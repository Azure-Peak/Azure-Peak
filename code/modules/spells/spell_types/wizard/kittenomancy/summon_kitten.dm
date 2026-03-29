/datum/action/cooldown/spell/summon_kitten
	button_icon = 'icons/mob/actions/mage_kittenomancy.dmi'
	name = "Summon Kitten"
	desc = "Summon a perfectly normal, non-explosive kitten. For companionship purposes only. Probably."
	button_icon_state = "summon_kitten"
	sound = 'sound/vo/mobs/cat/cat_purr1.ogg'
	spell_color = GLOW_COLOR_HEX
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Veni, Feles! Purrfect!")
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 3 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/summon_kitten/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/mob/living/simple_animal/pet/cat/kitten/K = new(get_turf(H))
	K.visible_message(span_notice("A kitten materializes out of thin air!"))
	playsound(get_turf(H), 'sound/vo/mobs/cat/cat_meow1.ogg', 60, TRUE)
	return TRUE
