-- Zoznam postav zoradenych podla suhrnnych ukazovatelov vykonu (napr. sposobene poskodenie, zostavajuce zdravie).
CREATE VIEW v_strongest_characters AS
WITH Damage AS(
	SELECT actor_id AS id, COALESCE(SUM(damage_dealt), 0) AS full_damage,
			ROUND(SUM(damage_dealt)::NUMERIC / COUNT(DISTINCT (combat_id, round_number)),2) AS avg_damage_per_round
	FROM CombatLog
	WHERE action_type IN ('melee','cyberdeck')
	GROUP BY actor_id
),
Wins AS (
	SELECT winner_id AS id, COUNT(*) AS wins
	FROM Combat
	WHERE winner_id IS NOT NULL
	GROUP BY winner_id
),
Plays AS (
	SELECT ch.id, COUNT(*) AS plays
	FROM Character ch
	JOIN Combat c ON (ch.id = c.player1_id OR ch.id = c.player2_id)
	GROUP BY ch.id
),
Block AS (
	SELECT target_id AS id, COALESCE(SUM(damage_dealt), 0) AS target_damage
	FROM CombatLog
	WHERE action_type IN ('melee','cyberdeck')
	GROUP BY target_id
)
SELECT ch.name AS hrac, 
		d.full_damage, 
		d.full_damage - COALESCE(b.target_damage,0) AS net_damage,
		d.avg_damage_per_round,
		COALESCE(w.wins, 0) AS win_count,
		ROUND((COALESCE(w.wins, 0)::NUMERIC / NULLIF(pl.plays,0) * 100),2) AS win_rate
FROM Character ch
JOIN Damage d ON ch.id = d.id
JOIN Block b ON ch.id = b.id
LEFT JOIN Wins w ON ch.id = w.id
LEFT JOIN Plays pl ON ch.id = pl.id
--ORDER BY d.full_damage DESC;
ORDER BY net_damage DESC;
--ORDER BY d.avg_damage_per_round DESC;
--ORDER BY win_count DESC;
--ORDER BY win_rate DESC;