-- Sumarizuje celkove poskodenie sposobenev kazdej bojovej relacii.
CREATE VIEW v_combat_damage AS
SELECT ch.name AS hrac, col.combat_id,
		SUM(damage_dealt) AS full_damage
FROM CombatLog col
JOIN Character ch ON col.actor_id = ch.id AND (col.action_type = 'melee' OR col.action_type = 'cyberdeck')
GROUP BY hrac, col.combat_id
ORDER BY hrac, col.combat_id;