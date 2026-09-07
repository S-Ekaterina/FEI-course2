CREATE OR REPLACE FUNCTION f_effective_cyber_cost(
	p_attack_id INTEGER,
	p_caster_id INTEGER
 ) RETURNS INT AS $$
 DECLARE
	caster_class TEXT;		-- Class
	caster_health INT;		-- CombatLog
	attack_AP_cost INT;		-- Attack
	caster_ap_bonus INT;	-- Item
	caster_technique INT;	-- Character
	
 	v_effective_cost INT;
	
 BEGIN

 	SELECT c.technique, cl.name
	INTO caster_technique, caster_class
	FROM Character c
	JOIN Class cl ON cl.id = c.class_id
	WHERE c.id = p_caster_id;

	SELECT actor_health
	INTO caster_health
	FROM CombatLog
	WHERE actor_id = p_caster_id
	ORDER BY timestamp DESC, id DESC
	LIMIT 1;

	SELECT base_ap_cost
	INTO attack_AP_cost
	FROM Attack
	WHERE id = p_attack_id;

	SELECT COALESCE(SUM(i.ap_bonus), 0)
	INTO caster_ap_bonus
	FROM Item i
	JOIN Inventory inv ON i.id = inv.item_id
	WHERE character_id = p_caster_id AND IsWearing = true;


	-- Spocitanie straty kyberdeky
	IF caster_class = 'Dieta ulic' AND caster_health = 1 THEN
		v_effective_cost := 0;
	ELSE
		v_effective_cost := GREATEST(0, attack_AP_cost + caster_ap_bonus - FLOOR(caster_technique / 2));
	END IF;
 
 	RETURN v_effective_cost;
 END;
 $$ LANGUAGE plpgsql;
