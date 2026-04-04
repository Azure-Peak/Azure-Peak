#define PRESTI_CLEAN "presti_clean"
#define PRESTI_SPARK "presti_spark"
#define PRESTI_MOTE "presti_mote"
#define PRESTI_SENSE "presti_sense"

/datum/action/cooldown/spell/touch/prestidigitation
	name = "Prestidigitation"
	desc = "A few basic tricks many apprentices use to practice basic manipulation of the arcyne. Except for light, cooldown is decreased by 10% per point of Int above 10 up to 50%. Includes the following modes:\n \
	<b>Touch</b>: Use your arcyne powers to scrub an object or something clean, like using soap. Also known as the Apprentice's Woe.\n \
	<b>Shove</b>: Will forth a spark on an item of your choosing (or in front of you, if used on the ground) to ignite flammable items and things like torches, lanterns or campfires. \n \
	<b>Use</b>: Conjure forth an orbiting mote of magelight to light your way. Starts at 5 tiles light range and get one more per Int above 10 up to 15.\n \
	<b>Grab</b>: Attune to the veil and sense nearby leylines. "
	button_icon_state = "prestidigitation"

	draw_message = span_notice("I prepare to perform a minor arcyne incantation.")
	drop_message = span_notice("I release my minor arcyne focus.")

	hand_path = /obj/item/melee/new_touch_attack/prestidigitation
	can_cast_on_self = TRUE
	infinite_use = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 0

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/touch/prestidigitation/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	var/obj/item/melee/new_touch_attack/prestidigitation/presti_hand = hand
	if(!istype(presti_hand))
		return FALSE

	switch(caster.used_intent.type)
		if(INTENT_HELP)
			if(presti_hand.clean_thing(victim, caster))
				handle_presti_cost(caster, PRESTI_CLEAN)
		if(INTENT_DISARM)
			if(presti_hand.create_spark(caster, victim))
				handle_presti_cost(caster, PRESTI_SPARK)
		if(/datum/intent/use)
			if(presti_hand.handle_mote(caster))
				handle_presti_cost(caster, PRESTI_MOTE)
		if(INTENT_GRAB)
			if(presti_hand.sense_leylines(caster))
				handle_presti_cost(caster, PRESTI_SENSE)

	return FALSE // don't consume the hand

/datum/action/cooldown/spell/touch/prestidigitation/proc/handle_presti_cost(mob/living/carbon/human/user, action)
	var/fatigue_used = get_adjusted_cost(primary_resource_cost)
	var/extra_fatigue = 0
	switch(action)
		if(PRESTI_CLEAN)
			fatigue_used *= 0.2
		if(PRESTI_SPARK)
			extra_fatigue = 5
		if(PRESTI_MOTE)
			extra_fatigue = 15
		if(PRESTI_SENSE)
			extra_fatigue = 10

	user.stamina_add(fatigue_used + extra_fatigue)

	var/skill_level = user.get_skill_level(associated_skill)
	if(skill_level >= SKILL_LEVEL_EXPERT)
		fatigue_used = 0

	return fatigue_used

/obj/item/melee/new_touch_attack/prestidigitation
	name = "\improper prestidigitating touch"
	possible_item_intents = list(INTENT_HELP, INTENT_DISARM, /datum/intent/use, INTENT_GRAB)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#3FBAFD"
	var/obj/effect/wisp/prestidigitation/mote
	var/cleanspeed = 35
	var/motespeed = 20
	var/sparkspeed = 30
	var/spark_cd = 0
	var/cast_range = 7
	experimental_inhand = FALSE

/obj/item/melee/new_touch_attack/prestidigitation/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity && get_dist(user, target) > cast_range)
		return
	var/datum/action/cooldown/spell/touch/prestidigitation/spell = spell_which_made_us?.resolve()
	if(spell)
		spell.cast_on_hand_hit(src, target, user)

