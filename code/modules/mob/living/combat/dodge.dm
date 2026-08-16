/mob/living/simple_animal
	// Pseudo dodge expert system for simple animals that let you exhausts them with normal attacks
	var/dodge_fatigue = 0
	var/dodge_fatigue_updated = 0
	var/winded_until = 0

/mob/living/simple_animal/proc/is_winded()
	return world.time < winded_until

/mob/living/simple_animal/proc/current_dodge_fatigue()
	if(dodge_fatigue <= 0)
		return 0
	var/idle = world.time - dodge_fatigue_updated - SIMPLEMOB_DODGE_RECOVERY_DELAY
	if(idle <= 0)
		return dodge_fatigue
	dodge_fatigue = max(0, dodge_fatigue - round((idle / 10) * SIMPLEMOB_DODGE_FATIGUE_REGEN, 1))
	dodge_fatigue_updated = world.time
	return dodge_fatigue

/mob/living/simple_animal/proc/spend_dodge_reserve()
	dodge_fatigue = min(current_dodge_fatigue() + SIMPLEMOB_DODGE_FATIGUE_PER_DODGE, SIMPLEMOB_DODGE_FATIGUE_MAX)
	dodge_fatigue_updated = world.time
	if(dodge_fatigue < SIMPLEMOB_DODGE_FATIGUE_MAX)
		return
	winded_until = world.time + SIMPLEMOB_WINDED_DURATION
	dodge_fatigue = 0
	visible_message(span_boldwarning("[src] is winded!"))
	balloon_alert_to_viewers("<font color='#ff3b3b'>winded!</font>")

/mob/living/proc/attempt_dodge(datum/intent/intenty, mob/living/user)
	if(pulledby || pulling)
		return FALSE
	if(isanimal(src))
		var/mob/living/simple_animal/beast = src
		if(beast.is_winded())
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

/mob/living/proc/combat_sidestep(atom/target, list/offsets, prefer_flank = FALSE)
	if(QDELETED(target) || !isturf(loc) || !isturf(target.loc))
		return FALSE
	if(!(mobility_flags & MOBILITY_STAND))
		return FALSE
	var/target_dir = get_dir(src, target)
	if(!target_dir)
		return FALSE
	var/static/list/lateral_offsets = list(-90, -45, 45, 90)
	if(!length(offsets))
		offsets = lateral_offsets
	var/list/candidates = list()
	for(var/offset in offsets)
		var/turf/candidate = get_step(src, turn(target_dir, offset))
		if(check_dodge_turf(candidate))
			candidates += candidate
	if(!length(candidates))
		return FALSE
	if(prefer_flank && ismob(target))
		var/mob/victim = target
		var/list/frontal = list(victim.dir, turn(victim.dir, 45), turn(victim.dir, -45))
		var/list/flanking = list()
		for(var/turf/candidate as anything in candidates)
			if(!(get_dir(victim, candidate) in frontal))
				flanking += candidate
		if(length(flanking))
			candidates = flanking
	var/turf/step_to = pick(candidates)
	var/was_fixedeye = fixedeye
	tempfixeye = TRUE
	nodirchange = TRUE
	fixedeye = TRUE
	Move(step_to, get_dir(src, step_to))
	nodirchange = FALSE
	tempfixeye = FALSE
	fixedeye = was_fixedeye
	face_atom(target)
	return TRUE

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
	var/mainh = get_active_held_item()
	var/offh = get_inactive_held_item()
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
		prob2defend = prob2defend + (L.STASPD * 10)
	if(U)
		var/dodgemod = 10
		// This is to compensate for getting swarmed / flanked by simplemobs which can (somewhat)
		// Occur more frequently. DE users will be able to dodge those a bit better even if DE
		// Behaviour doesn't trigger.
		if(has_trait && !U.mind && !UH)
			dodgemod = 5
		prob2defend = prob2defend - (U.STASPD * dodgemod)
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
			else if(U.skills)
				var/datum/intent/attacker_intent = U.used_intent
				var/attacker_skill_type = attacker_intent?.masteritem?.associated_skill || /datum/skill/combat/unarmed
				prob2defend = prob2defend - (U.get_skill_level(attacker_skill_type) * 10)



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

		if(L.STASPD <= 9)
			ignore_DE_bonus = TRUE

		if(I && IL)	//Skilldiff applies extra stamloss, tentative
			drained += (UH.get_skill_level(I.associated_skill) - H.get_skill_level(IL.associated_skill)) * 2

			if(istype(U.rmb_intent, /datum/rmb_intent/swift) && I.wbalance != WBALANCE_HEAVY)
				// We drain extra stam if we're being attacked by swift stance, inversely based on our dodgetime
				// This is quite tentative and the numbers can be whatever, but this is meant to make Swift a good option
				// Without allowing "just spam them down" to work all that well.
				if(dodgetime <= CLICK_CD_FAST)
					drained += (abs(round((CLICK_CD_HEAVY - dodgetime) / 2)))

		if(has_trait && H.mind && !ignore_DE_bonus)
			prob2defend = DODGE_EXPERT_BASE_CAP	//We cap it out if we have Dodge Expert as a Player.

		if(H.STASPD < U.STASPD)
			if(IL && IL.wbalance != WBALANCE_HEAVY)
				drained += (U.STASPD - H.STASPD)

		if(dodgetime <= CLICK_CD_DODGE && !ignore_DE_bonus && has_trait && H.mind)
			if(istype(mainh, /obj/item/rogueweapon/shield) || istype(offh, /obj/item/rogueweapon/shield))	//why do I have to pre-empt the worst of you
				if(!istype(mainh, /obj/item/rogueweapon/shield/buckler) && !istype(offh, /obj/item/rogueweapon/shield/buckler))
					max_dodge = MAX_DODGE_FLOOR
					L.changeNext_def(CLICK_CD_DODGE)
		prob2defend = clamp((prob2defend + max_dodge), 5, (90 + max_dodge))

		// Dual wield drawback (-5%)
		var/dualwield_penalty = HAS_TRAIT(src, TRAIT_DUALWIELDER) && H.can_dualwield(mainh, offh)
		if(dualwield_penalty)
			prob2defend = max(prob2defend - 5, 0)

		if(src.client?.prefs.showrolls)
			var/text = "Roll to dodge... [HAS_TRAIT(user, TRAIT_DECEIVING_MEEKNESS) ? "???" : prob2defend]%"

			if(dualwield_penalty)
				text += " (-5%)"

			to_chat(src, span_info(text))

		if(L.has_status_effect(/datum/status_effect/swingdelay/penalty))
			prob2defend = clamp(prob2defend - 50, 5, 90)

		var/dodge_status = FALSE

		if(prob(prob2defend))
			dodge_status = TRUE

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
		var/mob/living/simple_animal/beast = isanimal(src) ? src : null
		prob2defend = SIMPLEMOB_DODGE_BASE + ((L.STASPD - U.STASPD) * SIMPLEMOB_DODGE_PER_SPD)
		if(I && UH)
			prob2defend -= UH.get_skill_level(I.associated_skill) * SIMPLEMOB_DODGE_PER_SKILL
		if(beast)
			prob2defend -= beast.current_dodge_fatigue()
		prob2defend = clamp(prob2defend, 5, SIMPLEMOB_DODGE_CAP)
		if(client?.prefs.showrolls)
			to_chat(src, span_info("Roll to dodge... [prob2defend]%"))
		if(!prob(prob2defend))
			return FALSE
		beast?.spend_dodge_reserve()
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
