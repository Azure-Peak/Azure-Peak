/////////////////////////////////////////Scrying///////////////////

/obj/item/scrying
	name = "scrying orb"
	desc = "Within its glass depths, you can scry on many beings..."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state ="scrying"
	throw_speed = 3
	throw_range = 7
	throwforce = 15
	damtype = BURN
	force = 15
	hitsound = 'sound/blank.ogg'
	sellprice = 30
	dropshrink = 0.6
	resistance_flags = FIRE_PROOF

	grid_height = 32
	grid_width = 32

	var/mob/current_owner
	var/last_scry
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 30 SECONDS
	var/extended_cooldown = 10 MINUTES
	var/on_extended_cooldown = FALSE

	var/debugseverity = FALSE
	var/debugprob = 0

/obj/item/scrying/examine(mob/user)
	. = ..()
	if(on_cooldown())
		. += "The orb requires rest..."
	else
		. += "The orb seems eager to be used!"

/obj/item/scrying/proc/on_cooldown()
	if (world.time < last_scry + (on_extended_cooldown ? extended_cooldown : cooldown))
		return TRUE
	// No longer on cooldown, so reset the extended cooldown flag if it was set
	on_extended_cooldown = FALSE
	return FALSE

/obj/item/scrying/attack_self(mob/living/user)
	. = ..()
	if(!user.mind)
		return
	if(world.time < last_scry + 30 SECONDS)
		to_chat(user, span_warning("I look into the ball but only see inky smoke. Maybe I should wait."))
		return
	var/input = input(user, "Who are you looking for?", "Scrying Orb")
	if(!input)
		return
	if(!user.key)
		return
	if(!user.mind || !user.mind.do_i_know(name=input))
		to_chat(user, span_warning("I don't know anyone by that name."))
		return
	var/arcane_skill = user.get_skill_level(/datum/skill/magic/arcane)
	if(on_cooldown())
		if (on_extended_cooldown)
			to_chat(user, span_warning("I've pushed the orb far enough already - this is risky..."))
		else
			to_chat(user, span_warning("The orb doesn't seem ready. Maybe I should wait..."))

	var/time_to_use
	if(arcane_skill >= 1)
		time_to_use = 60 / arcane_skill
	else
		time_to_use = 100

	if(!do_after(user, time_to_use, target = user))
		to_chat(user, span_warning("I need to focus..."))
		return
	
	var/success_chance = 0

	var/break_on_fail = FALSE
	var/failure_severity = 6 - arcane_skill

	// Max severity: 6 (no arcane) + 6 (1 intelligence) + 4 (on cooldown) = 16
	// For an Apprentice using the orb, 3-7 would be the realistic results, depending on whether the orb is on cooldown.
	// Max severity with a unique effect: 10

	// Users too unintelligent to read a mage's tome get worse failures,
	// but not worse success chance
	if (user.STAINT < 12)
		failure_severity += max((6 - (user.STAINT/2)), 1)

	var/on_cooldown = world.time < last_scry + cooldown

	if(on_cooldown)
		// Failure severity is increased, and chance of success is reduced by one proficiency level
		// if the orb is on cooldown
		failure_severity += rand(1, 4)
		switch(arcane_skill)
			if(SKILL_LEVEL_NONE)
				break_on_fail = TRUE
				success_chance = 20
			if(SKILL_LEVEL_NOVICE)
				break_on_fail = TRUE
				success_chance = 50
			if(SKILL_LEVEL_APPRENTICE)
				success_chance = 65
			if(SKILL_LEVEL_JOURNEYMAN)
				success_chance = 80
			if(SKILL_LEVEL_EXPERT)
				success_chance = 90
			if(SKILL_LEVEL_MASTER)
				success_chance = 95
			if(SKILL_LEVEL_LEGENDARY)
				success_chance = 100
	// Only a true master of the arcane can reliably use the orb when it's REALLY been pushed
		if (on_extended_cooldown && arcane_skill < SKILL_LEVEL_LEGENDARY)
			success_chance /= 2
	else
		switch(arcane_skill)
			if(SKILL_LEVEL_NONE)
				break_on_fail = TRUE
				success_chance = 50
			if(SKILL_LEVEL_NOVICE)
				break_on_fail = TRUE
				success_chance = 65
			if(SKILL_LEVEL_APPRENTICE) //Apprentices have this
				success_chance = 80
			if(SKILL_LEVEL_JOURNEYMAN) // refugee mages have this
				success_chance = 90
			if(SKILL_LEVEL_EXPERT)
				success_chance = 94
			if(SKILL_LEVEL_MASTER to SKILL_LEVEL_LEGENDARY) // Magus has this
				success_chance = 100

	if (debugseverity)
		success_chance = 0

	var/lucky_prob = user.get_scaled_sq_luck(1, 50)
	if (prob(lucky_prob))
		break_on_fail = FALSE
		failure_severity -= rand(1, 3)

	var/mob/living/carbon/human/target = get_named_mob(input)
	if (target == null)
		return

	if(!prob(success_chance))
		on_failure(user, target, failure_severity)
		if(break_on_fail)
			failure_break(user)
		return
	
	playsound(src, 'sound/magic/whiteflame.ogg', 100, TRUE)
	scry(user, target)

	to_chat(user, span_warning("I peer into the ball, but can't find [input]."))
	return

