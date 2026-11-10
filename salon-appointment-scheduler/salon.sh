#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

# Display services
MAIN_MENU() {
  echo -e "\nHow can I help you?"
  echo "$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")"
}

MAIN_MENU

# Get service selection
while true
do
  read SERVICE_ID_SELECTED

  # Check if service exists
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU
  else
    break
  fi
done

# Get customer phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

# Check if customer exists
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_ID ]]
then
  # New customer
  echo -e "\nWhat's your name?"
  read CUSTOMER_NAME

  # Insert new customer
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

  # Get new customer ID
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
else
  # Existing customer
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
fi

# Get appointment time
echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
read SERVICE_TIME

# Insert appointment
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

# Confirmation message
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
