
/obj/item/bodypart/proc/can_dismember(obj/item/I)
	return dismemberable

/obj/item/bodypart/proc/can_disable(obj/item/I)
	return disableable

/obj/item/bodypart
	/// Wound we get when surgically reattached
	var/attach_wound = /datum/wound/artery/reattachment
	/// Wound we leave on the chest when violently dismembered
	var/dismember_wound
	/// Sound we make when violently dismembered
	var/list/dismemsound = list(
		'sound/combat/dismemberment/dismem (1).ogg',
		'sound/combat/dismemberment/dismem (2).ogg',
		'sound/combat/dismemberment/dismem (3).ogg',
		'sound/combat/dismemberment/dismem (5).ogg',
		'sound/combat/dismemberment/dismem (6).ogg',
	)

//Dismember a limb
/obj/item/bodypart/proc/dismember(dam_type = BRUTE, bclass = BCLASS_CUT, mob/living/user, zone_precise = src.body_zone, damage = 0, vorpal = FALSE)
	if(!owner)
		return FALSE
	var/mob/living/carbon/C = owner
	if(!dismemberable)
		return FALSE
	if(user && (body_zone == BODY_ZONE_HEAD))
		if(zone_precise != BODY_ZONE_PRECISE_NECK)
			return FALSE
		if(!HAS_TRAIT(C, TRAIT_CRITICAL_WEAKNESS) && !HAS_TRAIT(C, TRAIT_EASYDISMEMBER))	//People with these traits can be decapped standing, or buckled, or however.
			var/has_mind = TRUE  // DEBUG: Temporarily forced to TRUE for testing
			var/not_buckled = !C.buckled

			// Check if currently standing OR within grace period after being knocked down
			var/can_stand = (C.mobility_flags & MOBILITY_STAND)
			if(!can_stand && C.mob_timers && C.mob_timers["last_standing"])
				// Within 2 seconds of being knocked down? Still count as standing
				if(world.time < C.mob_timers["last_standing"] + STANDING_DECAP_GRACE_PERIOD)
					can_stand = TRUE

			if(has_mind && can_stand && not_buckled) //Only allows upright decapitations if it's not a player. Unless they're buckled.
				return FALSE

	if(body_zone != BODY_ZONE_HEAD)
		var/mob/living/carbon/human/victim = owner
		var/d_type = "slash"
		if(victim.run_armor_check(zone_precise, d_type, damage = damage))
			to_chat(victim, span_warning("My armour just saved me from losing my [C.get_bodypart(body_zone).name]!"))
			return FALSE

	if(C.status_flags & GODMODE)
		return FALSE
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return FALSE

	if(SEND_SIGNAL(src, COMSIG_MOB_DISMEMBER, src) & COMPONENT_CANCEL_DISMEMBER)
		return FALSE //signal handled the dropping
	
	if(C.try_resist_critical())
		C.visible_message(span_danger("Critical resistance! [C]'s [src.name] hangs on by a thread!</span>"))
		return FALSE

	var/obj/item/bodypart/affecting = C.get_bodypart(BODY_ZONE_CHEST)
	if(affecting && dismember_wound)
		affecting.add_wound(dismember_wound)
	playsound(C, pick(dismemsound), 50, FALSE, -1)

	var/stress2give = /datum/stressevent/viewdismember
	var/guillotine_execution = FALSE
	if(C.buckled)
		if(istype(C.buckled, /obj/structure/guillotine))
			guillotine_execution = TRUE
		if(istype(C.buckled, /obj/structure/fluff/psycross))
			if(C.real_name in GLOB.excommunicated_players)
				stress2give = /datum/stressevent/viewsinpunish

	if(body_zone == BODY_ZONE_HEAD)
		// decaps should happen in two phases: the first one inflicts a spinal column sever, killing them instantly.
		// if they're already spinal-severed, THEN the head is removed.
		// extra note: we only do this for mobs with a mind, aka not NPCS. npcs always get insta-decapped as before
		if (owner?.client && !vorpal && !guillotine_execution && two_stage_death && !grievously_wounded)
			if (owner?.construct)
				C.visible_message(span_danger("<b>[C]'s wrought skull is <span class='crit'>CLEFT NIGH IN TWAIN</span> by a fearsome blow, crumbling into a <span class='crit'>CLOUD of DUST!</span></b>"))
				C.death()
				return
			
			if (skeletonized)
				C.visible_message(span_danger("<b>[C]'s bony skull is <span class='crit'>MULCHED</span> by a fearsome blow, spalling into a <span class='crit'>CLOUD of SHARDS!</span></b>"))
				C.death()
				return
			else
				C.visible_message(span_danger("<B>[C] is <span class='crit'>[pick("ENDED", "SLAIN", "SLAUGHTERED","MURDERED","SNUFFED","BUTCHERED","FELLED","FINISHED","FRAGGED")]</span> as their ravaged neck <span class='crit'>BLOSSOMS</span> into petals of <span class='crit'>GORE and BONE!</span></B>"))
				add_wound(/datum/wound/grievous/pre_decapitation) // this causes a bigass wound, marks the limb as greviously wounded and instantly kills the affected user.
				return
		else
			// we're greviously wounded OR we don't give a shit about two-stage death (guillotines, npcs, etc)
			C.visible_message(span_danger("<B>[C] is [pick("BRUTALLY","VIOLENTLY","BLOODILY","MESSILY")] DECAPITATED!</B>"))
	else
		C.visible_message(span_danger("<B>The [src.name] is [pick("torn off", "sundered", "severed", "separated", "unsewn")]!</B>"))

	if(!HAS_TRAIT(C, TRAIT_NOPAIN))
		C.emote("painscream")

	if(!(NOBLOOD in C.dna?.species?.species_traits))
		add_mob_blood(C)

	if(stress2give && C.mind) //Shouldn't be freaking out over a boglin getting their shit rocked.
		for(var/mob/living/carbon/CA in hearers(world.view, C))
			if(CA != C && !HAS_TRAIT(CA, TRAIT_BLIND))
				if(stress2give == /datum/stressevent/viewdismember)
					if(HAS_TRAIT(CA, TRAIT_STEELHEARTED))
						continue
				CA.add_stress(stress2give)
	// Ensure grabbedby is a list so it can be properly .Cut()'d
	grabbedby = SANITIZE_LIST(grabbedby)
	if(grabbedby)
		if(dam_type != BURN)
			for(var/obj/item/grabbing/grab in grabbedby)
				if(grab.grab_state != GRAB_AGGRESSIVE)
					continue

				var/mob/living/carbon/human = grab.grabbee
				var/hand_index = human.get_held_index_of_item(grab)
				human.dropItemToGround(grab)
				drop_limb()
				human.put_in_hand(src, hand_index)

				if(grabbedby)
					grabbedby.Cut()
				return TRUE

		if(grabbedby)
			grabbedby.Cut()

	if(length(wounds))
		for(var/datum/wound/wound in wounds)
			remove_wound(wound.type)


	drop_limb()
	if(dam_type == BURN)
		burn()
		return TRUE

	var/turf/location = C.loc
	if(istype(location))
		C.add_splatter_floor(location)
		C.add_splatter_wall(user, location, force = 2, spill_amount = 3) //Garunteed at least 2 tile distance of blood spattering on the walls, and up to 3 walls to splat.
	var/direction = pick(GLOB.cardinals)
	var/t_range = rand(2,max(throw_range/2, 2))
	var/turf/target_turf = get_turf(src)
	for(var/i in 1 to t_range-1)
		var/turf/new_turf = get_step(target_turf, direction)
		if(!new_turf)
			break
		target_turf = new_turf
		if(new_turf.density)
			break
	throw_at(target_turf, throw_range, throw_speed)
	owner = C
	return TRUE

