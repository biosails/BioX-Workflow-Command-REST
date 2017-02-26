package BioX::Workflow::Command::REST;

our $VERSION = '0.01';

use strict;
use warnings;

use feature 'say';

#use FindBin '$Bin';
#use lib ("$Bin/../lib", "$Bin/../../../lib");

use Raisin::API;

plugin 'Swagger';
middleware 'CrossOrigin',
    origins => '*',
    methods => [qw/DELETE GET HEAD OPTIONS PATCH POST PUT/],
    headers => [qw/accept authorization content-type api_key_token/];

plugin 'Logger', outputs => [['Screen', min_level => 'debug']];

swagger_setup(
    title => 'BioX-Workflow REST Application',
    description => 'BioX-Workflow REST Application',

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

mount 'BioX::Workflow::Command::REST::run';

# Utils
sub paginate {
    my ($data, $params) = @_;

    my $max_count = scalar(@$data) - 1;
    my $start = _return_max($params->{start}, $max_count);
    my $count = _return_max($params->{count}, $max_count);

    my @slice = @$data[$start .. $count];
    \@slice;
}

sub _return_max {
    my ($value, $max) = @_;
    $value > $max ? $max : $value;
}

1;

__END__

=encoding utf-8

=head1 NAME

BioX::Workflow::Command::REST - Blah blah blah

=head1 SYNOPSIS

  use BioX::Workflow::Command::REST;

=head1 DESCRIPTION

BioX::Workflow::Command::REST is

=head1 AUTHOR

Jillian Rowe E<lt>jillian.e.rowe@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2017- Jillian Rowe

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
