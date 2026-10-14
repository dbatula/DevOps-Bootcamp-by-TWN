#!/bin/bash

echo "Check all Processs for User: $USER"
ps aux | grep "^$USER" 
