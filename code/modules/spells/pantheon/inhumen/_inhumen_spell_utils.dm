#define MAMMON_FILTER "mammon_glow"

////////
//ZIZO//
////////

/datum/action/cooldown/spell/zizo/rituos/proc/run_ritual_chant(mob/living/carbon/human/user, path_choice)
	var/list/chant_lines

	switch(path_choice)
		if("Progress")
			chant_lines = list(
				",w ZIZO! ZIZO! ZIZO! GRANT ME INSIGHT UNSHACKLED!",
				",w STRIP ME OF STAGNATION AND IGNORANCE!",
				",w BREAK THE CHAINS OF FALSE UNDERSTANDING!",
				",w LET REVELATION FLOOD THIS FRAIL MIND!",
				",w I OFFER THIS MIND TO COMPLETE THY WORK!",
			)

		if("Unlife")
			chant_lines = list(
				",w ZIZO! ZIZO! ZIZO! FLENSE FLESH FROM MY BONE!",
				",w STRIP ME OF MORTALITY'S SHACKLE!",
				",w LET THIS FRAIL MORTALITY FALL AWAY FROM PURPOSE!",
				",w REMAKE ME IN DEATH'S ENDURING IMAGE!",
				",w I OFFER THIS VESSEL TO COMPLETE THY WORK!",
			)

	for(var/i in 1 to length(chant_lines))
		user.say(chant_lines[i], forced = "spell", language = /datum/language/common)
		user.adjustBruteLoss(15)
		user.emote(pick("Progress" ? list("whimper", "painmoan", "gag", "choke") : list("painscream", "agony", "paincrit", "choke")))

		if(i > 1)
			shake_camera(user, min(i * 2, 3), i)

		if(!do_after(user, 3 SECONDS, target = user))
			to_chat(user, span_warning("The ritual collapses. Zizo's gaze turns away."))
			return FALSE

	return TRUE

/datum/action/cooldown/spell/zizo/rituos/proc/apply_progress_path(mob/living/carbon/human/user)
	user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)

	if(user.mind)
		user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6))
		ADD_TRAIT(user, TRAIT_STEELHEARTED, "[type]")
		ADD_TRAIT(user, TRAIT_JACKOFALLTRADES, "[type]")
		ADD_TRAIT(user, TRAIT_SELF_SUSTENANCE, "[type]")
		ADD_TRAIT(user, TRAIT_UNLYCKERABLE, "[type]")
		grant_poke_spell(user)

	user.visible_message(
		span_boldwarning("Arcyne runes sear themselves across [user]'s skin, glowing with a sickly light before fading beneath the flesh!"),
		span_notice("THE LESSER WORK IS DONE! Arcyne knowledge floods my mind - I can see the threads of magic itself!")
	)

/datum/action/cooldown/spell/zizo/rituos/proc/apply_unlife_path(mob/living/carbon/human/user)

	user.mob_biotypes |= MOB_UNDEAD

	ADD_TRAIT(user, TRAIT_NOMOOD, "[type]")
	ADD_TRAIT(user, TRAIT_NOPAIN, "[type]")
	ADD_TRAIT(user, TRAIT_NOHUNGER, "[type]")
	ADD_TRAIT(user, TRAIT_NOBREATH, "[type]")
	ADD_TRAIT(user, TRAIT_TOXIMMUNE, "[type]")
	ADD_TRAIT(user, TRAIT_BLOODLOSS_IMMUNE, "[type]")
	ADD_TRAIT(user, TRAIT_LIMBATTACHMENT, "[type]")
	ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, "[type]")
	ADD_TRAIT(user, TRAIT_SILVER_WEAK, "[type]")
	ADD_TRAIT(user, TRAIT_UNLYCKERABLE, "[type]")

	for(var/obj/item/bodypart/part in user.bodyparts)
		if(istype(part, /obj/item/bodypart/head))
			continue

		part.skeletonize(FALSE)
		user.update_body_parts()
		playsound(user.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
		sleep(15)

	var/obj/item/bodypart/torso = user.get_bodypart(BODY_ZONE_CHEST)
	playsound(user.loc, 'sound/misc/lava_death.ogg', 100, FALSE)
	torso?.skeletonize(FALSE)
	user.update_body_parts()

	user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)

	if(user.mind)
		user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4))
		user.mind.AddSpell(new /datum/action/cooldown/spell/bonechill)
		user.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)
		grant_poke_spell(user)

	user.visible_message(
		span_boldwarning("[user]'s flesh burns away in necrotic flames, revealing bone beneath as they are consumed by the Lesser Work!"),
		span_notice("THE LESSER WORK IS DONE! My flesh is forfeit - and death itself answers my call!")
	)

	to_chat(user, span_purple("You finished Rituos to perfection, you should be a full-fledged Lich now, but..."))
	sleep(30)
	to_chat(user, "<i>...Vestiges of mortality still cling to me...? Why?</i>")

