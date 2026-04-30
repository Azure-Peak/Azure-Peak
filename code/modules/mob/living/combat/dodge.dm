/mob/living/proc/attempt_dodge(datum/intent/intenty, mob/living/user)
	if(pulledby || pulling)
		return FALSE
	if(world.time < last_dodge + dodgetime)
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/riposted))
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/exposed) || has_status_effect(/datum/status_effect/debuff/vulnerable))
		return FALSE
	last_dodge = world.time
	if(src.loc == user.loc)
		return FALSE
	if(intenty)
		if(!intenty.candodge)
			return FALSE
	if(HAS_TRAIT(src, TRAIT_NODEF))
		return FALSE
	if(candodge)
		var/list/dirry = list()
		var/dx = x - user.x
		var/dy = y - user.y
		if(abs(dx) < abs(dy))
			if(dy > 0)
				dirry += NORTH
				dirry += WEST
				dirry += EAST
			else
				dirry += SOUTH
				dirry += WEST
				dirry += EAST
		else
			if(dx > 0)
				dirry += EAST
				dirry += SOUTH
				dirry += NORTH
			else
				dirry += WEST
				dirry += NORTH
				dirry += SOUTH
		var/turf/turfy
		if(fixedeye)
			var/dodgedir = turn(dir, 180)
			var/turf/turfcheck = get_step(src, dodgedir)
			if(turfcheck)
				if(check_dodge_turf(turfcheck))
					turfy = turfcheck
		if(!turfy)
			for(var/x in shuffle(dirry.Copy()))
				var/turf/turfcheck = turfy = get_step(src,x)
				if(turfcheck)
					if(check_dodge_turf(turfcheck))
						turfy = turfcheck
						break
		if(pulledby)
			return FALSE
		if(!turfy)
			to_chat(src, span_boldwarning("There's nowhere to dodge to!"))
			return FALSE
		else
			if(do_dodge(user, turfy))
				flash_fullscreen("blackflash2")
				user.aftermiss()
				return TRUE
			else
				return FALSE
	else
		return FALSE

/mob/living/proc/check_dodge_turf(turf/check_turf)
	if(!check_turf)
		return FALSE
	if(check_turf.density)
		return FALSE
	for(var/atom/movable/AM in check_turf.contents)
		if(AM.density)
			return FALSE
	return TRUE

// origin is used for multi-step dodges like jukes
/mob/living/proc/get_dodge_destinations(mob/living/attacker, atom/origin = src)
	var/dodge_dir = get_dir(attacker, origin)
	if(!dodge_dir) // dir is 0, so we're on the same tile.
		return null
	var/list/dirry = list(turn(dodge_dir, -90), dodge_dir, turn(dodge_dir, 90))
	// pick a random dir
	var/list/turf/dodge_candidates = list()
	for(var/dir_to_check in dirry)
		var/turf/dodge_candidate = get_step(origin, dir_to_check)
		if(!dodge_candidate)
			continue
		if(dodge_candidate.density)
			continue
		var/has_impassable_atom = FALSE
		for(var/atom/movable/AM in dodge_candidate)
			if(!AM.CanPass(src, dodge_candidate))
				has_impassable_atom = TRUE
				break
		if(has_impassable_atom)
			continue
		dodge_candidates += dodge_candidate
	return dodge_candidates

