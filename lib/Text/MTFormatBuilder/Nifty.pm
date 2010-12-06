package Text::MTFormatBuilder::Nifty;

use strict;
use warnings;
use base 'Text::MTFormatBuilder';

push @Text::MTFormatBuilder::Entry::keys, 'keywords';

use Mouse::Meta::Class;

my $meta = Mouse::Meta::Class->initialize('Text::MTFormatBuilder::Entry');

$meta->add_attribute(
    keywords =>
        is   => 'rw',
        isa  => 'Str',
);

$meta->add_around_method_modifier(
    export => sub {
        my $orig = shift;
        my $self = shift;
        my $text = '';
        $text .= $self->metadata->export;
        $text .= join "", grep { $_ } map {
            (my $u = $_) =~ s{_}{ }g;
            my $str = $self->$_ || '';
            $u = uc $u;
            "${u}:\n${str}\n" . $self->delimiter;
        } @Text::MTFormatBuilder::Entry::keys;
        $text .= join '', $self->map_comments(sub { $_->export });
        $text .= join '', $self->map_pings(sub { $_->export });
        $text .= "\n\n";
        return $text;
    }
);

sub export {
    my $self = shift;
    my @entries = $self->map_entries(sub { $_->export });
    $entries[-1] = "\n\n";
    my $exports = join delimiter(), (@entries, '');
    return $exports;
}

1;
