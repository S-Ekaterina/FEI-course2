-- Naplnenie klassov
INSERT INTO Class (name, description) 
VALUES
('Dieta ulic', 'Hovoria, že aby si pochopil ulicu, musíš na nej žiť. Od detstva si sa stýkal s kriminálnikmi, prostitútkami a dílermi, naučil si sa hlavné pravidlo: slabí sa podriaďujú silným. To je jediný zákon Night City, ktorý si neporušil.'),
('Kocovnik', 'Život kočovníka je nebezpečný: vyrastal si v Pustatinách, plienil si a prepadával čerpacie stanice. Cesty ťa mnohému naučili. Hlavné hodnoty kočovníkov — čestnosť, sloboda — sú cudzie obyvateľom Night City.'),
('Korporat', 'Len málokomu sa podarí odísť z korporácie a zachovať si život, nieto ešte česť a dôstojnosť. Pri práci pre korporáciu si porušoval pravidlá, vydieral konkurentov a zbieral informácie — vo vojne je dovolené všetko.');

-- Naplnenie bonusov klasov
INSERT INTO ClassBonus (class_id, condition, effect) 
VALUES
(1, 'mestský boj', '+10 % šanca na únik'),   															-- 'Dieta ulíc' class bonus
(1, '1 HP', 'aut. úkryt'),                    															-- 'Dieta ulíc' class bonus
(2, 'mimo mesto', 'liečivé predmety obnovia o 20 % viac zdravia'),  									-- 'Kočovník' class bonus
(2, 'kapacita predmetov', 'môže niesť viac predmetov, ako povoľuje limit (až o 10 % nad kapacitu)'),  -- 'Kočovník' class bonus
(3, 'kyberútok', 'prvý nepriateľský kyberútok v boji je úplne zablokovaný'),  							-- 'Korporat' class bonus
(3, 'šanca na udvojenie poškodenia', '4 % šanca na udvojenie poškodenia');  							-- 'Korporat' class bonus


-- Naplnenie predmetov
-- Typ: healing
INSERT INTO Item (name, type, description, weight, damage, usage_limit)
VALUES
('Malá lekárnička', 'healing', 'Základná lekárnička na rýchle ošetrenie malých zranení.', 1, 15, 'single-use'),
('Energetický nápoj', 'healing', 'Osobitý nápoj, ktorý mierne obnovuje zdravie a povzbudzuje.', 1, 10, 'single-use'),
('Proteinová tyčinka', 'healing', 'Nutrične vyvážená tyčinka s regeneračným účinkom.', 1, 5, 'single-use'),
('Vojenská lekárska sada', 'healing', 'Pokročilá súprava pre urgentné ošetrenie počas boja.', 3, 50, 'single-use'),
('Chladená voda', 'healing', 'Čistá studená voda, ktorá mierne regeneruje a osviežuje.', 1, 8, 'single-use');

-- Typ: weapon
INSERT INTO Item (name, type, description, weight, damage, melee_chance_bonus, ap_bonus, usage_limit)
VALUES
('Seraﬁm', 'weapon', 'Bližší priateľ Padreho a vykonávateľ Božieho súdu — dva v jednom.', 13, 15, 0.02, -1, 'multi-use'),
('Krvavá Mária', 'weapon', 'Umožňuje nenechať ujsť korisť v Santo Domingo aj v Night City.', 2, 7, 0.09, 1, 'multi-use'),
('Molon labe', 'weapon', 'Zbraň pre najdrsnejších.', 14, 19, 0.10, 0, 'multi-use'),
('Kat', 'weapon', 'Voľba tých, ktorí občas strácajú nepriateľov z dohľadu.', 23, 21, 0.01, 2, 'multi-use'),
('Skippy', 'weapon', 'Smartgun s hlasovým ovládaním. Občas nepredvídateľný.', 22, 11, 0.11, -2, 'multi-use'),
('Nokota D5 „Sidewinder“', 'weapon', 'Inteligentná puška — voľba inteligentných.', 25, 26, 0.00, 4, 'multi-use'),
('Ba Xinqin', 'weapon', 'Sen každého sólo.', 13, 14, 0.13, 2, 'multi-use'),
('Lizzie', 'weapon', 'Vyzerá ako hračka, ale strieľa ako poriadna zbraň.', 31, 4, 0.05, -3, 'multi-use'),
('Chaos', 'weapon', 'Do tejto zbrane sa ľahko zamilujete, no ťažko jej dôverovať.', 23, 14, 0.17, -1, 'multi-use'),
('Prízrak', 'weapon', 'Modiﬁkovaný „Kenshin“, obľúbený medzi agentmi Arasaki.', 14, 30, 0.20, -2, 'multi-use');

-- Typ: cyberdeck
INSERT INTO Item (name, type, description, weight, damage, ap_bonus, cyber_chance_bonus, usage_limit)
VALUES
('Zvukový šok', 'cyberdeck', 'Nemôže byť detegovaný.', 1, 3, -1, 0.20, 'multi-use'),
('Preťaženie', 'cyberdeck', 'Spôsobuje zlyhanie systému.', 1, 2, 0, 0.15, 'multi-use'),
('Skrat', 'cyberdeck', 'Predlžuje účinok všetkých kontrolných skriptov.', 2, 7, 1, 0.18, 'multi-use'),
('Infekcia', 'cyberdeck', 'Nakazí nepriateľské implantáty vírusom spôsobujúcim toxický únik.', 12, 24, 3, 0.10, 'multi-use'),
('Prehriatie', 'cyberdeck', 'Zapáli nepriateľa, čím spôsobuje pretrvávajúce poškodenie.', 6, 17, 2, 0.12, 'multi-use'),
('Tavenie synapsií', 'cyberdeck', 'Spôsobuje obrovské poškodenie.', 8, 30, 4, 0.08, 'multi-use'),
('Výbuch granátu', 'cyberdeck', 'Prinúti nepriateľa odpáliť granát v ruke.', 14, 14, 1, 0.13, 'multi-use'),
('Kyberpsychóza', 'cyberdeck', 'Prinúti nepriateľa napadnúť blízkeho spojenca alebo nepriateľa. Ak je sám, spácha samovraždu.', 13, 10, 0, 0.25, 'multi-use'),
('Samovražda', 'cyberdeck', 'Prinúti nepriateľa zastreliť sa.', 9, 21, -1, 0.11, 'multi-use'),
('Formátovanie', 'cyberdeck', 'Spôsobí, že nepriateľ bezhlučne omdlie.', 1, 5, 0, 0.02, 'multi-use');

