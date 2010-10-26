package Text::MTFormatBuilder::Base;

use Any::Moose 'Role';

has keys => (
    is      => 'rw',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
);

has content => ( is => 'rw', isa => 'Str', required => 1,);
has delimiter => ( is => 'ro', 'isa' => 'Str', default => sub { "-----\n" } );

no Any::Moose 'Role';

sub export {
    my $self = shift;
    my $section = uc((split('::', ref($self)))[-1]);

    my $text = "${section}:\n";
    my @params = grep { $_ } map {
        (my $k = uc $_) =~ s{_}{ }g;
        my $v = $self->$_;
        $v ? "$k: $v" : '';
    } @{ $self->keys };
    if (@params) {
        $text .= join "\n", @params;
        $text .= "\n";
    }
    $text .= $self->content. "\n";
    $text .= $self->delimiter;

    return $text;
}

1;
