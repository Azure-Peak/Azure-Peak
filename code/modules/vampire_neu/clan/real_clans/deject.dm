/datum/clan/deject
	name = "Deject"
	desc = "Sired and discarded. Your blood is so thin that no clan will claim you, and no elder will ever bother to teach you."
	curse = "Thin blood, no kin, no lord."
	clanicon = "caitiff"
	blood_preference = BLOOD_PREFERENCE_ALL
	selectable_by_vampires = FALSE
	allows_non_vampires = FALSE
	has_clan_menu = FALSE
	has_leadership = FALSE
	clane_covens = list()
	common_covens = list()
	restricted_covens = list()
	covens_to_select = 0
	leader = null

/datum/clan/deject/get_blood_preference_string()
	return "any blood, though it barely sustains you"

/datum/clan/deject/get_downside_string()
	return "burn in sunlight, with no kin to guide you"

/datum/clan/deject/apply_clan_components(mob/living/carbon/human/H)
	H.AddComponent(/datum/component/sunlight_vulnerability)
	H.AddComponent(/datum/component/vampire_disguise)

/datum/clan/deject/setup_vampire_abilities(mob/living/carbon/human/H)
	H.AddSpell(new /obj/effect/proc_holder/spell/targeted/transfix_neu)
	add_verb(H, /mob/living/carbon/human/proc/disguise_verb)
