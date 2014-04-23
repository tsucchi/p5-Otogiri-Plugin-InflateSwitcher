[![Build Status](https://travis-ci.org/tsucchi/p5-Otogiri-Plugin-InflateSwitcher.png?branch=master)](https://travis-ci.org/tsucchi/p5-Otogiri-Plugin-InflateSwitcher) [![Coverage Status](https://coveralls.io/repos/tsucchi/p5-Otogiri-Plugin-InflateSwitcher/badge.png?branch=master)](https://coveralls.io/r/tsucchi/p5-Otogiri-Plugin-InflateSwitcher?branch=master)
# NAME

Otogiri::Plugin::InflateSwitcher - Otogiri plugin to enable/disable inflate

# SYNOPSIS

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

# DESCRIPTION

Otogiri::Plugin::InflateSwitcher is plugin for [Otogiri](https://metacpan.org/pod/Otogiri) to enable or disable inflate feature

# LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Takuya Tsuchida <tsucchi@cpan.org>
