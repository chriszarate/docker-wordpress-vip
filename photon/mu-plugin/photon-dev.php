<?php
/**
 * Plugin name: Photon Dev
 * Author: Chris Zarate
 * Description: Auto-enable Photon in dev environment.
 * Version: 1.0
 *
 * @package docker-wordpress-vip
 */

if ( defined( 'PHOTON_DEV_HOST' ) ) {
	add_filter( 'jetpack_photon_development_mode', '__return_false', 50, 0 );
	add_filter( 'jetpack_photon_domain', function() {
		return PHOTON_DEV_HOST;
	}, 50, 0 );

	// Force initial activation.
	add_action( 'init', function() {
		if ( false === get_option( 'jetpack_active_modules' ) ) {
			update_option( 'jetpack_active_modules', array( 'photon' ) );
		}
	}, 10, 0 );
}
