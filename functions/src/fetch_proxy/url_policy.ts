import ipaddr from 'ipaddr.js';

import { isPublicAddress } from './address_policy.js';
import { FetchFailure } from './fetch_failure.js';

/** The longest URL the proxy accepts. */
export const maxUrlLength = 2048;

const allowedProtocols = new Set(['http:', 'https:']);

// An empty port is the default for the protocol.
const allowedPorts = new Set(['', '80', '443']);

/**
 * Parses [raw], resolved against [base] for redirects, and checks it is a
 * plain web address: http or https, the default ports, no credentials, and
 * no IP address that isn't public. Hostnames are checked again when they
 * resolve (see `publicOnlyLookup`).
 */
export const parsePublicUrl = (raw: string, base?: URL): URL => {
  if (raw.length > maxUrlLength) {
    throw new FetchFailure('invalidUrl', 'URL is too long');
  }
  const url = URL.parse(raw, base?.href);
  if (url === null) {
    throw new FetchFailure('invalidUrl', 'Not a URL');
  }
  if (!allowedProtocols.has(url.protocol)) {
    throw new FetchFailure(
      'invalidUrl',
      `Unsupported protocol ${url.protocol}`,
    );
  }
  if (url.username !== '' || url.password !== '') {
    throw new FetchFailure('invalidUrl', 'URLs with credentials are refused');
  }
  if (!allowedPorts.has(url.port)) {
    throw new FetchFailure('invalidUrl', `Unsupported port ${url.port}`);
  }
  // IPv6 hosts keep their brackets in URL.hostname.
  const host = url.hostname.replace(/^\[(.*)\]$/, '$1');
  if (ipaddr.isValid(host) && !isPublicAddress(host)) {
    throw new FetchFailure('blockedAddress', `${host} is not public`);
  }
  return url;
};
