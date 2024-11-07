#! /bin/bash

set -e

wget -O latest-release "https://api.github.com/repos/openrazer/openrazer/releases/latest"
wget -O - $(jq -r '.tarball_url' latest-release) | tar -xzvf - --strip-component=1 -C src

mkdir tmp/openrazer-kmod
cp src/driver/* tmp/openrazer-kmod
tar -czvf rpmbuild/SOURCES/openrazer-kmod.tar.gz -C tmp openrazer-kmod

mkdir tmp/openrazer
cp src/install_files/udev/* src/LICENSES/* src/README.md tmp/openrazer
tar -czvf rpmbuild/SOURCES/openrazer.tar.gz -C tmp openrazer

mkdir tmp/openrazer-daemon
cp -r src/daemon/* tmp/openrazer-daemon
rm tmp/openrazer-daemon/Makefile
rm -r tmp/openrazer-daemon/tests
sed -i "s|##PREFIX##|/usr|" tmp/openrazer-daemon/resources/org.razer.service.in \
    tmp/openrazer-daemon/resources/openrazer-daemon.systemd.service.in
mv tmp/openrazer-daemon/resources/org.razer.service.in tmp/openrazer-daemon/resources/org.razer.service
mv tmp/openrazer-daemon/resources/openrazer-daemon.systemd.service.in tmp/openrazer-daemon/resources/openrazer-daemon.service
tar -czvf rpmbuild/SOURCES/openrazer-daemon.tar.gz -C tmp openrazer-daemon


mkdir tmp/openrazer-daemon-only
cp -r src/daemon/* tmp/openrazer-daemon-only
rm tmp/openrazer-daemon-only/Makefile
rm -r tmp/openrazer-daemon-only/tests
sed -i "s|##PREFIX##|/usr|" tmp/openrazer-daemon-only/resources/org.razer.service.in \
    tmp/openrazer-daemon-only/resources/openrazer-daemon.systemd.service.in
mv tmp/openrazer-daemon-only/resources/org.razer.service.in tmp/openrazer-daemon-only/resources/org.razer.service
mv tmp/openrazer-daemon-only/resources/openrazer-daemon.systemd.service.in tmp/openrazer-daemon-only/resources/openrazer-daemon.service
tar -czvf rpmbuild/SOURCES/openrazer-daemon-only.tar.gz -C tmp openrazer-daemon-only



mkdir tmp/python-openrazer
cp -r src/pylib/* tmp/python-openrazer
rm -r tmp/python-openrazer/tests
tar -czvf rpmbuild/SOURCES/python-openrazer.tar.gz -C tmp python-openrazer

sed -i "s/OPENRAZER_VERSION/$(jq -r '.tag_name' latest-release | cut -c2-)/" rpmbuild/SPECS/*
sed -i "s/RELEASE_VERSION/${RELEASE_VERSION:-1}/" rpmbuild/SPECS/*

rpmbuild -ba --define "_topdir ${PWD}/rpmbuild" rpmbuild/SPECS/openrazer-kmod.spec
rpmbuild -ba --define "_topdir ${PWD}/rpmbuild" rpmbuild/SPECS/openrazer.spec
rpmbuild -ba --define "_topdir ${PWD}/rpmbuild" rpmbuild/SPECS/openrazer-daemon.spec
rpmbuild -ba --define "_topdir ${PWD}/rpmbuild" rpmbuild/SPECS/openrazer-daemon-only.spec
rpmbuild -ba --define "_topdir ${PWD}/rpmbuild" rpmbuild/SPECS/python-openrazer.spec

rm -vf out/*.rpm
cp -v rpmbuild/RPMS/**/*.rpm out/
