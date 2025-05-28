FROM alpine:3.21

RUN apk add --no-cache docker-cli-compose

COPY main.sh /main.sh

RUN chmod +x /main.sh

ENTRYPOINT ["/main.sh"]
