FROM fedora:latest AS build

RUN dnf update -y \
    dnf groupinstall -y "Development Tools" \
    && dnf install -y rpmdevtools kmodtool

RUN dnf install -y wget jq 
RUN dnf install -y make python3-devel systemd-rpm-macros

WORKDIR /openrazer

RUN mkdir -p rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS} src tmp

ARG RELEASE_VERSION=1

ADD "https://api.github.com/repos/openrazer/openrazer/releases/latest" latest-release

RUN wget -O - $(jq -r '.tarball_url' latest-release) | tar -xzvf - --strip-component=1 -C src

RUN mkdir tmp/openrazer-kmod \
&& cp src/driver/* tmp/openrazer-kmod \
&& tar -czvf rpmbuild/SOURCES/openrazer-kmod.tar.gz -C tmp openrazer-kmod

RUN mkdir tmp/openrazer \
&& cp src/install_files/udev/* src/LICENSES/* src/README.md tmp/openrazer \
&& tar -czvf rpmbuild/SOURCES/openrazer.tar.gz -C tmp openrazer

RUN mkdir tmp/openrazer-daemon \
&& cp -r src/daemon/* tmp/openrazer-daemon \
&& rm tmp/openrazer-daemon/Makefile \
&& rm -r tmp/openrazer-daemon/tests \
&& sed -i "s|##PREFIX##|/usr|" tmp/openrazer-daemon/resources/org.razer.service.in \
tmp/openrazer-daemon/resources/openrazer-daemon.systemd.service.in \
&& mv tmp/openrazer-daemon/resources/org.razer.service.in tmp/openrazer-daemon/resources/org.razer.service \
&& mv tmp/openrazer-daemon/resources/openrazer-daemon.systemd.service.in tmp/openrazer-daemon/resources/openrazer-daemon.service \
&& tar -czvf rpmbuild/SOURCES/openrazer-daemon.tar.gz -C tmp openrazer-daemon

RUN mkdir tmp/openrazer-daemon-lib \
&& cp -r src/pylib/* tmp/openrazer-daemon-lib \
&& rm -r tmp/openrazer-daemon-lib/tests \
&& tar -czvf rpmbuild/SOURCES/openrazer-daemon-lib.tar.gz -C tmp openrazer-daemon-lib

RUN dnf update -y

COPY ./*.spec rpmbuild/SPECS/
RUN sed -i "s/OPENRAZER_VERSION/$(jq -r '.tag_name' latest-release | cut -c2-)/" rpmbuild/SPECS/*
RUN sed -i "s/RELEASE_VERSION/${RELEASE_VERSION}/" rpmbuild/SPECS/*

RUN rpmbuild -ba --define "_topdir ${PWD}/rpmbuild" rpmbuild/SPECS/openrazer-kmod.spec
RUN rpmbuild -ba --define "_topdir ${PWD}/rpmbuild" rpmbuild/SPECS/openrazer.spec
RUN rpmbuild -ba --define "_topdir ${PWD}/rpmbuild" rpmbuild/SPECS/openrazer-daemon.spec
RUN rpmbuild -ba --define "_topdir ${PWD}/rpmbuild" rpmbuild/SPECS/openrazer-daemon-lib.spec

WORKDIR /output

RUN cp /openrazer/rpmbuild/RPMS/{noarch,x86_64}/* .