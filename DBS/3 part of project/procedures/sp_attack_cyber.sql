CREATE OR REPLACE FUNCTION sp_attack_cyber(
	p_combat_id INTEGER,
    p_actor_id INTEGER,
    p_target_id INTEGER,
    p_item_id INTEGER,
	p_attack_id INTEGER
) RETURNS VOID AS $$
DECLARE
    actor_c INT;    					-- CombatLog
	actor_s INT;    					-- CombatLog
	actor_h INT;    		   			-- CombatLog
    actor_intelligence INT; 			-- Character
	actor_technique INT;    			-- Character
	actor_cyber_attack INT; 			-- Character
    actor_item_damage INT;  			-- Item
	actor_item_damage_bonus INT; 		-- Item
	actor_ap_bonus INT;     			-- Item
	attack_base_damage INT; 			-- Attack
    attack_AP_cost INT;     			-- Attack
	actor_class TEXT;       		    -- Class
    
    target_chance_cyber NUMERIC;		-- Character
    target_class TEXT;					-- Class
	target_cyber_chance_bonus NUMERIC;	-- Item
	target_ac_bonus INT;				-- Item
	target_h INT;						-- CombatLog
	target_s INT;						-- CombatLog
	target_c INT;						-- CombatLog

	event_n INT;						-- CombatLog
	round_n INT;						-- CombatLog
	c_location TEXT;					-- Combat

	actor_cyberdeck_cost INT; 			-- straty kyberdeky
    hit_roll NUMERIC;         			-- random na utok
	x_roll NUMERIC;           			-- random na x2
	chance_to_hit NUMERIC;    			-- sanca na utok
	damage INT;               			-- utok
	full_damage INT;          			-- finalny utok
	class_bonus NUMERIC;
	target_ac INT;
    
BEGIN 
	-- Hladame vsetko co potrebujem
	SELECT target_cyberdeck, target_stamina, target_health, actor_health, actor_stamina, actor_cyberdeck, event_number, round_number
	INTO actor_c, actor_s, actor_h, target_h, target_s, target_c, event_n, round_n
	FROM CombatLog
	WHERE target_id = p_actor_id AND actor_id = p_target_id AND combat_id = p_combat_id
	ORDER BY timestamp DESC, id DESC
	LIMIT 1;
	
	SELECT intelligence, technique, cyber_attack
	INTO actor_intelligence, actor_technique, actor_cyber_attack
	FROM Character
	WHERE id = p_actor_id;
	
	SELECT chance_cyber
	INTO target_chance_cyber
	FROM Character
	WHERE id = p_target_id;

	SELECT COALESCE(SUM(i.damage), 0),
	       COALESCE(SUM(i.damage_bonus), 0),
	       COALESCE(SUM(i.ap_bonus), 0)
	INTO actor_item_damage, actor_item_damage_bonus, actor_ap_bonus
	FROM Item i
	JOIN Inventory inv ON i.id = inv.item_id
	WHERE character_id = p_actor_id AND IsWearing = true;

	SELECT COALESCE(SUM(i.cyber_chance_bonus), 0), 
	       COALESCE(SUM(i.ac_bonus), 0)
	INTO target_cyber_chance_bonus, target_ac_bonus
	FROM Item i
	JOIN Inventory inv ON i.id = inv.item_id
	WHERE character_id = p_target_id AND IsWearing = true;

	SELECT base_damage, base_ap_cost
	INTO attack_base_damage, attack_AP_cost
	FROM Attack
	WHERE id = p_attack_id;

	SELECT cl.name
	INTO actor_class
	FROM Class cl 
	JOIN Character c ON cl.id = c.class_id 
	WHERE c.id = p_actor_id;

	SELECT cl.name
	INTO target_class
	FROM Class cl 
	JOIN Character c ON cl.id = c.class_id 
	WHERE c.id = p_target_id;

	SELECT location
	INTO c_location
	FROM Combat
	WHERE id = p_combat_id;
------------------------------------------------------------------------------------------------------------------------

	-- Spocitanie straty kyberdeky
	IF actor_class = 'Dieta ulic' AND actor_h = 1 THEN
		actor_cyberdeck_cost := 0;
	ELSE
		actor_cyberdeck_cost := GREATEST(0, attack_AP_cost + actor_ap_bonus - FLOOR(actor_technique / 2));
	END IF;
	
	-- Kontrola ze hrac ma dost kyberdeky na ten utok a potom odpocitanie ac
	IF actor_cyberdeck_cost <= actor_c THEN
		actor_c := actor_c - actor_cyberdeck_cost;
	ELSE
		RETURN;
	END IF;
	
	-- Vypocitanie sanca na zasah
	IF target_class = 'Dieta ulic' AND c_location = 'city' THEN
		class_bonus := 0.1;
	ELSIF target_class = 'Korporat' AND (event_n = 1 OR event_n = 2) THEN
		class_bonus := 1;
	ELSE
		class_bonus := 0;
	END IF;
	-- character, technique, item, class
	chance_to_hit := GREATEST(0, 1 - target_chance_cyber - 0.03 * CEIL(actor_technique / 2) - target_cyber_chance_bonus - class_bonus);

	hit_roll := random();
	IF hit_roll <= chance_to_hit THEN
		-- ak utok je uspesny, idem spocitat Damage
		damage := actor_cyber_attack + 10 * FLOOR(actor_intelligence / 2) + actor_item_damage 
			+ actor_item_damage_bonus + attack_base_damage;
		x_roll := random();
		IF actor_class = 'Korporat' AND x_roll <= 0.04 THEN
			damage := 2 * damage;
		END IF;
		-- dalej vypocitame obrannu hodnotu
		target_ac := target_ac_bonus;
		-- a full damage bude
		full_damage := GREATEST(0, damage - target_ac);
		-- Spravim utok
		target_h := GREATEST(0, target_h - full_damage);
		-- spravim novy zaznam:
		INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, 
			damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result) 
		VALUES (p_combat_id, round_n, event_n+1, p_actor_id, p_target_id, 'cyberdeck', p_attack_id, p_item_id, 
			full_damage, actor_h, actor_s, actor_c, target_h, target_s, target_c, 'success');
	ELSE 
		-- ak utok nie je uspesny, spravim novy zaznam:
	    INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, 
			damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result) 
		VALUES (p_combat_id, round_n, event_n+1, p_actor_id, p_target_id, 'cyberdeck', p_attack_id, p_item_id, 
			0, actor_h, actor_s, actor_c, target_h, target_s, target_c, 'failure');
	END IF;
	
END;
$$ LANGUAGE plpgsql;