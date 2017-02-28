package Main;

use MooseX::App::Command;
extends 'BioX::Workflow::Command::run';
with 'BioX::Workflow::Command::run::Utils::Rules';

option '+workflow' => ( required => 0, );

has 'text_obj' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
);

around 'eval_process' => sub {
    my $orig = shift;
    my $self = shift;

    my $text = $self->$orig(@_);

    if(! exists $self->text_obj->{$self->rule_name} ){
      $self->text_obj->{$self->rule_name} = [] ;
    }

    push(@{$self->text_obj->{$self->rule_name}}, $text);
};

package BioX::Workflow::Command::REST::run;

use strict;
use warnings;

use Main;
use HTTP::Status qw(:constants);
use Raisin::API;
use Types::Standard qw(HashRef Any Int Str ArrayRef);
use File::Temp qw/ tempfile tempdir /;
use Capture::Tiny ':all';

my $href = {
    global => [
        { sample_rule      => "Sample_(\\w+)" },
        { root_dir         => 'data/raw' },
        { indir            => '{$self->root_dir}' },
        { outdir           => 'data/processed' },
        { sample_bydir     => 1 },
        { by_sample_outdir => 1 },
    ],
    rules => [
        {
            t3_rule1 => {
                'local' => [
                    { root_dir => 'data/raw' },
                    { INPUT    => '{$self->root_dir}/some_input_rule1' },
                    { OUTPUT   => ['some_output_rule1'] },
                ],
                process =>
'R1: INDIR: {$self->indir} INPUT: {$self->INPUT} outdir: {$self->outdir} OUTPUT: {$self->OUTPUT->[0]}',
            },
        },
        {
            t3_rule2 => {
                'local' => [
                    { INPUT  => '{$self->root_dir}/some_input_rule2' },
                    { OUTPUT => ['some_output_rule2'] },
                ],
                process =>
'R2: SAMPLE: {$sample} INDIR: {$self->indir} INPUT: {$self->INPUT} outdir: {$self->outdir} OUTPUT: {$self->OUTPUT->[0]}',
            },
        },
        {
            t3_rule3 => {
                'local' => [ { indir => 'data/raw' }, ],
                process =>
'R3: SAMPLE: {$sample} INDIR: {$self->indir} INPUT: {$self->INPUT->[0]} outdir: {$self->outdir}',
            },
        },
    ]
};

api_format 'json';
api_default_format 'json';

desc 'Run a Workflow';
resource run => sub {
    summary 'List users';
    params(
        optional(
            'select_rules',
            type => ArrayRef [Str],
            default => [],
            desc    => 'Process one or more rules'
        ),
        optional(
            'samples',
            type => ArrayRef [Str],
            default => [ 'Sample_01', 'Sample_02' ],
            desc    => 'Process one or more samples'
        ),
        optional(
            'data',
            type => HashRef,
            desc => 'Workflow object',

            #TODO add global and rules here
            group {}
        ),
    );

    post sub {
        my $params = shift;

        print "Params are\n";
        use Data::Dumper;
        print Dumper($params);

        my $biox = Main->new();
        my $tmp_dir = tempdir( CLEANUP => 0 );
        chdir($tmp_dir);

        my $samples      = $params->{samples};
        my $data         = $params->{data};
        my $select_rules = $params->{select_rules};

        my ( $stdout, $stderr, $exit ) = capture {
            $biox->select_rules($select_rules);
            $biox->stdout(1);
            $biox->samples($samples);

            #TODO if using select don't want to print opts or start
            $biox->print_opts;
            $biox->workflow_data($data);
            print Dumper($biox->workflow_data);
            $biox->apply_global_attributes;

            $biox->global_attr->create_outdir(0);
            $biox->global_attr->coerce_abs_dir(0);
            $biox->get_global_keys;

            $biox->write_workflow_meta('start');

            $biox->iterate_rules;
        };

        { process_text => $stdout, logs => $stderr, text_obj => $biox->text_obj };
    };
};

1;
