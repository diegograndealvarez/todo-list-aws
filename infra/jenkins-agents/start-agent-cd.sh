#!/bin/bash

cd /var/lib/jenkins/agent-cd

if [ ! -f agent.jar ]; then
  curl -sO http://localhost:8080/jnlpJars/agent.jar
fi

exec java -jar agent.jar \
  -url http://localhost:8080/ \
  -secret @secret-file-cd \
  -name "agent-cd" \
  -webSocket \
  -workDir "/var/lib/jenkins/agent-cd"
