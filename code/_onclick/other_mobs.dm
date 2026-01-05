/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/carbon/UnarmedAttack(atom/A, proximity, params)

	if(!has_active_hand()) //can't attack without a hand.
		to_chat(src, span_warning("I lack working hands."))
		return

	if(!has_hand_for_held_index(used_hand)) //can't attack without a hand.
		to_chat(src, span_warning("I can't move this hand."))
		return

	if(check_arm_grabbed(used_hand))
		to_chat(src, span_warning("Someone is grabbing my arm!"))
		return

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines
	if(proximity && istype(G) && G.Touch(A,1))
		return
	//This signal is needed to prevent gloves of the north star + hulk.
	if(SEND_SIGNAL(src, COMSIG_HUMAN_EARLY_UNARMED_ATTACK, A, proximity) & COMPONENT_NO_ATTACK_HAND)
		return
	SEND_SIGNAL(src, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, A, proximity)
	var/rmb_stam_penalty = 1
	if(istype(rmb_intent, /datum/rmb_intent/strong) || istype(rmb_intent, /datum/rmb_intent/swift))
		rmb_stam_penalty = 1.5	//Uses a modifer instead of a flat addition, less than weapons no matter what rn. 50% extra stam cost basically.
	if(isliving(A))
		var/mob/living/L = A
		if(!used_intent.noaa)
			playsound(get_turf(src), pick(GLOB.unarmed_swingmiss), 100, FALSE)
//			src.emote("attackgrunt")
		if(used_intent.releasedrain)
			stamina_add(ceil(used_intent.releasedrain * rmb_stam_penalty))
		if(L.has_status_effect(/datum/status_effect/buff/clash) && L.get_active_held_item() && ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/IM = L.get_active_held_item()
			H.process_clash(src, IM)
			return
		if(mob_biotypes & MOB_UNDEAD)
			if(L.has_status_effect(/datum/status_effect/buff/necras_vow))
				if(isnull(mind))
					adjust_fire_stacks(5)
					ignite_mob()
				else
					if(prob(30))
						to_chat(src, span_warning("The Undermaiden protects me!"))
						to_chat(L, span_warning("The foul blessing of the Undermaiden hurts us!"))
				adjust_blurriness(2)
				adjustBruteLoss(rand(5, 10))
				apply_status_effect(/datum/status_effect/churned, L)

		if(L.checkmiss(src))
			return
		if(!L.checkdefense(used_intent, src))
			L.attack_hand(src, params)
		return
	else
		var/item_skip = FALSE
		if(isitem(A))
			var/obj/item/I = A
			if(I.w_class < WEIGHT_CLASS_GIGANTIC)
				item_skip = TRUE
		if(!item_skip)
			if(used_intent.releasedrain && !used_intent.type == INTENT_GRAB)
				stamina_add(ceil(used_intent.releasedrain * rmb_stam_penalty))
			if(used_intent.type == INTENT_GRAB)
				var/obj/AM = A
				if(istype(AM) && !AM.anchored)
					start_pulling(A) //add params to grab bodyparts based on loc
					stamina_add(ceil(used_intent.releasedrain * rmb_stam_penalty))
					return
			if(used_intent.type == INTENT_DISARM)
				var/obj/AM = A
				if(istype(AM) && !AM.anchored)
					var/jadded = max(100-(STASTR*10),5)
					if(stamina_add(jadded))
						visible_message(span_info("[src] pushes [AM]."))
						PushAM(AM, MOVE_FORCE_STRONG)
					else
						visible_message(span_warning("[src] pushes [AM]."))
					changeNext_move(CLICK_CD_MELEE)
					return
		A.attack_hand(src, params)
		if(pulling)
			changeNext_move(CLICK_CD_MELEE)

/mob/living/rmb_on(atom/A, params)
	if(stat)
		return

	if(!has_active_hand()) //can't attack without a hand.
		to_chat(src, span_warning("I lack working hands."))
		return

	if(!has_hand_for_held_index(used_hand)) //can't attack without a hand.
		to_chat(src, span_warning("I can't move this hand."))
		return

	if(check_arm_grabbed(used_hand))
		to_chat(src, span_warning("[pulledby] is restraining my arm!"))
		return

	A.attack_right(src, params)

/mob/living/attack_right(mob/user, params)
	. = ..()
//	if(!user.Adjacent(src)) //alreadyu checked in rmb_on
//		return
	user.face_atom(src)
	if(!user.cmode)
		user.changeNext_move(CLICK_CD_RAPID)
		ongive(user, params)

/turf/attack_right(mob/user, params)
	. = ..()
	user.face_atom(src)
	if(!user.cmode)
		user.changeNext_move(CLICK_CD_RAPID)

/atom/proc/ongive(mob/user, params)
	return

/obj/item/ongive(mob/user, params) //take an item if hand is empty
	if(user.get_active_held_item())
		return
	src.attack_hand(user, params)

/mob/living/ongive(mob/living/carbon/human/user, params)
	if(!ishuman(user) || src == user)
		return

	var/obj/item/item_to_offer = user.get_active_held_item()
	if(!item_to_offer)
		return

	if(src == user)
		if(offered_item_ref)
			cancel_offering_item()
		return

	if(user.offered_item_ref)
		var/obj/offered_item = user.offered_item_ref.resolve()
		if(offered_item == item_to_offer)
			user.cancel_offering_item()
		else
			to_chat(user, span_notice("I'm already offering \the [item_to_offer]!"))
		return

	if(HAS_TRAIT(item_to_offer, TRAIT_NODROP))
		to_chat(user, span_warning("I can't offer this."))
		return
	user.offer_item(src, item_to_offer)

/mob/living/MiddleClickOn(atom/A, params)
	..()
	if(!mmb_intent)
		if(!A.Adjacent(src))
			return
		A.MiddleClick(src, params)
	else
		mmb_intent.on_mmb(A, src, params)

//Return TRUE to cancel other attack hand effects that respect it.
/atom/proc/attack_hand(mob/user, params)
	. = FALSE
	if(!(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_ATTACK_HAND))
		add_fingerprint(user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user) & COMPONENT_NO_ATTACK_HAND)
		. = TRUE
	if(interaction_flags_atom & INTERACT_ATOM_ATTACK_HAND)
		. = _try_interact(user)

