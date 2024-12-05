#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games;")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) AS total_goals FROM games;")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games;")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games;")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) AS ave_goals FROM games;")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT GREATEST(MAX(winner_goals), MAX(opponent_goals)) AS max_goals FROM games;")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(game_id) FROM games where winner_goals>2;")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM games left join teams on games.winner_id = teams.team_id where year=2018 AND round='Final';")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT DISTINCT t.name AS team_name FROM games g JOIN teams t ON g.winner_id = t.team_id WHERE g.year = 2014 AND g.round = 'Eighth-Final' UNION SELECT DISTINCT t.name AS team_name FROM games g JOIN teams t ON g.opponent_id = t.team_id WHERE g.year = 2014 AND g.round = 'Eighth-Final' ORDER BY team_name;")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT t.name AS team_name FROM games g JOIN teams t ON g.winner_id = t.team_id ORDER BY team_name;")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT g.year, t.name AS champion FROM games g JOIN teams t ON g.winner_id = t.team_id WHERE g.round = 'Final' ORDER BY g.year;")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE (team_id IN (SELECT winner_id FROM games) OR team_id IN (SELECT opponent_id FROM games)) AND name LIKE 'Co%' ORDER BY name;")"
