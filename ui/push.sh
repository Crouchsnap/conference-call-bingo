#!/bin/bash

elm make src/Main.elm --output=main.js
cf push bingo -b staticfile_buildpack --no-manifest
