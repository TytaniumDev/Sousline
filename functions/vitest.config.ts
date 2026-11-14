import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    include: ['test/**/*.test.ts'],
    // Rules and function tests share one set of emulators, so test files run
    // one at a time to keep them from clearing each other's data.
    fileParallelism: false,
    coverage: {
      provider: 'v8',
      include: ['src/**/*.ts'],
      // index.ts only sets global options and re-exports functions.
      exclude: ['src/index.ts'],
      reporter: ['text', 'lcov'],
      thresholds: { lines: 90, functions: 90, branches: 90, statements: 90 },
    },
  },
});
