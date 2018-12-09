#!/usr/bin/env bash

# Command co

# co @point
# co @point [operator] pattern
# co [operator] pattern
# co ~
# co -
function co() {
    # co pattern
    # to switch to the cloesest point
    if [ $# -eq 0 ]; then
        # to get the closest point
        local point=`_cox_point_closest_point $PWD`
        if [[ "$closest" == "" ]]; then
            # error, current directory is not in a cox point
            return 1
        fi

        _co_to_absolute "$closest"
        return 0
    fi

    # co -
    # switch to the previous directory
    if [[ "$1" == "-" ]]; then
        cd - >> /dev/null && echo "switch to $PWD"
        return 0
    fi

    local point

    # co @point
    # co @point pattern
    # co @point [operator] pattern
    #if [[ "$1" == @* ]]; then
         
    #fi

    #if [[ "$1" == ">" ]]; then

    #fi

}
