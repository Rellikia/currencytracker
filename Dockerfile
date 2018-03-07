FROM ruby:2.5-alpine3.7

RUN apk add --update --no-cache \
      build-base \
      nodejs \
      tzdata \
      libxml2-dev \
      libxslt-dev \
      bash \
      postgresql-dev \
      mysql-dev

ENV APP_ROOT /app

RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT

RUN bundle config --global frozen 1

COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock

RUN RAILS_ENV=production bundle install --path /bundle --without development test

COPY . $APP_ROOT
