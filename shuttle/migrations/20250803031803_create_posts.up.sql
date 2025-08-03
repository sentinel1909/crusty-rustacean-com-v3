-- Migration 004: Create posts table
-- up.sql
CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    content JSONB NOT NULL,
    excerpt TEXT,
    featured_image_url VARCHAR(500),
    author_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status content_status NOT NULL DEFAULT 'draft',
    password VARCHAR(255), -- For password-protected posts
    comment_status comment_status NOT NULL DEFAULT 'open',
    is_featured BOOLEAN NOT NULL DEFAULT false,
    view_count INTEGER NOT NULL DEFAULT 0,
    -- SEO fields
    meta_title VARCHAR(255),
    meta_description TEXT,
    meta_keywords TEXT,
    canonical_url VARCHAR(500),
    -- Social media fields
    og_title VARCHAR(255),
    og_description TEXT,
    og_image VARCHAR(500),
    twitter_title VARCHAR(255),
    twitter_description TEXT,
    twitter_image VARCHAR(500),
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_posts_slug ON posts(slug);
CREATE INDEX idx_posts_author ON posts(author_id);
CREATE INDEX idx_posts_status ON posts(status);
CREATE INDEX idx_posts_published_at ON posts(published_at);
CREATE INDEX idx_posts_created_at ON posts(created_at);
CREATE INDEX idx_posts_featured ON posts(is_featured) WHERE is_featured = true;

-- Compound indexes for better query performance
CREATE INDEX idx_posts_status_published_at ON posts(status, published_at) WHERE status = 'published';
CREATE INDEX idx_posts_author_status ON posts(author_id, status);
CREATE INDEX idx_posts_status_created_at ON posts(status, created_at);
