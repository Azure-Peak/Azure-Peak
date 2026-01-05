///////////OFFHAND///////////////
/obj/item/grabbing
	name = "pulling"
	icon_state = "grabbing"
	icon = 'icons/mob/roguehudgrabs.dmi'
	w_class = WEIGHT_CLASS_HUGE
	possible_item_intents = list(/datum/intent/grab/upgrade)
	item_flags = ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	grab_state = 0 //this is an atom/movable var i guess
	no_effect = TRUE
	force = 0
	experimental_inhand = FALSE
	var/grabbed				//ref to what atom we are grabbing
	var/obj/item/bodypart/limb_grabbed		//ref to actual bodypart being grabbed if we're grabbing a carbo
	var/sublimb_grabbed		//ref to what precise (sublimb) we are grabbing (if any) (text)
	var/mob/living/carbon/grabbee
	var/list/dependents = list()
	var/handaction
	var/bleed_suppressing = 0.25 //multiplier for how much we suppress bleeding, can accumulate so two grabs means 50% less bleeding; each grab being 25% basically.
	var/chokehold = FALSE

/atom/movable //reference to all obj/item/grabbing
	var/list/grabbedby = list()

/turf
	var/list/grabbedby = list()

/obj/item/grabbing/Initialize()
	. = ..()
	START_PROCESSING(SSfastprocess, src)

/obj/item/grabbing/process()
	valid_check()

/obj/item/grabbing/proc/valid_check()
	// We require adjacency to count the grab as valid
	if(grabbee.Adjacent(grabbed))
		return TRUE
	grabbee.stop_pulling(FALSE)
	qdel(src)
	return FALSE

/obj/item/grabbing/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C != grabbee)
			qdel(src)
			return 1
		if(modifiers["right"])
			qdel(src)
			return 1
	return ..()

/obj/item/grabbing/proc/update_hands(mob/user)
	if(!user)
		return
	if(!iscarbon(user))
		return
	var/mob/living/carbon/C = user
	for(var/i in 1 to C.held_items.len)
		var/obj/item/I = C.get_item_for_held_index(i)
		if(I == src)
			if(i == 1)
				C.r_grab = src
			else
				C.l_grab = src

/datum/proc/grabdropped(obj/item/grabbing/G)
	if(G)
		for(var/datum/D in G.dependents)
			if(D == src)
				G.dependents -= D

/obj/item/grabbing/proc/relay_cancel_action()
	if(handaction)
		for(var/datum/D in dependents) //stop fapping
			if(handaction == D)
				D.grabdropped(src)
		handaction = null

/obj/item/grabbing/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	if(isobj(grabbed))
		var/obj/I = grabbed
		I.grabbedby -= src
	if(ismob(grabbed))
		var/mob/M = grabbed
		M.grabbedby -= src
		if(iscarbon(M) && sublimb_grabbed)
			var/mob/living/carbon/carbonmob = M
			var/obj/item/bodypart/part = carbonmob.get_bodypart(sublimb_grabbed)

			// Edge case: if a weapon becomes embedded in a mob, our "grab" will be destroyed...
			// In this case, grabbed will be the mob, and sublimb_grabbed will be the weapon, rather than a bodypart
			// This means we should skip any further processing for the bodypart
			if(part)
				part.grabbedby -= src
				part = null
				sublimb_grabbed = null
	if(isturf(grabbed))
		var/turf/T = grabbed
		T.grabbedby -= src
	if(grabbee)
		if(grabbee.r_grab == src)
			grabbee.r_grab = null
		if(grabbee.l_grab == src)
			grabbee.l_grab = null
		if(grabbee.mouth == src)
			grabbee.mouth = null
	for(var/datum/D in dependents)
		D.grabdropped(src)
	return ..()

