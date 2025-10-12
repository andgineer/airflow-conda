[![Docker Automated build](https://img.shields.io/docker/image-size/andgineer/airflow-conda)](https://hub.docker.com/r/andgineer/airflow-conda)

# Dockerized Apache Airflow 3 with Anaconda

A [Docker container](https://hub.docker.com/r/andgineer/airflow-conda) for running Apache Airflow 3
in a miniconda3 environment with pre-installed data science libraries (Pandas, PyArrow) and database
adapters (MySQL, PostgreSQL, Redis, Celery).

## Features
* **Airflow 3**: Latest version with improved modularity and task execution
* **Pre-configured**: Includes essential libraries and database adapters out of the box
* **Non-root user**: Runs securely as unprivileged user (UID 50000)

# Usage

## Start the Container

    # Latest version
    docker run -p 8080:8080 andgineer/airflow-conda:latest

    # Specific Airflow version
    docker run -p 8080:8080 andgineer/airflow-conda:airflow-3.0.4

## Access Apache Airflow WebUI

Open the Airflow web UI in your browser: [http://localhost:8080](http://localhost:8080)

See [Apache Airflow UI docs](https://airflow.apache.org/docs/stable/ui.html) for more details.

## Default Login

- **Username:** admin 
- **Password:** admin

## Airflow DAGs

The container initializes a SQLite database at `/home/airflow/airflow/airflow.db` and includes
tutorial example DAGs from Apache Airflow.

For a production-like setup with mounted DAGs and persistent database, see the
[docker-compose.yml example](https://github.com/andgineer/airflow/blob/master/docker-compose.yml).
