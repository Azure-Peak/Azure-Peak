/mob/living/carbon/human/proc/process_clash(mob/user, obj/item/IM, obj/item/IU)
	if(!ishuman(user))
		return
	if(user == src)
		bad_guard(span_warning("I hit myself."))
		return
	var/mob/living/carbon/human/H = user
	if(!IU)	//The opponent is trying to rawdog us with their bare hands while we have Guard up. We get a free attack on their active hand.
		var/obj/item/bodypart/affecting = H.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
		var/force = get_complex_damage(IM, src)
		var/armor_block = H.run_armor_check(BODY_ZONE_PRECISE_L_HAND, used_intent.item_d_type, armor_penetration = used_intent.penfactor, damage = force, used_weapon = IM)
		if(H.apply_damage(force, IM.damtype, affecting, armor_block))
			visible_message(span_suicide("[src] gores [user]'s hands with \the [IM]!"))
			affecting.bodypart_attacked_by(used_intent.blade_class, force, crit_message = TRUE, weapon = IM)
		else
			visible_message(span_suicide("[src] clashes into [user]'s hands with \the [IM]!"))
		playsound(src, pick(used_intent.hitsound), 80)
		remove_status_effect(/datum/status_effect/buff/clash)
		return
	if(H.has_status_effect(/datum/status_effect/buff/clash))	//They also have Riposte active. It'll trigger the special event.
		clash(user, IM, IU)
	else	//Otherwise, we just riposte them.
		var/sharpnesspenalty = 0.15
		if(IM.wbalance == WBALANCE_HEAVY || IU.blade_dulling == DULLING_SHAFT_CONJURED)
			sharpnesspenalty += 0.05
		if(IU.max_blade_int)
			IU.remove_bintegrity((IU.blade_int * sharpnesspenalty), user)
		else
			var/integdam = max((IU.max_integrity / 5), (INTEG_PARRY_DECAY_NOSHARP * 5))
			if(IU.blade_dulling == DULLING_SHAFT_CONJURED)
				integdam *= 2
			IU.take_damage(integdam, BRUTE, IM.d_type)
		visible_message(span_suicide("[src] ripostes [H] with \the [IM]!"))
		playsound(src, 'sound/combat/clash_struck.ogg', 100)
		H.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		H.apply_status_effect(/datum/status_effect/debuff/clickcd, 3 SECONDS)
		H.Slowdown(3)
		to_chat(src, span_notice("[capitalize(H.p_theyre())] exposed!"))
		remove_status_effect(/datum/status_effect/buff/clash)
		apply_status_effect(/datum/status_effect/buff/adrenaline_rush)
		purge_peel(GUARD_PEEL_REDUCTION)

