-- Initial schema migration - 2025 06 30

-- Create users table (must come first since blogposts references it)
CREATE TABLE users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(32) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create blogposts table with user association
CREATE TABLE blogposts (
    id UUID NOT NULL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    draft BOOLEAN NOT NULL DEFAULT true,
    slug TEXT NOT NULL UNIQUE,
    categories TEXT[],
    tags TEXT[],
    word_count INTEGER,
    reading_time INTEGER,
    featured_image_url TEXT
);

-- Create sessions table
CREATE TABLE sessions (
    id VARCHAR(255) PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- Add indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_expires_at ON sessions(expires_at);
CREATE INDEX idx_blogposts_slug ON blogposts(slug);
CREATE INDEX idx_blogposts_created_at ON blogposts(created_at);
CREATE INDEX idx_blogposts_user_id ON blogposts(user_id);

-- Table for inline images in blog posts
CREATE TABLE blogpost_images (
    id UUID PRIMARY KEY,
    blogpost_id UUID NOT NULL REFERENCES blogposts(id) ON DELETE CASCADE,
    url TEXT NOT NULL,
    position INTEGER, -- Optional: for ordering images in the post
    alt_text TEXT     -- Optional: for accessibility/SEO
); 