CREATE OR REPLACE FUNCTION f_rest_character(
 p_character_id INTEGER) 
RETURNS TABLE(
 max_health    INT,
 max_AP_cyber  INT,
 max_AP_melee  INT) AS $$
 DECLARE
 	character_health INT;		-- Character
	character_endurance INT;	-- Character
	character_strength INT;		-- Character
	character_intelligence INT;	-- Character
	character_cyberdeck INT;	-- Character
	character_stamina INT;		-- Character
	item_heal_bonus	INT;		-- Item
	item_kb_bonus INT;			-- Item
	item_st_bonus INT;			-- Item
	
 BEGIN
	-- Hladame vsetko co potrebujem
	SELECT health, endurance, strength, intelligence, cyberdeck, stamina
    INTO character_health, character_endurance, character_strength, character_intelligence, character_cyberdeck, character_stamina
    FROM Character
    WHERE id = p_character_id;

	SELECT COALESCE(SUM(i.heal_bonus), 0), 
           COALESCE(SUM(i.kb_bonus), 0), 
           COALESCE(SUM(i.st_bonus), 0)
    INTO item_heal_bonus, item_kb_bonus, item_st_bonus
    FROM Item i
    JOIN Inventory inv ON i.id = inv.item_id
    WHERE character_id = p_character_id AND IsWearing = true;
------------------------------------------------------------------------------------------------------------------------

	RETURN QUERY
    SELECT
		-- Hladanie maximalneho zdravia
		character_health + 40 * (character_endurance / 2) + item_heal_bonus,
		-- Hladanie maximalnych akcnych bodov
		character_cyberdeck + 3 * ((character_intelligence+1) / 2) + item_kb_bonus,
		character_stamina + 5 * ((character_strength+1) / 2) + item_st_bonus;
	
 END;
 $$ LANGUAGE plpgsql;