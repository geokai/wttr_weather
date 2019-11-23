#!/bin/bash

# This file was created on 25/12/18
# Author: George Kaimakis - https://github.com/geokai


#################################################################
#### 
#### Description:
#### 
#### Place a full text description of your shell function here.
#### 
#### Assumptions:
#### 
#### Provide a list of assumptions your shell function makes,
#### with a description of each assumption.
#### 
#### Dependencies:
#### 
#### Provide a list of dependencies your shell function has,
#### with a description of each dependency.
#### 
#### Products:
#### 
#### Provide a list of output your shell function produces,
#### with a description of each product.
#### 
#### Configured Usage:
#### 
#### Describe how your shell function should be used.
#### 
#### Details:
#### 
#################################################################


_usage () {
    #############################################################
    #### usage function
    #### 
    _get_name_version "${0}"
    printf "  %b\n"\
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


_get_date () {
    #############################################################
    #### this function generates the date to be added to the
    #### output
    #### 
    printf " %b\n"\
    ""\
    "# $(TZ=${_tzone:-${_utc}} date -R)"\
    ""
}


_get_name_version () {
    #############################################################
    #### prints the script name and version number
    #### 
    printf "  %b\n"\
    ""\
    "$(basename ${1%.*})  version: ${VERSION}  created: ${CREATED}"\
    ""
}


_print_config_file () {
    printf "  %b\n" "# configuateion file: ${CONF_FILE}"\
    ""
    printf "%b\n" "Config file contents:"
    printf "%b\n" "$(cat ${CONF_FILE})"\
    ""
    return 0
}


_run_main () {
    #############################################################
    #### main function
    #### 
    #############################################################
    #### asign main variables
    #### 
    declare TRUE="1"
    declare FALSE="0"
    declare _date="${FALSE}"
    declare VERBOSE="${FALSE}"
    declare VERYVERB="${FALSE}"
    declare -g CONF_LOCATION="$HOME/bin/.config"
    declare -g CONF_FILE="${CONF_LOCATION}/wttr_loop.conf"
    declare -g VERSION="0.01.01"   # 0.00.00 - major.minor.patch
    declare -g _utc="Europe/London"
    declare -g _tzone=


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
            d) _date="${TRUE}"; _tzone="${2}" ;;
            v) VERBOSE="${TRUE}" ;;
            V) VERYVERB="${TRUE}" ;;
            c) _print_config_file && return 0 ;;
            h) _usage "${0}" "${VERSION}" && return 0 ;;
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
    #### 
    (( VERYVERB == TRUE )) && set -x
    (( VERBOSE == TRUE )) && { _get_name_version "${0}"; return 0; }

    # (( _date == TRUE )) &&  { _get_date "${_tzone}"; }

    #############################################################
    #### asign the remaining positional arguments
    #### 
    unset _locs
    _locs=($@)


    #############################################################
    #### check if lcations have been provided and exit if not
    #### 
    [[ -z "${_locs}" ]] && { printf " %b\n" "# no location provided!";\
                            _usage  "${0}" "${VERSION}"; return 1; }


    #############################################################
    #### loop through the list of places with wttr function
    #### 
    for i in "${!_locs[@]}"; do
        # TODO implement <_date> function
        (( _date == TRUE )) &&  { _get_date "${_tzone}"; }
        wttr_cron ~${_locs[i]}?q0 ${_dir}${_locs[i]%\+*}.txt;
        [ "${i}" -lt $((${#_locs[@]}-1)) ] && sleep ${_interval};
    done
    return 0

} # endo of main function



#################################################################
#### call the main function with all the positional parameters
#### 
_run_main "${@}"