/mob/living/carbon/human/proc/zizo_spam_rejection()
	visible_message(span_userdanger("[src]'s body suddenly convulses as the Lesser Work reaches completion!<br>"), span_userdanger("The Work collapses in on itself...! Something has gone terribly WRONG!<br>"))
	to_chat(src, span_artery("<br><br>OH. IT'S YOU.<br><br>"))
	sleep(30)
	to_chat(src, span_artery("DO YOU THINK I DON'T NOTICE?<br><br>"))
	sleep(20)
	to_chat(src, span_artery("PATHETIC.<br><br>"))
	sleep(20)
	to_chat(src, span_artery("YOU ARE NOT CLEVER. YOU ARE INSOLENT.<br><br>"))
	sleep(20)
	to_chat(src, span_artery("AND I HATE INSOLENT THINGS.<br><br>"))
	sleep(20)
	to_chat(src, span_artery("KINDLY, UNDO YOURSELF."))
	Stun(100)
	Knockdown(100)
	emote("superagony")
	playsound(get_turf(src), 'sound/misc/zizo.ogg', 200)
	to_chat(src, span_userdanger("--MY LUX- NO-! SHE SEES IT! SHE SEES WHAT I TRIED TO DO-!! SHIT!!!"))
	ADD_TRAIT(src, TRAIT_DNR, "zizo_rejection")
	sleep(50)
	playsound(get_turf(src), 'sound/magic/churn.ogg', 200)
	playsound(get_turf(src), 'sound/combat/dismemberment/dismem (2).ogg', 100)
	gib()
	visible_message(span_userdanger("[src] suddenly explodes into a pile or gore and remains!"), span_artery("The Lesser Work rejects you entirely. A hopeful lesson for another timeline."))

/mob/living/carbon/human/proc/zizo_vampire_rejection()
	visible_message(span_userdanger("[src]'s body suddenly convulses as the Lesser Work reaches completion!<br>"),
	span_userdanger("The Work rejects my cursed blood!<br>"))
	to_chat(src, span_artery("<br><br>OH. WONDERFUL. I KNOW WHAT YOU ARE ATTEMPTING.<br><br>"))
	sleep(40)
	to_chat(src, span_artery("YOU THINK SO LITTLE OF MY WORK? INSOLENT FOOL.<br><br>"))
	sleep(20)
	to_chat(src, span_artery("YOU HAVE NOT DISCOVERED SOME HIDDEN TRUTH.<br><br>"))
	sleep(20)
	to_chat(src, span_artery("YOU HAVE NOT FOUND A LOOPHOLE.<br><br>"))
	sleep(20)
	to_chat(src, span_artery("YOU HAVE NOT OUTWITTED ME.<br><br>"))
	sleep(20)
	to_chat(src, span_artery("YOU HAVE MERELY WASTED MY TIME.<br><br>"))
	sleep(20)
	to_chat(src, span_artery("MY PRECIOUS TIME.<br><br>"))
	sleep(20)
	to_chat(src, span_artery("SO. ALLOW ME TO REPAY THE FAVOR."))
	Stun(40)
	Knockdown(40)
	emote("superagony")
	playsound(get_turf(src), 'sound/misc/zizo.ogg', 200)
	to_chat(src, span_userdanger("--MY LUX IS BEING TORN OFF THROUGH MY HEAD!! MY HEAD!! MYHEADMYHEADMYHEADMYHEADMYHEHEAHEHEA!!"))
	ADD_TRAIT(src, TRAIT_DNR, "zizo_rejection")
	sleep(50)
	playsound(get_turf(src), 'sound/magic/churn.ogg', 200)
	playsound(get_turf(src), 'sound/combat/dismemberment/dismem (2).ogg', 100)
	var/obj/item/bodypart/head = get_bodypart(BODY_ZONE_HEAD)
	head?.skeletonize(TRUE)
	update_body()
	visible_message(span_userdanger("[src] SCREAMS in UNBELIEVABLE AGONY as their face is torn away, leaving only a hollow skull..."))
	sleep(20)
	visible_message(span_artery("Their Lux has been completely and utterly annihilated..."))

