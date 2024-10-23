#!/bin/bash
rm -rf *.pem
rm -rf *.jks
rm -rf *.der
# https://gist.github.com/mattchilds1/19f254cd8047c91110fa2199279ebc0b
# openssl genpkey -algorithm RSA -out nexus-key.pem
# openssl req -new -x509 -key nexus-key.pem -out nexus-cert.pem -days 365 -config openssl.cnf
# openssl x509 -in nexus-cert.pem -outform der -out nexus-cert-with-san.der
# keytool -genkeypair -alias nexus -file nexus-cert-with-san.der -keyalg RSA -keysize 2048 -keystore nexus.jks -validity 365
# keytool -genkeypair -keystore nexus.jks -dname "CN=192.168.0.160, OU=RJ, O=em casa, L=niterói, ST=RJ, C=BR" -keypass 123456 -storepass 123456 -keyalg RSA -alias unknown -ext SAN=dns:test.abc.com,ip:192.168.0.160 -validity 365

keytool -genkey -alias 192.168.0.160 -keyalg RSA -dname 'CN=192.168.0.160, OU=RJ, O=em casa, L=niterói, ST=RJ, C=BR' -storepass 123456 -validity 365 -keystore keystore.jks -keypass 123456 -deststoretype pkcs12
sudo chown 666 keystore.jks
