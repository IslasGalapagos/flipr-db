-- Deploy flipr:insert_user to pg
-- requires: appschema
-- requires: users

BEGIN;

CREATE OR REPLACE FUNCTION flipr.insert_user(
  nickname TEXT,
  password TEXT
) RETURNS VOID LANGUAGE SQL SECURITY DEFINER AS $$
  INSERT INTO flipr.users VALUES ($1, crypt($2, gen_salt('md5')));
$$;

COMMIT;
