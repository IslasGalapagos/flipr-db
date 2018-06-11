SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
SELECT plan(9);
SET search_path TO flipr,public;

SELECT has_function('change_pass');
SELECT has_function('change_pass', ARRAY['text', 'text', 'text']);
SELECT function_lang_is('change_pass', ARRAY['text', 'text', 'text'], 'plpgsql');
SELECT function_returns('change_pass', ARRAY['text', 'text', 'text'], 'boolean');
SELECT volatility_is('change_pass', ARRAY['text', 'text', 'text'], 'volatile');

SELECT insert_user('evgenys', 'foo');

SELECT ok(
  change_pass('evgenys', 'foo', 'bar'),
  'Change password'
);
SELECT ok(
  EXISTS(
    SELECT 1 FROM flipr.users
      WHERE nickname = 'evgenys'
        AND password = crypt('bar', password)
  ),
  'The password should have been changed'
);
SELECT ok(
  NOT change_pass('evgenys', 'foo', 'bar'),
  'Should get an error for wrong old password'
);
SELECT ok(
  EXISTS(
    SELECT 1 FROM flipr.users
      WHERE nickname = 'evgenys'
        AND password = crypt('bar', password)
  ),
  'The password should be unchanged'
);

SELECT finish();
ROLLBACK;