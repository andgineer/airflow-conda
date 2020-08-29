[Apache Airflow](https://airflow.apache.org/docs/stable/) is a workflow management platform. 
This makes it easier to build data pipelines, monitor them, and perform ETL operations. 

Airflow pipelines are configuration as Python code, allowing for dynamic pipeline generation. 
They are lean and explicit.
Airflow has a modular architecture and uses a message queue to orchestrate an arbitrary number of workers. 

But you can run it on your laptop.

This Docker container ships Airflow based on Anaconda (miniconda3) to make 
running machine learning pipelines and data science tasks seamless. 

Anaconda is an open source Python distribution for data science, machine learning, 
and large-scale data processing tasks with over 1,400 packages. 

Running Airflow on the Anaconda environment provides users with a simple and robust tool for building 
complex data pipelines for machine learning and data science tasks. 

### Usage

#### Running

    docker rm airflow
    docker run --name airflow -p 8080:8080 -p 5555:5555 -v $PWD/dags:/root/airflow/dags andgineer/airflow-conda

#### DAGs

You can place your [DAGs](https://airflow.apache.org/docs/stable/concepts.html) into folder `dags`
and they will be immediately available in the Apache Airflow.

Also there are a number of DAG examples already preloaded from Airflow.

#### Apache Airflow WebUI

You can open Apache Airflow web UI in your browser: [localhost:8080/admin/](http://127.0.0.1:8080/admin/).
See [Apache Airflow UI docs](https://airflow.apache.org/docs/stable/ui.html)

To manage Apache Airflow Worker jobs you can use Flower [localhost:5555/dashboard](http://127.0.0.1:5555/dashboard)

#### Command-line interface

    docker exec airflow airflow --help

See [Apache Airflow CLI docs](https://airflow.apache.org/docs/stable/usage-cli.html).

### Version

Latest tag builds Airflow 1.10.12 with Miniconda 3.

### DB

By default it create SQLite DB in `/root/airflow/airflow.db`.

By all means do not use this configuration on production %-)

See an example how to use this Docker image in 
[more mature configuration](https://github.com/andgineer/airflow/blob/master/docker-compose.yml).
