#!/bin/bash

if [ -z "$1" ]; then
	echo "No user given. Good bye cruel world!";
	exit 1;
fi

currentUser=$1;
processesList=$(ps -u $currentUser | grep tcsh)

while read -r line; do
	matched=$(echo "$line" | grep "tty")
	if [ -n "$matched" ]; then echo "$line"; fi
done <<< "$processesList"
