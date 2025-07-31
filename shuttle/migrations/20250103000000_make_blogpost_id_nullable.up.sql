-- Migration: Make blogpost_id nullable in blogpost_images
ALTER TABLE blogpost_images
ALTER COLUMN blogpost_id DROP NOT NULL; 