-- Typ: armor
INSERT INTO Item (name, type, description, weight, st_bonus, ac_bonus, damage_bonus, heal_bonus, carry_bonus, melee_chance_bonus, usage_limit)
VALUES
('Titanová bunda', 'armor', 'Ľahká, no mimoriadne pevná bunda vyrobená z titanových vlákien.', 5, 2, 6, 2, 0, 10, 0.04, 'multi-use'),
('Nanozbroj “Fantom”', 'armor', 'Pokročilá kamuflážna zbroj, znižuje pravdepodobnosť zásahu.', 3, 1, 4, 1, 2, 5, 0.07, 'multi-use'),
('Balistická vesta “Kríž”', 'armor', 'Používaná špeciálnymi jednotkami, odolná proti väčšine nábojov.', 10, -1, 10, 0, 0, 15, 0.03, 'multi-use'),
('Exosuit MK-II', 'armor', 'Mechanický rám zvyšujúci silu a nosnosť, ale obmedzuje pohyb.', 18, 6, 8, 3, 0, 30, 0.01, 'multi-use'),
('Pouličný pancier', 'armor', 'Zbroj obľúbená medzi gangstrami. Lacná, ale účinná.', 7, 0, 5, 1, 0, 8, 0.06, 'multi-use'),
('Korporátny smoking', 'armor', 'Stylová, ale mierne upravená verzia obleku s kevlarom.', 4, 0, 3, 1, 1, 5, 0.05, 'multi-use'),
('Zdravotná zbroj “Sanitek”', 'armor', 'Poskytuje základnú ochranu a mierne urýchľuje liečenie.', 6, -2, 4, 0, 5, 10, 0.02, 'multi-use'),
('Božská škrupina', 'armor', 'Ťažká experimentalna zbroj s vysokou odolnosťou.', 20, -5, 13, 5, 0, 25, 0.00, 'multi-use'),
('Kevlarový plášť', 'armor', 'Nenápadný, ale účinný. Ideálny pre nájomných zabijakov.', 6, 1, 6, 2, 0, 6, 0.09, 'multi-use'),
('Zbroj “Spása”', 'armor', 'Zosilnená prežitie orientovaná zbroj, podporuje liečbu a výdrž.', 9, 3, 7, 1, 10, 20, 0.08, 'multi-use');

-- Typ: implant
INSERT INTO Item (name, type, description, weight, kb_bonus, ac_bonus, damage_bonus, heal_bonus, carry_bonus, cyber_chance_bonus, usage_limit)
VALUES
('Neurorýchlovač', 'implant', 'Zrýchľuje spracovanie informácií a zvyšuje šancu na úspešný kyberútok.', 3, 2, 2, 0, 0, 5, 0.07, 'multi-use'),
('Kožné brnenie', 'implant', 'Implantované ochranné vrstvy zvyšujúce odolnosť voči zraneniu.', 6, 0, 7, 2, 0, 0, 0.02, 'multi-use'),
('Zdravotný implantát „Aurora“', 'implant', 'Udržiava životné funkcie a zlepšuje regeneráciu zdravia.', 5, 1, 1, 0, 7, 5, 0.01, 'multi-use'),
('Svalový implantát „Kladivo“', 'implant', 'Zvyšuje fyzickú silu a poškodenie v boji na blízko.', 8, 3, 0, 4, 0, 10, 0.00, 'multi-use'),
('Kyberchrbtica', 'implant', 'Spevňuje chrbticu a zvyšuje nosnosť.', 9, -1, 2, 0, 0, 25, 0.03, 'multi-use'),
('Skenovací modul „Orol“', 'implant', 'Zvyšuje presnosť a reakciu pri kyberútokoch.', 4, 0, 3, 1, 0, 5, 0.08, 'multi-use'),
('Implantát „Regen“', 'implant', 'Pasívne regeneruje zdravie počas boja.', 7, -2, 2, 0, 10, 0, 0.01, 'multi-use'),
('Odolnostný implantát „Tank“', 'implant', 'Zvýši ochranu, ale znižuje obratnosť.', 12, -3, 11, 1, 0, 0, 0.00, 'multi-use'),
('Manipulátory „Sirius“', 'implant', 'Presné implantáty rúk ideálne pre hackerov.', 4, 2, 1, 0, 2, 3, 0.09, 'multi-use'),
('Implantát „Titánový kľúč“', 'implant', 'Zabezpečuje priamy prístup k nepriateľským systémom.', 6, 1, 1, 2, 0, 7, 0.10, 'multi-use');


-- Naplnenie hracov
INSERT INTO Character (class_id, name, strength, intelligence, technique, reaction, endurance, health, load_capacity, max_load_capacity, stamina, cyberdeck, melee_attack, cyber_attack, chance_weapon, chance_cyber)
VALUES
(1, 'Viktor', 2, 1, 1, 3, 3, 110, 22, 46, 27, 6, 11, 5, 0, 0), -- Dieťa ulíc
(2, 'Alfie', 1, 1, 1, 2, 5, 95, 18, 55, 32, 8, 9, 6, 0, 0), -- Kočovník
(3, 'Lena', 1, 3, 2, 1, 3, 108, 21, 47, 30, 7, 11, 5, 0, 0), -- Korporát
(1, 'Jack', 3, 2, 2, 4, 6, 102, 20, 48, 29, 6, 10, 5, 0, 0), -- Dieťa ulíc
(2, 'Eva', 1, 2, 1, 3, 7, 95, 19, 52, 28, 7, 9, 6, 0, 0), -- Kočovníк
(3, 'Mark', 2, 4, 3, 1, 4, 105, 21, 49, 30, 7, 11, 5, 0, 0), -- Korporát
(1, 'Max', 4, 2, 1, 3, 5, 97, 19, 54, 31, 7, 9, 6, 0, 0), -- Dieťa ulíc
(2, 'Tom', 1, 1, 2, 3, 6, 108, 21, 49, 32, 6, 10, 5, 0, 0), -- Kočovníк
(3, 'Nina', 2, 3, 2, 1, 4, 100, 20, 51, 30, 7, 10, 5, 0, 0), -- Korporát
(1, 'Sam', 3, 1, 1, 3, 5, 110, 22, 50, 30, 6, 10, 6, 0, 0); -- Dieťa ulíc


-- Naplnenie inventara
INSERT INTO Inventory (item_id, quantity, IsWearing, character_id)
VALUES
-- Viktor
(1, 1, true, 1),   
(2, 2, false, 1),  
(3, 1, false, 1),  
(4, 1, false, 1),  
(5, 3, false, 1),  
-- Alfie
(1, 1, false, 2),  
(2, 2, true, 2),   
(3, 1, false, 2),  
(4, 1, true, 2),   
(6, 1, false, 2),  
-- Lena
(3, 1, true, 3),    
(2, 2, false, 3),  
(5, 1, false, 3),  
(4, 1, false, 3),  
(7, 1, true, 3),  
-- Jack
(1, 1, false, 4),   
(2, 2, false, 4),  
(6, 1, true, 4),   
(8, 1, false, 4),  
(9, 1, true, 4),   
-- Eva
(1, 1, true, 5),   
(2, 2, false, 5),  
(3, 1, false, 5),  
(6, 1, true, 5),   
(5, 1, false, 5),  
-- Mark
(1, 1, false, 6),   
(3, 1, true, 6),   
(4, 1, false, 6),  
(2, 2, false, 6), 
(6, 1, true, 6),   
-- Max
(2, 2, false, 7),   
(3, 1, true, 7),   
(5, 1, false, 7),  
(4, 1, true, 7),  
(7, 1, false, 7), 
-- Tom
(1, 1, true, 8),    
(2, 2, false, 8), 
(6, 1, true, 8),
(9, 1, false, 8),
(10, 1, false, 8);


