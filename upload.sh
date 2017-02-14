#!/bin/bash
set -eu

aliases='9 latest'
tag='mattrobenolt/pgbadger'

fullVersion=$(awk '$1 == "ENV" && $2 == "PGBADGER_VERSION" { print $3; exit }' Dockerfile)

docker build --pull --rm -t $tag:$fullVersion .
docker push $tag:$fullVersion

for alias in $aliases; do
    docker tag $tag:$fullVersion $tag:$alias
    docker push $tag:$alias
done
