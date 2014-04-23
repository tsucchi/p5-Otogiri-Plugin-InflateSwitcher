package Otogiri::Plugin::InflateSwitcher;
use 5.008005;
use strict;
use warnings;
use parent qw(Otogiri::Plugin);

our $VERSION = "0.01";

our @EXPORT = qw(enable_inflate disable_inflate);

sub enable_inflate {
    my ($self) = @_;
    return if ( !defined $self->{inflate_backup} || defined $self->{inflate} );

    $self->{inflate} = delete $self->{inflate_backup};
}

sub disable_inflate {
    my ($self) = @_;
    if ( defined $self->{inflate} ) {
        $self->{inflate_backup} = delete $self->{inflate};
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

=head1 DESCRIPTION

Otogiri::Plugin::InflateSwitcher is plugin for L<Otogiri> to enable or disable inflate feature

=head1 LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takuya Tsuchida E<lt>tsucchi@cpan.orgE<gt>

=cut

