#!/usr/bin/env perl
use strict;
use warnings;

use ExtUtils::MakeMaker;

my %args = (
    NAME => 'local-lib-website',
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
    my $postamble = <<'POSTAMBLE';
preview:
	$(NOECHO) plackup

render:
	$(NOECHO) mkdir site
	$(NOECHO) wallflower --application app.psgi --destination site sitemap.txt
POSTAMBLE
    if (can_run('cpanm')) {
        $postamble .= <<'POSTAMBLE'
deps:
	$(NOECHO) cpanm --installdeps .
POSTAMBLE
    }
    else {
        $postamble .= <<'POSTAMBLE'
cpanm:
	$(NOECHO) wget -q http://xrl.us/cpanm
	$(NOECHO) chmod a+x cpanm

deps: cpanm
	$(NOECHO) ./cpanm --installdeps .
POSTAMBLE
    }
}

use constant IS_WIN32 => $^O eq 'MSWin32' ? 1 : 0;
require Win32 if IS_WIN32;

# check if we can run some command
sub can_run {
    my $command = shift;

    my @possibles;

    if( File::Spec->file_name_is_absolute($command) ) {
        return MM->maybe_command($command);

    } else {
        for my $dir (
            (split /\Q$Config::Config{path_sep}\E/, $ENV{PATH})
        ) {
            next if ! $dir || ! -d $dir;
            my $abs = File::Spec->catfile( IS_WIN32 ? Win32::GetShortPathName( $dir ) : $dir, $command);
            push @possibles, $abs if $abs = MM->maybe_command($abs);
        }
    }
    return shift @possibles;
}
