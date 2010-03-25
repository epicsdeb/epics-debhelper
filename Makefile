DESTDIR=

prefix=$(DESTDIR)/usr
bindir=$(prefix)/bin
man1dir=$(prefix)/share/man/man1
dhseq=$(prefix)/share/perl5/Debian/Debhelper/Sequence

all: $(MAN1S)

BINS=dh_rtems

MAN1S=dh_rtems.1

DHSEQ=rtems.pm

%.1 : %
	pod2man --section=1 $< $@

install: install-bin install-man1 perl-seq

install-bin: $(addprefix $(bindir)/,$(BINS))

$(addprefix $(bindir)/,$(BINS)) : \
$(bindir)/% : %
	[ -d $(dir $@) ] || install -d $(dir $@)
	install -m 755 $^ $@

install-man1: $(addprefix $(man1dir)/,$(MAN1S))

$(addprefix $(man1dir)/,$(MAN1S)) : \
$(man1dir)/% : %
	[ -d $(dir $@) ] || install -d $(dir $@)
	install -m 644 $< $@

perl-seq: $(addprefix $(dhseq)/,$(DHSEQ))

$(dhseq)/% : %
	install -d $(dhseq)
	install -m 644 $< $@

clean:
	rm -f $(MAN1S)
