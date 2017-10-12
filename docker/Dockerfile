
FROM bitwalker/alpine-elixir:1.5

RUN apk add --update nodejs nodejs-npm

COPY startup.sh /startup.sh

RUN chmod u+x /startup.sh && mv /startup.sh /startup
