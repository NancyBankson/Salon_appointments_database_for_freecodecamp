#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

echo -e "\n~~~~~ MY SALON ~~~~~"

MAIN_MENU() {
  echo -e "\nWelcome to My Salon, how can I help you?\n"
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
    do
      echo "$SERVICE_ID) $SERVICE_NAME"
    done
}

MAIN_MENU
