#!/bin/bash

FILENAME="$1"
CONTACT_SECTION=false
CONTACT_COUNT=0

while read -r line; do
    if [[ "$line" =~ BEGIN:VCARD.* ]]; then
        echo "BEGIN:VCARD" >> contact$CONTACT_COUNT.vcf

        CONTACT_SECTION=true

    elif [[ "$line" =~ END:VCARD.* ]]; then
        echo "END:VCARD" >> contact$CONTACT_COUNT.vcf

        CONTACT_SECTION=false
        CONTACT_COUNT=$((CONTACT_COUNT+1))
    
    elif [ $CONTACT_SECTION = true ]; then
        echo "$line" >> contact$CONTACT_COUNT.vcf
    fi
done < "$FILENAME"
