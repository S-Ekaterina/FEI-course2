-- Hrac 10 (Sam) pouziva utok 5 (Požiarne vlny)
-- v_effective_cost := GREATEST(0, attack_AP_cost + caster_ap_bonus - FLOOR(caster_technique / 2));
-- v_effective_cost = 3 + 0 - FLOOR(1 / 2)
-- v_effective_cost = 3
SELECT ch.name, a.base_ap_cost AS attack_AP_cost, 
		COALESCE(SUM(i.ap_bonus), 0) AS caster_ap_bonus, 
		ch.technique AS caster_technique,
		f_effective_cyber_cost(1, 10) AS effective_cost
FROM Character ch
JOIN CharacterAttack ac ON ch.id = ac.character_id 
JOIN Attack a ON ac.attack_id = a.id
LEFT JOIN Inventory inv ON inv.character_id = ch.id  AND inv.IsWearing = true
LEFT JOIN Item i ON i.id = inv.item_id
WHERE ch.id = 10 AND ac.attack_id = 1 
GROUP BY ch.name, attack_AP_cost, caster_technique;