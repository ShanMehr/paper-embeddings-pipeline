-- Drop TableER if they exist
DROP TABLE IF EXISTS documents; 
DROP TABLE IF EXISTS group_members;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS groups;
DROP TABLE if EXISTS paper_vector_db;
DROP TABLE IF EXISTS annotation_record_rectangles;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS annotation_records;
DROP TABLE IF EXISTS paper_metadata;
DROP TABLE IF EXISTS author_attribution_linking;
DROP TABLE IF EXISTS chats;

--  Drop the database if it exists
DROP DATABASE IF EXISTS research_platform;
-- Create and switch to the database
CREATE DATABASE research_platform;
\c research_platform;
CREATE EXTENSION IF NOT EXISTS vector;

-- Create Tables
CREATE TABLE paper_vector_db (
  id SERIAL PRIMARY KEY,
  paper_id VARCHAR(255) NOT NULL UNIQUE,
  embedding VECTOR(768) NOT NULL,
  context TEXT
);

CREATE TABLE comment_vector_db (
  id SERIAL PRIMARY KEY,
  comment_id VARCHAR(255) NOT NULL UNIQUE,
  embedding VECTOR(768) NOT NULL
);

CREATE TABLE annotation_records (
  id SERIAL PRIMARY KEY,
  paper_id VARCHAR(255) NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  text TEXT NOT NULL,
  image TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE annotation_record_rectangles (
  id SERIAL PRIMARY KEY,
  annotation_id INTEGER NOT NULL REFERENCES annotation_records(id),
  x1 FLOAT NOT NULL,
  y1 FLOAT NOT NULL,
  x2 FLOAT NOT NULL,
  y2 FLOAT NOT NULL,
  width FLOAT NOT NULL,
  height FLOAT NOT NULL,
  page_number INT NOT NULL,
  usePdfCoordinates BOOLEAN DEFAULT FALSE,
  boundingRectangle BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  annotation_id INTEGER REFERENCES annotation_records(id),
  user_id VARCHAR(255) NOT NULL,
  y2 FLOAT NOT NULL,
  width FLOAT NOT NULL,
  height FLOAT NOT NULL,
  page_number INT NOT NULL,
  usePdfCoordinates BOOLEAN DEFAULT FALSE,
  boundingRectangle BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  text TEXT,
  emoji VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
  id VARCHAR(255) PRIMARY KEY,
  username VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE groups (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE group_members (
  group_id VARCHAR(255) REFERENCES groups(id),
  user_id VARCHAR(255) REFERENCES users(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE documents (
  paper_id VARCHAR(255) PRIMARY KEY,
  owner_id VARCHAR(255),
  group_id VARCHAR(255),
  file_name VARCHAR(255),
  url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE paper_metadata (
  paper_id VARCHAR(255) PRIMARY KEY,
  author_attribution_linking_id VARCHAR(255),
  title VARCHAR(255),
  abstract TEXT,
  doi VARCHAR(255),
  report_number VARCHAR(255),
  update_date TIMESTAMP
);


-- Association Table between 
CREATE TABLE author_attribution_linking (
  id VARCHAR(255),
  author_id VARCHAR(255)
);

CREATE TABLE chats (
  id VARCHAR(255) PRIMARY KEY,
  associated_context_id VARCHAR(255),
  text VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  user_id VARCHAR(255)
);