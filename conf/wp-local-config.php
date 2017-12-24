<?php
/**
 * WordPress local config
 *
 * @package docker-wordpress-vip
 */

// Conditionally turn on HTTPS since we're behind nginx-proxy.
if ( isset( $_SERVER['HTTP_X_FORWARDED_PROTO'] ) && 'https' === $_SERVER['HTTP_X_FORWARDED_PROTO'] ) { // Input var ok.
	$_SERVER['HTTPS'] = 'on';
}

// This should match the MariaDB container name in `docker-compose.yml`.
define( 'DB_HOST', 'mysql' );

// Disable asset minification.
define( 'QUICKSTART_DISABLE_CONCAT', true );

// This provides the host and port of the development Memcached server. The host
// should match the container name in `docker-compose.memcached.yml`. If you
// aren't using Memcached, it will simply be ignored.
$memcached_servers = array(
	array(
		'memcached',
		11211,
	),
);

// Put project-specific config below this line.
