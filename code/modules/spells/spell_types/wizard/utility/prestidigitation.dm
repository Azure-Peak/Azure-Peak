#define PRESTI_CLEAN "presti_clean"
#define PRESTI_SPARK "presti_spark"
#define PRESTI_MOTE "presti_mote"
#define PRESTI_SENSE "presti_sense"

/obj/effect/proc_holder/spell/targeted/touch/prestidigitation
	name = "Prestidigitation"
	desc = "A few basic tricks many apprentices use to practice basic manipulation of the arcyne."
	clothes_req = FALSE
	drawmessage = "I prepare to perform a minor arcyne incantation."
	dropmessage = "I release my minor arcyne focus."
	school = "transmutation"
	overlay_state = "prestidigitation"
	chargedrain = 0
	chargetime = 0
	skipcharge = TRUE
	releasedrain = 5 // this influences -every- cost involved in the spell's functionality, if you want to edit specific features, do so in handle_cost
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/prestidigitation

/obj/item/melee/touch_attack/prestidigitation
	name = "\improper prestidigitating touch"
	desc = "You recall the following incantations you've learned:\n \
	<b>Touch</b>: Use your arcyne powers to scrub an object or something clean, like using soap. Also known as the Apprentice's Woe.\n \
	<b>Shove</b>: Will forth a spark on an item of your choosing (or in front of you, if used on the ground) to ignite flammable items and things like torches, lanterns or campfires. \n \
	<b>Use</b>: Conjure forth an orbiting mote of magelight to light your way.\n \
	<b>Grab</b>: Attune to the veil and sense nearby leylines."
	catchphrase = null
	possible_item_intents = list(INTENT_HELP, INTENT_DISARM, /datum/intent/use, INTENT_GRAB)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#3FBAFD" // this produces green because the icon base is yellow but someone else can fix that if they want
	var/obj/effect/wisp/prestidigitation/mote
	var/cleanspeed = 35 // adjust this down as low as 15 depending on magic skill
	var/motespeed = 20 // mote summoning speed
	var/sparkspeed = 30 // spark summoning speed
	var/spark_cd = 0
	experimental_inhand = FALSE

/obj/item/melee/touch_attack/prestidigitation/Initialize()
	. = ..()
	mote = new(src)

/obj/item/melee/touch_attack/prestidigitation/Destroy()
	if(mote)
		QDEL_NULL(mote)
	return ..()

/obj/item/melee/touch_attack/prestidigitation/attack_self()
	qdel(src)

/obj/item/melee/touch_attack/prestidigitation/proc/sense_leylines(mob/living/carbon/human/user)
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

	// Sort by distance (simple insertion sort, small list)
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
			to_chat(user, span_info("[colored_type] leyline — right beside you[status]."))
		else if(dist <= 30)
			to_chat(user, span_info("[colored_type] leyline — [direction], not far[status]."))
		else if(dist <= 100)
			to_chat(user, span_info("[colored_type] presence — [direction], some distance away[status]."))
		else
			to_chat(user, span_info("[colored_type] whisper — [direction], far away[status]."))
		count++

	if(!count)
		to_chat(user, span_warning("You sense nothing. Strange."))
	else
		var/charges = get_leyline_charges(user)
		to_chat(user, span_info("You have enough mana for <b>[charges]</b> more ritual[charges != 1 ? "s" : ""]."))
	return TRUE

/obj/item/melee/touch_attack/prestidigitation/afterattack(atom/target, mob/living/carbon/user, proximity)
	switch (user.used_intent.type)
		if (INTENT_HELP) // Clean something like a bar of soap
			if(clean_thing(target, user))
				handle_cost(user, PRESTI_CLEAN)
		if (INTENT_DISARM) // Snap your fingers and produce a spark
			if(create_spark(user, target))
				handle_cost(user, PRESTI_SPARK)
		if (/datum/intent/use) // Summon an orbiting arcane mote for light
			if(handle_mote(user))
				handle_cost(user, PRESTI_MOTE)
		if (INTENT_GRAB) // Sense nearby leylines
			if(sense_leylines(user))
				handle_cost(user, PRESTI_SENSE)

/obj/item/melee/touch_attack/prestidigitation/proc/handle_cost(mob/living/carbon/human/user, action)
	// handles fatigue/stamina deduction, this stuff isn't free - also returns the cost we took to use for xp calculations
	var/obj/effect/proc_holder/spell/targeted/touch/prestidigitation/base_spell = attached_spell
	var/fatigue_used = base_spell.get_fatigue_drain() //note that as our skills/stats increases, our fatigue drain DECREASES, so this means less xp, too. which is what we want since this is a basic spell, not a spam-for-xp-forever kinda beat
	var/extra_fatigue = 0 // extra fatigue isn't considered in xp calculation
	switch (action)
		if (PRESTI_CLEAN)
			fatigue_used *= 0.2 // going to be spamming a lot of this probably
		if (PRESTI_SPARK)
			extra_fatigue = 5 // just a bit of extra fatigue on this one
		if (PRESTI_MOTE)
			extra_fatigue = 15 // same deal here
		if (PRESTI_SENSE)
			extra_fatigue = 10

	user.stamina_add(fatigue_used + extra_fatigue)

	var/skill_level = user.get_skill_level(attached_spell.associated_skill)
	if (skill_level >= SKILL_LEVEL_EXPERT)
		fatigue_used = 0 // we do this after we've actually changed fatigue because we're hard-capping the raises this gives to Expert

	return fatigue_used

