#!/usr/bin/perl

use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

insert_after("dh_perl", "dh_rtems");

insert_before("dh_strip", "dh_strip_rtems");
remove_command("dh_strip");

insert_before("dh_lintian", "dh_epics_lintian");

1
