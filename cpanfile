requires 'BioX::Workflow::Command::run';
requires 'Capture::Tiny';
requires 'File::Temp';
requires 'HTTP::Status';
requires 'List::Util';
requires 'MooseX::App::Command';
requires 'Plack::Builder';
requires 'Raisin::API';
requires 'Types::Standard';
requires 'feature';
requires 'perl', '5.008005';
requires 'strict';
requires 'warnings';

on configure => sub {
    requires 'Module::Build::Tiny', '0.034';
};

on test => sub {
    requires 'Test::More', '0.96';
};

on develop => sub {
    requires 'Dist::Milla', 'v1.0.17';
    requires 'Test::Pod', '1.41';
};
