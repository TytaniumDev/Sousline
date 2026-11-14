import { describe, expect, it } from 'vitest';

import { parseContentType } from '../../src/fetch_proxy/content_type.js';

describe('parseContentType', () => {
  it('reads the media type and charset', () => {
    expect(parseContentType('Text/HTML; Charset="ISO-8859-1"')).toEqual({
      mediaType: 'text/html',
      charset: 'ISO-8859-1',
    });
  });

  it('leaves the charset out when there is none', () => {
    expect(parseContentType('text/html')).toEqual({ mediaType: 'text/html' });
  });

  it('ignores other parameters', () => {
    expect(parseContentType('text/html; boundary=x')).toEqual({
      mediaType: 'text/html',
    });
  });

  it('treats a missing header as empty', () => {
    expect(parseContentType(null)).toEqual({ mediaType: '' });
  });
});
