FROM alpine:latest

LABEL Maintainer="Ernesto Pérez <eperez@isotrol.com>" \
      Name="Forticlient_cli" \
      Description="Imágen con el servicio forticlient_cli" \
      Version="0.1.0"

# Install dependency
RUN echo '@community http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories \
    && apk add --update --no-cache ca-certificates wget iproute2 ppp ppp-daemon bash expect file libgcc libstdc++ gcompat@community


WORKDIR /opt

# Install fortivpn client unofficial .deb
RUN wget 'https://tianyublog.com/res/forticlient.tar.gz' -O forticlient-sslvpn.tgz \
    && tar -xzf forticlient-sslvpn.tgz \
    && rm -rf forticlient-sslvpn.tgz \
    && bash forticlient/helper/setup.linux.sh 2 \
    && echo $'debug dump\n\
lock\n\
noauth\n\
proxyarp\n\
nodefaultroute\n\
modem\n\
noipdefault\n\
lcp-echo-interval 60\n\
lcp-echo-failure 4\n\
' > /etc/ppp/options

# Copy runfiles
COPY forticlient /usr/bin/forticlient
COPY start.sh /start.sh

CMD [ "/start.sh" ]
