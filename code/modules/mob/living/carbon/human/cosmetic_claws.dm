#define CLAW_STYLE_RETRACTABLE "Retractable claws"
#define CLAW_STYLE_HOOKED "Hooked claws"
#define CLAW_STYLE_HEAVY "Heavy beast-claws"
#define CLAW_STYLE_TALONS "Sharp talons"
#define CLAW_STYLE_CHITINOUS "Chitinous claws"

// These RT species either explicitly have claws in their physiology. This allows them to use cosmetic claws without having to add a new different mechanical attack to the game. In other words, these species can use cosmetic claws because they have claws in their body.
/datum/species/anthromorph
	cosmetic_claw_types = list(
		CLAW_STYLE_RETRACTABLE = /datum/intent/unarmed/punch/cosmetic_claw/retractable,
		CLAW_STYLE_HOOKED = /datum/intent/unarmed/punch/cosmetic_claw/hooked,
		CLAW_STYLE_HEAVY = /datum/intent/unarmed/punch/cosmetic_claw/heavy,
		CLAW_STYLE_TALONS = /datum/intent/unarmed/punch/cosmetic_claw/talons,
		CLAW_STYLE_CHITINOUS = /datum/intent/unarmed/punch/cosmetic_claw/chitinous,
	)

/datum/species/anthromorphsmall
	cosmetic_claw_types = list(
		CLAW_STYLE_RETRACTABLE = /datum/intent/unarmed/punch/cosmetic_claw/retractable,
		CLAW_STYLE_HOOKED = /datum/intent/unarmed/punch/cosmetic_claw/hooked,
		CLAW_STYLE_HEAVY = /datum/intent/unarmed/punch/cosmetic_claw/heavy,
		CLAW_STYLE_TALONS = /datum/intent/unarmed/punch/cosmetic_claw/talons,
		CLAW_STYLE_CHITINOUS = /datum/intent/unarmed/punch/cosmetic_claw/chitinous,
	)

/datum/species/dracon
	cosmetic_claw_types = list(
		CLAW_STYLE_RETRACTABLE = /datum/intent/unarmed/punch/cosmetic_claw/retractable,
		CLAW_STYLE_HOOKED = /datum/intent/unarmed/punch/cosmetic_claw/hooked,
		CLAW_STYLE_HEAVY = /datum/intent/unarmed/punch/cosmetic_claw/heavy,
		CLAW_STYLE_TALONS = /datum/intent/unarmed/punch/cosmetic_claw/talons,
	)

/datum/species/kobold
	cosmetic_claw_types = list(
		CLAW_STYLE_RETRACTABLE = /datum/intent/unarmed/punch/cosmetic_claw/retractable,
		CLAW_STYLE_HOOKED = /datum/intent/unarmed/punch/cosmetic_claw/hooked,
		CLAW_STYLE_HEAVY = /datum/intent/unarmed/punch/cosmetic_claw/heavy,
		CLAW_STYLE_TALONS = /datum/intent/unarmed/punch/cosmetic_claw/talons,
	)

/datum/species/lizardfolk
	cosmetic_claw_types = list(
		CLAW_STYLE_RETRACTABLE = /datum/intent/unarmed/punch/cosmetic_claw/retractable,
		CLAW_STYLE_HOOKED = /datum/intent/unarmed/punch/cosmetic_claw/hooked,
		CLAW_STYLE_HEAVY = /datum/intent/unarmed/punch/cosmetic_claw/heavy,
		CLAW_STYLE_TALONS = /datum/intent/unarmed/punch/cosmetic_claw/talons,
	)

/datum/species/lupian
	cosmetic_claw_types = list(
		CLAW_STYLE_RETRACTABLE = /datum/intent/unarmed/punch/cosmetic_claw/retractable,
		CLAW_STYLE_HOOKED = /datum/intent/unarmed/punch/cosmetic_claw/hooked,
		CLAW_STYLE_HEAVY = /datum/intent/unarmed/punch/cosmetic_claw/heavy,
	)

/datum/species/vulpkanin
	cosmetic_claw_types = list(
		CLAW_STYLE_RETRACTABLE = /datum/intent/unarmed/punch/cosmetic_claw/retractable,
		CLAW_STYLE_HOOKED = /datum/intent/unarmed/punch/cosmetic_claw/hooked,
		CLAW_STYLE_HEAVY = /datum/intent/unarmed/punch/cosmetic_claw/heavy,
	)

