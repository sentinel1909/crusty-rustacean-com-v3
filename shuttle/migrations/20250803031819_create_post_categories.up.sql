-- Migration 006: Create post_categories junction table
-- up.sql
CREATE TABLE post_categories (
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (post_id, category_id)
);

CREATE INDEX idx_post_categories_post ON post_categories(post_id);
CREATE INDEX idx_post_categories_category ON post_categories(category_id);
