# Specialization for makefile for EPICS build system
#
# Copyright: © 2011 Michael Davidsaver
# License: BSD

package Debian::Debhelper::Buildsystem::epicsmake;


use strict;
use Cwd qw(abs_path);
use Debian::Debhelper::Dh_Lib qw(verbose_print);
use Debian::Debhelper::Dh_Epics qw(setepicsenv epics_sover get_targets);
use base 'Debian::Debhelper::Buildsystem::makefile';

sub new {
    my $class=shift;
    my $this=$class->SUPER::new(@_);
    $this->enforce_in_source_building();
    setepicsenv();
    return $this;
}

sub DESCRIPTION {
    "EPICS build system"
}

sub check_auto_buildable {
    my $this=shift;
    my ($step) = @_;

    if( not exists $ENV{EPICS_HOST_ARCH} ) {
        return 0;
    }

    return (-e $this->get_sourcepath("configure/RELEASE") ? 5 : 0);
}

sub pre_building_step {
    my $this=shift;

    my $pwd    = abs_path($ENV{PWD});
    my $bindir = $this->get_sourcepath("bin/$ENV{EPICS_HOST_ARCH}");
    my $libdir = $this->get_sourcepath("lib/$ENV{EPICS_HOST_ARCH}");
    $ENV{PATH} = "${pwd}/${bindir}:$ENV{PATH}";
    if( not exists $ENV{LD_LIBRARY_PATH} ) {
        $ENV{LD_LIBRARY_PATH} = "${pwd}/${libdir}";
    } else {
        $ENV{LD_LIBRARY_PATH} = "${pwd}/${libdir}:$ENV{LD_LIBRARY_PATH}";
    }

    $this->SUPER::pre_building_step(@_);
}

sub do_make {
    my $this=shift;
    my $sov=epics_sover();
    my $targets=join(" ",get_targets());

    verbose_print("export PATH=$ENV{PATH}");
    verbose_print("export LD_LIBRARY_PATH=$ENV{LD_LIBRARY_PATH}");

    unshift(@_, ("LINKER_USE_RPATH=NO", "USE_RPATH=NO",
            "SHRLIB_VERSION=${sov}", "EPICS_HOST_ARCH=$ENV{EPICS_HOST_ARCH}",
            "CROSS_COMPILER_TARGET_ARCHS=$targets"));
    $this->SUPER::do_make(@_);
}

sub test {
    my $this=shift;
    $this->do_make('runtests', @_);
}

sub install {
    my $this=shift;
    my $destdir=shift;

    $this->do_make('install',
        "INSTALL_LOCATION=$destdir/$ENV{EPICS_BASE}", @_);
}

sub clean {
    my $this=shift;
    $this->do_make('distclean', @_);
}

1
