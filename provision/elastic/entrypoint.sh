#!/bin/bash

echo "Create Volume"
mkdir -p /usr/share/elasticsearch/data
echo "Load Data"
chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data

su -m elasticsearch /usr/local/bin/docker-entrypoint.sh "$@"