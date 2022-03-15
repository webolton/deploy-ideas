# Our base image

FROM ruby:2.7

# Define where our application will run inside the image
ARG RAILS_ROOT /var/www/${YOUR_APP_NAME}

# Set Rails environment
ARG RAILS_ENV

# Set working directory inside the image
WORKDIR $RAILS_ROOT

# Create place to put pids. The App server will need it, so create it in one shot.
RUN mkdir -p $RAILS_ROOT/tmp/pids

# Create bundle folder. Gems get installed and compiled locally.
RUN mkdir -p $RAILS_ROOT/vendor/bundle

# Use the Gemfiles.
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

# Install bundler
RUN gem install bundler

# Finish establishing Ruby environment
COPY vendor/bundle vendor/bundle

# Set bundler configuration value
RUN bundle config set path 'vendor/bundle

# Copy the appliction into place
COPY . .

# Copy database configs into place
COPY config/containers/db_config/${RAILS_ENV}/database.yml config/database.yml

# CA Cert???

# Clear the cache
RUN bundle exec rake tmp:clear

# Bin files or other executables?
CMD ["scripts/app_cmd.sh"]
