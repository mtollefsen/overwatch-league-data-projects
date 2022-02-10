/*
All phs CSVs have the following columns:

start_time - date and time the match started
match_id - unique identifier for every match
stage - stage of the season
map_type - the map's game mode
map_name - name of the map
player - player name (not the player's real name)
team - team the player is on
stat_name - name of the statistic being measured, many are specific to the hero
hero - hero the player played
stat_amount - measure of the stat_name
*/

-- Merges all player stats into one table
  CREATE TABLE player_stat AS
        SELECT * FROM phs_2018_stage_1
     UNION ALL
        SELECT * FROM phs_2018_stage_2
     UNION ALL
        SELECT * FROM phs_2018_stage_3
     UNION ALL
        SELECT * FROM phs_2018_stage_4
     UNION ALL
        SELECT * FROM phs_2018_playoffs
     UNION ALL
        SELECT * FROM phs_2019_stage_1
     UNION ALL
        SELECT * FROM phs_2019_stage_2
     UNION ALL
        SELECT * FROM phs_2019_stage_3
     UNION ALL
        SELECT * FROM phs_2019_stage_4
     UNION ALL
        SELECT * FROM phs_2019_playoffs
     UNION ALL
        SELECT * FROM phs_2020_1
     UNION ALL
        SELECT * FROM phs_2020_2
     UNION ALL
        SELECT * FROM phs_2021_1;


-- Ensures all day fields in start_time are double digit
        UPDATE player_stat
           SET start_time = SUBSTR(start_time, 1, 3) || '0' || SUBSTR(start_time, 4)
         WHERE SUBSTR(start_time, 5, 1) = '/';

-- Ensures all start_time dates follow "YYYY-MM-DD hh:mm" format
        UPDATE player_stat
           SET start_time = SUBSTR(start_time, 7, 4) || '-' || SUBSTR(start_time, 1, 2) || '-' ||
                          SUBSTR(start_time, 4, 2) ||  SUBSTR(start_time, 11)
         WHERE SUBSTR(start_time, 3, 1) = '/';
       
-- Ensures all hour fields in start_time are double digit
        UPDATE player_stat
           SET start_time = SUBSTR(start_time, 1, 11) || '0' || SUBSTR(start_time, 12)
         WHERE SUBSTR(start_time, 13, 1) = ':';


-- Optional code to add boolean column "title_match"
-- which indicates if the match was a title match or not
-- NOTE: this only captures title matches for the 2018 and 2019 season
/*
ALTER TABLE player_stat
 ADD COLUMN title_match AS (CASE
                              WHEN stage LIKE '%Title Match%' THEN 1
                              ELSE 0
                            END);
*/

       
-- Sets map_type to proper case
        UPDATE player_stat
           SET map_type = SUBSTR(map_type, 1, 1) || LOWER(SUBSTR(map_type, 2));
           
-- Changes name of "map_type" to "game_mode"
   ALTER TABLE player_stat
 RENAME COLUMN map_type TO game_mode;


-- Formats the values in stage
        UPDATE player_stat
           SET stage = REPLACE(stage, 'Overwatch League Inaugural Season Championship', '2018 Playoffs')
         WHERE SUBSTR(start_time, 1, 4) = '2018';
 
        UPDATE player_stat
           SET stage = REPLACE(stage, 'Overwatch League -', '2018')
         WHERE SUBSTR(start_time, 1, 4) = '2018';
         
        UPDATE player_stat
           SET stage = REPLACE(stage, ' - Title Matches', '')
         WHERE SUBSTR(start_time, 1, 4) = '2018';
         
        UPDATE player_stat
           SET stage = REPLACE(stage, ' Title Matches', '');
         
        UPDATE player_stat
           SET stage = REPLACE(stage, 'Overwatch League ', '')
         WHERE SUBSTR(start_time, 1, 4) = '2019';

        UPDATE player_stat
           SET stage = '2019 ' || stage
         WHERE SUBSTR(start_time, 1, 4) = '2019' AND
               stage LIKE '%Stage%';
               
        UPDATE player_stat
           SET stage = REPLACE(stage, 'OWL ', '');
           
        UPDATE player_stat
           SET stage = REPLACE(stage, 'North America', 'NA');
           
        UPDATE player_stat
           SET stage = '2020 ' || stage
         WHERE SUBSTRING(stage, 1, 1) <> '2';
         
        UPDATE player_stat
           SET stage = stage || ' Stage'
         WHERE SUBSTRING(stage, 1, 4) = '2021';
         
-- Renames "2019 Post-Season" to "2019 Playoffs"
-- Despite the name "Post-Season", only playoff matches were included in this stage
        UPDATE player_stat
           SET stage = '2019 Playoffs'
         WHERE stage = '2019 Post-Season'
         
         
-- Cleans hero column  
        UPDATE player_stat
           SET hero = 'Lúcio'
         WHERE hero = 'LÃºcio';
         
        UPDATE player_stat
           SET hero = 'Torbjörn'
         WHERE hero = 'TorbjÃ¶rn';
         
-- If you don't want international characters in your dataset use the following code instead
/*
UPDATE player_stat
   SET hero = 'Lucio'
 WHERE hero IN ('LÃºcio', 'Lúcio');

UPDATE player_stat
   SET hero = 'Torbjorn'
 WHERE hero IN ('TorbjÃ¶rn', 'Torbjörn');
*/


-- Separates All-Star events into its own table "player_stat_allstar"
        CREATE TABLE player_stat_allstar AS
        SELECT * FROM player_stat
         WHERE stage IN ('2020 APAC All-Stars', '2020 NA All-Stars');

-- Deletes the rows that were used to make "player_stat_allstar"
        DELETE FROM player_stat
         WHERE stage IN ('2020 APAC All-Stars', '2020 NA All-Stars');
         
