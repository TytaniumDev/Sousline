import {
  type FunctionsErrorCode,
  HttpsError,
} from 'firebase-functions/v2/https';

/**
 * Why a page couldn't be fetched. The app reads it from the error's
 * `details.reason`, so import can report failures by site (PRD §10).
 */
export type FetchFailureReason =
  | 'invalidUrl'
  | 'blockedAddress'
  | 'tooManyRedirects'
  | 'upstreamStatus'
  | 'unsupportedContentType'
  | 'tooLarge'
  | 'timeout'
  | 'network';

/** A page fetch that failed for a known [reason]. */
export class FetchFailure extends Error {
  constructor(
    /** Why the fetch failed. */
    readonly reason: FetchFailureReason,
    message: string,
    /** The upstream HTTP status, for `upstreamStatus`. */
    readonly status?: number,
  ) {
    super(message);
    this.name = 'FetchFailure';
  }
}

const errorCodes: Record<FetchFailureReason, FunctionsErrorCode> = {
  invalidUrl: 'invalid-argument',
  blockedAddress: 'permission-denied',
  tooManyRedirects: 'failed-precondition',
  upstreamStatus: 'failed-precondition',
  unsupportedContentType: 'failed-precondition',
  tooLarge: 'out-of-range',
  timeout: 'deadline-exceeded',
  network: 'unavailable',
};

/** Converts [failure] to the error a callable function sends the client. */
export const toHttpsError = (failure: FetchFailure): HttpsError =>
  new HttpsError(errorCodes[failure.reason], failure.message, {
    reason: failure.reason,
    status: failure.status,
  });
