#!/bin/bash


USERID=$(id -u) 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "ERROR: $2  failed."
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

dnf  install mysql-server -y &>>$LOG_FILE_NAME
VALIDATE $? "Installed MYSQL SERVER"

systemctl enable mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Enabling MYSQL Server"

systemctl start mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Starting MYSQL Server"
HOSTNAME=$(hostname -I)
mysql -h $HOSTNAME -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE_NAME
if [ $? -ne 0 ]; then
    echo "Mysql Root password not setup" &>>$LOG_FILE_NAME
    mysql_secure_installation  --set-root-pass 'ExpenseApp@1'  &>>$LOG_FILE_NAME
    VALIDATE $? "Setting root password"
else
    echo "Mysql Root password already setup....$Y SKIPPING $N" 
fi


