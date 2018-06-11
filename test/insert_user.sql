SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
SELECT plan(12);
SET search_path TO flipr,public;

SELECT has_function('insert_user');
SELECT has_function('insert_user', ARRAY['text', 'text']);
SELECT function_lang_is('insert_user', ARRAY['text', 'text'], 'sql');
SELECT function_returns('insert_user', ARRAY['text', 'text'], 'void');
SELECT volatility_is('insert_user', ARRAY['text', 'text'], 'volatile');
SELECT lives_ok($$ SELECT insert_user('evgenys', 'foo') $$, 'Insert user');
SELECT ok(
  EXISTS(
    SELECT 1 FROM flipr.users
      WHERE nickname = 'evgenys'
      AND password = crypt('foo', password)
  ),
  'The user should have been inserted'
);
SELECT lives_ok($$ SELECT insert_user('islas', 'bar') $$, 'Insert user');
SELECT is(count(*)::INT, 2, 'There should be two users') FROM flipr.users;
SELECT ok(
  EXISTS(
    SELECT 1 FROM flipr.users
      WHERE nickname = 'islas'
      AND password = crypt('bar', password)
  ),
  'The user should have been inserted'
);
SELECT throws_ok(
  $$ SELECT insert_user('evgenys', 'fooo') $$,
  23505,
  NULL,
  'Should get an error for dublicate nickname'
);
SELECT is(count(*)::INT, 2, 'There should be two users') FROM flipr.users;

SELECT finish();
ROLLBACK;
