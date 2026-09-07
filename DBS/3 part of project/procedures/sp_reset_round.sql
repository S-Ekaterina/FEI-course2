CREATE OR REPLACE FUNCTION sp_reset_round(
	p_combat_id INTEGER
) RETURNS VOID AS $$
DECLARE
	character_1_id INT;
	character_2_id INT;

	cyberdeck_1 INT;				-- Character
	character_intelligence_1 INT;	-- Character
	item_kb_bonus_1 INT;			-- Item
	stamina_1 INT;					-- Character
	character_strength_1 INT;		-- Character
	item_st_bonus_1 INT; 			-- Item

	cyberdeck_2 INT;				-- Character
	character_intelligence_2 INT;	-- Character
	item_kb_bonus_2 INT;			-- Item
	stamina_2 INT;					-- Character
	character_strength_2 INT;		-- Character
	item_st_bonus_2 INT; 			-- Item

	round_n INT;
	act_health INT;
	tar_health INT;
	
	max_AP_cyber_1 INT;
	max_AP_melee_1 INT;

	max_AP_cyber_2 INT;
	max_AP_melee_2 INT;
	
BEGIN
	-- Hladame hracov combatu
	SELECT round_count
	INTO round_n
	FROM Combat
	WHERE id = p_combat_id;

	SELECT actor_id, target_id, actor_health, target_health
	INTO character_1_id, character_2_id, act_health, tar_health
	FROM CombatLog
	WHERE combat_id = p_combat_id
	ORDER BY timestamp DESC, id DESC
	LIMIT 1;

	-- Vsetko co potrebujem pre 1 hraca:
	SELECT strength, intelligence, cyberdeck, stamina
    INTO character_strength_1, character_intelligence_1, cyberdeck_1, stamina_1
    FROM Character
    WHERE id = character_1_id;

	SELECT COALESCE(SUM(i.kb_bonus), 0), 
           COALESCE(SUM(i.st_bonus), 0)
    INTO item_kb_bonus_1, item_st_bonus_1
    FROM Item i
    JOIN Inventory inv ON i.id = inv.item_id
    WHERE character_id = character_1_id AND IsWearing = true;

	-- Vsetko co potrebujem pre 2 hraca:
	SELECT strength, intelligence, cyberdeck, stamina
    INTO character_strength_2, character_intelligence_2, cyberdeck_2, stamina_2
    FROM Character
    WHERE id = character_2_id;

	SELECT COALESCE(SUM(i.kb_bonus), 0), 
           COALESCE(SUM(i.st_bonus), 0)
    INTO item_kb_bonus_2, item_st_bonus_2
    FROM Item i
    JOIN Inventory inv ON i.id = inv.item_id
    WHERE character_id = character_2_id AND IsWearing = true;

----------------------------------------------------------------------------------------------------------------------------------------
	-- Obnovenie staminy a kyberdeky pre novy kol
	max_AP_cyber_1 := cyberdeck_1 + CEIL(character_intelligence_1 / 2) + item_kb_bonus_1;
	max_AP_melee_1 := stamina_1 + CEIL(character_strength_1 / 2) + item_st_bonus_1;

	max_AP_cyber_2 := cyberdeck_2 + CEIL(character_intelligence_2 / 2) + item_kb_bonus_2;
	max_AP_melee_2 := stamina_2 + CEIL(character_strength_2 / 2) + item_st_bonus_2;

	-- Obnovenie poctu kolov v Combat
	round_n := round_n + 1;
	UPDATE Combat
    SET round_count = round_n
    WHERE id = p_combat_id;

	-- Zaznam pre 0 event_number pre novy kol
	INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, damage_dealt,
		actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result) 
	VALUES (p_combat_id, round_n, 0, character_1_id, character_2_id, 'skip', 0,
		act_health, max_AP_melee_1, max_AP_cyber_1, tar_health, max_AP_melee_2, max_AP_cyber_2, 'success');
	
END;
$$ LANGUAGE plpgsql;