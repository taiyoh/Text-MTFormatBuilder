package Text::MTFormatBuilder::Entry;

use Any::Moose;

use Text::MTFormatBuilder::MetaData;
use Text::MTFormatBuilder::Comment;
use Text::MTFormatBuilder::Ping;

has delimiter => (is => 'ro', isa => 'Str', default => sub { "-----\n" } );

my @keys = qw/body extended_body excerpt/;
has [@keys] => (
    is   => 'rw',
    isa  => 'Str',
);

has metadata => (
    is   => 'rw',
    isa  => 'Text::MTFormatBuilder::MetaData',
    handles => [qw/author title date primary_category
                   allow_comments allow_pings convert_breaks
                   append_category
                  /],
);

has comment => (
    is   => 'rw',
    isa  => 'ArrayRef[Text::MTFormatBuilder::Comment]',
    traits  => ['Array'],
    default => sub { [] },
    handles => {
        append_comment  => 'push',
        map_comments    => 'map',
        count_comments  => 'count',
        has_comment     => 'count',
        has_no_comments => 'is_empty',
    },
);

has ping => (
    is   => 'rw',
    isa  => 'ArrayRef[Text::MTFormatBuilder::Ping]',
    traits  => ['Array'],
    default => sub { [] },
    handles => {
        append_ping  => 'push',
        map_pings    => 'map',
        count_pings  => 'count',
        has_ping     => 'count',
        has_no_pings => 'is_empty',
    },
);

no Any::Moose;

sub BUILD {
    my $self = shift;
    $self->metadata(Text::MTFormatBuilder::MetaData->new);
}

sub export {
    my $self = shift;
    my $text = '';
    $text .= $self->metadata->export;
    $text .= join "", grep { $_ } map {
        return '' unless $self->$_;
        (my $u = $_) =~ s{_}{ }g;
        $u = uc $u;
        "${u}:\n" . $self->$_ . "\n"
            . $self->delimiter;
    } @keys;
    $text .= join '', $self->map_comments(sub { $_->export });
    $text .= join '', $self->map_pings(sub { $_->export });
    return $text;
}

sub add_comment {
    my $self = shift;
    $self->append_comment(Text::MTFormatBuilder::Comment->new(@_));
}

sub add_ping {
    my $self = shift;
    $self->append_ping(Text::MTFormatBuilder::Ping->new(@_));
}

__PACKAGE__->meta->make_immutable;