-- Naplnenie utokov
-- cyberdeck utoky
INSERT INTO Attack (name, type, base_ap_cost, base_damage)
VALUES
('Skratový výboj', 'cyberdeck', 3, 2),
('Hackerov výpad', 'cyberdeck', 4, 3),
('Overload script', 'cyberdeck', 5, 4),
('Vírusová infekcia', 'cyberdeck', 6, 5),
('Požiarne vlny', 'cyberdeck', 7, 4),
('Cyber roztavenie', 'cyberdeck', 8, 5),
('Granátová pasca', 'cyberdeck', 5, 3),
('Vírusová manipulácia', 'cyberdeck', 6, 4),
('Elektrický výboj', 'cyberdeck', 9, 5),
('Mimikrovlny', 'cyberdeck', 4, 2);

-- Мelee utoky
INSERT INTO Attack (name, type, base_ap_cost, base_damage)
VALUES
('Jednoduchý úder', 'melee', 2, 1),
('Silný úder', 'melee', 4, 3),
('Rýchly náraz', 'melee', 3, 2),
('Rozpad', 'melee', 5, 4),
('Úder do brucha', 'melee', 3, 3),
('Kladivo', 'melee', 6, 5),
('Rýchly úder', 'melee', 2, 2),
('Bleskový zásah', 'melee', 4, 3),
('Zničenie', 'melee', 7, 5),
('Odsek', 'melee', 5, 4);


-- Naplnenie utokov hracov
INSERT INTO CharacterAttack (character_id, attack_id) 
VALUES
(1, 1), (1, 11), (1, 2),       -- Viktor
(2, 3), (2, 12),               -- Alfie
(3, 4), (3, 13), (3, 5),       -- Lena
(4, 6), (4, 14),               -- Jack
(5, 7), (5, 15), (5, 8),       -- Eva
(6, 9), (6, 16),               -- Mark
(7, 10), (7, 17),              -- Max
(8, 18), (8, 2), (8, 5),       -- Tom
(9, 19), (9, 6),               -- Nina
(10, 20), (10, 1), (10, 11);   -- Sam


-- Naplnenie atributov
INSERT INTO AttributeBonus (attribute_type, level_parity, bonus_description) 
VALUES
-- strength
('strength', 'even', 'Zvýšenie sily útoku na blízko o 10'),
('strength', 'odd', '+5 k maximálnej výdrži (stamina)'),

-- intelligence
('intelligence', 'even', 'Zvýšenie sily kyberútoku o 10'),
('intelligence', 'odd', '+3 k pamäti kyberdeky'),

-- technique
('technique', 'even', '-1 k spotrebe pamäte pri kyberútokoch'),
('technique', 'odd', '+3 % šanca na kritický zásah (x2) alebo blok útoku'),

-- reaction
('reaction', 'even', '+3 % šanca na úhyb alebo kritický zásah'),
('reaction', 'odd', '+3 % šanca na úhyb alebo kritický zásah'),

-- endurance
('endurance', 'even', '+40 k max. zdraviu, -2 k spotrebe staminu pri útokoch na blízko'),
('endurance', 'odd', '+20 k maximálnej nosnosti inventára');


-- Naplnenie Combatov
INSERT INTO Combat (player1_id, player2_id, winner_id, reward_id, status, round_count, location, started_at, ended_at) VALUES
(1, 2, 1, 3, 'finished', 5, 'city', '2025-04-01 10:00:00', '2025-04-01 10:30:00'),  		-- Viktor vs Alfie, Viktor vyhral
(3, 1, 1, 5, 'finished', 4, 'wasteland', '2025-04-02 11:00:00', '2025-04-02 11:20:00'), 	-- Lena vs Viktor, Viktor vyhral
(2, 1, 1, 2, 'finished', 6, 'city', '2025-04-03 12:00:00', '2025-04-03 12:40:00'),  		-- Alfie vs Viktor, Viktor vyhral
(4, 5, 5, 6, 'finished', 7, 'wasteland', '2025-04-04 13:00:00', '2025-04-04 13:50:00'), 	-- Jack vs Eva, Jack vyhral
(6, 7, 7, 1, 'finished', 3, 'city', '2025-04-05 14:00:00', '2025-04-05 14:20:00'), 		-- Mark vs Max, Max vyhral
(5, 6, 5, 7, 'finished', 8, 'wasteland', '2025-04-06 15:00:00', '2025-04-06 15:40:00'), 	-- Eva vs Mark, Eva vyhrala
(1, 4, 1, 8, 'finished', 2, 'city', '2025-04-07 16:00:00', '2025-04-07 16:50:00'), 		-- Viktor vs Jack, Jack vyhral
(8, 9, 9, 4, 'finished', 6, 'wasteland', '2025-04-08 17:00:00', '2025-04-08 17:30:00'), 	-- Tom vs Nina, Nina vyhrala
(7, 9, 9, 10, 'finished', 5, 'city', '2025-04-09 18:00:00', '2025-04-09 18:25:00'), 		-- Max vs Nina, Nina vyhrala
(10, 1, 1, 9, 'finished', 4, 'wasteland', '2025-04-10 19:00:00', '2025-04-10 19:15:00'); 	-- Sam vs Viktor, Viktor vyhral


-- Naplnenie Character_Combat
INSERT INTO Character_Combat (combat_id, character_id) VALUES
(1, 1),  -- Viktor vs Alfie, Viktor
(1, 2),  -- Viktor vs Alfie, Alfie
(2, 3),  -- Lena vs Viktor, Lena
(2, 1),  -- Lena vs Viktor, Viktor
(3, 2),  -- Alfie vs Lena, Alfie
(3, 3),  -- Alfie vs Lena, Lena
(4, 4),  -- Jack vs Eva, Jack
(4, 5),  -- Jack vs Eva, Eva
(5, 6),  -- Mark vs Max, Max
(5, 7),  -- Mark vs Max, Mark
(6, 5),  -- Eva vs Mark, Eva
(6, 7),  -- Eva vs Mark, Mark
(7, 1),  -- Viktor vs Jack, Viktor
(7, 4),  -- Viktor vs Jack, Jack
(8, 8),  -- Tom vs Nina, Tom
(8, 9),  -- Tom vs Nina, Nina
(9, 7),  -- Max vs Nina, Max
(9, 9),  -- Max vs Nina, Nina
(10, 10), -- Sam vs Viktor, Sam
(10, 1);  -- Sam vs Viktor, Viktor


