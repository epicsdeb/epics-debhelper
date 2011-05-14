#!/usr/bin/perl -w
#
# Library for EPICS helpers
#

package Debian::Debhelper::Dh_Epics;
use strict;

use Exporter;
use vars qw(@ISA @EXPORT %dh);
@ISA=qw(Exporter);
@EXPORT=qw(&setepicsenv &epics_sover);

sub setepicsenv {
    if (not exists $ENV{EPICS_BASE}) {
        $ENV{EPICS_BASE} = "/usr/lib/epics";
    }
    if (not exists $ENV{EPICS_HOST_ARCH}) {
        $ENV{EPICS_HOST_ARCH} = `$ENV{EPICS_BASE}/startup/EpicsHostArch.pl`;
    }
}

# fetch the package SO version.  By default this is the
# upstream version (because packagers won't break the ABI ;).
# ... and if they do then set the environment var ...
sub epics_sover {
    if( exists $ENV{SHRLIB_VERSION} ) {
        return $ENV{SHRLIB_VERSION};
    }

    my $version=`dpkg-parsechangelog`;

    # [IGNORE:]INTERESTING[-IGNORE]
    my ($ver) = $version =~ m/Version:\s*(?:\d*:)?([\d:.+-~]*)/m;

    if($ver =~ /(.*)-[^-]*/) { # strip debian version
        ($ver) = $1;
    }
    return $ver;
}
