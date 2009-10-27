Name:           berry
Version:        1.0
Release:        1%{?dist}
Summary:        IRC bot for #soggies

Group:          Applications/Internet
License:        BSD
URL:            http://tumble.wcyd.org
Source0:        
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:  rubygem-rake
Requires:       rubygem-rbot

%description
Berry is a wrapper for rbot that extends the basic functionality for jameswhite.org
to use.  Berry includes functionality to perform Markov-based conversation,
Posting to tumble, Tell, Shoutout, Standis, and quotes.  The system is based on
rbot so that new plugins can be added easily.



%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%doc



%changelog
