%global debug_package %{nil}

Name:           python-openrazer
Version:        OPENRAZER_VERSION
Release:        RELEASE_VERSION%{?dist}
Summary:        Openrazer Python library
License:        GPL-2.0
URL:            https://github.com/openrazer/openrazer
Source0:        python-openrazer.tar.gz

Requires:       openrazer-daemon >= %{version}
Provides:       python-openrazer = %{version}

BuildArch:      noarch
BuildRequires:  python3-devel
BuildRequires:  python3-setuptools

%global _description %{expand:
Python library for accessing the daemon from Python.}

%description %_description

%package -n python3-openrazer
Summary:       %{summary}

%description -n python3-openrazer %_description

%prep
%setup -n python-openrazer

%build
%py3_build

%install
rm -rf %{buildroot}
%py3_install

%clean
rm -rf %{buildroot}

%files -n python3-openrazer
%{python3_sitelib}/openrazer/
%{python3_sitelib}/openrazer-*.egg-info/

%changelog
%autochangelog
