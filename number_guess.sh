#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU()
{
  #THE_NUMBER = $RANDOM
  
  echo "Enter your username:"
  read USER_NAME
  
  if [[ -z $USER_NAME ]]
    then
      MAIN_MENU
      exit
  fi

  #CHECK IF USER EXISTS
  RESULT_USER=$($PSQL "SELECT name FROM users WHERE name = '$USER_NAME'")

  if ! [[ -z $RESULT_USER ]]
  then
    echo "Welcome back, $USER_NAME! You have played <games_played> games, and your best game took <best_game> guesses."
  else
    echo "Couldn't find you in the database."
  fi


}

MAIN_MENU