/datum/action/cooldown/spell/zizo/rituos/proc/grant_poke_spell(mob/living/carbon/human/user)
	var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Greater Arcyne Bolt", "Stygian Efflorescence", "Arcyne Lance", "Lesser Gravel Blast", "Lesser Soulshot")
	var/poke_choice = tgui_input_list(user, "Choose your offensive cantrip.", "Arcyne Awakening", poke_options)
	if(!poke_choice || !user.mind)
		return
	switch(poke_choice)
		if("Spitfire")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
		if("Frost Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
		if("Arc Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
		if("Greater Arcyne Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/greater_arcyne_bolt)
		if("Stygian Efflorescence")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
		if("Arcyne Lance")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)
		if("Lesser Gravel Blast")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast/lesser)
		if("Lesser Soulshot")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/soulshot/lesser)

////////////
//MATTHIOS//
////////////

//Mammonite Utils

/datum/action/cooldown/spell/mammonite/proc/get_investment_range(mob/living/carbon/human/H)
	var/min_invest = min_mammon
	var/max_invest = min_mammon
	switch(H.rmb_intent.type)
		if(/datum/rmb_intent/swift)
			max_invest = 20
		if(/datum/rmb_intent/riposte) // "defend"
			min_invest = 20
			max_invest = 40
		if(/datum/rmb_intent/feint)
			min_invest = 40
			max_invest = 60
		if(/datum/rmb_intent/aimed)
			min_invest = 60
			max_invest = 80
		if(/datum/rmb_intent/strong)
			min_invest = 80
			max_invest = max_mammon
	return list(min_invest, max_invest)

/datum/action/cooldown/spell/mammonite/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE

	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/H = owner

	var/bank = 0
	if(SStreasury.has_account(H))
		bank = SStreasury.get_balance(H)

	var/onhand = get_mammons_in_atom(H)
	var/total = bank + onhand
	var/list/range = get_investment_range(H)
	var/min_invest = range[1]

	if(total < min_invest)
		if(feedback)
			to_chat(H, span_warning("I lack the wealth to invoke Matthios' favor... ([min_invest] mammon needed for [H.rmb_intent.name] stance.)"))
		return FALSE

	return TRUE

/proc/remove_mammons_from_atom(atom/A, amount)
	if(!A || amount <= 0)
		return 0

	var/remaining = amount
	var/list/coins = list()

	collect_coins_recursive(A, coins)
	coins = sortTim(coins, /proc/cmp_coin_value_desc)

	for(var/obj/item/roguecoin/C in coins)
		if(remaining <= 0)
			break

		if(QDELETED(C))
			continue

		var/value_per = C.sellprice
		if(value_per <= 0)
			continue

		var/max_value = value_per * C.quantity
		if(max_value <= remaining)
			remaining -= max_value
			qdel(C)
		else
			var/coins_to_remove = ceil(remaining / value_per)
			coins_to_remove = min(coins_to_remove, C.quantity)
			C.set_quantity(C.quantity - coins_to_remove)
			if(C.quantity <= 0)
				qdel(C)
			remaining = 0

	return amount - remaining

/proc/collect_coins_recursive(atom/A, list/out)
	for(var/atom/movable/AM in A.contents)
		if(istype(AM, /obj/item/roguecoin))
			out += AM
		if(AM.contents && length(AM.contents))
			collect_coins_recursive(AM, out)

/proc/cmp_coin_value_desc(obj/item/roguecoin/A, obj/item/roguecoin/B)
	return B.sellprice - A.sellprice

/atom/movable/screen/alert/status_effect/debuff/doomed
	name = "Doom"
	desc = "You have precisely 3 seconds to live. See you on the other side."
	icon_state = "permadeath"

