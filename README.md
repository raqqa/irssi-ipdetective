### Dependencies

#### GeoIP C API

In Debian/Ubuntu,

```
sudo apt-get install libgeoip-dev
```

OR

follow instructions at https://github.com/maxmind/geoip-api-c

#### Geo::IP perl module

```
sudo cpan
install Geo::IP
```

OR

Follow instructions at http://search.cpan.org/~maxmind/Geo-IP-1.45/

#### Regexp::Common::net perl module

```
sudo cpan
install Regexp::Common::net
```

#### geoipupdate (recommended)

* [geoipupdate] (https://github.com/maxmind/geoipupdate), follow instructions there for installation
* Replace the /usr/local/etc/GeoIP.conf (on Debian/Ubuntu at least) with the below GeoIP.conf
* sudo geoipupdate

OR

* Download the GeoLite ASN (optional) and GeoLite Country manually from [GeoLite Legacy Downloadable Databases] (http://dev.maxmind.com/geoip/legacy/geolite/)
* Extract to /usr/share/GeoIP (or another place, but change settings according to Configuration section below), do not change the names of the files (GeoLiteASNum.dat & GeoLiteCountry.dat)

##### My GeoIP.conf for installing country and AS GeoLite databases

```
UserId 999999
LicenseKey 000000000000
ProductIds 506 517
DatabaseDirectory /usr/share/GeoIP
```

### Configuration

Toggle if the script does lookups on recevied IPs, either in query or in channel, does not impact manual lookup,
```
/set ipdetective_enabled OFF|ON
```

If ASN is not to be used, in irssi,
```
/set ipdetective_asn OFF
```

If the GeoLite databases reside in another directory than /usr/share/GeoIP, in irssi,
```
/set ipdetective_db_dir /home/user/mydbdir
```

Toggle lookups on IP's received in private messages,
```
/set ipdetective_query OFF|ON
```

Specify a space separated list of channels to look up IPs from, used in combination with setting below
```
/set ipdetective_specific_channels OFF|ON
```

Toggle lookups on IP's only from specific channels,
```
/set ipdetective_specific_channels OFF|ON
```

### Usage

To make a manual lookup,
```
/ipdetective <ip>
```
e.g. /ipdetective 8.8.8.8
