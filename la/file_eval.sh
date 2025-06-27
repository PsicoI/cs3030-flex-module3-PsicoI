#!/usr/bin/env bash

# Represents the file that you want to test. 
temp="sales_"
ext=".csv"
today=`date +%Y-%m-%d`
FILE=${temp}${today}${ext}

echo $FILE

DATAFOLDER="data"
# Replace file_name with the target file's name to test.
# Operator - The file test operator to use.
if [ -e $FILE ]

then
 # Tasks to perform if the Operator returns true.
    echo "$FILE exists"

else
 # Tasks to perform if the Operator returns false.
 echo "File does not exist. Sorry Captain."
 echo "TAKING ACTION! Creating $FILE in working directory" 
touch $FILE
fi

# Check if a data folder exists.
if [[ ! -d $DATAFOLDER ]]
then
    echo "$DATAFOLDER does not exist. Creating new directory"
    mkdir $DATAFOLDER
 else
    echo "MOVING $FILE into $DATAFOLDER"
    mv $FILE $DATAFOLDER
fi
# If not, create it, then, move $FILE to it


exit 0
