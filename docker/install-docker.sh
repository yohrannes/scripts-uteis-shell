curl -fsSL https://get.docker.com | bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
