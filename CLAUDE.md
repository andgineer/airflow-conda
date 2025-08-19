# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker-based Apache Airflow 3 setup that runs in an Anaconda (miniconda3) environment. The project provides a pre-configured Docker container with Airflow 3.0.4 (configurable), and essential data science libraries including Pandas, PyArrow, and Celery, along with adapters for Redis, Postgres, and MySQL.

## Architecture

The project consists of three main components:

- **Dockerfile**: Multi-stage build that creates an Airflow container based on continuumio/miniconda3
  - Uses ARG AIRFLOW_VERSION for configurable version (default: 3.0.4)
  - Sets up non-root user (airflow:50000) for security
  - Installs system dependencies including MySQL client, Docker CLI, and development tools
  - Uses mamba for faster dependency resolution and uv for Python package installation
  - Dynamically detects Python version from miniconda image
  - Installs Airflow with celery, postgres, pandas, redis, and mysql extras

- **start.sh**: Container entrypoint script that:
  - Initializes Airflow database
  - Creates default admin user (admin/admin)
  - Starts webserver and scheduler processes

- **README.md**: User documentation with usage instructions

## Development Commands

### Building the Docker Image
```bash
# Build with default Airflow version (3.0.4)
docker build -t airflow-conda .

# Build with specific Airflow version
docker build --build-arg AIRFLOW_VERSION=3.0.4 -t airflow-conda .

# With proxy settings (if needed)
docker build --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy --build-arg no_proxy=$no_proxy --build-arg AIRFLOW_VERSION=3.0.4 -t airflow-conda .
```

### Running the Container
```bash
# Latest version
docker run -p 8080:8080 andgineer/airflow-conda:latest

# Specific Airflow version
docker run -p 8080:8080 andgineer/airflow-conda:airflow-3.0.4
```

### Accessing the Application
- Airflow WebUI: http://localhost:8080
- Default credentials: admin/admin

## Key Configuration Details

- **Airflow Version**: 3.0.4 (configurable via AIRFLOW_VERSION ARG)
- **Base Image**: continuumio/miniconda3
- **Python Version**: Dynamically detected from miniconda image  
- **User Setup**: Non-root user (UID/GID: 50000) for security
- **Home Directory**: /home/airflow
- **Airflow Home**: /home/airflow/airflow
- **Exposed Port**: 8080
- **Package Managers**: Uses mamba for conda packages and uv for Python packages (faster installation)

## Container Structure

The container is designed to run Airflow with:
- SQLite database (default, located at /home/airflow/airflow/airflow.db)
- Built-in tutorial DAGs for examples
- Support for external databases (MySQL, Postgres) and message queues (Redis, Celery)
- Docker CLI available for Docker-in-Docker scenarios

## GitHub Actions Workflow

The repository includes automated Docker image building and publishing:
- **Triggers**: Push to master, tags, pull requests, manual dispatch
- **Multi-platform**: Builds for linux/amd64 and linux/arm64
- **Smart Tagging**:
  - `latest`: Always points to the most recent build from master branch
  - `airflow-X.Y.Z`: Tagged with exact Airflow version being built
  - Git tags: Additional tags when pushing version tags
- **Manual Builds**: Can specify custom Airflow version via workflow dispatch

## Security Notes

- Container runs as non-root user 'airflow' with UID 50000
- Default admin credentials are admin/admin (should be changed in production)
- Supports proxy configuration for corporate environments