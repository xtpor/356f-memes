#!/bin/bash

cd /opt/memes

if [ ! -d "deps" ]; then
    mix local.hex --force
    mix deps.get
fi

if [ ! -d "assets/node_modules" ]; then
    npm install --prefix assets
fi

if [ ! -d "priv/static" ]; then
    npm run build --prefix assets
fi

mix local.rebar --force
iex -S mix
