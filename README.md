# AKMOD-OPENRAZER

This project builds [openrazer](https://github.com/openrazer/openrazer) akmod and other RPM packages using podman/docker, instead of the provided dkms solution.

## Prerequisites

- Git
- Podman (recommended) / Docker

## Build packages

1. Clone this repository
   `git clone --depth 1 https://github.com/my4ng/akmod-openrazer.git && cd akmod-openrazer`
2. Create an output directory
   `mkdir out`
3. Build Podman/Docker container image
   `<podman/docker> build -t openrazer -f Dockerfile .`
4. Run the container
   `<podman/docker> run -t -v ./out:/openrazer/out:Z --rm openrazer`
5. Find the built packages with `cd out`; there should be five packages:
   - `akmod-openrazer-<version>.rpm`
   - `kmod-openrazer-<version>.rpm`
   - `openrazer-<version>.rpm`
   - `openrazer-daemon-<version>.rpm`
   - `python3-openrazer-daemon-<version>.rpm`
6. Install the packages as appropriate to your distribution, e.g.
   - Fedora: `dnf install *`

## Licenses

This project is dual-licensed under Apache-2.0/MIT.
