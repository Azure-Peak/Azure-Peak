/datum/coven/fae_trickery
	name = "Fae Trickery"
	desc = "This coven typically develops in vampires born near the swamps of Daftmarsh surrounded by the Fae."
	icon_state = "mytherceria"
	power_type = /datum/coven_power/fae_trickery

/datum/coven_power/fae_trickery
	name = "Fae Trickery power name"
	desc = "Fae Trickery power description"

//DARKLING TRICKERY
/datum/coven_power/fae_trickery/darkling_trickery
	name = "Darkling Trickery"
	desc = "Disarm your victims from afar."

	level = 1
	research_cost = 0
	vitae_cost = 150
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_FREE_HAND | COVEN_CHECK_LYING
	target_type = TARGET_MOB
	range = 5

	cooldown_length = 1 MINUTES

/datum/coven_power/fae_trickery/darkling_trickery/activate(mob/living/target)
	. = ..()
	target.visible_message(span_suicide("[target] is disarmed!"),
					span_boldwarning("I'm disarmed!"))	
	playsound(get_turf(target), 'sound/magic/mockery.ogg', 40, FALSE)
	var/turnangle = (prob(50) ? 270 : 90)
	var/turndir = turn(target.dir, turnangle)
	var/dist = rand(1, owner.get_vampire_generation())
	var/current_turf = get_turf(target)
	var/target_turf = get_ranged_target_turf(current_turf, turndir, dist)
	target.throw_item(target_turf, FALSE)
	target.apply_status_effect(/datum/status_effect/debuff/clickcd, (owner.get_vampire_generation() - 1) SECONDS)

//GOBLINISM
/datum/coven_power/fae_trickery/goblinism
	name = "Goblinism"
	desc = "Summon a mischievous goblin to latch onto your enemies' faces."

	level = 2
	research_cost = 1
	vitae_cost = 100
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_FREE_HAND
	target_type = TARGET_MOB
	range = 5

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 1 MINUTES

/datum/coven_power/fae_trickery/goblinism/activate(mob/living/target)
	. = ..()
	var/obj/item/clothing/mask/rogue/goblin_mask/goblin = new (get_turf(owner))
	goblin.throw_at(target, 10, 14, owner)
	owner.visible_message(
		span_warning("[owner]'s hand glows green, only to launch a goblin at [target]!"))
	playsound(get_turf(owner), 'sound/magic/clang.ogg', 40, TRUE)

/obj/item/clothing/mask/rogue/goblin_mask
	name = "goblin"
	desc = "A green changeling creature."
	icon_state = "goblin"
	max_integrity = 200
	body_parts_covered = FULL_HEAD
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	var/stat = CONSCIOUS
	var/strength = 5
	var/attached = 0
	var/obj/item/clothing/mask/rogue/headgear

/obj/item/clothing/mask/rogue/goblin_mask/Destroy()
	. = ..() // Not the other way around as we need to restore our victim's headgear
	QDEL_NULL(headgear)

/obj/item/clothing/mask/rogue/goblin_mask/take_damage(damage_amount, damage_type = BRUTE, damage_flag, sound_effect, attack_dir, armor_penetration)
	..()
	if(obj_integrity < 90)
		Die()

/obj/item/clothing/mask/rogue/goblin_mask/proc/Die()
	if(stat == DEAD)
		return

	icon_state = "[initial(icon_state)]_dead"
	stat = DEAD

	visible_message(span_danger("[src] curls up into a ball!"))

/obj/item/clothing/mask/rogue/goblin_mask/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		var/used_hand_zone = C.used_hand == 1 ? BODY_ZONE_PRECISE_L_HAND : BODY_ZONE_PRECISE_R_HAND
		to_chat(user, span_warning("[src] bites!"))
		if(!C.apply_damage(5, BRUTE, used_hand_zone, C.run_armor_check(used_hand_zone, "stab", damage = 5)))
			to_chat(user, VISMSG_ARMOR_BLOCKED)
		playsound(get_turf(src), pick('sound/vo/mobs/gob/aggro (1).ogg','sound/vo/mobs/gob/aggro (2).ogg','sound/vo/mobs/gob/aggro (3).ogg','sound/vo/mobs/gob/aggro (4).ogg'), 100, FALSE, -1)
		return
	if((stat == CONSCIOUS))
		if(Leap(user))
			return
	. = ..()