/datum/status_effect/debuff/doom
	id = "doom"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/doomed
	duration = 3 SECONDS
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/debuff/doom/on_apply()
	. = ..()
	owner.add_filter(MAMMON_FILTER, 2, list("type" = "outline", "color" = "#911096ff", "alpha" = 175, "size" = 2))

/datum/status_effect/debuff/doom/on_remove()
	. = ..()
	var/mob/living/L = owner
	if(!istype(L))
		return
	L.gib()

/atom/movable/screen/alert/status_effect/buff/mammonite
	name = "Mammonite Strike"
	desc = "My next strike is empowered by wealth."
	icon_state = "buff"

/datum/status_effect/buff/mammonite
	id = "mammonite"
	alert_type = /atom/movable/screen/alert/status_effect/buff/mammonite
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	var/bonus_damage
	var/cap

/datum/status_effect/buff/mammonite/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))
	owner.add_filter(MAMMON_FILTER, 2, list("type" = "outline", "color" = "#d4af37", "alpha" = 175, "size" = 2))

/datum/status_effect/buff/mammonite/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_HUMAN_MELEE_UNARMED_ATTACK))
	owner.remove_filter(MAMMON_FILTER)
	. = ..()

/datum/status_effect/buff/mammonite/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(source != owner || !isliving(target) || target.stat == DEAD)
		return
	INVOKE_ASYNC(src, PROC_REF(resolve_attack), target, weapon)
	return COMPONENT_ITEM_NO_ATTACK

/datum/status_effect/buff/mammonite/proc/on_unarmed_attack(mob/living/source, atom/target, proximity) 
	SIGNAL_HANDLER 
	if(!isliving(target) || target == owner) 
		return 
	var/mob/living/L = target 
	if(L.stat == DEAD) 
		return
	INVOKE_ASYNC(src, PROC_REF(resolve_attack), L, null)
	return COMPONENT_HAND_NO_ATTACK

//Mammonite Jakk
/datum/status_effect/buff/mammonite/proc/resolve_attack(mob/living/target, obj/item/weapon)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(target))
		return
	if(should_mammon_gib(target))
		do_mammon_execution(target) // only works vs NPCs! Knocks them back and chance to gib them if you spent over 80 mammon on this (guaranteed if over half the max_cap).
	else
		do_mammon_strike(target, weapon)
	consume()

/datum/status_effect/buff/mammonite/proc/should_mammon_gib(mob/living/target)
	if(target.mind)
		return FALSE
	var/mammon_spent = round(bonus_damage / 3)
	if(mammon_spent <= 79)
		return FALSE
	var/mid_cap = cap * 0.5
	var/gib_chance
	if(mammon_spent >= mid_cap)
		gib_chance = 100
	else
		gib_chance = 20 + (mammon_spent - 80) * (80 / (mid_cap - 80))
	gib_chance = clamp(gib_chance, 20, 100)
	return prob(gib_chance)

/datum/status_effect/buff/mammonite/proc/do_mammon_execution(mob/living/target)
	if(QDELETED(owner) || QDELETED(target))
		return
	owner.visible_message(span_boldwarning("[target] suddenly contorts, twists and lets out a blood-curling screech--!"), span_notice("Their life was worth less than the investment."))
	target.emote("superagony")
	mammon_coin_burst(get_turf(target))
	playsound(get_turf(target), 'sound/combat/hits/burn (2).ogg', 60, TRUE)
	target.apply_status_effect(/datum/status_effect/debuff/doom)
	target.safe_throw_at(target, 3, 1, owner, force = MOVE_FORCE_EXTREMELY_STRONG)

/datum/status_effect/buff/mammonite/proc/do_mammon_strike(mob/living/target, obj/item/weapon)
	if(QDELETED(owner) || QDELETED(target))
		return

	var/damage = bonus_damage
	var/npc_mult = target.mind ? 1 : 2
	var/apen = damage * 0.75

	arcyne_strike(owner, target, weapon, damage, owner.zone_selected, BCLASS_SMASH, apen, "Mammonite", FALSE, FALSE, FALSE, BRUTE, npc_mult, 1)
	owner.visible_message(span_danger("[owner]'s strike crashes down with the weight of greed!"), span_notice("My investment pays off in full!"))
	mammon_coin_burst(get_turf(target))
	playsound(get_turf(target), 'sound/combat/hits/burn (2).ogg', 60, TRUE)

