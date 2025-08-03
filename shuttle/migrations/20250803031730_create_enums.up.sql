-- Migration 000: Create enum types
-- up.sql

-- User role enum
CREATE TYPE user_role AS ENUM (
    'admin', 
    'editor', 
    'author', 
    'contributor', 
    'subscriber'
);

-- Content status enum (used by posts and pages)
CREATE TYPE content_status AS ENUM (
    'draft', 
    'published', 
    'private', 
    'trash'
);

-- Comment status enum (used by posts and pages)
CREATE TYPE comment_status AS ENUM (
    'open', 
    'closed', 
    'moderated'
);

-- Comment moderation status enum
CREATE TYPE comment_moderation_status AS ENUM (
    'approved', 
    'pending', 
    'spam', 
    'trash'
);

-- Entity type enum for metadata
CREATE TYPE entity_type AS ENUM (
    'post', 
    'page', 
    'user', 
    'category', 
    'tag'
);