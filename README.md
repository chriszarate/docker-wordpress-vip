# WordPress VIP development for Docker

This repo provides a Docker-based development environment for [WordPress VIP][vip]
development. Via [chriszarate/wordpress][image], it runs on PHP7 and adds better
defaults, WP-CLI, PHPUnit, Composer, Xdebug, and the WordPress unit testing
suite. It then adds VIP mu-plugins and the (optional) development plugins
provided by VIP Quickstart.

If you only need Docker WordPress development environment for a single plugin or
theme, my [docker-compose-wordpress][simple] repo is a simpler place to start.


## Set up

**Refer to [docker-compose-wordpress][simple] for general instructions** on how to
interact with the stack, including WP-CLI, PHPUnit, and Xdebug.

The main difference is that, with this repo, your theme lives in a subfolder and
is assumed to its own separate repo. In this repo, I use the subfolder name
`my-theme` as an example. Adjust the `services/wordpress` section of
`docker-compose.yml` and `.dockerignore` to reflect your chosen name.

Additionally, you have the opportunity to put project-specific config in `conf/wp-local-config.php`, which is synced to the Docker container.


[vip]: https://vip.wordpress.com
[image]: https://hub.docker.com/r/chriszarate/wordpress/
[simple]: https://github.com/chriszarate/docker-compose-wordpress
