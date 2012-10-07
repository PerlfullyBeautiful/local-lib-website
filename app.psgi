#!/usr/bin/env perl
use strict;
use warnings;
use Plack::Builder;

use Plack::Middleware::Static;
use Plack::Middleware::Xslate;

builder {
    enable Xslate => (
        path         => qr{^/},
        root         => 'root/templates/',
        pass_through => 1,
    );
    enable Static => (
        path         => qr{^/},
        root         => 'root/static/',
        pass_through => 1,
    );
    sub { [ 404, [], [ 'Not found' ] ] };
};