/obj/item/bodypart/chest/dismember(dam_type = BRUTE, bclass = BCLASS_CUT, mob/living/user, zone_precise = src.body_zone, damage = 0, vorpal = FALSE)
	if(!owner)
		return FALSE
	var/mob/living/carbon/C = owner
	if(!dismemberable)
		return FALSE
	if(C.status_flags & GODMODE)
		return FALSE
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return FALSE
	add_wound(/datum/wound/slash/disembowel)
	return TRUE

//limb removal. The "special" argument is used for swapping a limb with a new one without the effects of losing a limb kicking in.
/obj/item/bodypart/proc/drop_limb(special)
	if(!owner)
		return FALSE

	var/atom/drop_location = owner.drop_location()
	var/mob/living/carbon/was_owner = owner
	update_limb(dropping_limb = TRUE)

	if(length(wounds))
		var/list/stored_wounds = list()
		for(var/datum/wound/wound as anything in wounds)
			if(wound)
				wound.remove_from_bodypart()
				if(wound.qdel_on_droplimb)
					qdel(wound)
				else
					stored_wounds += wound //store for later when the limb is reattached
		wounds = stored_wounds
	//if we had an ongoing surgery on this limb, we stop it
	for(var/body_zone in was_owner.surgeries)
		if(check_zone(body_zone) != body_zone)
			continue
		was_owner.surgeries -= body_zone
	for(var/obj/item/embedded in embedded_objects)
		remove_embedded_object(embedded)
	if(bandage)
		if(drop_location)
			bandage.forceMove(drop_location)
		else
			qdel(bandage)
		bandage = null

	if(!special)
		for(var/obj/item/organ/organ as anything in was_owner.internal_organs) //internal organs inside the dismembered limb are dropped.
			var/org_zone = check_zone(organ.zone)
			if(org_zone != body_zone)
				continue
			organ.transfer_to_limb(src, was_owner)

	if(held_index)
		was_owner.dropItemToGround(owner.get_item_for_held_index(held_index), force = TRUE)
		was_owner.hand_bodyparts[held_index] = null

	if(organ_slowdown)
		was_owner.remove_movespeed_modifier("[src.type]_slow", update = TRUE)
	was_owner.bodyparts -= src
	owner = null

	update_icon_dropped()
	was_owner.update_health_hud() //update the healthdoll
	was_owner.update_body()
	was_owner.update_hair()
	was_owner.update_mobility()

	// drop_location = null happens when a "dummy human" used for rendering icons on prefs screen gets its limbs replaced.
	if(!drop_location)
		qdel(src)
		return TRUE

	// pseudoparts shouldn't have organs, but just in case
	if(is_pseudopart)
		drop_organs(was_owner)
		qdel(src)
		return TRUE

	forceMove(drop_location)
	return TRUE

