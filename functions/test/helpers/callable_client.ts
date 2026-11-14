import { demoProjectId } from './rules_test_environment.js';

/** The HTTP status and JSON body of a callable function's response. */
export interface CallableResponse {
  readonly status: number;
  readonly body: unknown;
}

interface EmulatorInfo {
  readonly host: string;
  readonly port: number;
}

/** Asks the emulator hub, which `firebase emulators:exec` starts, where the functions emulator is. */
const functionsEmulatorOrigin = async (): Promise<string> => {
  const hub = process.env.FIREBASE_EMULATOR_HUB;
  if (hub === undefined) {
    throw new Error('Run tests with `npm test`, which starts the emulators');
  }
  const response = await fetch(`http://${hub}/emulators`);
  const { functions } = (await response.json()) as {
    functions: EmulatorInfo;
  };
  return `http://${functions.host}:${String(functions.port)}`;
};

const base64Url = (value: object): string =>
  Buffer.from(JSON.stringify(value)).toString('base64url');

/**
 * An unsigned App Check token. The functions emulator decodes App Check
 * tokens without verifying them, so this passes `enforceAppCheck` there and
 * nowhere else.
 */
export const fakeAppCheckToken = (): string =>
  [
    base64Url({ alg: 'none', typ: 'JWT' }),
    base64Url({ sub: '1:000000000000:web:fake', iss: 'test' }),
    '',
  ].join('.');

/**
 * Calls the callable function [name] on the emulator with [data], using the
 * callable protocol directly so tests can leave the App Check token out.
 */
export const callFunction = async (
  name: string,
  data: unknown,
  { appCheck }: { appCheck: boolean },
): Promise<CallableResponse> => {
  const origin = await functionsEmulatorOrigin();
  const response = await fetch(
    `${origin}/${demoProjectId}/us-central1/${name}`,
    {
      method: 'POST',
      headers: {
        'content-type': 'application/json',
        ...(appCheck ? { 'x-firebase-appcheck': fakeAppCheckToken() } : {}),
      },
      body: JSON.stringify({ data }),
    },
  );
  return { status: response.status, body: await response.json() };
};