/obj/item/grabbing/dropped(mob/living/user, show_message = TRUE)
	SHOULD_CALL_PARENT(FALSE)
	// Dont stop the pull if another hand grabs the person
	if(user.r_grab == src)
		if(user.l_grab && user.l_grab.grabbed == user.r_grab.grabbed)
			qdel(src)
			return
	if(user.l_grab == src)
		if(user.r_grab && user.r_grab.grabbed == user.l_grab.grabbed)
			qdel(src)
			return
	if(grabbed == user.pulling)
		user.stop_pulling(FALSE)
	if(!user.pulling)
		user.stop_pulling(FALSE)
	for(var/mob/M in user.buckled_mobs)
		if(M == grabbed)
			user.unbuckle_mob(M, force = TRUE)
	if(QDELETED(src))
		return
	qdel(src)

/mob/living/carbon/human/proc/attackhostage()
	if(!istype(hostagetaker.get_active_held_item(), /obj/item/rogueweapon))
		return
	var/obj/item/rogueweapon/WP = hostagetaker.get_active_held_item()
	WP.attack(src, hostagetaker)
	hostagetaker.visible_message("<span class='danger'>\The [hostagetaker] attacks \the [src] reflexively!</span>")
	hostagetaker.hostage = null
	hostagetaker = null

