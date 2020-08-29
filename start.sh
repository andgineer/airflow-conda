#!/bin/bash

airflow initdb
airflow webserver &
airflow flower &
airflow worker &
