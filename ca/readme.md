# Project Gutenberg Stats Counter -- complete

In this project you will create a bash script that processes ebook text files from project gutenberg and outputs various statistics about the file.  The script should also work with other text files as well.  The details are described below.


## Purpose

This assignment will allow you to demonstrate proficiency using various command-line utilities to perform complex text processing tasks.  It will also allow you to demonstrate proficiency piping commands together and checking exit codes for errors

## Details

When run without any parameters your script should read text from stdin and output the following statistics

- output line count
- word count
- vowel count (ignore y)
- consanant count (include y)
- punctuation count (as defined by tr)
- digit count
- top 10 most frequent words and their counts
- top 10 least frequent words and their counts

### Command line options

Using getopts your script should take the following command line parameters:

 * -h --help Display a help message
 * -f --file FILE read from FILE instead of stdin. Cannot be combined with -u
 * -u --url URL download and read from the file at the given URL. Cannot be combined with -f
 * -g input is from Project Gutenberg (ignore all lines before the start of the project and after the end of the project)
 * -w output the word count
 * -v output the vowel count
 * -c output the consanant count
 * -p output the punctuation count
 * -d output the digit count
 * -t output the top 10 most frequent words and their counts
 * -T ouptut the top 10 least frequent words and their counts
 * -W WORD output the word count of the specified word

### Project Gutentberg files

eBook text files from Project Gutenberg are a great source of inputs for this program.  However, they usually include some header and footer information at the beginning and the end of the file.  The actual text is found between the lines  ` *** START OF THE PROJECT  ... ***` and `             *** END OF THE PROJECT ... ***`.  When the -g flag is passed as a parameter you should exclude these headers and footers from the processing.

### Cleanup

If your script produces any temporary files to store some of the intermediate results be sure to delete them before exiting.

### Error handling

Your script should always check the exit codes of any commands it runs to ensure there are no errors.  If an error occurs (either in your own script or in one of the other commands you run) your own script should exit with a non-zero exit code.


### Tips and Tricks

You can use `tee` to both read from stdin and save it to a file for later processing.  This is helpful when computing more than one statistic on the input file. If you want to be really fancy you can even use `tee` with process substitution to run all of the processing simultaneously but this is not required for the assignment.

You'll probably benefit from the use of `tee, cat, grep, sed, tr, curl, sort, and uniq, wc`.

Specifically, `tr` can be used to split your text into tokens (words, vowels, consanants, etc) and then wc can count the tokens. You can also use sort and uniq when sorting and counting words, grep to find specific words, and sed to remove the project gutenberg header and footers.  There is more than one way to solve most of these tasks.  Find a set of utilities that can be combined to produce the output you need.

## Sample output

```
$ cat romeo_and_juliet.txt | ./ca.sh
Line Count: 5694
Word Count: 28987
Consanant Count: 75907
Vowel Count: 47018
Punctation Count: 7384
Digit Count: 148
Most Frequent Words
    782 the
    656 I
    551 and
    538 to
    477 of
    464 a
    360 in
    331 is
    326 you
    313 s
Least Frequent Words
      1 ACTUAL
      1 AGREEMENT
      1 ANYTHING
      1 AS
      1 Abate
      1 About
      1 Above
      1 Abraham
      1 Abram
      1 Accurs
```


```
$ ./ca.sh -f romeo_and_juliet.txt
Line Count: 5694
Word Count: 28987
Consanant Count: 75907
Vowel Count: 47018
Punctation Count: 7384
Digit Count: 148
Most Frequent Words
    782 the
    656 I
    551 and
    538 to
    477 of
    464 a
    360 in
    331 is
    326 you
    313 s
Least Frequent Words
      1 ACTUAL
      1 AGREEMENT
      1 ANYTHING
      1 AS
      1 Abate
      1 About
      1 Above
      1 Abraham
      1 Abram
      1 Accurs
```

```
$ cat romeo_and_juliet.txt | ./ca.sh -g 
Line Count: 5275
Word Count: 25958
Consanant Count: 66536
Vowel Count: 41206
Punctation Count: 6935
Digit Count: 0
Most Frequent Words
    656 I
    612 the
    484 and
    462 to
    407 a
    366 of
    309 is
    307 s
    304 my
    302 in
Least Frequent Words
      1 AND
      1 Abate
      1 Above
      1 Abraham
      1 Abram
      1 Accurs
      1 Acquaint
      1 Act
      1 Adding
      1 Adieu
```

```
$ ./ca.sh -u https://www.gutenberg.org/cache/epub/1513/pg1513.txt -g -w -v -W Romeo -t
Word Count: 25958
Vowel Count: 41206
Most Frequent Words
    656 I
    612 the
    484 and
    462 to
    407 a
    366 of
    309 is
    307 s
    304 my
    302 in
"Romeo" count: 151
```


