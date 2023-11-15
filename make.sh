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

#git clone https://github.com/asterisk/asterisk.git /asterisk
git clone -b 20 https://github.com/asterisk/asterisk asterisk
cd /asterisk
./configure
make
make menuselect
make install
make config
make samples

cd /tmp 
wget https://downloads.digium.com/pub/telephony/codec_opus/asterisk-20.0/x86-64/codec_opus-20.0_current-x86_64.tar.gz
tar xvzf codec_opus-20.0_current-x86_64.tar.gz
cp 'codec_opus-20.0_1.3.0-x86_64/*.so' '/usr/lib/asterisk/modules/'
cp 'codec_opus-20.0_1.3.0-x86_64/codec_opus_config-en_US.xml' '/var/lib/asterisk/documentation/thirdparty'

