FROM continuumio/miniconda3

# set build-time proxy settings from docker-compose.yaml#args
ARG no_proxy
ARG http_proxy
ARG https_proxy

# copy build-time proxy-settings into run-time ones
ENV NO_PROXY=$no_proxy
ENV HTTP_PROXY=$http_proxy
ENV HTTPS_PROXY=$https_proxy

ENV DEBIAN_FRONTEND=noninteractive LANGUAGE=C.UTF-8 LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    LC_CTYPE=C.UTF-8 LC_MESSAGES=C.UTF-8

ARG HOME=/root
ENV HOME=${HOME}

ARG AIRFLOW_HOME=/root/airflow
ENV AIRFLOW_HOME=${AIRFLOW_HOME}

ARG AIRFLOW_SOURCES=/opt/airflow
ENV AIRFLOW_SOURCES=${AIRFLOW_SOURCES}

RUN echo http_proxy: ${http_proxy} \
    && echo HTTP_PROXY: ${HTTP_PROXY} \
    && echo https_proxy: ${https_proxy} \
    && echo HTTPS_PROXY: ${HTTPS_PROXY}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl unzip libaio1 bc tox lcov valgrind \
        freetds-bin  krb5-user ldap-utils libsasl2-2 libsasl2-modules libssl3 locales  \
        lsb-release sasl2-bin sqlite3 unixodbc libsasl2-dev libkrb5-dev build-essential \
        python3-dev libmemcached-dev libldap2-dev libzbar-dev default-libmysqlclient-dev \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://download.docker.com/linux/static/stable/x86_64/docker-24.0.6.tgz \
    |  tar -C /usr/bin --strip-components=1 -xvzf - docker/docker

# Install mamba
RUN conda install pip \
#  && conda config --set ssl_verify false \  # build behind corporate proxy
  && conda install mamba -c conda-forge \
  && mamba install -c conda-forge uvicorn gunicorn

# Install Airflow
RUN pip install \
# --trusted-host files.pythonhosted.org --trusted-host raw.githubusercontent.com \  # build behind corporate proxy
 apache-airflow[celery,postgres,pandas,redis,mysql]==2.10.0 \
 --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.10.0/constraints-3.12.txt"

RUN register-python-argcomplete airflow >> ~/.bashrc

ENV PATH="${HOME}:${PATH}"

# Needed to stop Gunicorn from crashing when /tmp is now mounted from host
ENV GUNICORN_CMD_ARGS="--worker-tmp-dir /dev/shm/"

COPY start.sh /
CMD /start.sh

EXPOSE 8080
