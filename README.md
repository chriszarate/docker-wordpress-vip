# WordPress VIP development for Docker

This repo provides a Docker-based development environment for [WordPress VIP][vip]
development. Via [chriszarate/wordpress][image], it runs on PHP7 and adds
WP-CLI, PHPUnit, Xdebug, and the WordPress unit testing suite. It further adds
VIP shared plugins, VIP mu-plugins, a [Photon][photon] server, and the
development plugins provided by VIP Quickstart.

If you only need Docker WordPress development environment for a single plugin or
theme, my [docker-compose-wordpress][simple] repo is a simpler place to start.


# VIP Go

For a work-in-progress VIP Go environment, check out the `vip-go` branch of this
repo.


## Set up

**NEW!**: Run `setup.sh` to check out third-party (VIP) code. You should alter
this script to check out your organization’s code as well (see the final section
of script). Then, adjust the `services/wordpress` section of `docker-compose.yml`
to reflect your changes:

1. Mount your theme folder in `/var/www/html/wp-content/themes/vip/`.

2. Add your theme to the `WORDPRESS_ACTIVATE_THEME` environment variable, using
   a path relative to `wp-content/themes` (e.g., `vip/my-theme`).

3. Add `project.dev` to your `/etc/hosts` file. If you choose a different TLD,
   make sure to edit `.env` as well.

**Refer to [docker-compose-wordpress][simple] for general instructions** on how to
interact with the stack, including WP-CLI, PHPUnit, and Xdebug.

The main difference with this stack is that all code is synced to the WordPress
container from the `src` subfolder and, generally, is assumed to be its own
separate repo.

Additionally, you have the opportunity to put project-specific WordPress config
in `conf/wp-local-config.php` and PHP ini changes in `conf/php-local.ini`, which
are synced to the container. You may also need to adjust the Nginx config of the
reverse proxy container via `conf/nginx-proxy.conf`.


## TLS / SSL support

Run `./certs/create-certs.sh` to generate self-signed certificates. Optionally,
you may wish to add the generated root certificate to your system’s trusted root
certificates. This will allow you to browse your dev environment over HTTPS
without accepting a browser security warning. On OS X:

```sh
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain certs/ca-root/ca.crt
```

Next, uncomment the cert-related lines in `docker-compose.yml` and restart the
stack (`docker-compose stop`, `docker-compose up -d`).


[vip]: https://vip.wordpress.com
[photon]: https://jetpack.com/support/photon/
[image]: https://hub.docker.com/r/chriszarate/wordpress/
[simple]: https://github.com/chriszarate/docker-compose-wordpress
