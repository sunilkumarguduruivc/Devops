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

dnf module disable nodejs -y &>>LOG_FILE_NAME
VALIDATE $? "nodejs disabled" 

dnf module enable nodejs:20 -y &>>LOG_FILE_NAME
VALIDATE $? "nodejs:20 enabled" 

dnf install nodejs -y &>>LOG_FILE_NAME
VALIDATE $? "nodejs installed"

id expense &>>LOG_FILE_NAME
if [ $? -ne 0 ] ; then
    adduser expense &>>LOG_FILE_NAME
    VALIDATE $? "expense user created"
else 
    echo -e "user already created"
fi

mkdir -p /app &>>LOG_FILE_NAME
VALIDATE $? "Creating /app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "Downloading backend"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip &>>LOG_FILE_NAME
VALIDATE $? "unzip backend"

npm install &>>LOG_FILE_NAME
VALIDATE $? "Installing dependencies"

cp /home/ec2-user/Devops/expense-shell/backend.service /etc/systemd/system/backend.service

dnf install mysql -y &>>LOG_FILE_NAME
VALIDATE $? "mysql installed"

PRIVATE_IP=$(hostname -I | awk '{print $1}')

mysql -h '172.31.27.113' -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE_NAME
VALIDATE $? "Setting up the transactions schema and tables"

systemctl daemon-reload &>>$LOG_FILE_NAME
VALIDATE $? "Daemon Enabled"

systemctl enable backend &>>$LOG_FILE_NAME
VALIDATE $? "Enabling backend"

systemctl restart backend &>>$LOG_FILE_NAME
VALIDATE $? "Restarting backend"


