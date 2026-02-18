#!/bin/bash

cd /var/lib/jenkins/agent-ci

if [ ! -f agent.jar ]; then
  curl -sO http://localhost:8080/jnlpJars/agent.jar
fi

exec java -jar agent.jar \
  -url http://localhost:8080/ \
  -secret @secret-file-ci \
  -name "agent-ci" \
  -webSocket \
  -workDir "/var/lib/jenkins/agent-ci"

