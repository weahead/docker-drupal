FROM php:7.0.9-fpm-alpine

MAINTAINER We ahead <docker@weahead.se>

RUN apk --no-cache add \
      git \
      tar \
      coreutils \
      freetype-dev \
      libjpeg-turbo-dev \
      libmcrypt-dev \
      libpng-dev \
      su-exec \
      mysql-client \
      postfix \
    && docker-php-ext-configure gd --with-png-dir=/usr/include --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd iconv mcrypt mysqli mbstring pdo_mysql

ENV S6_VERSION=1.19.1.1\
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN apk --no-cache add --virtual build-deps\
    gnupg \
  && cd /tmp \
  && curl -OL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz" \
  && curl -OL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz.sig" \
  && export GNUPGHOME="$(mktemp -d)" \
  && curl https://keybase.io/justcontainers/key.asc | gpg --import \
  && gpg --verify s6-overlay-amd64.tar.gz.sig s6-overlay-amd64.tar.gz \
  && tar -xzf /tmp/s6-overlay-amd64.tar.gz -C / \
  && rm -rf "$GNUPGHOME" /tmp/* \
  && apk del build-deps

ENV COMPOSER_VERSION=1.5.1\
    DRUSH_VERSION=8.1.13

RUN curl -L -o composer-setup.php https://getcomposer.org/installer \
    && curl -L -o composer-setup.sig https://composer.github.io/installer.sig \
    && echo "$(cat composer-setup.sig) *composer-setup.php" | sha384sum -c - \
    && php composer-setup.php -- \
      --install-dir=/usr/local/bin\
      --filename=composer\
      --version=${COMPOSER_VERSION}\
    && rm -rf composer-setup.php composer-setup.sig \
    && su-exec www-data composer global require "hirak/prestissimo:^0.3" \
    && su-exec www-data composer global require "drush/drush:${DRUSH_VERSION}" \
    && ln -s /home/www-data/.composer/vendor/bin/drush /usr/local/bin/drush

COPY root /

RUN chown -R www-data:www-data /var/www/html \
    && su-exec www-data composer install --prefer-dist

ENTRYPOINT ["/init"]

ONBUILD COPY app/ /var/www/html/web/sites/all/

ONBUILD RUN mv /var/www/html/web/sites/all/settings.php /var/www/html/web/sites/default/settings.php 2> /dev/null || true

ONBUILD RUN chown -R www-data:www-data /var/www/html \
    && rm composer.lock \
    && su-exec www-data composer clearcache \
    && su-exec www-data composer install --prefer-dist