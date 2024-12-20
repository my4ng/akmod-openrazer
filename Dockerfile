FROM fedora:41 AS build

RUN dnf update -y
RUN dnf group install -y development-tools
RUN dnf install -y rpmdevtools kmodtool
RUN dnf install -y wget jq 
RUN dnf install -y make python3-devel python3-setuptools systemd-rpm-macros

WORKDIR /openrazer
RUN mkdir -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS} src tmp out

COPY ./*.spec rpmbuild/SPECS/
COPY ./build.sh .

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["./build.sh"]
