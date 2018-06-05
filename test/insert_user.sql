SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
SELECT plan(11);
SET search_path TO flipr,public;

SELECT has_function('insert_user');
SELECT has_function('insert_user', ARRAY['text', 'text']);
SELECT function_lang_is('insert_user', ARRAY['text', 'text'], 'sql');
SELECT function_returns('insert_user', ARRAY['text', 'text'], 'void');
SELECT volatility_is('insert_user', ARRAY['text', 'text'], 'volatile');
SELECT lives_ok($$ SELECT insert_user('evgenys', 'foo') $$, 'Insert user');
SELECT row_eq(
  'SELECT * FROM users', 
  ROW('evgenys', md5('foo'), NOW())::users,
  'The user should have been inserted'
);
SELECT lives_ok($$ SELECT insert_user('islas', 'bar') $$, 'Insert user');
SELECT bag_eq(
  'SELECT * FROM users',
  $$ VALUES
    ('evgenys', md5('foo'), NOW()),
    ('islas', md5('bar'), NOW())
  $$,
  'Both users should be present'
);
SELECT throws_ok(
  $$ SELECT insert_user('evgenys', 'fooo') $$,
  23505,
  NULL,
  'Should get an error for dublicate nickname'
);
SELECT bag_eq(
  'SELECT * FROM users',
  $$ VALUES
    ('evgenys', md5('foo'), NOW()),
    ('islas', md5('bar'), NOW())
  $$,
  'Should still have just the two users'
);

SELECT finish();
ROLLBACK;
