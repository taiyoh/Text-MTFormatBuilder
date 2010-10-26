package Text::MTFormatBuilder::MetaData;

use Any::Moose;
with 'Text::MTFormatBuilder::Base';

my @param = qw/author title date primary_category convert_breaks status/;
my @booleans = qw/allow_comments allow_pings/;

has '+keys' => default => sub { [@param, @booleans] };
has [@param] => ( is => 'rw', isa  => 'Str' );
has [@booleans] => ( is => 'rw', isa  => 'Bool', default => 1 );

has '+convert_breaks' => default => sub { 0 };
has '+content' => default => sub { 1 };

has category => (
    traits     => ['Array'],
    is         => 'ro',
    isa        => 'ArrayRef[Str]',
    default    => sub { [] },
    handles => {
        append_category   => 'push',
        map_categories    => 'map',
        count_categories  => 'count',
        has_category      => 'count',
        has_no_categories => 'is_empty',
    },
);

# no_entry

sub export {
    my $self = shift;

    my $text = "";
    my @params1 = grep { $_ } map {
        (my $k = uc $_) =~ s{_}{ }g;
        my $v = $self->$_;
        defined($self->$_) ? "$k: $v" : '';
    } @param;
    my @params2 = grep { $_ } map {
        (my $k = uc $_) =~ s{_}{ }g;
        my $v = $self->$_ || 0;
        "$k: $v";
    } @booleans;
    my @cats  = grep { $_ } $self->map_categories(sub { "CATEGORY: ${_}"; });
    $text .= join "\n", (@params1, @params2, @cats);
    $text .= "\n" . $self->delimiter;

    return $text;
};

no Any::Moose;

__PACKAGE__->meta->make_immutable;
