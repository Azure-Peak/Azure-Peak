/datum/action/cooldown/spell/touch/rune_ward
	button_icon = 'icons/mob/actions/mage_utilities.dmi'
	name = "Rune Ward"
	desc = "Channel arcyne energy through ash to inscribe protective runes upon the ground. The runes trigger when trespassers cross them - but can be circumvented by jumping or flying over them. Includes the following modes:\n \
	<b>Touch</b>: Draw a rune on the ground using ash from your off-hand. Choose from Stun, Fire, Chill, Damage, or Alarm types.\n \
	<b>Shove</b>: Scrub an existing rune from the ground. Skilled mages can do this silently.\n \
	<b>Use</b>: Memorize or forget allies - memorized people will not trigger your runes."

	button_icon_state = "rune_ward"

	draw_message = span_notice("I focus my arcyne power into my fingertips, ready to inscribe.")
	drop_message = span_notice("I release my arcyne focus.")

	hand_path = /obj/item/melee/new_touch_attack/rune_ward
	can_cast_on_self = TRUE
	infinite_use = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1
	requires_aspect_access = TRUE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	cooldown_time = 30 SECONDS

	var/list/allowed_names = list()
	var/list/obj/structure/rune_ward/active_runes = list()
	var/max_runes = 10

	var/draw_time = 4 SECONDS
	var/scrub_time_skilled = 3 SECONDS
	var/scrub_time_unskilled = 8 SECONDS

/datum/action/cooldown/spell/touch/rune_ward/Destroy()
	for(var/obj/structure/rune_ward/rune in active_runes)
		UnregisterSignal(rune, COMSIG_PARENT_QDELETING)
	active_runes.Cut()
	return ..()

/datum/action/cooldown/spell/touch/rune_ward/proc/on_rune_destroyed(obj/structure/rune_ward/source)
	SIGNAL_HANDLER
	active_runes -= source

