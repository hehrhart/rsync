FROM alpine:3.10.2

LABEL maintainer="Gal1le0 <herve@start-to-up.com>"

ARG RSA_KEY

ENV PATH_ID_RSA=/root/.ssh/id_rsa
ENV SYNC_PORT=22
ENV SYNC_EXCLUDE_PATH_FILE=/exclude-list.txt
ENV SYNC_SRC=/root/sync/

RUN apk update \
 && apk add openssh rsync expect \
 && touch $SYNC_EXCLUDE_PATH_FILE \
 && mkdir /root/.ssh \
 && chmod 700 /root/.ssh \
 && echo $RSA_KEY | base64 -d > /root/.ssh/id_rsa \
 && chmod 600 /root/.ssh/id_rsa

COPY /docker-entrypoint.sh /

RUN chmod 755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]