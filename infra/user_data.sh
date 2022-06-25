#!/bin/bash
# installing docker dependencies
sudo apt-get update -y 
sudo apt-get install -y \
ca-certificates \
curl \
gnupg \
lsb-release 

# installing docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg 
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
sudo apt-get update -y 
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y 

# allowing docker to run without sudo
sudo groupadd docker 
sudo usermod -aG docker $USER 
sudo newgrp docker 

# file system configuration
sudo mkfs -t xfs /dev/xvdf 
mkdir /home/ubuntu/ragzinho
mkdir /home/ubuntu/ragzinho/db_ragzinho
sudo chown -R ubuntu:ubuntu /home/ubuntu/ragzinho
sudo mount /dev/xvdf /home/ubuntu/ragzinho

sudo reboot