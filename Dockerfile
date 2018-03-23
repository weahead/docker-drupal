FROM php:7.2.3-fpm-alpine

LABEL maintainer="We ahead <docker@weahead.se>"

RUN apk --no-cache add \
      git \
      tar \
      coreutils \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
      su-exec \
      mysql-client \
      postfix \
      patch \
    && docker-php-ext-configure gd --with-png-dir=/usr/include --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd iconv mysqli mbstring pdo_mysql \
    && apk --no-cache add --virtual build-deps \
      autoconf \
      g++ \
      make \
    && pecl install opcache xdebug \
    && docker-php-ext-enable opcache xdebug \
    && apk del build-deps

ENV S6_VERSION=1.21.2.2\
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

ENV COMPOSER_VERSION=1.6.2

RUN curl -L -o composer-setup.php https://getcomposer.org/installer \
    && curl -L -o composer-setup.sig https://composer.github.io/installer.sig \
    && echo "$(cat composer-setup.sig) *composer-setup.php" | sha384sum -c - \
    && php composer-setup.php -- \
      --install-dir=/usr/local/bin\
      --filename=composer\
      --version=${COMPOSER_VERSION}\
    && rm -rf composer-setup.php composer-setup.sig \
    && su-exec www-data composer global require "hirak/prestissimo:^0.3" \
    && su-exec www-data composer clear-cache

COPY root/var/ /var/

RUN chown -R www-data:www-data /var/www/html \
    && su-exec www-data composer install --prefer-dist \
    && su-exec www-data composer clear-cache

COPY root/etc/ /etc/

COPY root/usr/ /usr/

ENTRYPOINT ["/init"]

ONBUILD COPY --chown=www-data:www-data app/composer.json /var/www/html/web/composer.json

ONBUILD RUN rm composer.lock \
    && su-exec www-data composer install --prefer-dist \
    && su-exec www-data composer clearcache

ONBUILD COPY --chown=www-data:www-data config/services.yml /var/www/html/web/sites/default/services.yml

ONBUILD COPY --chown=www-data:www-data config/settings.php /var/www/html/web/sites/default/settings.php

ONBUILD COPY --chown=www-data:www-data config/sync/ /var/www/html/config/sync/

ONBUILD COPY --chown=www-data:www-data app/libraries/ /var/www/html/web/sites/all/libraries/

ONBUILD COPY --chown=www-data:www-data app/modules/ /var/www/html/web/modules/custom/

ONBUILD COPY --chown=www-data:www-data app/themes/ /var/www/html/web/themes/custom/
