import type { CallableRequest } from 'firebase-functions/v2/https';
import { HttpsError } from 'firebase-functions/v2/https';
import { MockAgent } from 'undici';
import { afterEach, beforeEach, describe, expect, it } from 'vitest';

import {
  fetchProxy,
  handleFetchProxy,
} from '../../src/fetch_proxy/fetch_proxy.js';

const requestWith = (data: unknown): CallableRequest<unknown> =>
  ({
    data,
    rawRequest: {},
    acceptsStreaming: false,
  }) as CallableRequest<unknown>;

describe('handleFetchProxy', () => {
  let agent: MockAgent;

  beforeEach(() => {
    agent = new MockAgent();
    agent.disableNetConnect();
  });

  afterEach(async () => {
    await agent.close();
  });

  it('returns the fetched page', async () => {
    agent
      .get('https://recipes.example')
      .intercept({ path: '/' })
      .reply(200, '<p>hi</p>', { headers: { 'content-type': 'text/html' } });

    const page = await handleFetchProxy(agent)(
      requestWith({ url: 'https://recipes.example/' }),
    );

    expect(page.body).toBe('<p>hi</p>');
  });

  it.each([undefined, null, 'https://recipes.example/', { url: 42 }])(
    'refuses %j as the request',
    async (data) => {
      await expect(
        handleFetchProxy(agent)(requestWith(data)),
      ).rejects.toMatchObject({
        code: 'invalid-argument',
        details: { reason: 'invalidUrl' },
      });
    },
  );

  it('sends fetch failures as HttpsErrors with a reason', async () => {
    agent
      .get('https://recipes.example')
      .intercept({ path: '/' })
      .reply(500, 'oops', { headers: { 'content-type': 'text/html' } });

    const call = handleFetchProxy(agent)(
      requestWith({ url: 'https://recipes.example/' }),
    );

    await expect(call).rejects.toBeInstanceOf(HttpsError);
    await expect(call).rejects.toMatchObject({
      details: { reason: 'upstreamStatus', status: 500 },
    });
  });

  it('reports a broken dispatcher as a network failure', async () => {
    const broken = {
      dispatch: () => {
        throw new Error('not a dispatcher');
      },
    } as unknown as MockAgent;

    await expect(
      handleFetchProxy(broken)(
        requestWith({ url: 'https://recipes.example/' }),
      ),
    ).rejects.toMatchObject({ details: { reason: 'network' } });
  });
});

describe('fetchProxy', () => {
  it('refuses private hosts with its real dispatcher', async () => {
    await expect(
      fetchProxy.run(requestWith({ url: 'http://localhost/' })),
    ).rejects.toMatchObject({ details: { reason: 'blockedAddress' } });
  });
});
