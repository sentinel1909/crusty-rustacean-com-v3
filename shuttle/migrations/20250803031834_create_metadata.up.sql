-- Migration 008: Create metadata table
-- up.sql
CREATE TABLE metadata (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type entity_type NOT NULL,
    entity_id UUID NOT NULL,
    meta_key VARCHAR(255) NOT NULL,
    meta_value TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(entity_type, entity_id, meta_key)
);

CREATE INDEX idx_metadata_entity ON metadata(entity_type, entity_id);
CREATE INDEX idx_metadata_key ON metadata(meta_key);

-- Compound indexes for better query performance  
-- Note: UNIQUE constraint on (entity_type, entity_id, meta_key) already provides an index
CREATE INDEX idx_metadata_key_value ON metadata(meta_key, meta_value) WHERE meta_value IS NOT NULL;
