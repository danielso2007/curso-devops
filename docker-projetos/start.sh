#/usr/bin/bash
cd nexus/ssl
./criar_jks_nexus.sh
cd ..
cd ..
cd jenkins/ssl
./criar_jks_jenkins.sh
cd ..
cd ..
docker compose up -d
docker compose ps