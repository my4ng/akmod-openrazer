# AKMOD-OPENRAZER

This project builds [openrazer](https://github.com/openrazer/openrazer) akmod and other RPM packages using podman/docker, instead of the provided dkms solution.

## Prerequisites

- Git
- Podman (recommended) / Docker
- Just (optional, recommended)

## Installation

Clone this repository
`git clone --depth 1 https://github.com/my4ng/akmod-openrazer.git && cd akmod-openrazer`

### Just

- Choose between Podman/Docker build
`just podman` / `just docker`
- Install on fedora (with superuser privileges)
`just install-fedora`

### Manual

1. Create an output directory
   `mkdir out`
2. Build Podman/Docker container image
   `<podman/docker> build -t openrazer -f Dockerfile .`
3. Run the container
   `<podman/docker> run -t -v ./out:/openrazer/out:Z --rm openrazer`
4. Find the built packages with `cd out`; there should be five packages:
   - `akmod-openrazer-<version>.rpm`
   - `kmod-openrazer-<version>.rpm`
   - `openrazer-<version>.rpm`
   - `openrazer-daemon-<version>.rpm`
   - `python3-openrazer-daemon-<version>.rpm`
5. Install the packages as appropriate to your distribution, e.g.
   - Fedora: `dnf install *`

## Licenses

This project is dual-licensed under Apache-2.0/MIT.
