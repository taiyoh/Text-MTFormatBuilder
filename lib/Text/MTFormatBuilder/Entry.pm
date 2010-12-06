package Text::MTFormatBuilder::Entry;

use Any::Moose;

use Text::MTFormatBuilder::MetaData;
use Text::MTFormatBuilder::Comment;
use Text::MTFormatBuilder::Ping;

has delimiter => (is => 'ro', isa => 'Str', default => sub { "-----\n" } );

our @keys = qw/body extended_body excerpt/;
has [@keys] => (
    is   => 'rw',
    isa  => 'Str',
);

has metadata => (
    is   => 'rw',
    isa  => 'Text::MTFormatBuilder::MetaData',
    handles => [qw/author title date primary_category
                   allow_comments allow_pings convert_breaks
                   append_category status
                  /],
);

has comment => (
    is   => 'rw',
    isa  => 'ArrayRef[Text::MTFormatBuilder::Comment]',
    default => sub { [] },
);

has ping => (
    is   => 'rw',
    isa  => 'ArrayRef[Text::MTFormatBuilder::Ping]',
    default => sub { [] },
);

no Any::Moose;

sub BUILD {
    my $self = shift;
    $self->metadata(Text::MTFormatBuilder::MetaData->new);
}

sub append_comment {
    my $self = shift;
    my $c  = shift or die;
    my @cs = @{ $self->comment };
    push @cs, $c;
    $self->comment(\@cs);
}

sub map_comments {
    my $self  = shift;
    my $block = shift;
    return map { $block->() } @{ $self->comment };
}

sub append_ping {
    my $self = shift;
    my $p  = shift or die;
    my @ps = @{ $self->ping };
    push @ps, $p;
    $self->ping(\@ps);
}

sub map_pings {
    my $self  = shift;
    my $block = shift;
    return map { $block->() } @{ $self->ping };
}

sub export {
    my $self = shift;
    my $text = '';
    $text .= $self->metadata->export;
    $text .= join "", grep { $_ } map {
        if ($self->$_) {
            (my $u = $_) =~ s{_}{ }g;
            $u = uc $u;
            "${u}:\n" . $self->$_ . "\n"
                . $self->delimiter;
        }
        else {
            '';
        }
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

1;
