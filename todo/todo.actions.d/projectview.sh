#!/usr/bin/env bash
# 2009-2011 Paul Mansfield
# License: GPL, http://www.gnu.org/copyleft/gpl.html

# Stop Verbose lines, thanks to Mark Harrison
TODOTXT_VERBOSE=0

# Check how we are being run
HOWRUN=$(basename $0)

# If being run as simplepv then turn off all colours.
# Useful for display outside of terminal
if [ $HOWRUN = "simplepv" ] ; then
    TODOTXT_PLAIN=1
    PRI_X=$NONE
    PRI_A=$NONE
    PRI_B=$NONE
    PRI_C=$NONE
    DEFAULT=$NONE
    COLOR_DONE=$NONE
fi

action=$1
shift

# Stop filter now and run in a controlled manner after the _list function is run
TODOTXT_DISABLE_FILTER=1 

[ "$action" = "useage" ] && {
    echo "    $(basename $0) [TERM...]"
    echo "      Show todo items containing TERM, grouped by project, and displayed in"
    echo "      priority order. If no TERM provided, displays entire todo.txt."
    echo ""
    exit
}

# Show projects in alphabetical order and todo items in priority order
echo "=====  Projects  ====="
echo ""

# Find all projects and sort
PROJECTS=$(grep -o '[^ ]*+[^ ]\+' "$TODO_FILE" | grep '^+' | sort -u | sed 's/^+//g' )

# For each project show header and the list of todo items
for project in $PROJECTS ; do 
    # Use core _list function, does numbering and colouring for us
    PROJECT_LIST=$(_list "$TODO_FILE" "+$project\b" "$@" | sed 's/\ *+[a-zA-Z0-9._\-]*\ */ /g')
    if [[ -n "${PROJECT_LIST}" ]]; then
        echo  "---  $project  ---"
        echo  "${PROJECT_LIST}" | eval $TODOTXT_FINAL_FILTER 
        # If run as simplepv don't add newlines
        if [ $HOWRUN != "simplepv" ] ; then
            echo  ""
        fi
    fi
done

# Show todo items not associated to a project
PROJECT_LIST=$(_list "$TODO_FILE" "$@" | grep -v "+\w" )
if [[ -n "${PROJECT_LIST}" ]]; then
    echo "--- Not in projects ---"
    echo "${PROJECT_LIST}" | eval $TODOTXT_FINAL_FILTER
fi
