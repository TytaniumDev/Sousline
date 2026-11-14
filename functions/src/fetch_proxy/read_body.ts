import { TextDecoder } from 'node:util';

import { FetchFailure } from './fetch_failure.js';

const decoderFor = (charset: string | undefined): TextDecoder => {
  try {
    return new TextDecoder(charset ?? 'utf-8');
  } catch {
    // An unknown charset label. Most pages are UTF-8, so try that.
    return new TextDecoder('utf-8');
  }
};

/**
 * Reads [body] as text in [charset], failing with `tooLarge` as soon as it
 * passes [maxBytes], so a huge page is never held in memory.
 */
export const readLimitedText = async (
  body: AsyncIterable<Uint8Array> | null,
  maxBytes: number,
  charset?: string,
): Promise<string> => {
  const decoder = decoderFor(charset);
  let text = '';
  let bytes = 0;
  for await (const chunk of body ?? []) {
    bytes += chunk.byteLength;
    if (bytes > maxBytes) {
      throw new FetchFailure(
        'tooLarge',
        `Page is over ${String(maxBytes)} bytes`,
      );
    }
    text += decoder.decode(chunk, { stream: true });
  }
  return text + decoder.decode();
};
