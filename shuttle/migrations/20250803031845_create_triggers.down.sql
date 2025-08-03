
-- down.sql
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
DROP TRIGGER IF EXISTS update_categories_updated_at ON categories;
DROP TRIGGER IF EXISTS update_posts_updated_at ON posts;
DROP TRIGGER IF EXISTS update_pages_updated_at ON pages;
DROP TRIGGER IF EXISTS update_metadata_updated_at ON metadata;
DROP TRIGGER IF EXISTS update_comments_updated_at ON comments;
DROP FUNCTION IF EXISTS update_updated_at_column();