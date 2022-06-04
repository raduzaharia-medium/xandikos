#!/bin/bash

FILENAME="$1"
HEADER_SECTION=true
EVENT_SECTION=false
EVENT_COUNT=0
HEADER=()

while read -r line; do
    if [[ "$line" =~ BEGIN:VEVENT.* ]]; then
        EVENT_SECTION=true
        HEADER_SECTION=false

        printf "%s\n" "${HEADER[@]}" > event$EVENT_COUNT.ics
    
    elif [[ "$line" =~ END:VEVENT.* ]]; then
        echo "END:VEVENT" >> event$EVENT_COUNT.ics
        echo "END:VCALENDAR" >> event$EVENT_COUNT.ics

        EVENT_SECTION=false
        EVENT_COUNT=$((EVENT_COUNT+1))

    elif [ $HEADER_SECTION = true ]; then
        HEADER+=("$line")
    
    elif [ $HEADER_SECTION = false ] && [ $EVENT_SECTION = true ]; then
        echo "$line" >> event$EVENT_COUNT.ics
    fi
done < "$FILENAME"
