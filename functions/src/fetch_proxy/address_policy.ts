import { lookup, type LookupAddress } from 'node:dns';
import type { LookupFunction } from 'node:net';

import ipaddr from 'ipaddr.js';

import { FetchFailure } from './fetch_failure.js';

/**
 * Whether [address] is a public internet address. Loopback, private,
 * link-local (including the metadata server), and every other special range
 * are not, so the proxy can't be used to reach Google's internal network.
 */
export const isPublicAddress = (address: string): boolean =>
  ipaddr.isValid(address) && ipaddr.process(address).range() === 'unicast';

/**
 * A DNS lookup that fails when a host resolves to any address that isn't
 * public. It runs on every connection, including after redirects, so a host
 * can't pass a check and then resolve somewhere else (DNS rebinding).
 */
export const publicOnlyLookup: LookupFunction = (
  hostname,
  options,
  callback,
) => {
  lookup(hostname, { ...options, all: true }, (error, addresses) => {
    if (error) {
      callback(error, '');
      return;
    }
    if (!addresses.every(({ address }) => isPublicAddress(address))) {
      callback(
        new FetchFailure('blockedAddress', `${hostname} is not public`),
        '',
      );
      return;
    }
    if (options.all === true) {
      callback(null, addresses);
      return;
    }
    const [first] = addresses as [LookupAddress];
    callback(null, first.address, first.family);
  });
};