-- Naplnenie bojov
-- 1 Combat
INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result)
VALUES
-- Initial
(1, 1, 0, 2, 1, 'skip',     NULL, NULL,  0, 100, 30, 10,  95, 30, 10, 'success'),
-- Round 1
(1, 1, 1, 1, 2, 'melee',    11,   6,     4, 110, 15, 10,  95, 30, 10, 'failure'),  
(1, 1, 2, 2, 1, 'cyberdeck',4,   16,    13,  95, 30,  3,  97, 15, 10, 'success'),  
(1, 1, 3, 1, 2, 'loot',     NULL,  5,    0,  97, 15, 10,  95, 30,  3, 'failure'),
-- Round 2
(1, 2, 0, 1, 2, 'skip',     NULL, NULL,  0,  97, 30, 10,  95, 30, 10, 'success'),
(1, 2, 1, 2, 1, 'melee',    12,   6,     5,  95, 12, 10,  92, 30, 10, 'success'), 
(1, 2, 2, 1, 2, 'cyberdeck',5,   16,    13,  92, 30,  1,  82, 12, 10, 'success'),  
(1, 2, 3, 2, 1, 'cyberdeck',9,   16,    20,  82, 12,  0,  72, 30,  1, 'success'), 
-- Round 3
(1, 3, 0, 2, 1, 'skip',     NULL, NULL,  0,  82, 30, 10,  72, 30, 10, 'success'),
(1, 3, 1, 1, 2, 'melee',    14,   6,     4,  72,  3, 10,  59, 30, 10, 'success'),  
(1, 3, 2, 2, 1, 'cyberdeck',2,   16,     3,  59, 30,  1,  46,  3, 10, 'success'),  
(1, 3, 3, 1, 2, 'loot',     NULL,  7,    0,  46,  3, 10,  59, 30,  1, 'success'),
-- Round 4
(1, 4, 0, 1, 2, 'skip',     NULL, NULL,  0,  46, 30, 10,  59, 30, 10, 'success'),
(1, 4, 1, 1, 2, 'melee',    14,   6,    42,  59,  0, 10,   4, 30, 10, 'success'),  
(1, 4, 2, 2, 1, 'melee',    16,   6,    33,   4,  5, 10,  26,  0, 10, 'success'),  
(1, 4, 3, 1, 2, 'cyberdeck',4,   16,     2,  26,  0,  7,   4,  5, 10, 'failure'),  
-- Round 5
(1, 5, 0, 1, 2, 'skip',     NULL, NULL,  0,  26, 30, 10,   4, 30, 10, 'success'),
(1, 5, 1, 2, 1, 'melee',    12,   6,    20,   4, 15, 10,   6, 30, 10, 'success'),  
(1, 5, 2, 1, 2, 'cyberdeck',5,   16,    13,   6, 30,  2,   0, 15, 10, 'success'); 

-- 2 Combat
INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result)
VALUES
-- Initial
(2, 1, 0, 3, 1, 'skip',     NULL, NULL,   0, 108, 30, 10, 110, 30, 10, 'success'),
-- Round 1
(2, 1, 1, 3, 1, 'melee',     11,   6,    13, 110, 20, 10,  95, 30, 10, 'success'), 
(2, 1, 2, 1, 3, 'cyberdeck', 2,    16,    0,  95, 30,  5, 110, 20, 10, 'failure'), 
-- Round 2
(2, 2, 0, 1, 3, 'skip',     NULL, NULL,   0,  95, 30, 10, 110, 30, 10, 'success'),
(2, 2, 1, 3, 1, 'melee',     12,   6,     6, 110, 20, 10,  89, 30, 10, 'success'), 
(2, 2, 2, 1, 3, 'melee',     13,   6,    17,  89, 20, 10,  93, 20, 10, 'success'),
-- Round 3
(2, 3, 0, 3, 1, 'skip',     NULL, NULL,   0,  93, 30, 10,  89, 30, 10, 'success'),
(2, 3, 1, 3, 1, 'cyberdeck', 3,    16,   10,  93, 15,  5,  79, 30, 10, 'success'),
(2, 3, 2, 1, 3, 'melee',     14,   6,    15,  79, 10, 10,  78, 15, 10, 'success'),
-- Round 4
(2, 4, 0, 1, 3, 'skip',     NULL, NULL,   0,  79, 30, 10,  78, 30, 10, 'success'),
(2, 4, 1, 3, 1, 'melee',     15,   6,    10,  78, 20, 10,  69, 30, 10, 'success'),
(2, 4, 2, 1, 3, 'cyberdeck', 6,    16,   10,  69, 20,  5,  59, 20, 10, 'success'),
(2, 4, 3, 3, 1, 'melee',     16,   6,     9,  59, 10, 10,  69, 20,  5, 'failure'),
(2, 4, 4, 1, 3, 'melee',     17,   6,    50,  50, 10,  5,   0, 10, 10, 'success'); 

-- 3 Combat
INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result)
VALUES
-- Initial
(3, 1, 0, 2, 1, 'skip',     NULL, NULL,  0,  95, 30, 10, 110, 30, 10, 'success'),
-- Round 1
(3, 1, 1, 2, 1, 'melee',    11,   6,    16,  95, 20, 10,  94, 30, 10, 'success'),  
(3, 1, 2, 1, 2, 'cyberdeck', 2,   16,    0,  94, 30,  5,  95, 20, 10, 'failure'),
(3, 1, 3, 2, 1, 'cyberdeck', 3,   16,    5,  95, 20,  5,  89, 30,  5, 'success'),
-- Round 2
(3, 2, 0, 1, 2, 'skip',     NULL, NULL,  0,  89, 30, 10,  95, 30, 10, 'success'),
(3, 2, 1, 1, 2, 'melee',    12,   6,     3,  89, 15, 10,  92, 30, 10, 'success'),
(3, 2, 2, 2, 1, 'cyberdeck', 4,   16,    0,  92, 30,  5,  89, 15, 10, 'failure'), 
(3, 2, 3, 1, 2, 'melee',    13,   6,     7,  89,  5, 10,  85, 30, 10, 'success'),  
-- Round 3
(3, 3, 0, 2, 1, 'skip',     NULL, NULL,  0,  85, 30, 10,  89, 30, 10, 'success'),
(3, 3, 1, 2, 1, 'melee',    14,   6,     9,  85, 20, 10,  80, 30, 10, 'success'), 
(3, 3, 2, 1, 2, 'cyberdeck', 5,   16,   13,  80, 30,  5,  72, 20, 10, 'success'),  
(3, 3, 3, 2, 1, 'cyberdeck', 6,   16,    4,  72, 10,  1,  68, 30,  5, 'success'),  
-- Round 4
(3, 4, 0, 1, 2, 'skip',     NULL, NULL,  0,  68, 30, 10,  72, 30, 10, 'success'),
(3, 4, 1, 1, 2, 'melee',    15,   6,     5,  68, 20, 10,  67, 30, 10, 'success'),  
(3, 4, 2, 2, 1, 'melee',    16,   6,     0,  67, 10, 10,  68, 20, 10, 'failure'), 
(3, 4, 3, 1, 2, 'cyberdeck', 7,   16,   10,  68, 20,  5,  57, 10, 10, 'success'),  
-- Round 5
(3, 5, 0, 2, 1, 'skip',     NULL, NULL,  0,  57, 30, 10,  68, 30, 10, 'success'),
(3, 5, 1, 2, 1, 'melee',    17,   6,     6,  57, 20, 10,  62, 30, 10, 'success'),  
(3, 5, 2, 1, 2, 'melee',    18,   6,    11,  62, 10, 10,  46, 20, 10, 'success'),  
(3, 5, 3, 2, 1, 'cyberdeck', 8,   16,    0,  46, 10,  5,  62, 10, 10, 'failure'),  
-- Round 6
(3, 6, 0, 1, 2, 'skip',     NULL, NULL,  0,  46, 30, 10,  62, 30, 10, 'success'),
(3, 6, 1, 1, 2, 'cyberdeck', 9,   16,   15,  46, 20,  5,  47, 30, 10, 'success'),  
(3, 6, 2, 2, 1, 'melee',    19,   6,     0,  47, 10, 10,  46, 20, 10, 'failure'),  
(3, 6, 3, 1, 2, 'melee',    20,   6,    46,  46, 10, 10,   0, 20, 10, 'success');  

