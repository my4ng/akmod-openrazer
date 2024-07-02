%global debug_package %{nil}

Name:           python-openrazer-daemon
Version:        OPENRAZER_VERSION
Release:        RELEASE_VERSION%{?dist}
Summary:        Openrazer daemon Python library
License:        GPL-2.0
URL:            https://github.com/openrazer/openrazer
Source0:        python-openrazer-daemon.tar.gz

Requires:       openrazer-daemon >= %{version}
Provides:       python-openrazer-daemon = %{version}

BuildArch:      noarch
BuildRequires:  python3-devel
BuildRequires:  python3-setuptools

%global _description %{expand:
Openrazer daemon that adds persistence support and more.}

%description %_description

%package -n python3-openrazer-daemon
Summary:       %{summary}

%description -n python3-openrazer-daemon %_description

%prep
%setup -n python-openrazer-daemon

%build
%py3_build

%install
rm -rf %{buildroot}
%py3_install

%clean
rm -rf %{buildroot}

%files -n python3-openrazer-daemon
%{python3_sitelib}/openrazer/
%{python3_sitelib}/openrazer-*.egg-info/

%changelog
%autochangelog