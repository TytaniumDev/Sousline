import { MockAgent } from 'undici';
import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import { FetchFailure } from '../../src/fetch_proxy/fetch_failure.js';
import {
  type FetchLimits,
  fetchPage,
  userAgent,
} from '../../src/fetch_proxy/fetch_page.js';

const origin = 'https://recipes.example';
const html = { 'content-type': 'text/html; charset=utf-8' };
const limits: FetchLimits = { maxBytes: 100, maxRedirects: 2, timeoutMs: 500 };

describe('fetchPage', () => {
  let agent: MockAgent;

  beforeEach(() => {
    agent = new MockAgent();
    agent.disableNetConnect();
  });

  afterEach(async () => {
    await agent.close();
  });

  const site = () => agent.get(origin);

  const failureOf = async (url: string): Promise<FetchFailure> => {
    try {
      await fetchPage(url, agent, limits);
    } catch (error) {
      if (error instanceof FetchFailure) {
        return error;
      }
      throw error;
    }
    throw new Error('Expected the fetch to fail');
  };

  it('returns the page', async () => {
    site().intercept({ path: '/pancakes' }).reply(200, '<h1>Pancakes</h1>', {
      headers: html,
    });

    const page = await fetchPage(`${origin}/pancakes`, agent, limits);

    expect(page).toEqual({
      url: `${origin}/pancakes`,
      contentType: 'text/html',
      body: '<h1>Pancakes</h1>',
    });
  });

  it('identifies itself and asks for HTML', async () => {
    site()
      .intercept({
        path: '/',
        headers: { 'user-agent': userAgent, accept: /text\/html/ },
      })
      .reply(200, 'ok', { headers: html });

    await expect(fetchPage(`${origin}/`, agent, limits)).resolves.toMatchObject(
      { body: 'ok' },
    );
  });

  it('follows redirects and returns the final URL', async () => {
    site()
      .intercept({ path: '/old' })
      .reply(301, '', { headers: { location: '/new' } });
    site().intercept({ path: '/new' }).reply(200, 'moved', { headers: html });

    const page = await fetchPage(`${origin}/old`, agent, limits);

    expect(page.url).toBe(`${origin}/new`);
    expect(page.body).toBe('moved');
  });

  it('refuses a redirect to a private address', async () => {
    site()
      .intercept({ path: '/' })
      .reply(302, '', { headers: { location: 'http://10.0.0.1/' } });

    expect((await failureOf(`${origin}/`)).reason).toBe('blockedAddress');
  });

  it('stops after too many redirects', async () => {
    site()
      .intercept({ path: '/loop' })
      .reply(302, '', { headers: { location: '/loop' } })
      .times(3);

    expect((await failureOf(`${origin}/loop`)).reason).toBe('tooManyRedirects');
  });

  it('refuses an invalid URL before fetching', async () => {
    expect((await failureOf('ftp://recipes.example/')).reason).toBe(
      'invalidUrl',
    );
  });

  it('reports the status of an error page', async () => {
    site().intercept({ path: '/gone' }).reply(404, 'nope', { headers: html });

    const failure = await failureOf(`${origin}/gone`);

    expect(failure.reason).toBe('upstreamStatus');
    expect(failure.status).toBe(404);
  });

  it('refuses a response that is not a web page', async () => {
    site()
      .intercept({ path: '/menu.pdf' })
      .reply(200, '%PDF', { headers: { 'content-type': 'application/pdf' } });

    expect((await failureOf(`${origin}/menu.pdf`)).reason).toBe(
      'unsupportedContentType',
    );
  });

  it('refuses a response with no content type', async () => {
    site().intercept({ path: '/' }).reply(200, 'hi');

    expect((await failureOf(`${origin}/`)).reason).toBe(
      'unsupportedContentType',
    );
  });

  it('refuses a page whose declared length is over the limit', async () => {
    site()
      .intercept({ path: '/' })
      .reply(200, 'x', { headers: { ...html, 'content-length': '101' } });

    expect((await failureOf(`${origin}/`)).reason).toBe('tooLarge');
  });

  it('refuses a page whose body is over the limit', async () => {
    site()
      .intercept({ path: '/' })
      .reply(200, 'x'.repeat(101), { headers: html });

    expect((await failureOf(`${origin}/`)).reason).toBe('tooLarge');
  });

  it('times out on a slow site', async () => {
    site()
      .intercept({ path: '/' })
      .reply(200, 'slow', { headers: html })
      .delay(limits.timeoutMs * 2);

    expect((await failureOf(`${origin}/`)).reason).toBe('timeout');
  });

  it('reports a network error', async () => {
    site()
      .intercept({ path: '/' })
      .replyWithError(new Error('connection reset'));

    expect((await failureOf(`${origin}/`)).reason).toBe('network');
  });
});