/obj/item/melee/touch_attack/prestidigitation/proc/handle_mote(mob/living/carbon/human/user)
	// adjusted from /obj/item/wisp_lantern & /obj/item/wisp
	if (!mote)
		return // should really never happen

	//let's adjust the light power based on our skill, too
	var/skill_level = user.get_skill_level(attached_spell.associated_skill)
	var/mote_power = clamp(5 + (skill_level - 3), 5, 7) // every step above journeyman should get us 1 more tile of brightness
	mote.set_light_range(mote_power)
	if(mote.light_system == STATIC_LIGHT)
		mote.update_light()

	if (mote.loc == src)
		user.visible_message(span_notice("[user] holds open the palm of [user.p_their()] hand and concentrates..."), span_notice("I hold open the palm of my hand and concentrate on my arcyne power..."))
		if (do_after(user, src.motespeed, target = user))
			mote.orbit(user, 1, TRUE, 0, 48, TRUE)
			return TRUE
		return FALSE
	else
		user.visible_message(span_notice("[user] wills \the [mote.name] back into [user.p_their()] hand and closes it, extinguishing its light."), span_notice("I will \the [mote.name] back into my palm and close it."))
		mote.forceMove(src)
		return TRUE

/obj/item/melee/touch_attack/prestidigitation/proc/create_spark(mob/living/carbon/human/user, atom/thing)
	// adjusted from /obj/item/flint
	if (world.time < spark_cd + sparkspeed)
		return FALSE
	spark_cd = world.time

	playsound(user, 'sound/foley/finger-snap.ogg', 100, FALSE)
	user.flash_fullscreen("whiteflash")
	flick("flintstrike", src)

	if (isturf(thing) || !user.Adjacent(thing))
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_step(user, user.dir)
		S.set_up(1, 1, front)
		S.start()
		user.visible_message(span_notice("[user] snaps [user.p_their()] fingers, producing a spark!"), span_notice("I will forth a tiny spark with a snap of my fingers."))
	else
		thing.spark_act()
		user.visible_message(span_notice("[user] snaps [user.p_their()] fingers, and a spark leaps forth towards [thing]!"), span_notice("I will forth a tiny spark and direct it towards [thing]."))

	return TRUE

/obj/item/melee/touch_attack/prestidigitation/proc/clean_thing(atom/target, mob/living/carbon/human/user)
	// adjusted from /obj/item/soap in clown_items.dm, some duplication unfortunately (needed for flavor)

	// let's adjust the clean speed based on our skill level
	var/skill_level = user.get_skill_level(attached_spell.associated_skill)
	cleanspeed = initial(cleanspeed) - (skill_level * 3) // 3 cleanspeed per skill level, from 35 down to a maximum of 17 (pretty quick)

	if (istype(target, /obj/structure/roguewindow))
		user.visible_message(span_notice("[user] gestures at \the [target.name]. Tiny motes of arcyne power dance across its surface..."), span_notice("I begin to clean \the [target.name] with my arcyne power..."))
		if (do_after(user, src.cleanspeed, target = target))
			wash_atom(target,CLEAN_MEDIUM)
			to_chat(user, span_notice("I render \the [target.name] clean."))
			return TRUE
		return FALSE
	else if (istype(target, /obj/effect/decal/cleanable))
		user.visible_message(span_notice("[user] gestures at \the [target.name]. Arcyne power slowly scours it away..."), span_notice("I begin to scour \the [target.name] away with my arcyne power..."))
		if (do_after(user, src.cleanspeed, target = target))
			wash_atom(get_turf(target),CLEAN_MEDIUM)
			to_chat(user, span_notice("I expunge \the [target.name] with my mana."))
			return TRUE
		return FALSE
	else
		user.visible_message(span_notice("[user] gestures at \the [target.name]. Tiny motes of arcyne power surge over [target.p_them()]..."), span_notice("I begin to clean \the [target.name] with my arcyne power..."))
		if (do_after(user, src.cleanspeed, target = target))
			wash_atom(target,CLEAN_MEDIUM)
			to_chat(user, span_notice("I render \the [target.name] clean."))
			return TRUE
		return FALSE

// Intents for prestidigitation

/obj/effect/wisp/prestidigitation
	name = "minor magelight mote"
	desc = "A tiny display of arcyne power used to illuminate."
	pixel_x = 20
	light_outer_range =  4
	light_color = "#3FBAFD"

	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "wisp"

#undef PRESTI_CLEAN
#undef PRESTI_SPARK
#undef PRESTI_MOTE
#undef PRESTI_SENSE
