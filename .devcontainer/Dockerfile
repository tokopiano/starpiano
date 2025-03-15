FROM ruby:3.0
RUN apt-get update && apt-get install -y nodejs
RUN gem install jekyll bundler
WORKDIR /workspace
COPY . .
RUN bundle install