/obj/item/clothing/mask/rogue/goblin_mask/examine(mob/user)
	. = ..()
	switch(stat)
		if(DEAD,UNCONSCIOUS)
			. += span_boldannounce("[src] is not moving.")
		if(CONSCIOUS)
			. += span_boldannounce("[src] seems to be active!")

/obj/item/clothing/mask/rogue/goblin_mask/throw_at(atom/target, range, speed, mob/thrower, spin = FALSE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE) //If this returns FALSE then callback will not be called.
	. = ..()
	if(!.)
		return
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]_thrown"
		addtimer(CALLBACK(src, PROC_REF(clear_throw_icon_state)), 15)

/obj/item/clothing/mask/rogue/goblin_mask/proc/clear_throw_icon_state()
	if(icon_state == "[initial(icon_state)]_thrown")
		icon_state = "[initial(icon_state)]"

/obj/item/clothing/mask/rogue/goblin_mask/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]"
		Leap(hit_atom)

/obj/item/clothing/mask/rogue/goblin_mask/proc/valid_to_attach(mob/living/M)
	// valid targets: carbons
	if(stat != CONSCIOUS)
		return FALSE
	if(attached)
		return FALSE
	if(iscarbon(M))
		var/mob/living/carbon/target = M
		// gotta have a head to be implanted (no changelings or sentient plants)
		if(!target.get_bodypart(BODY_ZONE_HEAD))
			return FALSE
		// carbon, has head, not alien or devil, has no hivenode or embryo: valid
		return TRUE

	return FALSE


/obj/item/clothing/mask/rogue/goblin_mask/equipped(mob/M)
	. = ..()
	Attach(M)

/obj/item/clothing/mask/rogue/goblin_mask/dropped(mob/living/carbon/user)
	. = ..() // Retarded istype cuz we are doing retarded typecasting here.
	if(istype(user) && user?.wear_mask == src && istype(headgear))
		user.equip_to_slot(headgear, SLOT_WEAR_MASK)
		headgear = null

/obj/item/clothing/mask/rogue/goblin_mask/Crossed(atom/target)
	. = ..()
	HasProximity(target)

/obj/item/clothing/mask/rogue/goblin_mask/attack(mob/living/M, mob/user)
	..()
	if(user.transferItemToLoc(src, get_turf(M)))
		Leap(M)

/obj/item/clothing/mask/rogue/goblin_mask/proc/Attach(mob/living/M)
	if(!valid_to_attach(M))
		return
	// early returns and validity checks done: attach.
	attached++
	//ensure we detach once we no longer need to be attached
	addtimer(CALLBACK(src, PROC_REF(detach)), 30 SECONDS)


	GoIdle() //so it doesn't jump the people that tear it off


/obj/item/clothing/mask/rogue/goblin_mask/proc/GoIdle()
	if(stat == DEAD || stat == UNCONSCIOUS)
		return

	stat = UNCONSCIOUS
	icon_state = "[initial(icon_state)]_inactive"

	addtimer(CALLBACK(src, PROC_REF(GoActive)), rand(20 SECONDS, 40 SECONDS))

/obj/item/clothing/mask/rogue/goblin_mask/proc/GoActive()
	if(stat == DEAD || stat == CONSCIOUS)
		return

	stat = CONSCIOUS
	icon_state = "[initial(icon_state)]"

/obj/item/clothing/mask/rogue/goblin_mask/proc/detach()
	attached = 0

/obj/item/clothing/mask/rogue/goblin_mask/proc/Leap(mob/living/M)
	if(iscarbon(M))
		var/mob/living/carbon/target = M
		if(target.wear_mask && istype(target.wear_mask, /obj/item/clothing/mask/rogue/goblin_mask))
			return FALSE
	M.visible_message(span_danger("[src] leaps at [M]'s face!"), \
		span_userdanger("[src] leaps at your face!"))
	playsound(get_turf(src), 'sound/vo/mobs/gob/aggro (2).ogg', 100, FALSE, -1)
	if(iscarbon(M))
		var/mob/living/carbon/target = M

		if(target.wear_mask)
			headgear = M.get_item_by_slot(SLOT_WEAR_MASK)
			M.transferItemToLoc(headgear, src)
			target.visible_message(
				span_danger("[src] tears [headgear] off of [target]'s face!"), \
				span_userdanger("[src] tears [headgear] off of your face!"))
		target.equip_to_slot_if_possible(src, SLOT_WEAR_MASK, disable_warning = TRUE, bypass_equip_delay_self = TRUE)
		var/datum/cb = CALLBACK(src,/obj/item/clothing/mask/rogue/goblin_mask/proc/eat_head)
		for(var/i in 1 to 10)
			addtimer(cb, (i - 1) * 1.5 SECONDS)
		spawn(16 SECONDS)
			qdel(src)
	return TRUE

