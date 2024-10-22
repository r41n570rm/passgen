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

#######################################
# Generate password
# Globals:
#   choice
#   pass_len
# Arguments:
#   None
# Outputs:
#   Generated password
#######################################
genPassword(){
	cat /dev/urandom | tr -cd "$choice" | head -c "$pass_len" # Generate and display password
}

OPTERR="Invalid script options specified!"

uppercase_chars="[:upper:]" 
lowercase_chars="[:lower:]"
numbers="[:digit:]"
special_chars="!\"#$%&'()*+,-./:;<=>?@[\\]^_\`{|}~" # OWASP password special characters (space not included)

choice=""
# Handling command line options using getopts
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
		*)	echo -e "$OPTERR" && usage
			;;	
	esac
done

# Display usage message if options have not been specified
if [[ -z $choice ]]; then
	usage
fi

read -r -p "Enter password length: " pass_len # Prompt user to enter desired password length

if [[ $clipboard ]]; then	
	genPassword | xclip -selection clipboard 	# Generate password and redirect output to clipboard using xclip
else
	genPassword	 				# Generate password and display to terminal
fi

exit 0
