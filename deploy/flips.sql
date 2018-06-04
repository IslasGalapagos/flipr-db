-- Deploy flipr:flips to pg
-- requires: appschema

BEGIN;

SET client_min_messages TO warning;
CREATE TABLE flipr.flips (
  flip_id SERIAL PRIMARY KEY,
  nickname TEXT REFERENCES flipr.users,
  body TEXT,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMIT;
