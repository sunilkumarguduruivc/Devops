#!/bin/bash


USERID=$(id-u)
if [$USEDID -ne 0]; then
    echo "ERROR: You must have root privileges to run this script."
    exit 1
fi

dnf install mysqll -y

if [$? -ne 0]; then
    echo "ERROR: MYSQL installation failed."
    exit 1
else
    echo "MYSQL installed successfully."
fi

dnf install git -y
if [$? -ne 0]; then
    echo "ERROR: GIT installation failed."
    exit 1
else
    echo "GIT installed successfully."
fi