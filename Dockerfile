FROM ruby:2.5.1

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y build-essential libpq-dev nodejs nodejs
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile Gemfile.lock /myapp/
RUN bundle install
COPY . /myapp
