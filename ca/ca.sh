#!/bin/bash
# Author: Cody Turek
# Date: 2026-01-05 January 05
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
do_wordcount=false # option w
do_wordsearch=false  # option W

url=""
filename=""
search_word=""

# # Standard Input # #
# Accept piped input from STDIN if no filename is set and input is not a terminal
if [[ -z "$filename" && ! -t 0 ]]; then
    filename="/dev/stdin"
fi
# Saves STDN in to a temp file so all stats can perform their functions
if [[ "$filename" == "/dev/stdin" ]]; then
    tmpfile=$(mktemp)
    cat > "$tmpfile"
    filename="$tmpfile"
    trap 'rm -f "$tmpfile"' EXIT
fi


###
#~~~~~~~~~~~~~~~~~~~~~~~~~~GET OPTS SECTION~~~~~~~~~~~~~~~~~~~~~~~~~~#
# defines available options
optstring="ahfwvcpdtTu:gW:"
while getopts "$optstring" options; do
    case "$options" in 
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
        echo -e "--------------Welcome to Cody's file Stats program--------------"
            echo -e "This program calculates various statistics from a text file or URL."
                echo -e "The following are valid options: "
                    printf "
                        -a output all statistics. This is the easy button and will use all options except -f and -u
                        -c output the number of consonants
                        -d output the number of digits (numbers)
                        -f FILE read from FILE instead of stdin. ***NOTE*** Cannot be combined with -u
                        -g input is from Project Gutenberg (This will ommit all lines before the start of the project and after the end of the project)
                        -h Display a help message
                        -l Counts the number of lines
                        -p Outputs the punctuation count
                        -t MOST-USED output the top 10 MOST frequently used words and their counts
                        -T LEAST-USED output the top 10 LEAST frequently used words and their counts
                        -u  URL download and read from the file at the given URL. Cannot be combined with -f
                        -v VOWEL output the vowel count
                        -w WORD-COUNT output the word count
                        -W WORD output the word count of the specified word.\n"
            exit 0 
        ;;
    
# -l Outputs the count of lines in
        l)
            do_line=true
            echo "Line counter selected."
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
            url="$OPTARG"
            echo "URL: $url"
        ;;

# -g accepts Gutenberg project URL input out of alphabetical order to allow for -g and -f to have stats defined earlier in the script
        g) 
            do_gutenberg=true
        ;;
        
# -v Pulls all vowel count statistic
        v)
            do_vowel=true
        ;;

# -f Expects and accepts file input
        f)
            do_file=true
            filename=$OPTARG
            echo "File: $filename";
        ;;

        w)
            do_wordcount=true
        ;;
        W)
            do_wordsearch=true
            search_word="$OPTARG"
        ;;
# THIS SETS OUTPUTING ALL STATISTICS TO TRUE. The easy button. :)
        a)
            do_all_stats=true
            filename=$OPTARG
        ;;
# if option is unknown
        \?) 
        echo "Unknown option: $1"; exit 1
        ;;
  esac
done
echo
#~~~~~~~~~~~~~~~~~~~~~~~~~~END OF GET OPTS SECTION~~~~~~~~~~~~~~~~~~~~~~~~~~#


#~~~~~~~~~~~~~~~~~~~~~~~~~~START OF SYSTEM CHECKS~~~~~~~~~~~~~~~~~~~~~~~~~~#

# checks for file parameter and sets it operand for most flags
shift $((OPTIND - 1))

# Checks to make sure that the filename and actual file contents are not empty
if [[ -z "$filename" && -n "$OPTARG" && -f "$OPTARG" ]]; then
    filename="$OPTARG"
elif [[ -z "$filename" && -n "$1" && -f "$1" ]]; then
    filename="$1"
fi


# Only run -u logic if NOT using stdin
if [[ "$filename" != "/dev/stdin" && $do_url == true && $do_gutenberg == true ]]; then
    filename=$(basename "$url")
    echo "Commencing pull from $url"
    curl -s "$url" > "$filename"
    
    if [[ $? -ne 0 || ! -s "$filename" ]]; then
        echo "Download failed or file is empty."
        exit 1
    fi
    echo "Saved to $filename"
fi


# Download file if -u is set (and not using stdin)
if [[ "$filename" != "/dev/stdin" && $do_url == true && $do_gutenberg == false ]]; then
    filename=$(basename "$url")
    echo "Commencing pull from $url"
    curl -s "$url" > "$filename"
    if [[ $? -ne 0 || ! -s "$filename" ]]; then
        echo "Download failed or file is empty."
        exit 1
    fi
    echo "Saved to $filename"
fi

# Apply Gutenberg filter if requested (after download or file assignment)
if [[ "$filename" != "/dev/stdin" && $do_gutenberg == true ]]; then
    if [[ -n "$filename" && -f "$filename" ]]; then
        tmpfile=$(mktemp)
        echo "Processing $filename with Gutenberg AWK filter"
        awk '/\*\*\* START OF THE PROJECT/ {flag=1; next} /\*\*\* END OF THE PROJECT/ {flag=0} flag' "$filename" > "$tmpfile"
        
        if [[ ! -s "$tmpfile" ]]; then
            echo "Warning: Gutenberg filter produced no output. File not overwritten."
            rm "$tmpfile"
        else
            mv "$tmpfile" "$filename"
            echo "Filtered and saved to $filename"
        fi
    else
        echo "No file specified or file does not exist."
        exit 1
    fi
fi


