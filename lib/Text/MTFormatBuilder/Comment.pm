package Text::MTFormatBuilder::Comment;

use Any::Moose;
with 'Text::MTFormatBuilder::Base';

my @keys = qw/author email url ip date/;
has '+keys' => default => sub { [@keys] };
has [@keys] => (is => 'rw', isa => 'Str');

no Any::Moose;

__PACKAGE__->meta->make_immutable;
