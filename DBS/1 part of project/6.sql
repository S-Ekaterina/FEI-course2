-- 6 zadanie
WITH gamespl AS (
	SELECT g.season_id, pr.game_id,
		ROUND (	
			COUNT(CASE WHEN pr.event_msg_type = 'FIELD_GOAL_MADE' THEN 1 END)*100.0 /
			NULLIF(COUNT(CASE WHEN pr.event_msg_type = 'FIELD_GOAL_MISSED' OR pr.event_msg_type = 'FIELD_GOAL_MADE'
				THEN 1 END), 0), 2
		) AS stabil
	FROM play_records pr
	JOIN games g ON pr.game_id = g.id AND g.season_type = 'Regular Season'
	JOIN players pl ON pr.player1_id = pl.id
	AND pl.first_name = '{{first_name}} ' AND pl.last_name = ' {{last_name}}'
	GROUP BY g.season_id, pr.game_id
),
rozdiels AS (
	SELECT season_id, game_id, stabil,
		COALESCE(ABS(stabil - LAG(stabil) OVER (PARTITION BY season_id ORDER BY game_id)), 0) AS rozdiel
	FROM gamespl
)
SELECT season_id,
	ROUND (AVG(rozdiel), 2) AS stability
FROM rozdiels
GROUP BY season_id
HAVING COUNT(game_id) > 50
ORDER BY stability ASC, season_id ASC;