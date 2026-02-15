/mob/living/carbon/spirit
	name = "Wanderer"
	verb_say = "moans"
	initial_language_holder = /datum/language_holder/universal
	icon = 'icons/roguetown/underworld/enigma_husks.dmi'
	icon_state = "hollow"
	gender = NEUTER
	pass_flags = PASSTABLE
	var/owned_lantern = null
	mob_biotypes = MOB_SPIRIT|MOB_HUMANOID
	gib_type = /obj/effect/decal/cleanable/blood/gibs
	bodyparts = list(/obj/item/bodypart/chest/spirit, /obj/item/bodypart/head/spirit, /obj/item/bodypart/l_arm/spirit,
					 /obj/item/bodypart/r_arm/spirit, /obj/item/bodypart/r_leg/spirit, /obj/item/bodypart/l_leg/spirit)
	hud_type = /datum/hud/spirit
	density = FALSE // ghosts can pass through other mobs
	var/paid = FALSE
	var/beingmoved = FALSE
	var/livingname = null
	var/summoned = FALSE

/obj/item/bodypart/chest/spirit
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"

/obj/item/bodypart/head/spirit
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"

/obj/item/bodypart/l_arm/spirit
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"

/obj/item/bodypart/l_leg/spirit
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"

/obj/item/bodypart/r_arm/spirit
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"

/obj/item/bodypart/r_leg/spirit
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"

/mob/living/carbon/spirit/Initialize(mapload, cubespawned=FALSE, mob/spawner)
	set_light(2, 2, l_color= "#547fa4")
	coin_upkeep()
	verbs += /mob/living/proc/mob_sleep
	verbs += /mob/living/proc/lay_down
	ADD_TRAIT(src, TRAIT_PACIFISM, TRAIT_GENERIC)
	var/first_part = pick("Sorrowful", "Forlorn", "Regretful", "Piteous", "Rueful", "Dejected", "Desolate", "Mournful", "Melancholic", "Woeful")
	var/second_part = pick("Wanderer", "Traveler", "Pilgrim", "Vagabond", "Nomad", "Wayfarer", "Spirit", "Specter", "Wraith", "Phantom")
	name = first_part + " " + second_part

	//initialize limbs
	create_bodyparts()
	create_internal_organs()
	. = ..()
	var/L = new /obj/item/flashlight/lantern/shrunken(src.loc)
	owned_lantern = L
	put_in_hands(L)
	AddComponent(/datum/component/footstep, FOOTSTEP_MOB_BAREFOOT, 1, 2)
	addtimer(CALLBACK(src, PROC_REF(give_patron_toll)), 10 SECONDS) // For you, no charge.

/mob/living/carbon/spirit/ignite_mob() // Override so they don't catch on fire.
	return

/mob/living/carbon/spirit/proc/give_patron_toll()
	if(QDELETED(src) || paid)
		return
	for(var/item in held_items)
		if(istype(item, /obj/item/underworld/coin))
			return
	put_in_hands(new /obj/item/underworld/coin/notracking(get_turf(src)))
	if(patron)
		to_chat(src, span_danger("Your suffering has not gone unnoticed, [patron] has rewarded you with your toll."))
	else
		to_chat(src, span_danger("Your suffering has not gone unnoticed, your patron has rewarded you with your toll."))
	playsound(src, 'sound/combat/caught.ogg', 80, TRUE, -1)

/mob/living/carbon/spirit/create_internal_organs()
	internal_organs += new /obj/item/organ/lungs
	internal_organs += new /obj/item/organ/heart
	internal_organs += new /obj/item/organ/brain
	internal_organs += new /obj/item/organ/tongue
	internal_organs += new /obj/item/organ/eyes
	internal_organs += new /obj/item/organ/ears
	internal_organs += new /obj/item/organ/liver
	internal_organs += new /obj/item/organ/stomach

	visible_organs += new /obj/item/organ/eyes
	visible_organs += new /obj/item/organ/ears
	..()

/mob/living/carbon/spirit/Destroy()
	if(owned_lantern)
		qdel(owned_lantern)
	return ..()

/mob/living/carbon/spirit/updatehealth()
	. = ..()
	var/slow = 0
	if(!HAS_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN))
		var/health_deficiency = (maxHealth - health)
		if(health_deficiency >= 45)
			slow += (health_deficiency / 25)
	add_movespeed_modifier(MOVESPEED_ID_MONKEY_HEALTH_SPEEDMOD, TRUE, 100, override = TRUE, multiplicative_slowdown = slow)

/mob/living/carbon/spirit/Stat()
	..()
	if(statpanel("Status"))
		stat(null, "Intent: [a_intent]")
		stat(null, "Move Mode: [m_intent]")
	return

