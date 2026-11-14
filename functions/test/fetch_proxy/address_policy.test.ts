import type { LookupAddress } from 'node:dns';

import { describe, expect, it } from 'vitest';

import {
  isPublicAddress,
  publicOnlyLookup,
} from '../../src/fetch_proxy/address_policy.js';
import { FetchFailure } from '../../src/fetch_proxy/fetch_failure.js';

interface LookupResult {
  error: NodeJS.ErrnoException | null;
  address: string | LookupAddress[];
  family?: number;
}

const lookup = (hostname: string, all: boolean): Promise<LookupResult> =>
  new Promise((resolve) => {
    publicOnlyLookup(hostname, { all }, (error, address, family) => {
      resolve({ error, address, ...(family === undefined ? {} : { family }) });
    });
  });

describe('isPublicAddress', () => {
  it.each(['8.8.8.8', '151.101.1.69', '2607:f8b0:4004:c07::64'])(
    'accepts %s',
    (address) => {
      expect(isPublicAddress(address)).toBe(true);
    },
  );

  it.each([
    '127.0.0.1',
    '10.0.0.1',
    '172.16.0.1',
    '192.168.1.1',
    '169.254.169.254',
    '100.64.0.1',
    '0.0.0.0',
    '224.0.0.1',
    '::1',
    '::ffff:127.0.0.1',
    'fd00::1',
    'fe80::1',
    '64:ff9b::a00:1',
    'not an address',
  ])('refuses %s', (address) => {
    expect(isPublicAddress(address)).toBe(false);
  });
});

describe('publicOnlyLookup', () => {
  it('resolves a public address', async () => {
    const result = await lookup('8.8.8.8', false);

    expect(result).toEqual({ error: null, address: '8.8.8.8', family: 4 });
  });

  it('returns every address when asked for all', async () => {
    const result = await lookup('8.8.8.8', true);

    expect(result.address).toEqual([{ address: '8.8.8.8', family: 4 }]);
  });

  it('refuses a host that resolves to loopback', async () => {
    const { error } = await lookup('localhost', false);

    expect(error).toBeInstanceOf(FetchFailure);
    expect((error as FetchFailure).reason).toBe('blockedAddress');
  });

  it('passes on resolution errors', async () => {
    const { error } = await lookup('no-such-host.invalid', false);

    expect(error).not.toBeNull();
    expect(error).not.toBeInstanceOf(FetchFailure);
  });
});
