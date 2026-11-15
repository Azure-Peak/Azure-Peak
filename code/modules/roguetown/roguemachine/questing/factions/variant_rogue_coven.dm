/datum/quest_faction_variant/rogue_coven
	name_singular = "rogue mage"
	name_plural = "rogue mages"
	group_word = "coven"
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/highwayman/caster = 40,
		/mob/living/carbon/human/species/human/northern/highwayman/caster/magister = 8,
		/mob/living/carbon/human/species/human/northern/highwayman/bulwark = 20,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 22,
		/mob/living/carbon/human/species/human/northern/highwayman/archer = 10,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/human/northern/highwayman/caster/magister = 100,
	)
	boss_title_templates = list(
		"%N the Magister",
		"%N the Hexer",
		"%N the Magi",
		"%N the Great",
		"%N the Ancient"
	)
