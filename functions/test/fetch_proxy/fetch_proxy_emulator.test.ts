import { describe, expect, it } from 'vitest';

import { callFunction } from '../helpers/callable_client.js';

// These run against the deployed shape of the function in the emulator, so
// they cover App Check enforcement, which only the callable wrapper does.
describe('fetchProxy on the emulator', () => {
  it('rejects calls without App Check', async () => {
    const response = await callFunction(
      'fetchProxy',
      { url: 'https://example.com/' },
      { appCheck: false },
    );

    expect(response.status).toBe(401);
    expect(response.body).toMatchObject({
      error: { status: 'UNAUTHENTICATED' },
    });
  });

  it('accepts App Check and validates the request', async () => {
    const response = await callFunction(
      'fetchProxy',
      { url: 'not a url' },
      { appCheck: true },
    );

    expect(response.status).toBe(400);
    expect(response.body).toMatchObject({
      error: { status: 'INVALID_ARGUMENT', details: { reason: 'invalidUrl' } },
    });
  });

  it('refuses hosts that resolve to private addresses', async () => {
    const response = await callFunction(
      'fetchProxy',
      { url: 'http://localhost/' },
      { appCheck: true },
    );

    expect(response.status).toBe(403);
    expect(response.body).toMatchObject({
      error: {
        status: 'PERMISSION_DENIED',
        details: { reason: 'blockedAddress' },
      },
    });
  });
});
