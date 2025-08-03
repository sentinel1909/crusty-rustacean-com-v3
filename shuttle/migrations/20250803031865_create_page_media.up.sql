-- Migration 012: Create page_media junction table
-- up.sql
CREATE TABLE page_media (
    page_id UUID NOT NULL REFERENCES pages(id) ON DELETE CASCADE,
    media_id UUID NOT NULL REFERENCES media(id) ON DELETE CASCADE,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (page_id, media_id)
);

CREATE INDEX idx_page_media_page ON page_media(page_id);
CREATE INDEX idx_page_media_media ON page_media(media_id);
CREATE INDEX idx_page_media_order ON page_media(page_id, display_order);