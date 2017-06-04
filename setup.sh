#!/usr/bin/env bash

if [ ! -f docker-compose.yml ]; then
  echo "Please run this script from the root of the docker-wordpress-vip repo."
  exit 1
fi

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

# Clone Photon.
if [ ! -d "src/vip-photon" ]; then
  echo "Cloning Photon to \"src/vip-photon\"...."
  svn co --quiet --trust-server-cert --non-interactive https://code.svn.wordpress.org/photon src/vip-photon
fi

# Clone VIP plugins.
if [ ! -d "src/vip-plugins" ]; then
  echo "Cloning VIP plugins to \"src/vip-plugins\"...."
  svn co --quiet --trust-server-cert --non-interactive https://vip-svn.wordpress.com/plugins src/vip-plugins
fi

# Clone VIP Quickstart (provides needed mu-plugins).
if [ ! -d "src/vip-quickstart" ]; then
  echo "Cloning VIP Quickstart to \"src/vip-quickstart\"...."
  git clone --depth=1 https://github.com/Automattic/vip-quickstart.git src/vip-quickstart
fi

# Remove some of the constants that VIP Quickstart hardcodes. If desired, supply
# your own values in the local config.
sed -i '' -e '/DB_HOST/d' -e '/WP_DEBUG/d' src/vip-quickstart/www/wp-config.php

# Remove the object caching plugin, since we don't provide Memcached.
rm -f src/vip-quickstart/www/wp-content/object-cache.php

# Change flag that prevents Photon from activating in Jetpack dev mode.
sed -i '' -e 's/Requires Connection: Yes/Requires Connection: No/1' src/wordpress-plugins/jetpack/modules/photon.php

# Remove filter_var check that prevents connecting to local IP addresses (photon r436).
sed -i '' -e 's/ *FILTER_FLAG_NO_PRIV_RANGE *|//g' src/vip-photon/index.php

# Here is where you might check out your own code into the `src` subfolder. As a
# placeholder, we'll create a test theme with the bare minimum prerequisites.
mkdir -p src/test-theme
touch src/test-theme/index.php src/test-theme/style.css
