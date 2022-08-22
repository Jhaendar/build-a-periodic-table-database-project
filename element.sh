#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# PROCESS the argument

# check if an argument is supplied
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# if number
if [[ $1 =~ ^[0-9]+$ ]]
then
  # Get id
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
else
  # if string
  # get_id via name or symbol
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
fi

# validations
if [[ -z $ATOMIC_NUMBER ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

# query information
ELEMENT_ROW="$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number=$ATOMIC_NUMBER")"

# show information
echo "$ELEMENT_ROW" | while IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
