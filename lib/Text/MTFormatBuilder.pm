package Text::MTFormatBuilder;
use strict;
use warnings;
use utf8;

our $VERSION = '0.02';

use Text::MTFormatBuilder::Entry;

sub import {
    my $caller = caller;
    return unless $_[0] ne '-Base';
    no strict 'refs';
    no warnings 'redefine';
    *{"${caller}::transaction"} = \&do_transaction;
    *{"${caller}::${_}"} = sub(&) { warn "DUMMY: $_"; } for (qw/metadata ping comment entry/);
    my @keys = qw/title url ip blog_name date body extended_body
                  excerpt author email primary_category convert_breaks status allow_comments allow_pings content/;
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
    my @list;
    for my $entry (@{ $self->{entries} }) {
        local $_ = $entry;
        push @list, $block->();
    }
    return @list;
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

            local *{"${caller}::metadata"} = sub(&) {
                return unless ( caller 2 )[3] =~ /::do_entry$/;
                my $metadata = Text::MTFormatBuilder::MetaData->new(content => 1);
                my @keys = qw/author title date primary_category convert_breaks status allow_comments allow_pings content/;
                for my $attr (@keys) {
                    *{"${caller}::${attr}"} = sub($) { $metadata->$attr($_[0]) };
                }
                $_[0]->();
                $entry->metadata($metadata);
            };
            local *{"${caller}::ping"} = sub(&) {
                return unless ( caller 2 )[3] =~ /::do_entry$/;
                my $ping = Text::MTFormatBuilder::Ping->new(content => 1);
                my @keys = qw/title url ip blog_name date content/;
                for my $attr (@keys) {
                    *{"${caller}::${attr}"} = sub($) { $ping->$attr($_[0]) };
                }
                $_[0]->();
                $entry->append_ping($ping);
            };
            local *{"${caller}::comment"} = sub(&) {
                return unless ( caller 2 )[3] =~ /::do_entry$/;
                my $comment = Text::MTFormatBuilder::Comment->new(content => 1);
                my @keys = qw/author email url ip date content/;
                for my $attr (@keys) {
                    *{"${caller}::${attr}"} = sub($) { $comment->$attr($_[0]) };
                }
                $_[0]->();
                $entry->append_comment($comment);
            };

            local *{"${caller}::body"}          = sub($) { $entry->body(@_) if ( caller 2 )[3] =~ /::do_entry$/; };
            local *{"${caller}::extended_body"} = sub($) { $entry->extended_body(@_) if ( caller 2 )[3] =~ /::do_entry$/; };
            local *{"${caller}::excerpt"}       = sub($) { $entry->excerpt(@_) if ( caller 2 )[3] =~ /::do_entry$/; };

            $block->();
        };

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
