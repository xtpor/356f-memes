
FROM bitwalker/alpine-elixir:1.5

RUN apk --no-cache --update upgrade busybox musl && \
    apk add --update nodejs nodejs-npm build-base sqlite

COPY startup /startup

WORKDIR "/opt/memes"

ENV PATH="${PATH}:/opt/memes/assets/node_modules/brunch/bin" \
    HOME="/opt" \
    PS1="\u:\w$ "
