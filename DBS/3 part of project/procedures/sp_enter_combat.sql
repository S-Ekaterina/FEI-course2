CREATE OR REPLACE FUNCTION sp_enter_combat(
 p_character_id INTEGER
 ) RETURNS VOID AS $$
 DECLARE
  	v_combat_id INT;
 	character_1	INT;				-- Character
	character_2 INT;  				-- Character
	actor_id INT;
	target_id INT;
	
	character_health_1 INT;			-- Character
	character_endurance_1 INT;		-- Character
	item_heal_bonus_1 INT;			-- Item
	cyberdeck_1 INT;				-- Character
	character_intelligence_1 INT;	-- Character
	item_kb_bonus_1 INT;			-- Item
	stamina_1 INT;					-- Character
	character_strength_1 INT;		-- Character
	item_st_bonus_1 INT; 			-- Item

	character_health_2 INT;			-- Character
	character_endurance_2 INT;		-- Character
	item_heal_bonus_2 INT;			-- Item
	cyberdeck_2 INT;				-- Character
	character_intelligence_2 INT;	-- Character
	item_kb_bonus_2 INT;			-- Item
	stamina_2 INT;					-- Character
	character_strength_2 INT;		-- Character
	item_st_bonus_2 INT; 			-- Item
	
	max_health_1 INT;
	max_AP_cyber_1 INT;
	max_AP_melee_1 INT;

	max_health_2 INT;
	max_AP_cyber_2 INT;
	max_AP_melee_2 INT;
	
 BEGIN
	-- Hladame vsetko co potrebujem pre 1 hraca
	SELECT id, health, endurance, strength, intelligence, cyberdeck, stamina
    INTO character_1, character_health_1, character_endurance_1, character_strength_1, character_intelligence_1, 
		cyberdeck_1, stamina_1
    FROM Character
    WHERE id = p_character_id;

	SELECT COALESCE(SUM(i.heal_bonus), 0), 
           COALESCE(SUM(i.kb_bonus), 0), 
           COALESCE(SUM(i.st_bonus), 0)
    INTO item_heal_bonus_1, item_kb_bonus_1, item_st_bonus_1
    FROM Item i
    JOIN Inventory inv ON i.id = inv.item_id
    WHERE character_id = p_character_id AND IsWearing = true;
	
	-- Hladanie 2 hraca pre combat
	SELECT id
	INTO character_2
	FROM Character
	WHERE id != p_character_id
	  AND ABS(
	      (strength + intelligence + technique + reaction + endurance) -
	      (SELECT (strength + intelligence + technique + reaction + endurance)
	       FROM Character
	       WHERE id = p_character_id)) <= 5
	LIMIT 1;

	IF character_2 IS NULL THEN
	   RAISE NOTICE 'No opponent found';
	   RETURN;
	END IF;

	-- Hladame vsetko co potrebujem pre 2 hraca
	SELECT health, endurance, strength, intelligence, cyberdeck, stamina
    INTO character_health_2, character_endurance_2, character_strength_2, character_intelligence_2, 
		cyberdeck_2, stamina_2
    FROM Character
    WHERE id = character_2;

	SELECT COALESCE(SUM(i.heal_bonus), 0), 
           COALESCE(SUM(i.kb_bonus), 0), 
           COALESCE(SUM(i.st_bonus), 0)
    INTO item_heal_bonus_2, item_kb_bonus_2, item_st_bonus_2
    FROM Item i
    JOIN Inventory inv ON i.id = inv.item_id
    WHERE character_id = character_2 AND IsWearing = true;
	
	-- Spravim zaznam pre Combat
	INSERT INTO Combat (player1_id, player2_id, status, round_count, location) 
	VALUES (character_1, character_2, 'ongoing', 1, 'city')
	RETURNING id INTO v_combat_id;

	-- Hladanie zdravia a AP
	max_health_1 := character_health_1 + 40 * FLOOR(character_endurance_1 / 2) + item_heal_bonus_1;
	max_AP_cyber_1 := cyberdeck_1 + 3 * CEIL(character_intelligence_1 / 2) + item_kb_bonus_1;
	max_AP_melee_1 := stamina_1 + 5 * CEIL(character_strength_1 / 2) + item_st_bonus_1;

	max_health_2 := character_health_2 + 40 * FLOOR(character_endurance_2 / 2) + item_heal_bonus_2;
	max_AP_cyber_2 := cyberdeck_2 + 3 * CEIL(character_intelligence_2 / 2) + item_kb_bonus_2;
	max_AP_melee_2 := stamina_2 + 5 * CEIL(character_strength_2 / 2) + item_st_bonus_2;

	-- Vyberem, kto chodi prvy
	IF max_health_1 > max_health_2 THEN
		actor_id := character_1;
		target_id := character_2;
	ELSE
		actor_id := character_2;
		target_id := character_1;
	END IF;

	-- Spravim prvy zaznam
	INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, damage_dealt,
		actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result) 
	VALUES (v_combat_id, 1, 0, actor_id, target_id, 'skip', 0,
		max_health_1, max_AP_melee_1, max_AP_cyber_1, max_health_2, max_AP_melee_2, max_AP_cyber_2, 'success');
		
	-- Dalej bude 1 utok
	
 END;
 $$ LANGUAGE plpgsql;