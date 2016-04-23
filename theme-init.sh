#!/bin/sh -eu

# exit if wp-cli, wordmove or git is not installed.
type wp >/dev/null 2>&1 || { echo >&2 "wp-cli is not installed.  Aborting."; exit 1; }

# Variables.
DIRNAME=${PWD##*/}
URL_LOCAL=$(cd ../../.. && echo "${PWD##*/}")

npm init --yes
npm install gulp --save-dev
npm install gulp-sass --save-dev
npm install gulp-autoprefixer --save-dev
npm install browser-sync --save-dev
npm install gulp-plumber --save-dev
npm install gulp-sourcemaps --save-dev

curl https://gist.githubusercontent.com/ShinichiNishikawa/7f72356d3edcb33addef/raw/39da698e15e0da725f9d0f47b72c575e889f7818/gulpfile.js > gulpfile.js

mkdir sass
touch sass/style.scss

sed -i -e "s/example.loc/${URL_LOCAL}/g" gulpfile.js

gulp
