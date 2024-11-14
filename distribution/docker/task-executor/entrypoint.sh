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

# Get StatefulSet pod ordinal from hostname if running in K8s
# Hostname format in StatefulSet: $(statefulset name)-$(ordinal)
if [[ $HOSTNAME =~ -([0-9]+)$ ]]; then
    WS=${BASH_REMATCH[1]}
else
    # Fallback to default check
    if [[ -z "$WS" || $WS -lt 1 ]]; then
        WS=0
    fi
fi

function task_exe(){
    while [ 1 -eq 1 ];do
      $PY rag/svr/task_executor.py $1;
    done
}

task_exe $WS &

wait;
