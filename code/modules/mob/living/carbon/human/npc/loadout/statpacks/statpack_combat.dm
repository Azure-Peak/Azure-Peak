//** INFANTRY **//

/datum/npc_statpack/rabble
	strength = list(10, 11)
	speed = 10
	constitution = 6
	willpower = 6
	perception = 10
	intelligence = 9

/datum/npc_statpack/soldier
	strength = list(11, 14)
	speed = 11
	constitution = 6
	willpower = 6
	perception = 10
	intelligence = 8

/datum/npc_statpack/soldier/marksman
	constitution = 5
	willpower = 5
	perception = 9

/datum/npc_statpack/veteran
	strength = 12
	speed = 11
	constitution = 8
	willpower = 8
	perception = 11
	intelligence = 10

/datum/npc_statpack/champion
	strength = 14
	speed = 10
	constitution = 10
	willpower = 10
	perception = 10
	intelligence = 8

/datum/npc_statpack/champion/marksman
	strength = 12
	constitution = 7
	willpower = 8
	perception = 13

//** SKIRMISHERS **//

/datum/npc_statpack/skirmisher
	abstract_type = /datum/npc_statpack/skirmisher

/datum/npc_statpack/skirmisher/soldier
	strength = list(12, 13)
	speed = list(12, 13)
	constitution = 8
	willpower = 8
	perception = list(9, 10)
	intelligence = list(8, 9)

/datum/npc_statpack/skirmisher/veteran
	strength = list(12, 14)
	speed = list(12, 14)
	constitution = 8
	willpower = 8
	perception = list(10, 11)
	intelligence = list(9, 10)

/datum/npc_statpack/skirmisher/champion
	strength = list(13, 14)
	speed = list(13, 14)
	constitution = 10
	willpower = 10
	perception = list(11, 12)
	intelligence = list(10, 11)
