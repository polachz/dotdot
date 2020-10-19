#!/bin/sh

SOURCE_FILE=$1
OUTPUT_FILE=${2-index.md}
OUTPUT_FORMAT=${3-gfm}
pandoc -f docx -t "$OUTPUT_FORMAT"  -o "$OUTPUT_FILE" "$SOURCE_FILE"
