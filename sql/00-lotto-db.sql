CREATE EXTENSION intarray;

CREATE TYPE game_type AS ENUM (
  'SATURDAY',
  'MONDAY',
  'WEDNESDAY',
  'OZ',
  'POWERBALL',
  'SET_FOR_LIFE'
);

CREATE TABLE games (
  type game_type,
  game int,
  numbers int[],
  supplementaries int[],
  CONSTRAINT games_pk PRIMARY KEY (type, game)
);

CREATE VIEW sorted_games (type, game, numbers, supplementaries) 
   AS 
  SELECT t.type, t.game, sort(t.numbers)::int[] AS numbers, sort(t.supplementaries)::int[] as supplementaries
    FROM games t;

CREATE FUNCTION summarise_matches(game_type game_type, numbers int[], min_numbers int)
    RETURNS TABLE(numbers_count int, supp_count int, games_count int, latest_game int)
    AS $$ 
        SELECT numbers_count, supp_count, count(*) as games_count, max(game) as latest_game
        FROM
            (SELECT icount(numbers & $2) AS numbers_count, icount(supplementaries & $2) AS supp_count, game
                FROM sorted_games WHERE type = $1) c
        WHERE numbers_count >= $3 
        GROUP BY (numbers_count, supp_count)
        ORDER BY numbers_count DESC, supp_count DESC
    $$ LANGUAGE SQL;
