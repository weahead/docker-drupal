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


### Dev settings, remove on production

# Enable asserts
assert_options(ASSERT_ACTIVE, TRUE);
\Drupal\Component\Assertion\Handle::register();

# Dev services
$settings['container_yamls'][] = DRUPAL_ROOT . '/sites/development.services.yml';

# Verbose logging
$config['system.logging']['error_level'] = 'verbose';

# Disable aggregation
$config['system.performance']['css']['preprocess'] = FALSE;
$config['system.performance']['js']['preprocess'] = FALSE;

# Turn off cache during development
$settings['cache']['bins']['render'] = 'cache.backend.null';
$settings['cache']['bins']['dynamic_page_cache'] = 'cache.backend.null';

# Enable access to /rebuild.php
$settings['rebuild_access'] = TRUE;
