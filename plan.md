# Automated home server plan

## OS - NixOS
 - OpenZFS for storage
 - NFS share
 - K3S

## Containers - Kubernetes + ArgoCD

### Filesharing
 - OpenCloud
 - Copyparty
 - SMB

### Media
 - Jellyfin
 - Lyrion Music Server (LMS)
 - Audiobookshelf
 - Navidrome
 - RomM?
 - *arr stack
    - Jellyseerr (Overseerr)?
    - Soulseek?
    - Prowlarr
    - Radarr
    - Sonarr
    - Readarr
    - qBittorrent
    - SabNZBd
    - gluetun

### Ingress
 - ~~Pangolin (WAN)~~
 - knockd+rathole+2nd traefik instance for WAN
 - Traefik (LAN)
 - Tailscale
 - Authelia + glauth?

### Backup
 - Duplicacy?

### Utils
 - Technitium DNS 

### Misc services
 - Mealie
 - SearXNG
 - PaperlessNGX?
 - YoutubeDL-Material?
 - Invidious
 - Homebox?
 - n8n?
 - netboot.xyz
 - Forgejo (git)
 - Linkwarden

### Monitoring
 - Grafana
 - Prometheus