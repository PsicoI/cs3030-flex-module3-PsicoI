#!/bin/bash
# Author: Cody Turek
# Date: 2023-10-30
# Description: This script counts various statistics from a text file or a URL.

do_all_stats=false # option a check
do_consonant=false # option c ||
do_digit=false # option d 
do_gutenberg=false # option g  check
do_most=false # option t ||
do_least=false # option T
do_punct=false # option p 
do_url=false # option u
do_vowel=false # option v check
url=""
input_file_cturek="$2" # Input file
filename="$input_file_cturek"


###
##
# Checks to see if required parameters are used
 if [[ -z $1 ]]; then
        echo -e "No options detected"
        echo -e "Syntax is <OPTIONS> <input_file>"
        echo -e "Please use -h for more information."
        exit 1
    fi

 if [ -z "$input_file_cturek" ]; then
        echo -e "No file or URL detected: $0 <input_file>\n"
        echo -e "Syntax is <OPTIONS> <input_file>"
        echo -e "Please use -h for more information."
        exit 1
    fi
##
###
#~~~~~~~~~~~~~~~~~~~~~~~~~~GET OPTS SECTION~~~~~~~~~~~~~~~~~~~~~~~~~~#
# defines available options
optstring=":ahfugwvcpdtTW:"
while getopts "$optstring" options; do
    case "$options" in
# THIS SETS OUTPUTING ALL STATISTICS TO TRUE. The easy button. :)
        a)
            do_all_stats=true
            filename=$input_file_cturek
        ;;
# -c Pulls Consonant count statistics
        c)
            do_consonant=true
            echo -e "Consonant count option selected!\n\n"
        ;;
# -d Pulls digit count statistics
        d)
            do_digit=true
            echo -e "Digit count option selected!\n\n"
        ;;
# -h Start of help section
        h)  
        echo -e "Welcome to the ca.sh Module 3 program.\n"
            echo -e "This program counts various statistics from a text file or a URL."
                echo "Please use the following options: "
                    printf "
                        -a output all statistics. This is the easy button and will use all options except -f and -u
                        -c output the consonant count
                        -d output the digit count
                        -f FILE read from FILE instead of stdin. ***NOTE*** Cannot be combined with -u
                        -g input is from Project Gutenberg (ignore all lines before the start of the project and after the end of the project)
                        -h Display a help message
                        -p output the punctuation count
                        -t MOST-USED output the top 10 MOST frequently used words and their counts
                        -T LEAST-USED output the top 10 LEAST frequently used words and their counts
                        -u  URL download and read from the file at the given URL. Cannot be combined with -f
                        -v VOWEL output the vowel count
                        -w WORD-COUNT output the word count
                        -W WORD output the word count of the specified word.\n"
            exit 0 
        ;;
    


# -p Outputs all punctuation statistics
        p)
            do_punct=true
            echo "Punctuation counter selected."
        ;;
# -t Outputs MOST frequent 10 words
        t)
            do_most=true
            echo "Most used words counter selected."
        ;;
# -T Outputs LEAST frequent 10 words
        T)
            do_least=true
            echo "Least used words counter selected."
        ;;
# -u URL input (not specific to gutenberg)
        u)
            do_url=true 
            url="$input_file_cturek"
            echo "URL: $url"
        ;;
# -v Pulls all vowel count statistic
        v)
            do_vowel=true
            ;;
# -g accepts Gutenberg project URL input out of alphabetical order to allow for -g and -f to have stats defined earlier in the script
        g) 
            do_gutenberg=true
            url="$OPTARG"
        ;;
# -f Expects and accepts file input
        f)

            filename=$input_file_cturek
            echo "File: $filename";
            echo "File selected"

            if ! $do_consonant && ! $do_digit && ! $do_most && ! $do_least && ! $do_punct && ! $do_vowel && ! $do_all_stats; then
                echo -e "No other options detected"
                echo -e "Syntax is <OPTIONS> <input_file>"
                echo -e "Please use -h for more information."
                exit 1
            fi
        ;;
