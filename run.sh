#!/bin/bash
clear
printf "\e[34m____________________________________________________________________________________________________________________________________________________________________________________________________________\e[234m\n"
printf "\e[34m|                                                                                                                                            																|\e[234m\n"
printf "\e[34m|                                                                                                                                            																|\e[234m\n"
printf "|                                                                         \e[1;35m Address Book \e[1;235;93m(CRICKET) \e[5;21;293;36m- Stats \e[0m                                                                                       \e[34m|\n"
printf "\e[34m|                                                                                                                                            																|\e[234m\n"
printf "\e[34m|__________________________________________________________________________________________________________________________________________________________________________________________________________|\e[234m\n\n"
runagain='y'
while [ $runagain = 'y' ]
do
	printf "\e[31m	Operations Available:\e[231m\n\n"
	printf "\e[96m	1.	Insert\e[296m\n"
	printf "\e[96m	2.	Search\e[296m\n"
	printf "\e[93m  Choose your option number and input it ( eg : 1) \e[234m\n"
	printf "\e[31m  The match is not case sensitive match. \e[231m\n"

	read data

	if [ $data = '1' ]
	then
		printf "\e[95m Enter the credentials \e[295m\n"
		printf "\e[34m Name:"
		read name
		printf "\e[34m Team:"
		read team
		printf "\e[34m Batting average:"
		read avg

		if `grep -Ei "^\| [^\|]*$name[^\|]*\|" AddressBook.txt`
		then
			printf "\e[31m Warning: You already have this player's data in the Address book. Want to update?\n"
		# 	read response

		# 	if [ $response = 'y' ]
		# 	then
		# 		echo "update"
		# 	else
		# 		echo "Ok Not updated"
		# 	fi
		else
			printf "\e[93m Ok! Updated"
		fi
	fi

	
	printf "\n\n\e[31m  Do you want to search for more Students (y/n)\n"
	read runagain
	
	
done