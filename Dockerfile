FROM ruby:alpine3.19

RUN apk add git build-base libshout libshout-dev

WORKDIR /rbstream
COPY Gemfile Gemfile.lock rbstream.gemspec ./

# install gems
RUN bundle install --without development test

COPY . .

CMD bundle && bundle exec rbstream --password $ICECAST2_SOURCE_PASSWORD --hostname $ICECAST2_HOST --port $ICECAST2_PORT --mount $ICECAST2_SOURCE_MOUNT --playlist examples/playlist.json