//when a limb is dropped, the internal organs are removed from the mob and put into the limb
/obj/item/organ/proc/transfer_to_limb(obj/item/bodypart/LB, mob/living/carbon/C)
	Remove(C)
	forceMove(LB)
	return TRUE

/obj/item/organ/brain/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	Remove(C) //Changeling brain concerns are now handled in Remove
	forceMove(LB)
	if(istype(LB))
		LB.brain = src
	if(brainmob)
		LB.brainmob = brainmob
		LB.brainmob.forceMove(LB)
		LB.brainmob.stat = DEAD
	brainmob = null
	return TRUE

/obj/item/organ/eyes/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	if(istype(LB))
		LB.eyes = src
	return ..()

/obj/item/organ/ears/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	if(istype(LB))
		LB.ears = src
	return ..()

/obj/item/organ/tongue/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	if(istype(LB))
		LB.tongue = src
	return ..()

/obj/item/bodypart/chest/drop_limb(special)
	if(special)
		return ..()
	return FALSE

/obj/item/bodypart/r_arm/drop_limb(special)
	var/mob/living/carbon/C = owner
	. = ..()
	if(C && !special)
		if(C.handcuffed)
			C.handcuffed.forceMove(drop_location())
			C.handcuffed.dropped(C)
			C.handcuffed = null
			C.update_handcuffed()
		if(C.hud_used)
			var/atom/movable/screen/inventory/hand/R = C.hud_used.hand_slots["[held_index]"]
			if(R)
				R.update_icon()
		if(C.gloves && (C.get_num_arms(FALSE) < 1))
			C.dropItemToGround(C.gloves, force = TRUE)
		C.update_inv_gloves() //to remove the bloody hands overlay
		C.update_inv_armor()


