FROM ruby:3.1.0
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        curl \
        postgresql-client \
        gnupg && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg \
        | tee /usr/share/keyrings/yarn-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] \
        https://dl.yarnpkg.com/debian/ stable main" \
        | tee /etc/apt/sources.list.d/yarn.list > /dev/null && \
    apt-get update -qq && \
    apt-get install -y yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle config set path 'vendor/bundle' && \
    bundle install --jobs 4 --retry 3
COPY package.json yarn.lock ./
RUN yarn install --check-files && yarn build
COPY . .
COPY bin/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENV PATH="./vendor/bundle/ruby/3.1.0/bin:$PATH"
EXPOSE 3000
RUN apt-get remove --purge -y build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENTRYPOINT ["entrypoint.sh"]