/obj/item/clothing/mask/rogue/goblin_mask/proc/eat_head()
	if(iscarbon(loc))
		var/mob/living/carbon/C = loc
		to_chat(C, span_warning("[src] is eating your face!"))
		if(!C.apply_damage(5, BRUTE, BODY_ZONE_HEAD, C.run_armor_check(BODY_ZONE_HEAD, "stab", damage = 5)))
			to_chat(C, VISMSG_ARMOR_BLOCKED)

/obj/fae_trickery_trap
	name = "fae trap"
	desc = "Creates a fae trap to protect your domain."
	anchored = TRUE
	density = FALSE
	alpha = 64
	icon = 'icons/effects/clan.dmi'
	icon_state = "rune1"
	color = "#4182ad"
	var/unique = FALSE
	var/mob/owner

/obj/fae_trickery_trap/Crossed(atom/movable/AM, oldloc)
	..()
	if(isliving(AM) && owner)
		if(AM != owner)
			if(!unique)
				var/mob/living/L = AM
				var/atom/throw_target
				if(!oldloc)
					throw_target = get_edge_target_turf(AM, pick(GLOB.cardinals))
				else
					throw_target = get_edge_target_turf(AM, get_dir(AM, oldloc))
				L.apply_damage(20, BRUTE)
				AM.throw_at(throw_target, rand(8,10), 4, owner, spin = TRUE)
				qdel(src)

/obj/fae_trickery_trap/disorient
	name = "fae trap"
	desc = "Creates a fae trap to protect your domain."
	anchored = TRUE
	density = FALSE
	unique = TRUE
	icon_state = "rune2"

/obj/fae_trickery_trap/disorient/Crossed(atom/movable/AM)
	..()
	if(isliving(AM) && owner)
		if(AM != owner)
			var/mob/living/L = AM
			var/rotation = 50
			for(var/screen_type in L.hud_used?.plane_masters)
				var/atom/movable/screen/plane_master/whole_screen = L.hud_used?.plane_masters[screen_type]
				animate(whole_screen, transform = matrix(rotation, MATRIX_ROTATE), time = 0.5 SECONDS, easing = QUAD_EASING, loop = -1)
				animate(transform = matrix(-rotation, MATRIX_ROTATE), time = 0.5 SECONDS, easing = QUAD_EASING)
			spawn(15 SECONDS)
				for(var/screen_type in L.hud_used?.plane_masters)
					var/atom/movable/screen/plane_master/whole_screen = L.hud_used?.plane_masters[screen_type]
					animate(whole_screen, transform = matrix(), time = 0.5 SECONDS, easing = QUAD_EASING)
			qdel(src)

/obj/fae_trickery_trap/drop
	name = "fae trap"
	desc = "Creates a fae trap to protect your domain."
	anchored = TRUE
	density = FALSE
	unique = TRUE
	icon_state = "rune3"

/obj/fae_trickery_trap/drop/Crossed(mob/living/carbon/AM)
	..()
	if(iscarbon(AM) && owner)
		if(AM != owner)
			AM.adjustBruteLoss(35)
			AM.Knockdown(5)
			AM.visible_message(span_suicide("[AM] is disarmed!"), 
							span_boldwarning("I'm disarmed!"))
			playsound(get_turf(AM), 'sound/magic/mockery.ogg', 40, FALSE)
			var/target_turf = get_ranged_target_turf(get_turf(AM), pick(GLOB.cardinals), rand(2, 5))
			AM.throw_item(target_turf, FALSE)
			qdel(src)

//CHANJELIN WARD
/datum/coven_power/fae_trickery/chanjelin_ward
	name = "Chanjelin Ward"
	desc = "Plants a symbol under you. Brutal traps throw victims violently, spin makes them dizzy, drop knocks them on the ground and throws their weapon away."

	level = 3
	research_cost = 2
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE
	vitae_cost = 80

	aggravating = TRUE
	hostile = TRUE

	cooldown_length = 30 SECONDS

