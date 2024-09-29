FROM ruby:3.1.0
RUN apt-get update -qq && apt-get install -y libpq-dev postgresql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle config set path 'vendor/bundle'
RUN bundle install --jobs 4 --retry 3
ENV PATH ./vendor/bundle/ruby/3.1.0/bin:$PATH
COPY . /app
EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
