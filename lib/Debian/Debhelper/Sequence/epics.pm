#!/usr/bin/perl

use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

insert_before("dh_install", "dh_epics_installlibs");

insert_after("dh_install", "dh_rtems_install");

insert_after("dh_perl", "dh_rtems");

# wrapper for dh_strip which excludes RTEMS binaries
insert_before("dh_strip", "dh_strip_rtems");
remove_command("dh_strip");

insert_before("dh_lintian", "dh_rtems_lintian");

1