//This is a gargantuan, clunky proc that is meant to tally stats and weapon properties for the potential disarm.
//For future coders: Feel free to change this, just make sure someone like Struggler statpack doesn't get 3-fold advantage.
/mob/living/carbon/human/proc/clash(mob/user, obj/item/IM, obj/item/IU)
	var/mob/living/carbon/human/HU = user
	var/instantloss = FALSE
	var/instantwin = FALSE

	//Stat checks. Basic comparison.
	var/strdiff = STASTR - HU.STASTR
	var/perdiff = STAPER - HU.STAPER
	var/spddiff = STASPD - HU.STASPD
	var/fordiff = STALUC - HU.STALUC
	var/intdiff = STAINT - HU.STAINT

	var/list/statdiffs = list(strdiff, perdiff, spddiff, fordiff, intdiff)

	//Skill check, very simple. If you're more skilled with your weapon than the opponent is with theirs -> +10% to disarm or vice-versa.
	var/skilldiff
	if(IM.associated_skill)
		skilldiff = get_skill_level(IM.associated_skill)
	else
		instantloss = TRUE	//We are Guarding with a book or something -- no chance for us.

	if(IU.associated_skill)
		skilldiff = skilldiff - HU.get_skill_level(IU.associated_skill)
	else
		instantwin = TRUE	//THEY are Guarding with a book or something -- no chance for them.
	
	//Weapon checks.
	var/lengthdiff = IM.wlength - IU.wlength //The longer the weapon the better.
	var/wieldeddiff = IM.wielded - IU.wielded //If ours is wielded but theirs is not.
	var/weightdiff = (IM.wbalance < IU.wbalance) //If our weapon is heavy-balanced and theirs is not.
	var/wildcard = pick(-1,0,1)

	var/list/wepdiffs = list(lengthdiff, wieldeddiff, weightdiff)

	var/prob_us = 0
	var/prob_opp = 0

	//Stat checks only matter if their difference is 2 or more.
	for(var/statdiff in statdiffs)
		if(statdiff >= 2)
			prob_us += 10
		else if(statdiff <= -2)
			prob_opp += 10
	
	for(var/wepdiff in wepdiffs)
		if(wepdiff > 0)
			prob_us += 10
		else if(wepdiff < 0)
			prob_opp += 10

	//Wildcard modifier that can go either way or to neither.
	if(wildcard > 0)
		prob_us += 10
	else if(wildcard < 0 )
		prob_opp += 10
	
	//Small bonus to the first one to strike in a Clash.
	var/initiator_bonus = rand(5, 10)
	prob_us += initiator_bonus

	if(has_duelist_ring() && HU.has_duelist_ring())
		prob_us = max(prob_us, prob_opp)
		prob_opp = max(prob_us, prob_opp)

	if((!instantloss && !instantwin) || (instantloss && instantwin))	//We are both using normal weapons OR we're both using memes. Either way, proceed as normal.
		visible_message(span_boldwarning("[src] and [HU] clash!"))
		flash_fullscreen("whiteflash")
		HU.flash_fullscreen("whiteflash")
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_step(src,src.dir)
		S.set_up(1, 1, front)
		S.start()
		var/success
		if(prob(prob_us))
			HU.play_overhead_indicator('icons/mob/overhead_effects.dmi', "clashtwo", 1 SECONDS, OBJ_LAYER, soundin = 'sound/combat/clash_disarm_us.ogg', y_offset = 24)
			disarmed(IM)
			Slowdown(5)
			success = TRUE
		if(prob(prob_opp))
			HU.disarmed(IU)
			HU.Slowdown(5)
			play_overhead_indicator('icons/mob/overhead_effects.dmi', "clashtwo", 1 SECONDS, OBJ_LAYER, soundin = 'sound/combat/clash_disarm_opp.ogg', y_offset = 24)
			success = TRUE
		if(!success)
			to_chat(src, span_warningbig("Draw! Opponent's chances were... [prob_opp]%"))
			to_chat(HU, span_warningbig("Draw! Opponent's chances were... [prob_us]%"))
			playsound(src, 'sound/combat/clash_draw.ogg', 100, TRUE)
	else
		if(instantloss)
			disarmed(IM)
		if(instantwin)
			HU.disarmed(IU)
	
	remove_status_effect(/datum/status_effect/buff/clash)
	HU.remove_status_effect(/datum/status_effect/buff/clash)

///Proc that will try to throw the src's held I and throw it 1 - 5 tiles to their side. 
///At the moment it doesn't have a get_active_held_item() failsafe, so the I has to be defined first.
///This is due to, uh, bad code.
/mob/living/carbon/human/proc/disarmed(obj/item/I)
	visible_message(span_suicide("[src] is disarmed!"), 
					span_boldwarning("I'm disarmed!"))
	var/turnangle = (prob(50) ? 270 : 90)
	var/turndir = turn(dir, turnangle)
	var/dist = rand(1, 5)
	var/current_turf = get_turf(src)
	var/target_turf = get_ranged_target_turf(current_turf, turndir, dist)
	throw_item(target_turf, FALSE)
	apply_status_effect(/datum/status_effect/debuff/clickcd, 3 SECONDS)

///Proc that cancels Riposte with a small stamina penalty, unless it's an extreme case.
/mob/living/carbon/human/proc/bad_guard(msg, cheesy = FALSE, custom_value)
	stamina_add(((max_stamina * (custom_value ? custom_value : BAD_GUARD_FATIGUE_DRAIN)) / 100))
	if(cheesy)	//We tried to hit someone with Riposte (Not Limb Guard) up. Unfortunately this must be super punishing to prevent cheese.
		energy_add(-((max_energy * (custom_value ? custom_value : BAD_GUARD_FATIGUE_DRAIN)) / 100))
		Immobilize(2 SECONDS)
	if(msg)
		to_chat(src, msg)
		emote("strain", forced = TRUE)
	remove_status_effect(/datum/status_effect/buff/clash)
	remove_status_effect(/datum/status_effect/buff/clash/limbguard)