/atom/proc/attack_right(mob/user)
	. = FALSE
	if(!(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_ATTACK_HAND))
		add_fingerprint(user)
	SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_RIGHT, user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user) & COMPONENT_NO_ATTACK_HAND)
		. = TRUE
	if(interaction_flags_atom & INTERACT_ATOM_ATTACK_HAND)
		. = _try_interact(user)

//Return a non FALSE value to cancel whatever called this from propagating, if it respects it.
/atom/proc/_try_interact(mob/user)
	if(IsAdminGhost(user))		//admin abuse
		return interact(user)
	if(can_interact(user))
		return interact(user)
	return FALSE

/atom/proc/can_interact(mob/user)
	if(!user.can_interact_with(src))
		return FALSE
	if((interaction_flags_atom & INTERACT_ATOM_REQUIRES_DEXTERITY) && !user.IsAdvancedToolUser())
		to_chat(user, span_warning("I don't have the dexterity to do this!"))
		return FALSE
	if(!(interaction_flags_atom & INTERACT_ATOM_IGNORE_INCAPACITATED) && user.incapacitated((interaction_flags_atom & INTERACT_ATOM_IGNORE_RESTRAINED), !(interaction_flags_atom & INTERACT_ATOM_CHECK_GRAB)))
		return FALSE
	return TRUE

/atom/ui_status(mob/user)
	. = ..()
	if(!can_interact(user))
		. = min(., UI_UPDATE)

/atom/movable/can_interact(mob/user)
	. = ..()
	if(!.)
		return
	if(!anchored && (interaction_flags_atom & INTERACT_ATOM_REQUIRES_ANCHORED))
		return FALSE

/atom/proc/interact(mob/user)
	if(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_INTERACT)
		add_hiddenprint(user)
	else
		add_fingerprint(user)
	if(interaction_flags_atom & INTERACT_ATOM_UI_INTERACT)
		return ui_interact(user)
	return FALSE

/*
/mob/living/carbon/human/RestrainedClickOn(atom/A) ---carbons will handle this
	return
*/

/mob/living/carbon/RestrainedClickOn(atom/A)
	return 0

