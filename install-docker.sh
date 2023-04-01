#!/bin/bash

echo "Installing drivers:"
if (lspci | grep 3070)
	then
		sudo apt install nvidia-driver-525 nvidia-utils-525 -y

elif (lspci | grep 3080)
	then
		sudo apt install nvidia-driver-525 nvidia-utils-525 -y

else
	sudo ubuntu-drivers autoinstall

fi

sudo apt autoremove -y

echo "Installing Docker"

sudo apt-get update
sudo apt-get install \
	ca-certificates \
	curl \
	gnupg

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "Installing nvidia-docker2:"
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)       && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg       && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list |             sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |             sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt update -y
sudo apt install nvidia-docker2 -y

echo "Adding user to the docker group"
sudo groupadd docker
echo "Enter the username you want to add to the docker group: "
read username
sudo gpasswd -a $username docker
echo "User successfully added!"
sudo systemctl restart docker.service

echo " "
echo "Rebooting system in 10 seconds \(Ctrl+C to cancel\)"
sleep 10
sudo reboot
