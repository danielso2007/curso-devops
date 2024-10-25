#/usr/bin/bash
cd nexus/ssl
./criar_jks.sh
cd ..
cd ..
docker compose up -d
docker compose ps