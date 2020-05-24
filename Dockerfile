FROM openjdk:8u212-jre-alpine

ENV KAFKA_VERSION 2.5.0
ENV SCALA_VERSION 2.12

RUN wget https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -P /root
#COPY ./copy/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz /root
RUN mkdir /root/kafka
RUN tar xzf /root/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz --strip-components=1 -C /root/kafka
RUN rm /root/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

COPY ./copy/start.sh /root/kafka
RUN chmod +x /root/kafka/start.sh

RUN apk add --no-cache bash mc
RUN sed -i 's/log.dirs=.*/log.dirs=\/logs/' /root/kafka/config/server.properties
RUN sed -i 's/log.retention.hours=.*/log.retention.hours=2160/' /root/kafka/config/server.properties
#RUN sed -i 's/log.segment.bytes=.*/log.segment.bytes=10000/' /root/kafka/config/server.properties

VOLUME ["/logs"]

WORKDIR /logs
EXPOSE  9092 2181
# ENTRYPOINT [ "sh" ]
CMD [ "/root/kafka/start.sh" ]