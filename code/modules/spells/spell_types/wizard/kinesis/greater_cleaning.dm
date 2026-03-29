/datum/action/cooldown/spell/greater_cleaning
	button_icon = 'icons/mob/actions/mage_kinesis.dmi'
	name = "Greater Cleaning"
	desc = "Unleash a wave of kinetic force that scours a nearby area clean of grime and debris."
	fluff_desc = "An advanced cantrip, a development from the original Lesser Cleaning - also known as Apprentice's Woe. \
	It scours and cleans a wide area. No one knows where the filth and grime really went - just that it must've gone somewhere. \
	Perhaps there's an elemental realm of rubbish where all casts of prestidigitation and greater cleaning send the filth to? \
	Mages reasoned that since elemental realms for first-order concepts like fire and water exist, and second-order concepts like daemons and fae exist, \
	then there might be a second or third-order realm of rubbish that such spells have been sending filth to. \
	Alas, there has not been conclusive proof for the existence of such realm. This mystery will remain unanswered." 
	button_icon_state = "greater_cleaning"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_KINESIS
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = 7

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Purga Omnia.")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	cooldown_time = 10 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/greater_cleaning/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE

	owner.visible_message(span_notice("[owner] gestures forcefully. A wave of arcyne force ripples outward, scouring the area clean."), span_notice("I unleash a wave of kinetic force, purging the area of filth."))

	var/washed = 0
	var/max_washes = 75
	for(var/turf/T in range(1, target_turf))
		if(washed >= max_washes)
			break
		new /obj/effect/temp_visual/cleaning_pulse(T)
		wash_atom(T, CLEAN_MEDIUM)
		washed++
		for(var/atom/A in T)
			if(washed >= max_washes)
				break
			if(istype(A, /obj/effect/decal/cleanable) || ismob(A) || (isobj(A) && !istype(A, /obj/effect)))
				wash_atom(A, CLEAN_MEDIUM)
				washed++

	return TRUE

/obj/effect/temp_visual/cleaning_pulse
	name = "cleaning pulse"
	icon = 'icons/effects/wizard_spell_effects.dmi'
	icon_state = "cleaning_pulse"
	duration = 8
	randomdir = 0
