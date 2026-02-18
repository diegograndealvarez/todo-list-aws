
#!/bin/bash

# === static AGENT ===
sudo mkdir -p /var/lib/jenkins/agent-static
sudo cp secret-file-static /var/lib/jenkins/agent-static/
sudo cp start-agent-static.sh /var/lib/jenkins/agent-static/
sudo cp jenkins-agent-static.service /etc/systemd/system/
sudo chmod +x /var/lib/jenkins/agent-static/start-agent-static.sh
sudo chown -R jenkins:jenkins /var/lib/jenkins/agent-static

# === rest AGENT ===
sudo mkdir -p /var/lib/jenkins/agent-rest
sudo cp secret-file-rest /var/lib/jenkins/agent-rest/
sudo cp start-agent-rest.sh /var/lib/jenkins/agent-rest/
sudo cp jenkins-agent-rest.service /etc/systemd/system/
sudo chmod +x /var/lib/jenkins/agent-rest/start-agent-rest.sh
sudo chown -R jenkins:jenkins /var/lib/jenkins/agent-rest

cd /var/lib/jenkins/agent-rest
sudo -u jenkins curl -sO http://localhost:8080/jnlpJars/agent.jar
# Descargar agent.jar
cd /var/lib/jenkins/agent-static
sudo -u jenkins curl -sO http://localhost:8080/jnlpJars/agent.jar

# === SYSTEMD ===
sudo chmod 644 /etc/systemd/system/jenkins-agent-*.service
sudo systemctl daemon-reload

sudo systemctl enable jenkins-agent-static
sudo systemctl start jenkins-agent-static

sudo systemctl enable jenkins-agent-rest
sudo systemctl start jenkins-agent-rest