/mob/living/carbon/spirit/toggle_move_intent(mob/user) // Override so they can't run.
	return

/mob/living/carbon/spirit/toggle_rogmove_intent(intent, silent = FALSE) // Override so they can't run.
	return

/mob/living/carbon/spirit/mmb_intent_change(input as text) // There's no need for them to change MMB intents
	return

/mob/living/carbon/spirit/returntolobby()
	set name = "{RETURN TO LOBBY}"
	set category = "Options"
	set hidden = 1

	if(key)
		GLOB.respawntimes[key] = world.time

	log_game("[key_name(usr)] respawned from underworld")

	to_chat(src, span_info("Returned to lobby successfully."))

	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return
	client.screen.Cut()
	client.screen += client.void
//	stop_all_loops()
	SSdroning.kill_rain(src.client)
	SSdroning.kill_loop(src.client)
	SSdroning.kill_droning(src.client)
	remove_client_colour(/datum/client_colour/monochrome)
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return

	var/mob/dead/new_player/M = new /mob/dead/new_player()
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key
	qdel(src)
	return

/mob/living/carbon/spirit/attack_animal(mob/living/simple_animal/M)
	if(beingmoved)
		return
	beingmoved = TRUE
	to_chat(src, "<B><font size=3 color=red>Your soul is dragged to an infathomably cruel place where it endures severe torment. You've all but given up hope when you feel a presence drag you back to that Forest.</font></B>")
	playsound(src, 'sound/combat/caught.ogg', 80, TRUE, -1)
	for(var/obj/effect/landmark/underworld/A in GLOB.landmarks_list)
		forceMove(A.loc)
	beingmoved = FALSE

///Get the underworld spirit associated with this mob (from the mind)
/mob/proc/get_spirit()
	var/mind_key = key || mind?.key
	if(!mind_key)
		return
	for(var/mob/living/carbon/spirit/spirit in GLOB.carbon_list)
		if((ckey(spirit.key) == ckey(mind_key)) || (ckey(spirit.mind?.key) == ckey(mind_key)))
			return spirit

/mob/living/carbon/spirit/get_spirit()
	return src

/// Proc that will search inside a given atom for any corpses, and return TRUE if it finds one.
/proc/pacify_coffin(atom/movable/coffin, mob/user, deep = TRUE)
	if(!coffin)
		return FALSE
	var/success = FALSE

	if(isliving(coffin))
		if(pacify_corpse(coffin, user))
			success = TRUE

	for(var/mob/living/corpse in coffin)
		if(pacify_corpse(corpse, user))
			success = TRUE

	for(var/obj/item/bodypart/head/head in coffin)
		if(!head.brainmob)
			continue
		if(pacify_corpse(head.brainmob, user))
			success = TRUE

	// If this is a deep search, we will also search the contents of the coffin to pacify
	// (EXCEPT MOBS, SINCE WE HANDLED THOSE)
	if(deep)
		for(var/atom/movable/stuffing in coffin)
			if(isliving(stuffing) || istype(stuffing, /obj/item/bodypart/head))
				continue
			if(pacify_coffin(stuffing, user, deep))
				success = TRUE

	return success

/// Proc responsible for handling the logic for Necran coins, and for verifying that a corpse isn't still alive.
/// Needs to exist to be called by pacify_coffin.
/proc/pacify_corpse(mob/living/corpse, mob/user)
	// Our quick-and-dirty check to make sure they're really dead.
	if((corpse.stat != DEAD))
		return FALSE

	if(ishuman(corpse))
		var/mob/living/carbon/human/human_corpse = corpse
		human_corpse.buried = TRUE
		human_corpse.funeral = TRUE
		if(istype(human_corpse.mouth, /obj/item/roguecoin) && !HAS_TRAIT(corpse, TRAIT_BURIED_COIN_GIVEN))
			var/obj/item/roguecoin/coin = human_corpse.mouth

			if(coin.quantity >= 1) // stuffing their mouth full of a fuck ton of coins wont do shit
				ADD_TRAIT(human_corpse, TRAIT_BURIED_COIN_GIVEN, TRAIT_GENERIC)

				for(var/obj/effect/landmark/underworld/coin_spawn in GLOB.landmarks_list)
					var/turf/fallen = get_turf(coin_spawn)
					fallen = locate(fallen.x + rand(-3, 3), fallen.y + rand(-3, 3), fallen.z)
					new /obj/item/underworld/coin/notracking(fallen)
					fallen.visible_message(span_warning("A coin falls from above!"))
					qdel(human_corpse.mouth)
					human_corpse.update_inv_mouth()

	// If we haven't returned by now, everything looks alright and we return TRUE.
	return TRUE
