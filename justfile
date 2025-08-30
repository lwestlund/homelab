target_os := 'linux'
target_arch := 'arm64'
platform := target_os + '/' + target_arch
sha := `git rev-parse --short HEAD`

dest := '~/homelab'

@default:
    just --list

@deploy-compose host:
    rsync -avz \
        docker-compose.yml \
        ./secrets \
        ./services \
        {{host}}:{{dest}}

@deploy-caddy host: (docker-load host 'homelab-caddy') (compose-down host 'homelab-caddy') (deploy-compose host) (compose-up host 'homelab-caddy')

@deploy-all host: (docker-load host 'homelab-caddy') (compose-down host) (deploy-compose host) (compose-up host)

@compose-down host *service:
    ssh {{host}} 'cd {{dest}} && docker compose down {{service}}'

@compose-up host *service:
    ssh {{host}} 'cd {{dest}} && docker compose up -d {{service}}'


@docker-load host +images: (docker-build images)
    for image in {{images}}; do \
        docker save --platform {{platform}} $image | gzip | ssh {{host}} docker image load; \
    done

@docker-build +images:
    for image in {{images}}; do \
        docker build --load --platform {{platform}} --tag $image:{{sha}} services/$image; \
    done


@setup-cross-compile arch=target_arch:
    docker run --rm --privileged tonistiigi/binfmt --install {{arch}}

raspberry-install-docker-compose host:
    ssh -t {{host}} 'curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg'
    ssh {{host}} 'sudo chmod a+r /etc/apt/keyrings/docker.gpg'
    ssh {{host}} 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null'
    ssh {{host}} 'sudo apt update'
    ssh {{host}} 'sudo apt install --assume-yes docker-ce docker-compose-plugin'
    ssh {{host}} 'sudo usermod -aG docker $USER'
