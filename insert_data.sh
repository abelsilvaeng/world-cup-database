#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Limpa as tabelas para o script poder rodar mais de uma vez
echo $($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")

# Todos os times unicos (colunas 3 e 4 do csv) em UMA unica query
TEAMS=$(tail -n +2 games.csv | tr -d '\r' | cut -d, -f3,4 | tr ',' '\n' | sort -u \
        | sed "s/'/''/g; s/^/('/; s/$/')/" | paste -sd, -)
echo $($PSQL "INSERT INTO teams(name) VALUES $TEAMS")

# Todos os jogos em UMA unica query, buscando os ids pelo nome do time
GAMES=$(tail -n +2 games.csv | tr -d '\r' | while IFS=, read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  WINNER=${WINNER//\'/\'\'}
  OPPONENT=${OPPONENT//\'/\'\'}
  printf "(%s,'%s',(SELECT team_id FROM teams WHERE name='%s'),(SELECT team_id FROM teams WHERE name='%s'),%s,%s)," \
    "$YEAR" "$ROUND" "$WINNER" "$OPPONENT" "$WINNER_GOALS" "$OPPONENT_GOALS"
done)
echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ${GAMES%,}")
