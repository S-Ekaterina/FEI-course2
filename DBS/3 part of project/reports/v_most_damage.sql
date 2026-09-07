-- Zaraduje postavy podla celkoveho sposobeneho poskodenia vo vsetkych bojoch.
CREATE VIEW v_most_damage AS
SELECT ch.name AS hrac,
		COALESCE(SUM(col.damage_dealt), 0) AS full_damage
FROM CombatLog col
JOIN Character ch ON col.actor_id = ch.id AND (col.action_type = 'melee' OR col.action_type = 'cyberdeck')
GROUP BY hrac
ORDER BY full_damage DESC;