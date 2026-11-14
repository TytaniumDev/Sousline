// Entry point for every Cloud Function. Each function lives in its own
// folder under src/ and is exported here with one line, in alphabetical
// order (BUILD_PLAN.md §3.2).
import { setGlobalOptions } from 'firebase-functions/v2';

// Same region as Cloud Storage. maxInstances caps cost if a client misbehaves.
setGlobalOptions({ region: 'us-central1', maxInstances: 10 });
