%global debug_package %{nil}

Name:           openrazer
Version:        OPENRAZER_VERSION
Release:        RELEASE_VERSION%{?dist}
Summary:        OpenRazer
License:        GPL-2.0
URL:            https://github.com/openrazer/openrazer
Source0:        openrazer.tar.gz

Requires:       openrazer-kmod >= %{version}
Provides:       openrazer-kmod-common = %{version}

BuildArch:      noarch
BuildRequires:  systemd-rpm-macros

%description
UDev rules for Razer devices

%prep
%autosetup -n %{name}

%build

%install
rm -rf %{buildroot}
install -v -D -m 755 razer_mount %{buildroot}/%{_udevrulesdir}/../razer_mount
install -v -D -m 644 99-razer.rules %{buildroot}/%{_udevrulesdir}/99-razer.rules

%clean
rm -rf %{buildroot}

%pre
#!/bin/sh
set -e
getent group plugdev >/dev/null || groupadd -r plugdev

%files
%{_udevrulesdir}/../razer_mount
%{_udevrulesdir}/99-razer.rules
