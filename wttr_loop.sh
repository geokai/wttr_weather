#!/bin/bash

# This file was created on 25/12/18
# Author: George Kaimakis - https://github.com/geokai


# usage function
# _usage () {
#     printf "  %b\n" ""\
#                     "USAGE:"\
#                     ""
# }


# positional parameters: could also include a file with a list of places
unset _locs
_locs=($@)
# _locs=(highgate+london falmouth+uk)
# printf "%b\n" "item:" "${_locs[@]}"
# printf "%b\n" "# of items: ${#_locs[@]}"
# printf "$1\n"
# printf "$2\n"

_dir="$HOME/.weather/cache/"
_interval=60    # seconds delay between wttr.in api calls

# loop through the list of places with wttr function
for i in "${!_locs[@]}"; do
    # echo "processing: ${_locs[i]}"
    wttr_cron.sh ~${_locs[i]}?QM0 ${_dir}${_locs[i]%\+*}.txt;
    [ "${i}" -lt $((${#_locs[@]}-1)) ] && sleep ${_interval};
done

# call the main function with all the positional parameters passed
# _run_main "$@"
