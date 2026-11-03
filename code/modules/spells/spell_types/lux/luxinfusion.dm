/datum/action/cooldown/spell/luxinfusion
	name = "Infusion"
	desc = "Cannibalize your own lux to heal your wounds, and stem your own bleeding."
	button_icon = 'icons/mob/actions/engineer_skills.dmi'
	button_icon_state = "liver-lux"
	sound = 'sound/items/indexer_finished.ogg'

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_LUX
	primary_resource_cost = 2 //effective 15 minute cooldown after using this

	charge_required = FALSE
	cooldown_time = 5 MINUTES

	check_flags = AB_CHECK_CONSCIOUS
	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/luxinfusion/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!isliving(user) || !istype(user))
		return FALSE
	var/luxtype = user.get_lux_type()
	var/luxstring = "veins"
	if(HAS_TRAIT(user, TRAIT_IRONMAN))
		luxstring = "conduits"
	switch(luxtype)
		if("tainted")
			user.visible_message(span_warning("[user]'s [luxstring] pulse with putrescent, stinking fluid"))
		if("corrupted")
			user.visible_message(span_warning("[user]'s [luxstring] pulse with dimly glowing sludge."))
		if("infernal")
			user.visible_message(span_warning("[user]'s [luxstring] pulse with burning fire!"))
		if("impure")
			user.visible_message(span_warning("[user]'s [luxstring] pulse with glowing, impure lux!"))
		if("pure")
			user.visible_message(span_warning("[user]'s [luxstring] pulse with pure, brightly glowing lux!"))
	user.apply_status_effect(/datum/status_effect/buff/adrenaline_rush/lux)
	user.apply_status_effect(/datum/status_effect/buff/luxhealing)
	return TRUE
