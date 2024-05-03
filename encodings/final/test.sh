#! /bin/bash

# echo $1 > test.txt

while IFS= read -r line
do
echo "$line"
echo -e "$line\n" >> test.txt

done < $1