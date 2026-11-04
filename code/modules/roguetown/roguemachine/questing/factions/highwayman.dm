/datum/quest_faction/highwayman
	id = QUEST_FACTION_HIGHWAYMAN
	name_singular = "highwayman"
	name_plural = "highwaymen"
	group_word = "gang"
	faction_tag = FACTION_BANDITS
	can_blockade = TRUE
	category = FACTION_CAT_HUMANOID
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 50,
		/mob/living/carbon/human/species/human/northern/militia/deserter = 20,
		/mob/living/carbon/human/species/human/northern/highwayman/archer = 19, // archer+crossbowman+sharpshooter ~30% of highwaymen (ranged)
		/mob/living/carbon/human/species/human/northern/highwayman/crossbowman = 7,
		/mob/living/carbon/human/species/human/northern/highwayman/light = 14,
		/mob/living/carbon/human/species/human/northern/highwayman/bulwark = 8,
		/mob/living/carbon/human/species/human/northern/highwayman/road_knight = 8,
		/mob/living/carbon/human/species/human/northern/highwayman/sharpshooter = 8,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/human/northern/outlaw_duelist = 70,
		/mob/living/carbon/human/species/human/northern/outlaw_ranger = 30,
	)
	boss_title_templates = list(
		"%N the Cutthroat",
		"%N the Quick",
		"%N the Wolf",
		"%N Bloodhand",
	)
	boss_name_file = "strings/rt/names/human/humnorm.txt"
	crime_weights = list(
		/datum/quest_crime/brigandage = 10,
		/datum/quest_crime/road_robbery = 8,
		/datum/quest_crime/pilgrim_robbery = 5,
		/datum/quest_crime/murder_stealth = 5,
		/datum/quest_crime/murder_watch = 3,
		/datum/quest_crime/herald_slaying = 2,
		/datum/quest_crime/arson_night = 4,
		/datum/quest_crime/granary_burning = 2,
		/datum/quest_crime/burglary = 4,
		/datum/quest_crime/cattle_lifting = 4,
		/datum/quest_crime/horse_theft = 4,
		/datum/quest_crime/coin_clipping = 2,
		/datum/quest_crime/seal_forgery = 1,
		/datum/quest_crime/prison_breaking = 2,
		/datum/quest_crime/harbouring_outlaws = 3,
		/datum/quest_crime/receiving_stolen = 3,
		/datum/quest_crime/cleric_robbery = 2,
		/datum/quest_crime/shrine_robbery = 1,
		/datum/quest_crime/petty_chicken = 2,
		/datum/quest_crime/petty_orchard = 2,
		/datum/quest_crime/petty_brawl = 3,
		/datum/quest_crime/petty_dueling = 2,
		/datum/quest_crime/petty_alms_theft = 2,
		/datum/quest_crime/petty_priest_mocking = 1,
		/datum/quest_crime/petty_dog_kicking = 1,
		/datum/quest_crime/petty_proposal_scorn = 1,
		/datum/quest_crime/petty_guest_wine = 1,
		/datum/quest_crime/petty_tombstone_insult = 1,
		/datum/quest_crime/petty_lewd_hermes = 1,
		/datum/quest_crime/petty_lewd_gods_art = 1,
		/datum/quest_crime/petty_telescope_peeping = 1,
		/datum/quest_crime/petty_badger_notice = 1,
		/datum/quest_crime/petty_hermes_fish = 1,
		/datum/quest_crime/petty_false_hammerhold = 1,
		/datum/quest_crime/poaching_land = 3,
		/datum/quest_crime/poaching_fish = 1,
		/datum/quest_crime/false_relics = 1,
		/datum/quest_crime/oath_betrayal = 2,
	)
