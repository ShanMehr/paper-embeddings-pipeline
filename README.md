# Paper Upload Pipeline

This repository contains a prototype pipeline for ingesting arXiv metadata, generating vector embeddings from paper abstracts, and storing those embeddings in a PostgreSQL database with `pgvector`.

The main workflow lives in `paper_pipeline.ipynb`.

## What This Codebase Does

- Loads arXiv metadata from the JSON lines snapshot file.
- Transforms metadata into a shape suitable for the application schema.
- Generates embeddings with `ArtifactAI/arxiv-distilroberta-base-GenQ` using `sentence-transformers`.
- Uses Ray to parallelize embedding generation.
- Inserts vectors and metadata into Postgres tables such as `paper_vector_db`.
- Uses a schema script (`platform_schema.sql`) to create database objects, including the `vector` extension.

## Project Structure

- `paper_pipeline.ipynb`: End-to-end pipeline notebook.
- `platform_schema.sql`: Database schema and `pgvector` setup.
- `pixi.toml`: Environment, dependencies, and tasks.
- `pixi.lock`: Locked dependency resolution.

## Prerequisites

- [Pixi](https://pixi.sh/latest/) installed.
- PostgreSQL instance available locally or remotely.
- `pgvector` extension available in your Postgres instance.
- (Optional but recommended) NVIDIA GPU + CUDA for faster embedding generation.

## Environment Variables

The notebook expects:

- `SELF_HOSTED_POSTGRES_CONNECTION`: Postgres connection string used by `psycopg` and SQLAlchemy.

Example:

```bash
export SELF_HOSTED_POSTGRES_CONNECTION="postgresql://postgres:postgres@localhost:5432/research_platform"
```

If you use Infisical, this repository provides a Pixi task to pull secrets into `.env`:

```bash
pixi run pull-secrets
```

## Dataset

Place the arXiv snapshot file at the project root:

- `arxiv-metadata-oai-snapshot.json`

The notebook reads this file directly.

## Setup and Run with Pixi

1. Install dependencies:

```bash
pixi install
```

2. Initialize database schema (creates database and tables, enables vector extension):

```bash
psql -h localhost -U postgres -f platform_schema.sql
```

3. Ensure `SELF_HOSTED_POSTGRES_CONNECTION` is set (or loaded from `.env`).

4. Start Jupyter in the Pixi environment:

```bash
pixi run jupyter lab
```

5. Open `paper_pipeline.ipynb` and run cells in order.

## Running a Smaller Test

The notebook currently demonstrates with a small sample using:

- `pd.read_json(...).head(10)`

Keep this while validating your setup, then remove or increase the limit when you are ready for larger ingestion runs.

## Notes

- The schema script currently includes broader platform tables beyond vector storage. The embedding pipeline primarily writes to `paper_vector_db`.
- Because the SQL script drops and recreates the database, do **not** run it against production data.
