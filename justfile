@default:
    just --list

raspberry-install-docker-compose host:
    ssh -t {{host}} 'curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg'
    ssh {{host}} 'sudo chmod a+r /etc/apt/keyrings/docker.gpg'
    ssh {{host}} 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null'
    ssh {{host}} 'sudo apt update'
    ssh {{host}} 'sudo apt install --assume-yes docker-ce docker-compose-plugin'
    ssh {{host}} 'sudo usermod -aG docker $USER'
