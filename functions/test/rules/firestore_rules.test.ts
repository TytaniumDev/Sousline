import {
  assertFails,
  type RulesTestEnvironment,
} from '@firebase/rules-unit-testing';
import { doc, getDoc, setDoc } from 'firebase/firestore';
import { afterAll, beforeAll, beforeEach, describe, it } from 'vitest';

import { rulesTestEnvironment } from '../helpers/rules_test_environment.js';

describe('firestore.rules', () => {
  let testEnv: RulesTestEnvironment;

  beforeAll(async () => {
    testEnv = await rulesTestEnvironment();
  });

  beforeEach(async () => {
    await testEnv.clearFirestore();
  });

  afterAll(async () => {
    await testEnv.cleanup();
  });

  describe('signed out', () => {
    it('denies reads', async () => {
      const db = testEnv.unauthenticatedContext().firestore();
      await assertFails(getDoc(doc(db, 'anything/doc')));
    });

    it('denies writes', async () => {
      const db = testEnv.unauthenticatedContext().firestore();
      await assertFails(setDoc(doc(db, 'anything/doc'), { a: 1 }));
    });
  });

  describe('signed in', () => {
    it('denies reads', async () => {
      const db = testEnv.authenticatedContext('alice').firestore();
      await assertFails(getDoc(doc(db, 'users/alice')));
    });

    it('denies writes', async () => {
      const db = testEnv.authenticatedContext('alice').firestore();
      await assertFails(setDoc(doc(db, 'users/alice'), { a: 1 }));
    });
  });
});
