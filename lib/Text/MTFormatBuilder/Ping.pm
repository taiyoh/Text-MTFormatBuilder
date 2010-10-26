package Text::MTFormatBuilder::Ping;

use Any::Moose;
with 'Text::MTFormatBuilder::Base';

my @keys = qw/title url ip blog_name date/;
has '+keys' => default => sub { [@keys] };
has [@keys] => ( is => 'rw', isa => 'Str',);

__PACKAGE__->meta->make_immutable;
