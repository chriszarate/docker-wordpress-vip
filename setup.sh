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
git fetch && git pull && echo ""

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
  svn up src/wordpress-plugins/${repo}
  echo ""
done

# Clone VIP plugins.
if [ ! -d "src/vip-plugins/.svn" ]; then
  echo "Cloning VIP plugins to \"src/vip-plugins\"...."
  rm -rf src/vip-plugins/
  svn co --quiet --trust-server-cert --non-interactive https://vip-svn.wordpress.com/plugins src/vip-plugins
fi
svn up src/vip-plugins
echo ""

# Clone git repos (VIP Quickstart provides needed mu-plugins).
for repo in \
  Automattic/vip-quickstart \
  tollmanz/wordpress-pecl-memcached-object-cache
do
  # Clone repo if it is not in the "src" subfolder.
  if [ ! -d "src/${repo##*/}/.git" ]; then
    echo "Cloning $repo in the \"src\" subfolder...."
    rm -rf src/${repo##*/}
    git clone --depth=1 git@github.com:$repo src/${repo##*/}
  fi

  # Make sure repos are up-to-date.
  echo "Updating ${repo##*/}...."
  git --git-dir=src/${repo##*/}/.git --work-tree=src/${repo##*/} pull --ff-only
  echo ""
done

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