/datum/status_effect/buff/mammonite/proc/consume()
	if(owner)
		playsound(get_turf(owner), 'sound/magic/antimagic.ogg', 20, TRUE)
		playsound(get_turf(owner), 'sound/misc/coininsert.ogg', 40, TRUE)
		playsound(get_turf(owner), 'sound/effects/matth_barter.ogg', 40, TRUE)
		owner.remove_status_effect(/datum/status_effect/buff/mammonite)

/proc/mammon_coin_burst(turf/T)
	if(!T)
		return
	for(var/i = 3 to 8)
		var/obj/effect/temp_visual/coinburst/C = new(T)
		C.pixel_x = rand(-8, 8)
		C.pixel_y = rand(-8, 8)

/obj/effect/temp_visual/coinburst
	icon = 'icons/roguetown/items/valuable.dmi'
	icon_state = "g1"
	layer = ABOVE_MOB_LAYER
	duration = 6

/obj/effect/temp_visual/coinburst/Initialize()
	. = ..()
	var/matrix/M = matrix()
	M.Scale(0.25, 0.25) // 25% size
	transform = M
	animate(src, pixel_x = pixel_x + rand(-16,16), pixel_y = pixel_y + rand(8,20), alpha = 0, time = duration, easing = EASE_OUT)

#undef MAMMON_FILTER 

//Skulduggery Utils

/atom/movable/screen/alert/status_effect/buff/skulduggery 
	name = "Skulduggery" 
	desc = span_notice("I prepare to slip inside attacks and punish aggressors, like a true Free Man would.") 
	icon_state = "clash"

/datum/status_effect/buff/skulduggery
	id = "skulduggery"
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/skulduggery
	status_type = STATUS_EFFECT_REFRESH
	var/mob/living/carbon/human/grappled
	var/waiting_followup = FALSE
	var/list/grapple_counts = list() // free grapple can only happen twice vs players
	var/parries_left = 0 // only got X free parries based on miracle level
	tick_interval = 1 SECONDS

/datum/status_effect/buff/skulduggery/on_creation(mob/living/new_owner, ...)
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_BEING_ATTACKED, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(process_Wfist))
	RegisterSignal(new_owner, COMSIG_LIVING_STATUS_STUN, PROC_REF(on_incapacitate))
	RegisterSignal(new_owner, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(on_incapacitate))

	parries_left = new_owner.get_skill_level(/datum/skill/magic/holy)
	. = ..()

/datum/status_effect/buff/skulduggery/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_STATUS_STUN)
	UnregisterSignal(owner, COMSIG_LIVING_STATUS_KNOCKDOWN)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_BEING_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ATTACKED_BY_HAND)

	owner.stop_pulling()
	waiting_followup = FALSE
	. = ..()

/datum/status_effect/buff/skulduggery/proc/trigger_afterimage(duration = 2)
	if(!owner) return
	if(owner.GetComponent(/datum/component/after_image))
		return
	var/datum/component/after_image/A = owner.AddComponent(/datum/component/after_image)
	spawn(duration)
		if(A)
			qdel(A)

/datum/status_effect/buff/skulduggery/proc/on_incapacitate()
	SIGNAL_HANDLER 
	if(!owner) 
		return 
	if(!owner.IsKnockdown() && !owner.IsStun()) 
		return 
	to_chat(owner, span_warning("My footing falters! Carkin'--!")) 
	qdel(src)

/datum/status_effect/buff/skulduggery/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!owner) return
	if(prob(40))
		trigger_afterimage(2)
		owner.Jitter(1)

	if(waiting_followup && grappled)
		if(owner.pulling != grappled)
			waiting_followup = FALSE
			grappled = null
			
	if((H.highest_ac_worn() <= ARMOR_CLASS_LIGHT)&&(owner.has_status_effect(/datum/status_effect/buff/tempo_one) || owner.has_status_effect(/datum/status_effect/buff/tempo_two) || owner.has_status_effect(/datum/status_effect/buff/tempo_three) || owner.has_status_effect(/datum/status_effect/buff/equalizebuff)))
		owner.apply_status_effect(/datum/status_effect/buff/skulduggery)
		return

