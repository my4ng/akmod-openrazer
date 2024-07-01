%global debug_package %{nil}

Name:           python-openrazer-daemon-lib
Version:        OPENRAZER_VERSION
Release:        RELEASE_VERSION%{?dist}
Summary:        Openrazer daemon library
License:        GPL-2.0
URL:            https://github.com/openrazer/openrazer
Source0:        openrazer-daemon-lib.tar.gz

Requires:       openrazer-kmod >= %{version}
Requires:       openrazer-kmod-common >= %{version}
Provides:       openrazer-daemon-lib = %{version}

BuildArch:      noarch
BuildRequires:  python3-devel
BuildRequires:  python3-setuptools

%global _description %{expand:
Openrazer daemon that adds persistence support and more.}

%description %_description

%package -n python3-openrazer-daemon-lib
Summary:       %{summary}

%description -n python3-openrazer-daemon-lib %_description

%prep
%setup -n openrazer-daemon-lib

%build
%py3_build

%install
rm -rf %{buildroot}
%py3_install

%clean
rm -rf %{buildroot}

%files -n python3-openrazer-daemon-lib
%{python3_sitelib}/openrazer/
%{python3_sitelib}/openrazer-*.egg-info/