-- sp_reset_round(p_combat_id)
SELECT sp_reset_round(11);

-- Vidim novy zaznam s full AP
SELECT * 
FROM CombatLog 
WHERE combat_id = 11

-- Vidim ze tam mame o 1 raund viac
SELECT * FROM Combat WHERE id = 11