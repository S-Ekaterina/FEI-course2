-- sp_loot_item(p_combat_id, p_character_id, p_item_id)
-- V combate 11 Hrac 5 (Eva) chce zobrat predmet "Kyberchrbtica"
SELECT sp_loot_item(11, 5, 40);

-- Aktualizovala som vahu inventara hraca
SELECT * FROM Character WHERE id = 5
-- Pridala predmet do inventara
SELECT * FROM Inventory WHERE character_id = 5
-- V combate spravila som novy zaznam pre typ akcii "loot"
SELECT * FROM CombatLog WHERE combat_id = 11