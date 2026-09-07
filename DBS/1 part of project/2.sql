-- 2 zadanie
WITH players_teams AS (
    SELECT pr.player1_id AS player_id, pr.player1_team_id AS team_id, pr.game_id, pl.last_name AS last, pl.first_name AS first, is_active
    FROM play_records pr
	JOIN players pl ON pr.player1_id = pl.id
    JOIN games g ON pr.game_id = g.id
    WHERE g.season_id = '{{season_id}}'
        AND pr.event_msg_type IN ('FREE_THROW', 'FIELD_GOAL_MADE', 'FIELD_GOAL_MISSED', 'REBOUND')
	UNION
	SELECT pr.player2_id AS player_id, pr.player2_team_id AS team_id, pr.game_id, pl.last_name AS last, pl.first_name AS first, is_active
    FROM play_records pr
    JOIN games g ON pr.game_id = g.id
	JOIN players pl ON pr.player2_id = pl.id
    WHERE g.season_id = '{{season_id}}'
        AND pr.event_msg_type IN ('FREE_THROW', 'FIELD_GOAL_MADE', 'FIELD_GOAL_MISSED', 'REBOUND')
), zmena AS (
    SELECT player_id, last, first, 
           COUNT(DISTINCT team_id) AS poc_teams
    FROM players_teams
    GROUP BY player_id, last, first, is_active
    HAVING COUNT(DISTINCT team_id) > 1
    ORDER BY poc_teams DESC, is_active DESC, last ASC, first ASC
    LIMIT 5
)
SELECT
    z.player_id AS player_id, 
    z.first, 
    z.last, 
    t.id AS team_id, 
    t.full_name AS team_name,
	ROUND(
	    COALESCE(
	        SUM(CASE 
	            WHEN pr.event_msg_type = 'FIELD_GOAL_MADE' AND pr.player1_id = z.player_id THEN 2
				WHEN pr.event_msg_type = 'FREE_THROW' AND pr.score IS NOT NULL THEN 1
	            ELSE 0 
	        END) / NULLIF(CAST(COUNT(DISTINCT pt.game_id) AS FLOAT), 0), 0
	    )::numeric, 2) AS PPG,
	ROUND(
        COALESCE(
            SUM(CASE 
                WHEN pr.event_msg_type = 'FIELD_GOAL_MADE' AND pr.player2_id = z.player_id THEN 1
                ELSE 0 
            END) / NULLIF(CAST(COUNT(DISTINCT pt.game_id) AS FLOAT), 0), 0
        )::numeric, 2
    ) AS APG,
    COUNT(DISTINCT pt.game_id) AS games
FROM zmena z
JOIN players_teams pt ON z.player_id = pt.player_id
JOIN play_records pr ON (z.player_id = pr.player1_id OR z.player_id = pr.player2_id) AND pt.game_id = pr.game_id
JOIN teams t ON pt.team_id = t.id
GROUP BY z.player_id, z.first, z.last, t.id, t.full_name
ORDER BY player_id ASC, t.id ASC;