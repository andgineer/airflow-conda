#!/bin/bash

# Configure FAB auth manager for Airflow v3
export AIRFLOW__CORE__AUTH_MANAGER=airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager

# Initialize Airflow database
airflow db migrate

# Create admin user using FAB provider
airflow users create --role Admin --username admin --email admin@example.com --firstname admin --lastname admin --password admin

# Start Airflow services
airflow api-server &
airflow scheduler

