FROM ruby:3.1.0
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        curl \
        postgresql-client \
        gnupg \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev \
        pkg-config && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm cache clean --force && \
    rm -rf /root/.npm /root/.config /root/.cache && \
    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | \
        gpg --dearmor -o /usr/share/keyrings/yarn-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main" | \
        tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y yarn=1.22.22-1 && \
    apt-mark hold yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /app/tmp/pids
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle config set path 'vendor/bundle' && \
    bundle install --jobs 4 --retry 3
COPY package.json yarn.lock ./
RUN yarn install --check-files
COPY . .
RUN yarn build
COPY bin/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENV PATH="./vendor/bundle/ruby/3.1.0/bin:$PATH"
ENV RAILS_ENV=development
EXPOSE 3000
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
