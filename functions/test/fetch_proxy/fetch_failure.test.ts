import { HttpsError } from 'firebase-functions/v2/https';
import { describe, expect, it } from 'vitest';

import {
  FetchFailure,
  toHttpsError,
} from '../../src/fetch_proxy/fetch_failure.js';

describe('toHttpsError', () => {
  it('sends the reason and status in the details', () => {
    const error = toHttpsError(
      new FetchFailure('upstreamStatus', 'The site answered 403', 403),
    );

    expect(error).toBeInstanceOf(HttpsError);
    expect(error.code).toBe('failed-precondition');
    expect(error.message).toBe('The site answered 403');
    expect(error.details).toEqual({ reason: 'upstreamStatus', status: 403 });
  });

  it.each([
    ['invalidUrl', 'invalid-argument'],
    ['blockedAddress', 'permission-denied'],
    ['tooLarge', 'out-of-range'],
    ['timeout', 'deadline-exceeded'],
    ['network', 'unavailable'],
  ] as const)('maps %s to %s', (reason, code) => {
    expect(toHttpsError(new FetchFailure(reason, '')).code).toBe(code);
  });
});