/datum/coven_power/fae_trickery/chanjelin_ward/activate()
	. = ..()
	var/try_trap = input(owner, "Select a Trap:", "Trap") as null|anything in list("Brutal", "Spin", "Drop")
	if(!try_trap)
		return

	switch(try_trap)
		if("Brutal")
			var/obj/fae_trickery_trap/trap = new (get_turf(owner))
			trap.owner = owner
		if("Spin")
			var/obj/fae_trickery_trap/disorient/trap = new (get_turf(owner))
			trap.owner = owner
		if("Drop")
			var/obj/fae_trickery_trap/drop/trap = new (get_turf(owner))
			trap.owner = owner

//RIDDLE PHANTASTIQUE
/datum/coven_power/fae_trickery/riddle_phantastique
	name = "Riddle Phantastique"
	desc = "Pose a confounding riddle to your victim, forcing them to answer it before they can do anything else."

	level = 4
	research_cost = 3
	vitae_cost = 250
	minimal_generation = GENERATION_ANCILLAE
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_SPEAK
	target_type = TARGET_LIVING
	range = 7

	cooldown_length = 0

	var/list/datum/riddle/stored_riddles = list()

/datum/coven_power/fae_trickery/riddle_phantastique/activate(mob/living/target)
	. = ..()
	if(length(stored_riddles))
		var/list/riddle_list = list("Create a new riddle...")
		for(var/datum/riddle/riddle in stored_riddles)
			riddle_list += riddle.riddle_text
		var/try_riddle = input(owner, "Select a Riddle:", "Riddle") as null|anything in riddle_list
		if(try_riddle)
			if(try_riddle == "Create a new riddle...")
				var/datum/riddle/riddle = new ()
				if(riddle.create_riddle(owner))
					stored_riddles += riddle
					riddle.ask(target)
					owner.say(riddle.riddle_text)
				return
			var/datum/riddle/actual_riddle
			for(var/datum/riddle/RIDDLE in stored_riddles)
				if(RIDDLE)
					if(RIDDLE.riddle_text == try_riddle)
						actual_riddle = RIDDLE
			target.add_movespeed_modifier("riddle", 5)
			actual_riddle.ask(target)
			owner.say(actual_riddle.riddle_text)
	else
		var/datum/riddle/riddle = new ()
		if(riddle.create_riddle(owner))
			stored_riddles += riddle
			riddle.ask(target)
			owner.say(riddle.riddle_text)
		else
			qdel(riddle)

/datum/riddle
	var/riddle_text
	var/list/riddle_options = list()
	var/riddle_answer

/atom/movable/screen/alert/riddle
	name = "Riddle"
	desc = "You have a riddle to solve!"
	icon_state = "riddle"

	var/datum/riddle/riddle
	var/bad_answers = 0

/atom/movable/screen/alert/riddle/Click()
	if(iscarbon(usr) && (usr == mob_viewer))
		var/mob/living/carbon/M = usr
		if(riddle)
			riddle.try_answer(M, src)

/datum/riddle/proc/try_answer(mob/living/answerer, atom/movable/screen/alert/riddle/new_alert)
	var/try_answer = input(answerer, riddle_text, "Riddle") as null|anything in riddle_options
	if(try_answer)
		answer_riddle(answerer, try_answer, new_alert)

/datum/riddle/proc/ask(mob/living/asking)
	var/atom/movable/screen/alert/riddle/alert = asking.throw_alert("riddle", /atom/movable/screen/alert/riddle)
	alert.riddle = src

