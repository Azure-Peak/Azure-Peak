// Plunge your hand into someone's ribs to rip out their impure lux for your diabolical uses

/datum/action/cooldown/spell/lacrima
	name = "Lacrima"
	desc = "Requires an aggressive grab on a floored, living victim. Plunge your hand into their chest, shattering their ribs and will alike to forcefully tear the lux from their body."
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "zizograsp"
	charge_required = FALSE
	click_to_activate = FALSE
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 100
	associated_skill = /datum/skill/magic/holy
	associated_stat = null
	invocation_type = INVOCATION_SHOUT
	invocations = list("Give your lux for the Dame!")
	zizo_spell = TRUE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/lacrima/free
	primary_resource_type = SPELL_COST_NONE
	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = 100

/datum/action/cooldown/spell/lacrima/cast(atom/cast_on)
	. = ..()
	if(!ishuman(owner))
		return FALSE

	if(owner.pulling && ishuman(owner.pulling) && owner.grab_state >= GRAB_AGGRESSIVE)
		lux_rip(owner.pulling, owner)
		return TRUE

	to_chat(owner, span_warning("I need an aggressive grab on a floored victim to use Lacrima!"))
	reset_spell_cooldown()
	return FALSE

/datum/action/cooldown/spell/lacrima/proc/lux_rip(mob/living/carbon/human/target, mob/living/carbon/human/user)
	var/break_time = 100
	var/tear_time = 100

	if(target == user)
		to_chat(user, span_alert("I shouldn't rip out my own lux! I need that."))
		return
	if(!target.mind)
		to_chat(user, span_info("This one's lux is weak and insufficient. I need a victim with higher consciousness!"))
		return
	if(!isliving(target))
		to_chat(user, span_info("Only lyving creachers may have their lux torn."))
		return
	if(!target.Adjacent(user))
		to_chat(user, span_info("I need to be next to [target] to rip out their lux."))
		return
	if((target.mobility_flags & MOBILITY_STAND))
		to_chat(user, span_info("My target must be lying down to have their lux torn."))
		return
	if(target.has_status_effect(/datum/status_effect/debuff/devitalised) || target.mob_biotypes & MOB_UNDEAD)
		to_chat(user, span_notice("This one's lux is already disturbed!"))
		return
	else
		user.visible_message(span_alert("[user] reaches towards [target]'s chest, inhumen flames wreathing [user.p_their()] hand..."))
	var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
	if(!chest.has_wound(/datum/wound/fracture/chest))
		if(!do_after(user, break_time, target = target))
			return
		if(chest)
			if(!HAS_TRAIT(target, TRAIT_NOPAIN))
				target.emote("painscream")
			chest.add_wound(/datum/wound/fracture/chest)
			target.apply_damage(50, BRUTE, BODY_ZONE_CHEST)
			user.visible_message(span_alert("[user] plunges their fist into [target]'s ribcage, shattering it spectacularly!"))
	if(!do_after(user, tear_time, target = target) && chest.has_wound(/datum/wound/fracture/chest))
		return
	if(!HAS_TRAIT(target, TRAIT_NOPAIN))
		target.emote("painscream")
		target.add_stress(/datum/stressevent/myfuckingluxman)
	playsound(user, 'sound/items/blackmirror_needle.ogg', 60, FALSE, 3)
	user.visible_message(span_alert("[user] tears a glob of lux from [target]'s chest!"))
	new /obj/item/reagent_containers/lux_impure(target.loc)
	SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, target)
	record_featured_stat(FEATURED_STATS_CRIMINALS, user)
	record_round_statistic(STATS_LUX_HARVESTED)
	target.apply_status_effect(/datum/status_effect/debuff/devitalised)

/datum/stressevent/myfuckingluxman
	desc = span_boldred("THE ESSENCE OF MY LYFE HAS BEEN DEFILED!!")
	stressadd = 30
	timer = 5 MINUTES
