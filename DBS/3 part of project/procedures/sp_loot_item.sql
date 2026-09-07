CREATE OR REPLACE FUNCTION sp_loot_item(
 p_combat_id INTEGER,
 p_character_id INTEGER,
 p_item_id INTEGER
 ) RETURNS VOID AS $$
 DECLARE
 	loot_id INT;					-- Loot
	item_weight INT;				-- Item
	character_class TEXT;			-- Class
	base_character_load_capacity INT; -- Character
	character_load_capacity INT; 	-- Character
	character_endurance INT;		-- Character
	item_carry_bonus INT;			-- Item
	
	r_number INT;					-- CombatLog
	e_number INT;					-- CombatLog
	
	class_bonus NUMERIC;
	max_load INT;
	
 BEGIN
 	-- Hladame round_number, event_number
	SELECT round_number, event_number
	INTO r_number, e_number
	FROM CombatLog
	WHERE combat_id = p_combat_id
	ORDER BY timestamp DESC, id DESC
	LIMIT 1;
	
	-- Skontrolujem, ci mozem zobrat predmet
	SELECT id
    INTO loot_id
    FROM Loot
	WHERE combat_id = p_combat_id
	  AND item_id   = p_item_id
	  AND available = TRUE;

	IF NOT FOUND THEN
        RETURN;
    END IF;

	-- Najdeme vahu predmeta
	SELECT weight
	INTO item_weight
	FROM Item
	WHERE id = p_item_id;

	-- Njdeme max vahu inventara:
	SELECT max_load_capacity, endurance, load_capacity
	INTO base_character_load_capacity, character_endurance, character_load_capacity
	FROM Character
	WHERE id = p_character_id;

	SELECT COALESCE(SUM(i.carry_bonus), 0)
	INTO item_carry_bonus
	FROM Item i
	JOIN Inventory inv ON i.id = inv.item_id
	WHERE character_id = p_character_id AND IsWearing = true;

	SELECT cl.name
	INTO character_class
	FROM Class cl 
	JOIN Character c ON cl.id = c.class_id 
	WHERE c.id = p_character_id;

-------------------------------------------------------------------------------------------------------------------------------------
	IF character_class = 'Kocovnik' THEN
		class_bonus := 1.1;
	ELSE
		class_bonus := 1;
	END IF;
	
	max_load := ((base_character_load_capacity + 20 * CEIL(character_endurance / 2) + item_carry_bonus) * class_bonus)::INT;

	-- Skontrolujem, ze aktualna vaha + vaha predmetu bude menej ako max vaha
	IF max_load < (item_weight + character_load_capacity) THEN
		RAISE NOTICE 'V inventari nie je miesto pre predmet % (váha=%). Maximalna kapacita: %',
	    p_item_id, item_weight, max_load;
		RETURN;
	END IF;

	-- Spravim predmet nedostupnym
	UPDATE Loot
    SET available = FALSE
    WHERE id = loot_id;
	
	-- Obnovime aktualnu vahu hraca 
	UPDATE Character
    SET load_capacity = item_weight + character_load_capacity
    WHERE id = p_character_id;
	
	-- Pridame predmet do inventara
	UPDATE Inventory
	   SET quantity = quantity + 1
	 WHERE character_id = p_character_id
	   AND item_id      = p_item_id;
	
	IF NOT FOUND THEN
	  INSERT INTO Inventory(item_id, quantity, iswearing, character_id)
	  VALUES (p_item_id, 1, FALSE, p_character_id);
	END IF;

	-- Pridame zaznam do CombatLog
	INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, action_type, item_id, result) 
	VALUES (p_combat_id, r_number, e_number+1, p_character_id, 'loot', p_item_id, 'success');

 END;
 $$ LANGUAGE plpgsql;