/obj/item/bodypart/l_arm/drop_limb(special)
	var/mob/living/carbon/C = owner
	. = ..()
	if(C && !special)
		if(C.handcuffed)
			C.handcuffed.forceMove(drop_location())
			C.handcuffed.dropped(C)
			C.handcuffed = null
			C.update_handcuffed()
		if(C.hud_used)
			var/atom/movable/screen/inventory/hand/L = C.hud_used.hand_slots["[held_index]"]
			if(L)
				L.update_icon()
		if(C.gloves && (C.get_num_arms(FALSE) < 1))
			C.dropItemToGround(C.gloves, force = TRUE)
		C.update_inv_gloves() //to remove the bloody hands overlay
		C.update_inv_armor()

/obj/item/bodypart/r_leg/drop_limb(special)
	var/mob/living/carbon/C = owner
	. = ..()
	if(C && !special)
		if(C.legcuffed)
			C.legcuffed.forceMove(C.drop_location()) //At this point bodypart is still in nullspace
			C.legcuffed.dropped(C)
			C.legcuffed = null
			C.update_inv_legcuffed()
		if(C.shoes && (C.get_num_legs(FALSE) < 1))
			C.dropItemToGround(C.shoes, force = TRUE)
		C.update_inv_shoes()
		C.update_inv_pants()

/obj/item/bodypart/l_leg/drop_limb(special) //copypasta
	var/mob/living/carbon/C = owner
	. = ..()
	if(C && !special)
		if(C.legcuffed)
			C.legcuffed.forceMove(C.drop_location())
			C.legcuffed.dropped(C)
			C.legcuffed = null
			C.update_inv_legcuffed()
		if(C.shoes && (C.get_num_legs(FALSE) < 1))
			C.dropItemToGround(C.shoes, force = TRUE)
		C.update_inv_shoes()
		C.update_inv_pants()

/obj/item/bodypart/taur/drop_limb(special) //copypasta
	var/mob/living/carbon/C = owner
	. = ..()
	if(C && !special)
		if(C.legcuffed)
			C.legcuffed.forceMove(C.drop_location())
			C.legcuffed.dropped(C)
			C.legcuffed = null
			C.update_inv_legcuffed()
		if(C.shoes && (C.get_num_legs(FALSE) < 1))
			C.dropItemToGround(C.shoes, force = TRUE)
		C.update_inv_shoes()
		C.update_inv_pants()

/obj/item/bodypart/head/drop_limb(special)
	if(!special)
		//Drop all worn head items
		var/list/worn_items = list(
			owner.get_item_by_slot(SLOT_HEAD),
			owner.get_item_by_slot(SLOT_GLASSES),
			// owner.get_item_by_slot(SLOT_NECK), // We can still equip things in the neck, don't drop it.
			owner.get_item_by_slot(SLOT_WEAR_MASK),
			owner.get_item_by_slot(SLOT_MOUTH),
		)
		for(var/obj/item/worn_item in worn_items)
			owner.dropItemToGround(worn_item, force = TRUE)

//	owner.ghostize(0)
//	if(brainmob)
//		brainmob.ghostize(0)

	qdel(owner.GetComponent(/datum/component/creamed)) //clean creampie overlay

	name = "[owner.real_name]'s head"
	. = ..()

//Attach a limb to a human and drop any existing limb of that type.
/obj/item/bodypart/proc/replace_limb(mob/living/carbon/C, special)
	if(!istype(C))
		return
	var/obj/item/bodypart/O = C.get_bodypart(body_zone)
	if(O)
		O.drop_limb(1)
	return attach_limb(C, special)

