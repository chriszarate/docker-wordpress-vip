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

// This should match the container link name defined in `docker-compose.yml`.
define( 'DB_HOST', 'mysql' );

// Disable asset minification.
define( 'QUICKSTART_DISABLE_CONCAT', true );

// Project-specific config.
