FROM ruby:3.1.0
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        curl \
        postgresql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle config set path 'vendor/bundle' && \
    bundle install --jobs 4 --retry 3
COPY . .
ENV PATH ./vendor/bundle/ruby/3.1.0/bin:$PATH
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
