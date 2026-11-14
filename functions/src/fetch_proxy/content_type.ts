/** A parsed `Content-Type` header. */
export interface ContentType {
  /** The lowercase media type, such as `text/html`. */
  readonly mediaType: string;
  /** The `charset` parameter, if the header has one. */
  readonly charset?: string;
}

/** Parses a `Content-Type` header value. A missing header gives `''`. */
export const parseContentType = (header: string | null): ContentType => {
  const [mediaType = '', ...parameters] = (header ?? '').split(';');
  const charset = parameters
    .map((parameter) => parameter.trim().split('='))
    .find(([name]) => name?.toLowerCase() === 'charset')?.[1]
    ?.replace(/^"(.*)"$/, '$1');
  return {
    mediaType: mediaType.trim().toLowerCase(),
    ...(charset === undefined ? {} : { charset }),
  };
};
