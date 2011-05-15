# Specialization for makefile for EPICS build system
#
# Copyright: © 2011 Michael Davidsaver
# License: BSD

package Debian::Debhelper::Buildsystem::epicsmake;


use strict;
use Cwd qw(abs_path);
use Debian::Debhelper::Dh_Lib qw(verbose_print);
use Debian::Debhelper::Dh_Epics qw(setepicsenv epics_sover);
use base 'Debian::Debhelper::Buildsystem::makefile';

sub new {
    my $class=shift;
    my $this=$class->SUPER::new(@_);
    $this->enforce_in_source_building();
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

    return (-e $this->get_buildpath("configure/RELEASE") ? 5 : 0);
}

sub setbuildenv {
    my $this=shift;
    setepicsenv();
    my $bindir = $this->get_sourcepath("bin/$ENV{EPICS_HOST_ARCH}");
    my $libdir = $this->get_sourcepath("lib/$ENV{EPICS_HOST_ARCH}");
    $ENV{PATH} = "$ENV{PWD}/${bindir}:$ENV{PATH}";
    if( not exists $ENV{LD_LIBRARY_PATH} ) {
        $ENV{LD_LIBRARY_PATH} = "$ENV{PWD}/${libdir}";
    } else {
        $ENV{LD_LIBRARY_PATH} = "$ENV{PWD}/${libdir}:$ENV{LD_LIBRARY_PATH}";
    }
    verbose_print("export PATH=$ENV{PATH}");
    verbose_print("export LD_LIBRARY_PATHs=$ENV{LD_LIBRARY_PATH}");
}

sub makeargs {
    my $this=shift;
    my $sov=epics_sover();
    unshift(@_, ("USE_RPATH=NO", "SHRLIB_VERSION=${sov}",
            "EPICS_HOST_ARCH=$ENV{EPICS_HOST_ARCH}"));
    return @_;
}

sub do_make {
    my $this=shift;
    $this->setbuildenv();
    $this->SUPER::do_make($this->makeargs(@_));
}

sub test {
    my $this=shift;
    $this->make_first_existing_target(['runtests'], @_);
}

sub install {
    my $this=shift;
    my $destdir=shift;
    setepicsenv();
    $this->make_first_existing_target(['install'],
        "INSTALL_LOCATION=$destdir/$ENV{EPICS_BASE}", @_);
}

1
