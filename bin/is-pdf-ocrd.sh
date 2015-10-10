#!/bin/bash
MYFONTS=$(pdffonts "$1" | tail -n +3 | cut -d' ' -f1 | sort | uniq)
if [ "$MYFONTS" = '' ] || [ "$MYFONTS" = '[none]' ]; then
    echo "No OCR info in: $1"
    exit 1
else
    echo "OCR info found in: $1"
    exit 0
fi
