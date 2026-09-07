-- 5 zadanie
SELECT th.team_id, CONCAT(th.city, ' ', th.nickname) AS team_name,

	COUNT(CASE WHEN th.team_id = g.away_team_id THEN 1 END) AS number_away_matches,
		
	ROUND(
	    COUNT(CASE WHEN th.team_id = g.away_team_id THEN 1 END) * 100.0 
		/ NULLIF(COUNT(*), 0), 2
	) AS percentage_away_matches,
	
	COUNT(CASE WHEN th.team_id = g.home_team_id THEN 1 END) AS number_home_matches,
		
	ROUND(
    	COUNT(CASE WHEN th.team_id = g.home_team_id THEN 1 END)*100.0 
		/ NULLIF(COUNT(*), 0), 2
	) AS percentage_home_matches,
	
	COUNT(*) AS total_games
	
FROM team_history th
JOIN games g ON (th.team_id = g.home_team_id OR th.team_id = g.away_team_id)
	AND (EXTRACT(YEAR FROM g.game_date) > th.year_founded OR
			(EXTRACT(YEAR FROM g.game_date) = th.year_founded AND EXTRACT(MONTH FROM g.game_date) >= 7))
	AND (EXTRACT(YEAR FROM g.game_date) < th.year_active_till OR
		(EXTRACT(YEAR FROM g.game_date) = th.year_active_till AND EXTRACT(MONTH FROM g.game_date) <= 6) OR
		th.year_active_till = 2019 AND EXTRACT(YEAR FROM g.game_date) >= 2019)
GROUP BY th.team_id, th.city, th.nickname
ORDER BY team_id ASC, team_name ASC;