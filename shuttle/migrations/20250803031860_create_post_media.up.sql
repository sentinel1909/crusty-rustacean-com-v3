-- Migration 011: Create post_media junction table
-- up.sql
CREATE TABLE post_media (
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    media_id UUID NOT NULL REFERENCES media(id) ON DELETE CASCADE,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (post_id, media_id)
);

CREATE INDEX idx_post_media_post ON post_media(post_id);
CREATE INDEX idx_post_media_media ON post_media(media_id);
CREATE INDEX idx_post_media_order ON post_media(post_id, display_order);