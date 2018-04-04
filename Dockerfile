FROM ruby:2.5-alpine

RUN apk update && apk add coreutils git make g++ nodejs

RUN git clone https://github.com/lord/slate

WORKDIR /slate

RUN git checkout v2.2

RUN bundler install --deployment

COPY ["source", "/slate/source/"]

ENTRYPOINT bundler exec middleman build --clean