# if option is unknown
        *) 
        echo "Unknown option: $1"; exit 1
        ;;
  esac
done
#~~~~~~~~~~~~~~~~~~~~~~~~~~END OF GET OPTS SECTION~~~~~~~~~~~~~~~~~~~~~~~~~~#

# checks to see if argument options have been combined and flags them as mutually exclusive
if [[ "$do_file" == true && ( "$do_url" == true || "$do_gutenberg" == true ) ]]; then
    echo "Options -f, -u, and -g are mutually exclusive."
    exit 1
fi

# -g function:
    if [[ $do_gutenberg == true ]]; then
        echo "Commencing pull from $url"

        # Extract filename from URL (e.g., pg76386.txt)
        filename=$(basename "$url")

            # pulls in text from a Gutenberg project URL
            curl -s "$url" |
            # ommits the header and footer
            awk '/\*\*\* START OF THE PROJECT/ {flag=1; next} /\*\*\* END OF THE PROJECT/ {flag=0} flag' > "$filename"  
            # checks if the file was downloaded successfully
            if [[ $? -ne 0 || ! -s "$filename" ]]; then
                echo "Download failed or file is empty."
                exit 1
            fi
            echo "Saved to $filename"
            # -- END OF -G --

        echo -e "\ndone!"
    fi

# -u function
    if [[ $do_url == true ]]; then
        echo "Commencing pull from $url"

        # Extract filename from URL (e.g., pg76386.txt)
        filename=$(basename "$url")

            # pulls in text from a URL
            curl -s "$url" > "$filename"
            # checks if the file was downloaded successfully
            if [[ $? -ne 0 || ! -s "$filename" ]]; then
                echo "Download failed or file is empty."
                exit 1
            fi

            echo "Saved to $filename"
            # -- END OF -U --

        echo -e "\ndone!"
    fi
# -a Sets ALL STATS TRUE
    if [[ $do_all_stats == true ]]; then

        do_consonant=true # option c ||
        do_digit=true # option d
        do_most=true # option t ||
        do_least=true # option T
        do_punct=true # option p
        do_vowel=true # option v check
    fi



# -c Consonant stat IF STATEMENT
    if [[ $do_consonant == true ]]; then
        # Output consonant count (including y)
            echo -e "Consonant count (including y) in $filename:"
            grep -o -i '[bcdfghjklmnpqrstvwxyz]' "$filename" | wc -l
            echo -e "\n"

    fi
# -d Digit stat IF STATEMENT
    if [[ $do_digit == true ]]; then
        # Output digit count
            echo -e "Digit count in $filename:"
            tr -cd '[:digit:]' < "$filename" | wc -c
            echo -e "\n"
    fi

# -p Punctuation stat IF STATEMENT
    if [[ $do_punct == true ]]; then
        # Output punctuation count
            echo -e "Number of Punctuation marks in $filename:"
            tr -cd '[:punct:]' < "$filename" | wc -c
            echo -e "\n"
            
    fi


# -t Most used words stat IF STATEMENT
    if [[ $do_most == true ]]; then
        # Top 10 most frequent words and their counts
        echo -e "Top 10 most frequent words in $filename:"
        tr -cs '[:alnum:]' '[\n*]' < "$filename" | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr | head -10
        echo -e "\n"
    fi

# -T Least used words stat IF STATEMENT
    if [[ $do_least == true ]]; then
    # Top 10 least frequent words and their counts
        echo -e "Top 10 least frequent words in $filename:"
        tr -cs '[:alnum:]' '[\n*]' < "$filename" | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -n | head -10
        echo -e "\ndone!"

        exit 0
    fi
# -v Vowel stat IF STATEMENT
    if [[ $do_vowel == true ]]; then
        # Output vowel count (ignoring y)
            echo -e "Vowel count in $filename:"
            grep -o -i '[aeiou]' "$filename" | wc -l
            echo -e "\n"
    fi

exit 0