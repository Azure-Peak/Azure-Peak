/obj/effect/proc_holder/spell/targeted/churn
	name = "Churn Undead"
	desc = "Stuns and explodes undead."
	range = 4	//Way lower, halved.
	overlay_state = "necra"
	releasedrain = 30
	chargetime = 2 SECONDS
	recharge_time = 60 SECONDS
	max_targets = 0
	cast_without_targets = TRUE
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("The Undermaiden rebukes!")
	invocation_type = "shout" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 50

/obj/effect/proc_holder/spell/targeted/churn/cast(list/targets,mob/living/user = usr)
	var/prob2explode = 100
	if(user && user.mind)
		prob2explode = 0
		for(var/i in 1 to user.get_skill_level(/datum/skill/magic/holy))
			prob2explode += 30
	for(var/mob/living/L in targets)
		var/isvampire = FALSE
		var/iszombie = FALSE
		if(L.stat == DEAD)
			continue
		if(L.mind)
			var/datum/antagonist/vampire/V = L.mind.has_antag_datum(/datum/antagonist/vampire)
			if(V && !SEND_SIGNAL(L, COMSIG_DISGUISE_STATUS))
				isvampire = TRUE
			if(L.mind.has_antag_datum(/datum/antagonist/zombie))
				iszombie = TRUE
			if(L.mind.special_role == "Vampire Lord" || L.mind.special_role == "Lich")	//Won't detonate Lich's or VLs but will fling them away.
				user.visible_message(span_warning("[L] overpowers being churned!"), span_userdanger("[L] is too strong, I am churned!"))
				user.Stun(50)
				user.throw_at(get_ranged_target_turf(user, get_dir(user,L), 7), 7, 1, L, spin = FALSE)
				return
		if((L.mob_biotypes & MOB_UNDEAD) || isvampire || iszombie)
			if(spell_guard_check(L, TRUE))
				L.visible_message(span_warning("[L] resists being churned!"))
				continue
			var/vamp_prob = prob2explode
			if(isvampire)
				vamp_prob -= 59
			if(prob(vamp_prob))
				L.visible_message("<span class='warning'>[L] has been churned by Necra's grip!", "<span class='danger'>I've been churned by Necra's grip!")
				explosion(get_turf(L), light_impact_range = 1, flame_range = 1, smoke = FALSE)
				L.Stun(50)
			else
				L.visible_message(span_warning("[L] resists being churned!"), span_userdanger("I resist being churned!"))
	..()
	return TRUE


/*
	DEATH'S DOOR
*/


/obj/effect/proc_holder/spell/invoked/deaths_door
	name = "Death's Door"
	desc = "Opens a one-way portal into a realm on the edge of death, People can be dragged into the portal to prevent their decay. Undead with be set aflame. Those whom enter the domain will find their Will to continue heavily weaken. <br>Necras domain can be left through a portal within to a shrine, or a grave/psycross marked with necra's sight."
	range = 6
	no_early_release = TRUE
	chargedrain = 0
	overlay_state = "deathdoor"
	charging_slowdown = 1
	chargetime = 2 SECONDS
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE
	sound = 'sound/misc/deadbell.ogg'
	invocations = list("Necra, show me my destination!")
	invocation_type = "shout"
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/deaths_door/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		return FALSE
	
	if(istype(get_area(user), /area/rogue/indoors/ravoxarena))
		to_chat(user, span_userdanger("I tried to escape, but something rebukes me! There's no escape until the end of the challenge!"))
		revert_cast()
		return FALSE

	if(locate(/obj/structure/deaths_door_portal) in T)
		to_chat(user, span_warning("A gate already stands here."))
		return FALSE

	// Ensure the caster has Necra's Sight so they can mark graves/psycrosses
	if(user && user.mind && !user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/necras_sight))
		user.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/necras_sight)
		to_chat(user, span_notice("A cold clarity fills your vision as Necra opens your sight."))

	new /obj/structure/deaths_door_portal(T, user)
	return TRUE

/*
	SOUL SPEAK
*/


/obj/effect/proc_holder/spell/targeted/soulspeak
	name = "Speak with Soul"
	range = 5
	overlay_state = "speakwithdead"
	releasedrain = 30
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("She-Below brooks thee respite, be heard, wanderer.")
	invocation_type = "whisper" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/targeted/soulspeak/cast(list/targets,mob/user = usr)
	var/mob/living/carbon/spirit/capturedsoul = null
	var/list/souloptions = list()
	var/list/itemstore = list()
	for(var/mob/living/carbon/spirit/S in GLOB.mob_list)
		if(S.summoned)
			continue
		if(!S.client)
			continue
		souloptions += S.livingname
	var/pickedsoul = input(user, "Which wandering soul shall I commune with?", "Available Souls") as null|anything in souloptions
	if(!pickedsoul)
		to_chat(user, span_warning("I was unable to commune with a soul."))
		return
	for(var/mob/living/carbon/spirit/P in GLOB.mob_list)
		if(P.livingname == pickedsoul)
			to_chat(P, "<font color='blue'>You feel yourself being pulled out of the Underworld.</font>")
			sleep(2 SECONDS)
			if(QDELETED(P) || P.summoned)
				to_chat(user, "<font color='blue'>Your connection to the soul suddenly disappears!</font>")
				return
			capturedsoul = P
			break
	if(capturedsoul)
		for(var/obj/item/I in capturedsoul.held_items) // this is still ass
			capturedsoul.temporarilyRemoveItemFromInventory(I, force = TRUE)
			itemstore += I.type
			qdel(I)
		capturedsoul.loc = user.loc
		capturedsoul.summoned = TRUE
		capturedsoul.beingmoved = TRUE
		capturedsoul.invisibility = INVISIBILITY_OBSERVER
		capturedsoul.status_flags |= GODMODE
		capturedsoul.Stun(61 SECONDS)
		capturedsoul.density = FALSE
		addtimer(CALLBACK(src, PROC_REF(return_soul), user, capturedsoul, itemstore), 60 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(return_soul_warning), user, capturedsoul), 50 SECONDS)
		to_chat(user, "<font color='blue'>I feel a cold chill run down my spine, a ghastly presence has arrived.</font>")
		return ..()

/obj/effect/proc_holder/spell/targeted/soulspeak/proc/return_soul_warning(mob/user, mob/living/carbon/spirit/soul)
	if(!QDELETED(user))
		to_chat(user, span_warning("The soul is being pulled away..."))
	if(!QDELETED(soul))
		to_chat(soul, span_warning("I'm starting to be pulled away..."))

/obj/effect/proc_holder/spell/targeted/soulspeak/proc/return_soul(mob/user, mob/living/carbon/spirit/soul, list/itemstore)
	to_chat(user, "<font color='blue'>The soul returns to the Underworld.</font>")
	if(QDELETED(soul))
		return
	to_chat(soul, "<font color='blue'>You feel yourself being transported back to the Underworld.</font>")
	soul.drop_all_held_items()
	for(var/obj/effect/landmark/underworld/A in shuffle(GLOB.landmarks_list))
		soul.loc = A.loc
		for(var/I in itemstore)
			soul.put_in_hands(new I())
		break
	soul.beingmoved = FALSE
	soul.fully_heal(FALSE)
	soul.invisibility = initial(soul.invisibility)
	soul.status_flags &= ~GODMODE
	soul.density = initial(soul.density)