/mob/proc/do_dodge(mob/user, turf/turfy)
	if(dodgecd)
		return FALSE
	var/mob/living/L = src
	var/mob/living/U = user
	var/mob/living/carbon/human/H
	var/mob/living/carbon/human/UH
	var/obj/item/I
	var/obj/item/IL
	var/ourskill = 0
	var/theirskill = 0
	var/drained = 8
	var/drained_npc = 5
	if(ishuman(src))
		H = src
		IL = H.get_active_held_item()
		if(IL && IL?.associated_skill)
			ourskill = get_skill_level(IL.associated_skill)
		else
			ourskill = get_skill_level(/datum/skill/combat/unarmed)
	if(ishuman(user))
		UH = user
		I = UH.get_active_held_item()
		if(I && I?.associated_skill)
			theirskill = UH.get_skill_level(I.associated_skill)
		else
			theirskill = UH.get_skill_level(/datum/skill/combat/unarmed)
	var/prob2defend = U.defprob
	var/ignore_DE_bonus = FALSE
	var/is_in_cone = L.can_see_cone(user)
	if(!is_in_cone && H)
		is_in_cone = H?.get_tempo_bonus(TEMPO_TAG_NOLOS_DODGE)
	if(!is_in_cone)
		L.changeNext_def(CLAMP(dodgetime + 2, 0, CLICK_CD_DODGE))
		L.changeMaxDodge(-2)
	var/has_trait = H?.check_dodge_skill()
	if(L.stamina >= L.max_stamina)
		return FALSE
	if(src.client)
		log_combat(src, user, "dodged against")
	if(L)
		if(has_trait && is_in_cone)
			prob2defend = prob2defend + (L.STASPD * 15)
		else
			prob2defend = prob2defend + (L.STASPD * 10)
	if(U)
		prob2defend = prob2defend - (U.STASPD * 10)
	if(I)
		if(I.wbalance == WBALANCE_SWIFT && U.STASPD > L.STASPD) //nme weapon is quick, so they get a bonus based on spddiff
			prob2defend = prob2defend - ( I.wbalance * ((U.STASPD - L.STASPD) * 10) )
		if(I.wbalance == WBALANCE_HEAVY && L.STASPD > U.STASPD) //nme weapon is slow, so its easier to dodge if we're faster
			prob2defend = prob2defend + ( I.wbalance * ((U.STASPD - L.STASPD) * 10) )
		prob2defend = prob2defend - (UH.get_skill_level(I.associated_skill) * 10)
	if(H)
		if(!H?.check_armor_skill() || H?.legcuffed)
			H.Knockdown(1)
			H.drop_all_held_items()
			to_chat(H, span_warning("I can't dodge in such unfitting armor! I'm knocked down!"))
			return FALSE
		if(I) //the enemy attacked us with a weapon
			if(!I.associated_skill) //the enemy weapon doesn't have a skill because its improvised, so penalty to attack
				prob2defend = prob2defend + 10
			else
				prob2defend = prob2defend + (H.get_skill_level(I.associated_skill) * 10)
		else //the enemy attacked us unarmed or is nonhuman
			if(UH)
				if(UH.used_intent.unarmed)
					prob2defend = prob2defend - (UH.get_skill_level(/datum/skill/combat/unarmed) * 10)
					prob2defend = prob2defend + (H.get_skill_level(/datum/skill/combat/unarmed) * 10)
					if(U.STASPD > L.STASPD) //unarmed is inherently swift
						prob2defend = prob2defend - ((U.STASPD - L.STASPD) * 10)


		if(HAS_TRAIT(L, TRAIT_GUIDANCE))
			prob2defend += FULL_GUIDANCE_CHANCE
		else if(HAS_TRAIT(L, TRAIT_LESSER_GUIDANCE))
			prob2defend += LESSER_GUIDANCE_CHANCE

		if(HAS_TRAIT(U, TRAIT_GUIDANCE))
			prob2defend -= FULL_GUIDANCE_CHANCE
			ignore_DE_bonus = TRUE
		else if(HAS_TRAIT(U, TRAIT_LESSER_GUIDANCE))
			prob2defend -= LESSER_GUIDANCE_CHANCE

		if(HAS_TRAIT(L, TRAIT_REVERSE_GUIDANCE))
			prob2defend -= FULL_GUIDANCE_CHANCE
		else if(HAS_TRAIT(L, TRAIT_LESSER_REVERSE_GUIDANCE))
			prob2defend -= LESSER_GUIDANCE_CHANCE

		if(HAS_TRAIT(U, TRAIT_REVERSE_GUIDANCE))
			prob2defend += FULL_GUIDANCE_CHANCE
		else if(HAS_TRAIT(U, TRAIT_LESSER_REVERSE_GUIDANCE))
			prob2defend += LESSER_GUIDANCE_CHANCE
		
		if(HAS_TRAIT(user, TRAIT_CURSE_RAVOX))
			prob2defend -= 40
			ignore_DE_bonus = TRUE

		// dodging while knocked down sucks ass
		if(!(L.mobility_flags & MOBILITY_STAND))
			prob2defend *= 0.25
			ignore_DE_bonus = TRUE

		if(H && HAS_TRAIT(H, TRAIT_SENTINELOFWITS))
			var/sentinel = H.calculate_sentinel_bonus()
			prob2defend += sentinel

		if(UH && HAS_TRAIT(UH, TRAIT_ARMOUR_LIKED))
			if(HAS_TRAIT(UH, TRAIT_FENCERDEXTERITY))
				prob2defend -= 10
				ignore_DE_bonus = TRUE
		
		if(!is_in_cone)
			ignore_DE_bonus = TRUE

		if(I && IL)	//Skilldiff applies extra stamloss, tentative
			drained += (UH.get_skill_level(I.associated_skill) - H.get_skill_level(IL.associated_skill))

			if(istype(U.rmb_intent, /datum/rmb_intent/swift) && I.wbalance != WBALANCE_HEAVY)
				drained += 3	//We drain extra stam if we're being attacked by swift stance

		if(has_trait && H.mind && !ignore_DE_bonus && H.STASPD > 10)
			prob2defend = 90	//We cap it out if we have Dodge Expert as a Player.

		if(dodgetime <= CLICK_CD_DODGE && !ignore_DE_bonus && has_trait && H.mind)

			var/mainh = get_active_held_item()
			var/offh = get_inactive_held_item()
			if(istype(mainh, /obj/item/rogueweapon/shield) || istype(offh, /obj/item/rogueweapon/shield))	//why do I have to pre-empt the worst of you
				if(!istype(mainh, /obj/item/rogueweapon/shield/buckler) && !istype(offh, /obj/item/rogueweapon/shield/buckler))
					max_dodge = MAX_DODGE_FLOOR
					L.changeNext_def(CLICK_CD_DODGE)
		prob2defend = clamp((prob2defend + max_dodge), 5, (90 + max_dodge))

		//------------Dual Wielding Checks------------
		var/attacker_dualw
		var/defender_dualw
		var/extradefroll
		var/mainhand = L.get_active_held_item()
		var/offhand	= L.get_inactive_held_item()

		//Dual Wielder defense disadvantage
		if(mainhand && offhand)
			if(HAS_TRAIT(src, TRAIT_DUALWIELDER) && istype(offhand, mainhand))
				extradefroll = prob(prob2defend)
				defender_dualw = TRUE

		//dual-wielder attack advantage
		var/obj/item/mainh = U.get_active_held_item()
		var/obj/item/offh = U.get_inactive_held_item()
		if(mainh && offh && HAS_TRAIT(U, TRAIT_DUALWIELDER))
			if(istype(mainh, offh))
				attacker_dualw = TRUE
		//----------Dual Wielding check end---------

		var/attacker_feedback 

		if(src.client?.prefs.showrolls)
			var/text = "Roll to dodge... [HAS_TRAIT(user, TRAIT_DECEIVING_MEEKNESS) ? "???" : prob2defend]%"
			if((defender_dualw || attacker_dualw))
				if(defender_dualw && attacker_dualw)
					text += " Our dual wielding cancels out!"
				else//If we're defending against or as a dual wielder, we roll disadv. But if we're both dual wielding it cancels out.
					text += " Twice! Disadvantage! [!HAS_TRAIT(user, TRAIT_DECEIVING_MEEKNESS) ? "([(prob2defend / 100) * (prob2defend / 100) * 100]%)" : ""]"
			to_chat(src, span_info("[text]"))

		if(user.client?.prefs.showrolls && !HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS) && has_trait && client)
			to_chat(user, span_info("Their roll to dodge was... [prob2defend]%"))

		if(L.has_status_effect(/datum/status_effect/swingdelay/penalty))
			prob2defend = clamp(prob2defend - 50, 5, 90)

		var/dodge_status = FALSE
		if((!defender_dualw && !attacker_dualw) || (defender_dualw && attacker_dualw)) //They cancel each other out
			if(attacker_feedback)
				attacker_feedback = "Advantage cancelled out!"
			if(prob(prob2defend))
				dodge_status = TRUE
		else if(attacker_dualw)
			if(prob(prob2defend))
				dodge_status = TRUE
		else if(defender_dualw)
			if(prob(prob2defend) && extradefroll)
				dodge_status = TRUE

		if(attacker_feedback)
			to_chat(user, span_info("[attacker_feedback]"))

		if(!dodge_status)
			return FALSE

		if(!UH?.mind) // For NPC, reduce the drained to 5 stamina
			drained = drained_npc

		//Tempo bonus
		var/stamdrain = max(drained,5)
		stamdrain -= H.get_tempo_bonus(TEMPO_TAG_STAMLOSS_DODGE)

		if(!H.stamina_add(stamdrain))
			to_chat(src, span_warning("I'm too tired to dodge!"))
			return FALSE
	else //we are a non human
		prob2defend = clamp(prob2defend, 5, 90)
		if(client?.prefs.showrolls)
			to_chat(src, span_info("Roll to dodge... [prob2defend]%"))
		if(!prob(prob2defend))
			return FALSE
	dodgecd = TRUE
	playsound(src, 'sound/combat/dodge.ogg', 100, FALSE)
	if(!HAS_TRAIT(src, TRAIT_DODGE_NO_MOVE))
		throw_at(turfy, 1, 2, src, FALSE)
	if(drained > 0)
		src.visible_message(span_warning("<b>[src]</b> dodges [user]'s attack!"))
	else
		src.visible_message(span_warning("<b>[src]</b> easily dodges [user]'s attack!"))
	if(get_dist(src, user) <= user.used_intent?.reach)	//We are still in range of the attacker's weapon post-dodge
		var/probclip = 50
		var/obj/item/IS = L.get_active_held_item()
		var/obj/item/IU = U.get_active_held_item()
		if(IS)
			if(IS.wlength > WLENGTH_NORMAL)
				probclip += (IS.wlength - WLENGTH_NORMAL) * 10	//if wlength isn't standardised this might skyrocket it to >100%
			else
				probclip -= (WLENGTH_NORMAL - IS.wlength) * 10
		var/dist = (user.used_intent?.reach - get_dist(src, user)) - 1 //-1 because we already are in range and triggered this check to begin with.
		if(dist > 0)
			probclip += dist * 10
		if(L.STALUC != U.STALUC)
			var/lucmod = L.STALUC - U.STALUC
			probclip += lucmod * 10
		if(prob(probclip) && IS && IU)
			var/intdam = IS.max_blade_int ? INTEG_PARRY_DECAY : INTEG_PARRY_DECAY_NOSHARP
			var/sharp_loss = SHARPNESS_ONHIT_DECAY
			if(istype(user.rmb_intent, /datum/rmb_intent/strong))
				sharp_loss += STRONG_SHP_BONUS
				intdam += STRONG_INTG_BONUS

			IS.take_damage(intdam, BRUTE, IU.d_type)
			IS.remove_bintegrity(sharp_loss, src)

			user.visible_message(span_warning("<b>[user]</b> clips [src]'s weapon!"))
			playsound(user, 'sound/misc/weapon_clip.ogg', 100)
	dodgecd = FALSE
	var/ignore_penalty = FALSE
	if((L.fixedeye && L.goodluck(5)))
		ignore_penalty = TRUE
	if(!ignore_penalty && !ignore_DE_bonus && has_trait)
		var/max_mod = 0
		max_mod = ourskill - theirskill

		var/tempo_result = L.get_tempo_bonus(TEMPO_TAG_DODGE_LOSS)
		//TEMPO_DODGE_LOSS_NONE results in this not being accessed at all, so no loss. We're in a 1v4 in that context, so, like, yeah.
		if(tempo_result == TEMPO_DODGE_LOSS_NORMAL || (tempo_result == TEMPO_DODGE_LOSS_LESS && prob(33)))
			L.changeNext_def(clamp(dodgetime + 1, 0, CLICK_CD_DODGE))
			L.changeMaxDodge(-1 + ((max_mod < 0) ? max_mod : 0))
//		if(H)
//			if(H.IsOffBalanced())
//				H.Knockdown(1)
//				to_chat(H, span_danger("I tried to dodge off-balance!"))
//		if(isturf(loc))
//			var/turf/T = loc
//			if(T.landsound)
//				playsound(T, T.landsound, 100, FALSE)
	return TRUE
