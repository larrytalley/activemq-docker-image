FROM codenvy/centos_jdk8
MAINTAINER Larry TALLEY <larry.talley@gmail.com>

# from https://hub.docker.com/r/rmohr/activemq/~/dockerfile
# and https://github.com/granthbr/docker-activeMQ-OracleJava-7/blob/master/Dockerfile
ENV ACTIVEMQ_VERSION 5.14.1
ENV ACTIVEMQ apache-activemq-$ACTIVEMQ_VERSION
ENV ACTIVEMQ_TCP=61616 ACTIVEMQ_AMQP=5672 ACTIVEMQ_STOMP=61613 ACTIVEMQ_MQTT=1883 ACTIVEMQ_WS=61614 ACTIVEMQ_UI=8161

ENV ACTIVEMQ_HOME /opt/activemq

RUN curl -LO https://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$ACTIVEMQ-bin.tar.gz && \
    tar zxvf $ACTIVEMQ-bin.tar.gz && \
    ln -sf $ACTIVEMQ ACTIVEMQ_HOME
    ln -sf $ACTIVEMQ_HOME/bin/activemq /etc/init.d/ && \
    update-rc.d activemq defaults && \
    addgroup -S activemq && adduser -S -H -G activemq -h $ACTIVEMQ_HOME activemq && \
    chown -R activemq:activemq $ACTIVEMQ_HOME && \
    chown -h activemq:activemq $ACTIVEMQ_HOME && \
    /etc/init.d/activemq setup /etc/default/activemq

# Use our own /etc/default/activemq to activate jmx
#ADD etc/default /etc/default

USER activemq

WORKDIR $ACTIVEMQ_HOME
EXPOSE $ACTIVEMQ_TCP $ACTIVEMQ_AMQP $ACTIVEMQ_STOMP $ACTIVEMQ_MQTT $ACTIVEMQ_WS $ACTIVEMQ_UI

CMD ["/bin/sh", "-c", "bin/activemq console"]