/obj/item/scrying/proc/get_named_mob(mob_real_name)
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if (HL.real_name == mob_real_name)
			return HL
	return null

/obj/item/scrying/proc/scry_wrong_person(mob/living/carbon/human/user, mob/living/carbon/human/target)
	// We take the mobname so we know NOT to scry them
	var/len = length(GLOB.human_list)
	var/index = rand(1, len)
	var/mob/living/carbon/human/HL = GLOB.human_list[index]

	// If we get the desired target, add a random value to the index
	// Taking an upper limit of (len-1) should mean that we never roll the desired mob again
	if (HL.real_name == target.real_name)
		index = (index + rand(1, len-1)) % len
		HL = GLOB.human_list[index]

	scry(user, HL)

/obj/item/scrying/proc/scry(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/turf/T = get_turf(target)
	if(!T)
		return
	message_admins("SCRYING: [user.real_name] ([user.ckey]) has used the scrying orb to leer at [target.real_name] ([target.ckey])")
	log_game("SCRYING: [user.real_name] ([user.ckey]) has used the scrying orb to leer at [target.real_name] ([target.ckey])")
	var/mob/dead/observer/screye/S = user.scry_ghost()
	if(!S)
		return
	S.ManualFollow(target)
	last_scry = world.time
	user.visible_message(span_danger("[user] stares into [src], [user.p_their()] eyes rolling back into [user.p_their()] head."))
	addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), 8 SECONDS)
	if(!target.stat)
		if(target.STAPER >= 15)
			if(target.mind)
				if(target.mind.do_i_know(name=user.real_name))
					to_chat(target, span_warning("I can clearly see the face of [user.real_name] staring at me!."))
					return
				to_chat(target, span_warning("I can clearly see the face of an unknown [user.gender == FEMALE ? "woman" : "man"] staring at me!"))
				return

		if(target.STAPER >= 11)
			to_chat(target, span_warning("I feel a pair of unknown eyes on me."))
	return

/obj/item/scrying/proc/failure_break(mob/living/user)
	visible_message("\The [src] shatters!")
	user.flash_fullscreen("redflash1")
	new /obj/item/magic/obsidian(get_turf(src))
	playsound(src, "shatter", 70, TRUE)
	qdel(src)

/obj/item/scrying/proc/on_failure(mob/living/user, mob/living/carbon/human/target, severity)
	var/chance = rand(0, 99) // (chance < n) has n% probability, but we only need to calculate once here

	if (debugseverity)
		severity = debugseverity
		chance = debugprob

	if (on_cooldown())
		extended_cooldown = TRUE
		last_scry = world.time

	switch (severity)
		if (0)
			to_chat(user, span_boldwarning("You focus your thoughts on the orb, but it doesn't respond."))
		if (1)
			if (chance < 40)
				failure_random_person(user, target)
			else if (chance < 70)
				failure_burn(user)
			else
				failure_confused(user)
		if (2)
			if (chance < 20)
				failure_confused(user)
			else if (chance < 80)
				failure_sleep(user)
			else
				failure_drunk(user)
		if (3)
			if (chance < 20)
				failure_sleep(user)
			else if (chance < 80)
				failure_drunk(user)
			else
				failure_high(user)
		if (4)
			if (chance < 20)
				failure_drunk(user)
			else if (chance < 80)
				failure_high(user)
			else
				failure_dimwitted(user)
		if (5)
			if (chance < 10)
				failure_drunk(user)
			else if (chance < 20)
				failure_high(user)
			else
				failure_dimwitted(user)

		// Past this point, the effects of failure can be especially nasty.
		if (6)
			if (chance < 10)
				failure_paralysis(user)
			else
				failure_blind(user)
		if (7)
			if (chance < 30)
				failure_languageloss(user, target)
			else
				failure_paralysis(user)
		if (8)
			if (chance < 15)
				failure_paralysis(user)
			else
				failure_languageloss(user)
		if (10 to INFINITY)
			failure_feeblemind(user)

