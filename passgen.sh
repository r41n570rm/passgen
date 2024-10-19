#!/bin/bash
# Purpose: Password Generator - Includes OWASP password special characters
# Date: 2024.10.17


# Usage function
usage() {
	echo -e "Usage:"
	echo -e "-u	-	Include uppercase characters"
	echo -e "-l	-	Include lowercase characters"
	echo -e "-n	-	Include numbers"
	echo -e "-s 	-	Include special characters"
	echo -e "-c	-	Copy generated password to clipboard (Note: Password is not displayed to terminal when option -c is specified"
	exit 1
}

OPTERR="Invalid script options specified!"

uppercase_chars="[:upper:]" 
lowercase_chars="[:lower:]"
numbers="[:digit:]"
special_chars="!\"#$%&'()*+,-./:;<=>?@[\\]^_\`{|}~" # OWASP password special characters (space not included)

choice=""


if [[ $# -eq 0 ]]; then
	usage	
fi


# Handling options using getopts
while getopts 'ulnsc' opt; do
	case $opt in
		u)	choice+=$uppercase_chars
			;;

		l)	choice+=$lowercase_chars
			;;

		n)	choice+=$numbers
			;;

		s)	choice+=$special_chars
			;;
		c)	clipboard=true
			;;
		*)	echo -e $OPTERR && usage
			;;	
	esac
done


read -r -p "Enter password length: " pass_len # Prompt user to enter desired password length


if [[ $clipboard ]]; then	
	cat /dev/urandom| tr -cd $choice | head -c $pass_len | xclip -selection clipboard # Generate password and redirect output to clipboard using xclip
else
	cat /dev/urandom| tr -cd $choice | head -c $pass_len	# Generate and display password to terminal
fi

exit 0
