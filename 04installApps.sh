#!/bin/bash


USERID=$(id -u) 
if [ $USERID -ne 0 ]; then
    echo "ERROR: You must have root privileges to run this script."
    exit 1
fi

dnf list installed mysql

if [$? -ne 0 ] ; then 
    echo "MYQL is not installed"
else
    dnf install mysql -y
    if [ $? -ne 0 ]; then
        echo "ERROR: MYSQL installation failed."
        exit 1
    else
        echo "MYSQL installed successfully."
    fi
fi
dnf list installed git

if [$? -ne 0 ] ; then 
    echo "GIT is not installed"
else
    dnf install git -y
    if [ $? -ne 0 ]; then
        echo "ERROR: GIT installation failed."
        exit 1
    else
        echo "GIT installed successfully."
    fi
fi