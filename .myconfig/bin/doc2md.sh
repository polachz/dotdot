#!/bin/sh

#This script converts the MS Word docx file to another (defaul is markdown)
#By use open source tool Pandoc
#
#Used for my blog or GitHub page creation
#

source ~/.myconfig/bash/functions.sh

dump_usage() {
   echo -e "\nConvert MS Docx file to markdown"
   echo -e "\nUsage: doc2md.sh [-f output_format] [-o output_file] source_file\n"

   exit 1
}

if ! is_binary_installed 'pandoc'; then
   echo "Pandoc is not installed!!! use dnf pandoc to install it"
fi

if [ -z "$1"  ]; then
   echo -e "\nERROR: MS Word source file is not specified!!!"
   dump_usage
fi

#SOURCE_FILE=$1
OUTPUT_FILE="index.md"
OUTPUT_FORMAT="gfm"

while getopts "foh" option
do
   case "$option" in
      f)   OUTPUT_FORMAT="${OPTARG}";;
      o)   OUTPUT_FILE="${OPTARG}";;
      ?)   dump_usage;;
      h)   dump_usage;;
      *)   echo -e "option ${OPTARG} unknown." dump_usage ;;
   esac
done
shift $((OPTIND -1))

if [ -z "$1"  ]; then
   echo "Source MS word file is not specified"
   dump_usage
fi

echo "Converting \"$1\" file to \"$OUTPUT_FILE\" with format \"$OUTPUT_FORMAT\""

#pandoc -f docx -t "$OUTPUT_FORMAT"  -o "$OUTPUT_FILE" "$SOURCE_FILE"

echo ""
echo "Done.."

