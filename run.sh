#!/bin/bash

function printTable()
{
    local -r delimiter="${1}"
    local -r data="$(removeEmptyLines "${2}")"

    if [[ "${delimiter}" != '' && "$(isEmptyString "${data}")" = 'false' ]]
    then
        local -r numberOfLines="$(wc -l <<< "${data}")"

        if [[ "${numberOfLines}" -gt '0' ]]
        then
            local table=''
            local i=1

            for ((i = 1; i <= "${numberOfLines}"; i = i + 1))
            do
                local line=''
                line="$(sed "${i}q;d" <<< "${data}")"

                local numberOfColumns='0'
                numberOfColumns="$(awk -F "${delimiter}" '{print NF}' <<< "${line}")"

                # Add Line Delimiter

                if [[ "${i}" -eq '1' ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi

                # Add Header Or Body

                table="${table}\n"

                local j=1

                for ((j = 1; j <= "${numberOfColumns}"; j = j + 1))
                do
                    table="${table}$(printf '#| %s' "$(cut -d "${delimiter}" -f "${j}" <<< "${line}")")"
                done

                table="${table}#|\n"

                # Add Line Delimiter

                if [[ "${i}" -eq '1' ]] || [[ "${numberOfLines}" -gt '1' && "${i}" -eq "${numberOfLines}" ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi
            done

            if [[ "$(isEmptyString "${table}")" = 'false' ]]
            then
                echo -e "${table}" | column -s '#' -t | awk '/^\+/{gsub(" ", "-", $0)}1'
            fi
        fi
    fi
}

function removeEmptyLines()
{
    local -r content="${1}"

    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString()
{
    local -r string="${1}"
    local -r numberToRepeat="${2}"

    if [[ "${string}" != '' && "${numberToRepeat}" =~ ^[1-9][0-9]*$ ]]
    then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function isEmptyString()
{
    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true' && return 0
    fi

    echo 'false' && return 1
}

function trimString()
{
    local -r string="${1}"

    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}

function check () {
	if grep -Ei "^[^,]*$1" AddressBook.txt > /dev/null
	then
		retval="1"
	else 
		retval="0"
	fi
}

function insert() {
	echo "$1, $2, $3" >> AddressBook.txt
	echo "
	Successfully Inserted! "
	sleep 1s
}

function remove() {
	sed "/$1/d" AddressBook.txt > temp.txt
	cat temp.txt > AddressBook.txt
	rm temp.txt
	echo "
	Successfully Deleted! "
	sleep 1s
}

function edit() {
	sketch
	printf "\n\n"
	echo "Player Name,Team Name,Batting Avg" > temp.txt
	echo "$1">> temp.txt
	printTable ',' "$(cat temp.txt)"
	printf "\n\n\e[95m Which credential to update \e[295m\n\n"
	printf "\e[96m	1.	Player Name \e[296m\n"
	printf "\e[96m	2.	Team Name\e[296m\n"
	printf "\e[96m	3.	Batting Average \e[296m\n"
	printf "\e[96m	4.	Main Menu \e[296m\n"
	read reply

	if [ $reply = '1' ]
	then
		echo "Enter the Player's Name"
		read name
		awk -F, -v a="${1}" -v b=$name '$0 ~ a {$1=b} 1' OFS="," AddressBook.txt > temp.txt
		cat temp.txt > AddressBook.txt
		rm temp.txt

		echo "
		Successfully Edited!"

		sleep 1s

		edit "`awk -F, -v a="${1}" -v b=$name '$0 ~ a {$1=b} 1' OFS="," <<< $1`"
		
	elif [ $reply = '2' ]
	then
		echo "Enter the Team's Name"
		read team
		awk -F, -v a="${1}" -v b=$team '$0 ~ a {$2=b} 1' OFS="," AddressBook.txt > temp.txt
		cat temp.txt > AddressBook.txt
		rm temp.txt

		echo "
		Successfully Edited!"

		sleep 1s

		edit "`awk -F, -v a="${1}" -v b=$team '$0 ~ a {$2=b} 1' OFS="," <<< $1`"


	elif [ $reply = '3' ]
	then
		echo "Enter the Batting average"
		read avg
		awk -F, -v a="${1}" -v b=$avg '$0 ~ a {$3=b} 1' OFS="," AddressBook.txt > temp.txt
		cat temp.txt > AddressBook.txt
		rm temp.txt	

		echo "
		Successfully Edited!"

		sleep 1s

		edit "`awk -F, -v a="${1}" -v b=$avg '$0 ~ a {$3=b} 1' OFS="," <<< $1`"

		
	else
		main
	fi



}

function searchByName() {
	sketch
	printf "\n\n"
	if grep -Ei "^[^,]*$1" AddressBook.txt > /dev/null
	then
		echo""
	else 
		echo "No Data Found!!!"
		sleep 1s
		main
	fi
	echo "S.No.,Player Name,Team Name,Batting Avg" > temp.txt
	grep -Ei "^[^,]*$1" AddressBook.txt | awk '{print NR","$0}' >> temp.txt
	printTable ',' "$(cat temp.txt)"
	printf "\e[31m	\n\nWhat you wanna do?\e[231m\n\n"
	printf "\e[96m	1.	Remove an entry\e[296m\n"
	printf "\e[96m	2.	Update an entry\e[296m\n"
	printf "\e[96m	3.	Add New Entry\e[296m\n"
	printf "\e[96m	4.	Go Back! \e[296m\n"
	printf "\e[93m  \nChoose your option number and input it ( eg : 1) \e[234m\n"
	read reply

	

	if [ $reply = '1' ]
	then
		printf "\e[93m  \nChoose your line number to remove ( eg : 1) \e[234m\n"
		read response

		line=`grep -Ei "^[^,]*$1[^,]*,[^,]*,[^,]*" AddressBook.txt | awk -v var="$response" '{if(NR==var) print}'`
		remove "$line"

	elif [ $reply = '2' ]
	then
		printf "\e[93m  \nChoose your line number to edit ( eg : 1) \e[234m\n"
		read response

		line=`grep -Ei "^[^,]*$1[^,]*,[^,]*,[^,]*" AddressBook.txt | awk -v var="$response" '{if(NR==var) print}'`
		edit "$line"


	elif [ $reply = '3' ]
	then
		
			printf "\e[95m Enter the credentials \e[295m\n"
			echo "Name: "
			read name
			echo "Team: "
			read team
			echo "Batting average: "
			read avg
			insert $name $team $avg
		
	else
		main
	fi
}

function searchByTeam() {
	sketch
	printf "\n\n"
	if grep -Ei "^[^,]*,[^,]*$1" AddressBook.txt > /dev/null
	then
		echo""
	else 
		echo "No Data Found!!!"
		sleep 1s
		main
	fi
	echo "S.No.,Player Name,Team Name,Batting Avg" > temp.txt
	grep -Ei "^[^,]*,[^,]*$1" AddressBook.txt | awk '{print NR","$0}' >> temp.txt
	printTable ',' "$(cat temp.txt)"
	printf "\e[31m	\n\nWhat you wanna do?\e[231m\n\n"
	printf "\e[96m	1.	Remove an entry\e[296m\n"
	printf "\e[96m	2.	Edit an entry\e[296m\n"
	printf "\e[96m	3.	Add New Entry\e[296m\n"
	printf "\e[96m	4.	Go Back! \e[296m\n"
	printf "\e[93m  \nChoose your option number and input it ( eg : 1) \e[234m\n"
	read reply

	if [ $reply = '1' ]
	then
		printf "\e[93m  \nChoose your line number to remove ( eg : 1) \e[234m\n"
		read response

		line=`grep -Ei "^[^,]*,[^,]*$1[^,]*,[^,]*" AddressBook.txt | awk -v var=$response '{if(NR==var) print}'`
		remove "$line"

	elif [ $reply = '2' ]
	then
		printf "\e[93m  \nChoose your line number to edit ( eg : 1) \e[234m\n"
		read response

		line=`grep -Ei "^[^,]*,[^,]*$1[^,]*,[^,]*" AddressBook.txt | awk -v var="$response" '{if(NR==var) print}'`
		edit "$line"


	elif [ $reply = '3' ]
	then
			printf "\e[95m Enter the credentials \e[295m\n"
			echo "Name: "
			read name
			echo "Team: "
			read team
			echo "Batting average: "
			read avg
			insert $name $team $avg
		
	else
		main
	fi
}


function sketch() {
	clear
	printf "\e[34m____________________________________________________________________________________________________________________________________________________________________________________________________________\e[234m\n"
	printf "\e[34m|                                                                                                                                            																|\e[234m\n"
	printf "\e[34m|                                                                                                                                            																|\e[234m\n"
	printf "|                                                                         \e[1;35m Address Book \e[1;235;93m(CRICKET) \e[5;21;293;36m- Stats \e[0m                                                              									\e[34m|\n"
	printf "\e[34m|                                                                                                                                            																|\e[234m\n"
	printf "\e[34m|__________________________________________________________________________________________________________________________________________________________________________________________________________|\e[234m\n\n"
}

function main() {
	while [ 1 ]
	do
		sketch
		printf "\e[31m	Operations Available:\e[231m\n\n"
		printf "\e[96m	1.	Insert an entry\e[296m\n"
		printf "\e[96m	2.	Search for an entry\e[296m\n"
		printf "\e[96m	3.	Exit\e[296m\n"
		printf "\e[93m  \nChoose your option number and input it ( eg : 1) \e[234m\n"
		printf "\e[31m  The match is not case sensitive match. \e[231m\n\n"

		read data

		if [ $data = '1' ]
		then
			printf "\e[95m Enter the credentials \e[295m\n"
			echo "Name: "
			read name
			echo "Team: "
			read team
			echo "Batting average: "
			read avg

			# Check if the data is already present
			check $name
			if [ $retval = '1' ]
			then
				printf "\e[31m Entries with similar name exists \e[234m\n\e[96m"
				searchByName "$name" "$team" "$avg"
			else
				insert $name $team $avg
			fi

			
		elif [ $data = '2' ]
		then
			sketch
			printf "\e[31m	Operations Available:\e[231m\n\n"
			printf "\e[96m	1.	Search By Player's Name \e[296m\n"
			printf "\e[96m	2.	Search By Team's Name \e[296m\n"
			printf "\e[96m	3.	Go back \e[296m\n"
			printf "\e[93m  \nChoose your option number and input it ( eg : 1) \e[234m\n"
			printf "\e[31m  The match is not case sensitive match. \e[231m\n\n"
			read response
			if [ $response = '1' ]
			then
				echo "Please Enter Player's name: "
				read name
				searchByName $name
			elif [ $response = '2' ]
			then
				echo "Please Enter Team's name: "
				read team
				searchByTeam $team
			else 
				main
			fi
		else
			printf "\n\nNice to meet you! Come again! :)\n\n"
			exit
		fi
	done
}

main