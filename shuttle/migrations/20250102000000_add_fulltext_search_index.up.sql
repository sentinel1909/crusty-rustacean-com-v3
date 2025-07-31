-- Add GIN index for full-text search performance
-- This index will significantly speed up full-text search queries

CREATE INDEX IF NOT EXISTS idx_blogposts_search 
ON blogposts 
USING GIN(to_tsvector('english', 
    coalesce(title, '') || ' ' || 
    coalesce(content, '') || ' ' || 
    coalesce(description, '')
)); 