-- Migration 005: Create pages table
-- up.sql
CREATE TABLE pages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    content JSONB NOT NULL,
    excerpt TEXT,
    featured_image_url VARCHAR(500),
    author_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status content_status NOT NULL DEFAULT 'draft',
    password VARCHAR(255), -- For password-protected pages
    comment_status comment_status NOT NULL DEFAULT 'closed',
    parent_id UUID REFERENCES pages(id) ON DELETE SET NULL,
    menu_order INTEGER NOT NULL DEFAULT 0,
    template VARCHAR(100), -- Custom template name
    is_homepage BOOLEAN NOT NULL DEFAULT false,
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

CREATE INDEX idx_pages_slug ON pages(slug);
CREATE INDEX idx_pages_author ON pages(author_id);
CREATE INDEX idx_pages_status ON pages(status);
CREATE INDEX idx_pages_parent ON pages(parent_id);
CREATE INDEX idx_pages_menu_order ON pages(menu_order);
CREATE UNIQUE INDEX idx_pages_homepage ON pages(is_homepage) WHERE is_homepage = true;

-- Compound indexes for better query performance
CREATE INDEX idx_pages_parent_menu_order ON pages(parent_id, menu_order);
CREATE INDEX idx_pages_status_created_at ON pages(status, created_at);
