
#!/bin/bash

# === CI AGENT ===
sudo mkdir -p /var/lib/jenkins/agent-ci
sudo cp secret-file-ci /var/lib/jenkins/agent-ci/
sudo cp start-agent-ci.sh /var/lib/jenkins/agent-ci/
sudo cp jenkins-agent-ci.service /etc/systemd/system/
sudo chmod +x /var/lib/jenkins/agent-ci/start-agent-ci.sh
sudo chown -R jenkins:jenkins /var/lib/jenkins/agent-ci

# Descargar agent.jar
cd /var/lib/jenkins/agent-ci
sudo -u jenkins curl -sO http://localhost:8080/jnlpJars/agent.jar


# === CD AGENT ===
sudo mkdir -p /var/lib/jenkins/agent-cd
sudo cp secret-file-cd /var/lib/jenkins/agent-cd/
sudo cp start-agent-cd.sh /var/lib/jenkins/agent-cd/
sudo cp jenkins-agent-cd.service /etc/systemd/system/
sudo chmod +x /var/lib/jenkins/agent-cd/start-agent-cd.sh
sudo chown -R jenkins:jenkins /var/lib/jenkins/agent-cd

cd /var/lib/jenkins/agent-cd
sudo -u jenkins curl -sO http://localhost:8080/jnlpJars/agent.jar


# === SYSTEMD ===
sudo chmod 644 /etc/systemd/system/jenkins-agent-*.service
sudo systemctl daemon-reload

sudo systemctl enable jenkins-agent-ci
sudo systemctl start jenkins-agent-ci

sudo systemctl enable jenkins-agent-cd
sudo systemctl start jenkins-agent-cd
