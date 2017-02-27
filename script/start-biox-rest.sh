#!/usr/bin/env bash

plackup -E deployment -s Starman -p 3001  -a script/biox-app.psgi
