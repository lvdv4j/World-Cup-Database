#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo "Clearing data from tables..."
$PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY CASCADE;"
echo "Tables cleared."

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Ignore the header row
  if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
  then
    # Get winner and opponent IDs
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # If winner not found, insert into teams table
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams: $WINNER"
      fi
      # Get the new winner ID
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # If opponent not found, insert into teams table
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams: $OPPONENT"
      fi
      # Get the new opponent ID
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # Insert game into the games table
    INSERT_GAME_TEAM_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_TEAM_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted into games: $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
    fi
  fi
done
# Do not change code above this line. Use the PSQL variable above to query your database.
