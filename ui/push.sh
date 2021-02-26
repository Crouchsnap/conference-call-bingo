#!/bin/sh

set -e

if ! [ -x "$(command -v uglifyjs)" ]; then
  echo 'installing uglify'
  npm install uglify-js --global
fi

js="main.js"

elm make --optimize --output=$js src/Main.elm
echo "Initial size: $(cat $js | wc -c) bytes  ($js)"

uglifyjs $js --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | uglifyjs --mangle --output=$js

echo "Minified size:$(cat $js | wc -c) bytes  ($js)"
echo "Gzipped size: $(cat $js | gzip -c | wc -c) bytes"


cf push iwd-bingo -b staticfile_buildpack --no-manifest
