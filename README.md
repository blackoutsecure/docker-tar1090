<p align="center">
  <img src="https://raw.githubusercontent.com/blackoutsecure/docker-tar1090/main/logo.png" alt="tar1090 logo" width="200">
</p>

# blackoutsecure/tar1090

[![GitHub Stars](https://img.shields.io/github/stars/blackoutsecure/docker-tar1090?style=flat-square&color=E7931D&logo=github)](https://github.com/blackoutsecure/docker-tar1090/stargazers)
[![Docker Pulls](https://img.shields.io/docker/pulls/blackoutsecure/tar1090?style=flat-square&color=E7931D&logo=docker&logoColor=FFFFFF)](https://hub.docker.com/r/blackoutsecure/tar1090)
[![GitHub Release](https://img.shields.io/github/release/blackoutsecure/docker-tar1090.svg?style=flat-square&color=E7931D&logo=github&logoColor=FFFFFF)](https://github.com/blackoutsecure/docker-tar1090/releases)
[![Balena Hub](https://img.shields.io/badge/balena%20hub-tar1090-E7931D?style=flat-square&logo=balena&logoColor=FFFFFF)](https://hub.balena.io/blocks/2352352/tar1090)
[![Blackout Secure Launchpad](https://img.shields.io/github/actions/workflow/status/blackoutsecure/docker-tar1090/bos-launchpad.yml?style=flat-square&label=blackout%20secure%20launchpad&color=E7931D)](https://github.com/blackoutsecure/docker-tar1090/actions/workflows/bos-launchpad.yml)
[![License: GPL v2](https://img.shields.io/badge/License-GPLv2-blue.svg?style=flat-square)](https://www.gnu.org/licenses/gpl-2.0)
[![Made by BlackoutSecure](https://img.shields.io/badge/made%20by-BlackoutSecure-1f1f1f?style=flat-square)](https://github.com/blackoutsecure)

LinuxServer.io-style containerized build of [tar1090](https://github.com/wiedehopf/tar1090), an improved, fast ADS-B web interface for readsb/dump1090-fa with maps, history, filters, and multi-instance support.

Sponsored and maintained by [Blackout Secure](https://blackoutsecure.app).

> [!IMPORTANT]
> This repository is not an official LinuxServer.io image release.
> Want to help make it an officially supported LinuxServer.io Community image?
> Add your support in [linuxserver/discussions/111](https://github.com/orgs/linuxserver/discussions/111).

## Overview

LinuxServer.io-style containerized build of [tar1090](https://github.com/wiedehopf/tar1090), an improved, fast ADS-B web interface for readsb/dump1090-fa with maps, history, filters, and multi-instance support.

Quick links:

- Docker Hub listing: [blackoutsecure/tar1090](https://hub.docker.com/r/blackoutsecure/tar1090)
- Balena block listing: [tar1090](https://hub.balena.io/blocks/2352352/tar1090)
- GitHub repository: [blackoutsecure/docker-tar1090](https://github.com/blackoutsecure/docker-tar1090)
- Upstream application: [wiedehopf/tar1090](https://github.com/wiedehopf/tar1090)
- Upstream query parameters: [tar1090 README-query.md](https://github.com/wiedehopf/tar1090/blob/master/README-query.md)

---

## Table of Contents

- [blackoutsecure/tar1090](#blackoutsecuretar1090)
  - [Overview](#overview)
  - [Table of Contents](#table-of-contents)
  - [Quick Start](#quick-start)
  - [Image Availability](#image-availability)
  - [About The tar1090 Application](#about-the-tar1090-application)
  - [Supported Architectures](#supported-architectures)
  - [Usage](#usage)
    - [docker-compose (recommended, click here for more info)](#docker-compose-recommended-click-here-for-more-info)
    - [docker-compose with paired readsb container](#docker-compose-with-paired-readsb-container)
    - [docker-cli (click here for more info)](#docker-cli-click-here-for-more-info)
    - [Balena Deployment](#balena-deployment)
  - [Parameters](#parameters)
    - [Ports](#ports)
    - [Environment Variables](#environment-variables)
    - [Storage Mounts](#storage-mounts)
  - [Volume Details](#volume-details)
    - [`/config` — Configuration \& Persistence](#config--configuration--persistence)
    - [`/data/readsb` — Decoder JSON Input](#datareadsb--decoder-json-input)
    - [Best Practices](#best-practices)
    - [Volume Mount Examples](#volume-mount-examples)
  - [Configuration](#configuration)
  - [User / Group Identifiers](#user--group-identifiers)
  - [Application Setup](#application-setup)
    - [Key Features](#key-features)
    - [Features That Depend On The Decoder](#features-that-depend-on-the-decoder)
  - [Troubleshooting](#troubleshooting)
    - [Container won't start or exits immediately](#container-wont-start-or-exits-immediately)
    - [The web UI loads but no aircraft appear](#the-web-ui-loads-but-no-aircraft-appear)
    - [Container starts but page appears incomplete](#container-starts-but-page-appears-incomplete)
    - [HTTP port conflict](#http-port-conflict)
    - [Advanced tar1090 behavior questions](#advanced-tar1090-behavior-questions)
    - [Getting help](#getting-help)
  - [Release \& Versioning](#release--versioning)
    - [Docker Hub Tags](#docker-hub-tags)
    - [How It Works](#how-it-works)
    - [Checking Your Image Version](#checking-your-image-version)
  - [Support \& Getting Help](#support--getting-help)
  - [Sponsor \& Credits](#sponsor--credits)
  - [References](#references)
    - [Project Resources](#project-resources)
    - [Upstream \& Related](#upstream--related)
    - [Technical Resources](#technical-resources)
  - [License](#license)

---

## Quick Start

**5-minute web UI setup (with sample data):**

```bash
docker compose up -d
```

Open `http://localhost:8080`.

**With a running decoder (e.g., readsb outputting JSON to a host directory):**

```bash
docker run -d \
  --name=tar1090 \
  --restart unless-stopped \
  -e TZ=Etc/UTC \
  -e TAR1090_SOURCE_DIR=/data/readsb \
  -p 8080:8080 \
  -v tar1090-config:/config \
  -v /path/to/readsb/json:/data/readsb:ro \
  blackoutsecure/tar1090:latest
```

Access the web interface at `http://<host-ip>:8080`.

For compose files, balena, and more examples, see [Usage](#usage) below.

---

## Image Availability

**Docker Hub (Recommended):**

- All images published to [Docker Hub](https://hub.docker.com/r/blackoutsecure/tar1090)
- Simple pull command: `docker pull blackoutsecure/tar1090:latest`
- Multi-arch support: amd64, arm64
- No registry prefix needed (defaults to Docker Hub)

```bash
# Pull latest
docker pull blackoutsecure/tar1090

# Pull by upstream version (from version file)
docker pull blackoutsecure/tar1090:3.14.1801

# Pull by upstream commit (tracks exact source)
docker pull blackoutsecure/tar1090:upstream-2bf25135a665
```

---

## About The tar1090 Application

[tar1090](https://github.com/wiedehopf/tar1090) is an improved aircraft map and tracking web interface for ADS-B decoder outputs.

It is **not** an ADS-B decoder. It reads JSON data produced by an existing decoder such as readsb, dump1090-fa, or another compatible source, and renders an interactive aircraft map in the browser.

Author and maintenance credits (upstream):

- Primary upstream maintainer: [wiedehopf](https://github.com/wiedehopf) (Matthias Wirth)
- Upstream repository and documentation: [wiedehopf/tar1090](https://github.com/wiedehopf/tar1090)
- Aircraft database: [wiedehopf/tar1090-db](https://github.com/wiedehopf/tar1090-db)

---

## Supported Architectures

This image is published as a multi-arch manifest. Pulling `blackoutsecure/tar1090:latest` retrieves the correct image for your host architecture.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |

---

## Usage

### docker-compose (recommended, [click here for more info](https://docs.linuxserver.io/general/docker-compose))

```yaml
---
services:
  tar1090:
    image: blackoutsecure/tar1090:latest
    container_name: tar1090
    environment:
      - TZ=Etc/UTC
      - TAR1090_SOURCE_DIR=/data/readsb
    volumes:
      - /path/to/tar1090/config:/config
      - /path/to/readsb/json:/data/readsb:ro
    ports:
      - 8080:8080
    restart: unless-stopped
    tmpfs:
      - /tmp
      - /run:exec
```

### docker-compose with paired readsb container

```yaml
---
services:
  readsb:
    image: blackoutsecure/readsb:latest
    container_name: readsb
    environment:
      - TZ=Etc/UTC
      - READSB_ARGS=--net --device-type rtlsdr
    volumes:
      - readsb-config:/config
      - readsb-json:/run/readsb
    devices:
      - /dev/bus/usb:/dev/bus/usb
    restart: unless-stopped
    tmpfs:
      - /tmp
      - /run

  tar1090:
    image: blackoutsecure/tar1090:latest
    container_name: tar1090
    environment:
      - TZ=Etc/UTC
      - TAR1090_SOURCE_DIR=/data/readsb
    volumes:
      - tar1090-config:/config
      - readsb-json:/data/readsb:ro
    ports:
      - 8080:8080
    depends_on:
      - readsb
    restart: unless-stopped
    tmpfs:
      - /tmp
      - /run:exec

volumes:
  readsb-config:
  readsb-json:
  tar1090-config:
```

### docker-cli ([click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=tar1090 \
  -e TZ=Etc/UTC \
  -e TAR1090_SOURCE_DIR=/data/readsb \
  -p 8080:8080 \
  -v /path/to/tar1090/config:/config \
  -v /path/to/readsb/json:/data/readsb:ro \
  --restart unless-stopped \
  blackoutsecure/tar1090:latest
```

### Balena Deployment

This image can be deployed to Balena-powered IoT devices using the included `docker-compose.yml` file (which contains the required Balena labels):

```bash
balena push <your-app-slug>
```

For deployment via the web interface, use the deploy button in this repository. See [Balena documentation](https://docs.balena.io/) for details.

## Parameters

### Ports

| Parameter | Function |
| :----: | --- |
| `-p 8080:8080` | tar1090 web UI (HTTP) |

### Environment Variables

| Parameter | Function | Required |
| :----: | --- | :---: |
| `-e TZ=Etc/UTC` | Timezone ([TZ database](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)) | Optional |
| `-e TAR1090_SOURCE_DIR=/data/readsb` | Directory tar1090 reads decoder JSON from | Recommended |
| `-e TAR1090_PORT=8080` | HTTP port for the web UI | Optional |
| `-e TAR1090_USER=abc` | Runtime user selection | Optional |
| `-e PUID=911` | User ID for non-root operation | Optional |
| `-e PGID=911` | Group ID for non-root operation | Optional |

### Storage Mounts

| Parameter | Function | Required |
| :----: | --- | :---: |
| `-v /config` | Configuration and persistent data | Recommended |
| `-v /data/readsb` | Mounted decoder JSON directory (read-only recommended) | Recommended |

---

## Volume Details

The container uses two volumes for data persistence and input:

### `/config` — Configuration & Persistence

- **Required**: No (container runs without it, but state is lost on restart)
- **Purpose**: Stores persistent data and application state
- **Example**: `-v /path/to/tar1090/config:/config` or `-v tar1090-config:/config`

### `/data/readsb` — Decoder JSON Input

- **Required**: Effectively yes (without it, the web UI loads but shows no aircraft)
- **Purpose**: Input directory containing decoder-generated JSON files
- **Contents**:
  - `aircraft.json` (current aircraft positions and data)
  - `receiver.json` (receiver stats and information)
  - Other tar1090-compatible outputs
- **Example**: `-v /path/to/readsb/json:/data/readsb:ro` or shared volume with readsb container

### Best Practices

- **Read-only mount**: Always mount `/data/readsb` as read-only (`:ro`) when another container owns the decoder output
- **For persistence**: Use named volumes or host paths for `/config` to preserve state between container restarts
- **Shared volume with readsb**: Use a named volume shared between readsb and tar1090 containers

### Volume Mount Examples

**Named volumes (recommended for single-host deployments):**

```yaml
volumes:
  - config:/config
  - readsb-json:/data/readsb:ro
```

**Host paths (for direct file access):**

```yaml
volumes:
  - /var/lib/tar1090/config:/config
  - /var/lib/readsb/json:/data/readsb:ro
```

---

## Configuration

Environment variables are set using `-e` flags in `docker run` or the `environment:` section in docker-compose.

tar1090 web interface customization is generally performed through upstream configuration such as `config.js` in the served HTML assets. This container ships the upstream defaults.

Useful upstream documentation:

- Main tar1090 readme: [wiedehopf/tar1090](https://github.com/wiedehopf/tar1090)
- Query parameters: [tar1090 README-query.md](https://github.com/wiedehopf/tar1090/blob/master/README-query.md)

Examples of upstream URL-driven behavior include:

- `/?pTracks` for history display
- `/?icao=abc123` to select a specific aircraft
- `/?zoom=9&enableLabels&extendedLabels=2` for display tuning
- `/?heatmap=200000` when compatible heatmap data is available

---

## User / Group Identifiers

By default, this container runs with the `abc` user (uid 911) via LinuxServer.io s6-overlay patterns.

**Default mode:**

- Uses `TAR1090_USER=abc` with `PUID=911` / `PGID=911`
- No special permissions needed

**Custom user mode (advanced):**

- Set `TAR1090_USER` to your username
- Provide matching `PUID` and `PGID` values

---

## Application Setup

The container runs tar1090 through nginx and expects decoder JSON input from a mounted directory.

### Key Features

- **Interactive Map**: Aircraft visualization with multiple basemap options
- **Aircraft Database**: Includes [tar1090-db](https://github.com/wiedehopf/tar1090-db) for accurate aircraft identification
- **Advanced Filtering**: Filter by ICAO, callsign, type, altitude, and more
- **Track History**: `?pTracks` support when decoder provides history snapshots
- **Read-Only Filesystem**: Supported when temp directories are mounted to tmpfs

### Features That Depend On The Decoder

Some tar1090 features depend on the decoder providing additional data:

- `?pTracks` requires history snapshots from the decoder
- Heatmap and replay require decoder-side support and retained history
- Richer aircraft identification benefits from the included tar1090-db aircraft database

This container fetches `aircraft.csv.gz` from [wiedehopf/tar1090-db](https://github.com/wiedehopf/tar1090-db) during build so the web UI has the upstream database artifact available.

---

## Troubleshooting

### Container won't start or exits immediately

**Check logs:**

```bash
docker logs tar1090
docker logs tar1090 --tail 50 -f  # Follow last 50 lines
```

**Common causes:**

- Port conflict: another service is already using port 8080
- Volume mount issue: verify paths exist and are accessible

### The web UI loads but no aircraft appear

**Check that decoder JSON is available:**

```bash
docker exec tar1090 ls -la /data/readsb
docker exec tar1090 cat /data/readsb/aircraft.json | head -c 200
```

If `aircraft.json` is missing or stale, the problem is upstream of tar1090 — fix it in the decoder container or host service.

### Container starts but page appears incomplete

**Check logs:**

```bash
docker logs tar1090 --tail 100
```

### HTTP port conflict

Change the host-side port mapping:

```bash
docker run ... -p 8081:8080 ...
```

### Advanced tar1090 behavior questions

For filter syntax, query parameters, `?pTracks`, heatmaps, and multi-instance behavior, use the [upstream tar1090 documentation](https://github.com/wiedehopf/tar1090) as those are application-level features.

### Getting help

- Check [upstream tar1090 documentation](https://github.com/wiedehopf/tar1090)
- Review container logs: `docker logs -f tar1090`
- Open an issue on [GitHub](https://github.com/blackoutsecure/docker-tar1090/issues)

---

## Release & Versioning

This project tracks two independent values from the upstream [wiedehopf/tar1090](https://github.com/wiedehopf/tar1090) master branch:

| What | Source | Example | Changes when |
| --- | --- | --- | --- |
| **Upstream Version** | [`version` file](https://github.com/wiedehopf/tar1090/blob/master/version) | `3.14.1801` | Upstream maintainer bumps it |
| **Upstream Commit** | Latest commit on `master` | `2bf25135a665` | Every upstream push |

These are two different things: the commit changes frequently with every push, while the version only changes when the upstream maintainer explicitly increments it. Both are tracked and published.

### Docker Hub Tags

Every build produces multiple tags so you can pin at the granularity you need:

| Tag | Example | Description |
| --- | --- | --- |
| `latest` | `blackoutsecure/tar1090:latest` | Always points to the most recent build |
| `<version>` | `blackoutsecure/tar1090:3.14.1801` | Matches the upstream `version` file |
| `<major>.<minor>` | `blackoutsecure/tar1090:3.14` | Semver major.minor from upstream version |
| `<major>` | `blackoutsecure/tar1090:3` | Semver major from upstream version |
| `upstream-<commit>` | `blackoutsecure/tar1090:upstream-2bf25135a665` | Exact upstream commit hash |

### How It Works

Release plumbing is handled by a thin caller for the [Blackout Secure Launchpad](https://github.com/blackoutsecure/bos-automation-hub) reusable workflow, defined in [`.github/workflows/bos-launchpad.yml`](../../actions/workflows/bos-launchpad.yml). On a 6-hour cron (and on manual dispatch) it runs three stages end-to-end:

1. **Monitor** — Polls the `version` file at the head of `wiedehopf/tar1090@master`, compares against `.github/upstream/tar1090-master.json`, and commits the tracking file when upstream moves.
2. **Docker** — Builds multi-arch images (amd64, arm64), tags `latest`, `<version>`, `<major>.<minor>`, `<major>`, `upstream-<commit>`, and `sha-<run-sha>` on Docker Hub, then refreshes the Docker Hub description from this README and runs a Docker Scout scan.
3. **Balena** — Renders `balena.yml` dynamically from the launchpad inputs and publishes the `tar1090` block release. This repo opts out of automated GitHub Releases (`github_release: false`).

### Checking Your Image Version

```bash
# Check the upstream version baked into the image
docker inspect -f '{{ index .Config.Labels "org.opencontainers.image.version" }}' blackoutsecure/tar1090:latest

# Check the upstream commit baked into the image
docker inspect -f '{{ index .Config.Labels "io.tar1090.upstream.commit" }}' blackoutsecure/tar1090:latest

# Check the full build version string
docker inspect -f '{{ index .Config.Labels "build_version" }}' blackoutsecure/tar1090:latest
```

**Update to latest:**

```bash
docker pull blackoutsecure/tar1090:latest
docker-compose up -d  # if using compose
```

---

## Support & Getting Help

- **Questions:** [GitHub Issues](https://github.com/blackoutsecure/docker-tar1090/issues)
- **Bug Reports:** Include Docker version, container logs, and reproduction steps
- **Upstream Documentation:** [tar1090 on GitHub](https://github.com/wiedehopf/tar1090)
- **Community:** [LinuxServer.io Discord](https://linuxserver.io/discord)

**Get help:**

```bash
docker logs tar1090                          # View container logs
docker exec -it tar1090 /bin/bash           # Access container shell
docker inspect blackoutsecure/tar1090       # Check image details
```

---

## Sponsor & Credits

Sponsored and maintained by [Blackout Secure](https://blackoutsecure.app)

Upstream project: [wiedehopf/tar1090](https://github.com/wiedehopf/tar1090)
Container patterns: [LinuxServer.io](https://linuxserver.io/)

---

## References

### Project Resources

| Resource | Link |
| --- | --- |
| **Docker Hub** | [blackoutsecure/tar1090](https://hub.docker.com/r/blackoutsecure/tar1090) |
| **Balena Block** | [tar1090](https://hub.balena.io/blocks/2352352/tar1090) |
| **GitHub Issues** | [Report bugs or request features](https://github.com/blackoutsecure/docker-tar1090/issues) |

### Upstream & Related

| Project | Link |
| --- | --- |
| **tar1090** | [wiedehopf/tar1090](https://github.com/wiedehopf/tar1090) |
| **tar1090-db** | [wiedehopf/tar1090-db](https://github.com/wiedehopf/tar1090-db) |
| **readsb** | [wiedehopf/readsb](https://github.com/wiedehopf/readsb) |
| **LinuxServer.io** | [linuxserver.io](https://linuxserver.io/) |

### Technical Resources

- [ADS-B Overview](https://en.wikipedia.org/wiki/Automatic_Dependent_Surveillance%E2%80%93Broadcast)
- [Docker Documentation](https://docs.docker.com/)

---

## License

This project is licensed under the GNU General Public License v2.0 or later - see the LICENSE file for details.

The tar1090 application itself is also licensed under GPL-2.0-or-later. For more information, see the [tar1090 repository](https://github.com/wiedehopf/tar1090).

---

*Made with care by [Blackout Secure](https://blackoutsecure.app)*
