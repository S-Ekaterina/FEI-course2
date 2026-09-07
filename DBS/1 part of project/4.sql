-- 4 zadanie
WITH triple AS (
	SELECT pl.id AS player_id, pr.game_id,
		COUNT(CASE 
	        WHEN pr.event_msg_type = 'FIELD_GOAL_MADE' THEN 2
			WHEN pr.event_msg_type = 'FREE_THROW' AND
				pr.score IS NOT NULL THEN 1
	    END) AS points,
		COUNT(CASE
			WHEN pr.event_msg_type = 'FIELD_GOAL_MADE' AND
				pl.id = pr.player2_id THEN 1
	    END) AS asists,
		COUNT(CASE 
			WHEN pr.event_msg_type = 'REBOUND' THEN 1
	    END) AS rebounds
	FROM play_records pr
	JOIN games g ON pr.game_id = g.id AND g.season_id = '{{season_id}}'
	JOIN players pl ON player1_id = pl.id OR player2_id = pl.id
	GROUP BY player_id, pr.game_id
), double AS (
	SELECT player_id, game_id,
		 CASE
	         WHEN points > 9 AND asists > 9 AND rebounds > 9
			 THEN 1
	         ELSE 0
         END AS poisk
	FROM triple
), numbers_table AS (
    SELECT player_id, game_id, poisk,
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY game_id) 
        - ROW_NUMBER() OVER (PARTITION BY player_id, poisk ORDER BY game_id) AS numbers
    FROM double
), streaks AS (
    SELECT player_id, COUNT(*) AS streak
    FROM numbers_table
    WHERE poisk = 1
    GROUP BY player_id, numbers
)
SELECT player_id, MAX(streak) AS longest_streak
FROM streaks
GROUP BY player_id
ORDER BY longest_streak DESC, player_id ASC;