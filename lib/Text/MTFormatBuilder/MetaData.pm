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

has [qw/tags category/] => (
    is         => 'rw',
    isa        => 'ArrayRef[Str]',
    default    => sub { [] },
);

# no_entry

sub append_category {
    my $self = shift;
    my $cat  = shift or die;
    my @cats = @{ $self->category };
    push @cats, $cat;
    $self->category(\@cats);
}

sub map_categories {
    my $self  = shift;
    my $block = shift;
    return map { $block->() } @{ $self->category };
}


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
    my @tags  = @{ $self->tags };
    if (@tags) {
        $text .= "\nTAGS: ".join(',', @tags);
    }
    $text .= "\n" . $self->delimiter;

    return $text;
};

no Any::Moose;

__PACKAGE__->meta->make_immutable;
