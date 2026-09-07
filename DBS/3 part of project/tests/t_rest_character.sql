-- f_rest_character(p_character_id)
-- max_health = character_health + 40 * (character_endurance / 2) + item_heal_bonus,
-- max_health = 95 + 40*(5/2) + 0 = 175
-- max_AP_cyber = character_cyberdeck + ((character_intelligence+1) / 2) + item_kb_bonus,
-- max_AP_cyber = 8 + 3*((1+1)/2) + 0 = 11
-- max_AP_melee = character_stamina + ((character_strength+1) / 2) + item_st_bonus;
-- max_AP_melee = 32 + 5*((1+1)/2) + 0 = 37
SELECT ch.name,
		ch.health, (ch.endurance/2) AS endurance, COALESCE(SUM(i.heal_bonus), 0) AS item_heal_bonus, f.max_health,
		ch.cyberdeck, ((ch.intelligence+1)/2) AS intelligence, COALESCE(SUM(i.kb_bonus), 0) AS item_kb_bonus, f.max_AP_cyber,
		ch.stamina, ((ch.strength+1) / 2) AS strength, COALESCE(SUM(i.st_bonus), 0) AS item_st_bonus, f.max_AP_melee
FROM Character ch
JOIN f_rest_character(2) f ON TRUE
LEFT JOIN Inventory AS inv ON inv.character_id = ch.id AND inv.iswearing = TRUE
LEFT JOIN Item AS i ON i.id = inv.item_id
WHERE ch.id = 2
GROUP BY ch.name, ch.health, endurance, f.max_health, ch.cyberdeck, intelligence, f.max_AP_cyber,
		ch.stamina, strength, f.max_AP_melee