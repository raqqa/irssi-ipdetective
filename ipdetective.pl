#!/usr/bin/perl
use strict;
use vars qw($VERSION %IRSSI);
$VERSION = '0.10';
%IRSSI = (
    authors => 'raqqa',
    contact => 'raqqa\@budskap.eu',
    name => 'ipdetective',
    description => 'Detects IP-addresses in channels and PMs, outputs; country code, country name, optionally ASN',
    license => 'Public Domain'
);

use Irssi qw(
    command_bind
    settings_get_bool settings_add_bool
    settings_get_str  settings_add_str
    signal_add_last
);
use Irssi::Irc;

use Geo::IP;
use Regexp::Common qw /net/;

sub watch_for_ip {
    my ($server,$msg,$nick,$address,$target) = @_;
    if (!settings_get_bool('ipdetective_enabled')) {
        return;
    }
    my @channels = split(" ", settings_get_str('ipdetective_channels'));
    if (settings_get_bool('ipdetective_specific_channels')) {
        if (!grep(/^$target$/, @channels)) {
            return;
        }
    }
    if ($msg =~ /$RE{net}{IPv4}{-keep}/) {
        my ($country_code, $country_name, $isp) = ip_lookup($1);
        if (settings_get_bool('ipdetective_asn')) {
            Irssi::print("\x02\x0304IPDETECTIVE\x03\x02: \x02\x0308$1\x03\x02 (%9$isp - $country_code - $country_name%9), in \x02\x0311$target\x03\x02 from \x02\x0311$nick\x03\x02");
        } else {
            Irssi::print("\x02\x0304IPDETECTIVE\x03\x02: \x02\x0308$1\x03\x02 (%9$country_code - $country_name%9), in \x02\x0311$target\x03\x02 from \x02\x0311$nick\x03\x02");
        }
    }
    return;
}

sub watch_for_ip_private {
    if (!settings_get_bool('ipdetective_enabled') || !settings_get_bool('ipdetective_query')) {
        return;
    }
    my ($server,$msg,$nick,$address) = @_;
    if ($msg =~ /$RE{net}{IPv4}{-keep}/) {
        my ($country_code, $country_name, $isp) = ip_lookup($1);
        if (settings_get_bool('ipdetective_asn')) {
            Irssi::print("\x02\x0304IPDETECTIVE\x03\x02: \x02\x0308$1\x03\x02 (%9$isp - $country_code - $country_name%9), PM from \x02\x0311$nick\x03\x02");
        } else {
            Irssi::print("\x02\x0304IPDETECTIVE,\x03\x02 \x02\x0308$1\x03\x02 (%9$country_code - $country_name%9), PM from \x02\x0311$nick\x03\x02");
        }
    }
    return;
}

sub ip_lookup {
    my ($target_addr) = @_;
    my $country_code = "";
    my $country_name = "";
    my $isp = "";
    my $gi;
    my $gi2;
    if (settings_get_str('ipdetective_geodb_dir') eq "") {
        $gi = Geo::IP->open('/usr/share/GeoIP/GeoLiteCountry.dat',GEOIP_STANDARD);
        if (settings_get_bool('ipdetective_asn')) {
            $gi2 = Geo::IP->open('/usr/share/GeoIP/GeoLiteASNum.dat', GEOIP_STANDARD);
            $isp = $gi2->name_by_addr($target_addr);
        }
    } elsif (settings_get_str('ipdetective_geodb_dir') ne "") {
        $gi = Geo::IP->open(settings_get_str('ipdetective_geodb_dir') . 'GeoLiteCountry.dat',GEOIP_STANDARD);
        if (settings_get_bool('ipdetective_asn')) {
            $gi2 = Geo::IP->open(settings_get_str('ipdetective_geodb_dir') . 'GeoLiteASNum.dat', GEOIP_STANDARD);
            $isp = $gi2->name_by_addr($target_addr);
        }
    } else {
        $gi = Geo::IP->new(GEOIP_STANDARD);
    }
    $country_code = $gi->country_code_by_addr($target_addr);
    $country_name = $gi->country_name_by_addr($target_addr);
    return ($country_code, $country_name, $isp);
}

sub command_ipdetective {
    my ($data, $server, $channel) = @_;
    if ($data !~ m/^$RE{net}{IPv4}$/) {
        Irssi::print("\x02\x0304IPDETECTIVE\x03\x02: \"%9$data%9\" is not a valid IP address");
        Irssi::signal_stop();
        return;
    }
    my ($country_code, $country_name, $isp) = ip_lookup($data);
    if (settings_get_bool('ipdetective_asn')) {
        Irssi::print("\x02\x0304IPDETECTIVE\x03\x02: \x02\x0308$data\x03\x02 (%9$isp - $country_code - $country_name%9)");
    } else {
        Irssi::print("\x02\x0304IPDETECTIVE\x03\x02: \x02\x0308$data\x03\x02 (%9$country_code - $country_name%9)");
    }
}

signal_add_last 'message public' => \&watch_for_ip;
signal_add_last 'message private' => \&watch_for_ip_private;

settings_add_bool('ipdetective', 'ipdetective_enabled', 1);
settings_add_bool('ipdetective', 'ipdetective_query', 1);
settings_add_bool('ipdetective', 'ipdetective_asn', 1);
settings_add_bool('ipdetective', 'ipdetective_specific_channels', 0);

settings_add_str('ipdetective', 'ipdetective_channels', '');
settings_add_str('ipdetective', 'ipdetective_geodb_dir', '');

command_bind('ipdetective', \&command_ipdetective);
