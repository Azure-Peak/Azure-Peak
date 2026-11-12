/datum/action/cooldown/spell/necra
	background_icon = 'icons/mob/actions/necramiracles.dmi'
	button_icon = 'icons/mob/actions/necramiracles.dmi'
	spell_color = PATRON_COLOR_NECRA
	ignore_armor_penalty = TRUE
	attunement_school = null
	primary_resource_type = SPELL_COST_DEVOTION
	secondary_resource_type = SPELL_COST_STAMINA
	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0
	point_cost = 0
	required_items = list(/obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/necra, /obj/item/clothing/neck/roguetown/psicross/necra/g)

/obj/effect/proc_holder/spell/targeted/churn
	name = "Churn Undead"
	desc = "Stuns and explodes undead."
	range = 4	//Way lower, halved.
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
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


///////////////////////
// T4 - DEATH'S DOOR //
///////////////////////
// Open a portal to Necra's dimension, which can let you use to keep fresh corpses safe from decay and transport them (or yourself) to safety.

/datum/action/cooldown/spell/necra/deaths_door
	name = "Death's Door"
	desc = "Opens a one-way portal to Necra's domain at a targeted location within range. Those who enter are transported to the realm, where their will to continue is weakened. Undead are set aflame. The domain can only be left through its designated portal, or a grave or psycross marked with Necra's Sight.<br><br>\"Whatever you do. Do NOT fall asleep.\""
	fluff_desc = "There is a place between the final breath and the silence that follows, where the living have no business lingering and the dead have yet to find their rest. It is here that Necra's dominion touches the mortal world. Through her grace, the faithful may part the veil and open a passage into her realm, a place where the dying are spared the indignity of decay, and where all who trespass are reminded how frail their will to live truly is. Yet this passage is not freely given. Once across its threshold, only Necra's appointed ways may lead one home."
	button_icon_state = "deathdoor"
	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = 2 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	sound = 'sound/misc/deadbell.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'
	cooldown_time = 30 SECONDS
	cast_range = 6
	invocations = list("Rend the veil, and grant me passage...")

/datum/action/cooldown/spell/necra/deaths_door/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	var/turf/T = get_turf(cast_on)
	if(!user || !T || !isopenturf(T))
		return FALSE
	if(istype(get_area(user), /area/rogue/indoors/ravoxarena))
		to_chat(user, span_userdanger("I tried to escape, but something rebukes me! There's no escape until the end of the challenge!"))
		return FALSE
	if(locate(/obj/structure/deaths_door_portal) in T)
		to_chat(user, span_warning("A gate already stands here."))
		return FALSE
	if(user.mind && !user.mind.has_spell(/obj/effect/proc_holder/spell/invoked/necras_sight))
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/necras_sight)
		to_chat(user, span_notice("A cold clarity fills my vision as Necra opens my sight."))
	new /obj/structure/deaths_door_portal(T, user)
	return TRUE

/*
	SOUL SPEAK
*/


/obj/effect/proc_holder/spell/targeted/soulspeak
	name = "Speak with Soul"
	range = 5
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
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
