[![Docker Automated build](https://img.shields.io/docker/image-size/andgineer/airflow-conda)](https://hub.docker.com/r/andgineer/airflow-conda)

# Dockerized Apache Airflow 2 with Anaconda

This repository offers a [Docker container](https://hub.docker.com/repository/docker/andgineer/airflow-conda/general) 
to run Airflow 2 on your local machine, using an Anaconda (miniconda3) environment. 

It comes with handy libraries and tools like Pandas, PyArrow, and Celery, as well as adapters for Redis and Postgres.

## Features
* **Airflow 2**: 
Easy management and scaling with a modular setup and a message queue.
* **Anaconda Environment**: 
Simplify setup and execution with Anaconda managing dependencies.
* **Faster with Mamba**: 
Speed up dependency resolution by swapping `conda` with `mamba` in your commands.

# Usage

## Start the Container

    docker run -p 8080:8080 andgineer/airflow-conda

## Access Apache Airflow WebUI

Open the Apache Airflow web UI in your browser: [localhost:8080/admin/](http://127.0.0.1:8080/admin/). 
See [Apache Airflow UI docs](https://airflow.apache.org/docs/stable/ui.html) for more.

## Default Login

- **Username:** admin 
- **Password:** admin

## Airflow DAGs

The container initially sets up a local DB at `/root/airflow/airflow.db` and loads some tutorial examples from 
Apache Airflow. 

For a more realistic environment, with a local DB and DAGs mounted into the container,
see [this example](https://github.com/andgineer/airflow/blob/master/docker-compose.yml).
