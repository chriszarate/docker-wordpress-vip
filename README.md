# WordPress VIP development for Docker

This repo provides a Docker-based development environment for WordPress
development. Notably, it includes everything necessary for developing themes for
[WordPress VIP][vip], but it works well for WordPress in general.

- The [chriszarate/wordpress][image] image runs on PHP7. It generally follows
  the approach of the official WordPress Docker image and adds better defaults,
  WP-CLI, PHPUnit, Composer, Xdebug, and the WordPress unit testing suite.

- `lib/Dockerfile` provides plugins specific to the WordPress VIP environment as
  well as some generally useful development plugins. They are completely
  optional to use.

- `docker-compose.yml` adds MariaDB and `nginx-proxy` to create a complete
  development environment that boots up quickly.


## Set up

1. Put your theme and/or plugin in the root of this folder and adjust the 
   `services/wordpress/volumes` section of `docker-compose.yml` so that they
   sync to the WordPress container. Additionally edit `.dockerignore` to exclude
   those directories.

   If you would like your theme or plugin activated when the container starts,
   edit the `WORDPRESS_ACTIVATE_PLUGINS` and/or `WORDPRESS_ACTIVATE_THEME`
   environment variables.

2. Add `project.dev` (or your chosen hostname) to `/etc/hosts`, e.g.:

```
127.0.0.1 localhost project.dev
```

  If you choose a different hostname, edit `.env` as well.


## Start environment

```sh
docker-compose up -d
```

The `-d` flag backgrounds the process and log output. To view logs for a
specific container, use `docker-compose logs [container]`, e.g.:

```sh
docker-compose logs wordpress
```

Please refer to the [Docker Compose documentation][docker-compose] for more
information about starting, stopping, and interacting with your environment.

Log in to `/wp-admin` with `wordpress` / `wordpress`. Put project-specific
config in `conf/wp-local-config.php`, which is synced to the Docker container.


## WP-CLI

```sh
docker-compose exec wordpress wp [command]
```


## Running tests (PHPUnit)

Set `PHPUNIT_TEST_DIR` to the path containing `phpunit.xml`. A configured
WordPress test suite is available in `/tmp/wordpress/latest/`. Tests are run
against a separate MariaDB instance.

```sh
docker-compose exec wordpress tests
```


## Xdebug

Xdebug is installed but needs the IP of your local machine to connect to your
local debugging client. Provide it via the `DOCKER_LOCAL_IP` environment
variable. The default `idekey` is `xdebug`.

You can enable profiling by appending instructions to `XDEBUG_CONFIG` in
`docker-compose.yml`, e.g.:

```
XDEBUG_CONFIG: "remote_host=${DOCKER_LOCAL_IP} idekey=xdebug profiler_enable=1 profiler_output_name=%R.%t.out"
```

This will output cachegrind files (named after the request URI and timestamp) to
`/tmp` inside the WordPress container.


[docker-compose]: https://docs.docker.com/compose/
[image]: https://hub.docker.com/r/chriszarate/wordpress/
[vip]: https://vip.wordpress.com
