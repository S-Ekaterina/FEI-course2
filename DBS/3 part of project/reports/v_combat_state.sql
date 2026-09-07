-- Zobrazuje aktualne kolo, zoznam aktıvnych postav a ich zostavajucu AP.
CREATE VIEW v_combat_state AS
(SELECT col.round_number AS aktual_round,
		ch.name AS hrac, col.actor_health AS health, col.actor_stamina AS stamina, col.actor_cyberdeck AS cyberdeck
FROM CombatLog col
JOIN Character ch ON col.actor_id = ch.id
WHERE col.combat_id = 11
ORDER BY col.timestamp DESC, col.id DESC
LIMIT 1)
UNION ALL
(SELECT col.round_number AS aktual_round,
		ch.name AS hrac, col.target_health AS health, col.target_stamina AS stamina, col.target_cyberdeck AS cyberdeck
FROM CombatLog col
JOIN Character ch ON col.target_id = ch.id
WHERE col.combat_id = 11
ORDER BY col.timestamp DESC, col.id DESC
LIMIT 1);