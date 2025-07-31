-- Migration: Revert blogpost_id to NOT NULL in blogpost_images
ALTER TABLE blogpost_images
ALTER COLUMN blogpost_id SET NOT NULL; 