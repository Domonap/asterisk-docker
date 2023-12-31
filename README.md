# Asterisk 17 PBX


docker login 
docker build -t domonapapp/asterisk:20 .
docker system prune
docker push domonapapp/asterisk:20 


Since COPY copies files including their metadata, 
you can also simply change the permissions of the file in 
the host machine (the one building the Docker image): 
$ chmod +x entrypoint.sh

chown asterisk /etc
To change all the directories to 755 (drwxr-xr-x):

find /asterisk -type d -exec chmod 755 {} \;
To change all the files to 644 (-rw-r--r--):

find /asterisk -type f -exec chmod 644 {} \;
 
cdchown -R asterisk:asterisk asterisk

Uses `debian:buster-slim` because `uuid-dev` is not available in Alpine.

Builds Asterisk 17 from git master.

Multi-stage Dockerfile uses build-essential and git to clone from the git repository https://github.com/asterisk/asterisk.git

First stage installs the prerequisites and builds Asterisk from source. Second stage copies the compiled assets from the first, sets up the asterisk user and sets permissions.

> Includes the Festival Text-To-Speach Server and LDAP support.

> Now with opus codec from https://downloads.digium.com/pub/telephony/codec_opus/ and with res_rtsp as it was missing from earlier builds because of a non-included `librtsp2-dev`.

`/etc/asterisk` is populated with the config samples from `make samples`. Mount your own folder to overwrite the samples.

## Build

```shell
$ docker build -t domonapapp/asterisk:20 .
```

## Usage

```shell
$ docker run -v ${PWD}/etc/asterisk/:/etc/asterisk:rw ${PWD}/log/:/var/log/asterisk:rw domonapapp/asterisk bash
```

### docker-compose.yml

__Note:__ Use `network_mode: "host"` as the RTP service requires a large port range and it takes a long time to setup thousands of iptable rules if it uses a docker network.

```yaml
version: '3'

services:
  asterisk:
    image: domonapapp/asterisk:20
    volumes:
      - "${PWD}/etc/asterisk/:/etc/asterisk:rw"
      - "${PWD}/log:/var/log/asterisk:rw"
    network_mode: "host"
    ports:
      - "1314"
      - "5060:5060/tcp"
      - "5060:5060/udp"
      - "5038:5038"
      - "8088:8088"
      - "10000-20000:10000-20000/udp"
```

## LDAP Support

You will need to import the [`asterisk.ldif`](asterisk.ldif) schema into your LDAP configuration. This is an olc format file, if you need the older schema format you'll find it in the link below.

Full details are here: [Asterisk LDAP Integration](http://asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/ExternalServices_id291590.html)

## ODBC and PostgreSQL Support

Now build with ODBC and the postgresql-client to enble the use of real-time databases.

## Festival TTS

Festival is a default install listening on TCP port 1314 - but does not need to be exposed.

## Supervisor

Supervisor is used to start the two programs (festival and asterisk) within the container. The supervisor configuration is included as [`asterisk.conf`](./asterisk.conf)

Minor change to the asterisk startup to put it into non-colour console.


#wget https://downloads.digium.com/pub/telephony/codec_opus/asterisk-17.0/x86-64/codec_opus-17.0_current-x86_64.tar.gz
#tar xvzf codec_opus-17.0_current-x86_64.tar.gz
#cp codec_opus-17.0_1.3.0-x86_64/*.so /usr/lib/asterisk/modules/
#cp codec_opus-17.0_1.3.0-x86_64/codec_opus_config-en_US.xml /var/lib/asterisk/documentation/thirdparty