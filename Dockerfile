FROM ruby:alpine3.19

RUN apk add git build-base libshout libshout-dev

WORKDIR /rbstream
COPY Gemfile Gemfile.lock rbstream.gemspec ./

# install gems
RUN bundle install --without development test

COPY . .

CMD bundle && bundle exec rbstream
