import { describe, expect, it } from 'vitest';

import { FetchFailure } from '../../src/fetch_proxy/fetch_failure.js';
import { readLimitedText } from '../../src/fetch_proxy/read_body.js';

// eslint-disable-next-line @typescript-eslint/require-await -- an async generator stands in for a response body stream.
async function* chunks(...parts: Uint8Array[]): AsyncGenerator<Uint8Array> {
  yield* parts;
}

const utf8 = (text: string): Uint8Array => new TextEncoder().encode(text);

describe('readLimitedText', () => {
  it('decodes UTF-8 split across chunks', async () => {
    const bytes = utf8('crème brûlée');

    const text = await readLimitedText(
      chunks(bytes.slice(0, 3), bytes.slice(3)),
      100,
    );

    expect(text).toBe('crème brûlée');
  });

  it('decodes the given charset', async () => {
    const latin1 = Uint8Array.from([0x63, 0x72, 0xe8, 0x6d, 0x65]);

    expect(await readLimitedText(chunks(latin1), 100, 'iso-8859-1')).toBe(
      'crème',
    );
  });

  it('falls back to UTF-8 for an unknown charset', async () => {
    expect(await readLimitedText(chunks(utf8('é')), 100, 'nonsense')).toBe('é');
  });

  it('reads a missing body as empty', async () => {
    expect(await readLimitedText(null, 100)).toBe('');
  });

  it('fails once the body passes the limit', async () => {
    const read = readLimitedText(chunks(utf8('abc'), utf8('def')), 5);

    await expect(read).rejects.toBeInstanceOf(FetchFailure);
    await expect(read).rejects.toMatchObject({ reason: 'tooLarge' });
  });
});
