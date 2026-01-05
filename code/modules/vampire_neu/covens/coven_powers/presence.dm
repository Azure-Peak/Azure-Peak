/datum/coven/presence
	name = "Presence"
	desc = "Invade the mortal mynd, your words are far mightier than any sword. Subjugate them."
	icon_state = "presence"
	power_type = /datum/coven_power/presence

/datum/coven_power/presence
	name = "Presence power name"
	desc = "Presence power description"

//AWE
/datum/coven_power/presence/awe
	name = "Awe"
	desc = "Make those around you admire you. Should they turn the other cheek, they will face consequences."
	gif = "Awe.gif"

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_HUMAN
	vitae_cost = 100
	range = 4
	multi_activate = TRUE
	cooldown_length = 60 SECONDS

/datum/coven_power/presence/awe/pre_activation_checks(mob/living/target)
	if(!can_affect_target(target))
		return FALSE
	var/mypower = owner.STAINT
	var/mob/living/carbon/human/H = target
	var/theirpower = H.STAINT - 5
	if((theirpower >= mypower))
		to_chat(owner, span_warning("[target]'s mind is too powerful to sway!"))
		return FALSE
	return TRUE

/datum/coven_power/presence/awe/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)
	playsound(target,'sound/villain/wonder.ogg', 40)
	target.apply_status_effect(/datum/status_effect/awestruck, owner)
	if(!owner.cmode)
		to_chat(target, span_love("<b>Come close and look upon me.</b>"))
		owner.say("Look upon me.")
	else
		to_chat(target, span_love("<b>BEHOLD ME!!</b>"))
		owner.say("BEHOLD ME!!")


/datum/coven_power/presence/awe/deactivate(mob/living/carbon/human/target)
	. = ..()
	target?.remove_overlay(MUTATIONS_LAYER)

/datum/coven_power/presence/awe/proc/can_affect_target(mob/living/target)
	if(!istype(target))
		return FALSE
	if(target.stat == DEAD)
		return FALSE
	if(target.clan == owner.clan)
		return FALSE
	if(target.has_status_effect(/datum/status_effect/awestruck))
		return FALSE
	return TRUE

/datum/status_effect/awestruck
	id = "awestruck"
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/awestruck
	var/mob/living/carbon/human/awe_user
	var/mob/living/carbon/human/awe_target

/atom/movable/screen/alert/status_effect/awestruck
	name = "Awestruck"
	desc = "I can hardly take my eyes off them!"
	icon_state = "debuff"

/datum/status_effect/awestruck/on_remove()
	. = ..()
	var/dist = get_dist(awe_target, awe_user)
	if(!awe_target.can_see_cone(awe_user))
		awe_target.playsound_local(awe_target, 'sound/magic/heartbeat.ogg', 100)
		awe_target.Immobilize(4 SECONDS)
		awe_target.freakout_hud_skew()
		awe_target.visible_message("<span class='warning'>[awe_target] goes still for a moment, their movements suddenly halted.</span>", "<span class='warning'>You were just beholding their presence.. Where are they? WHERE ARE THEY!?</span>")
	if(awe_target.can_see_cone(awe_user) && dist > 4)
		awe_target.playsound_local(awe_target, 'sound/magic/heartbeat.ogg', 100)
		awe_target.Immobilize(4 SECONDS)
		awe_target.freakout_hud_skew()
		awe_target.visible_message("<span class='warning'>[awe_target] goes still for a moment, their movements suddenly halted.</span>", "<span class='warning'>Their presence.. you need to be closer, to admire it. YOU NEED TO BE CLOSER!!</span>")

	else
		awe_target.visible_message("[awe_target]'s gaze seemingly returns to normal.", "My gaze can focus again!")

/datum/status_effect/awestruck/on_creation(mob/living/new_owner, mob/living/user)
	awe_user = user
	awe_target = new_owner
	new_owner.visible_message("<span class='warning'>[new_owner] blinks, their gaze going strange for a moment.</span>", "<span class='notice'>You blink, and suddenly [user] is the only thing you feel capable of focusing on.</span>")

	return ..()


//DREAD GAZE
/datum/coven_power/presence/dread_gaze
	name = "Dread Gaze"
	desc = "Incite fear in others through only your words and gaze."

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 4
	vitae_cost = 100

	multi_activate = TRUE
	cooldown_length = 60 SECONDS

/datum/coven_power/presence/dread_gaze/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	to_chat(target, "<span class='userlove'><b>FEAR ME</b></span>")
	owner.say("FEAR ME!!")
	var/datum/cb = CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, step_away_caster), owner)
	for(var/i in 1 to 30)
		addtimer(cb, (i - 1) * target.total_multiplicative_slowdown())
	target.emote("scream")
	target.do_jitter_animation(3 SECONDS)
	to_chat(target, "<span class='userlove'><b>OH GOD, PLEASE SAVE ME!.</b></span>")
	playsound(target,'sound/villain/wonder.ogg', 40)

