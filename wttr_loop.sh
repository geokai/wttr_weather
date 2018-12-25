#!/bin/bash

# This file was created on 25/12/18
# Author: George Kaimakis - https://github.com/geokai


# usage function
_usage () {
    printf "  %b\n" ""\
           ""\
           ""
}


# handle fatal errors
_fatal () {
    return 2
}


# handle minor errors (warnings)
_warning () {
    return 1
}


# main function
_run_main () {

    # positional parameters: could also include a file with a list of places
    _places="${@}"
    _dir="~/.weather/cache/"
    _interval=20    # seconds delay between wttr.in api calls
    OPTIND=1


    # parse option flags using getopts
    while getopts ":hvV" opt; do
        case $opt in
            h) _usage && return 0;;
            v) verbose=(( verbose+1 ))
            V) set -x;;
            *) _warning "";;
        esac
    done
 
    shift "$((OPTIND-1))"


    # loop through the list of places with wttr function
    _wttr_loop() {
        for i in "${!_places[@]}"; do
            wttr_cron.sh ~${_places[i]}?QM0 ${_dir}${_places[i]%\+*}.txt;
            [ "${i}" -lt 1 ] && sleep ${_interval};
        done
    }
}

# call the main function with all the positional parameters passed
_run_main "${@}"
