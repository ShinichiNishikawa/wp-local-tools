#!/usr/bin/env bash
set -ex

type wp >/dev/null 2>&1 || { echo >&2 "wp-cli is not installed.  Aborting."; exit 1; }

# Variables.
DIRNAME=${PWD##*/}
HTTP_HOST='$_SERVER["HTTP_HOST"]'

# Download WordPress
wp core download

# Create wp-config.php, adding consonants.
wp core config --dbname=${DIRNAME} --dbuser=root --dbpass=root --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_SITEURL', 'http://'.${HTTP_HOST} );
define( 'WP_HOME',    'http://'.${HTTP_HOST} );
PHP

# create a database
wp db create

# Retrieve Movefile template for WordMove
curl https://raw.githubusercontent.com/ShinichiNishikawa/wp-local-tools/master/resources/Movefile > Movefile

# Retrieve .gitignore template
curl https://raw.githubusercontent.com/ShinichiNishikawa/wp-local-tools/master/resources/WordPress.gitignore > .gitignore

# Retrieve wp-cli.local.yml template for WP-CLI
curl https://raw.githubusercontent.com/ShinichiNishikawa/wp-local-tools/master/resources/wp-cli.local.yml > wp-cli.local.yml
