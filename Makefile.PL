#!/usr/bin/env perl
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    PREREQ_PM => {
        "App::Wallflower"           => 0,
        "Plack"                     => 0,
        "Plack::Middleware::Xslate" => 0,
    },
);
