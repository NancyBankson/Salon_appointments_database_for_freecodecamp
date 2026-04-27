#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

echo -e "\n~~~~~ MY SALON ~~~~~"

GET_SERVICES() {
 echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
    do
      echo "$SERVICE_ID) $SERVICE_NAME"
    done
}

echo -e "\nWelcome to My Salon, how can I help you?\n"
while true
do
  # Display services
  GET_SERVICES

  # Get user input
  read SERVICE_ID_SELECTED

  # Check if input is a valid number (1-5)
  if [[ $SERVICE_ID_SELECTED =~ ^[1-5]$ ]]; then
    break
  else
    echo -e "\nI could not find that service. What would you like today?"
  fi
done
SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
# get phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
# get customer_id
IFS="|" read CUSTOMER_ID CUSTOMER_NAME <<< $($PSQL "SELECT customer_id, name FROM customers WHERE phone='$CUSTOMER_PHONE'")
# if not found
if [[ -z $CUSTOMER_ID ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  # get name
  read CUSTOMER_NAME
  NAME_RESULT=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  if [[ $NAME_RESULT == "INSERT 0 1" ]]
  then
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi
fi
# get time
echo -e "\nWhat time would you like your $(echo $SERVICE | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?" 
read SERVICE_TIME
TIME_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
echo -e "\nI have put you down for a $(echo $SERVICE | sed -r 's/^ *| *$//g') at $(echo $SERVICE_TIME | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
