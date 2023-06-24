# syntax = docker/dockerfile:experimental
FROM ruby:3.2.2-slim-bullseye AS base

RUN mkdir /app
WORKDIR /app

SHELL ["/bin/bash", "-c"]

ARG RAILS_ENV="production"
ARG NODE_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}" \
    NODE_ENV="${NODE_ENV}" \
    PATH="/home/ruby/.local/bin:/node_modules/.bin:/usr/local/node/bin:${PATH}"

####################################################################################################

FROM base as build

RUN set -o pipefail \
  && apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl \
  && rm -rf /var/cache/apt/archives /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean

ADD https://github.com/benbjohnson/litestream/releases/download/v0.3.9/litestream-v0.3.9-linux-amd64-static.tar.gz /tmp/litestream.tar.gz
RUN tar -C /usr/local/bin -xzf /tmp/litestream.tar.gz

RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ \
  && /tmp/node-build-master/bin/node-build "16.13.0" /usr/local/node \
  && npm install -g yarn@1.22.10 \
  && rm -rf /tmp/node-build-master

COPY ./config/gems ./config/gems
COPY Gemfile* ./
RUN bundle install --jobs "$(nproc)" --without "development test" \
  && bundle exec bootsnap precompile --gemfile \
  && rm -rf ~/.bundle/ $BUNDLE_PATH/ruby/*/cache $BUNDLE_PATH/ruby/*/bundler/gems/*/.git

COPY package.json *yarn* ./
RUN yarn install --frozen-lockfile

COPY bin/ ./bin
RUN chmod 0755 bin/*

COPY . .

RUN bundle exec bootsnap precompile app/ lib/

RUN --mount=type=secret,id=RAILS_MASTER_KEY \
  RAILS_MASTER_KEY="$(cat /run/secrets/RAILS_MASTER_KEY)" ./bin/rails assets:precompile;

####################################################################################################

FROM base AS app

RUN set -o pipefail \
  && apt-get update \
  && apt-get install -y --no-install-recommends libjemalloc2 libsqlite3-dev vim \
  && rm -rf /var/cache/apt/archives /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2

COPY bin/ ./bin
RUN chmod 0755 bin/*

COPY --from=build /usr/local/bin/litestream /usr/local/bin/litestream
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app/public /app/public
COPY . .

# gotta match [env].PORT and [[services]].internal_port
ENV PORT 8080

CMD \
  litestream restore -v -if-db-not-exists -if-replica-exists -o /app/db/production.sqlite3 "s3://todol--all/db/production.sqlite3" \
  && litestream restore -v -if-db-not-exists -if-replica-exists -o /app/db/production_litecache.sqlite3 "s3://todol--all/db/production_litecache.sqlite3" \
  && litestream restore -v -if-db-not-exists -if-replica-exists -o /app/db/production_litejob.sqlite3 "s3://todol--all/db/production_litejob.sqlite3" \
  && ./bin/rails db:migrate \
  && litestream replicate -exec "./bin/rails server -p ${PORT}" -config ./config/litestream.yml
