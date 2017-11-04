# ai <ruby>愛<rp>(</rp><rt>あい</rt><rp>)</rp></ruby>

[![CircleCI](https://img.shields.io/circleci/project/github/mirai-audio/ai.svg?style=flat-square)](https://circleci.com/gh/mirai-audio/ai)
[![Coveralls branch](https://img.shields.io/coveralls/mirai-audio/ai/master.svg?style=flat-square)](https://coveralls.io/github/mirai-audio/ai?branch=master)
[![Phoenix](https://img.shields.io/badge/Phoenix-1.3-blue.svg?style=flat-square)](http://phoenixframework.org/)
[![StackShare](https://img.shields.io/badge/stack-share-0690fa.svg?style=flat-square)](https://stackshare.io/mirai-audio/mirai-audio)

_Phoenix & Elixir JSON API powering mirai.audio_


## Docs

* [CODE_OF_CONDUCT](https://github.com/mirai-audio/mir/wiki/CODE_OF_CONDUCT)
* [CONTRIBUTING](https://github.com/mirai-audio/mir/blob/master/.github/CONTRIBUTING.md)


## Prerequisites

You will need the following tools properly installed:

* [Git](https://git-scm.com/)
* [Elixir](http://elixir-lang.org/)
* [Docker](https://www.docker.com/)

```bash
brew install elixir  # installs Erlang & Elixir
mix local.hex  # install hex package manager
brew cask install docker  # used to run PostgreSQL
```


## Running / Development

Run the PostgreSQL db server (via Docker)

```bash
docker run -it -p 5432:5432 --rm \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=postgres \
  --name postgres \
  postgres
```


### Environment variables

The following environment variables are available to override fallback (dev)
configuration, it works best to add them to a `.env` file.

```bash
ENV_AI_MIR_URL=https://mirai.audio       # URL of Mir, frontend
ENV_AI_DB_URL=ecto://postgres:postgres@localhost/ai_dev
ENV_AI_HOST=api.mirai.audio
ENV_AI_PORT=4000
ENV_AI_SECRET_KEY_BASE=<64-char string>
ENV_AI_GUARDIAN_SECRET_KEY=<64-char random string>
ENV_AI_DB_POOL_SIZE=20
ENV_AI_TWITTER_CONSUMER_KEY=changeme     # Twitter OAuth Consumer Key (API Key)
ENV_AI_TWITTER_CONSUMER_SECRET=changeme  # Twitter OAuth Consumer Secret (API Secret)
```

To create the database schema, run migrations and start Phoenix:

```bash
# set .env file environment variables 
export $(cat .env | xargs) && \
  mix ecto.setup && \
  mix phx.server
```

Now you can visit [localhost:4000](localhost:4000) from your browser.

### Running Tests

```bash
mix test
```


## LICENSE

[MIT](LICENSE)

A product of <ruby>
  <ruby>
    青<rp>(</rp><rt>せい</rt><rp>)</rp>
    心<rp>(</rp><rt>しん</rt><rp>)</rp>
    工<rp>(</rp><rt>こう</rt><rp>)</rp>
    機<rp>(</rp><rt>き</rt><rp>)</rp>
  </ruby>
  <rp>(</rp><rt>seishinkouki</rt><rp>)</rp>
</ruby> Co., Ltd
