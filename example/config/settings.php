<?php

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

$config_directories = array();
$settings['hash_salt'] = '';
$settings['update_free_access'] = FALSE;
$settings['container_yamls'][] = $app_root . '/' . $site_path . '/services.yml';

$settings['file_scan_ignore_directories'] = [
  'node_modules',
  'bower_components',
];

$settings['entity_update_batch_size'] = 50;

if (file_exists($app_root . '/' . $site_path . '/settings.local.php')) {
  include $app_root . '/' . $site_path . '/settings.local.php';
}
$config_directories['sync'] = '../config/sync';
