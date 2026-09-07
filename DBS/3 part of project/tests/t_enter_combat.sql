-- sp_enter_combat(p_character_id)
-- Hrac 5 (Eva) chce vstupit do cobatu
SELECT sp_enter_combat(5);

-- Vidim novy combat (predpokladam ze id = 12)
SELECT * FROM Combat;
-- Vidim prvy hod noveho combatu (ak id = 12):
SELECT * FROM CombatLog WHERE combat_id=12;


--SELECT setval(
--  pg_get_serial_sequence('Combat','id'),
--  COALESCE(MAX(id),0)
--) FROM Combat;