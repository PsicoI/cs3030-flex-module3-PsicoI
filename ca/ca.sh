#!/bin/bash

# filepath: count_stats.sh

# Input file
input_file_cturek="$1"

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

