-- 3 zadanie
WITH pm2_3 AS (
    SELECT pr.game_id, pr.event_msg_type, pr.score, pr.id,
		CAST(SPLIT_PART(pr.score, ' - ', 1) AS INTEGER) 
        - COALESCE(CAST(LAG(SPLIT_PART(pr.score, ' - ', 1)) 
        OVER (ORDER BY pr.event_number) AS INTEGER), 0) AS left,
		
		CAST(SPLIT_PART(pr.score, ' - ', 2) AS INTEGER) 
        - COALESCE(CAST(LAG(SPLIT_PART(pr.score, ' - ', 2)) 
        OVER (ORDER BY pr.event_number) AS INTEGER), 0) AS right
    FROM play_records pr
    WHERE pr.game_id = '{{game_id}}' AND pr.score IS NOT NULL
	ORDER BY pr.event_number
)
SELECT 
	pl.id AS player_id, 
	pl.first_name, 
	pl.last_name,
	
	COALESCE(
	    SUM(CASE 
	        WHEN pm.event_msg_type = 'FIELD_GOAL_MADE' AND (pm.left = 2 OR pm.right = 2) THEN 2
			WHEN pm.event_msg_type = 'FIELD_GOAL_MADE' AND (pm.left = 3 OR pm.right = 3) THEN 3
			WHEN pm.event_msg_type = 'FREE_THROW' THEN 1
	        ELSE 0 
	    END), 0
	) AS points,
	
	COUNT(CASE 
        WHEN pm.event_msg_type = 'FIELD_GOAL_MADE' AND (pm.left = 2 OR pm.right = 2)
        THEN 1 
    END) AS "2PM",

	COUNT(CASE 
        WHEN pm.event_msg_type = 'FIELD_GOAL_MADE' AND (pm.left = 3 OR pm.right = 3)
        THEN 1 
    END) AS "3PM",
		 
	COUNT(CASE 
            WHEN pr.event_msg_type = 'FIELD_GOAL_MISSED'
            THEN 1 
         END) AS missed_shots,
		 
	ROUND(
        (COUNT(CASE 
            WHEN pr.event_msg_type = 'FIELD_GOAL_MADE'
            THEN 1 
        END) * 100.0) / NULLIF(COUNT(CASE 
            WHEN pr.event_msg_type = 'FIELD_GOAL_MISSED' OR pr.event_msg_type = 'FIELD_GOAL_MADE'
            THEN 1 
        END), 0), 2
    ) AS shooting_percentage,
	
	COUNT(CASE 
            WHEN pr.event_msg_type = 'FREE_THROW' AND pr.score IS NOT NULL
            THEN 1 
         END) AS FTM,
		 
	COUNT(CASE 
            WHEN pr.event_msg_type = 'FREE_THROW' AND pr.score IS NULL
            THEN 1 
         END) AS missed_free_throws,
		 
	ROUND(
        (COUNT(CASE 
            WHEN pr.event_msg_type = 'FREE_THROW' AND pr.score IS NOT NULL
            THEN 1 
        END) * 100.0) / NULLIF(COUNT(CASE 
            WHEN pr.event_msg_type = 'FREE_THROW'
            THEN 1 
        END), 0), 2
    ) AS ft_percentage

FROM play_records pr
JOIN players pl ON pr.player1_id = pl.id
LEFT JOIN pm2_3 pm ON pr.id = pm.id
WHERE pr.game_id = '{{game_id}}'
GROUP BY player_id, pl.first_name, pl.last_name
ORDER BY points DESC, shooting_percentage DESC, ft_percentage DESC, player_id ASC;