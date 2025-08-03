-- Migration 010: Create revisions table
-- up.sql
CREATE TABLE revisions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type entity_type NOT NULL CHECK (entity_type IN ('post', 'page')),
    entity_id UUID NOT NULL,
    title VARCHAR(255) NOT NULL,
    content JSONB NOT NULL,
    excerpt TEXT,
    author_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    revision_note TEXT, -- Optional note about what changed
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_revisions_entity ON revisions(entity_type, entity_id);
CREATE INDEX idx_revisions_created_at ON revisions(created_at);
CREATE INDEX idx_revisions_author ON revisions(author_id);