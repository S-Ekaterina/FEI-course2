-- sp_attack_cyber(p_combat_id, p_actor_id, p_target_id, p_item_id, p_attack_id)
-- Pridam zaznam pre test:
INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result)
VALUES
-- Round 3
(11, 3, 2, 5, 1, 'cyberdeck',    11,   6,     14,  95, 13, 5, 100, 32,  9, 'failure');

-- v Combate 11 hrac 1 (Viktor) utoci hraca 5 (Eva) pomocou predmetu 6 ("Seraﬁm") a utoku 9 ("Elektrický výboj")
SELECT sp_attack_cyber(11, 1, 5, 6, 9);
-- Vidim ze posledny zaznam - utok hraca 1 pomocou kyberdeky
SELECT * FROM CombatLog WHERE combat_id=11
