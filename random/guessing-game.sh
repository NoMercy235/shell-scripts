#!/bin/bash

# A simple guessing game.

# Get a random number < 100
target=$(($RANDOM % 100))

# With variables
# decalre -ir target=$(( ($RANDOM % 100) + 1 ))

# Initialize the user's guess.
# Leaving it empty counts as an empty string
guess=

# With declare
# decalre -i guess=0

# or (( guess == target ))
until [[ $guess -eq $target ]]; do
	read -p "Take a guess: " guess

	# or (( guess < target )) or (( guess > target ))
	if [[ $guess -lt $target ]]; then
		echo "Higher!"
	elif [[ $guess -gt $target ]]; then
		echo "Lower!"
	else
		echo "Found it"
	fi
done

exit 0
