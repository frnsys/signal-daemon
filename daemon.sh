#!/bin/bash
# this pulls new messages sent to my daemon signal number
# and parses them to a file

OUTPUT_FILE=~/notes/memos.md
NEW_NOTES=0

# this is a little messy b/c bash isn't really
# meant for parsing csvs, and so it doesn't handle quoted
# csv rows well, so we have to strip off the quotes ourselves
notify-send "Fetching memos..."
while IFS=, read -r timestamp body; do
    if [[ "$body" != "\"" ]]; then
        dt=$(date -d @${timestamp:1:10})
        echo -e "# $dt\n" >> $OUTPUT_FILE
        printf "${body:2:${#body}-5}" | sed "s/\"\"/\"/g" >> $OUTPUT_FILE
        echo -e "\n\n---\n" >> $OUTPUT_FILE
        NEW_NOTES=$((NEW_NOTES+1))
    fi
done < <(signal-cli -u ${DAEMONSIGNALNUM} receive --json | jq '[.envelope.timestamp,.envelope.dataMessage.message] | @csv')
notify-send "${NEW_NOTES} new memos"
