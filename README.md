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

[geoipupdate] (https://github.com/maxmind/geoipupdate), follow instructions there

##### My GeoIP.conf for installing country and AS GeoLite databases

```
UserId 999999
LicenseKey 000000000000
ProductIds 506 517
DatabaseDirectory /usr/share/GeoIP
```

### Configuration

If ASN is not to be used, set ipdetective_asn to OFF

If the GeoLite databases reside in another directory than /usr/share/GeoIP, set ipdetective_db_dir to this directory (e.g. /home/user/mydbdir)
