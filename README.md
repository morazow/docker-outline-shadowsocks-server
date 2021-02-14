# Outline Shadowsocks Server &#x1F433;

The standalone [outline-ss-server][outline-ss-server] that runs inside the
[Google Distroless][distroless] static image.

The `outline-ss-server` is a Shadowsocks implementation used by the [Outline
Server][outline-server].

## Features

- Supports multiple users on a single port
- Supports multiple ports
- Supports whitebox monitoring using [Prometheus][prometheus]
- Prohibits non [AEAD ciphers][aead-ciphers]

## Usage

### Docker Compose

Create a `docker-compose.yml` file:

```yml
version: '3.8'

services:
  outline-shadowsocks-server:
    image: morazow/outline-shadowsocks-server:latest
    container_name: outline-shadowsocks-server
    ports:
      - "8081:8081/tcp"
      - "8081:8081/udp"
    volumes:
      - "./config.yml:/outline/config.yml:ro"
    restart: unless-stopped
```

### Configuration

An example configuration `config.yml` file:

```yml
keys:
  - id: user01
    port: 8081
    cipher: chacha20-ietf-poly1305
    secret: secret1

  - id: user02
    port: 8081
    cipher: chacha20-ietf-poly1305
    secret: secret2
```

To run the container:

```sh
docker-compose up -d
docker-compose logs -f
```

### Upgrade

To upgrade the image and recreate the container:

```sh
docker-compose pull
docker-compose up -d
```

## Building

Build with a version:

```sh
VERSION=1.3.4 && \
docker build --build-arg OUTLINE_SHADOWSOCKS_VERSION="$VERSION" \
    -f Dockerfile \
    -t "morazow/outline-shadowsocks-server:$VERSION" \
    .
```

## License

[The MIT License (MIT)](LICENSE)

[distroless]: https://github.com/GoogleContainerTools/distroless
[outline-server]: https://github.com/Jigsaw-Code/outline-server
[outline-ss-server]: https://github.com/Jigsaw-Code/outline-ss-server
[prometheus]: https://prometheus.io/
[aead-ciphers]: https://shadowsocks.org/en/wiki/AEAD-Ciphers.html
