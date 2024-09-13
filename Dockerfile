FROM ruby:3.0.2
RUN apt-get update -qq && apt-get install -y libpq-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle config set path 'vendor/bundle'
RUN bundle install --jobs 4 --retry 3
COPY . /app
RUN bundle exec rails assets:precompile RAILS_ENV=production
RUN bundle exec rails db:migrate RAILS_ENV=production
RUN bundle exec rails db:seed RAILS_ENV=production
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
