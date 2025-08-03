-- Migration 009: Create media table
-- up.sql
CREATE TABLE media (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    filename VARCHAR(255) NOT NULL,
    original_filename VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    file_size BIGINT NOT NULL, -- Size in bytes
    width INTEGER, -- For images
    height INTEGER, -- For images
    alt_text TEXT,
    caption TEXT,
    description TEXT,
    uploaded_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    is_featured BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_media_uploaded_by ON media(uploaded_by);
CREATE INDEX idx_media_mime_type ON media(mime_type);
CREATE INDEX idx_media_created_at ON media(created_at);
CREATE INDEX idx_media_filename ON media(filename);

-- Add trigger for automatic updated_at timestamp
CREATE TRIGGER update_media_updated_at 
    BEFORE UPDATE ON media 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();