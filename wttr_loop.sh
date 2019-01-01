#!/bin/bash

# This file was created on 25/12/18
# Author: George Kaimakis - https://github.com/geokai


_usage () {
    #############################################################
    #### usage function
    #### 
    printf "  %b\n"\
        ""\
        "$(basename ${1%.*})  version: ${VERSION}  created: ${CREATED}"\
        ""\
        "Usage: $(basename ${1%.*}) [OPTION] [LOCATIONS...]"\
        "Retreve weather report from the wttr.in api and save the info"\
        "to a text file."\
        "LOCATIONS can be a file or cmd-line strings."\
        ""\
        "  -d            Set the date option"\
        "                If TZ info is added to location string"\
        "                the location time is given"\
        "  -c            Print the location of the script configuration file"\
        "  -V            Very Verbose Mode - debug output displayed"\
        "  -v            output version information and exit"\
        "  -h            display this help and exit,"\
        "                supersedes other options"\
        ""\
        "Examples:"\
        "  wttr_loop london+uk       Retreve weather for London UK and save"\
        "                            the output to 'london.txt'."\
        "  wttr_loop -d boston+usa   option -d adds the time of the specified"\
        "                            location."\
        ""\
        "This shell script is interpreted with the \"${SHEBANG#*!}\" shell."\
        ""\
        "author: ${AUTHOR}"\
        "email : ${EMAIL}"\
        "repo  : ${REPO}"\
        ""\
        "\"AutoContent\" enabled"\
        ""
} # end of usage function


_configure_wttr_loop () {
    #############################################################
    #### configuration function to run automatically with trap on
    #### HUP signal
    #### 
    CFILE="${1}"
    if [[ -f ${CFILE} ]]; then
        if (( VERBOSE == TRUE )); then
            printf "  %b\n"\
                   ""\
                   "# Configuration   file: ${CFILE}"\
                   ""\
                   "# Config file contents: "\
                   ""
            printf "%b\n"\
                   "$(cat ${CFILE})"\
                   ""
        fi
        # source config file
        . ${CFILE}
    else
        printf "  %b\n"\
               ""\
               "# Configuration file \"${CFILE}\" not found!"\
               ""
        exit 2
    fi

    return 0
}


_date () {
    #############################################################
    #### this function generates the date to be added the output
    #### 
    :
}


_run_main () {
    #############################################################
    #### 
    #### main function
    #### 

    #############################################################
    #### asign main variables
    #### 
    declare TRUE="1"
    declare FALSE="0"
    declare VERBOSE="${FALSE}"
    declare VERYVERB="${FALSE}"
    declare -g CONF_LOCATION="$HOME/bin/.config"
    declare -g CONF_FILE="${CONF_LOCATION}/wttr_loop.conf"
    declare -g VERSION="0.01.01"   # 0.00.00 - major.minor.patch


    #############################################################
    #### Set up a trap of the HUP signal to cause this script
    #### to dynamically configure or reconfigure itself upon
    #### receipt of the signal
    #### 
    trap "_configure_wttr_loop ${CONF_FILE}" HUP
    kill -HUP ${$}
    trap - HUP


    #############################################################
    #### parse cmd-line options - getopts
    #### 
    while getopts ":hvVcd" OPTION; do
        case "${OPTION}" in
            d) _date="${TRUE}" ;;
            v) VERBOSE="${TRUE}" ;;
            V) VERYVERB="${TRUE}" ;;
            c) printf "  %b\n" "" "# configuateion file: ${CONF_FILE}" ""\
               && return 0
            ;;
            h) _usage "${0}" "${VERSION}" && return 1
            ;;
            *) printf "  %b\n" "" "# unknown option: ${1}" ""
               _usage "${0}" "${VERSION}" && return 1
            ;;
        esac
    done


    #############################################################
    #### shift out all/any cmd-line options
    #### 
    shift $(( ${OPTIND} - 1 ))


    #############################################################
    #### set debug mode
    #### note: xtrace will commence from this point,
    #### for xtrace of entire script execution run
    #### with bash -x
    (( VERYVERB == TRUE )) && set -x
    (( VERBOSE == TRUE )) && _configure_wttr_loop ${CONF_FILE}


    #############################################################
    #### asign the remaining positional arguments
    #### 
    unset _locs
    _locs=($@)


    #############################################################
    #### loop through the list of places with wttr function
    #### 
    for i in "${!_locs[@]}"; do
        # implement <_date> function
        wttr_cron ~${_locs[i]}?QM0 ${_dir}${_locs[i]%\+*}.txt;
        [ "${i}" -lt $((${#_locs[@]}-1)) ] && sleep ${_interval};
    done

} # endo of main function



#################################################################
#### call the main function with all the positional parameters
#### 
_run_main "${@}"

