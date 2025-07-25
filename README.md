# Tutek: My home server 
This repo stores scripts and configuration files to set up my home server called **Tutek**

Services are set up with docker compose.

As for now, I'm running these services:
- **Nginx** -> Web server / reverse proxy
- **Homepage** -> UI dashboard for the server
- **Pi-hole** -> DNS server/sinkhole
- **FreshRSS** -> RSS reader
- **Jellyfin** -> Media server
- **qBittorrent** -> Torrent client
- **slskd** -> Client-server app for the Soulseek file sharing network

## Specs
Currently running Ubuntu Server LTS 24.04 on a low-end-old laptop
 
- HP Pavilion DV2000
- AMD Turion(tm) X2 Dual-Core Mobile RM-70
- 2GB RAM (4GB configured as swap)
- 160GB HDD

## Setup scripts
On `scripts` folder there are currently the following scripts.

`configure_logind.sh` is used to ignore the lid closing and the server going idle/sleep. It is recommended to execute it if your server is running on a laptop.

`install_docker.sh` is used to install docker on the server, but you can install in your preferred way if you want to.

`setup_vimrc.sh` is used to setup vim editor to my preferred settings.

---

`scripts/cron` directory stores scripts for cron, for stuff like apt packages update.

## Pi-hole setup
If your server is running in a recent Ubuntu/Debian distro you may have to deactivate systemd-resolved, since it is listening on port 53.

Run these commands:

```bash
systemctl disable systemd-resolved.service
systemctl stop systemd-resolved
```

Thanks to [AlfonsoVM](https://discourse.pi-hole.net/t/docker-unable-to-bind-to-port-53/45082/8)

## Running services
To start services run:

`docker compose up -d`
