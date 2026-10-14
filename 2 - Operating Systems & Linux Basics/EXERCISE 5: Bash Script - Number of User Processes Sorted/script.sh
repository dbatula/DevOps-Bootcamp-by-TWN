#!/bin/bash

echo "Check all Processs for User: $USER"
read -p $'Enter number of Filter:\n1) CPU\n2) MEM\n' filter_number
read -p "Enter how many processes to display: " processes_number

if [ $filter_number = 1 ]; then
	echo "Filtered by CPU:"
	ps aux | grep "^$USER" | sort -k3 -nr | head -n "$processes_number"
elif [ $filter_number = 2 ]; then
	echo "Filtered by MEM"
	ps aux | grep "^$USER" | sort -k4 -nr | head -n "$processes_number"
else
	echo "Without Filter"
	ps aux | grep "^$USER" | head -n "$processes_number"
fi