/datum/action/cooldown/spell/touch/rune_ward/cast_on_hand_hit(obj/item/melee/new_touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	switch(caster.used_intent.type)
		if(INTENT_HELP)
			return draw_rune(hand, victim, caster)
		if(INTENT_DISARM)
			return scrub_rune(hand, victim, caster)
		if(/datum/intent/use)
			return memorize_allies(caster)
	return FALSE

/datum/action/cooldown/spell/touch/rune_ward/proc/draw_rune(obj/item/melee/new_touch_attack/hand, atom/victim, mob/living/carbon/caster)
	var/turf/target_turf = get_turf(victim)
	if(!target_turf)
		to_chat(caster, span_warning("There is nowhere to draw a rune here."))
		return FALSE

	if(!caster.Adjacent(target_turf))
		to_chat(caster, span_warning("I need to be adjacent to the surface."))
		return FALSE

	var/obj/item/ash/ash_item = locate(/obj/item/ash) in caster.held_items
	if(!ash_item)
		to_chat(caster, span_warning("I need ash in my other hand to draw a rune."))
		return FALSE

	var/list/choices = list()
	choices[RUNE_WARD_STUN] = image(icon = 'icons/roguetown/misc/rune_wards.dmi', icon_state = RUNE_WARD_ICON_STUN)
	choices[RUNE_WARD_FIRE] = image(icon = 'icons/roguetown/misc/rune_wards.dmi', icon_state = RUNE_WARD_ICON_FIRE)
	choices[RUNE_WARD_CHILL] = image(icon = 'icons/roguetown/misc/rune_wards.dmi', icon_state = RUNE_WARD_ICON_CHILL)
	choices[RUNE_WARD_DAMAGE] = image(icon = 'icons/roguetown/misc/rune_wards.dmi', icon_state = RUNE_WARD_ICON_DAMAGE)
	choices[RUNE_WARD_ALARM] = image(icon = 'icons/roguetown/misc/rune_wards.dmi', icon_state = RUNE_WARD_ICON_ALARM)

	var/choice = show_radial_menu(caster, caster, choices)
	if(!choice)
		return FALSE

	if(QDELETED(ash_item) || !(ash_item in caster.held_items))
		to_chat(caster, span_warning("I lost the ash."))
		return FALSE

	var/adjusted_time = draw_time
	var/skill_level = caster.get_skill_level(associated_skill)
	if(skill_level >= SKILL_LEVEL_EXPERT)
		adjusted_time *= 0.5
	else if(skill_level >= SKILL_LEVEL_JOURNEYMAN)
		adjusted_time *= 0.75

	caster.visible_message(span_notice("[caster] kneels and begins tracing symbols on the ground with ash."), span_notice("I begin inscribing a rune ward..."))
	if(!do_after(caster, adjusted_time, target = target_turf))
		to_chat(caster, span_warning("My concentration breaks."))
		return FALSE

	if(QDELETED(ash_item) || !(ash_item in caster.held_items))
		to_chat(caster, span_warning("I lost the ash."))
		return FALSE

	var/rune_path
	switch(choice)
		if(RUNE_WARD_STUN)
			rune_path = /obj/structure/rune_ward/stun
		if(RUNE_WARD_FIRE)
			rune_path = /obj/structure/rune_ward/fire
		if(RUNE_WARD_CHILL)
			rune_path = /obj/structure/rune_ward/chill
		if(RUNE_WARD_DAMAGE)
			rune_path = /obj/structure/rune_ward/damage
		if(RUNE_WARD_ALARM)
			rune_path = /obj/structure/rune_ward/alarm

	if(!rune_path)
		return FALSE

	qdel(ash_item)
	var/obj/structure/rune_ward/rune = new rune_path(target_turf)
	rune.owner_ref = WEAKREF(caster)
	rune.spell_ref = WEAKREF(src)
	rune.owner_name = caster.real_name
	rune.owner_ckey = caster.ckey || "no ckey"
	active_runes += rune
	RegisterSignal(rune, COMSIG_PARENT_QDELETING, PROC_REF(on_rune_destroyed))

	if(length(active_runes) > max_runes)
		var/obj/structure/rune_ward/oldest = active_runes[1]
		if(!QDELETED(oldest))
			oldest.visible_message(span_warning("The oldest rune fades as its creator inscribes a new one."))
			qdel(oldest)

	caster.visible_message(span_notice("[caster] finishes inscribing a rune on the ground."), span_notice("I finish the [choice] rune ward."))
	playsound(target_turf, 'sound/magic/whiteflame.ogg', 30, TRUE)

	var/fatigue = get_adjusted_cost(primary_resource_cost)
	caster.stamina_add(fatigue)
	StartCooldown()
	return FALSE

/datum/action/cooldown/spell/touch/rune_ward/proc/scrub_rune(obj/item/melee/new_touch_attack/hand, atom/victim, mob/living/carbon/caster)
	var/obj/structure/trap/target_trap
	if(istype(victim, /obj/structure/trap))
		target_trap = victim
	else
		var/turf/T = get_turf(victim)
		if(T)
			target_trap = locate(/obj/structure/rune_ward) in T

	if(!target_trap)
		to_chat(caster, span_warning("There is no rune or trap here to scrub."))
		return FALSE

	if(!caster.Adjacent(target_trap))
		to_chat(caster, span_warning("I need to be adjacent to scrub this."))
		return FALSE

	var/skill_level = caster.get_skill_level(associated_skill)
	var/skilled = skill_level >= SKILL_LEVEL_EXPERT

	if(skilled)
		caster.visible_message(span_notice("[caster] carefully passes a hand over the ground."), span_notice("I begin carefully unraveling the ward..."))
	else
		caster.visible_message(span_warning("[caster] begins scrubbing at something on the ground."), span_notice("I begin scrubbing at the ward..."))

	var/scrub_time = skilled ? scrub_time_skilled : scrub_time_unskilled

	if(!do_after(caster, scrub_time, target = target_trap))
		to_chat(caster, span_warning("My concentration breaks!"))
		if(!skilled && target_trap.armed)
			target_trap.trap_effect(caster)
		return FALSE

	if(QDELETED(target_trap))
		return FALSE

	if(skilled)
		to_chat(caster, span_notice("I silently erase the ward."))
	else
		caster.visible_message(span_notice("[caster] scrubs away a ward from the ground."), span_notice("I manage to scrub away the ward."))

	qdel(target_trap)
	return FALSE

/datum/action/cooldown/spell/touch/rune_ward/proc/memorize_allies(mob/living/carbon/caster)
	if(!caster.mind)
		to_chat(caster, span_warning("I can't focus my thoughts."))
		return FALSE

	var/list/known = caster.mind.known_people
	if(!length(known))
		to_chat(caster, span_warning("I don't know anyone to memorize."))
		return FALSE

	var/list/options = list()
	for(var/person_name in known)
		if(person_name in allowed_names)
			options["[person_name] (memorized)"] = person_name
		else
			options[person_name] = person_name

	var/choice = input(caster, "Choose a person to memorize or forget:", "Rune Ward - Memorize") as null|anything in options
	if(!choice)
		return FALSE

	var/real_name = options[choice]

	if(real_name in allowed_names)
		allowed_names -= real_name
		to_chat(caster, span_notice("I purge [real_name] from my ward memory. Future runes will not spare them."))
	else
		allowed_names += real_name
		to_chat(caster, span_notice("I commit [real_name] to my ward memory. Future runes will spare them."))

	return FALSE

// --- Touch Attack Item ---

/obj/item/melee/new_touch_attack/rune_ward
	name = "\improper inscribing hand"
	desc = "Arcyne energy crackles at your fingertips, ready to inscribe wards. Touch yourself to dismiss."
	possible_item_intents = list(INTENT_HELP, INTENT_DISARM, /datum/intent/use)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#FF8844"
	experimental_inhand = FALSE

/obj/item/melee/new_touch_attack/rune_ward/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	var/datum/action/cooldown/spell/touch/rune_ward/spell = spell_which_made_us?.resolve()
	if(spell)
		spell.cast_on_hand_hit(src, target, user)

