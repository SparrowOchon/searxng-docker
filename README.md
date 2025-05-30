# searxng-docker

Create a new SearXNG instance in five minutes using Docker. This was specifically modified to be optimized for lan use and speed with JSON support natively out of the box enabled.

## What is included?

| Name | Description | Docker image | Dockerfile |
| -- | -- | -- | -- |
| [Nginx](https://nginx.org/en/) | Reverse proxy (optimized for speed) | [docker.io/library/nginx:alpine](https://hub.docker.com/_/caddy)           | [Dockerfile](https://github.com/caddyserver/caddy-docker/blob/master/Dockerfile.tmpl) |
| [SearXNG](https://github.com/searxng/searxng) | SearXNG by itself                                              | [docker.io/searxng/searxng:latest](https://hub.docker.com/r/searxng/searxng) | [Dockerfile](https://github.com/searxng/searxng/blob/master/Dockerfile)               |

## How to use it
There are two ways to host SearXNG. The first one doesn't require any prior knowledge about self-hosting and thus is recommended for beginners. It includes Nginx as a reverse proxy and automatically deals with the local tls certificates for you.

1. [Install docker](https://docs.docker.com/install/)
2. Get searxng-docker
  ```sh
  cd /usr/local
  git clone https://github.com/searxng/searxng-docker.git
  cd searxng-docker
  ```
3. Run the setup script `./setup.sh` at the root of this Repo

> [!NOTE]
> Windows users can use the following powershell script to generate the secret key:
> ```powershell
> $randomBytes = New-Object byte[] 32
> (New-Object Security.Cryptography.RNGCryptoServiceProvider).GetBytes($randomBytes)
> $secretKey = -join ($randomBytes | ForEach-Object { "{0:x2}" -f $_ })
> (Get-Content searxng/settings.yml) -replace 'ultrasecretkey', $secretKey | Set-Content searxng/settings.yml
> ```

### Method 1: With Nginx included
4. Run SearXNG in the background: `docker compose up -d`


## Troubleshooting - How to access the logs

To access the logs from all the containers use: `docker compose logs -f`.

To access the logs of one specific container:

- Caddy: `docker compose logs -f caddy`
- SearXNG: `docker compose logs -f searxng`
- Valkey: `docker compose logs -f redis`

### Start SearXNG with systemd

You can skip this step if you don't use systemd.
1. Copy the service template file:
   ```sh
   cp searxng-docker.service.template searxng-docker.service
   ```
  
2. Edit the content of ```WorkingDirectory``` in the ```searxng-docker.service``` file (only if the installation path is different from ```/usr/local/searxng-docker```)
   
3. Enable the service:
   ```sh
   systemctl enable $(pwd)/searxng-docker.service
   ```

4. Start the service:
   ```sh
   systemctl start searxng-docker.service
   ```

**Note:** Ensure the service file path matches your installation directory before enabling it.

## Note on the image proxy feature

The SearXNG image proxy is activated by default.

The default [Content-Security-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy) allows the browser to access to ```${SEARXNG_HOSTNAME}``` and ```https://*.tile.openstreetmap.org;```.

If some users want to disable the image proxy, you have to modify [./Caddyfile](https://github.com/searxng/searxng-docker/blob/master/Caddyfile). Replace the ```img-src 'self' data: https://*.tile.openstreetmap.org;``` by ```img-src * data:;```.

## Multi Architecture Docker images

Supported architecture:

- amd64
- arm64
- arm/v7

## How to update ?

To update the SearXNG stack:

```sh
git pull
docker compose pull
docker compose up -d
```

Or the old way (with the old docker-compose version):

```sh
git pull
docker-compose pull
docker-compose up -d
```
