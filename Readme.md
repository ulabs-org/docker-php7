[![CircleCI](https://img.shields.io/circleci/project/github/ulabs-org/docker-php7.svg)](https://circleci.com/gh/ulabs-org/docker-php7/tree/master)
[![Docker Build Statu](https://img.shields.io/docker/build/imkulikov/php7.svg)](https://hub.docker.com/r/imkulikov/php7/)
[![Docker Stars](https://img.shields.io/docker/stars/imkulikov/php7.svg)](https://hub.docker.com/r/imkulikov/php7/)

# Alpine + PHP7

## Docker

###Build image

```sh
$ docker build -t php7 .
```

### Get image

```sh
$ docker pull imkulikov/php7
```

### Run image

```sh
$ docker run -d -p 9000:9000 --name php imkulikov/php7
```

### Preinstalled extensions:

```sh
$> php -m
[PHP Modules]
amqp
bcmath
bz2
Core
ctype
curl
date
dom
exif
fileinfo
filter
gd
gettext
gmp
hash
iconv
igbinary
imagick
intl
json
libxml
mbstring
mcrypt
memcached
mongodb
mysqli
mysqlnd
odbc
openssl
pcntl
pcre
PDO
pdo_dblib
pdo_mysql
PDO_ODBC
pdo_pgsql
pdo_sqlite
Phar
posix
readline
redis
Reflection
session
SimpleXML
soap
SPL
sqlite3
standard
tokenizer
xml
xmlreader
xmlrpc
xmlwriter
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
```

### It has composer?

- Yes, it's!