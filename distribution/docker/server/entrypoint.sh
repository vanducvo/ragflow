#!/bin/bash

# replace env variables in the service_conf.yaml file
rm -rf /ragflow/conf/service_conf.yaml
while IFS= read -r line || [[ -n "$line" ]]; do
    # Use eval to interpret the variable with default values
    eval "echo \"$line\"" >> /ragflow/conf/service_conf.yaml
done < /ragflow/conf/service_conf.yaml.template

# unset http proxy which maybe set by docker daemon
export http_proxy=""; export https_proxy=""; export no_proxy=""; export HTTP_PROXY=""; export HTTPS_PROXY=""; export NO_PROXY=""

export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/

PY=python3


while [ 1 -eq 1 ];do
    $PY api/ragflow_server.py
done

wait;
