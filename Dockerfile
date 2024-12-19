FROM continuumio/miniconda3

# set build-time proxy settings from docker-compose.yaml#args
ARG no_proxy
ARG http_proxy
ARG https_proxy

# copy build-time proxy-settings into run-time ones
ENV NO_PROXY=$no_proxy \
    HTTP_PROXY=$http_proxy \
    HTTPS_PROXY=$https_proxy

ENV DEBIAN_FRONTEND=noninteractive \
    LANGUAGE=C.UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LC_CTYPE=C.UTF-8 \
    LC_MESSAGES=C.UTF-8

ARG AIRFLOW_UID=50000
ARG AIRFLOW_GID=50000
ENV HOME=/home/airflow \
    AIRFLOW_HOME=/home/airflow/airflow \
    PATH="/home/airflow:${PATH}" \
    GUNICORN_CMD_ARGS="--worker-tmp-dir /dev/shm/"

RUN groupadd -g ${AIRFLOW_GID} airflow \
    && useradd -u ${AIRFLOW_UID} -g airflow -m -s /bin/bash airflow \
    # Install system dependencies
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        curl unzip libaio1 bc tox lcov valgrind \
        freetds-bin  krb5-user ldap-utils libsasl2-2 libsasl2-modules libssl3 locales  \
        lsb-release sasl2-bin sqlite3 unixodbc libsasl2-dev libkrb5-dev build-essential \
        python3-dev libmemcached-dev libldap2-dev libzbar-dev default-libmysqlclient-dev \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    # Install Docker CLI
    && curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-24.0.6.tgz \
        | tar -C /usr/bin --strip-components=1 -xvzf - docker/docker \
    # Install Python dependencies
    && conda install pip \
    && conda install mamba -c conda-forge \
    && mamba install -c conda-forge uvicorn gunicorn virtualenv \
    # Install Airflow
    && pip install \
        apache-airflow[celery,postgres,pandas,redis,mysql]==2.10.0 \
        --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.10.0/constraints-3.12.txt" \
    && register-python-argcomplete airflow >> ~/.bashrc \
    # Create directories
    && mkdir -p ${AIRFLOW_HOME} \
    && chown -R airflow:airflow ${HOME}

COPY start.sh /
RUN chmod +x /start.sh && chown airflow:airflow /start.sh

USER airflow

EXPOSE 8080

CMD ["/start.sh"]