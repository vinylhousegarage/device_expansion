FROM ruby:3.1.0
RUN apt-get update -qq && apt-get install -y \
    libpq-dev postgresql-client curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs
RUN npm install -g yarn@1.22.22
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle config set path 'vendor/bundle' \
    && bundle install --jobs 4 --retry 3
COPY package.json yarn.lock /app/
RUN yarn install --check-files
COPY . /app
RUN yarn build
RUN bundle exec rails assets:precompile
ENV PATH ./vendor/bundle/ruby/3.1.0/bin:$PATH
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
