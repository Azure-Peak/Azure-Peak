/obj/effect/proc_holder/spell/invoked/mending
	name = "Mending"
	desc = "Uses arcyne energy to mend an item. Effect of repair scales off of your Intelligence."
	overlay_state = "mending"
	releasedrain = 50
	chargetime = 5
	recharge_time = 20 SECONDS
	warnie = "spellwarning"
	movement_interrupt = FALSE
	no_early_release = FALSE
	chargedloop = null
	sound = 'sound/magic/whiteflame.ogg'
	cost = 2
	spell_tier = 1 // Utility. For repair
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	miracle = FALSE

	invocations = list("Reficio")
	invocation_type = "shout" //can be none, whisper, emote and shout

	var/repair_percent = 0.20
	var/int_bonus = 0.00

/obj/effect/proc_holder/spell/invoked/mending/cast(list/targets, mob/living/user)
	if(!istype(targets[1], /obj/item))
		to_chat(user, span_warning("There is no item here!"))
		revert_cast()
		return

	var/obj/item/I = targets[1]

	if(!I.anvilrepair && !I.sewrepair)
		to_chat(user, span_warning("Not even magic can mend this item!"))
		revert_cast()
		return
	if(I.obj_integrity >= I.max_integrity && I.body_parts_covered_dynamic == I.body_parts_covered && !I.peel_count)
		to_chat(user, span_info("[I] appears to be in perfect condition."))
		revert_cast()
		return

	user.visible_message(
		span_warning("[user] begins to concentrate on [I]!"),
		span_notice("I begin to concentrate on [I]..")
	)
	if(!do_after(user, 4 SECONDS, TRUE, I, TRUE))
		to_chat(user, span_warning("My concentration breaks! I could not repair [I]."))
		revert_cast()
		return

	repair_percent = initial(repair_percent)
	int_bonus = CLAMP((user.STAINT * 0.01), 0.01, 0.9)
	repair_percent += int_bonus
	repair_percent *= I.max_integrity

	I.obj_integrity = min(I.obj_integrity + repair_percent, I.max_integrity)
	user.visible_message(span_info("[I] glows in a faint mending light."))
	playsound(I, 'sound/foley/sewflesh.ogg', 50, TRUE, -2)

	if(I.obj_integrity >= I.max_integrity)
		if(I.obj_broken)
			I.obj_fix()
		if(I.peel_count)
			I.peel_count--
			to_chat(user, span_info("[I]'s shorn layers mend together. ([I.peel_count])."))
		else
			if(I.body_parts_covered_dynamic != I.body_parts_covered)
				I.repair_coverage()
				to_chat(user, span_info("[I]'s shorn layers mend together, completely."))


/obj/effect/proc_holder/spell/invoked/mending/lesser
	name = "Lesser Mending"
	repair_percent = 0.10
	recharge_time = 30 SECONDS
	cost = 1