-- 4 Combat
INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result)
VALUES
-- Initial
(4, 1, 0, 5, 4, 'skip',      NULL, NULL,   0,  95, 30, 10, 105, 30, 10, 'success'),
-- Round 1
(4, 1, 1, 5, 4, 'melee',     11,   6,    13,  95, 20, 10,  92, 30, 10, 'success'),
(4, 1, 2, 4, 5, 'cyberdeck', 10,  16,     0,  92, 30,  5,  95, 20, 10, 'failure'),
(4, 1, 3, 5, 4, 'cyberdeck',  3,  16,     6,  95, 20,  5,  86, 30,  5, 'success'),
-- Round 2
(4, 2, 0, 4, 5, 'skip',      NULL, NULL,  0,  86, 30, 10,  95, 30, 10, 'success'),
(4, 2, 1, 4, 5, 'melee',     12,   6,     1,  86, 15, 10,  94, 30, 10, 'success'),
(4, 2, 2, 5, 4, 'cyberdeck',  5,  16,     7,  94, 30,  2,  79, 15, 10, 'success'),
(4, 2, 3, 4, 5, 'cyberdeck',  6,  16,    16,  79, 15,  0,  94, 15,  2, 'failure'),
-- Round 3
(4, 3, 0, 5, 4, 'skip',      NULL, NULL,  0,  94, 30, 10,  79, 30, 10, 'success'),
(4, 3, 1, 5, 4, 'melee',     13,   6,    10,  94, 20, 10,  69, 30, 10, 'success'),
(4, 3, 2, 4, 5, 'melee',     14,   6,     3,  69, 20, 10,  91, 30, 10, 'success'),
(4, 3, 3, 5, 4, 'cyberdeck',  4,  16,    18,  91, 20,  5,  64, 20, 10, 'success'),
-- Round 4
(4, 4, 0, 4, 5, 'skip',      NULL, NULL,  0,  64, 30, 10,  91, 30, 10, 'success'),
(4, 4, 1, 4, 5, 'cyberdeck',  5,  16,     9,  64, 20,  5,  82, 30, 10, 'success'),
(4, 4, 2, 5, 4, 'melee',     15,   6,     9,  82, 10, 10,  57, 20, 10, 'success'),
(4, 4, 3, 4, 5, 'melee',     16,   6,     0,  57, 10, 10,  82, 10, 10, 'failure'),
-- Round 5
(4, 5, 0, 5, 4, 'skip',      NULL, NULL,  0,  82, 30, 10,  57, 30, 10, 'success'),
(4, 5, 1, 5, 4, 'melee',     17,   6,    11,  82, 20, 10,  46, 30, 10, 'success'),
(4, 5, 2, 4, 5, 'cyberdeck',  6,  16,    19,  46, 30,  0,  82, 20, 10, 'failure'),
(4, 5, 3, 5, 4, 'cyberdeck',  7,  16,    18,  82, 20,  0,  36, 30,  0, 'success'),
-- Round 6
(4, 6, 0, 4, 5, 'skip',      NULL, NULL,  0,  36, 30, 10,  82, 30, 10, 'success'),
(4, 6, 1, 4, 5, 'melee',     18,   6,     6,  36, 15, 10,  76, 30, 10, 'success'),
(4, 6, 2, 5, 4, 'cyberdeck',  8,  16,     8,  76, 10,  5,  28, 15, 10, 'success'),
(4, 6, 3, 4, 5, 'cyberdeck',  9,  16,     0,  28, 10,  0,  76, 15,  5, 'failure'),
-- Round 7
(4, 7, 0, 5, 4, 'skip',      NULL, NULL,  0,  76, 30, 10,  28, 30, 10, 'success'),
(4, 7, 1, 5, 4, 'melee',     19,   6,    28,  76, 20, 10,   0, 30, 10, 'success');

-- 5 Combat
INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result)
VALUES
-- Initial
(5, 1, 0, 6, 7, 'skip',     NULL, NULL, 0, 105, 30, 10,  97, 30, 10, 'success'),
-- Round 1
(5, 1, 1, 6, 7, 'melee',    11,     6,  2, 105, 20, 10,  95, 30, 10, 'success'),
(5, 1, 2, 7, 6, 'cyberdeck', 3,    16, 10, 100, 30,  9,  95, 20, 10, 'success'),
(5, 1, 3, 6, 7, 'cyberdeck', 4,    16,  6,  95, 20,  4,  89, 30,  9, 'success'),
(5, 1, 4, 7, 6, 'loot',      NULL, 12,  0,  89, 30,  9,  95, 20,  4, 'success'),
-- Round 2
(5, 2, 0, 6, 7, 'skip',     NULL, NULL, 0,  95, 30, 10,  89, 30, 10, 'success'),
(5, 2, 1, 6, 7, 'melee',    12,   6,    9,  95, 15, 10,  80, 30, 10, 'success'),
(5, 2, 2, 7, 6, 'melee',    13,   6,    4,  80, 20, 10,  91, 15, 10, 'success'),
(5, 2, 3, 6, 7, 'cyberdeck', 5,  16,    5,  91, 15,  5,  75, 20, 10, 'success'),
(5, 2, 4, 7, 6, 'cyberdeck', 6,  16,    7,  75, 20,  3,  84, 15,  5, 'success'),
-- Round 3
(5, 3, 0, 6, 7, 'skip',     NULL, NULL, 0,  84, 30, 10,  75, 30, 10, 'success'),
(5, 3, 1, 6, 7, 'melee',    14,   6,    6,  84, 20, 10,  69, 30, 10, 'success'),
(5, 3, 2, 7, 6, 'cyberdeck', 7,  16,    9,  69, 30,  1,  75, 20, 10, 'success'),
(5, 3, 3, 6, 7, 'melee',    15,   6,   10,  75, 10, 10,  59, 30,  1, 'success'),
(5, 3, 4, 7, 6, 'melee',    16,   6,   12,  59, 20,  1,  63, 10, 10, 'success'),
(5, 3, 5, 6, 7, 'cyberdeck', 8,  16,    4,  63, 10,  6,  55, 20,  1, 'success'),
(5, 3, 6, 7, 6, 'melee',    17,   6,   13,  55, 10,  1,  50, 10,  6, 'success'),
(5, 3, 7, 6, 7, 'melee',    18,   6,    0,  50,  0,  6,  50, 10,  1, 'failure'),
(5, 3, 8, 7, 6, 'cyberdeck', 9,  16,   50,  50, 10,  0,   0,  0,  6, 'success');

