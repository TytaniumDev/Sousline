import { type Dispatcher, fetch, type Response } from 'undici';

import { parseContentType } from './content_type.js';
import { FetchFailure } from './fetch_failure.js';
import { readLimitedText } from './read_body.js';
import { parsePublicUrl } from './url_policy.js';

/** Limits on one page fetch. */
export interface FetchLimits {
  /** Largest body accepted, in bytes. */
  readonly maxBytes: number;
  /** Redirects followed before giving up. */
  readonly maxRedirects: number;
  /** Time allowed for the whole fetch, redirects included. */
  readonly timeoutMs: number;
}

/** The limits the deployed proxy uses. */
export const defaultLimits: FetchLimits = {
  maxBytes: 5 * 1024 * 1024,
  maxRedirects: 5,
  timeoutMs: 10_000,
};

/** Media types the proxy returns. Recipe pages are HTML. */
export const allowedMediaTypes: ReadonlySet<string> = new Set([
  'text/html',
  'application/xhtml+xml',
]);

/** Identifies the proxy to sites, with a link to the project. */
export const userAgent =
  'Sousvite/1.0 (recipe import; +https://github.com/TytaniumDev/Sousvite)';

/** A fetched page, ready for the app's importer to parse. */
export interface FetchedPage {
  /** The final URL, after redirects. Relative links resolve against it. */
  readonly url: string;
  /** The page's media type, such as `text/html`. */
  readonly contentType: string;
  /** The decoded page. */
  readonly body: string;
}

const redirectStatuses = new Set([301, 302, 303, 307, 308]);

const isAbort = (error: unknown): boolean =>
  error instanceof DOMException &&
  (error.name === 'TimeoutError' || error.name === 'AbortError');

/** Finds a FetchFailure thrown inside undici, which wraps it in `cause`. */
const toFetchFailure = (error: unknown): FetchFailure => {
  for (let e = error; e instanceof Error; e = e.cause) {
    if (e instanceof FetchFailure) {
      return e;
    }
    if (isAbort(e)) {
      return new FetchFailure('timeout', 'The site took too long to respond');
    }
  }
  return new FetchFailure('network', 'Could not reach the site');
};

const request = async (
  url: URL,
  dispatcher: Dispatcher,
  signal: AbortSignal,
): Promise<Response> => {
  try {
    return await fetch(url, {
      dispatcher,
      signal,
      redirect: 'manual',
      headers: {
        accept: 'text/html,application/xhtml+xml;q=0.9,*/*;q=0.1',
        'user-agent': userAgent,
      },
    });
  } catch (error) {
    throw toFetchFailure(error);
  }
};

/** Follows redirects by hand, so every hop passes the URL policy. */
const followRedirects = async (
  start: URL,
  dispatcher: Dispatcher,
  limits: FetchLimits,
  signal: AbortSignal,
): Promise<{ url: URL; response: Response }> => {
  let url = start;
  for (let hop = 0; ; hop++) {
    const response = await request(url, dispatcher, signal);
    const location = response.headers.get('location');
    if (!redirectStatuses.has(response.status) || location === null) {
      return { url, response };
    }
    await response.body?.cancel();
    if (hop >= limits.maxRedirects) {
      throw new FetchFailure('tooManyRedirects', 'Too many redirects');
    }
    url = parsePublicUrl(location, url);
  }
};

/**
 * Fetches the page at [rawUrl] through [dispatcher], within [limits].
 * Throws a FetchFailure saying why when the page can't be returned.
 */
export const fetchPage = async (
  rawUrl: string,
  dispatcher: Dispatcher,
  limits: FetchLimits = defaultLimits,
): Promise<FetchedPage> => {
  const signal = AbortSignal.timeout(limits.timeoutMs);
  const { url, response } = await followRedirects(
    parsePublicUrl(rawUrl),
    dispatcher,
    limits,
    signal,
  );
  if (!response.ok) {
    await response.body?.cancel();
    throw new FetchFailure(
      'upstreamStatus',
      `The site answered ${String(response.status)}`,
      response.status,
    );
  }
  const { mediaType, charset } = parseContentType(
    response.headers.get('content-type'),
  );
  if (!allowedMediaTypes.has(mediaType)) {
    await response.body?.cancel();
    throw new FetchFailure(
      'unsupportedContentType',
      `Not a web page (${mediaType || 'no content type'})`,
    );
  }
  const declaredLength = Number(response.headers.get('content-length'));
  if (declaredLength > limits.maxBytes) {
    await response.body?.cancel();
    throw new FetchFailure(
      'tooLarge',
      `Page is over ${String(limits.maxBytes)} bytes`,
    );
  }
  try {
    const body = await readLimitedText(response.body, limits.maxBytes, charset);
    return { url: url.href, contentType: mediaType, body };
  } catch (error) {
    throw toFetchFailure(error);
  }
};
