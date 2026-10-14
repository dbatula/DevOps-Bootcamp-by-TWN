#!/bin/bash

if command -v java >/dev/null 2>&1
then
        echo "Java is installed (+)"
        java_version=$(java -version 2>&1 | awk -F'["\.]' '/version/ {print $2}')

        if [ $java_version -ge 11 ]
        then
                echo "Java version is higher or equall of 11 installed"
	elif [ $java_version -lt "11" ]
        then
                echo "Java version is lower of 11 installed"
        fi
else
	echo "Java isn't installed (X)"
fi
