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

// Project-specific config.
