#!/usr/bin/bash

set -eu

docker service rm nginx || true
docker secret rm nginx.conf || true
docker secret create nginx.conf nginx.conf
docker service create --name nginx --network http --publish 80:80 --publish 443:443 \
                      --replicas 3 --update-delay 30s \
                      --secret site.crt --secret site.key --secret trusted.crt --secret dhparams-nginx.pem --secret nginx.conf \
                      nginx:stable-alpine \
                      sh -c "ln -fs /run/secrets/nginx.conf /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'"
