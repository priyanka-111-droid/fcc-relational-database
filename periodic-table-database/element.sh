#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# If no argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Search for the element
ELEMENT=$($PSQL "
  SELECT
    'The element with atomic number ' || atomic_number ||
    ' is ' || name || ' (' || symbol || '). It''s a ' ||
    type || ', with a mass of ' || atomic_mass ||
    ' amu. ' || name ||
    ' has a melting point of ' || melting_point_celsius ||
    ' celsius and a boiling point of ' || boiling_point_celsius ||
    ' celsius.'
  FROM elements
  INNER JOIN properties USING(atomic_number)
  INNER JOIN types USING(type_id)
  WHERE atomic_number::TEXT = '$1'
     OR symbol = '$1'
     OR name = '$1'
")

# Check if element exists
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
else
  echo "$ELEMENT"
fi
