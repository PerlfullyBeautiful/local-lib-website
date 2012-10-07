#!/usr/bin/env perl
use strict;
use warnings;

use ExtUtils::MakeMaker;

my %args = (
    NAME => 'perlfully-beautiful-skeleton', # change me!
    PREREQ_PM => {
        "App::Wallflower"           => 0,
        "Plack"                     => 0,
        "Plack::Middleware::Xslate" => 0,
    },
);

WriteMakefile(%args);

print "\n";

my $need_deps;
for my $module (keys %{ $args{PREREQ_PM} }) {
    if (!eval "require $module; 1") {
        $need_deps = 1;
    }
}
if ($need_deps) {
    print <<'MESSAGE';
Not all required dependencies are installed. To install them, you can run
'make deps'.

MESSAGE
}

print <<'MESSAGE';
You can now preview your site by running 'make preview', and deploy your site
by running 'make render'. The deployed site will be created in the 'site'
directory, containing a file for each path specified in sitemap.txt.
MESSAGE

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
