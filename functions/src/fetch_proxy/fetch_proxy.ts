import { logger } from 'firebase-functions/v2';
import {
  type CallableRequest,
  HttpsError,
  onCall,
} from 'firebase-functions/v2/https';
import { Agent, type Dispatcher } from 'undici';

import { publicOnlyLookup } from './address_policy.js';
import { FetchFailure, toHttpsError } from './fetch_failure.js';
import { type FetchedPage, type FetchLimits, fetchPage } from './fetch_page.js';

/** What the app sends: the page to fetch. */
export interface FetchProxyRequest {
  readonly url: string;
}

const isFetchProxyRequest = (data: unknown): data is FetchProxyRequest =>
  typeof data === 'object' &&
  data !== null &&
  typeof (data as { url?: unknown }).url === 'string';

/**
 * Handles one proxy call with [dispatcher]. Separate from the function so
 * tests can pass a mock dispatcher.
 */
export const handleFetchProxy =
  (dispatcher: Dispatcher, limits?: FetchLimits) =>
  async (request: CallableRequest<unknown>): Promise<FetchedPage> => {
    if (!isFetchProxyRequest(request.data)) {
      throw new HttpsError('invalid-argument', 'Expected { url: string }', {
        reason: 'invalidUrl',
      });
    }
    try {
      return await fetchPage(request.data.url, dispatcher, limits);
    } catch (error) {
      if (!(error instanceof FetchFailure)) {
        throw error;
      }
      logger.warn('Fetch proxy failed', {
        reason: error.reason,
        status: error.status,
        host: URL.parse(request.data.url)?.hostname,
      });
      throw toHttpsError(error);
    }
  };

// Every connection resolves through publicOnlyLookup, so the proxy can only
// reach public addresses.
const publicAgent = new Agent({ connect: { lookup: publicOnlyLookup } });

/**
 * Fetches a recipe page for web URL import, where browsers block
 * cross-site requests (ENGINEERING.md §14). The app parses the HTML.
 * App Check limits callers to our apps.
 */
export const fetchProxy = onCall(
  { enforceAppCheck: true, timeoutSeconds: 30 },
  handleFetchProxy(publicAgent),
);
