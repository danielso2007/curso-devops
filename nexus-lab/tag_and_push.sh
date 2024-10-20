#!/bin/bash
docker login -u jenkins -p jenkins123 localhost:8123
docker tag node/redis-app:1.0.0 localhost:8123/node/redis-app:1.0.0
docker push localhost:8123/node/redis-app:1.0.0
docker images