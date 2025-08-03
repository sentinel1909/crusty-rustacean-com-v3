-- down.sql
DROP TRIGGER IF EXISTS update_media_updated_at ON media;
DROP TABLE IF EXISTS media CASCADE;