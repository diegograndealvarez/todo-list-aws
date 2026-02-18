#!/bin/bash

cd /var/lib/jenkins/agent-static

if [ ! -f agent.jar ]; then
  curl -sO http://localhost:8080/jnlpJars/agent.jar
fi

exec java -jar agent.jar \
  -url http://localhost:8080/ \
  -secret @secret-file-static \
  -name "agent-static" \
  -webSocket \
  -workDir "/var/lib/jenkins/agent-static"

