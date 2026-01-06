#!/usr/bin/env bash

# usage: loopy [-c COUNT --sleep=SECONDS] cmd...

usage() {
  cat <<EOF >&2
Usage: $0 [ -c COUNT -s SECONDS ] cmd...

Run cmd in a loop for COUNT times, stopping on error or if
COUNT times reached.

The time to sleep between iterations can be set using with
-s SECONDS. If not specified, the default is 1 second.

EOF
}


if [[ $# -lt 1 ]]; then
    usage
    exit 1
fi

COUNT=1
SLEEPTIME=1

while getopts ":c:s:" opt; do
    case "${opt}" in
        c)
	    COUNT=${OPTARG}
	    ;;
        s)
	    SLEEPTIME=${OPTARG}
	    ;;
        *)
	    usage
	    ;;
    esac
done
shift $((OPTIND-1))

#echo "SLEEPTIME=$SLEEPTIME"
#echo "COUNT=$COUNT"

CMD="$*"

set -e

STOP=${COUNT}
results=loopy_results_`date +"%Y-%m-%dT%H:%M:%S%z"`.out
cat <<EOF | tee $results
Begin at $(date):
    Looping for ${STOP} iterations.
    Sleeping ${SLEEPTIME} between each.
    Executing command:
        ${CMD}
EOF

count=1
while true; do
    echo -e "\n ==== starting $count of $STOP  ===================== " | tee -a $results
    $CMD | tee -a $results
    echo "`date`: SUCCESS. $count of $STOP" | tee -a $results
    ((count++))
    if [[ $count -gt $STOP ]]; then
        echo "Stopped after $STOP successful iterations." | tee -a $results
        exit 0
    fi
    sleep ${SLEEPTIME}
done
