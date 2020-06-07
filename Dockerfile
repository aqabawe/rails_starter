FROM ruby:2.7.1
MAINTAINER Mamoun Saudi <aqabawe@gmail.com>

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    postgresql-client \
    build-essential \
    libpq-dev \
    nodejs \
    yarn \
    vim \
    wget \
    libfontconfig1 \
    libxrender1 \
    libxext6 \
    git \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists
RUN mkdir /poc
WORKDIR /poc
COPY Gemfile /poc/Gemfile
COPY Gemfile.lock /poc/Gemfile.lock
RUN bundle install
COPY . /poc

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
