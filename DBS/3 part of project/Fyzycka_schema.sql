-- Tabulka klasov
CREATE TABLE Class (
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	description VARCHAR(255)
);
-- Tabulka bonusov klasov
CREATE TABLE ClassBonus (
    id SERIAL PRIMARY KEY,
    class_id INTEGER REFERENCES Class(id),
    condition VARCHAR(255),           -- Priklad: "mestský boj", "1 HP", "mimo mesta"
    effect VARCHAR(255)               -- Priklad: "+10 % šanca na únik", "aut. úkryt"
);
-- Tabulka Item
CREATE TABLE Item (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type TEXT CHECK (type IN ('healing', 'weapon', 'cyberdeck', 'armor', 'implant')),
    description VARCHAR(255),
    weight INTEGER CHECK (weight >= 0),
    damage INTEGER DEFAULT 0 CHECK (damage >= 0),
	kb_bonus INTEGER,
	st_bonus INTEGER,
	ac_bonus INTEGER, -- Armor class
	ap_bonus INTEGER, -- potreba na Action points
	damage_bonus INTEGER,
	heal_bonus INTEGER,
	carry_bonus INTEGER, -- ++ k inventaru
	melee_chance_bonus NUMERIC,
	cyber_chance_bonus NUMERIC,
	usage_limit TEXT CHECK (usage_limit IN ('single-use', 'multi-use')) NOT NULL
);
-- Tabulka hracov
CREATE TABLE Character (
    id SERIAL PRIMARY KEY,
    class_id INTEGER REFERENCES Class(id),
    
    name VARCHAR(100) NOT NULL,

    strength INTEGER CHECK (strength >= 0),
    intelligence INTEGER CHECK (intelligence >= 0),
    technique INTEGER CHECK (technique >= 0),
    reaction INTEGER CHECK (reaction >= 0),
    endurance INTEGER CHECK (endurance >= 0),
    
    health INTEGER CHECK (health >= 0),
    load_capacity INTEGER CHECK (load_capacity >= 0),         -- aktualny
    max_load_capacity INTEGER CHECK (max_load_capacity >= 0), -- base load
    
    stamina INTEGER CHECK (stamina >= 0),
    cyberdeck INTEGER CHECK (cyberdeck >= 0),

    melee_attack INTEGER CHECK (melee_attack >= 0), -- ?
    cyber_attack INTEGER CHECK (cyber_attack >= 0), -- ?

    chance_weapon NUMERIC CHECK (chance_weapon >= 0 AND chance_weapon <= 1),
    chance_cyber NUMERIC CHECK (chance_cyber >= 0 AND chance_cyber <= 1)
);
-- Tabulka Inventory
CREATE TABLE Inventory (
    id SERIAL PRIMARY KEY,
    character_id INTEGER REFERENCES Character(id) ON DELETE CASCADE,
    item_id INTEGER REFERENCES Item(id),
    quantity INTEGER CHECK (quantity >= 1),
	IsWearing BOOLEAN DEFAULT false
);
-- Tabulka utokov
CREATE TABLE Attack (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type TEXT CHECK (type IN ('melee', 'cyberdeck')),
    base_ap_cost INTEGER CHECK (base_ap_cost >= 0),
    base_damage INTEGER CHECK (base_damage >= 0)
);
-- Tabulka utokov hraca
CREATE TABLE CharacterAttack (
    id SERIAL PRIMARY KEY,
    character_id INTEGER REFERENCES Character(id),
    attack_id INTEGER REFERENCES Attack(id),
    UNIQUE (character_id, attack_id)
);
-- Tabulka ++ atributov
CREATE TABLE AttributeBonus (
    id SERIAL PRIMARY KEY,
	character_id INTEGER REFERENCES Character(id),
    attribute_type TEXT CHECK (attribute_type IN ('strength', 'intelligence', 'technique', 'reaction', 'endurance')),
    level_parity TEXT CHECK (level_parity IN ('even', 'odd')),
    bonus_description VARCHAR(255) NOT NULL
);
-- Tabulka Combat
CREATE TABLE Combat (
    id SERIAL PRIMARY KEY,
    player1_id INTEGER REFERENCES Character(id),
    player2_id INTEGER REFERENCES Character(id),
    winner_id INTEGER REFERENCES Character(id),
    reward_id INTEGER REFERENCES Item(id),
    started_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP,
    status TEXT CHECK (status IN ('ongoing', 'finished', 'cancelled')) NOT NULL,
    round_count INTEGER CHECK (round_count >= 0),
    location TEXT CHECK (location IN ('city', 'wasteland'))
);
-- Tabulka medzi Character a Combat
CREATE TABLE Character_Combat (
    combat_id INTEGER REFERENCES Combat(id),
    character_id INTEGER REFERENCES Character(id),
    PRIMARY KEY (combat_id, character_id)
);
-- Tabulka CombatLog
CREATE TABLE CombatLog (
    id SERIAL PRIMARY KEY,
    combat_id INTEGER REFERENCES Combat(id) ON DELETE CASCADE,
    round_number INTEGER CHECK (round_number >= 0),
	event_number INTEGER CHECK (event_number >= 0),
    actor_id INTEGER REFERENCES Character(id),
    target_id INTEGER REFERENCES Character(id),
    action_type TEXT CHECK (action_type IN ('melee', 'cyberdeck', 'loot', 'skip')),
	attack_id INTEGER REFERENCES Attack(id),
	item_id INTEGER REFERENCES Item(id),
	damage_dealt INTEGER CHECK (damage_dealt >= 0),
    actor_health INTEGER,
    actor_stamina INTEGER,
    actor_cyberdeck INTEGER,
    target_health INTEGER,
    target_stamina INTEGER,
    target_cyberdeck INTEGER,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    result TEXT CHECK (result IN ('success', 'failure'))
);
-- Tabulka Loot
CREATE TABLE Loot (
    id SERIAL PRIMARY KEY,
	combat_id INTEGER REFERENCES Combat(id) ON DELETE CASCADE,
	item_id INTEGER REFERENCES Item(id),
    round_number INTEGER CHECK (round_number >= 0),
    available BOOLEAN DEFAULT FALSE
);

----------------------------------------------------------------------------------------------------------
CREATE INDEX idx_inventory_character_iswearing ON Inventory(character_id, iswearing);
CREATE INDEX idx_inventory_character_item ON Inventory(character_id, item_id);

CREATE INDEX idx_combatlog_combat_ts_id ON CombatLog(combat_id, timestamp DESC, id DESC);
CREATE INDEX idx_combatlog_actor_ts_id ON CombatLog(actor_id, timestamp DESC, id DESC);
CREATE INDEX idx_combatlog_combat_actor_target_ts ON CombatLog(combat_id, actor_id, target_id, timestamp DESC, id DESC);

CREATE INDEX idx_loot_combat_item_available ON Loot(combat_id, item_id, available);

CREATE INDEX idx_character_class_id ON Character(class_id);
