#!/bin/bash

# Update and install docker
sudo apt update
sudo apt install -y docker.io docker-compose

# A/B host run a_normal_java_service
sudo docker run -d -p 8080:8080 detcaccounts/a_normal_java_service

# B host run a_normal_java_service
if [ "${HOST_A_B}" = "B" ]; then
  sudo docker run -d -p 8081:8080 detcaccounts/a_normal_java_service
  sudo docker run -d -p 8082:8080 detcaccounts/a_normal_java_service
  sudo docker run -d -p 8083:8080 detcaccounts/a_normal_java_service
  sudo docker run -d -p 8084:8080 detcaccounts/a_normal_java_service
  sudo docker run -d -p 8085:8080 detcaccounts/a_normal_java_service
fi

# Setup Lacework via Docker 
sudo docker pull lacework/datacollector:latest
sudo docker run -d --name datacollector --net=host --pid=host --privileged --volume /:/laceworkfim:ro --volume /var/lib/lacework:/var/lib/lacework --volume /var/log:/var/log --volume /var/run:/var/run --volume /etc/passwd:/etc/passwd:ro --volume /etc/group:/etc/group:ro --env ACCESS_TOKEN=${LACEWORK_ACCESS_TOKEN} lacework/datacollector:latest

# sudo wget https://s3-us-west-2.amazonaws.com/www.lacework.net/download/5.1.0.6419_2021-12-18_release-v5.1_d0fd83c92c604ed47e8485222b0c42b4d5f20684/install.sh
# sudo chmod +x install.sh
# sudo ./install.sh
