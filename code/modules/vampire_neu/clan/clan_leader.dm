/datum/clan_leader
	var/list/lord_spells = list(
	)
	var/list/lord_verbs = list(
	)
	var/list/lord_traits = list()
	var/lord_title = "Lord"
	var/vitae_bonus = 5 // Extra vitae for lords
	var/ascended = FALSE

/datum/clan_leader/lord
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat,
		/obj/effect/proc_holder/spell/targeted/shapeshift/gaseousform,
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_INFINITE_ENERGY, TRAIT_STRENGTH_UNCAPPED)
	lord_title = "Lord"
	vitae_bonus = 500 // Extra vitae for lords
	ascended = FALSE

/datum/clan_leader/wretch
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat,
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_title = "Lord"
	ascended = FALSE

/datum/clan_leader/proc/make_new_leader(mob/living/carbon/human/H)
	ADD_TRAIT(H, TRAIT_CLAN_LEADER, "clan")

	// Add lord spells
	for(var/spell_type in lord_spells)
		H.mind?.AddSpell(new spell_type(H.mind))

	// Add lord verbs
	for(var/verb_path in lord_verbs)
		H.verbs |= verb_path

	// Add lord traits
	for(var/trait in lord_traits)
		ADD_TRAIT(H, trait, "lord_component")

	// Update vampire datum if they have one
	var/datum/antagonist/vampire/vamp_datum = H.mind?.has_antag_datum(/datum/antagonist/vampire)
	H.maxbloodpool += vitae_bonus
	if(vamp_datum)
		vamp_datum.name = "[lord_title]"
		vamp_datum.antag_hud_name = "Vlord"

/datum/clan_leader/proc/remove_leader(mob/living/carbon/human/H)
	REMOVE_TRAIT(H, TRAIT_CLAN_LEADER, "clan")
	for(var/spell_type in lord_spells)
		H.mind?.RemoveSpell(spell_type)

	for(var/verb_path in lord_verbs)
		H.verbs -= verb_path

	for(var/trait in lord_traits)
		REMOVE_TRAIT(H, trait, "lord_component")
	H.maxbloodpool -= vitae_bonus
