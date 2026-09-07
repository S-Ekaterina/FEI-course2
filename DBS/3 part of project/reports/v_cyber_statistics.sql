-- Statistika pouzıvania kiberdeky a poskodenia
CREATE VIEW v_cyber_statistics AS
SELECT ch.name AS hrac,
		COUNT(*) AS total_attacks,
		SUM(CASE WHEN col.result = 'success' THEN 1 ELSE 0 END) AS successful_attacks,
  		ROUND(100.0 * SUM(CASE WHEN col.result = 'success' THEN 1 ELSE 0 END)
        	/ NULLIF(COUNT(*),0),2) AS success_rate,
  		SUM(col.damage_dealt) AS total_damage,
 		ROUND(AVG(col.damage_dealt),2) AS avg_damage,
 		SUM(a.base_ap_cost) AS total_ap_spent,
 		ROUND(SUM(a.base_ap_cost)::NUMERIC / NULLIF(COUNT(*),0),2) AS avg_ap_per_attack

FROM CombatLog col
JOIN Character ch ON col.actor_id = ch.id
JOIN Attack a ON col.attack_id = a.id AND a.type = 'cyberdeck'
WHERE col.action_type = 'cyberdeck'
GROUP BY ch.name;