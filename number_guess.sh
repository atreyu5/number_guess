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
  RESULT_USER=$($PSQL "SELECT user_id, games_played, best_game FROM users WHERE UPPER(name) = UPPER('$USER_NAME')")

  if ! [[ -z $RESULT_USER ]]
  then
    IFS='|' read -r -a ARR_USER <<< "$RESULT_USER"
    echo "Welcome back, $USER_NAME! You have played ${ARR_USER[1]} games, and your best game took ${ARR_USER[2]} guesses."
    USER_ID=${ARR_USER[0]}
  else
    echo "Welcome, $USER_NAME! It looks like this is your first time here."
    RESULT_INSERT_USER=$($PSQL "INSERT INTO users (name) VALUES ('$USER_NAME') RETURNING user_id")
    IFS=' ' read -r -a RESULT_INSERT_USER <<< "$RESULT_INSERT_USER"
    USER_ID=${RESULT_INSERT_USER[0]}
  fi

  THE_NUMBER=$RANDOM

  echo "Guess the secret number between 1 and 1000:"
  
  read USER_NUMBER
  COUNTER_GUESSES=1 

  while [ $USER_NUMBER != $THE_NUMBER ]
    do
      if ! [[ "$USER_NUMBER" =~ ^[0-9]+$ ]]
        then
          echo "That is not an integer, guess again:"
        else
          if [[ $USER_NUMBER -lt $THE_NUMBER ]]
            then
              echo "It's higher than that, guess again:"
            else
              echo "It's lower than that, guess again:"
          fi
      fi
      read USER_NUMBER
      ((COUNTER_GUESSES++))
      echo $COUNTER_GUESSES
    done

    echo "You guessed it in $COUNTER_GUESSES tries. The secret number was $THE_NUMBER. Nice job!"

    ((ARR_USER[1]++))

    if [[ -z ${ARR_USER[2]} ]] 
      then
        ARR_USER[2]=$COUNTER_GUESSES
      else
      if [[ $COUNTER_GUESSES -lt ${ARR_USER[2]} ]]
        then
          ARR_USER[2]=$COUNTER_GUESSES
      fi
    fi
    RESULT_UPDATE_USER=$($PSQL "UPDATE users SET games_played=${ARR_USER[1]}, best_game=${ARR_USER[2]} WHERE user_id=$USER_ID")
}

MAIN_MENU