// SIGNAL HOOKS
/datum/status_effect/buff/skulduggery/proc/process_Wfist(mob/living/carbon/human/parent,mob/living/carbon/human/attacker,mob/living/carbon/human/defender)
	if(!ishuman(defender)) return
	if(defender.process_skd(attacker, null))
		return COMPONENT_HAND_NO_ATTACK

/datum/status_effect/buff/skulduggery/proc/process_Wattack(mob/living/parent,mob/living/target,mob/user,obj/item/I)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.process_skd(user, I))
			return COMPONENT_NO_ATTACK

/mob/living/carbon/human/proc/process_skd(mob/living/carbon/human/attacker, obj/item/I)
	var/datum/status_effect/buff/skulduggery/S = has_status_effect(/datum/status_effect/buff/skulduggery)
	if(!S) return FALSE
	return S.process_skd(attacker, I)

// CORE LOGIC
/datum/status_effect/buff/skulduggery/proc/process_skd(mob/living/carbon/human/attacker, obj/item/I)
	if(!owner || !ishuman(owner) || !ishuman(attacker) || owner.IsKnockdown() || owner.lying || owner.IsParalyzed() || owner.IsStun() || owner.stat != CONSCIOUS || !(owner.mobility_flags & MOBILITY_STAND))
		return FALSE

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/A = attacker

	// FOLLOW-UP STATE
	if(waiting_followup)
		if(A == grappled)
			slam_target(A)
		else
			slam_into(A)
		return TRUE

	// PRONE CHECK
	if(A.IsKnockdown() || A.lying)
		return stomp_prone(A)

	// THROW MODE = INTERCEPT-GRAPPLE
	if(H.in_throw_mode)
		return attempt_grapple(H, A)

	// NPC BAMBOOZLING
	if(!A.mind)
		return auto_flank_move(H, A)

	// PLAYER STANDARD PARRY
	return attempt_parry(H, A, I)

/datum/status_effect/buff/skulduggery/proc/attempt_grapple(mob/living/carbon/human/H, mob/living/carbon/human/A)
	if(A.mind)
		if(!grapple_counts[A])
			grapple_counts[A] = 0

		if(grapple_counts[A] >= 2)
			H.visible_message(
				span_warning("[H] reaches for [A], but they anticipate it!"),
				span_notice("They've adapted... I can't grab them again!")
			)
			return FALSE
		grapple_counts[A]++

	H.start_pulling(A)
	H.setDir(get_dir(H, A))
	playsound(H, 'sound/combat/riposte.ogg', 100, TRUE)

	H.visible_message(
		span_boldwarning("[H] intercepts [A] and seizes them!"),
		span_notice("Got them!")
	)

	H.balloon_alert_to_viewers("SKD!!", "SKD!!", 10)

	grappled = A
	waiting_followup = TRUE

	return TRUE

/datum/status_effect/buff/skulduggery/proc/attempt_parry(mob/living/carbon/human/H, mob/living/carbon/human/A, obj/item/I)
	if(!I?.associated_skill)
		return FALSE
	var/my_skill = H.get_skill_level(/datum/skill/magic/holy)
	var/enemy_skill = A.get_skill_level(I.associated_skill)
	if(!enemy_skill)
		enemy_skill = 0

	// Skill difference
	var/skill_diff = my_skill - enemy_skill
	// Base success chance (10% per point of advantage)
	var/base_chance = skill_diff * 10
	// Parry bonus (+20% per remaining parry)
	var/parry_bonus = parries_left * 20
	// Final success chance
	var/success_chance = base_chance + parry_bonus
	success_chance = clamp(success_chance, 0, 90)

	// Roll
	if(!prob(success_chance))
		H.visible_message(
			span_warning("[H] tries to read [A]'s attack, but fails!"),
			span_notice("Gah, I can't keep up!")
		)
		parries_left--
		to_chat(owner, span_warning("Failed, [parries_left] left. ([success_chance]%)")) 
		return FALSE
	// Success
	if(parries_left > 0)
		parries_left--

	to_chat(owner, span_warning("Success, [parries_left] left. ([success_chance]%)")) 
	auto_flank_move(H, A)
	return TRUE

