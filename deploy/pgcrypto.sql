-- Deploy flipr:pgcrypto to pg

BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

COMMIT;
