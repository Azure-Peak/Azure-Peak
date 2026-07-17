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

////////////
//MATTHIOS//
////////////

//Mammonite Utils

/datum/action/cooldown/spell/matthios/mammonite/proc/get_investment_range(mob/living/carbon/human/H)
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

/datum/action/cooldown/spell/matthios/mammonite/can_cast_spell(feedback = TRUE)
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
