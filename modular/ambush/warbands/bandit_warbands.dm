/datum/npc_warband/bandit_band_balanced
	name = "Bandit Band"
	category = FACTION_BANDITS
	faction_tag = "bandits"
	members = list(
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 2,
		/mob/living/carbon/human/species/human/northern/highwayman/archer = 1,
		/mob/living/carbon/human/species/human/northern/highwayman/light = 1,
		/mob/living/carbon/human/species/human/northern/highwayman/bulwark = 1,
	)

/datum/npc_warband/bandit_band_balanced/lean
	name = "Bandit Gang"
	members = list(
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 2,
		/mob/living/carbon/human/species/human/northern/highwayman/light = 1,
	)

/datum/npc_warband/bandit_band_balanced/shieldwall
	name = "Bandit Shieldwall"
	members = list(
		/mob/living/carbon/human/species/human/northern/highwayman/bulwark = 2,
		/mob/living/carbon/human/species/human/northern/highwayman/crossbowman = 2,
	)

/datum/npc_warband/bandit_band_high
	name = "Bandit Warband"
	category = FACTION_BANDITS
	faction_tag = "bandits"
	members = list(
		/mob/living/carbon/human/species/human/northern/highwayman/mount_reaver = 2,
		/mob/living/carbon/human/species/human/northern/highwayman/bulwark = 1,
		/mob/living/carbon/human/species/human/northern/highwayman/sharpshooter = 1,
	)

/datum/npc_warband/bandit_band_high/knight
	name = "Road Knight's Company"
	members = list(
		/mob/living/carbon/human/species/human/northern/highwayman/road_knight = 1,
		/mob/living/carbon/human/species/human/northern/highwayman/bulwark = 1,
		/mob/living/carbon/human/species/human/northern/highwayman/mount_reaver = 1,
		/mob/living/carbon/human/species/human/northern/highwayman/archer = 1,
	)

/datum/npc_warband/bandit_houndmaster
	name = "Houndmaster and Hounds"
	category = FACTION_BANDITS
	faction_tag = "bandits"
	members = list(
		/mob/living/carbon/human/species/human/northern/highwayman/bulwark = 1,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 4,
	)
