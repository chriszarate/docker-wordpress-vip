<?php
/**
 * WordPress local config
 *
 * @package docker-wordpress-vip
 */

// This should match the container link name defined in `docker-compose.yml`.
define( 'DB_HOST', 'mysql' );

// Disable asset minification.
define( 'QUICKSTART_DISABLE_CONCAT', true );

// Comment out to disable connection to Photon dev server.
define( 'PHOTON_DEV_HOST', getenv( 'PHOTON_DEV_HOST' ) );

// Project-specific config.
