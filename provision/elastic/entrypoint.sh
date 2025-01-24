#!/bin/bash

mkdir -p /usr/share/elasticsaearch/data
chown -R elasticsearch:elasticsearch /usr/share/elasticsaearch/data

su -m elasticsearch /usr/local/bin/docker-entrypoint.sh "$@"