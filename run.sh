#!/bin/bash


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
	echo "Successfully Inserted! "
	sleep 1s
}

function remove() {
	sed "/$1/d" AddressBook.txt > temp.txt
	cat temp.txt > AddressBook.txt
	rm temp.txt
	echo "Successfully Deleted! "
	sleep 1s
}

function edit() {
	sketch
	printf "\n\n"
	echo "$1"
	printf "\e[95m Enter the credentials to update \e[295m\n"
	printf "\e[34m Name: "
	read name
	printf "\e[34m Team: "
	read team
	printf "\e[34m Batting average: "
	read avg

	sed "s/$1/$name, $team, $avg/g" AddressBook.txt > temp.txt
	cat temp.txt > AddressBook.txt
	rm temp.txt

	echo "Successfully Edited!"

	sleep 1s
}

function searchByName() {
	sketch
	printf "\n\n"
	if grep -Ei "^[^,]*$1" AddressBook.txt > /dev/null
	then
		echo""
	else 
		echo "No Data Found"
		sleep 1s
		main
	fi
	grep -Ei "^[^,]*$1" AddressBook.txt | column -s "," -t | awk '{print NR":	"$0}' 
	printf "\e[31m	\n\nWhat you wanna do?\e[231m\n\n"
	printf "\e[96m	1.	Remove\e[296m\n"
	printf "\e[96m	2.	Update\e[296m\n"
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
		echo "No Data Found"
		sleep 1s
		main
	fi
	grep -Ei "^[^,]*,[^,]*$1" AddressBook.txt | column -s "," -t | awk '{print NR":	"$0}'
	printf "\e[31m	\n\nWhat you wanna do?\e[231m\n\n"
	printf "\e[96m	1.	Remove\e[296m\n"
	printf "\e[96m	2.	Edit\e[296m\n"
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
		if [ $# -gt '0' ]
		then
			insert $1 $2 $3
		else 
			printf "\e[95m Enter the credentials \e[295m\n"
			echo "Name: "
			read name
			echo "Team: "
			read team
			echo "Batting average: "
			read avg
			insert $name $team $avg
		fi
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
		printf "\e[96m	1.	Insert\e[296m\n"
		printf "\e[96m	2.	Search\e[296m\n"
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