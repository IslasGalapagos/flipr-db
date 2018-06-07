SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
SELECT no_plan();
SET search_path TO flipr,public;

SELECT ok(
  EXISTS(SELECT 1 FROM pg_extension WHERE extname = 'pgcrypto'),
  'pgcrypto should be loaded'
);
SELECT has_function('crypt', ARRAY['text', 'text']);
SELECT has_function('gen_salt', ARRAY['text']);

SELECT finish();
ROLLBACK;