///Reduces Peel by some amount. Usually called after waiting out of combat for a while or by other effects (riposte / bait)
/mob/living/carbon/human/proc/purge_peel(amt)
	//Equipment slots manually picked out cus we don't have a proc for this apparently
	var/list/slots = list(wear_armor, wear_pants, wear_wrists, wear_shirt, gloves, head, shoes, wear_neck, wear_mask, wear_ring)
	for(var/slot in slots)
		if(isnull(slot) || !istype(slot, /obj/item/clothing))
			slots.Remove(slot)

	for(var/obj/item/clothing/C in slots)
		if(C.peel_count > 0)
			C.reduce_peel(amt)

///Purges the singular possible bait stack after waiting for a bit out of combat.
/mob/living/carbon/human/proc/purge_bait()
	if(!cmode)
		if(bait_stacks > 0)
			bait_stacks = 0
			to_chat(src, span_info("My focus and balance returns. I won't lose my footing if I am baited again."))

///Called by a timer after toggling cmode off.
/mob/living/carbon/human/proc/expire_peel()
	if(!cmode)
		purge_peel(99)

///A Unique Stat comparison between src and HT.
///It takes the highest stats up to 14 and lowest stats 'up to' 14.
///It compares the highest and the lowest of both targets and adds them to the probability.
///-Lower- stats are multiplied by 3. Higher stats are added as-is.
///This in essence favors someone with a more balanced statblock rather than someone who is specced 16+ into one, and 7 elsewhere.
///eg (14 Hi. & 7 Lo.) will be at a disadvantage vs (11 Hi. & 10 Lo.) (14 + 21) vs (11 + 30)
/mob/living/carbon/human/proc/measured_statcheck(mob/living/carbon/human/HT)
	var/finalprob = 40

	//We take the highest and the lowest stats, clamped to 14.
	var/max_target = min(max(HT.STASTR, HT.STACON, HT.STAWIL, HT.STAINT, HT.STAPER, HT.STASPD), 14)
	var/min_target = min(HT.STASTR, HT.STACON, HT.STAWIL, HT.STAINT, HT.STAPER, HT.STASPD)
	var/max_user = min(max(STASTR, STACON, STAWIL, STAINT, STAPER, STASPD), 14)
	var/min_user = min(STASTR, STACON, STAWIL, STAINT, STAPER, STASPD)
	
	if(max_target > max_user)
		finalprob -= max_target
	if(min_target > min_user)
		finalprob -= 3 * min_target
	
	if(max_target < max_user)
		finalprob += max_user
	if(min_target < min_user)
		finalprob += 3 * min_user

	finalprob = clamp(finalprob, 5, 75)

	if(STALUC > HT.STALUC)
		finalprob += rand(1, rand(1,25))	//good luck mathing this out, code divers
	if(STALUC < HT.STALUC)
		finalprob -= rand(1, rand(1,25))

	return prob(finalprob)

/mob/living/carbon/human/proc/has_duelist_ring()
	if(wear_ring)
		if(istype(wear_ring, /obj/item/clothing/ring/duelist))
			return TRUE
	return FALSE

/// Returns the highest AC worn, or held in hands.
/mob/living/carbon/human/proc/highest_ac_worn(check_hands)
	var/list/slots = list(wear_armor, wear_pants, wear_wrists, wear_shirt, gloves, head, shoes, wear_neck, wear_mask, wear_ring)
	for(var/slot in slots)
		if(isnull(slot) || !istype(slot, /obj/item/clothing))
			slots.Remove(slot)
	
	var/highest_ac = ARMOR_CLASS_NONE

	for(var/obj/item/clothing/C in slots)
		if(C.armor_class)
			if(C.armor_class > highest_ac)
				highest_ac = C.armor_class
				if(highest_ac == ARMOR_CLASS_HEAVY)
					return highest_ac
	if(check_hands)
		var/mainh = get_active_held_item()
		var/offh = get_inactive_held_item()
		if(mainh && istype(mainh, /obj/item/clothing))
			var/obj/item/clothing/CMH = mainh
			if(CMH.armor_class > highest_ac)
				highest_ac = CMH.armor_class 
		if(offh && istype(offh, /obj/item/clothing))
			var/obj/item/clothing/COH = offh
			if(COH.armor_class > highest_ac)
				highest_ac = COH.armor_class 
	
	return highest_ac

