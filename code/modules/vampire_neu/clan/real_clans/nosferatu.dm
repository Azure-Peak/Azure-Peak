/datum/sprite_accessory/ears/nosferatu
	icon_state = "nosferatu"
	color_key_defaults = list(KEY_SKIN_COLOR)

/datum/clan_leader/nosferatu
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/rat
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_title = "Nosferatu"
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_INFINITE_ENERGY, TRAIT_STRENGTH_UNCAPPED)
	vitae_bonus = 500

/datum/clan/nosferatu
	name = "Nosferatu"
	desc = "The Nosferatu wear their curse on the outside. Their bodies horribly twisted and deformed through the Embrace, they lurk on the fringes of most cities, acting as spies and brokers of information. Using animals and their own supernatural capacity to hide, nothing escapes the eyes of the so-called Sewer Rats."
	curse = "Masquerade-violating appearance."
	clanicon = "melpominee"
	leader = /datum/clan_leader/nosferatu
	clane_covens = list(
		/datum/coven/potence,
		/datum/coven/obfuscate,
		/datum/coven/bloodheal
	)
	blood_preference = BLOOD_PREFERENCE_RATS | BLOOD_PREFERENCE_DEAD | BLOOD_PREFERENCE_KIN
	clane_traits = list(
		TRAIT_STRONGBITE,
		TRAIT_VAMPBITE,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_NOSLEEP,
		TRAIT_VAMPMANSION,
		TRAIT_VAMP_DREAMS,
		TRAIT_DARKVISION,
		TRAIT_LIMBATTACHMENT,
		TRAIT_KEENEARS,
		TRAIT_SILVER_WEAK,
	)
	covens_to_select = 0

/datum/clan/nosferatu/get_downside_string()
	return "have a hideous face, and suffer in the sun"

/datum/clan/nosferatu/get_blood_preference_string()
	return "kindred blood, the blood of the dead, blood of vermin"

/datum/clan/nosferatu/on_gain(mob/living/carbon/human/H, is_vampire = TRUE)
	. = ..()

	if(is_vampire)
		var/obj/item/organ/eyes/night_vision/vampire/NV = new()
		NV.Insert(H, TRUE, FALSE)
		H.ventcrawler = VENTCRAWLER_ALWAYS //I don't think this does anything because we have no vents

/datum/clan/nosferatu/apply_clan_components(mob/living/carbon/human/H)
	pass()
	H.AddComponent(/datum/component/sunlight_vulnerability, damage = 2, drain = 2)
	H.AddComponent(/datum/component/vampire_disguise/nosferatu)
	H.AddComponent(/datum/component/hideous_face, CALLBACK(TYPE_PROC_REF(/datum/clan/nosferatu, face_seen)))

/datum/clan/nosferatu/apply_vampire_look(mob/living/carbon/human/H)
	. = ..()
	var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
	ears?.set_accessory_type(/datum/sprite_accessory/ears/nosferatu)

/datum/clan/nosferatu/remove_vampire_look(mob/living/carbon/human/H)

/datum/clan/nosferatu/proc/face_seen(mob/living/carbon/human/nosferatu)
	nosferatu.AdjustMasquerade(-1)
