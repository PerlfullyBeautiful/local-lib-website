#!/usr/bin/env perl
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => 'perlfully-beautiful-skeleton', # change me!
    PREREQ_PM => {
        "App::Wallflower"           => 0,
        "Plack"                     => 0,
        "Plack::Middleware::Xslate" => 0,
    },
);

sub MY::postamble {
    return <<'POSTAMBLE';
preview:
	$(NOECHO) plackup

render:
	$(NOECHO) mkdir site
	$(NOECHO) wallflower --application app.psgi --destination site sitemap.txt

deps:
	$(NOECHO) cpanm --installdeps .
POSTAMBLE
}
