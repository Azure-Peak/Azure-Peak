/datum/quest_faction/highwayman
	id = QUEST_FACTION_HIGHWAYMAN
	name_singular = "highwayman"
	name_plural = "highwaymen"
	group_word = "gang"
	faction_tag = FACTION_BANDITS
	can_blockade = TRUE
	category = FACTION_CAT_HUMANOID
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 70,
		/mob/living/carbon/human/species/human/northern/militia/deserter = 30,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/human/northern/outlaw_duelist = 100,
	)
	boss_title_templates = list(
		"%N the Cutthroat",
		"%N the Quick",
		"%N the Wolf",
		"%N Bloodhand",
	)
	boss_name_file = "strings/rt/names/human/humnorm.txt"
	crime_weights = list(
		CRIME_BRIGANDAGE = 10,
		CRIME_ROAD_ROBBERY = 8,
		CRIME_PILGRIM_ROBBERY = 5,
		CRIME_MURDER_STEALTH = 5,
		CRIME_MURDER_WATCH = 3,
		CRIME_HERALD_SLAYING = 2,
		CRIME_ARSON_NIGHT = 4,
		CRIME_GRANARY_BURNING = 2,
		CRIME_BURGLARY = 4,
		CRIME_CATTLE_LIFTING = 4,
		CRIME_HORSE_THEFT = 4,
		CRIME_COIN_CLIPPING = 2,
		CRIME_SEAL_FORGERY = 1,
		CRIME_PRISON_BREAKING = 2,
		CRIME_HARBOURING_OUTLAWS = 3,
		CRIME_RECEIVING_STOLEN = 3,
		CRIME_CLERIC_ROBBERY = 2,
		CRIME_SHRINE_ROBBERY = 1,
		CRIME_PETTY_CHICKEN = 2,
		CRIME_PETTY_ORCHARD = 2,
		CRIME_PETTY_BRAWL = 3,
		CRIME_PETTY_DUELING = 2,
		CRIME_PETTY_ALMS_THEFT = 2,
		CRIME_PETTY_PRIEST_MOCKING = 1,
		CRIME_PETTY_DOG_KICKING = 1,
		CRIME_PETTY_PROPOSAL_SCORN = 1,
		CRIME_PETTY_GUEST_WINE = 1,
		CRIME_PETTY_TOMBSTONE_INSULT = 1,
		CRIME_POACHING_LAND = 3,
		CRIME_POACHING_FISH = 1,
		CRIME_FALSE_RELICS = 1,
		CRIME_OATH_BETRAYAL = 2,
	)
