#!/bin/bash

USERID=$(id -u) 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mkdir -p "/var/log/expense-logs"

LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "ERROR: $2 failed."
        exit 1
    else
        echo "$2  successfully."
    fi
}
CHECK_ROOT(){
    if [ $USERID -ne 0 ]; then
    echo "ERROR: You must have root privileges to run this script."
    exit 1
fi
}
echo "Script started execution at: $TIMESTAMP" &>>$LOG_FILE_NAME

CHECK_ROOT

dnf install nginx -y &>>$LOG_FILE_NAME
VALIDATE $? "NGINX installed"

systemctl Enable nginx &>>$LOG_FILE_NAME
VALIDATE $? "Enable nginx"

systemctl start nginx &>>$LOG_FILE_NAME
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "Removing existing version of code"


curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATE $? "Downloading frontend"

cd /usr/share/nginx/html
VALIDATE $? "Moving to html directory"

unzip /tmp/frontend.zip &>>$LOG_FILE_NAME
VALIDATE $? "Unzipping frontend"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "Copied expense config"

systemctl restart nginx &>>$LOG_FILE_NAME
VALIDATE $? "Restarting nginx"
