# ai <ruby>愛<rp>(</rp><rt>あい</rt><rp>)</rp></ruby>

> Phoenix & Elixir JSON API powering mirai.audio.

[![CircleCI](https://img.shields.io/circleci/project/github/mirai-audio/ai.svg?style=flat-square)](https://circleci.com/gh/mirai-audio/ai)

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

These are done when bootstrapping a new Phoenix project.

```bash
mix local.hex --force && \  # install hex package manager
  mix local.rebar --force
# install phoenix framework
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
mix project.new .  # scaffold a new Phoenix project

# generate a json-api endpoint for a model
mix ja_serializer.gen.phoenix_api \
  <Model_name> <model_names> \
  <column_name>:<type> [<column_name>:<type>]
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
  mix phoenix.server
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

