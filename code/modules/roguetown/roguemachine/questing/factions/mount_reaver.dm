/datum/quest_faction/mount_reaver
	id = QUEST_FACTION_MOUNT_REAVER
	name_singular = "mount reaver"
	name_plural = "mount reavers"
	group_word = "gang"
	faction_tag = FACTION_BANDITS
	can_blockade = TRUE
	category = FACTION_CAT_HUMANOID
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/highwayman/mount_reaver = 55,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20,
		/mob/living/carbon/human/species/human/northern/highwayman/archer = 25,
		/mob/living/carbon/human/species/human/northern/highwayman/crossbowman = 8,
		/mob/living/carbon/human/species/human/northern/highwayman/light = 12,
		/mob/living/carbon/human/species/human/northern/highwayman/bulwark = 12,
		/mob/living/carbon/human/species/human/northern/highwayman/caster = 8,
		/mob/living/carbon/human/species/human/northern/highwayman/spellblade = 7,
		/mob/living/carbon/human/species/human/northern/highwayman/road_knight = 8,
		/mob/living/carbon/human/species/human/northern/highwayman/sharpshooter = 8,
		/mob/living/carbon/human/species/human/northern/doppelganger/ambush = 3,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/human/northern/outlaw_tank = 40,
		/mob/living/carbon/human/species/human/northern/outlaw_ranger = 30,
		/mob/living/carbon/human/species/human/northern/outlaw_duelist = 30,
		/mob/living/carbon/human/species/human/northern/highwayman/caster/boss/pyromancer = 4,
		/mob/living/carbon/human/species/human/northern/highwayman/caster/boss/fulgurmancer = 4,
		/mob/living/carbon/human/species/human/northern/highwayman/caster/boss/geomancer = 4,
		/mob/living/carbon/human/species/human/northern/highwayman/caster/boss/telomancer = 4,
		/mob/living/carbon/human/species/human/northern/highwayman/caster/boss/cryomancer = 4,
		/mob/living/carbon/human/species/human/northern/highwayman/spellblade/boss/blade = 4,
		/mob/living/carbon/human/species/human/northern/highwayman/spellblade/boss/phalangite = 4,
		/mob/living/carbon/human/species/human/northern/highwayman/spellblade/boss/macebearer = 4,
		/mob/living/carbon/human/species/human/northern/highwayman/spellblade/boss/spellfist = 4,
	)
	variant_chances = list(
		/datum/quest_faction_variant/rogue_coven = 10,
		/datum/quest_faction_variant/rogue_azurcaephan = 10,
		/datum/quest_faction_variant/mountain_spirits = 10,
	)
	boss_name_file = "strings/rt/names/human/humnorm.txt"
