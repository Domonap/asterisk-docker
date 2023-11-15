FROM debian:buster-slim as builder

LABEL maintainer="info@domonap.ru"

#USER root

COPY ${PWD}/make.sh /

COPY ${PWD}/entrypoint.sh /entrypoint.sh
#COPY ${PWD}/docker-entrypoint.sh /docker-entrypoint.sh
#COPY ${PWD}/docker-common.sh /docker-common.sh
#COPY ${PWD}/docker-config.sh /docker-config.sh
#COPY ${PWD}/docker-service.sh /docker-service.sh

RUN chmod +x /make.sh && /make.sh

FROM debian:buster-slim as final

COPY ${PWD}/install.sh /install.sh

RUN chmod +x /install.sh && /install.sh

COPY --from=builder --chown=asterisk:asterisk /usr/lib/libasterisk* /usr/lib/
COPY --from=builder --chown=asterisk:asterisk /usr/lib/asterisk/ /usr/lib/asterisk/
COPY --from=builder --chown=asterisk:asterisk /var/spool/asterisk/ /var/spool/asterisk/
COPY --from=builder --chown=asterisk:asterisk /var/log/asterisk/ /var/log/asterisk/
COPY --from=builder --chown=asterisk:asterisk /usr/sbin/asterisk /usr/sbin/asterisk
COPY --from=builder --chown=asterisk:asterisk /etc/asterisk/ /etc/asterisk/
COPY --from=builder --chown=asterisk:asterisk /etc/init.d/asterisk /etc/init.d/
COPY --from=builder --chown=asterisk:asterisk /var/lib/asterisk/ /var/lib/asterisk/

COPY --from=builder /entrypoint.sh /entrypoint.sh

#COPY --from=builder /docker-entrypoint.sh /docker-entrypoint.sh
#COPY --from=builder /docker-common.sh /docker-common.sh
#COPY --from=builder /docker-config.sh /docker-config.sh
#COPY --from=builder /docker-service.sh /docker-service.sh

COPY ${PWD}/asterisk.conf /etc/supervisor/conf.d/asterisk.conf

EXPOSE 5060/udp 5060/tcp 8088/tcp 5038/tcp 10000-11000/udp

VOLUME /var/lib/asterisk/sounds /var/lib/asterisk/keys /var/lib/asterisk/phoneprov /var/spool/asterisk /var/log/asterisk /etc/asterisk
 
 
USER asterisk
WORKDIR ${PWD} 
RUN ["chmod", "+x", "/entrypoint.sh"] 
#RUN chmod +x /entrypoint.sh
 
ENTRYPOINT [ "/entrypoint.sh" ]

COPY ./entrypoint.sh /app
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]


#RUN chmod 0777 /entrypoint.sh 
#RUN mkdir /app  
#USER asterisk 
#COPY ./entrypoint.sh /app
#RUN chmod +x /app/entrypoint.sh
#ENTRYPOINT ["/app/entrypoint.sh"]

#ENV	SVDIR=/etc/service \
#	DOCKER_PERSIST_DIR=/srv \
#	DOCKER_BIN_DIR=/usr/local/bin \
#	DOCKER_ENTRY_DIR=/etc/docker/entry.d \
#	DOCKER_EXIT_DIR=/etc/docker/exit.d \
#	DOCKER_PHP_DIR=/usr/share/php81 \
#	DOCKER_SPOOL_DIR=/var/spool/asterisk \
#	DOCKER_CONF_DIR=/etc/asterisk \
#	DOCKER_LOG_DIR=/var/log/asterisk \
#	DOCKER_LIB_DIR=/var/lib/asterisk \
#	DOCKER_DL_DIR=/usr/lib/asterisk/modules \
#	DOCKER_NFT_DIR=/etc/nftables.d \
#	DOCKER_SEED_CONF_DIR=/usr/share/asterisk/config \
#	DOCKER_SEED_NFT_DIR=/usr/share/nftables \
#	DOCKER_SSL_DIR=/etc/ssl \
#	ACME_POSTHOOK="sv restart asterisk" \
#	SYSLOG_LEVEL=4 \
#	SYSLOG_OPTIONS=-SDt \
#	WEBSMSD_PORT=80
#ENV	DOCKER_MOH_DIR=$DOCKER_LIB_DIR/moh \
#	DOCKER_ACME_SSL_DIR=$DOCKER_SSL_DIR/acme \
#	DOCKER_APPL_SSL_DIR=$DOCKER_SSL_DIR/asterisk
# 
#
#ENTRYPOINT [ "/docker-entrypoint.sh" ]

#CMD	runsvdir -P ${SVDIR} 
#HEALTHCHECK CMD sv status ${SVDIR}/*