/datum/coven_power/presence/dread_gaze/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

/mob/living/carbon/human/proc/step_away_caster(mob/living/step_from)
	walk(src, 0)
	if(can_frenzy_move())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_away(src, step_from, 99)

/datum/coven_power/presence/fall
	name = "Kneel"
	desc = "Make those kneel before you."

	level = 3
	research_cost = 2
	vitae_cost = 200
	check_flags = COVEN_CHECK_CAPABLE|COVEN_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 4

	multi_activate = TRUE
	cooldown_length = 1 MINUTES

/datum/coven_power/presence/fall/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	target.Immobilize(3 SECONDS)
	to_chat(target, "<span class='userlove'><b>KNEEL</b></span>")
	to_chat(target, "<span class='userlove'><b>MY NEW GOD!</b></span>")
	playsound(target,'sound/villain/wonder_secret_known.ogg', 40)
	owner.say("KNEEL!!")
	target.set_resting(TRUE, TRUE)

/datum/coven_power/presence/fall/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//SUMMON
/datum/coven_power/presence/summon
	name = "Summon"
	desc = "Keep your friends close, but your enemies closer. Teleport a target to you."

	level = 4
	research_cost = 3
	vitae_cost = 200
	check_flags = COVEN_CHECK_CAPABLE|COVEN_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7
	multi_activate = TRUE
	cooldown_length = 1 MINUTES

/datum/coven_power/presence/summon/activate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	to_chat(target, "<span class='userlove'><b>TO ME</b></span>")
	owner.say("TO ME!!")
	target.Immobilize(1.5 SECONDS)
	new /obj/effect/temp_visual/vamp_summon (get_turf(target))
	new /obj/effect/temp_visual/vamp_summon/end (get_turf(owner))
	addtimer(CALLBACK(src, PROC_REF(finish_teleport), owner, target, get_turf(owner)), 1.5 SECONDS)

/datum/coven_power/presence/summon/proc/finish_teleport(mob/living/user, mob/living/target, turf/target_turf)
	// Teleport subordinate to user
	if(target_turf)
		new /obj/effect/temp_visual/vamp_teleport(get_turf(target))
		target.forceMove(target_turf)

		// Messages
		to_chat(user, "<span class='notice'>You summon [target.real_name] to your location.</span>")
		to_chat(target, "<span class='userdanger'>You are compelled to appear before [user.real_name]!</span>")

		// Announce to nearby clan members
		for(var/mob/living/carbon/human/observer in view(7, user))
			if(observer.clan == user.clan && observer != user && observer != target)
				to_chat(observer, "<span class='info'>[user.real_name] has summoned [target.real_name].</span>")

/datum/coven_power/presence/summon/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

/mob/living/carbon/human/proc/step_toward_caster(mob/living/step_to)
	walk(src, 0)
	if(can_frenzy_move())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_towards(src, step_to, 99)

//MAJESTY
/datum/coven_power/presence/majesty
	name = "Majesty"
	desc = "Become so grand that others find it nearly impossible to disobey or harm you."

	level = 5
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE|COVEN_CHECK_SPEAK
	vitae_cost = 35
	toggled = TRUE
	cooldown_length = 90 SECONDS
	duration_length = 5 SECONDS
	var/list/affected_mobs = list() // Track who's affected by majesty

/datum/coven_power/presence/majesty/activate()
	. = ..()
	if(!.)
		return FALSE

	owner.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	owner.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	owner.apply_overlay(MUTATIONS_LAYER)

	owner.apply_status_effect(/datum/status_effect/majesty_active)

	var/list/nearby_mobs = range(7, owner)
	for(var/mob/living/M in nearby_mobs)
		if(M == owner || !can_affect_target(M))
			continue
		apply_majesty_effect(M)

	to_chat(owner, "<span class='notice'>You radiate an aura of absolute authority and grandeur. Others find themselves compelled to obey.</span>")
	owner.visible_message("<span class='warning'>[owner] seems to become incredibly imposing and majestic!</span>", "<span class='notice'>You feel your presence become overwhelming.</span>")

/datum/coven_power/presence/majesty/on_refresh()
	var/list/nearby_mobs = range(7, owner)
	var/list/checked_mobs = list()
	for(var/mob/living/M in nearby_mobs)
		checked_mobs |= M
		if(M == owner || !can_affect_target(M))
			continue
		apply_majesty_effect(M)

	for(var/mob/living/mob in affected_mobs)
		if(!(mob in checked_mobs))
			remove_majesty_effect(mob)
			affected_mobs -= mob

/datum/coven_power/presence/majesty/deactivate(mob/living/carbon/human/target)
	. = ..()
	owner.remove_overlay(MUTATIONS_LAYER)
	owner.remove_status_effect(/datum/status_effect/majesty_active)

	for(var/mob/living/M in affected_mobs)
		remove_majesty_effect(M)
	affected_mobs.Cut()

	to_chat(owner, "<span class='notice'>Your overwhelming presence fades away.</span>")

