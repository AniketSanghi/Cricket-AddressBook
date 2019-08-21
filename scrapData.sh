#!/bin/bash

touch Records.txt
touch pagesource.txt
touch data.txt
touch AddressBook.txt

url="http://stats.espncricinfo.com/india/engine/records/batting/highest_career_batting_average.html?class=2;id=6;type=team"

# Fetch the pagesource from the url
curl $url -o pagesource.txt

# Add the Headings for each Field
echo "| Player Name #| Team Name #| Batting Average #|" > Records.txt

# Fetch the data but yet not in order
grep -Eo "[A-Z a-z]*</a></td>|[0-9\.]*</b></td>" pagesource.txt | grep -Eo "[A-Z a-z]*|[0-9\.]*" | paste -d" " - - - -  > data.txt

# Looping through every line and bringing data in order
name=""
team=""
avg=""

while IFS= read -r line; do
  name=`echo $line | grep -Eo "[A-Z a-z]+"`
  avg=`echo $line | grep -Eo "[0-9.]+"`
  team="India"

  echo "| $name #| $team #| $avg #|" >> Records.txt
done < "data.txt"

column -s "#" -t Records.txt > AddressBook.txt

rm pagesource.txt Records.txt data.txt 