-- 6 Combat
INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result)
VALUES
-- Initial
(6, 1, 0, 5, 6, 'skip',      NULL, NULL,  0, 105, 30, 10, 105, 30, 10, 'success'),
-- Round 1
(6, 1, 1, 6, 5, 'melee',     12,   6,     2, 105, 25, 10,  93, 30, 10, 'success'),
(6, 1, 2, 5, 6, 'cyberdeck',  7,  16,    10,  93, 30,  9,  94, 25, 10, 'success'),
(6, 1, 3, 6, 5, 'loot',      NULL, 33,    0,  94, 25, 10,  93, 30,  9, 'success'),
-- Round 2
(6, 2, 0, 6, 5, 'skip',      NULL, NULL,  0,  94, 25, 10,  93, 30, 10, 'success'),
(6, 2, 1, 6, 5, 'cyberdeck',  4,  19,    12,  94, 25,  6,  81, 30, 10, 'success'),
(6, 2, 2, 5, 6, 'melee',     18,  10,     5,  81, 27,  6,  89, 25, 10, 'success'),
(6, 2, 3, 6, 5, 'cyberdeck',  2,  25,     0,  89, 25,  2,  81, 27,  6, 'failure'),
-- Round 3
(6, 3, 0, 6, 5, 'skip',      NULL, NULL,  0,  89, 25, 10,  81, 27, 10, 'success'),
(6, 3, 1, 6, 5, 'melee',     13,  11,     9,  89, 20, 10,  72, 27, 10, 'success'),
(6, 3, 2, 5, 6, 'cyberdeck',  8,  21,     8,  72, 27,  4,  81, 20, 10, 'success'),
(6, 3, 3, 6, 5, 'loot',      NULL, 12,    0,  81, 20, 10,  72, 27,  4, 'failure'),
-- Round 4
(6, 4, 0, 6, 5, 'skip',      NULL, NULL,  0,  81, 20, 10,  72, 27, 10, 'success'),
(6, 4, 1, 6, 5, 'cyberdeck',  3,  24,    11,  81, 20,  5,  61, 27, 10, 'success'),
(6, 4, 2, 5, 6, 'melee',     15,   7,     6,  61, 15,  5,  75, 20, 10, 'success'),
(6, 4, 3, 6, 5, 'cyberdeck', 10,  17,     0,  75, 20,  2,  61, 15,  5, 'failure'),
-- Round 5
(6, 5, 0, 6, 5, 'skip',      NULL, NULL,  0,  75, 20, 10,  61, 15, 10, 'success'),
(6, 5, 1, 6, 5, 'melee',     14,   9,    10,  75, 10, 10,  51, 15, 10, 'success'),
(6, 5, 2, 5, 6, 'cyberdeck',  9,  23,     4,  51, 15,  1,  71, 10, 10, 'success'),
(6, 5, 3, 6, 5, 'loot',      NULL, 31,    0,  71, 10, 10,  51, 15,  1, 'success'),
-- Round 6
(6, 6, 0, 6, 5, 'skip',      NULL, NULL,  0,  71, 10, 10,  51, 15, 10, 'success'),
(6, 6, 1, 6, 5, 'cyberdeck',  5,  20,    15,  71, 10,  4,  36, 15, 10, 'success'),
(6, 6, 2, 5, 6, 'melee',     19,   8,     7,  36,  8,  4,  66, 10, 10, 'success'),
(6, 6, 3, 6, 5, 'cyberdeck',  6,  18,     2,  66, 10,  2,  34,  8,  4, 'failure'),
-- Round 7
(6, 7, 0, 6, 5, 'skip',      NULL, NULL,  0,  66, 10, 10,  34,  8, 10, 'success'),
(6, 7, 1, 6, 5, 'melee',     11,  14,    18,  66,  0, 10,  16,  8, 10, 'success'),
(6, 7, 2, 5, 6, 'cyberdeck',  1,  16,     3,  16,  5,  7,  61,  0, 10, 'success'),
(6, 7, 3, 6, 5, 'loot',      NULL,  8,    0,  61,  0, 10,  16,  5,  7, 'failure'),
-- Round 8
(6, 8, 0, 6, 5, 'skip',      NULL, NULL,  0,  61,  0, 10,  16,  5, 10, 'success'),
(6, 8, 1, 6, 5, 'cyberdeck',  2,  25,    16,  61,  0,  5,   0,  5, 10, 'success');

-- 7 Combat
INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result)
VALUES
-- Initial
(7, 1, 0, 4, 1, 'skip',      NULL, NULL,  0, 102, 30, 10, 110, 30, 10, 'success'),
-- Round 1
(7, 1, 1, 1, 4, 'melee',     15,   6,    15, 110, 25, 10,  87, 30, 10, 'success'),
(7, 1, 2, 4, 1, 'cyberdeck',  2,  16,    17,  87, 30,  7,  93, 25, 10, 'success'),
(7, 1, 3, 1, 4, 'cyberdeck',  9,  16,    20,  93, 25,  6,  67, 30, 10, 'success'),
-- Round 2
(7, 2, 0, 1, 4, 'skip',      NULL, NULL,  0,  93, 25, 10,  67, 30, 10, 'success'),
(7, 2, 1, 1, 4, 'melee',     13,   6,    12,  93, 15, 10,  55, 30, 10, 'success'),
(7, 2, 2, 4, 1, 'melee',     18,   6,     9,  55, 22, 10,  87, 15, 10, 'success'),
(7, 2, 3, 1, 4, 'cyberdeck',  4,  16,    55,  87, 15,  5,   0, 22, 10, 'success');

