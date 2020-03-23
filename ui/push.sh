#!/bin/bash

elm make src/Main.elm
cf push bingo -b staticfile_buildpack --no-manifest