/datum/riddle/proc/create_riddle(mob/living/carbon/human/riddler)
	var/proceed = FALSE
	var/text_riddle = input(riddler, "Create a riddle:", "Riddle", "Is it something?") as null|text
	if(text_riddle)
		riddle_text = trim(copytext_char(sanitize(text_riddle), 1, MAX_MESSAGE_LEN))
		var/right_answer = input(riddler, "Create a right answer:", "Riddle", "Something") as null|text
		if(right_answer)
			riddle_answer = trim(copytext_char(sanitize(right_answer), 1, MAX_MESSAGE_LEN))
			riddle_options += trim(copytext_char(sanitize(right_answer), 1, MAX_MESSAGE_LEN))
			proceed = TRUE
			var/answer1 = input(riddler, "Create another answer:", "Riddle", "Anything") as null|text
			if(answer1)
				riddle_options += trim(copytext_char(sanitize(answer1), 1, MAX_MESSAGE_LEN))
				var/answer2 = input(riddler, "Create another answer:", "Riddle", "Anything") as null|text
				if(answer2)
					riddle_options += trim(copytext_char(sanitize(answer2), 1, MAX_MESSAGE_LEN))
					var/answer3 = input(riddler, "Create another answer:", "Riddle", "Anything") as null|text
					if(answer3)
						riddle_options += trim(copytext_char(sanitize(answer3), 1, MAX_MESSAGE_LEN))
						var/answer4 = input(riddler, "Create another answer:", "Riddle", "Anything") as null|text
						if(answer4)
							riddle_options += trim(copytext_char(sanitize(answer4), 1, MAX_MESSAGE_LEN))
	if(proceed)
		to_chat(riddler, "New riddle created.")
		return src
	else
		to_chat(riddler, span_danger("Your riddle is too complicated."))
		return FALSE

/datum/riddle/proc/answer_riddle(mob/living/answerer, the_answer, var/atom/movable/screen/alert/riddle/alert)
	if(the_answer != riddle_answer)
		alert.bad_answers++
		to_chat(answerer,
			span_danger("WRONG ANSWER."))
		if(alert.bad_answers >= round(length(riddle_options)/2))
			if(HAS_TRAIT(answerer, TRAIT_CRITICAL_WEAKNESS))
				if(iscarbon(answerer))
					var/mob/living/carbon/C = answerer
					var/obj/item/organ/tongue/tongue = locate(/obj/item/organ/tongue) in C.internal_organs
					if(tongue)
						tongue.Remove(C)
				to_chat(answerer,
					span_danger("THE RIDDLE REMOVES YOUR LYING TONGUE AS IT FLEES."))
			else
				to_chat(answerer,
					span_danger("THE RIDDLE PUNISHES YOU FOR LYING."))
				answerer.adjust_fire_stacks(6)
				answerer.ignite_mob()
				answerer.adjustFireLoss(45)
				answerer.Knockdown(10)
			answerer.remove_movespeed_modifier("riddle")
			alert.bad_answers = 0
			alert.riddle = null
			answerer.clear_alert("riddle")
	else
		to_chat(answerer,
			span_nicegreen("You feel the riddle's hold over you vanish."))
		alert.riddle = null
		answerer.remove_movespeed_modifier("riddle")
		answerer.say(the_answer)
		answerer.clear_alert("riddle")

//FAE WRATH T5
/datum/coven_power/fae_trickery/fae_wrath
	name = "Fae Wrath"
	desc = "Unleash a barrage of strikes upon thine foes."

	level = 5
	research_cost = 4
	vitae_cost = 250
	minimal_generation = GENERATION_ANCILLAE
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_SPEAK
	range = 7

	cooldown_length = 40 SECONDS

/datum/coven_power/fae_trickery/fae_wrath/activate()
	. = ..()
	var/turf/initial = get_turf(owner)
	INVOKE_ASYNC(src, PROC_REF(aftervisual), initial)
	for(var/mob/living/carbon/human/viewer in oviewers(range, owner))
		if(viewer.clan == owner.clan)
			continue

		var/turf/T = get_step(viewer, GLOB.flip_dir[viewer.dir])
		if(!isfloorturf(T))
			continue

		INVOKE_ASYNC(src, PROC_REF(aftervisual), get_turf(viewer))
		owner.doMove(T)
		owner.face_atom(viewer)
		var/obj/item/W = owner.get_active_held_item()
		if(!istype(W))
			W = owner.get_inactive_held_item()
		owner.resolveAdjacentClick(viewer, W)
		owner.resolveAdjacentClick(viewer, W)
		sleep(0.5 SECONDS)
	owner.doMove(initial)
	INVOKE_ASYNC(src, PROC_REF(aftervisual), initial)

/datum/coven_power/fae_trickery/fae_wrath/proc/aftervisual(turf/target)
	var/list/afterimages = list()
	var/list/turfs = RANGE_TURFS(1, target)
	for(var/turf/T in turfs)
		var/obj/effect/after_image/C = new(T, -8, 8, -8, 8, 0.5 SECONDS, 3 SECONDS, 0)
		afterimages += C
		C.name = owner.name
		C.appearance = owner.appearance
		C.dir = get_dir(T, target)

	QDEL_LIST_IN(afterimages, 3 SECONDS)
