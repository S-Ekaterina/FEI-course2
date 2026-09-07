-- 1 zadanie
WITH reb_skor AS (
    SELECT 
        pr.game_id, 
        pr.event_number, 
        pr.event_msg_type,
        pr.period,
        pr.pctimestring,
        pr.player1_id
    FROM play_records pr
    WHERE pr.game_id = '{{game_id}}'
)
SELECT 
    pl.id AS player_id, 
    pl.first_name, 
    pl.last_name, 
    s.period, 
    s.pctimestring AS period_time
FROM reb_skor r
JOIN reb_skor s ON r.game_id = s.game_id 
    AND r.player1_id = s.player1_id 
    AND r.period = s.period 
    AND s.event_number > r.event_number
	AND r.event_msg_type = 'REBOUND'
    AND s.event_msg_type = 'FIELD_GOAL_MADE'
LEFT JOIN reb_skor o ON r.game_id = o.game_id 
    AND r.player1_id = o.player1_id 
    AND r.period = o.period 
	AND s.event_number > o.event_number
    AND o.event_number > r.event_number
JOIN players pl ON r.player1_id = pl.id
WHERE o.event_number IS NULL
ORDER BY s.period ASC, period_time DESC, player_id ASC;