/datum/species/tabaxi
	cosmetic_claw_types = list(
		CLAW_STYLE_RETRACTABLE = /datum/intent/unarmed/punch/cosmetic_claw/retractable,
		CLAW_STYLE_HOOKED = /datum/intent/unarmed/punch/cosmetic_claw/hooked,
		CLAW_STYLE_HEAVY = /datum/intent/unarmed/punch/cosmetic_claw/heavy,
	)

/datum/species/moth
	cosmetic_claw_types = list(
		CLAW_STYLE_CHITINOUS = /datum/intent/unarmed/punch/cosmetic_claw/chitinous,
		CLAW_STYLE_HOOKED = /datum/intent/unarmed/punch/cosmetic_claw/hooked,
	)

/mob/living/carbon/human/apply_intent_customizations(datum/intent/intent)
	. = ..()
	if(intent.type != INTENT_HARM || !cosmetic_claw_intent)
		return
	var/datum/intent/unarmed/punch/cosmetic_claw/claw_presentation = new cosmetic_claw_intent(src)
	intent.name = claw_presentation.name
	intent.desc = claw_presentation.desc
	intent.attack_verb = claw_presentation.attack_verb.Copy()
	intent.animname = claw_presentation.animname
	intent.miss_text = claw_presentation.miss_text
	intent.hitsound = cosmetic_claw_hitsound
	intent.miss_sound = cosmetic_claw_miss_sound
	qdel(claw_presentation)

/mob/living/carbon/human/verb/choose_cosmetic_claws()
	set name = "Choose Natural Attack Appearance"
	set category = "IC"

	if(cosmetic_claws_configured)
		remove_verb(src, /mob/living/carbon/human/verb/choose_cosmetic_claws)
		return

	var/list/available_claws = dna?.species?.cosmetic_claw_types
	var/harm_index = base_intents.Find(INTENT_HARM)
	if(!length(available_claws) || !harm_index)
		remove_verb(src, /mob/living/carbon/human/verb/choose_cosmetic_claws)
		return

	cosmetic_claws_configured = TRUE
	remove_verb(src, /mob/living/carbon/human/verb/choose_cosmetic_claws)

	var/use_claws = tgui_alert(src, "My natural claws could take the place of my closed fists. This changes only the appearance, sound, and wording of my unarmed attacks; they remain punches in every mechanical respect.", "NATURAL WEAPONS", list("Fight with claws", "Keep using fists"))
	if(use_claws != "Fight with claws")
		to_chat(src, span_notice("I will continue to fight with closed fists."))
		return

	var/claw_style = tgui_input_list(src, "What form do my natural claws take? This choice is entirely cosmetic.", "NATURAL WEAPONS", available_claws)
	var/claw_intent = available_claws[claw_style]
	if(!claw_intent)
		to_chat(src, span_notice("I will continue to fight with closed fists."))
		return

	var/static/list/sound_profiles = list(
		"Light claw - medium blunt woosh" = list(BLUNTWOOSH_MED, BLUNTWOOSH_MED),
		"Heavy claw - large blunt woosh" = list(BLUNTWOOSH_LARGE, BLUNTWOOSH_LARGE),
		"Massive claw - huge blunt woosh" = list(BLUNTWOOSH_HUGE, BLUNTWOOSH_HUGE),
	)
	var/sound_profile_name = tgui_input_list(src, "What sound accompanies my clawed strikes? This choice is entirely cosmetic.", "NATURAL WEAPONS", sound_profiles)
	if(!sound_profile_name)
		sound_profile_name = "Light claw - medium blunt woosh"
	var/list/sound_profile = sound_profiles[sound_profile_name]
	cosmetic_claw_hitsound = sound_profile[1]
	cosmetic_claw_miss_sound = sound_profile[2]

	cosmetic_claw_intent = claw_intent
	update_a_intents()
	to_chat(src, span_notice("I will now fight with [lowertext(claw_style)], accompanied by [lowertext(sound_profile_name)]. They are no stronger than my fists."))

#undef CLAW_STYLE_RETRACTABLE
#undef CLAW_STYLE_HOOKED
#undef CLAW_STYLE_HEAVY
#undef CLAW_STYLE_TALONS
#undef CLAW_STYLE_CHITINOUS
