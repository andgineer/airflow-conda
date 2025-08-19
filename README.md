[![Docker Automated build](https://img.shields.io/docker/image-size/andgineer/airflow-conda)](https://hub.docker.com/r/andgineer/airflow-conda)

# Dockerized Apache Airflow 3 with Anaconda

This repository offers a [Docker container](https://hub.docker.com/r/andgineer/airflow-conda) 
to run Airflow 3 on your local machine, using an Anaconda (miniconda3) environment. 

It comes with handy libraries and tools like Pandas, PyArrow, and Celery, as well as adapters for Redis and Postgres.

## Features
* **Airflow 3**: 
Easy management and scaling with a modular setup and a message queue.
* **Anaconda Environment**: 
Simplify setup and execution with Anaconda managing dependencies.
* **Faster with Mamba**: 
Speed up dependency resolution by swapping `conda` with `mamba` in your commands.

# Usage

## Start the Container

    # Latest version (Airflow 3.0.4)
    docker run -p 8080:8080 andgineer/airflow-conda:latest
    
    # Specific Airflow version
    docker run -p 8080:8080 andgineer/airflow-conda:airflow-3.0.4

## Access Apache Airflow WebUI

Open the Apache Airflow web UI in your browser: [localhost:8080/](http://127.0.0.1:8080/). 
See [Apache Airflow UI docs](https://airflow.apache.org/docs/stable/ui.html) for more.

## Default Login

- **Username:** admin 
- **Password:** admin

## Airflow DAGs

The container initially sets up a local DB at `/root/airflow/airflow.db` and loads some tutorial examples from 
Apache Airflow. 

For a more realistic environment, with a local DB and DAGs mounted into the container,
see [this example](https://github.com/andgineer/airflow/blob/master/docker-compose.yml).