/obj/item/melee/new_touch_attack/prestidigitation/proc/get_int_speed_mult(mob/living/user)
	var/int_above = max(user.STAINT - 10, 0)
	return clamp(1 - (int_above * 0.1), 0.5, 1)

/obj/item/melee/new_touch_attack/prestidigitation/Initialize(mapload, datum/action/cooldown/spell/spell)
	. = ..()
	mote = new(src)

/obj/item/melee/new_touch_attack/prestidigitation/Destroy()
	QDEL_NULL(mote)
	return ..()

/obj/item/melee/new_touch_attack/prestidigitation/proc/sense_leylines(mob/living/carbon/human/user)
	if(!length(GLOB.leyline_sites))
		to_chat(user, span_warning("You reach out through the veil but sense nothing. No leylines exist in this world."))
		return FALSE

	user.visible_message(span_notice("[user] closes [user.p_their()] eyes and reaches out through the veil..."), span_notice("I close my eyes and attune to the flow of the veil..."))
	if(!do_after(user, 2 SECONDS, target = user))
		to_chat(user, span_warning("Your concentration breaks."))
		return FALSE

	var/list/sensed = list()
	var/user_z = user.z
	for(var/obj/structure/leyline/L in GLOB.leyline_sites)
		var/dist = get_dist(user, L)
		sensed += list(list("leyline" = L, "dist" = dist, "same_z" = (L.z == user_z)))

	for(var/i in 2 to length(sensed))
		var/j = i
		while(j > 1 && sensed[j]["dist"] < sensed[j - 1]["dist"])
			sensed.Swap(j, j - 1)
			j--

	to_chat(user, span_info("You attune to the veil and sense the flow of leyline energy..."))
	var/count = 0
	for(var/entry in sensed)
		if(count >= 5)
			break
		var/obj/structure/leyline/L = entry["leyline"]
		var/dist = entry["dist"]
		var/same_z = entry["same_z"]
		var/direction = dir2text(get_dir(user, L))
		if(!direction)
			direction = "beneath you"
		else
			direction = "to the [direction]"
		if(!same_z)
			if(L.z > user_z)
				direction += ", above you"
			else
				direction += ", below you"

		var/status = ""
		L.check_daily_reset()
		if(!L.has_uses_remaining())
			status = " <span style='color:#888'>(exhausted)</span>"

		var/flavor = L.alignment
		var/flavor_color = "#FFFFFF"
		switch(L.alignment)
			if("infernal")
				flavor = "Scorched"
				flavor_color = "#EF5350"
			if("fae")
				flavor = "Sylvan"
				flavor_color = "#81C784"
			if("elemental")
				flavor = "Earthen"
				flavor_color = "#D4A04A"
			if("void")
				flavor = "Unstable"
				flavor_color = "#AB47BC"
			if("neutral")
				flavor = "Tamed"
				flavor_color = "#C0C0FF"

		var/colored_type = "<b><span style='color:[flavor_color]'>[flavor]</span></b>"
		if(dist <= 3)
			to_chat(user, span_info("[colored_type] leyline - right beside you[status]."))
		else if(dist <= 30)
			to_chat(user, span_info("[colored_type] leyline - [direction], not far[status]."))
		else if(dist <= 100)
			to_chat(user, span_info("[colored_type] presence - [direction], some distance away[status]."))
		else
			to_chat(user, span_info("[colored_type] whisper - [direction], far away[status]."))
		count++

	if(!count)
		to_chat(user, span_warning("You sense nothing. Strange."))
	else
		var/charges = get_leyline_charges(user)
		to_chat(user, span_info("You have enough mana for <b>[charges]</b> more ritual[charges != 1 ? "s" : ""]."))
	return TRUE

