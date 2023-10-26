[![Docker Automated build](https://img.shields.io/docker/image-size/andgineer/airflow-conda)](https://hub.docker.com/r/andgineer/airflow-conda)

[Apache Airflow](https://airflow.apache.org/docs/stable/) is a workflow management platform. 
This makes it easier to build data pipelines, monitor them, and perform ETL operations. 

Airflow pipelines are configured as Python code, allowing for dynamic pipeline generation. 
They are lean and explicit.
Airflow has a modular architecture and uses a message queue to orchestrate an arbitrary number of workers.

This [Docker container](https://hub.docker.com/repository/docker/andgineer/airflow-conda/general)
allows you to run it on your laptop. It ships Airflow 2 based on Anaconda (miniconda3) with a number of
useful staff like Pandas, PyArrow, Celery, adapters for Redis, Postgres.

Running Airflow on the Anaconda environment provides users with a simple and robust tool for building 
complex data pipelines for machine learning and data science tasks. 
As a bonus I included super-fast conda replacement - mamba, just replace `conda` with `mamba` in your commands and you will be
surfrised how fast it is.

### Usage

#### Running

    docker run -p 8080:8080 andgineer/airflow-conda

#### Apache Airflow WebUI

You can open Apache Airflow web UI in your browser: [localhost:8080/admin/](http://127.0.0.1:8080/admin/).
See [Apache Airflow UI docs](https://airflow.apache.org/docs/stable/ui.html)

#### Default user

- **login:** admin 
- **password:** admin

### Debugging your pipelines

By default the container creates local DB in `/root/airflow/airflow.db`.
And loads Apache Airflow tutorial examples.

You can play with this examples for a while.
If you need more realistic environment to debug your own pipelines you can use 
[this example](https://github.com/andgineer/airflow/blob/master/docker-compose.yml)
or create your own debug environment, based on this image.

### Version

Latest tag builds Airflow 1.10.12 with Miniconda 3.
