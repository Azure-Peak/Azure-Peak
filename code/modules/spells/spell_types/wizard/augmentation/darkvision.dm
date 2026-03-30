/datum/action/cooldown/spell/darkvision
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	name = "Darkvision"
	desc = "Enhance the night vision of yourself and everyone around you for 15 minutes."
	fluff_desc = "When the first men walked the world, they were not gifted with sight at night. They were preys to monsters and animals in the dark. Noc, in his infinite wisdom, bestowed upon humenity the gift of noc vision. And soon, the Magi followed suit and replicated it with magyck, as is His vision."
	button_icon_state = "darkvision"
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Nox Oculus")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 1.5 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1

	point_cost = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/darkvision/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	H.visible_message("[H] mutters an incantation and a dim pulse of light radiates out from them.")
	for(var/mob/living/L in range(1, H))
		L.apply_status_effect(/datum/status_effect/buff/darkvision)

	return TRUE

/datum/action/cooldown/spell/darkvision/miracle
	button_icon_state = "darkvision"
	point_cost = 0
	spell_tier = 0
	associated_skill = /datum/skill/magic/holy
