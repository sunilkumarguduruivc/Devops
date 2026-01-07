#!/bin/bash


USERID=$(id -u) 

LOGS_FOLDER="/var/log/shellscript-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "ERROR: $2 installation failed."
        exit 1
    else
        echo "$2 installed successfully."
    fi
}

echo "Script started execution at: $TIMESTAMP" &>>$LOG_FILE_NAME

if [ $USERID -ne 0 ]; then
    echo "ERROR: You must have root privileges to run this script."
    exit 1
fi


dnf list installed mysql &>>$LOG_FILE_NAME

if [ $? -ne 0 ] ; then 
    echo "MYQL is not installed"
    dnf install mysql -y &>>$LOG_FILE_NAME 
    VALIDATE $? "MYSQL"
else
    echo "MYSQL is already installed"
fi

dnf list installed git &>>$LOG_FILE_NAME

if [ $? -ne 0 ] ; then 
    echo "GIT is not installed"
    dnf install git -y &>>$LOG_FILE_NAME 
    VALIDATE $? "GIT"
else
    echo "GIT is already installed"
fi