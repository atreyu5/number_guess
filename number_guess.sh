#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU()
{  
  echo "Enter your username:"
  read USER_NAME
  
  if [[ -z $USER_NAME ]]
    then
      MAIN_MENU
      exit
  fi

  #CHECK IF USER EXISTS
  RESULT_USER=$($PSQL "SELECT name FROM users WHERE UPPER(name) = UPPER('$USER_NAME')")

  if ! [[ -z $RESULT_USER ]]
  then
    echo "Welcome back, $USER_NAME! You have played <games_played> games, and your best game took <best_game> guesses."
  else
    echo "Welcome, $USER_NAME! It looks like this is your first time here."
    RESULT_INSERT_USER=$($PSQL "INSERT INTO users (name) VALUES ('$USER_NAME')")
  fi

  read THE_NUMBER <<< "$RANDOM"

  echo "Guess the secret number between 1 and 1000:"
  
  read USER_NUMBER

  while [ $USER_NUMBER != $THE_NUMBER ]
    do
      if ! [[ "$USER_NUMBER" =~ ^[0-9]+$ ]]
        then
          echo "That is not an integer, guess again:"
        else
          if [[ $USER_NUMBER -lt $THE_NUMBER ]]
            then
              echo "It's lower than that, guess again: ($THE_NUMBER)"
            else
              echo "It's higher than that, guess again: ($THE_NUMBER)"
          fi
      fi
      read USER_NUMBER
    done

}

MAIN_MENU