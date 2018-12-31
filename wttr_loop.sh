#!/bin/bash

# This file was created on 25/12/18
# Author: George Kaimakis - https://github.com/geokai


usage function
_usage () {
    printf "  %b\n"
        ""\
        "${1%%.*}  version: ${VERSION}  created: ${CREATED}"\
        ""\
        "Usage: ${1##*/} [-hvVd]"\
        ""\
        "  -t            Set the date option"\
        "                If TZ info is added to location string, the"\
        "                location time is given"\
        "  -v            Verbose mode - displays ${1%%.*} version info"\
        "  -V            Very Verbose Mode - debug output displayed"\
        "  -c            Print the location of the script configuration file"\
        "  -h            Help - display this message and exit"\
        ""\
        ""\
        "This shell script is interpreted with the ${SHEBANG#*!} shell."\
        ""\
        "author: ${AUTHOR}"\
        "email : ${EMAIL}"\
        "repos : ${REPO}"\
        ""\
        "\"AutoContent\" enabled"\
        ""\

# call the main function with all the positional parameters passed
# _run_main "$@"
