%global debug_package %{nil}

Name:           python-openrazer-daemon
Version:        OPENRAZER_VERSION
Release:        RELEASE_VERSION%{?dist}
Summary:        Openrazer daemon
License:        GPL-2.0
URL:            https://github.com/openrazer/openrazer
Source0:        openrazer-daemon.tar.gz

Requires:       openrazer-kmod >= %{version}
Requires:       openrazer-kmod-common >= %{version}
Provides:       openrazer-daemon = %{version}

BuildArch:      noarch
BuildRequires:  python3-devel
BuildRequires:  python3-setuptools
BuildRequires:  systemd-rpm-macros

%global _description %{expand:
Openrazer daemon that adds persistence support and more.}

%description %_description

%package -n python3-openrazer-daemon
Summary:       %{summary}

%description -n python3-openrazer-daemon %_description

%prep
%setup -n openrazer-daemon

%build
%py3_build

%install
rm -rf %{buildroot}
%py3_install
install -v -D -m 644 resources/razer.conf                   %{buildroot}/%{_datadir}/openrazer/razer.conf.example
install -v -D -m 755 run_openrazer_daemon.py                %{buildroot}/%{_bindir}/openrazer-daemon
install -v -D -m 644 resources/org.razer.service            %{buildroot}/%{_datadir}/dbus-1/services/org.razer.service
install -v -D -m 644 resources/openrazer-daemon.service     %{buildroot}/%{_userunitdir}/openrazer-daemon.service

%clean
rm -rf %{buildroot}

%post
%systemd_user_post openrazer-daemon.service

%preun
%systemd_user_preun openrazer-daemon.service

%postun
%systemd_user_postun_with_reload openrazer-daemon.service

%files -n python3-openrazer-daemon
%{python3_sitelib}/openrazer_daemon/
%{python3_sitelib}/openrazer_daemon-*.egg-info/

%doc resources/man/razer.conf.5
%doc resources/man/openrazer-daemon.8
%config %{_datadir}/openrazer/razer.conf.example

%{_bindir}/openrazer-daemon
%{_datadir}/dbus-1/services/org.razer.service
%{_userunitdir}/openrazer-daemon.service

%changelog
%autochangelog