#!/usr/bin/perl

use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

# dh_epics_postinstall prevents accidental configure/RELEASE install
insert_after("dh_auto_install", "dh_epics_postinstall");

# relocate host runtime libs to /usr/lib/
insert_before("dh_install", "dh_epics_installlibs");

# handle install for packages w/o a debian/*.install
insert_after("dh_epics_installlibs", "dh_epics_install");

# emit dependencies for rtems packages
insert_after("dh_perl", "dh_rtems");

# wrapper for dh_strip which excludes RTEMS binaries
insert_before("dh_strip", "dh_strip_rtems");
remove_command("dh_strip");

# inject epics-dev dep for *-dev to match libepics* dep in lib*
insert_after("dh_shlibdeps", "dh_epicsdep");

insert_before("dh_makeshlibs", "dh_makeshlibs_epics");
remove_command("dh_makeshlibs");

# auto-create lintian overrides for epics module packages
insert_before("dh_lintian", "dh_epics_lintian");

1
