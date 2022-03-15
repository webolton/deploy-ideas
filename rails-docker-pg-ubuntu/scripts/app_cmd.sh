#!/usr/bin/env bash

# Rails application commands
bundle exec rails db:migrate RAILS_ENV="$RAILS_ENV"
bundle exec unicorn -c config/unicorn.rb -l 0.0.0.0:3000 -E "$RAILS_ENV"
