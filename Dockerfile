FROM ruby:2.7.2-alpine

ENV APP_PATH /var/app
ENV BUNDLE_VERSION 2.2.9
ENV BUNDLE_PATH /usr/local/bundle/gems
ENV GLIBC_RELEASE_VERSION 2.32-r0

# copy entrypoint script and grant execution permissions
COPY ./bin/docker-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint

WORKDIR ${APP_PATH}

# install dependencies for application
RUN apk -U add --no-cache \
  bash \
  build-base \
  sqlite-dev \
  git \
  ca-certificates \
  wget \
  && rm -rf /var/cache/apk/* \
  && mkdir -p ${APP_PATH}

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_RELEASE_VERSION}/glibc-${GLIBC_RELEASE_VERSION}.apk
RUN apk add glibc-${GLIBC_RELEASE_VERSION}.apk

# Ensure the correct version of bundler is installed
RUN gem install bundler --version ${BUNDLE_VERSION} \
  && rm -rf $GEM_HOME/cache/*

# Copy the rest of the application
COPY . .

ENTRYPOINT ["bundle", "exec"]
