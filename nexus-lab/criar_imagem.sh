#!/bin/bash
cd ..
cd jenkins-lab/redis-app
docker build -t node/redis-app:1.0.0 .
docker images