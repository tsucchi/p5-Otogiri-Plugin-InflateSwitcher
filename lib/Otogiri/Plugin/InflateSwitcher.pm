package Otogiri::Plugin::InflateSwitcher;
use 5.008005;
use strict;
use warnings;
use parent qw(Otogiri::Plugin);

use Scope::Guard;

our $VERSION = "0.01";

our @EXPORT = qw(enable_inflate disable_inflate);

sub enable_inflate {
    my ($self) = @_;

    my $enabled = defined $self->{inflate};
    if ( defined $self->{inflate_backup} ) {
        $self->{inflate} = delete $self->{inflate_backup};
    }
    if ( defined wantarray() ) {
        return Scope::Guard->new( sub { $enabled ? $self->enable_inflate : $self->disable_inflate } );
    }
}

sub disable_inflate {
    my ($self) = @_;

    my $enabled = defined $self->{inflate};
    if ( defined $self->{inflate} ) {
        $self->{inflate_backup} = delete $self->{inflate};
    }
    if ( defined wantarray() ) {
        return Scope::Guard->new( sub { $enabled ? $self->enable_inflate : $self->disable_inflate } );
    }

}


1;
__END__

=encoding utf-8

=head1 NAME

Otogiri::Plugin::InflateSwitcher - Otogiri plugin to enable/disable inflate

=head1 SYNOPSIS

    use Otogiri;
    use Otogiri::Plugin::InflateSwitcher;
    my $db = Otogiri->new($connect_info);
    $db->disable_inflate;
    my $row = $db->single(...); # inflate is disabled
    $db->enable_inflate;
    $row = $db->single(...); # inflate is enabled

    # using guard
    my $guard1 = $db->enable_inflate;
    {
        my $guard2 = $db->disable_inflate;
        # inflate is disabled
    } #dismiss $guard2
    # inflate is enabled again

=head1 DESCRIPTION

Otogiri::Plugin::InflateSwitcher is plugin for L<Otogiri> to enable or disable inflate feature

=head1 LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takuya Tsuchida E<lt>tsucchi@cpan.orgE<gt>

=cut

