package Text::MTFormatBuilder;
use strict;
use warnings;
use utf8;

our $VERSION = '0.03.1';

use Text::MTFormatBuilder::Entry;

sub import {
    my $caller = caller;
    return unless $_[0] ne '-Declare';
    no strict 'refs';
    no warnings 'redefine';
    *{"${caller}::blog_export"} = \&do_transaction;
    *{"${caller}::${_}"} = sub(&) { warn "DUMMY: $_"; } for (qw/metadata ping comment entry/);
    my @keys = qw/title url ip blog_name date body extended_body
                  excerpt author email primary_category category
                  convert_breaks status allow_comments allow_pings content/;
    for my $p (@keys) {
        *{"${caller}::${p}"} = sub($) { warn "DUMMY: $p"; };
    }
}

sub delimiter() { "--------\n" }

sub new {
    my $package = shift;
    my %args = @_ > 1 ? @_ : %{ $_[0] || {} };
    $args{entries} = [];
    bless \%args, $package;
}

sub append_entry {
    my $self = shift;
    push @{ $self->{entries} }, shift;
}

sub map_entries {
    my $self  = shift;
    my $block = shift;
    return map { $block->() } @{ $self->{entries} };
}

do {
    my $builder;

    sub do_transaction(&) {
        $builder = __PACKAGE__->new;
        no strict 'refs';
        no warnings 'redefine';
        local *{caller(0)."::entry"} = \&do_entry;
        $_[0]->();
        return $builder->export;
    }

    sub do_entry(&) {
        my $block  = shift;

        my ($caller, undef, undef, $func) = caller(2);
        return unless $func =~ /::do_transaction$/;

        my $entry = Text::MTFormatBuilder::Entry->new;
        do {
            no strict 'refs';
            no warnings 'redefine';

            *{"${caller}::metadata"} = sub(&) {
                return unless ( caller 2 )[3] =~ /::do_entry$/;
                my $metadata = Text::MTFormatBuilder::MetaData->new(content => 1);
                my @keys = @{ $metadata->keys };
                push @keys, 'content';
                for my $attr (@keys) {
                    *{"${caller}::${attr}"} = sub($) { $metadata->$attr($_[0]) };
                }
                *{"${caller}::category"} = sub($) { $metadata->append_category($_[0]) };
                $_[0]->($metadata);
                $entry->metadata($metadata);
            };

            for my $info (qw/Ping Comment/) {
                my $info_lc = lc $info;
                *{"${caller}::${info_lc}"} = sub(&) {
                    return unless ( caller 2 )[3] =~ /::do_entry$/;
                    my $class = "Text::MTFormatBuilder::${info}";
                    my $obj = $class->new(content => 1);
                    my @keys = @{ $obj->keys };
                    push @keys, 'content';
                    for my $attr (@keys) {
                        *{"${caller}::${attr}"} = sub($) { $obj->$attr($_[0]) };
                    }
                    $_[0]->($obj);
                    my $append = "append_${info_lc}";
                    $entry->$append($obj);
                };
            }

            *{"${caller}::body"}          = sub($) { $entry->body(@_) if ( caller 2 )[3] =~ /::do_entry$/; };
            *{"${caller}::extended_body"} = sub($) { $entry->extended_body(@_) if ( caller 2 )[3] =~ /::do_entry$/; };
            *{"${caller}::excerpt"}       = sub($) { $entry->excerpt(@_) if ( caller 2 )[3] =~ /::do_entry$/; };
        };
        $block->($entry);

        $builder->append_entry($entry);
    }
};

sub export {
    my $self = shift;
    my @entries = $self->map_entries(sub { $_->export });
    my $exports = join delimiter(), (@entries, '');
    return $exports;
}

1;
__END__

=head1 NAME

Text::MTFormatBuilder -

=head1 SYNOPSIS

  use Text::MTFormatBuilder;

=head1 DESCRIPTION

Text::MTFormatBuilder is

=head1 AUTHOR

Taiyoh Tanaka E<lt>sun.basix@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