/datum/status_effect/buff/skulduggery/proc/is_valid_step(mob/living/carbon/human/H, turf/dest)
	if(!dest)
		return FALSE
	if(arcyne_validate_blink_dest(dest, H))
		return FALSE
	if(istransparentturf(dest))
		return FALSE
	return TRUE

/datum/status_effect/buff/skulduggery/proc/auto_flank_move(mob/living/carbon/human/H, mob/living/carbon/human/A)
	if(!H || !A)
		return FALSE

	var/original_dir = A.dir
	var/left_dir = turn(original_dir, 90)
	var/right_dir = turn(original_dir, -90)
	var/behind_dir = turn(original_dir, 180)
	var/turf/left = get_step(A, left_dir)
	var/turf/right = get_step(A, right_dir)
	var/turf/behind = get_step(A, behind_dir)
	var/dx = H.x - A.x
	var/dy = H.y - A.y
	var/use_left = (dx * dy >= 0)
	var/turf/side = use_left ? left : right
	var/turf/alt_side = use_left ? right : left

	if(!is_valid_step(H, side) || !is_valid_step(H, behind))
		side = alt_side

		if(!is_valid_step(H, side) || !is_valid_step(H, behind))
			if(!is_valid_step(H, behind))
				return FALSE

			trigger_afterimage(3)
			H.forceMove(behind)
		else
			trigger_afterimage(3)
			H.forceMove(side)

			sleep(1) 
			
			trigger_afterimage(3)
			H.forceMove(behind)
	else
		trigger_afterimage(3)
		H.forceMove(side)

		sleep(1) // 1 tick, enough to render
	
		H.forceMove(behind)
		trigger_afterimage(3)

	H.setDir(get_dir(H, A))

	if(!A.mind)
		A.Immobilize(8 SECONDS)
		A.OffBalance(8 SECONDS)
		A.apply_status_effect(/datum/status_effect/debuff/clickcd, 8 SECONDS)
		if(A.mob_biotypes != MOB_UNDEAD && prob(25))
			A.emote("huh")
	else
		A.apply_status_effect(/datum/status_effect/debuff/clickcd, 2 SECONDS)

	H.visible_message(
		span_boldwarning("[H] slips past [A] in a blur and appears at their back!"),
		span_notice("Too slow.")
	)

	return TRUE

// SKD - STOMP
/datum/status_effect/buff/skulduggery/proc/stomp_prone(mob/living/carbon/human/T)
	if(!T) return

	var/mob/living/carbon/human/H = owner
	H.visible_message(
			span_boldwarning("[H] delivers their foot onto [T] while they try to swing!"),
			span_notice("Deserved kick for trying that, fool!")
		)
	H.do_attack_animation(T)
	T.adjustBruteLoss(8)
	T.stamina_add(8)
	H.setDir(get_dir(H, T))

	if(!T.mind)
		T.stamina_add(12)
		T.apply_status_effect(/datum/status_effect/debuff/clickcd, 2 SECONDS)

	addtimer(CALLBACK(T, /mob/proc/slamdunked), 1)
	return TRUE
	