/obj/item/grabbing/attack(mob/living/M, mob/living/user)
	if(M != grabbed)
		if(!istype(limb_grabbed, /obj/item/bodypart/head))
			return FALSE
		if(M != user)
			return FALSE
		if(!user.cmode)
			return FALSE
		user.changeNext_move(CLICK_CD_RESIST)
		headbutt(user)
		return
	if(!valid_check())
		return FALSE
	if(M == user) // Self-grab attempt
		var/signal_result = SEND_SIGNAL(user, COMSIG_LIVING_GRAB_SELF_ATTEMPT, user, M, sublimb_grabbed, null)
		if(signal_result & COMPONENT_CANCEL_GRAB_ATTACK)
			return FALSE
	user.changeNext_move(CLICK_CD_TRACKING)

	var/skill_diff = 0
	var/combat_modifier = 1
	if(user.mind)
		skill_diff += (user.get_skill_level(/datum/skill/combat/wrestling))
	if(M.mind)
		skill_diff -= (M.get_skill_level(/datum/skill/combat/wrestling))
	if(HAS_TRAIT(M, TRAIT_GRABIMMUNE))
		if(M.cmode)
			to_chat(user, span_warning("Can't get a grip on this one!"))
			return

	if(M.compliance || M.surrendering)
		combat_modifier = 2

	if(M.restrained())
		combat_modifier += 0.25

	if(!(M.mobility_flags & MOBILITY_STAND) && user.mobility_flags & MOBILITY_STAND)
		combat_modifier += 0.05

	if(user.cmode && !M.cmode)
		combat_modifier += 0.3
	
	else if(!user.cmode && M.cmode)
		combat_modifier -= 0.3

	if(sublimb_grabbed == BODY_ZONE_PRECISE_NECK && grab_state > 0) //grabbing aggresively the neck
		if(user && (M.dir == turn(get_dir(M,user), 180))) //is behind the grabbed
			chokehold = TRUE

	if(chokehold)
		combat_modifier += 0.15
	switch(user.used_intent.type)
		if(/datum/intent/grab/upgrade)
			if(!(M.status_flags & CANPUSH) || HAS_TRAIT(M, TRAIT_PUSHIMMUNE))
				to_chat(user, span_warning("Can't get a grip!"))
				return FALSE
			user.stamina_add(rand(7,15))
			if(M.grippedby(user))			//Aggro grip
				bleed_suppressing = 0.5		//Better bleed suppression
		if(/datum/intent/grab/choke)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			if(user.badluck(5))
				badluckmessage(user)
				user.stop_pulling()
				return FALSE
			if(limb_grabbed && grab_state > 0) //this implies a carbon victim
				if(iscarbon(M))
					playsound(src.loc, 'sound/foley/struggle.ogg', 100, FALSE, -1)
					user.stamina_add(7)
					var/mob/living/carbon/C = M
					var/choke_damage
					if(user.STASTR > STRENGTH_SOFTCAP)
						choke_damage = STRENGTH_SOFTCAP
					else
						choke_damage = user.STASTR * 0.75
					if(chokehold)
						choke_damage *= 1.2		//Slight bonus
					if(C.pulling == user && C.grab_state >= GRAB_AGGRESSIVE)
						choke_damage *= 0.95	//Slight malice
					var/neck_armor = C.run_armor_check(BODY_ZONE_PRECISE_NECK, "slash")
					var/reduction = (neck_armor / 100) * 0.66
					reduction = min(max(reduction, 0), 1)
					choke_damage *= (1 - reduction)
					if(!HAS_TRAIT(C, TRAIT_NOBREATH))
						if(C.stamina < C.max_stamina)
							C.stamina_add(choke_damage*1.5)
						if(prob(25))
							C.emote("choke")
					C.adjustOxyLoss(choke_damage)
					C.visible_message(span_danger("[user] [pick("chokes", "strangles")] [C][chokehold ? " with a chokehold" : ""]!"), \
							span_userdanger("[user] [pick("chokes", "strangles")] me[chokehold ? " with a chokehold" : ""]!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE, user)
					to_chat(user, span_danger("I [pick("choke", "strangle")] [C][chokehold ? " with a chokehold" : ""]!"))
					user.changeNext_move(CLICK_CD_GRABBING)	//Stops spam for choking.
		if(/datum/intent/grab/hostage)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			if(user.badluck(10))
				badluckmessage(user)
				user.stop_pulling()
				return FALSE
			if(limb_grabbed && grab_state > GRAB_PASSIVE) //this implies a carbon victim
				if(ishuman(M) && M != user)
					var/mob/living/carbon/human/H = M
					var/mob/living/carbon/human/U = user
					if(U.cmode)
						if(H.cmode)
							to_chat(U, "<span class='warning'>[H] is too prepared for combat to be taken hostage.</span>")
							return
						to_chat(U, "<span class='warning'>I take [H] hostage.</span>")
						to_chat(H, "<span class='danger'>[U] takes us hostage!</span>")

						U.swap_hand() // Swaps hand to weapon so you can attack instantly if hostage decides to resist

						U.hostage = H
						H.hostagetaker = U
		if(/datum/intent/grab/twist)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			if(user.badluck(5))
				badluckmessage(user)
				user.stop_pulling()
				return FALSE
			if(limb_grabbed && grab_state > 0) //this implies a carbon victim
				if(iscarbon(M))
					user.stamina_add(rand(3,8))
					twistlimb(user)
		if(/datum/intent/grab/twistitem)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			if(user.badluck(10))
				badluckmessage(user)
				user.stop_pulling()
				return FALSE
			if(limb_grabbed && grab_state > 0) //this implies a carbon victim
				if(ismob(M))
					user.stamina_add(rand(3,8))
					twistitemlimb(user)
		if(/datum/intent/grab/remove)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			if(user.badluck(10))
				badluckmessage(user)
				user.stop_pulling()
				return FALSE
			user.stamina_add(rand(3,13))
			if(isitem(sublimb_grabbed))
				removeembeddeditem(user)
			else
				user.stop_pulling()
		if(/datum/intent/grab/shove)
			if(user.buckled)
				to_chat(user, span_warning("I can't do this while buckled!"))
				return FALSE
			if(user.badluck(10))
				badluckmessage(user)
				user.stop_pulling()
				return FALSE
			if(!(user.mobility_flags & MOBILITY_STAND))
				to_chat(user, span_warning("I must stand.."))
				return
			if(!(M.mobility_flags & MOBILITY_STAND))
				if(user.loc != M.loc)
					to_chat(user, span_warning("I must be above them."))
					return
				var/stun_dur = max(((65 + (skill_diff * 10) + (user.STASTR * 5) - (M.STASTR * 5)) * combat_modifier), 20)
				var/pincount = 0
				user.stamina_add(rand(1,3))
				while(M == grabbed && !(M.mobility_flags & MOBILITY_STAND) && (src in M.grabbedby))
					if(M.IsStun())
						if(!do_after(user, stun_dur + 1, needhand = 0, target = M))
							pincount = 0
							qdel(src)
							break
						if(!(src in M.grabbedby))
							pincount = 0
							qdel(src)
							break
						M.Stun(stun_dur - pincount * 2)	
						M.Immobilize(stun_dur)	//Made immobile for the whole do_after duration, though
						user.stamina_add(rand(1,3) + abs(skill_diff) + stun_dur / 1.5)
						M.visible_message(span_danger("[user] keeps [M] pinned to the ground!"))
						pincount += 2
					else if(src in M.grabbedby)
						M.Stun(stun_dur - 10)
						M.Immobilize(stun_dur)
						user.stamina_add(rand(1,3) + abs(skill_diff) + stun_dur / 1.5)
						pincount += 2
						M.visible_message(span_danger("[user] pins [M] to the ground!"), \
							span_userdanger("[user] pins me to the ground!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
			else
				if(user.badluck(10))
					badluckmessage(user)
					user.stop_pulling()
					return FALSE
				user.stamina_add(rand(5,15))
				if(M.compliance || prob(clamp((((4 + (((user.STASTR - M.STASTR)/2) + skill_diff)) * 10 + rand(-5, 5)) * combat_modifier), 5, 95)))
					M.visible_message(span_danger("[user] shoves [M] to the ground!"), \
									span_userdanger("[user] shoves me to the ground!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
					M.Knockdown(max(10 + (skill_diff * 2), 1))
				else
					M.visible_message(span_warning("[user] tries to shove [M]!"), \
									span_danger("[user] tries to shove me!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
		if(/datum/intent/grab/disarm)
			if(user.badluck(10))
				badluckmessage(user)
				user.stop_pulling()
				return FALSE
			var/obj/item/I
			if(sublimb_grabbed == BODY_ZONE_PRECISE_L_HAND && M.active_hand_index == 1)
				I = M.get_active_held_item()
			else 
				if(sublimb_grabbed == BODY_ZONE_PRECISE_R_HAND && M.active_hand_index == 2)
					I = M.get_active_held_item()
				else
					I = M.get_inactive_held_item()
			user.stamina_add(rand(3,8))
			var/probby = clamp((((3 + (((user.STASTR - M.STASTR)/4) + skill_diff)) * 10) * combat_modifier), 5, 95)
			if(I)
				if(M.mind)
					if(I.associated_skill)
						probby -= M.get_skill_level(I.associated_skill) * 5
				if(I.wielded)
					probby -= 20
				if(prob(probby))
					M.dropItemToGround(I, force = FALSE, silent = FALSE)
					user.stop_pulling()
					user.put_in_active_hand(I)
					M.visible_message(span_danger("[user] takes [I] from [M]'s hand!"), \
								span_userdanger("[user] takes [I] from my hand!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
					user.changeNext_move(12)//avoids instantly attacking with the new weapon
					playsound(src.loc, 'sound/combat/weaponr1.ogg', 100, FALSE, -1) //sound queue to let them know that they got disarmed
				else
					probby += 20
					if(prob(probby))
						M.dropItemToGround(I, force = FALSE, silent = FALSE)
						M.visible_message(span_danger("[user] disarms [M] of [I]!"), \
								span_userdanger("[user] disarms me of [I]!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
						M.Stun(6)//slight delay to pick up the weapon
					else
						user.Immobilize(10)
						M.Immobilize(10)
						M.visible_message(span_notice("[user.name] struggles to disarm [M.name]!"))
						playsound(src.loc, 'sound/foley/struggle.ogg', 100, FALSE, -1)
			else
				to_chat(user, span_warning("They aren't holding anything on that hand!"))
				return

/obj/item/grabbing/proc/twistlimb(mob/living/user) //implies limb_grabbed and sublimb are things
	if(user.badluck(5))
		badluckmessage(user)
		user.stop_pulling()
		return
	var/mob/living/carbon/C = grabbed
	var/armor_block = C.run_armor_check(limb_grabbed, "slash")
	var/damage = user.get_punch_dmg()
	if(grabbed == user && limb_grabbed.status == BODYPART_ROBOTIC)	//removing ones own prosthetic should not be violent, nor damaging
		C.visible_message(span_notice("[user] starts twisting [limb_grabbed] of [C], twisting it out of its socket!"), span_notice("I start twisting [limb_grabbed] from [src]."))
		playsound(user, 'sound/misc/blackbag2.ogg', 100)
		if(do_after(user, 60, target = src))
			C.visible_message(span_notice("[user] twists [limb_grabbed] of [C], popping it out of the socket!"), span_notice("I pop [limb_grabbed] from [src]."))
			limb_grabbed.drop_limb()
			return
	playsound(C.loc, "genblunt", 100, FALSE, -1)
	C.next_attack_msg.Cut()
	C.apply_damage(damage, BRUTE, limb_grabbed, armor_block)
	limb_grabbed.bodypart_attacked_by(BCLASS_TWIST, damage, user, sublimb_grabbed, crit_message = TRUE)
	C.visible_message(span_danger("[user] twists [C]'s [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]"), \
					span_userdanger("[user] twists my [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_warning("I twist [C]'s [parse_zone(sublimb_grabbed)].[C.next_attack_msg.Join()]"))
	C.next_attack_msg.Cut()
	log_combat(user, C, "limbtwisted [sublimb_grabbed] ")
	if(limb_grabbed.status == BODYPART_ROBOTIC && armor_block == 0) //Twisting off prosthetics.
		C.visible_message(span_danger("[C]'s prosthetic [parse_zone(sublimb_grabbed)] twists off![C.next_attack_msg.Join()]"), \
					span_userdanger("My prosthetic [parse_zone(sublimb_grabbed)] was twisted off of me![C.next_attack_msg.Join()]"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_warning("I twisted [C]'s prosthetic [parse_zone(sublimb_grabbed)] off.[C.next_attack_msg.Join()]"))
		limb_grabbed.drop_limb(TRUE)
	if(ishuman(user) && user.mind)
		var/text = "[bodyzone2readablezone(user.zone_selected)]..."
		user.filtered_balloon_alert(TRAIT_COMBAT_AWARE, text, show_self = FALSE)

	// Dealing damage to the head beforehand is intentional.
	if(limb_grabbed.body_zone == BODY_ZONE_HEAD && isdullahan(C))
		var/mob/living/carbon/human/target = C
		var/datum/species/dullahan/target_species = target.dna.species
		var/obj/item/equipped_nodrop = target_species.get_nodrop_head()
		if(equipped_nodrop)
			target.visible_message(span_danger("[target]'s head fails to be twisted off!"), \
				span_danger("[user] Tries to twist my head off but the [equipped_nodrop.name] keeps it bound to my neck!"))
			to_chat(user, span_warning("[target]'s head stays bound to their neck because of the [equipped_nodrop.name]!"))
			return

		target.visible_message(span_danger("[target]'s head is being forcefully twisted off!"), \
			span_danger("My head is being forcefully twisted off!"))
		to_chat(user, span_warning("I begin twisting [target]'s head off."))

		if(do_after(user, 6, target = target))
			target.visible_message(span_danger("[target]'s head has been twisted off!"), \
				span_userdanger("My head was twisted off!"))
			to_chat(user, span_warning("I twist [target]'s head off."))

			limb_grabbed.drop_limb(FALSE)

			if(QDELETED(limb_grabbed))
				return

			qdel(src)
			user.put_in_active_hand(limb_grabbed)

/obj/item/grabbing/proc/headbutt(mob/living/carbon/human/H)
	var/mob/living/carbon/C = grabbed
	var/obj/item/bodypart/Chead = C.get_bodypart(BODY_ZONE_HEAD)
	var/obj/item/bodypart/Hhead = H.get_bodypart(BODY_ZONE_HEAD)
	var/armor_block = C.run_armor_check(Chead, "blunt")
	var/armor_block_user = H.run_armor_check(Hhead, "blunt")
	var/damage = H.get_punch_dmg()
	C.next_attack_msg.Cut()
	playsound(C.loc, "genblunt", 100, FALSE, -1)
	C.apply_damage(damage*1.5, , Chead, armor_block)
	Chead.bodypart_attacked_by(BCLASS_SMASH, damage*1.5, H, crit_message=TRUE)
	H.apply_damage(damage, BRUTE, Hhead, armor_block_user)
	Hhead.bodypart_attacked_by(BCLASS_SMASH, damage/1.2, H, crit_message=TRUE)
	C.stop_pulling(TRUE)
	C.Immobilize(10)
	C.OffBalance(10)
	H.Immobilize(5)

	C.visible_message("<span class='danger'>[H] headbutts [C]'s [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]</span>", \
					"<span class='userdanger'>[H] headbutts my [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]</span>", "<span class='hear'>I hear a sickening sound of pugilism!</span>", COMBAT_MESSAGE_RANGE, H)
	to_chat(H, "<span class='warning'>I headbutt [C]'s [parse_zone(sublimb_grabbed)].[C.next_attack_msg.Join()]</span>")
	C.next_attack_msg.Cut()
	log_combat(H, C, "headbutted ")

/obj/item/grabbing/proc/twistitemlimb(mob/living/user) //implies limb_grabbed and sublimb are things
	var/mob/living/M = grabbed
	var/damage = rand(5,10)
	var/obj/item/I = sublimb_grabbed
	playsound(M.loc, "genblunt", 100, FALSE, -1)
	M.apply_damage(damage, BRUTE, limb_grabbed)
	M.visible_message(span_danger("[user] twists [I] in [M]'s wound!"), \
					span_userdanger("[user] twists [I] in my wound!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
	log_combat(user, M, "itemtwisted [sublimb_grabbed] ")

/obj/item/grabbing/proc/removeembeddeditem(mob/living/user) //implies limb_grabbed and sublimb are things
	var/mob/living/M = grabbed
	var/obj/item/bodypart/L = limb_grabbed
	playsound(M.loc, "genblunt", 100, FALSE, -1)
	log_combat(user, M, "itemremovedgrab [sublimb_grabbed] ")
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		var/obj/item/I = locate(sublimb_grabbed) in L.embedded_objects
		if(QDELETED(I) || QDELETED(L) || !L.remove_embedded_object(I))
			return FALSE
		L.receive_damage(I.embedding.embedded_unsafe_removal_pain_multiplier*I.w_class) //It hurts to rip it out, get surgery you dingus.
		user.dropItemToGround(src) // this will unset vars like limb_grabbed
		user.put_in_hands(I)
		C.emote("paincrit", TRUE)
		playsound(C, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
		if(usr == src)
			user.visible_message(span_notice("[user] rips [I] out of [user.p_their()] [L.name]!"), span_notice("I rip [I] from my [L.name]."))
		else
			user.visible_message(span_notice("[user] rips [I] out of [C]'s [L.name]!"), span_notice("I rip [I] from [C]'s [L.name]."))
	else if(HAS_TRAIT(M, TRAIT_SIMPLE_WOUNDS))
		var/obj/item/I = locate(sublimb_grabbed) in M.simple_embedded_objects
		if(QDELETED(I) || !M.simple_remove_embedded_object(I))
			return FALSE
		M.apply_damage(I.embedding.embedded_unsafe_removal_pain_multiplier*I.w_class, BRUTE) //It hurts to rip it out, get surgery you dingus.
		user.dropItemToGround(src) // this will unset vars like limb_grabbed
		user.put_in_hands(I)
		M.emote("paincrit", TRUE)
		playsound(M, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
		if(user == M)
			user.visible_message(span_notice("[user] rips [I] out of [user.p_them()]self!"), span_notice("I remove [I] from myself."))
		else
			user.visible_message(span_notice("[user] rips [I] out of [M]!"), span_notice("I rip [I] from [src]."))
	user.update_grab_intents(grabbed)
	return TRUE

/obj/item/grabbing/attack_turf(turf/T, mob/living/user)
	if(!valid_check())
		return
	if(user.badluck(5))
		badluckmessage(user)
		user.stop_pulling()
		return
	user.changeNext_move(CLICK_CD_GRABBING)
	switch(user.used_intent.type)
		if(/datum/intent/grab/move)
			if(isturf(T))
				user.Move_Pulled(T)
		if(/datum/intent/grab/smash)
			if(!(user.mobility_flags & MOBILITY_STAND))
				to_chat(user, span_warning("I must stand.."))
				return
			if(limb_grabbed && grab_state > 0) //this implies a carbon victim
				if(isopenturf(T))
					if(iscarbon(grabbed))
						var/mob/living/carbon/C = grabbed
						if(!C.Adjacent(T))
							return FALSE
						if(C.mobility_flags & MOBILITY_STAND)
							return
						playsound(C.loc, T.attacked_sound, 100, FALSE, -1)
						smashlimb(T, user)
				else if(isclosedturf(T))
					if(iscarbon(grabbed))
						var/mob/living/carbon/C = grabbed
						if(!C.Adjacent(T))
							return FALSE
						if(!(C.mobility_flags & MOBILITY_STAND))
							return
						playsound(C.loc, T.attacked_sound, 100, FALSE, -1)
						smashlimb(T, user)

/obj/item/grabbing/attack_obj(obj/O, mob/living/user)
	if(!valid_check())
		return
	if(user.badluck(5))
		badluckmessage(user)
		user.stop_pulling()
		return
	user.changeNext_move(CLICK_CD_GRABBING)
	if(user.used_intent.type == /datum/intent/grab/smash)
		if(isstructure(O) && O.blade_dulling != DULLING_CUT)
			if(!(user.mobility_flags & MOBILITY_STAND))
				to_chat(user, span_warning("I must stand.."))
				return
			if(limb_grabbed && grab_state > 0) //this implies a carbon victim
				if(iscarbon(grabbed))
					var/mob/living/carbon/C = grabbed
					if(!C.Adjacent(O))
						return FALSE
					playsound(C.loc, O.attacked_sound, 100, FALSE, -1)
					smashlimb(O, user)


/obj/item/grabbing/proc/smashlimb(atom/A, mob/living/user) //implies limb_grabbed and sublimb are things
	if(user.badluck(10))
		badluckmessage(user)
		user.stop_pulling()
		return
	var/mob/living/carbon/C = grabbed
	var/armor_block = C.run_armor_check(limb_grabbed, d_type, armor_penetration = BLUNT_DEFAULT_PENFACTOR)
	var/damage = user.get_punch_dmg()
	var/unarmed_skill = user.get_skill_level(/datum/skill/combat/unarmed)
	damage *= (1 + (unarmed_skill / 10))	//1.X multiplier where X is the unarmed skill.
	C.next_attack_msg.Cut()
	if(C.apply_damage(damage, BRUTE, limb_grabbed, armor_block))
		limb_grabbed.bodypart_attacked_by(BCLASS_BLUNT, damage, user, sublimb_grabbed, crit_message = TRUE)
		playsound(C.loc, "smashlimb", 100, FALSE, -1)
	else
		C.next_attack_msg += VISMSG_ARMOR_BLOCKED
	C.visible_message(span_danger("[user] smashes [C]'s [limb_grabbed] into [A]![C.next_attack_msg.Join()]"), \
					span_userdanger("[user] smashes my [limb_grabbed] into [A]![C.next_attack_msg.Join()]"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_warning("I smash [C]'s [limb_grabbed] against [A].[C.next_attack_msg.Join()]"))
	C.next_attack_msg.Cut()
	log_combat(user, C, "limbsmashed [limb_grabbed] ")
	if(ishuman(user) && user.mind)
		var/text = "[bodyzone2readablezone(user.zone_selected)]..."
		user.filtered_balloon_alert(TRAIT_COMBAT_AWARE, text, show_self = FALSE)
/datum/intent/grab
	unarmed = TRUE
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	no_attack = TRUE
	misscost = 2
	releasedrain = 2

/datum/intent/grab/move
	name = "grab move"
	desc = ""
	icon_state = "inmove"

/datum/intent/grab/upgrade
	name = "upgrade grab"
	desc = ""
	icon_state = "ingrab"

/datum/intent/grab/smash
	name = "smash"
	desc = ""
	icon_state = "insmash"

/datum/intent/grab/twist
	name = "twist"
	desc = ""
	icon_state = "intwist"

/datum/intent/grab/choke
	name = "choke"
	desc = ""
	icon_state = "inchoke"

/datum/intent/grab/hostage
	name = "hostage"
	desc = ""
	icon_state = "inhostage"

/datum/intent/grab/shove
	name = "shove"
	desc = ""
	icon_state = "intackle"

/datum/intent/grab/twistitem
	name = "twist in wound"
	desc = ""
	icon_state = "intwist"

/datum/intent/grab/remove
	name = "remove"
	desc = ""
	icon_state = "intake"

/datum/intent/grab/disarm
	name = "disarm"
	desc = ""
	icon_state = "intake"

/obj/item/grabbing/bite
	name = "bite"
	icon_state = "bite"
	d_type = "stab"
	slot_flags = ITEM_SLOT_MOUTH
	bleed_suppressing = 1

/obj/item/grabbing/bite/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(!valid_check())
		return
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C != grabbee || C.incapacitated() || C.stat == DEAD)
			qdel(src)
			return 1
		if(modifiers["right"])
			qdel(src)
			return 1
		var/_y = text2num(params2list(params)["icon-y"])
		if(_y>=17)
			bitelimb(C)
		else
			drinklimb(C)
	return 1

/datum/status_effect/buff/oiled
	id = "oiled"
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/oiled
	var/slip_chance = 2 // chance to slip when moving

/datum/status_effect/buff/oiled/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))

/datum/status_effect/buff/oiled/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

/datum/status_effect/buff/oiled/proc/on_move(mob/living/mover, atom/oldloc, direction, forced)
	if(forced)
		return
	var/slipping_prob = slip_chance
	if(iscarbon(mover))
		var/mob/living/carbon/carbon = mover
		if(!carbon.shoes) // being barefoot makes you slip lesss
			slipping_prob /= 2

	if(!prob(slip_chance))
		return

	if(istype(mover))
		if(istype(mover.mind?.assigned_role, /datum/job/roguetown/jester))
			mover.liquid_slip(total_time = 1 SECONDS, stun_duration = 1 SECONDS, height = 30, flip_count = 10)
		else
			mover.liquid_slip(total_time = 1 SECONDS, stun_duration = 1 SECONDS, height = 12, flip_count = 0)

/atom/movable/screen/alert/status_effect/oiled
	name = "Oiled"
	desc = "I'm covered in oil, making me slippery and harder to grab!"
	icon_state = "oiled"

/atom/proc/liquid_slip(dir=null, total_time = 0.5 SECONDS, height = 16, stun_duration = 1 SECONDS, flip_count = 1)
	animate(src) // cleanse animations as funny as a ton of stacked flips would be it would be an eye sore
	var/matrix/M = transform
	var/turn = 90
	if(isnull(dir))
		if(dir == EAST)
			turn = 90
		else if(dir == WEST)
			turn = -90
		else
			if(prob(50))
				turn = -90

	var/flip_anim_step_time = total_time / (1 + 4 * flip_count)
	animate(src, transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = flip_anim_step_time, flags = ANIMATION_PARALLEL)
	for(var/i in 1 to flip_count)
		animate(transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = flip_anim_step_time)
		animate(transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = flip_anim_step_time)
		animate(transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = flip_anim_step_time)
		animate(transform = matrix(M, turn, MATRIX_ROTATE | MATRIX_MODIFY), time = flip_anim_step_time)
	var/matrix/M2 = transform
	animate(transform = matrix(M, 1.2, 0.7, MATRIX_SCALE | MATRIX_MODIFY), time = total_time * 0.125)
	animate(transform = M2, time = total_time * 0.125)

	animate(src, pixel_y=height, time= total_time * 0.5, flags=ANIMATION_PARALLEL)
	animate(pixel_y=-4, time= total_time * 0.5)

	if(isliving(src))
		var/mob/living/living = src
		living.Knockdown(stun_duration)
		living.set_resting(FALSE, silent = TRUE)
		animate(src, pixel_x = 0, pixel_y = 0, transform = src.transform.Turn(-turn), time = 3, easing = LINEAR_EASING, flags=ANIMATION_PARALLEL)
	else
		spawn(stun_duration + total_time)
			animate(src, pixel_x = 0, pixel_y = 0, transform = src.transform.Turn(-turn), time = 3, easing = LINEAR_EASING, flags=ANIMATION_PARALLEL)
