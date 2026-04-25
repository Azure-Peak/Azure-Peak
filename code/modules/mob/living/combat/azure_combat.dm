/mob/living/carbon/human/proc/process_clash(mob/user, obj/item/IM, obj/item/IU)
	if(!ishuman(user))
		return
	if(user == src)
		bad_guard(span_warning("I hit myself."))
		return
	var/mob/living/carbon/human/H = user
	if(!IU)	//The opponent is trying to rawdog us with their bare hands while we have Guard up. We get a free attack on their active hand.
		if(!IM)	//We are also unarmed -- no clash or riposte without a weapon on the guarder's side.
			remove_status_effect(/datum/status_effect/buff/clash)
			return
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
		apply_status_effect(/datum/status_effect/buff/adrenaline_rush)
		return
	if(!IM)	//We are guarding unarmed but they have a weapon -- no clash, just consume the guard to block the hit.
		visible_message(span_warning("[src] deflects [H]'s strike with [p_their()] bare hands!"))
		playsound(src, 'sound/combat/clash_struck.ogg', 100)
		H.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		H.apply_status_effect(/datum/status_effect/debuff/clickcd, 3 SECONDS)
		if(H.mind)
			H.dodgetime = clamp(H.dodgetime + 5, 0, CLICK_CD_HEAVY)
		H.Slowdown(3)
		to_chat(src, span_notice("[capitalize(H.p_theyre())] exposed!"))
		remove_status_effect(/datum/status_effect/buff/clash)
		apply_status_effect(/datum/status_effect/buff/adrenaline_rush)
		return
	if(H.has_status_effect(/datum/status_effect/buff/clash))	//They also have Riposte active. It'll trigger the special event.
		clash(user, IM, IU)
	else	//Otherwise, we just riposte them.
		var/sharpnesspenalty = RIPOSTE_SHARPNESS_FACTOR
		if(IM.wbalance == WBALANCE_HEAVY || IU.blade_dulling == DULLING_SHAFT_CONJURED)
			sharpnesspenalty += 0.05
		if(IU.max_blade_int)
			IU.remove_bintegrity((IU.blade_int * sharpnesspenalty), user)
		else
			var/integdam = max((IU.max_integrity / RIPOSTE_INTEG_DIVISOR), (INTEG_PARRY_DECAY_NOSHARP * 5))
			if(IU.blade_dulling == DULLING_SHAFT_CONJURED)
				integdam *= 2
			IU.take_damage(integdam, BRUTE, IM.d_type)
		visible_message(span_suicide("[src] ripostes [H] with \the [IM]!"))
		playsound(src, 'sound/combat/clash_struck.ogg', 100)
		H.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		H.apply_status_effect(/datum/status_effect/debuff/clickcd, 3 SECONDS)
		if(H.mind)
			H.dodgetime = clamp(H.dodgetime + 5, 0, CLICK_CD_HEAVY)
		dodgetime = clamp(dodgetime - 5, 0, CLICK_CD_DODGE)
		H.Slowdown(3)
		
		to_chat(src, span_notice("[capitalize(H.p_theyre())] exposed!"))
		remove_status_effect(/datum/status_effect/buff/clash)
		apply_status_effect(/datum/status_effect/buff/adrenaline_rush)
		H.reset_desert_rider_momentum_tier()

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

	if(has_vendetta() && HU.has_vendetta())
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

/mob/living/carbon/human/proc/try_guard()
	if(has_status_effect(/datum/status_effect/buff/clash) || has_status_effect(/datum/status_effect/debuff/clashcd) || has_status_effect(/datum/status_effect/buff/clash/limbguard))
		return FALSE
	if(!get_active_held_item())
		if(get_skill_level(/datum/skill/combat/unarmed) < 3)
			to_chat(src, span_warning("I'm not skilled enough in the art of unarmed combat to guard without a weapon!"))
			return FALSE
	if(r_grab || l_grab || length(grabbedby))
		return FALSE
	if(IsImmobilized() || IsOffBalanced())
		return FALSE
	if(m_intent == MOVE_INTENT_RUN)
		to_chat(src, span_warning("I can't focus on this while running."))
		return FALSE
	// Can't guard while channeling a spell
	var/datum/action/cooldown/spell/active_spell = click_intercept
	if(istype(active_spell) && (active_spell.currently_charging || active_spell.charged))
		to_chat(src, span_warning("I can't guard while channeling a spell!"))
		return FALSE

	if(is_swinging(disrupt_only = TRUE))
		return FALSE

	if(has_status_effect(/datum/status_effect/debuff/exposed))
		return FALSE

	apply_status_effect(/datum/status_effect/buff/clash)
	return TRUE

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

///Purges the singular possible bait stack after waiting for a bit out of combat.
/mob/living/carbon/human/proc/purge_bait()
	if(!cmode)
		if(bait_stacks > 0)
			bait_stacks = 0
			to_chat(src, span_info("My focus and balance returns. I won't lose my footing if I am baited again."))

/mob/living/carbon/human/proc/reset_dodgetime()
	if(!cmode && mind)
		dodgetime = 0
		max_dodge = MAX_DODGE_CEIL

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