-- 8 Combat
INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result)
VALUES
-- Initial
(8, 1, 0, 8, 9, 'skip',      NULL, NULL,  0, 108, 30, 10, 100, 30, 10, 'success'),
-- Round 1
(8, 1, 1, 9, 8, 'melee',     16,   6,    13, 100, 25, 10,  95, 30, 10, 'success'),
(8, 1, 2, 8, 9, 'melee',     11,   6,     0,  95, 15, 10,  95, 25, 10, 'failure'),
(8, 1, 3, 9, 8, 'cyberdeck',  7,  16,     4,  95, 25,  6,  91, 15, 10, 'success'),
-- Round 2
(8, 2, 0, 9, 8, 'skip',      NULL, NULL,  0,  95, 25, 10,  91, 15, 10, 'success'),
(8, 2, 1, 9, 8, 'melee',     13,   6,    10,  81, 15, 10,  81, 15, 10, 'success'),
(8, 2, 2, 8, 9, 'cyberdeck',  8,  16,     3,  81, 15, 10,  92, 15, 10, 'success'),
(8, 2, 3, 9, 8, 'loot',      NULL,  38,   0,  92, 15,  9,  81, 15,  7, 'success'),
-- Round 3
(8, 3, 0, 9, 8, 'skip',      NULL, NULL,  0,  92, 15, 10,  81, 15, 10, 'success'),
(8, 3, 1, 8, 9, 'melee',     17,   6,     4,  81,  5, 10,  88, 15, 10, 'success'),
(8, 3, 2, 9, 8, 'cyberdeck',  6,  16,     8,  88, 15,  2,  73,  5, 10, 'success'),
(8, 3, 3, 8, 9, 'loot',      NULL,  41,   0,  73,  5, 10,  88, 15,  2, 'failure'),
-- Round 4
(8, 4, 0, 8, 9, 'skip',      NULL, NULL,  0,  73,  5, 10,  88, 15, 10, 'success'),
(8, 4, 1, 9, 8, 'melee',     15,   6,     6,  88,  5, 10,  67,  5, 10, 'success'),
(8, 4, 2, 8, 9, 'melee',     12,   6,     3,  67,  0, 10,  85,  5, 10, 'success'),
(8, 4, 3, 9, 8, 'cyberdeck',  9,  16,     5,  85,  5,  6,  62,  0, 10, 'success'),
-- Round 5
(8, 5, 0, 9, 8, 'skip',      NULL, NULL,  0,  85,  5, 10,  62,  0, 10, 'success'),
(8, 5, 1, 8, 9, 'cyberdeck',  2,  16,     2,  62,  0,  8,  83,  5, 10, 'success'),
(8, 5, 2, 9, 8, 'melee',     20,   6,    15,  83,  5, 10,  47,  0,  8, 'success'),
(8, 5, 3, 8, 9, 'melee',     14,   6,     4,  47,  0,  8,  79,  5, 10, 'success'),
-- Round 6
(8, 6, 0, 8, 9, 'skip',      NULL, NULL,  0,  47,  0, 10,  79,  5, 10, 'success'),
(8, 6, 1, 9, 8, 'cyberdeck',  5,  16,    20,  79,  5,  4,  27,  0, 10, 'success'),
(8, 6, 2, 8, 9, 'melee',     18,   6,     5,  27,  0,  6,  74,  5,  4, 'success'),
(8, 6, 3, 9, 8, 'melee',     19,   6,    27,  74,  5,  4,   0,  0,  6, 'success');

-- 9 Combat
INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result)
VALUES
-- Initial
(9, 1, 0, 7, 9, 'skip',      NULL, NULL,  0,  97, 30, 10, 100, 30, 10, 'success'),
-- Round 1
(9, 1, 1, 9, 7, 'melee',     14,   6,     6, 100, 25, 10,  96, 30, 10, 'success'),
(9, 1, 2, 7, 9, 'cyberdeck',  6,  16,     1,  96, 30, 10, 100, 25, 10, 'success'),
(9, 1, 3, 9, 7, 'melee',     17,   6,     5, 100, 25, 10,  91, 30, 10, 'success'),
-- Round 2
(9, 2, 0, 9, 7, 'skip',      NULL, NULL,  0, 100, 25, 10,  91, 30, 10, 'success'),
(9, 2, 1, 7, 9, 'melee',     11,   6,    13,  91, 20, 10,  87, 25,  6, 'success'),
(9, 2, 2, 9, 7, 'cyberdeck',  4,  16,     6,  87, 25, 10,  69, 20, 10, 'success'),
(9, 2, 3, 7, 9, 'loot',      NULL,  6,    0,  69, 20, 10,  87, 25,  0, 'failure'),
-- Round 3
(9, 3, 0, 7, 9, 'skip',      NULL, NULL,  0,  69, 10, 10,  81, 25,  0, 'success'),
(9, 3, 1, 9, 7, 'melee',     15,   6,    10,  81, 20, 10,  59, 10, 10, 'success'),
(9, 3, 2, 7, 9, 'cyberdeck',  3,  16,     4,  59, 10,  6,  77, 20,  0, 'success'),
(9, 3, 3, 9, 7, 'loot',      NULL,  6,    0,  77, 20,  0,  59, 10,  6, 'success'),
-- Round 4
(9, 4, 0, 9, 7, 'skip',      NULL, NULL,  0,  77, 20,  0,  59, 10,  6, 'success'),
(9, 4, 1, 7, 9, 'melee',     16,   6,     8,  59,  0,  6,  69, 20,  0, 'success'),
(9, 4, 2, 9, 7, 'cyberdeck',  5,  16,    15,  69, 20,  0,  44,  0,  6, 'success'),
(9, 4, 3, 7, 9, 'skip',      NULL, NULL,  0,  44,  0,  6,  69, 20,  0, 'success'),
-- Round 5
(9, 4, 0, 9, 7, 'skip',      NULL, NULL,  0,  69, 30,  10,  32, 30,  10, 'success'),
(9, 5, 1, 9, 7, 'melee',     20,   6,    12,  69, 15,  0,  32,  0,  6, 'success'),
(9, 5, 2, 7, 9, 'melee',     18,   6,     6,  32,  0,  6,  55, 15,  0, 'success'),
(9, 5, 3, 9, 7, 'cyberdeck',  7,  16,    32,  55, 15,  0,   0,  0,  6, 'success');

-- 10 Combat
INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result)
VALUES
-- Initial
(10, 1, 0, 10, 1, 'skip',      NULL, NULL,   0, 110, 30, 10, 110, 30, 10, 'success'),
-- Round 1
(10, 1, 1, 10, 1, 'cyberdeck', 3,    17,     7, 110, 30, 10, 110, 30, 10, 'success'),
(10, 1, 2,  1, 10, 'melee',    11,    6,    19, 110, 30, 10,  91, 30, 10, 'success'),
(10, 1, 3, 10,  1, 'melee',    15,    7,    25,  91, 25, 10,  85, 30, 10, 'success'),
(10, 1, 4,  1, 10, 'loot',     NULL,  21,    0,  85, 30, 10,  91, 25, 10, 'success'),
-- Round 2
(10, 2, 0,  1, 10, 'skip',      NULL, NULL,  0,  85, 25, 10,  91, 25, 10, 'success'),
(10, 2, 1,  1, 10, 'melee',    14,   12,     9,  85, 25, 10,  79, 25, 10, 'success'),
(10, 2, 2, 10,  1, 'cyberdeck',5,    18,    11,  79, 25,  5,  68, 25, 10, 'success'),
(10, 2, 3, 10,  1, 'melee',    19,   10,     7,  68, 20, 10,  75, 25,  5, 'success'),
-- Round 3
(10, 3, 0,  1, 10, 'skip',      NULL, NULL,  0,  75, 20,  5,  75, 20,  5, 'success'),
(10, 3, 1,  1, 10, 'melee',    20,   14,    10,  75, 20,  5,  54, 20, 10, 'success'),
(10, 3, 2, 10,  1, 'cyberdeck',6,    15,     6,  54, 20,  4,  69, 20,  5, 'success'),
(10, 3, 3,  1, 10, 'melee',    17,    6,    12,  69, 15,  5,  42, 20,  4, 'success'),
(10, 3, 4, 10,  1, 'loot',     NULL,  30,    0,  42, 20,  4,  69, 15,  5, 'failure'),
-- Round 4
(10, 4, 0, 10,  1, 'skip',      NULL, NULL,  0,  42, 10,  4,  60, 15,  5, 'success'),
(10, 4, 1, 10,  1, 'melee',    16,   11,     9,  42, 10,  4,  60, 15,  5, 'success'),
(10, 4, 2,  1, 10, 'cyberdeck',4,    22,    32,  60, 15,  0,  10, 10,  4, 'success'),
(10, 4, 3,  1, 10, 'melee',    13,   15,    10,  60, 10,  0,   0, 10,  4, 'success');



