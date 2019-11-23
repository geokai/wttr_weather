#!/bin/bash

# get_wttr.sh
# Purpose: a script that send a get request to the wttr.in weather api
# api: curl http://wttr.in/~london?MQ0
# retreives weather information for the location given as an argument to the
# script call:
# - wttr.sh london?0q
# will render the current weather for London, with reduced text.
# refer to http://wttr.in:help

# This file was created on 17/02/18
# Author: George Kaimakis

get_wttr () {
    curl wttr.in/$1 > $2
}


get_wttr "$@"
