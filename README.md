# Home lab

A description of my home lab, what is relevant for myself with my specific host and server setup.

- Host: Arch Linux desktop
- Server: Raspberry Pi 3B+ with default Raspberry Pi OS Lite

My home lab is a Docker Compose setup.
Not much more to it right now!

# Getting started (setting up the host and server)

Neither of a regular Arch or Raspberry Pi system runs this out of the box, so we'll go through what you need to do first.

## Host

### Just

I use [just](https://just.systems/man/en/) to drive my workflow.
Install it with

``` sh
pacman -S just
```

### Docker

We need to install Docker and plugins, and then we'll add ourselves to the `docker` group.

``` sh
pacman -S docker docker-buildx docker-compose
usermod -aG docker $USER
# Remember that you have to log out and back in for the group to apply.
```

With docker installed, we can start the daemon with

``` sh
systemctl start docker
```


## Server

### Docker

We need to install Docker and the Docker Compose plugin on the Raspberry, otherwise we're gonna have a hard time running this.
To help myself out, do it automatically with

``` sh
just raspberry-install-docker-compose
```

# Deploying to the server

Deploying should be as easy as pushing a button.
That's why we have the justfile and for more information, read that one!

# Services

## Caddy

[Caddy](https://caddyserver.com/) is a web server, but I will probably use it mostly to automate setting up TLS certificates for my domain (and subdomains. I am not a web developer, I can brag about having wildcarded subdomains).
