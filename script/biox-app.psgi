use Plack::Builder;

use BioX::Workflow::Command::REST;

builder {
    mount '/api' => BioX::Workflow::Command::REST->new;
};
