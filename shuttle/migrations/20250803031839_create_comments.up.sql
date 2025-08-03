-- Migration 009: Create comments table
-- up.sql
CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
    page_id UUID REFERENCES pages(id) ON DELETE CASCADE,
    parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
    author_name VARCHAR(100) NOT NULL,
    author_email VARCHAR(255) NOT NULL,
    author_url VARCHAR(500),
    author_fingerprint VARCHAR(64), -- Hashed IP for privacy/security
    user_agent TEXT,
    content TEXT NOT NULL,
    status comment_moderation_status NOT NULL DEFAULT 'pending',
    user_id UUID REFERENCES users(id) ON DELETE SET NULL, -- For registered users
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT comments_content_check CHECK (
        (post_id IS NOT NULL AND page_id IS NULL) OR 
        (post_id IS NULL AND page_id IS NOT NULL)
    )
);

CREATE INDEX idx_comments_post ON comments(post_id);
CREATE INDEX idx_comments_page ON comments(page_id);
CREATE INDEX idx_comments_parent ON comments(parent_id);
CREATE INDEX idx_comments_status ON comments(status);
CREATE INDEX idx_comments_created_at ON comments(created_at);
CREATE INDEX idx_comments_author_email ON comments(author_email);
CREATE INDEX idx_comments_fingerprint ON comments(author_fingerprint) WHERE author_fingerprint IS NOT NULL;

-- Compound indexes for better query performance
CREATE INDEX idx_comments_status_created_at ON comments(status, created_at);
CREATE INDEX idx_comments_post_status ON comments(post_id, status);
CREATE INDEX idx_comments_page_status ON comments(page_id, status);
