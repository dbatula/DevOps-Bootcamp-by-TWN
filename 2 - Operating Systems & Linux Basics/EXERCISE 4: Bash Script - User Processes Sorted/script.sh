#!/bin/bash

echo "Check all Processs for User: $USER"
read -p $'Enter number of Filter:\n1) CPU\n2) MEM\n' filter_number

if [ $filter_number = 1 ]; then
	echo "Filtered by CPU:"
	ps aux | grep "^$USER" | sort -k3 -nr
elif [ $filter_number = 2 ]; then
	echo "Filtered by MEM"
	ps aux | grep "^$USER" | sort -k4 -nr
else
	echo "Without Filter"
	ps aux | grep "^$USER"
fi
