#!/usr/bin/env bash

# FOREGROUND

BLACK="0"
RED="1"
GREEN="2"
YELLOW="3"
BLUE="4"
MAGENTA="5"
CYAN="6"
WHITE="7"

ESC=$(printf '\033')

# Wrapping a string with ANSI color

WRAP() {
    local output=$1
    local c=

    if [ -n "$2" ]; then
        c=$(echo $2 | tr '[a-z]' '[A-Z]')
        output="${ESC}[3${!c}m$output${ESC}[0m"
    fi

    if [ -n "$3" ]; then
        c=$(echo $3 | tr '[a-z]' '[A-Z]')
        output="${ESC}[4${!c}m$output${ESC}[0m"
    fi

    echo $output;
}

# original substr
SUBSTR=

# foreground color
FGC=

# background color
BGC=

HELP() {
    printf 'Usage: coecho [OPTION]... [input-string]...\n'
    printf 'Print a string with highlighting some substrings.\n'
    printf 'Example: coecho -f red -b white -s "hello" "hello world"\n'
    printf 'Supported Colors:\n'
    printf '  BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE.\n'
    printf '\n'
    printf 'Mandatory arguments:\n'
    printf '  %-15.15s specifying a foreground color with a color name\n' '-f'
    printf '  %-15.15s specifying a background color with a color name\n' '-b'
    printf '  %-15.15s the substring for highlighting\n' '-s'
    printf '  %-15.15s display this help information and exit\n' '-h, --help'
    printf '  %-15.15s display the version number and exit\n' '-v, --version'
    printf '\n'
    printf 'COX Project: <https://github.com/Cox-Project/cox>'
}

VERSION() {
    printf 'coecho 0.0.0'
}

while getopts ":f:b:s:hv" option
do
    case "$option" in
        f )
            FGC=$OPTARG
            ;;
        b )
            BGC=$OPTARG
            ;;
        s )
            SUBSTR=$OPTARG
            ;;
        h )
            HELP     
            exit
            ;;
        v )
            VERSION
            exit
            ;;
        \? )
            ;;
    esac

done

shift $((OPTIND - 1))

if [ $# -eq 0 ]; then
    read STRING
else
    case "$1" in
        --help )
            HELP     
            exit
            ;;
        --version )
            VERSION
            exit
            ;;
        * )
            STRING=$1
            ;;
    esac
fi

if [ -z "$STRING" ]; then
    exit
fi

echo "$STRING" | sed -e "s|\($SUBSTR\)|$(WRAP \\1 $FGC $BGC)|"
