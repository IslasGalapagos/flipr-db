-- Deploy flipr:change_pass to pg
-- requires: appschema
-- requires: users

BEGIN;

CREATE OR REPLACE FUNCTION flipr.change_pass(
  nick TEXT,
  old_password TEXT,
  new_password TEXT
) RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE flipr.users
    SET password = crypt($3, password)
    WHERE nickname = $1
      AND password = crypt($2, password);
  RETURN FOUND;
END;
$$;

COMMIT;
