import {
  assertFails,
  type RulesTestEnvironment,
} from '@firebase/rules-unit-testing';
import { getBytes, ref, uploadString } from 'firebase/storage';
import { afterAll, beforeAll, beforeEach, describe, it } from 'vitest';

import { rulesTestEnvironment } from '../helpers/rules_test_environment.js';

describe('storage.rules', () => {
  let testEnv: RulesTestEnvironment;

  beforeAll(async () => {
    testEnv = await rulesTestEnvironment();
  });

  beforeEach(async () => {
    await testEnv.clearStorage();
  });

  afterAll(async () => {
    await testEnv.cleanup();
  });

  describe('signed out', () => {
    it('denies reads', async () => {
      const storage = testEnv.unauthenticatedContext().storage();
      await assertFails(getBytes(ref(storage, 'anything/photo.jpg')));
    });

    it('denies writes', async () => {
      const storage = testEnv.unauthenticatedContext().storage();
      await assertFails(uploadString(ref(storage, 'anything/photo.jpg'), 'x'));
    });
  });

  describe('signed in', () => {
    it('denies reads', async () => {
      const storage = testEnv.authenticatedContext('alice').storage();
      await assertFails(getBytes(ref(storage, 'users/alice/photo.jpg')));
    });

    it('denies writes', async () => {
      const storage = testEnv.authenticatedContext('alice').storage();
      await assertFails(
        uploadString(ref(storage, 'users/alice/photo.jpg'), 'x'),
      );
    });
  });
});
