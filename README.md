# Drupal 7 in a container

[![Drupal 7.39](https://img.shields.io/badge/Drupal-7.39-green.svg)](https://github.com/weahead/docker-drupal/tree/v7.x)


## Layout of this repository

Check out the branches for each version of Drupal supported by this repository.


## Contents

This container includes:

- [S6 Overlay](https://github.com/just-containers/s6-overlay)
- [Drupal](https://www.drupal.org/)
- [Composer](https://getcomposer.org/)
- [Drush](http://www.drush.org/)


## Usage

An example of usage can be found at [example](example).

1. Create a `Dockerfile` with `FROM weahead/drupal:<tag>`. Where `tag` is a
   version number like `7.39.0`.

2. Make sure you add `VOLUME /var/www/html` to the end of your `Dockerfile`.

3. Create a folder named `app` next to `Dockerfile`.

4. Drupal packages, like themes and modules, are installed with Composer. Create
   a file named `composer.json` at `app/composer.json` and specify your
   requirements there.

   See [example/app/composer.json](example/app/composer.json) for example content.

   More information can be found in [Drupals Community Documentation](https://www.drupal.org/node/2718229).

5. Optionally, place a `settings.php` file at `app/settings.php`. It will be 
   installed in the correct place inside the container at build time. *Skip this
   step if you plan on running the Drupal installation steps rather than
   importing an existing installation.*

6. Place custom themes to develop in folder `app/themes`.

7. Place custom modules to develop in folder `app/modules`.

   This gives you a folder structure like this:

   ```
   .
   ├── Dockerfile
   ├── app
   │   ├── composer.json
   │   ├── settings.php
   │   ├── modules
   │   │   ├── custom-module1
   │   │   ├── custom-module2
   │   │   └── ...
   │   └── themes
   │       ├── custom-theme
   │       └── ...
   └── ...
   ```

7. Build it with `docker build -t <name>:<tag> .`


### S6 supervision

To use additional services, like using node to watch files and compile on save,
S6 supervision can be used. More information on how to use S6 can be found in
[their documentation](https://github.com/just-containers/s6-overlay).

The recommended way is to use `COPY root /` in a descendant `Dockerfile` with
the directory structure found in [example/root](example/root).


## License

[X11](LICENSE)