/obj/item/bodypart/head/replace_limb(mob/living/carbon/C, special)
	if(!istype(C))
		return
	var/obj/item/bodypart/head/O = C.get_bodypart(body_zone)
	if(O)
		if(!special)
			return
		else
			O.drop_limb(1)
	return attach_limb(C, special)

/obj/item/bodypart/proc/attach_limb(mob/living/carbon/C, special)
	moveToNullspace()
	owner = C
	C.bodyparts += src
	if(held_index)
		if(held_index > C.hand_bodyparts.len)
			C.hand_bodyparts.len = held_index
		C.hand_bodyparts[held_index] = src
		if(C.dna.species.mutanthands && !is_pseudopart)
			C.put_in_hand(new C.dna.species.mutanthands(), held_index)
		if(C.hud_used)
			var/atom/movable/screen/inventory/hand/hand = C.hud_used.hand_slots["[held_index]"]
			if(hand)
				hand.update_icon()
		C.update_inv_gloves()

	if(special) //non conventional limb attachment
		//if we had an ongoing surgery to attach a new limb, we stop it.
		for(var/body_zone in C.surgeries)
			if(check_zone(body_zone) != body_zone)
				continue
			C.surgeries -= body_zone

	for(var/obj/item/organ/stored_organ in src)
		stored_organ.Insert(C)

	for(var/datum/wound/wound as anything in wounds)
		if(wound)
			wounds -= wound
			wound.apply_to_bodypart(src, silent = TRUE, crit_message = FALSE)

	var/obj/item/bodypart/affecting = C.get_bodypart(BODY_ZONE_CHEST)
	if(affecting && dismember_wound)
		affecting.remove_wound(dismember_wound)

	update_bodypart_damage_state()

	if(organ_slowdown)
		C.add_movespeed_modifier("[src.type]_slow", update=TRUE, priority=100, flags=NONE, override=FALSE, multiplicative_slowdown=organ_slowdown, movetypes=GROUND, blacklisted_movetypes=NONE, conflict=FALSE)
	C.updatehealth()
	C.update_body()
	C.update_hair()
	C.update_damage_overlays()
	C.update_mobility()
	return TRUE

/obj/item/bodypart/head/attach_limb(mob/living/carbon/C, special)
	//Transfer some head appearance vars over
	if(brain)
		if(brainmob)
			brainmob.forceMove(brain) //Throw mob into brain.
			brain.brainmob = brainmob
			brainmob = null //Set head brainmob var to null
		brain.Insert(C) //Now insert the brain proper
		brain = null //No more brain in the head

	if(tongue)
		tongue = null
	if(ears)
		ears = null
	if(eyes)
		eyes = null

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.hair_color = hair_color
		H.hairstyle = hairstyle
		H.facial_hair_color = facial_hair_color
		H.facial_hairstyle = facial_hairstyle
		H.lip_style = lip_style
		H.lip_color = lip_color
	if(real_name)
		C.real_name = real_name
	real_name = ""
	name = initial(name)

	return ..()

//Regenerates all limbs. Returns amount of limbs regenerated
/mob/living/proc/regenerate_limbs(noheal, excluded_limbs)
	return 0

/mob/living/carbon/regenerate_limbs(noheal, list/excluded_limbs)
	var/list/limb_list = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
	if(excluded_limbs)
		limb_list -= excluded_limbs
	for(var/Z in limb_list)
		. += regenerate_limb(Z, noheal)

/mob/living/proc/regenerate_limb(limb_zone, noheal)
	return

/mob/living/carbon/regenerate_limb(limb_zone, noheal)
	var/obj/item/bodypart/L
	if(get_bodypart(limb_zone))
		return 0
	L = newBodyPart(limb_zone, 0, 0)
	if(L)
		if(!noheal)
			L.brute_dam = 0
			L.burn_dam = 0
			L.brutestate = 0
			L.burnstate = 0

		L.attach_limb(src, 1)
		return 1
