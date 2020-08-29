#!/bin/bash

airflow initdb
airflow webserver &
airflow scheduler

