FROM ruby:3.0.1-alpine3.13

RUN apk add --no-cache \
  build-base \
  tzdata \
  postgresql-dev \
  git

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN gem update bunlder && \
  bundle config set without 'development test' && \
  bundle install --jobs 4

COPY . .

EXPOSE 3000

CMD ["bin/puma"]
