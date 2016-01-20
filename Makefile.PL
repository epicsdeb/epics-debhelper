#!/usr/bin/perl

use ExtUtils::MakeMaker;

WriteMakefile (
    NAME    => 'Debian::Debhelper::Dh_Epics',
    VERSION => "1.0",
    AUTHOR  => 'Michael Davidsaver <mdavidsaver@gmail.com>',
    ABSTRACT => 'Debhelpers for EPICS build system',
    PREREQ_PM => { 'Debian::Debhelper' => 0 },
    EXE_FILES => [ qw(dh_rtems dh_strip_rtems ),
                   qw(dh_rtems_install dh_rtems_lintian),
                   qw(dh_epics_list_targets dh_epics_installlibs),
                   qw(dh_epicsdep),
                 ],
);