/mob/living/carbon/human/proc/process_tempo_attack(mob/living/carbon/attacker)
	if(iscarbon(attacker) && attacker.mind && attacker != src)
		if(length(tempo_attackers) <= TEMPO_CAP || (attacker in tempo_attackers))	//This list auto-culls so we don't need to flood it. If you're fighting 7 dudes at the same time you've got other problems.
			var/newtime
			var/att_count = length(tempo_attackers)
			switch(att_count)
				if(0 to TEMPO_ONE)
					newtime = world.time + TEMPO_DELAY_ONE
				if(TEMPO_TWO)
					newtime = world.time + TEMPO_DELAY_TWO
				if(TEMPO_MAX to TEMPO_CAP)
					newtime = world.time + TEMPO_DELAY_MAX
			tempo_attackers[attacker] = newtime
			next_tempo_cull = world.time + TEMPO_CULL_DELAY	//We reset the autocull timer on a hit from a valid person.
		manage_tempo()

/mob/living/carbon/human/proc/manage_tempo()
	var/newcount
	newcount = length(tempo_attackers)
	switch(newcount)
		if(TEMPO_MAX to TEMPO_CAP)
			apply_status_effect(/datum/status_effect/buff/tempo_three)
			remove_status_effect(/datum/status_effect/buff/tempo_two)
			remove_status_effect(/datum/status_effect/buff/tempo_one)
		if(TEMPO_TWO)
			apply_status_effect(/datum/status_effect/buff/tempo_two)
			remove_status_effect(/datum/status_effect/buff/tempo_three)
			remove_status_effect(/datum/status_effect/buff/tempo_one)
		if(TEMPO_ONE)
			apply_status_effect(/datum/status_effect/buff/tempo_one)
			remove_status_effect(/datum/status_effect/buff/tempo_three)
			remove_status_effect(/datum/status_effect/buff/tempo_two)
		if(0 to (TEMPO_ONE - 1))
			remove_status_effect(/datum/status_effect/buff/tempo_one)
			remove_status_effect(/datum/status_effect/buff/tempo_two)
			remove_status_effect(/datum/status_effect/buff/tempo_three)

/mob/living/carbon/human/proc/cull_tempo_list()
	list_clear_nulls(tempo_attackers)	//I pray this never returns TRUE
	for(var/mob in tempo_attackers)
		if(tempo_attackers[mob] < world.time)
			tempo_attackers.Remove(mob)
	manage_tempo()

/mob/living/carbon/human/proc/clear_tempo_all()
	if(HAS_TRAIT(src, TRAIT_TEMPO))
		var/tempo_amt = length(tempo_attackers)
		if(tempo_amt)
			LAZYCLEARLIST(tempo_attackers)
			if(tempo_amt >= TEMPO_ONE)
				to_chat(src, span_info("My muscles relax. My tempo is gone."))
			manage_tempo()

/mob/living/proc/get_tempo_bonus(id)
	switch(id)
		//Bonus CDR for rclicks
		if(TEMPO_TAG_RCLICK_CD_BONUS)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 5 SECONDS
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 10 SECONDS
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 15 SECONDS
		//Bonus parry CDR. Note that default is 1.2 SECONDS
		if(TEMPO_TAG_PARRYCD_BONUS)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 0.2 SECONDS
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 0.4 SECONDS
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 0.6 SECONDS
		//Modifier for how much integ damage the weapon we parry with takes. Multiplier.
		if(TEMPO_TAG_DEF_INTEGFACTOR)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 0.75
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 0.5
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 0.25
		//Modifier for how much LESS sharpness we lose with the weapon we parry. Flat number.
		if(TEMPO_TAG_DEF_SHARPNESSFACTOR)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 1
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 2
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 3	//No default sharpness lost at max Tempo.
		//Whether we can parry without seeing the enemy
		if(TEMPO_TAG_NOLOS_PARRY)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return FALSE
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return TRUE
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return TRUE
			else
				return FALSE
		//How much less armor integ we lose on hit. Multiplier. (0 to 1)
		if(TEMPO_TAG_ARMOR_INTEGFACTOR)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 0.8
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 0.7
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 0.6
		//How much stamloss we take away from dodging. Flat number.
		if(TEMPO_TAG_STAMLOSS_DODGE)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 2
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 4
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 6
		//How much stamloss we take away from parrying. Flat number.
		if(TEMPO_TAG_STAMLOSS_PARRY)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 1
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 2
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 3
