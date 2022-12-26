FROM alpine:3.17 as builder

RUN apk add --no-cache \
        curl \
        jq \
    && LATEST_VERSION=$(curl -s 'https://papermc.io/api/v2/projects/paper' | jq -r '.versions[-1]') \
    && LATEST_BUILD=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/${LATEST_VERSION}" | jq -r '.builds[-1]') \
    && curl -s "https://api.papermc.io/v2/projects/paper/versions/${LATEST_VERSION}/builds/${LATEST_BUILD}/downloads/paper-${LATEST_VERSION}-${LATEST_BUILD}.jar" -o /tmp/paper.jar

FROM alpine:3.17

ARG MINECRAFT_UID=1000
ARG MINECRAFT_GID=1000

RUN apk add --no-cache \
        bash \
        curl \
        openjdk17-jre-headless\
        screen \
        supervisor \
        tzdata

RUN cp -a /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && addgroup -g $MINECRAFT_GID -S minecraft \
    && adduser -u $MINECRAFT_UID -S minecraft -G minecraft minecraft \
    && mkdir -p /data \
    && chown minecraft /data \
    && chmod o+r /etc/supervisord.conf

COPY --from=builder /tmp/paper.jar /usr/local/bin/
COPY start.sh /usr/local/bin/
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 25565
EXPOSE 19132/udp

USER minecraft
WORKDIR /data

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
