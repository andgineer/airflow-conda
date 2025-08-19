# Use specific miniconda3 version with Python 3.12 (Airflow 3.0.4 supports Python 3.9-3.12, not 3.13)
# Latest Python 3.12 version as of Feb 2025: 25.1.1-2
# Check for updates at: https://github.com/ContinuumIO/docker-images/releases
FROM continuumio/miniconda3:25.1.1-2

# Version arguments
ARG AIRFLOW_VERSION=3.0.4

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
    # Install Docker CLI (latest version as of Feb 2025)
    && curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-28.3.3.tgz \
        | tar -C /usr/bin --strip-components=1 -xvzf - docker/docker \
    # Install Python dependencies
    && conda install pip \
    && conda install mamba -c conda-forge \
    && mamba install -c conda-forge uvicorn gunicorn virtualenv \
    # Install uv for faster package installation
    && pip install uv \
    # Install Airflow using uv with dynamic Python version detection
    && PYTHON_VERSION="$(python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')" \
    && CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt" \
    && uv pip install --system "apache-airflow[celery,postgres,pandas,redis,mysql]==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}" \
    # Install FAB provider for user management in Airflow v3
    && uv pip install --system "apache-airflow-providers-fab" --constraint "${CONSTRAINT_URL}" \
    && register-python-argcomplete airflow >> ~/.bashrc \
    # Create directories
    && mkdir -p ${AIRFLOW_HOME} \
    && chown -R airflow:airflow ${HOME}

COPY start.sh /
RUN chmod +x /start.sh && chown airflow:airflow /start.sh

USER airflow

EXPOSE 8080

CMD ["/start.sh"]