Name:           cross_lang_msg_system
Version:        1.0
Release:        1%{?dist}
Summary:        Multi-language app service

License:        MIT
Source0:        cross_lang_msg_system.tar.gz
BuildArch:      x86_64

%description
This package installs the binaries for a multi-language app service.

%prep
%setup -q

%build
# No compilation required for this RPM build

%install
# Create necessary directories and install the binaries with correct permissions
install -d -m 0755 %{buildroot}/usr/local/bin
install -m 0755 %{_builddir}/%{name}-%{version}/bin/* %{buildroot}/usr/local/bin/

# Optional: Ensure start_apps.sh and other scripts are included if needed
install -m 0755 %{_builddir}/%{name}-%{version}/bin/start_apps.sh %{buildroot}/usr/local/bin/

%files
/usr/local/bin/*

%changelog
* Sat Feb 15 2025 Albert Tran <xopiad@gmail.com> - 1.0-1
- Initial release
