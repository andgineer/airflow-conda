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
    && apt-get install -y --no-install-recommends curl \
        freetds-bin  krb5-user ldap-utils libffi6 libsasl2-2 libsasl2-modules libssl1.1 locales  \
        lsb-release sasl2-bin sqlite3 unixodbc libsasl2-dev libkrb5-dev build-essential \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://download.docker.com/linux/static/stable/x86_64/docker-19.03.9.tgz \
    |  tar -C /usr/bin --strip-components=1 -xvzf - docker/docker

# Install MySQL client from Oracle repositories (Debian installs mariadb)
RUN echo "deb [trusted=yes] http://repo.mysql.com/apt/debian/ stretch mysql-5.6" | tee -a /etc/apt/sources.list.d/mysql.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        libmysqlclient-dev \
        mysql-client \
    && apt-get autoremove -yqq --purge \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN conda install pip \
    && pip install uvicorn gunicorn

COPY airflow-1.10.12-constraints-3.7.txt ${AIRFLOW_HOME}/
RUN pip install \
 apache-airflow[all]==1.10.12 \
 --constraint "${AIRFLOW_HOME}/airflow-1.10.12-constraints-3.7.txt"

RUN register-python-argcomplete airflow >> ~/.bashrc

ENV PATH="${HOME}:${PATH}"

# Needed to stop Gunicorn from crashing when /tmp is now mounted from host
ENV GUNICORN_CMD_ARGS="--worker-tmp-dir /dev/shm/"

# in docker-compose-dev we mount this as volume for live reload on changes for debugging
VOLUME /etl

EXPOSE 8080
