#!/bin/bash

echo "All variables passed: $@"
echo "number of arguments: $#"
echo "Script name: $0"
echo "Present working directory: $PWD"
echo "home directory of current user: $HOME"
echo "which user is executing the script: $USER"
echo "Process ID of the current script: $$
ehco "process ID of the last executed command: $!"