# Gutenberg logic + filename
if [[ "$do_file" == true && "$do_gutenberg" == true ]]; then
    if [[ -n "$filename" && -f "$filename" ]]; then
        tmpfile=$(mktemp)
        echo "Processing $filename with Gutenberg AWK filter"
        awk '/\*\*\* START OF THE PROJECT/ {flag=1; next} /\*\*\* END OF THE PROJECT/ {flag=0} flag' "$filename" > "$tmpfile"

        if [[ ! -s "$tmpfile" ]]; then
            echo "Warning: Gutenberg filter produced no output. File not overwritten."
            rm "$tmpfile"
        else
            mv "$tmpfile" "$filename"
            echo "Filtered and saved to $filename"
        fi
    else
        echo "No file specified or file does not exist."
        exit 1
    fi
fi

if [[ "$do_file" == true && "$do_gutenberg" == true ]]; then
    if [[ -n "$filename" && -f "$filename" ]]; then
        tmpfile=$(mktemp)
        echo "Processing $filename with Gutenberg AWK filter"
        awk '/\*\*\* START OF THE PROJECT/ {flag=1; next} /\*\*\* END OF THE PROJECT/ {flag=0} flag' "$filename" > "$tmpfile"

        if [[ ! -s "$tmpfile" ]]; then
            echo "Warning: Gutenberg filter produced no output. File not overwritten."
            rm "$tmpfile"
        else
            mv "$tmpfile" "$filename"
            echo "Filtered and saved to $filename"
        fi
    else
        echo "No file specified or file does not exist."
        exit 1
    fi
fi

# Now check for file existence (but skip if using /dev/stdin)
if [[ "$filename" != "/dev/stdin" && ! -f "$filename" ]]; then
    echo "No file specified or file does not exist."
    exit 1
fi

if [[ -z "$filename" ]]; then
    echo "No file specified or file does not exist."
    exit 1
fi


#~~~~~~~~~~~~~~~~~~~~~~~~START OF INPUT CHECK SECTION~~~~~~~~~~~~~~~~~~~~~~~~#
# checks to see if argument options have been combined and flags them as mutually exclusive
# Checks to make sure that only URL or file is being sent as input
if [[ "$do_file" == true && "$do_url" == true  ]]; then
    echo "Options -f, and -u are mutually exclusive."
    exit 1
fi

if [[ -z "$filename" && ! -t 0 ]]; then
    filename="/dev/stdin"
fi

if [[ -z "$filename" ]]; then
    echo "No file specified or file does not exist."
    exit 1
fi

#~~~~~~~~~~~~~~~~~~~~~~~~~END OF INPUT CHECK SECTION~~~~~~~~~~~~~~~~~~~~~~~~~#



# If no stats flags are set, default to all stats
if [[ "$do_consonant" == false && "$do_digit" == false && "$do_most" == false && "$do_least" == false && "$do_punct" == false && "$do_vowel" == false && "$do_wordcount" == false && "$do_wordsearch" == false ]]; then
    # If no file/URL flags are set, read from stdin and set do_all_stats

     do_all_stats=true

fi

if [[ -z "$filename" && "$do_url" == false && "$do_gutenberg" == false ]]; then
        filename=$OPTARG
        do_all_stats=true
fi

# -a Sets ALL STATS TRUE
    if [[ $do_all_stats == true ]]; then
            do_line=true
            do_consonant=true
            do_digit=true
            do_most=true
            do_least=true
            do_punct=true
            do_vowel=true
            do_wordcount=true


    fi

# -l Line count IF STATEMENT
    if [[ $do_line == true ]]; then
        echo "Line count: "
        grep -c '' "$filename"

    fi

    # Word count for entire file
    if [[ "$do_wordcount" == true ]]; then
        echo "Word count in $filename:"
        wc -w < "$filename"
    fi


# -c Consonant stat IF STATEMENT
    if [[ $do_consonant == true ]]; then
        # Output consonant count (including y)
            echo -e "Consonant count in $filename:"
            grep -o -i '[bcdfghjklmnpqrstvwxyz]' "$filename" | wc -l
    

    fi

 # -v Vowel stat IF STATEMENT
    if [[ $do_vowel == true ]]; then
        # Output vowel count (ignoring y)
            echo -e "Vowel count in $filename:"
            grep -o -i '[aeiou]' "$filename" | wc -l
    
    fi

# -p Punctuation stat IF STATEMENT
    if [[ $do_punct == true ]]; then
        # Output punctuation count
            echo -e "Number of Punctuation marks in $filename:"
            tr -cd '[:punct:]' < "$filename" | wc -c
    
            
    fi

# -d Digit stat IF STATEMENT
    if [[ $do_digit == true ]]; then
        # Output digit count
            echo -e "Digit count in $filename:"
            tr -cd '[:digit:]' < "$filename" | wc -c
    
    fi

# -t Most used words stat IF STATEMENT
    if [[ $do_most == true ]]; then
        # Top 10 most frequent words and their counts
        echo -e "Top 10 most frequent words in $filename:"
        tr -cs '[:alnum:]' '[\n*]' < "$filename" | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr | head -10

    fi

# -T Least used words stat IF STATEMENT
    if [[ $do_least == true ]]; then
    # Top 10 least frequent words and their counts
        echo -e "Top 10 least frequent words in $filename:"
        tr -cs '[:alpha:]' '[\n*]' < "$filename" | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -n | head -10
        

    fi


# Word count for a specific word
    if [[ "$do_wordsearch" == true ]]; then
        if [[ -z "$search_word" ]]; then
            echo "No word specified for -W option."
            exit 1
        fi
        echo "Count of '$search_word' in $filename:"
        grep -o -w -i "$search_word" "$filename" | wc -l
    fi

echo -e "\ndone!"
exit 0