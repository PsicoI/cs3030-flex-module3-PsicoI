#!/bin/bash

# filepath: count_stats.sh

# Input file
input_file_cturek="$2"

#~~~~~~~~~~~~~~~~~~~~~~~~~~GET OPTS SECTION~~~~~~~~~~~~~~~~~~~~~~~~~~#

 if [[  -z $1 ]]; then
    echo -e "No options detected"
    echo -e "Syntax is <OPTIONS> <input_file>"
    echo -e "Please use -h for more information."
    exit 1
    fi

# defines available options
optstring=":hfugwvcpdtTW:"
while getopts "$optstring" options; do
  case "$options" in
    h)  echo -e "Welcome to the ca.sh Module 3 program.\n"
                echo -e "This program counts various statistics from a text file or a URL."
                    echo "Please use the following options: "
                    printf " * -h Display a help message
 * -f FILE read from FILE instead of stdin. ***NOTE*** Cannot be combined with -u \n
 * -u  URL download and read from the file at the given URL. Cannot be combined with -f \n
 * -g input is from Project Gutenberg (ignore all lines before the start of the project and after the end of the project) \n
 * -w output the word count\n
 * -v output the vowel count\n
 * -c output the consonant count\n
 * -p output the punctuation count\n
 * -d output the digit count\n
 * -t output the top 10 MOST frequently used words and their counts\n
 * -T output the top 10 LEAST frequently used words and their counts\n
 * -W WORD output the word count of the specified word\n"
                    exit 0 ;;
 
    -g) echo "Commencing pull from $input_file_cturek" 
    # pulls in text from a Gutenberg project URL 
    curl -s "$input_file_cturek" | 

    # ommits the header and footer
    awk '/\*\*\* START OF THE PROJECT/ {flag=1; next} /\*\*\* END OF THE PROJECT/ {flag=0} flag';; 
    -f) input_file_cturek="$2"; echo "File: $input_file_cturek";
                            echo "File selected";;

    -u) URL="$1"; echo "URL: $URL";;
    *) echo "Unknown option: $1" ;;
  esac
done

if [ -z "$input_file_cturek" ]; then
    echo -e "No file or URL detected: $0 <input_file>\n"
    echo -e "Syntax is <OPTIONS> <input_file>"
    echo -e "Please use -h for more information."
    exit 1
fi

        # Output line count
    echo "Line count in $input_file_cturek:"
wc -l < "$input_file_cturek"


        # Output word count
    echo "Number of words in $input_file_cturek:"
wc -w < "$input_file_cturek"


        # Output vowel count (ignoring y)
    echo "Vowel count in $input_file_cturek:"
grep -o -i '[aeiou]' "$input_file_cturek" | wc -l


        # Output consonant count (including y)
    echo "Consonant count (including y) in $input_file_cturek:"
grep -o -i '[bcdfghjklmnpqrstvwxyz]' "$input_file_cturek" | wc -l


        # Output punctuation count (as defined by tr)
    echo "Number of Punctuation marks in $input_file_cturek:"
tr -cd '[:punct:]' < "$input_file_cturek" | wc -c


        # Output digit count
    echo "Digit count in $input_file_cturek:"
tr -cd '[:digit:]' < "$input_file_cturek" | wc -c


        # Top 10 most frequent words and their counts
    echo "Top 10 most frequent words in $input_file_cturek:"
tr -cs '[:alnum:]' '[\n*]' < "$input_file_cturek" | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr | head -10


        # Top 10 least frequent words and their counts
    echo "Top 10 least frequent words in $input_file_cturek:"
tr -cs '[:alnum:]' '[\n*]' < "$input_file_cturek" | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -n | head -10

# change to test commit with git in kernel