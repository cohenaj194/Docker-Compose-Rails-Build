#!/bin/bash

#makes rails app if not working
full_make() {
  docker-compose run web rails new . --force --database=postgresql --skip-bundle
  sudo chown -R $USER:$USER .
  docker-compose build
  echo "development: &default
  adapter: postgresql
  encoding: unicode
  database: postgres
  pool: 5
  username: postgres
  password:
  host: db
test:
  <<: *default
  database: myapp_test" > config/database.yml
    docker-compose up -d
}

#start of script creating Dockerfile and docker-compose.yml
echo "version: '2'
services:
  db:
    image: postgres
  web:
    build: .
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    volumes:
      - .:/myapp
    ports:
      - 3000
    depends_on:
      - db" > docker-compose.yml

echo "
FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp" > Dockerfile

# creates a Gemfile if none exists
if [ -z "$(ls . | grep -w Gemfile | tr -d '\012')" ]; then 

echo "source 'https://rubygems.org'
gem 'rails', '4.2.0' "> Gemfile

fi

# creates a Gemfile.lock if none exists
if [ -z "$(ls . | grep -w 'Gemfile.lock' | tr -d '\012')" ]; then
  touch Gemfile.lock
fi

#checks that there is a config/database.yml file 
if [ -d "config" ]; then
  if [ -f "config/database.yml"]; then
    #if we have one then all we have to do is modify our files and run docker compose
    sudo chown -R $USER:$USER .
    docker-compose up -d
    sleep 5

    #if the web container fails then config/database.yml is set up incorrectly 
    #so well remake the project with a fresh config/database.yml
    if [ -z "$( docker ps | grep 'rails_web' | tr -d '\012')"]; then
      full_make
    fi
    echo "up and running!!!"
  fi
else
  #if the project was empty from the start then well make everything from scratch
  full_make
fi