/mob/living/carbon/human/RangedAttack(atom/A, mouseparams)
	. = ..()
	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		if(istype(G) && G.Touch(A,0)) // for magic gloves
			return
	if(!used_intent.noaa && ismob(A))
//		playsound(src, pick(GLOB.unarmed_swingmiss), 100, FALSE)
		do_attack_animation(A, visual_effect_icon = used_intent.animname)
		changeNext_move(used_intent.clickcd)
//		src.emote("attackgrunt")
		playsound(get_turf(src), used_intent.miss_sound, 100, FALSE)
		if(used_intent.miss_text)
			visible_message(span_warning("[src] [used_intent.miss_text]!"), \
							span_warning("I [used_intent.miss_text]!"))
		aftermiss()

//	if(isturf(A) && get_dist(src,A) <= 1) //move this to grab inhand item being used on an empty tile
//		src.Move_Pulled(A)
//		return

/*
	Animals & All Unspecified
*/
/mob/living/UnarmedAttack(atom/A)
	if(!isliving(A))
		if(used_intent.type == INTENT_GRAB)
			var/obj/structure/AM = A
			if(istype(AM) && !AM.anchored)
				start_pulling(A) //add params to grab bodyparts based on loc
				return
		if(used_intent.type == INTENT_DISARM)
			var/obj/structure/AM = A
			if(istype(AM) && !AM.anchored)
				var/jadded = max(100-(STASTR*10),5)
				if(stamina_add(jadded))
					visible_message(span_info("[src] pushes [AM]."))
					PushAM(AM, MOVE_FORCE_STRONG)
				else
					visible_message(span_warning("[src] pushes [AM]."))
				return
	A.attack_animal(src)

/atom/proc/attack_animal(mob/user)
	SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_ANIMAL, user)

/mob/living/RestrainedClickOn(atom/A)
	return

/*
	Monkeys
*/
/mob/living/carbon/monkey/UnarmedAttack(atom/A)
	A.attack_paw(src)

/atom/proc/attack_paw(mob/user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_PAW, user) & COMPONENT_NO_ATTACK_HAND)
		return TRUE
	return FALSE

/*
	Monkey RestrainedClickOn() was apparently the
	one and only use of all of the restrained click code
	(except to stop you from doing things while handcuffed);
	moving it here instead of various hand_p's has simplified
	things considerably
*/
/mob/living/carbon/monkey/RestrainedClickOn(atom/A)
	if(..())
		return
	if(used_intent.type != INTENT_HARM || !ismob(A))
		return
	if(is_muzzled())
		return
	var/mob/living/carbon/ML = A
	if(istype(ML))
		var/dam_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
		var/obj/item/bodypart/affecting = null
		if(ishuman(ML))
			var/mob/living/carbon/human/H = ML
			affecting = H.get_bodypart(ran_zone(dam_zone))
		var/armor = ML.run_armor_check(affecting, "stab")
		if(prob(75))
			ML.apply_damage(rand(1,3), BRUTE, affecting, armor)
			ML.visible_message(span_danger("[name] bites [ML]!"), \
							span_danger("[name] bites you!"), span_hear("I hear a chomp!"), COMBAT_MESSAGE_RANGE, name)
			to_chat(name, span_danger("I bite [ML]!"))
			if(armor >= 2)
				return
		else
			ML.visible_message(span_danger("[src]'s bite misses [ML]!"), \
							span_danger("I avoid [src]'s bite!"), span_hear("I hear jaws snapping shut!"), COMBAT_MESSAGE_RANGE, src)
			to_chat(src, span_danger("My bite misses [ML]!"))

/*
	Brain
*/

/mob/living/brain/UnarmedAttack(atom/A)//Stops runtimes due to attack_animal being the default
	return

/*
	Simple animals
*/

/mob/living/simple_animal/UnarmedAttack(atom/A, proximity)
	if(!dextrous)
		return ..()
	if(!ismob(A))
		A.attack_hand(src)
		update_inv_hands()


/*
	Hostile animals
*/

/mob/living/simple_animal/hostile/UnarmedAttack(atom/A)
	target = A
	if(dextrous && !ismob(A))
		..()
	else
		AttackingTarget(A)



/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/dead/new_player/ClickOn()
	return
