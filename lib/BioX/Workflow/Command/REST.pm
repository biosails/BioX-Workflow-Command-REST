package BioX::Workflow::Command::REST;
use HTTP::Status qw(:constants);
use Raisin::API;

our $VERSION = '0.01';

use strict;
use warnings;
use feature 'say';

api_format 'json';
api_default_format 'json';

middleware 'CrossOrigin',
    origins => '*',
    methods => [qw/DELETE GET HEAD OPTIONS PATCH POST PUT/],
    headers => [qw/accept authorization content-type api_key_token/];

plugin 'Swagger';

swagger_setup(
    title => 'A POD synopsis API',
    description => 'An example of API documentation.',
    terms_of_service => '',

    contact => {
        name => 'Jillian Rowe',
        url => 'http://github.com/jerowe',
        email => 'jillian.e.rowe@gmail.com',
    },

    license => {
        name => 'Perl license',
        url => 'http://dev.perl.org/licenses/',
    },
);

plugin 'Logger', outputs => [['Screen', min_level => 'debug']];

mount 'BioX::Workflow::Command::REST::run';

1;

__END__

=encoding utf-8

=head1 NAME

BioX::Workflow::Command::REST - REST API for BioX::Workflow::Command

=head1 SYNOPSIS

  This is an extremely beta release
  plackup -E deployment -s Starman -p 3001 -r -R `pwd`/lib -a script/biox-app.psgi


=head1 DESCRIPTION

BioX::Workflow::Command::REST exposes a REST API for BioX::Workflow::Command

=head1 AUTHOR

Jillian Rowe E<lt>jillian.e.rowe@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2017- Jillian Rowe

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
