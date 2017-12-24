#!/usr/bin/env bash

if [ ! -f docker-compose.yml ]; then
  echo "Please run this script from the root of the docker-wordpress-vip repo."
  exit 1
fi

if [ ! -z "$(docker-compose ps | sed -e '/^\-\-\-/,$!d' -e '/^\-\-\-/d')" ]; then
  echo "Please run \`docker-compose down\` before running this script. (You will need"
  echo "to reimport content after this script completes.)"
  exit 1
fi

# Make sure environment is up to date.
echo "Updating environment...."
git fetch && git pull

# Make sure src directory exists.
mkdir -p src/wordpress-plugins

# Clone useful WordPress plugins.
for repo in \
  jetpack \
  log-deprecated-notices \
  monster-widget \
  query-monitor \
  rewrite-rules-inspector \
  user-switching \
  vip-scanner \
  wordpress-importer
do
  if [ ! -d "src/wordpress-plugins/${repo}" ]; then
    echo "Cloning $repo in the \"src/wordpress-plugins\" subfolder...."
    svn co --quiet --trust-server-cert --non-interactive https://plugins.svn.wordpress.org/$repo/trunk src/wordpress-plugins/${repo}
  fi
done

# Clone VIP plugins.
if [ ! -d "src/vip-plugins/.svn" ]; then
  echo "Cloning VIP plugins to \"src/vip-plugins\"...."
  rm -rf src/vip-plugins/
  svn co --quiet --trust-server-cert --non-interactive https://vip-svn.wordpress.com/plugins src/vip-plugins
fi
svn up src/vip-plugins

# Clone VIP Quickstart (provides needed mu-plugins).
if [ ! -d "src/vip-quickstart/.git" ]; then
  echo "Cloning VIP Quickstart to \"src/vip-quickstart\"...."
  rm -rf src/vip-quickstart/
  git clone --depth=1 https://github.com/Automattic/vip-quickstart.git src/vip-quickstart
fi

# Clone Memcached drop-in.
if [ ! -d "src/memcached-object-cache/.git" ]; then
  echo "Cloning Memcached object cache to \"src/memcached-object-cache\"...."
  rm -rf src/memcached-object-cache/
  git clone --depth=1 https://github.com/tollmanz/wordpress-pecl-memcached-object-cache.git src/memcached-object-cache
fi

# Remove some of the constants that VIP Quickstart hardcodes. If desired, supply
# your own values in the local config.
sed -i.bak -e '/DB_HOST/d' -e '/WP_DEBUG/d' src/vip-quickstart/www/wp-config.php

# Remove the default object caching plugin, since we will want to provide it
# conditionally if Memcached is provided.
rm -f src/vip-quickstart/www/wp-content/object-cache.php

# Make sure self-signed TLS certificates exist.
./certs/create-certs.sh

# Here is where you might check out your own code into the `src` subfolder. As a
# placeholder, we'll create a test theme with the bare minimum prerequisites.
mkdir -p src/test-theme
touch src/test-theme/style.css
echo "Hello!" > src/test-theme/index.php

# Done!
echo ""
echo "Done! You are ready to run \`docker-compose up -d\`."
