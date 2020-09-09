#!/bin/bash

export ORACLE_HOME=/opt/oracle/instantclient_19_8
export LD_RUN_PATH=$ORACLE_HOME

mkdir -p /opt/oracle
unzip "/tmp/instantclient*.zip" -d /opt/oracle
sh -c "echo $ORACLE_HOME > /etc/ld.so.conf.d/oracle-instantclient.conf"
ldconfig