/obj/item/melee/new_touch_attack/prestidigitation/proc/handle_mote(mob/living/carbon/human/user)
	if(!mote)
		return

	var/int_bonus = max(user.STAINT - 10, 0)
	var/mote_power = 5 + FLOOR(int_bonus * 0.3, 1)
	mote.set_light_range(mote_power)
	if(mote.light_system == STATIC_LIGHT)
		mote.update_light()

	if(mote.loc == src)
		user.visible_message(span_notice("[user] holds open the palm of [user.p_their()] hand and concentrates..."), span_notice("I hold open the palm of my hand and concentrate on my arcyne power..."))
		if(do_after(user, initial(motespeed) * get_int_speed_mult(user), target = user))
			mote.orbit(user, 1, TRUE, 0, 48, TRUE)
			return TRUE
		return FALSE
	else
		user.visible_message(span_notice("[user] wills \the [mote.name] back into [user.p_their()] hand and closes it, extinguishing its light."), span_notice("I will \the [mote.name] back into my palm and close it."))
		mote.forceMove(src)
		return TRUE

/obj/item/melee/new_touch_attack/prestidigitation/proc/create_spark(mob/living/carbon/human/user, atom/thing)
	var/actual_sparkspeed = initial(sparkspeed) * get_int_speed_mult(user)
	if(world.time < spark_cd + actual_sparkspeed)
		return FALSE
	spark_cd = world.time

	playsound(user, 'sound/foley/finger-snap.ogg', 100, FALSE)
	user.flash_fullscreen("whiteflash")
	flick("flintstrike", src)

	if(isturf(thing) || !user.Adjacent(thing))
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_step(user, user.dir)
		S.set_up(1, 1, front)
		S.start()
		user.visible_message(span_notice("[user] snaps [user.p_their()] fingers, producing a spark!"), span_notice("I will forth a tiny spark with a snap of my fingers."))
	else
		thing.spark_act()
		user.visible_message(span_notice("[user] snaps [user.p_their()] fingers, and a spark leaps forth towards [thing]!"), span_notice("I will forth a tiny spark and direct it towards [thing]."))

	return TRUE

/obj/item/melee/new_touch_attack/prestidigitation/proc/clean_thing(atom/target, mob/living/carbon/human/user)
	cleanspeed = initial(cleanspeed) * get_int_speed_mult(user)

	if(istype(target, /obj/effect/decal/cleanable))
		user.visible_message(span_notice("[user] gestures at \the [target.name]. Arcyne power slowly scours it away..."), span_notice("I begin to scour \the [target.name] away with my arcyne power..."))
		if(do_after(user, src.cleanspeed, target = target))
			var/turf/T = get_turf(target)
			new /obj/effect/temp_visual/cleaning_pulse(T)
			for(var/obj/effect/decal/cleanable/C in T)
				wash_atom(C, CLEAN_MEDIUM)
			wash_atom(T, CLEAN_MEDIUM)
			to_chat(user, span_notice("I expunge \the [target.name] with my mana."))
			return TRUE
		return FALSE
	else
		var/clean_name = isturf(target) ? "the ground" : "\the [target.name]"
		user.visible_message(span_notice("[user] gestures at [clean_name]. Tiny motes of arcyne power surge over it..."), span_notice("I begin to clean [clean_name] with my arcyne power..."))
		if(do_after(user, src.cleanspeed, target = target))
			var/turf/T = get_turf(target)
			new /obj/effect/temp_visual/cleaning_pulse(T)
			wash_atom(target, CLEAN_MEDIUM)
			for(var/obj/effect/decal/cleanable/C in T)
				wash_atom(C, CLEAN_MEDIUM)
			to_chat(user, span_notice("I render [clean_name] clean."))
			return TRUE
		return FALSE

/obj/effect/wisp/prestidigitation
	name = "minor magelight mote"
	desc = "A tiny display of arcyne power used to illuminate."
	pixel_x = 20
	light_outer_range =  5
	light_color = "#3FBAFD"

	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "wisp"

#undef PRESTI_CLEAN
#undef PRESTI_SPARK
#undef PRESTI_MOTE
#undef PRESTI_SENSE
