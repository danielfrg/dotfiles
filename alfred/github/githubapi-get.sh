#!/bin/bash

if [ ${#@} -lt 2 ]; then
    echo "usage: $0 [your github credentials as 'user:token'] [REST expression]"
    exit 1;
fi

GITHUB_CREDENTIALS=$1
GITHUB_API_REST=$2

GITHUB_API_HEADER_ACCEPT="Accept: application/vnd.github.v3+json"

temp=`basename $0`
TMPFILE=`mktemp /tmp/${temp}.XXXXXX` || exit 1

function rest_call {
    curl -s -u $GITHUB_CREDENTIALS $1 -H "${GITHUB_API_HEADER_ACCEPT}" >> $TMPFILE
}

# Replace with https://github.com/garriguv/alfred-repo eventually
for p in `seq 1 10`; do
    rest_call "https://api.github.com${GITHUB_API_REST}?per_page=200&page=$p"
done

# # single page results (no pagination), have no Link: section, the grep result is empty
# last_page=`curl -s -I -u $GITHUB_CREDENTIALS "https://api.github.com${GITHUB_API_REST}?per_page=200" -H "${GITHUB_API_HEADER_ACCEPT}" | grep '^Link:' | sed -e 's/^Link:.*page=//g' -e 's/>.*$//g'`
# echo $last_page

# # does this result use pagination?
# if [ -z "$last_page" ]; then
#     # no - this result has only one page
#     rest_call "https://api.github.com${GITHUB_API_REST}?per_page=1000"
# else
#     # yes - this result is on multiple pages
# fi

cat $TMPFILE
