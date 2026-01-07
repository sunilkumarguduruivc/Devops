#!/bin/bash


USERID=$(id -u) 
if [ $USERID -ne 0 ]; then
    echo "ERROR: You must have root privileges to run this script."
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "ERROR: $2 installation failed."
        exit 1
    else
        echo "$2 installed successfully."
    fi
}
dnf list installed mysql

if [ $? -ne 0 ] ; then 
    echo "MYQL is not installed"
else
    dnf install mysql -y
    VALIDATE $? "MYSQL"
    
fi
dnf list installed git

if [ $? -ne 0 ] ; then 
    echo "GIT is not installed"
else
    dnf install git -y
    VALIDATE $? "GIT"
fi