/mob/living/carbon/human/proc/has_vendetta()
	if(HAS_TRAIT(src, TRAIT_VENDETTA))
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
	if(iscarbon(attacker) && attacker != src && attacker.mind)
		if(length(tempo_attackers) <= TEMPO_CAP || (REF(attacker) in tempo_attackers))	//This list auto-culls so we don't need to flood it. If you're fighting 7 dudes at the same time you've got other problems.
			var/newtime
			var/att_count = length(tempo_attackers)
			switch(att_count)
				if(0 to TEMPO_ONE)
					newtime = world.time + TEMPO_DELAY_ONE
				if(TEMPO_TWO)
					newtime = world.time + TEMPO_DELAY_TWO
				if(TEMPO_MAX to TEMPO_CAP)
					newtime = world.time + TEMPO_DELAY_MAX
			tempo_attackers[REF(attacker)] = newtime
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
			if(tempo_amt >= TEMPO_MAX)
				playsound_local(src, 'sound/combat/tempo_loss.ogg', 85, TRUE)
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
			else
				return 0
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
		//Whether we care about our attacker being in our FOV when dodging.
		if(TEMPO_TAG_NOLOS_DODGE)
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
				return 3
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 5
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 7
		//How much stamloss we take away from parrying. Flat number.
		if(TEMPO_TAG_STAMLOSS_PARRY)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 1
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 2
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 3
		//Whether our baiters / feinters have to be in FOV of us.
		if(TEMPO_TAG_FEINTBAIT_FOV)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return FALSE
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return TRUE
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return TRUE
		//Whether we lose max dodge and increase our dodge delay after a dodge.
		if(TEMPO_TAG_DODGE_LOSS)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return TEMPO_DODGE_LOSS_LESS
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return TEMPO_DODGE_LOSS_NONE
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return TEMPO_DODGE_LOSS_NONE
			else
				return TEMPO_DODGE_LOSS_NORMAL
		//Whether we can get binded.
		if(TEMPO_TAG_BINDABLE)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return FALSE
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return FALSE
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return FALSE
			else
				return TRUE


/// A defensive boon from matching subzones.
/mob/living/carbon/human/proc/try_bind(obj/item/used_weapon, mob/living/user, vuln_exception = FALSE)	//user is the attacker in this context
	if(!used_weapon)
		return
	if(!user.get_active_held_item())
		return
	if(get_skill_level(used_weapon.associated_skill) < SKILL_LEVEL_JOURNEYMAN)
		return
	if(has_status_effect(/datum/status_effect/debuff/bindcd))
		return
	if(check_bind(check_bind_subzone(zone_selected), user.zone_selected) || (!user.mind && (check_zone(zone_selected) == check_zone(user.zone_selected))) || (vuln_exception && zone_selected != BODY_ZONE_CHEST))
		var/chance = 100	//Only here so chest vs chest has a smaller chance to trigger a bind.
		if(zone_selected == user.zone_selected && zone_selected == BODY_ZONE_CHEST)
			chance = 3
		if(prob(chance))
			apply_status_effect(/datum/status_effect/buff/weapon_binded)
			//!change_feint(-FEINT_PERC_DECREASE_BASE, user)
			//user.apply_status_effect(/datum/status_effect/debuff/bindcd)

			var/cd = BIND_CD
			var/cd_mod = get_tempo_bonus(TEMPO_TAG_RCLICK_CD_BONUS)
			cd = max((cd - cd_mod), 10.1 SECONDS)	// This is the duration of the bind itself + 1 tick, to prevent any screwiness.
			apply_status_effect(/datum/status_effect/debuff/bindcd, cd)

			// Immob. Mostly for dramatic flair. ClickCD is to prevent instant follow-up attacks.
			user.Immobilize(0.3 SECONDS)
			user.changeNext_move(CLICK_CD_CHARGED)
			user.changeNext_def(user.parrydelay)

			if(get_tempo_bonus(TEMPO_TAG_BINDABLE))
				Immobilize(0.3 SECONDS)
				changeNext_move(CLICK_CD_FAST)

			var/obj/item/rogueweapon/RW = user.get_active_held_item()
			if(RW)
				RW.take_damage(RW.sharpness ? (INTEG_PARRY_DECAY) : (INTEG_PARRY_DECAY_NOSHARP), BRUTE, used_weapon.d_type)
				RW.remove_bintegrity((SHARPNESS_ONHIT_DECAY), src)
			
			//if(used_weapon)
			//	used_weapon.take_damage((used_weapon.sharpness ? (INTEG_PARRY_DECAY) : (INTEG_PARRY_DECAY_NOSHARP)), BRUTE, used_weapon.d_type)
			//	used_weapon.remove_bintegrity((SHARPNESS_ONHIT_DECAY), src)

			if(vuln_exception)	// If we triggered this via a vuln attack, we suffer an extra penalty.
				used_weapon.take_damage((INTEG_PARRY_DECAY_NOSHARP * 3), BRUTE, used_weapon.d_type)
				used_weapon.remove_bintegrity((SHARPNESS_ONHIT_DECAY * 3), src)

			flash_fullscreen("whiteflash")
			user.flash_fullscreen("whiteflash")
			var/turf/front = get_turf(src)
			do_sparks(4, FALSE, front)

			var/soundcategory = WBALANCE_NORMAL
			var/sfx
			if(used_weapon)
				soundcategory = used_weapon.wbalance
			sfx = pick_bind_sfx(soundcategory)
			if(sfx)
				playsound(src, sfx, 100, TRUE, 2)
			visible_message(span_notice("[src] binds their weapon with [user]'s! They saw that attack coming!"))
			return TRUE
		else
			return FALSE
