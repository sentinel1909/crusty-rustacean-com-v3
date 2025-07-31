-- Drop all tables in reverse order - 2025 06 30

DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS blogposts;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS blogpost_images;
ALTER TABLE blogposts DROP COLUMN IF EXISTS featured_image_url; 