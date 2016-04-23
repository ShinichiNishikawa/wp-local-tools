#!/bin/sh -eu

# Variables.
DIRNAME=${PWD##*/}
HTTP_HOST='$_SERVER["HTTP_HOST"]'

wp core download
wp core config --dbname=${DIRNAME} --dbuser=root --dbpass=root --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_SITEURL', 'http://'.${HTTP_HOST} );
define( 'WP_HOME',    'http://'.${HTTP_HOST} );
PHP
wp db create
curl https://gist.githubusercontent.com/ShinichiNishikawa/073fedd4d76ef818cc26/raw/c660c4c80d3dd84741720cf14c807fa11fed0995/Movefile.init > Movefile
curl https://gist.githubusercontent.com/ShinichiNishikawa/8c64c74f7422d40ed271/raw/09db75ca8c0c2bbaaf6c15bad1386abd7a78afac/wordpress.gitignore > .gitignore