/datum/coven_power/presence/majesty/proc/can_affect_target(mob/living/target)
	if(!istype(target))
		return FALSE
	if(target.stat == DEAD)
		return FALSE
	if(target.clan == owner.clan)
		return FALSE
	if(target in affected_mobs)
		return FALSE
	return TRUE

/datum/coven_power/presence/majesty/proc/apply_majesty_effect(mob/living/target)
	if(!can_affect_target(target))
		return

	affected_mobs |= target
	target.apply_status_effect(/datum/status_effect/majesty_compulsion, owner)

	if(prob(70))
		if(target.get_active_held_item())
			target.visible_message("<span class='warning'>[target] seems overwhelmed by [owner]'s presence!</span>")
			target.dropItemToGround(target.get_active_held_item())

		target.stop_pulling()
		if(target.cmode)
			target.cmode = FALSE

/datum/coven_power/presence/majesty/proc/remove_majesty_effect(mob/living/target)
	if(!target)
		return
	target.remove_status_effect(/datum/status_effect/majesty_compulsion)

/datum/status_effect/majesty_active
	id = "majesty_active"
	duration = -1
	alert_type = null

/datum/status_effect/majesty_active/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))

/datum/status_effect/majesty_active/on_remove()
	. = ..()
	UnregisterSignal(owner, list(COMSIG_PARENT_ATTACKBY))

/datum/status_effect/majesty_active/proc/on_attackby(atom/source, obj/item/attacking_item, mob/living/user, params)
	SIGNAL_HANDLER

	if(!user || user == source)
		return

	if(!user.has_status_effect(/datum/status_effect/majesty_compulsion))
		return

	if(prob(60))
		to_chat(user, "<span class='warning'>You find yourself unable to bring yourself to harm [source]! Their presence is too overwhelming!</span>")
		to_chat(source, "<span class='notice'>[user] hesitates, overwhelmed by your majesty.</span>")
		return COMPONENT_NO_AFTERATTACK

/datum/status_effect/majesty_compulsion
	id = "majesty_compulsion"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/majesty_compulsion
	var/mob/living/majesty_user

/datum/status_effect/majesty_compulsion/on_creation(mob/living/new_owner, mob/living/user)
	majesty_user = user
	to_chat(new_owner, span_cultbigbold("You are compelled by an overwhelming presence. You find it nearly impossible to act against them."))
	return ..()

/datum/status_effect/majesty_compulsion/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_ITEM_PRE_ATTACK, PROC_REF(on_pre_attack))
	//RegisterSignal(owner, COMSIG_ITEM_PRE_ATTACK_SECONDARY, PROC_REF(on_pre_attack_secondary))
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(on_say))

	if(owner.mind)
		owner.add_stress(/datum/stressevent/majesty_compelled)

/datum/status_effect/majesty_compulsion/on_remove()
	. = ..()
	UnregisterSignal(owner, list(
		COMSIG_ITEM_PRE_ATTACK,
		//COMSIG_ITEM_PRE_ATTACK_SECONDARY,
		COMSIG_MOB_SAY
	))

	if(owner.mind)
		owner.remove_stress(/datum/stressevent/majesty_compelled)

/datum/status_effect/majesty_compulsion/proc/on_pre_attack(obj/item/source, atom/target, mob/user, params)
	SIGNAL_HANDLER

	if(target != majesty_user || user != owner)
		return

	if(prob(80))
		to_chat(user, "<span class='warning'>You cannot bring yourself to attack [majesty_user]! Their presence is too overwhelming!</span>")
		return COMPONENT_NO_ATTACK

/datum/status_effect/majesty_compulsion/proc/on_pre_attack_secondary(obj/item/source, atom/target, mob/user, params)
	SIGNAL_HANDLER

	if(target != majesty_user || user != owner)
		return

	if(prob(80))
		to_chat(user, "<span class='warning'>You cannot bring yourself to attack [majesty_user]! Their presence is too overwhelming!</span>")
		return FALSE
	//	COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN

/datum/status_effect/majesty_compulsion/proc/on_say(mob/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]

	if(findtext(message, majesty_user.name) && (findtext(message, "fuck") || findtext(message, "shit") || findtext(message, "damn") || findtext(message, "kill") || findtext(message, "attack")))
		if(prob(70))
			to_chat(source, "<span class='warning'>The words die in your throat. You cannot speak ill of [majesty_user]!</span>")
			return

/atom/movable/screen/alert/status_effect/majesty_compulsion
	name = "Overwhelming Presence"
	desc = "You are compelled by an overwhelming presence. You find it nearly impossible to act against them."
	icon_state = "debuff"

/datum/stressevent/majesty_compelled
	desc = "There's someone here with such an overwhelming presence that I can barely think straight around them."
	stressadd = -3
