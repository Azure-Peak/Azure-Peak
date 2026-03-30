/datum/action/cooldown/spell/featherfall
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	name = "Featherfall"
	desc = "Grant yourself and any creatures adjacent to you some defense against falls."
	fluff_desc = "Featherfall is a simple spell that creates a barrier of air around the target that slows their descent. Mages can't fly, but they certainly do fall. It is said it was invented by a clumsy mage who kept breaking their legs climbing up fruit trees, but this is likely a myth and no one know the true origin of this common spell."
	button_icon_state = "featherfall"
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("Lenis Cadere")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 2 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1

	point_cost = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/featherfall/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	H.visible_message("[H] mutters an incantation and a dim pulse of light radiates out from them.")
	for(var/mob/living/L in range(1, H))
		L.apply_status_effect(/datum/status_effect/buff/featherfall)

	return TRUE