/obj/item/scrying/proc/failure_languageloss(mob/living/user)
	to_chat(user, span_boldwarning("You focus your thoughts on the orb - but as you do, you feel your grasp of language slipping away..."))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_langloss)

/obj/item/scrying/proc/failure_feeblemind(mob/living/user)
	user.visible_message(span_danger("[user] stares into [src] - [user.p_their()] eyes lose their wit, and [user.p_their()] mouth hangs open..."), span_boldwarning("You focus your thoughts on the orb - and feel them slipping away, away, slowly... draining... into..."))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_feeblemind)

/obj/item/scrying/proc/failure_paralysis(mob/living/user)
	user.visible_message(span_danger("[user] stares into [src]. Parts of [user.p_their()] body seem to go limp..."), span_boldwarning("You focus your thoughts on the orb - you feel a pain shooting through your head, and begin to feel a strange numbness..."))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_arcane_paralysis)

/obj/item/scrying/proc/failure_blind(mob/living/user)
	user.visible_message(span_danger("[user] stares into [src]. Arcyne darkness seem to cloud [user.p_their()] eyes!"), span_boldwarning("You focus your thoughts on the orb - your vision darkens... And doesn't return."))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_blindness)

/obj/item/scrying/proc/failure_dimwitted(mob/living/user)
	user.visible_message(span_danger("[user] stares into [src]... And [user.p_their()] eyes gain a witless look."), span_boldwarning("You focus your thoughts on the orb - and though you see nothing, suddenly the world becomes so much simpler."))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_dimwitted)

/obj/item/scrying/proc/failure_high(mob/living/user)
	user.visible_message(span_danger("[user] stares into [src]. Suddenly, [user.p_they()] seems unable to stay still!"), span_boldwarning("You focus your thoughts on the orb - and you begin to feel so happy and giddy!"))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_arcane_high)

/obj/item/scrying/proc/failure_random_person(mob/living/user, mob/living/target)
	user.visible_message(span_danger("[user] stares into [src], [user.p_their()] eyes rolling back into [user.p_their()] head."), span_boldwarning("You focus your thoughts on the orb - and... Wait, this isn't right..."))
	scry_wrong_person(user, target)

/obj/item/scrying/proc/failure_sleep(mob/living/user)
	user.visible_message(span_danger("[user] stares into [src] - and then, without warning, falls asleep!"), span_boldwarning("You focus your thoughts on the orb - and begin feeling tired, so tired; maybe you should... Should..."))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_sleepy)

/obj/item/scrying/proc/failure_confused(mob/living/user)
	user.visible_message(span_danger("[user] stares into [src]... And then looks around in confusion."), span_boldwarning("You focus your thoughts on the orb - and suddenly, you feel disoriented, as if the world no longer makes sense."))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_confused)

/obj/item/scrying/proc/failure_drunk(mob/living/user)
	user.visible_message(span_danger("[user] stares into [src] - and then hiccups."), span_boldwarning("You focus your thoughts on the orb - the world spins and, oh TEN, have you been DRINKING? Ha ha!"))
	user.apply_status_effect(/datum/status_effect/debuff/mishap_arcane_drunkenness)

/obj/item/scrying/proc/failure_burn(mob/living/user)
	user.visible_message(span_danger("[user] stares into [src]... But the orb glows red, and you hear a sizzling sound!"), span_boldwarning("You focus your thoughts on the orb - it heats up, until it's painfully hot!"))
	var/obj/item = user.get_item_for_held_index(1)
	if (item == src)
		user.apply_damage(25, BURN, user.get_bodypart(BODY_ZONE_L_ARM))
	else
		user.apply_damage(25, BURN, user.get_bodypart(BODY_ZONE_R_ARM))
	user.flash_fullscreen("redflash1")
	user.emote("scream")

/////////////////////////////////////////Crystal ball ghsot vision///////////////////

/obj/item/crystalball/attack_self(mob/user)
	user.visible_message(span_danger("[user] stares into [src], \their eyes rolling back into \their head."))
	user.ghostize(1)
