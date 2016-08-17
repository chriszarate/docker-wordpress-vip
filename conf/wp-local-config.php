<?php
/**
 * WordPress local config
 *
 * @package docker-wordpress-vip
 */

// This should match the container link name defined in `docker-compose.yml`.
define( 'DB_HOST', 'mysql' );

// We don't provide memcached or asset minification. Changing these values will
// likely result in a fatal error.
define( 'WP_OBJECT_CACHE', false );
define( 'QUICKSTART_DISABLE_CONCAT', true );

// Project-specific config.
