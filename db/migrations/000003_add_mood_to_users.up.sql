BEGIN;

CREATE TYPE enum_mood AS ENUM ('happy', 'sad', 'neutral');
ALTER TABLE person ADD COLUMN mood enum_mood;

COMMIT;
