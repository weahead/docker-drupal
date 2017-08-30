<?php

# Simple example of settings.php

$config_directories = array();

# Change this value to some random string.
$settings['hash_salt'] = 'CHANGE ME';

# Common settings
$settings['update_free_access'] = FALSE;
$settings['container_yamls'][] = $app_root . '/' . $site_path . '/services.yml';

# Directories to ignore
$settings['file_scan_ignore_directories'] = [
    'node_modules',
    'bower_components',
];

# Database credentials given via env variables
$databases = array (
  'default' =>
    array (
      'default' =>
        array (
          'database' => getenv('DB_NAME'),
          'username' => getenv('DB_USER'),
          'password' => getenv('DB_PASSWORD'),
          'host' => getenv('DB_HOST'),
          'port' => '3306',
          'driver' => 'mysql',
          'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
          'prefix' => '',
        ),
    ),
);