// SKD - GROUND SLAM
/datum/status_effect/buff/skulduggery/proc/slam_target(mob/living/carbon/human/T)
	if(!T) return

	var/mob/living/carbon/human/H = owner

	var/power = H.get_skill_level(/datum/skill/combat/unarmed) + (H.get_skill_level(/datum/skill/magic/holy) / 2)
	var/resist = (T.get_stat(STAT_CONSTITUTION) + T.get_stat(STAT_SPEED)/4)

	var/chance = clamp(50 + (power - resist), 10, 90)
	if(prob(chance))
		H.stop_pulling()
		waiting_followup = FALSE
		grappled = null
		H.visible_message(
			span_boldwarning("[H] turns [T] upside their head and slams them into the ground!"),
			span_notice("<i>I drive them into the floor with sheer skill!</i>")
		)
		H.setDir(get_dir(H, T))
		H.balloon_alert_to_viewers(message = "SKD Slam!!", self_message = "SKD Slam!!", y_offset = 10)
		playsound(get_turf(T), 'sound/combat/wooshes/blunt/wooshhuge (2).ogg', 100, FALSE)
		T.Knockdown(4 SECONDS)
		sleep(3)
		T.apply_status_effect(/datum/status_effect/debuff/clickcd, 4 SECONDS)
		T.adjustBruteLoss(40)
		T.stamina_add(60)
		shake_camera(H, 2, 1)
		shake_camera(T, 2, 1)
		var/da_slam = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
		playsound(T, da_slam, 100, TRUE)
		playsound(T, 'sound/combat/tf2crit.ogg', 100, TRUE)
		if(!T.mind && T.mob_biotypes != MOB_UNDEAD)
			if(prob(50))
				T.Unconscious(800)
	else
		H.visible_message(
			span_warning("[T] resists the slam, forcing [H] to kick them away!"),
			span_notice("They resist my attempt to slam! I have to kick them off!")
		)
		H.balloon_alert_to_viewers(message = "SKD Kick!!", self_message = "SKD Kick!!", y_offset = 10)
		H.setDir(get_dir(H, T))
		playsound(T, 'sound/combat/hits/punch/punch_hard (2).ogg', 100, TRUE)
		T.Knockdown(1 SECONDS)
		var/dir = turn(get_dir(T, H), 180)
		if(dir & (NORTH|SOUTH))
			dir = (dir & NORTH) ? NORTH : SOUTH
		else
			dir = (dir & EAST) ? EAST : WEST
		var/turf/current = get_turf(T)
		for(var/i = 1 to 3)
			var/turf/next = get_step(current, dir)
			if(!next || next.density)
				break
			current = next
		T.throw_at(current, 2, 4)
		waiting_followup = FALSE

	addtimer(CALLBACK(T, /mob/proc/slamdunked), 1)

	grappled = null
	waiting_followup = FALSE

// SKD - SLAM INTO ANOTHER
/datum/status_effect/buff/skulduggery/proc/slam_into(mob/living/carbon/human/other)
	if(!other || !grappled) return

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/G = grappled

	H.visible_message(
		span_boldwarning("[H] redirects [G] full force into [other]!"),
		span_notice("<i>Consecutive Skulduggery! Hells yae! Bring me more!</i>")
	)
	H.balloon_alert_to_viewers(message = "Consecutive SKD!!", self_message = "Consecutive SKD!!", y_offset = 10)
	H.setDir(get_dir(H, other))
	var/attack_sound = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
	playsound(other, attack_sound, 100, TRUE)

	G.forceMove(get_turf(other))

	G.adjustBruteLoss(30)
	other.adjustBruteLoss(30)
	other.stamina_add(25)

	G.Knockdown(1 SECONDS)
	other.Knockdown(1 SECONDS)

	shake_camera(H, 2, 1)
	shake_camera(G, 2, 1)
	shake_camera(other, 2, 1)

	var/dir = turn(get_dir(other, H), 180)

	if(dir & (NORTH|SOUTH))
		dir = (dir & NORTH) ? NORTH : SOUTH
	else
		dir = (dir & EAST) ? EAST : WEST

	var/turf/current = get_turf(other)

	for(var/i = 1 to 3)
		var/turf/next = get_step(current, dir)
		if(!next || next.density)
			break
		current = next

	other.throw_at(current, 1, 4)
	waiting_followup = FALSE

	addtimer(CALLBACK(src, .proc/_slam_followup, other, G), 0.5)

	grappled = null
	waiting_followup = FALSE

/datum/status_effect/buff/skulduggery/proc/_slam_followup(mob/living/carbon/human/other, mob/living/carbon/human/G)
	if(!other || !G) return

	G.forceMove(get_turf(other))

	var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
	var/turf/T = get_step(G, pick(dirs))
	if(T && !T.density)
		G.forceMove(T)

	addtimer(CALLBACK(G, /mob/proc/slamdunked), 1)
	addtimer(CALLBACK(other, /mob/proc/slamdunked), 1)

	if(!G.mind && G.mob_biotypes != MOB_UNDEAD)
		if(prob(50))
			G.Unconscious(800)

// EFFECTS
/mob/proc/slamdunked()
	var/amp = 6
	animate(src, pixel_x = 0, time = 0)
	for(var/i in 1 to 5)
		animate(src, pixel_x = -amp, time = 1)
		animate(src, pixel_x = amp, time = 1)
		amp = round(amp * 0.6)
	animate(src, pixel_x = 0, time = 2)
