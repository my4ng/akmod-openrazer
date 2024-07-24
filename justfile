out:
    mkdir -p out

podman: out
    podman build -t openrazer -f Dockerfile .
    podman run -t -v ./out:/openrazer/out:Z --rm openrazer

docker: out
    docker build -t openrazer -f Dockerfile .
    docker run -t -v ./out:/openrazer/out:Z --rm openrazer

install-fedora: out
   dnf install out/*.rpm
