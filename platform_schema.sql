-- Drop Tables if they exist
DROP TABLE if EXISTS paper_vector_db;

--  Drop the database if it exists
DROP DATABASE IF EXISTS research_platform;

-- Create and switch to the database
CREATE DATABASE research_platform;
\c research_platform;

DROP TABLE if EXISTS paper_vector_db;

-- Create Tables
CREATE TABLE paper_vector_db (
    id SERIAL PRIMARY KEY,
    paper_id VARCHAR(255) NOT NULL UNIQUE,
    embedding VECTOR(768) NOT NULL,
    context TEXT
);

