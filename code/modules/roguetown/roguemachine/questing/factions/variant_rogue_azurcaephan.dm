/datum/quest_faction_variant/rogue_azurcaephan
	name_singular = "rogue Azurcaephan"
	name_plural = "rogue Azurcaephans"
	group_word = "company"
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/highwayman/spellblade = 45,
		/mob/living/carbon/human/species/human/northern/highwayman/spellblade/champion = 8,
		/mob/living/carbon/human/species/human/northern/highwayman/archer = 20,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 27,
	)
	boss_mob_types = list(
		/mob/living/carbon/human/species/human/northern/highwayman/spellblade/champion = 100,
	)
	boss_title_templates = list(
		"%N the Undefeated",
		"%N the Spellsword",
		"%N the Blade",
		"%N the Hexknight"
	)
