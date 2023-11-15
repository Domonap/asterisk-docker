#!/bin/sh

apt-get update

apt-get install -y \
  build-essential \
  curl \
  git \
  gzip \
  libedit-dev \
  libjansson-dev \
  libldap2-dev \
  libncurses5-dev \
  libsqlite3-dev \
  libsrtp2-dev \
  libssl-dev \
  libuuid1 \
  libxml2-dev \
  odbc-postgresql \
  openssl \
  postgresql-client \
  sqlite3 \
  tar \
  unixodbc \
  unixodbc-dev \
  uuid-dev \
  wget

git clone -b 20 https://github.com/asterisk/asterisk.git /asterisk-20
cd /asterisk-20
./configure
make
make menuselect
make install
make config
make samples

cd /tmp

wget https://v-piski.ru/wp-content/uploads/codec_opus.tar.gz
tar xvzf codec_opus.tar.gz
cp codec_opus/*.so /usr/lib/asterisk/modules/
cp codec_opus/codec_opus_config-en_US.xml /var/lib/asterisk/documentation/thirdparty