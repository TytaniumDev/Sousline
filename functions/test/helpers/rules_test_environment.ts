import { readFileSync } from 'node:fs';

import {
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from '@firebase/rules-unit-testing';

/** The emulator-only project id. Never a real project (BUILD_PLAN.md BE-0). */
export const demoProjectId = 'demo-sousvite';

const readRules = (fileName: string): string =>
  readFileSync(new URL(`../../../${fileName}`, import.meta.url), 'utf8');

/**
 * Starts a rules test environment against the running emulators, loaded with
 * the repository's firestore.rules and storage.rules. Emulator hosts come from
 * the environment that `firebase emulators:exec` sets.
 */
export const rulesTestEnvironment = (): Promise<RulesTestEnvironment> =>
  initializeTestEnvironment({
    projectId: demoProjectId,
    firestore: { rules: readRules('firestore.rules') },
    storage: { rules: readRules('storage.rules') },
  });
