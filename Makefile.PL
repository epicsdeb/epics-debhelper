#!/usr/bin/perl

use ExtUtils::MakeMaker;

WriteMakefile (
    NAME    => 'Debian::Debhelper::Dh_Epics',
    VERSION => "1.0",
    AUTHOR  => 'Michael Davidsaver <mdavidsaver@bnl.gov',
    ABSTRACT => 'Debhelpers for EPICS build system',
    PREREQ_PM => { 'Debian::Debhelper' => 0 },
    EXE_FILES => [ qw(dh_rtems dh_strip_rtems ),
                   qw(dh_fixepicslibs dh_list_epics_targets) ],
);
