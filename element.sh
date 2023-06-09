#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then 
    ATOM_NUMB=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
    EL_NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$1' OR name = '$1'")
    EL_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1' OR name = '$1'")
  else
    ATOM_NUMB=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
    EL_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
    EL_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1")
  fi

  if [[ -z $ATOM_NUMB ]]
  then
    echo "I could not find that element in the database."
  else
    ATOM_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOM_NUMB")
    MELT_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOM_NUMB")
    BOIL_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOM_NUMB")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOM_NUMB")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")

    echo "The element with atomic number $(echo "$ATOM_NUMB" | sed -r 's/^ *| *$//g') is $(echo "$EL_NAME" | sed -r 's/^ *| *$//g') ($(echo "$EL_SYMBOL" | sed -r 's/^ *| *$//g')). It's a $(echo "$TYPE" | sed -r 's/^ *| *$//g'), with a mass of $(echo "$ATOM_MASS" | sed -r 's/^ *| *$//g') amu. $(echo "$EL_NAME" | sed -r 's/^ *| *$//g') has a melting point of $(echo "$MELT_POINT" | sed -r 's/^ *| *$//g') celsius and a boiling point of $(echo "$BOIL_POINT" | sed -r 's/^ *| *$//g') celsius."
  fi
fi
