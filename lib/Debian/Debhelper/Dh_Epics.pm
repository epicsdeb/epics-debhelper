#!/usr/bin/perl -w
#
# Library for EPICS helpers
#

package Debian::Debhelper::Dh_Epics;
use strict;

use Exporter;
use vars qw(@ISA @EXPORT);
@ISA=qw(Exporter);
@EXPORT=qw(&setepicsenv &epics_sover &get_targets &epics_targets);

use Debian::Debhelper::Dh_Lib qw(basename verbose_print getpackages);

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

sub get_targets {
    if(exists $ENV{CROSS_COMPILER_TARGET_ARCHS}) {
        my @targets = split(/\s+/, $ENV{CROSS_COMPILER_TARGET_ARCHS});
        return @targets;
    }

    my @targets = ();

    if(-d "$ENV{EPICS_BASE}/lib/$ENV{EPICS_HOST_ARCH}-debug") {
        push(@targets,"$ENV{EPICS_HOST_ARCH}-debug");
    }

    foreach my $pkg (getpackages()) {
        if ($pkg =~ m/^rtems-.+-([^-]+)$/) {
            push(@targets, "RTEMS-$1");
        }
    }
    return @targets;
}

sub epics_targets {
    my $neg = shift;
    my @filters = @_;
    setepicsenv();
    my @dirs = glob("$ENV{EPICS_BASE}/lib/*");

    my @ret = ();

    foreach my $libdir (@dirs) {
        next unless(-d $libdir and not -l $libdir);
        my $targ = basename($libdir);

        my $cont=($neg ? 0 : 1);
        foreach my $test (@filters) {
            if( $test =~ m/^-(.*)/ ) {
                if( $targ =~ m/$1/) {
                    $cont = 0;
                    last;
                }

            } else {
                my $tst = $test;
                $tst = $1 if( $test =~ m/^\\-(.*)/ );

                $cont = 1 if( $targ =~ m/$tst/);

            }
        }
        next if(not $cont);

        unshift(@ret, $targ);
    }
    return @ret;
}