-- Naplnenie loota
INSERT INTO Loot (combat_id, item_id, round_number, available) VALUES
-- 1 combat
(1, 1, 1, TRUE),  -- Healing item
(1, 7, 1, TRUE),  -- Weapon item
(1, 2, 2, TRUE),  -- Healing item
(1, 8, 2, TRUE),  -- Weapon item
(1, 3, 3, TRUE),  -- Healing item
(1, 16, 3, TRUE), -- Cyberdeck item
(1, 4, 4, TRUE),  -- Healing item
(1, 17, 4, TRUE), -- Cyberdeck item
(1, 5, 5, TRUE),  -- Healing item
(1, 27, 5, TRUE), -- Armor item
-- 2 combat
(2, 6, 1, TRUE),  -- Healing item
(2, 10, 1, TRUE), -- Weapon item
(2, 11, 2, TRUE), -- Weapon item
(2, 12, 2, TRUE), -- Weapon item
(2, 13, 3, TRUE), -- Healing item
(2, 18, 3, TRUE), -- Cyberdeck item
(2, 14, 4, TRUE), -- Healing item
(2, 19, 4, TRUE), -- Cyberdeck item
-- 3 combat
(3, 16, 1, TRUE), -- Cyberdeck item
(3, 19, 1, TRUE), -- Cyberdeck item
(3, 17, 2, TRUE), -- Cyberdeck item
(3, 18, 2, TRUE), -- Cyberdeck item
(3, 3, 3, TRUE),  -- Healing item
(3, 7, 3, TRUE),  -- Weapon item
(3, 8, 4, TRUE),  -- Weapon item
(3, 20, 4, TRUE), -- Cyberdeck item
(3, 9, 5, TRUE),  -- Weapon item
(3, 26, 5, TRUE), -- Armor item
(3, 2, 6, TRUE),  -- Healing item
-- 4 combat
(4, 2, 1, TRUE),  -- Healing item
(4, 6, 1, TRUE),  -- Weapon item
(4, 3, 2, TRUE),  -- Healing item
(4, 7, 2, TRUE),  -- Weapon item
(4, 5, 3, TRUE),  -- Healing item
(4, 14, 3, TRUE), -- Cyberdeck item
(4, 6, 4, TRUE),  -- Weapon item
(4, 15, 4, TRUE), -- Cyberdeck item
(4, 8, 5, TRUE),  -- Weapon item
(4, 27, 5, TRUE), -- Armor item
(4, 9, 6, TRUE),  -- Weapon item
(4, 28, 6, TRUE), -- Armor item
(4, 4, 7, TRUE),  -- Healing item
-- 5 combat
(5, 2, 1, TRUE),  -- Healing item
(5, 7, 1, TRUE),  -- Weapon item
(5, 3, 2, TRUE),  -- Healing item
(5, 8, 2, TRUE),  -- Weapon item
(5, 5, 3, TRUE),  -- Healing item
-- 6 combat
(6, 1, 1, TRUE),  -- Healing item
(6, 7, 1, TRUE),  -- Weapon item
(6, 16, 2, TRUE), -- Cyberdeck item
(6, 3, 3, TRUE),  -- Healing item
(6, 12, 3, TRUE), -- Weapon item
(6, 17, 4, TRUE), -- Cyberdeck item
(6, 5, 5, TRUE),  -- Healing item
(6, 13, 5, TRUE), -- Weapon item
(6, 18, 6, TRUE), -- Cyberdeck item
(6, 6, 7, TRUE),  -- Weapon item
(6, 28, 7, TRUE), -- Armor item
(6, 8, 8, TRUE),  -- Weapon item
-- 7 combat
(7, 2, 1, TRUE),  -- Healing item
(7, 5, 1, TRUE),  -- Healing item
-- 8 combat
(8, 7, 1, TRUE),  -- Weapon item
(8, 2, 2, TRUE),  -- Healing item
(8, 17, 3, TRUE), -- Cyberdeck item
(8, 8, 4, TRUE),  -- Weapon item
(8, 16, 5, TRUE), -- Cyberdeck item
(8, 27, 6, TRUE), -- Armor item
-- 9 combat
(9, 4, 1, TRUE),  -- Healing item
(9, 9, 1, TRUE),  -- Weapon item
(9, 3, 2, TRUE),  -- Healing item
(9, 8, 2, TRUE),  -- Weapon item
(9, 28, 3, TRUE), -- Armor item
(9, 6, 4, TRUE),  -- Weapon item
(9, 18, 4, TRUE), -- Cyberdeck item
(9, 12, 5, TRUE), -- Weapon item
-- 10 combat
(10, 2, 1, TRUE),  -- Healing item
(10, 5, 1, TRUE),  -- Healing item
(10, 3, 2, TRUE),  -- Healing item
(10, 6, 2, TRUE),  -- Weapon item
(10, 9, 3, TRUE),  -- Weapon item
(10, 16, 3, TRUE), -- Cyberdeck item
(10, 8, 4, TRUE),  -- Weapon item
(10, 17, 4, TRUE); -- Cyberdeck item


-- Podla prikladov, reportov a testov ------------------------------------------------------------------------------------------
INSERT INTO Combat (id, player1_id, player2_id, status, round_count, location, started_at) VALUES
(11, 1, 5, 'ongoing', 1, 'city', '2025-04-01 10:00:00');

INSERT INTO Character_Combat (combat_id, character_id) VALUES
(11, 1),
(11, 5);

INSERT INTO CombatLog (combat_id, round_number, event_number, actor_id, target_id, action_type, attack_id, item_id, damage_dealt, actor_health, actor_stamina, actor_cyberdeck, target_health, target_stamina, target_cyberdeck, result)
VALUES
-- Initial
(11, 1, 0, 5, 1, 'skip',     NULL, NULL,   0, 100, 32, 9,  95, 25,  5, 'success'),
-- Round 1
(11, 1, 1, 1, 5, 'melee',    11,   6,     14,  95, 13, 5, 100, 32,  9, 'failure'),  
(11, 1, 2, 5, 1, 'cyberdeck', 4,  16,     13, 100, 32,  0,  82, 13, 5, 'success');

INSERT INTO Loot (combat_id, item_id, round_number, available) VALUES
-- 1 combat
(11, 40, 2, TRUE);
