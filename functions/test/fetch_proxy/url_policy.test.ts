import { describe, expect, it } from 'vitest';

import { FetchFailure } from '../../src/fetch_proxy/fetch_failure.js';
import {
  maxUrlLength,
  parsePublicUrl,
} from '../../src/fetch_proxy/url_policy.js';

const reasonFor = (raw: string): string | undefined => {
  try {
    parsePublicUrl(raw);
    return undefined;
  } catch (error) {
    return error instanceof FetchFailure ? error.reason : 'other';
  }
};

describe('parsePublicUrl', () => {
  it.each([
    'https://www.example.com/recipes/pancakes',
    'http://example.com/',
    'https://example.com:443/a',
    'http://example.com:80/a',
    'http://8.8.8.8/',
  ])('accepts %s', (raw) => {
    expect(parsePublicUrl(raw).href).toBe(new URL(raw).href);
  });

  it('resolves a relative redirect against the base', () => {
    const url = parsePublicUrl('/b', new URL('https://example.com/a'));

    expect(url.href).toBe('https://example.com/b');
  });

  it.each([
    ['not a url', 'invalidUrl'],
    ['ftp://example.com/', 'invalidUrl'],
    ['file:///etc/passwd', 'invalidUrl'],
    ['https://user:pass@example.com/', 'invalidUrl'],
    ['https://example.com:8080/', 'invalidUrl'],
    [`https://example.com/${'a'.repeat(maxUrlLength)}`, 'invalidUrl'],
    ['http://127.0.0.1/', 'blockedAddress'],
    ['http://169.254.169.254/computeMetadata/v1/', 'blockedAddress'],
    ['http://[::1]/', 'blockedAddress'],
    ['http://0x7f000001/', 'blockedAddress'],
  ])('refuses %s', (raw, reason) => {
    expect(reasonFor(raw)).toBe(reason);
  });
});
