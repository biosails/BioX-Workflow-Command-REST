package BioX::Workflow::Command::REST::validate;

use strict;
use warnings;
use HTTP::Status qw(:constants);
use Raisin::API;
use Types::Standard qw(HashRef Any Int Str ArrayRef);

desc 'Validate a Workflow';

resource 'validate' => sub {
    summary 'Validate your workflow';
    params(
        requires( 'data',    type => HashRef, desc => 'Workflow Data' ),
    );
};

1;
