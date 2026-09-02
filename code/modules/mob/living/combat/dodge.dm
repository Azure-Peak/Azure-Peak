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

/mob/living/proc/attempt_dodge(datum/intent/attack_intent, mob/living/user)
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
	if(attack_intent)
		if(!attack_intent.candodge)
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
		var/turf/dodge_turf
		if(fixedeye)
			var/dodgedir = turn(dir, 180)
			var/turf/turfcheck = get_step(src, dodgedir)
			if(turfcheck)
				if(check_dodge_turf(turfcheck))
					dodge_turf = turfcheck
		if(!dodge_turf)
			for(var/dodge_dir in shuffle(dirry.Copy()))
				var/turf/turfcheck = get_step(src, dodge_dir)
				if(turfcheck)
					if(check_dodge_turf(turfcheck))
						dodge_turf = turfcheck
						break
		if(pulledby)
			return FALSE
		if(!dodge_turf)
			to_chat(src, span_boldwarning("There's nowhere to dodge to!"))
			return FALSE
		else
			if(do_dodge(user, dodge_turf))
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
	var/moved = Move(step_to, get_dir(src, step_to))
	nodirchange = FALSE
	tempfixeye = FALSE
	fixedeye = was_fixedeye
	face_atom(target)
	if(moved)
		ai_controller?.advance_movement_cooldown()
	return TRUE

/mob/proc/do_dodge(mob/user, turf/dodge_turf)
	if(dodgecd)
		return FALSE
	var/mob/living/defender = src
	var/mob/living/attacker = user
	var/mob/living/carbon/human/defender_human
	var/mob/living/carbon/human/attacker_human
	var/obj/item/attacker_weapon
	var/obj/item/defender_mainhand = get_active_held_item()
	var/defender_skill = 0
	var/attacker_skill = 0
	var/drained = 8
	var/defender_offhand = get_inactive_held_item()
	if(ishuman(src))
		defender_human = src
		defender_skill = get_wskill(defender_mainhand, /datum/skill/combat/unarmed)
	if(ishuman(user))
		attacker_human = user
		attacker_weapon = attacker_human.get_active_held_item()
		attacker_skill = attacker_human.get_wskill(attacker_weapon, /datum/skill/combat/unarmed)
	var/prob2defend = attacker.defprob
	var/ignore_DE_bonus = FALSE
	var/is_in_cone = defender.can_see_cone(user)
	if(!is_in_cone && defender_human)
		is_in_cone = defender_human?.get_tempo_bonus(TEMPO_TAG_NOLOS_DODGE)
	if(!is_in_cone)
		defender.changeNext_def(CLAMP(dodgetime + 2, 0, CLICK_CD_DODGE))
		defender.changeMaxDodge(-2)
	var/defender_dodge_expert = defender_human?.check_dodge_skill()
	if(defender.stamina >= defender.max_stamina)
		return FALSE
	if(src.client)
		log_combat(src, user, "dodged against")
	if(defender)
		prob2defend = prob2defend + (defender.STASPD * 10)
	if(attacker)
		var/dodgemod = 10
		// This is to compensate for getting swarmed / flanked by simplemobs which can (somewhat)
		// Occur more frequently. DE users will be able to dodge those a bit better even if DE
		// Behaviour doesn't trigger.
		if(defender_dodge_expert && !attacker.mind && !attacker_human)
			dodgemod = 5
		prob2defend = prob2defend - (attacker.STASPD * dodgemod)
	if(attacker_weapon)
		if(attacker_weapon.wbalance == WBALANCE_SWIFT && attacker.STASPD > defender.STASPD) //nme weapon is quick, so they get a bonus based on spddiff
			prob2defend = prob2defend - ( attacker_weapon.wbalance * ((attacker.STASPD - defender.STASPD) * 10) )
		if(attacker_weapon.wbalance == WBALANCE_HEAVY && defender.STASPD > attacker.STASPD) //nme weapon is slow, so its easier to dodge if we're faster
			prob2defend = prob2defend + ( attacker_weapon.wbalance * ((attacker.STASPD - defender.STASPD) * 10) )
		prob2defend = prob2defend - (attacker_human.get_wskill(attacker_weapon) * 10)
	if(defender_human)
		if(!defender_human?.check_armor_skill() || defender_human?.legcuffed)
			defender_human.Knockdown(1)
			defender_human.drop_all_held_items()
			to_chat(defender_human, span_warning("I can't dodge in such unfitting armor! I'm knocked down!"))
			return FALSE
		if(attacker_weapon) //the enemy attacked us with a weapon
			if(!attacker_weapon.has_wskill()) //the enemy weapon doesn't have a skill because its improvised, so penalty to attack
				prob2defend = prob2defend + 10
			else
				prob2defend = prob2defend + (defender_human.get_wskill(attacker_weapon) * 10)
		else //the enemy attacked us unarmed or is nonhuman
			if(attacker_human)
				if(attacker_human.used_intent.unarmed)
					prob2defend = prob2defend - (attacker_human.get_skill_level(/datum/skill/combat/unarmed) * 10)
					prob2defend = prob2defend + (defender_human.get_skill_level(/datum/skill/combat/unarmed) * 10)
					if(attacker.STASPD > defender.STASPD) //unarmed is inherently swift
						prob2defend = prob2defend - ((attacker.STASPD - defender.STASPD) * 10)
			else if(attacker.skills)
				var/datum/intent/attacker_intent = attacker.used_intent
				prob2defend = prob2defend - (attacker.get_wskill(attacker_intent?.masteritem, /datum/skill/combat/unarmed) * 10)
				prob2defend = prob2defend + (defender_human.get_skill_level(/datum/skill/combat/unarmed) * 10)



		if(HAS_TRAIT(user, TRAIT_CURSE_RAVOX))
			prob2defend -= 40
			ignore_DE_bonus = TRUE

		// dodging while knocked down sucks ass
		if(!(defender.mobility_flags & MOBILITY_STAND))
			prob2defend *= 0.25
			ignore_DE_bonus = TRUE

		if(defender_human && HAS_TRAIT(defender_human, TRAIT_SENTINELOFWITS))
			var/sentinel = defender_human.calculate_sentinel_bonus()
			prob2defend += sentinel

		if(attacker_human && HAS_TRAIT(attacker_human, TRAIT_ARMOUR_LIKED))
			if(HAS_TRAIT(attacker_human, TRAIT_FENCERDEXTERITY))
				prob2defend -= 10
				ignore_DE_bonus = TRUE

		if(!is_in_cone)
			ignore_DE_bonus = TRUE

		if(defender.STASPD <= 9)
			ignore_DE_bonus = TRUE

		if(attacker_weapon && defender_mainhand)	//Skilldiff applies extra stamloss, tentative
			drained += (attacker_human.get_wskill(attacker_weapon) - defender_human.get_wskill(defender_mainhand)) * 2

			if(istype(attacker.rmb_intent, /datum/rmb_intent/swift) && attacker_weapon.wbalance != WBALANCE_HEAVY)
				// We drain extra stam if we're being attacked by swift stance, inversely based on our dodgetime
				// This is quite tentative and the numbers can be whatever, but this is meant to make Swift a good option
				// Without allowing "just spam them down" to work all that well.
				if(dodgetime <= CLICK_CD_FAST)
					drained += (abs(round((CLICK_CD_HEAVY - dodgetime) / 2)))

		if(defender_dodge_expert && defender_human.mind && !ignore_DE_bonus)
			prob2defend = DODGE_EXPERT_BASE_CAP	//We cap it out if we have Dodge Expert as a Player.

		if(defender_human.STASPD < attacker.STASPD)
			if(defender_mainhand && defender_mainhand.wbalance != WBALANCE_HEAVY)
				drained += (attacker.STASPD - defender_human.STASPD)

		if(dodgetime <= CLICK_CD_DODGE && !ignore_DE_bonus && defender_dodge_expert && defender_human.mind)
			if(istype(defender_mainhand, /obj/item/rogueweapon/shield) || istype(defender_offhand, /obj/item/rogueweapon/shield))	//why do I have to pre-empt the worst of you
				if(!istype(defender_mainhand, /obj/item/rogueweapon/shield/buckler) && !istype(defender_offhand, /obj/item/rogueweapon/shield/buckler))
					max_dodge = MAX_DODGE_FLOOR
					defender.changeNext_def(CLICK_CD_DODGE)
		prob2defend = clamp((prob2defend + max_dodge), 5, (90 + max_dodge))

		// Dual wield drawback (-5%)
		var/dualwield_penalty = HAS_TRAIT(src, TRAIT_DUALWIELDER) && defender_human.can_dualwield(defender_mainhand, defender_offhand)
		if(dualwield_penalty)
			prob2defend = max(prob2defend - 5, 0)

		if(src.client?.prefs.showrolls)
			var/text = "Roll to dodge... [HAS_TRAIT(user, TRAIT_DECEIVING_MEEKNESS) ? "???" : prob2defend]%"

			if(dualwield_penalty)
				text += " (-5%)"

			to_chat(src, span_info(text))

		if(defender.has_status_effect(/datum/status_effect/swingdelay/penalty))
			prob2defend = clamp(prob2defend - 50, 5, 90)

		if(!prob(prob2defend))
			return FALSE

		if(!attacker_human?.mind) // For NPC, reduce the drained to 5 stamina
			drained = 5

		//Tempo bonus
		var/stamdrain = max(drained,5)
		stamdrain -= defender_human.get_tempo_bonus(TEMPO_TAG_STAMLOSS_DODGE)

		if(!defender_human.stamina_add(stamdrain))
			to_chat(src, span_warning("I'm too tired to dodge!"))
			return FALSE
	else //we are a non human
		var/mob/living/simple_animal/beast = isanimal(src) ? src : null
		prob2defend = SIMPLEMOB_DODGE_BASE + ((defender.STASPD - attacker.STASPD) * SIMPLEMOB_DODGE_PER_SPD)
		if(attacker_weapon && attacker_human)
			prob2defend -= attacker_human.get_wskill(attacker_weapon) * SIMPLEMOB_DODGE_PER_SKILL
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
		throw_at(dodge_turf, 1, 2, src, FALSE)
	if(drained > 0)
		src.visible_message(span_warning("<b>[src]</b> dodges [user]'s attack!"))
	else
		src.visible_message(span_warning("<b>[src]</b> easily dodges [user]'s attack!"))
	if(get_dist(src, user) <= user.used_intent?.reach)	//We are still in range of the attacker's weapon post-dodge
		var/probclip = 50
		var/obj/item/defender_clip_weapon = defender.get_active_held_item()
		var/obj/item/attacker_clip_weapon = attacker.get_active_held_item()
		if(defender_clip_weapon)
			if(defender_clip_weapon.wlength > WLENGTH_NORMAL)
				probclip += (defender_clip_weapon.wlength - WLENGTH_NORMAL) * 10	//if wlength isn't standardised this might skyrocket it to >100%
			else
				probclip -= (WLENGTH_NORMAL - defender_clip_weapon.wlength) * 10
		var/dist = (user.used_intent?.reach - get_dist(src, user)) - 1 //-1 because we already are in range and triggered this check to begin with.
		if(dist > 0)
			probclip += dist * 10
		if(defender.STALUC != attacker.STALUC)
			var/lucmod = defender.STALUC - attacker.STALUC
			probclip += lucmod * 10
		if(prob(probclip) && defender_clip_weapon && attacker_clip_weapon)
			var/intdam = defender_clip_weapon.max_blade_int ? INTEG_PARRY_DECAY : INTEG_PARRY_DECAY_NOSHARP
			var/sharp_loss = SHARPNESS_ONHIT_DECAY
			if(istype(user.rmb_intent, /datum/rmb_intent/strong))
				sharp_loss += STRONG_SHP_BONUS
				intdam += STRONG_INTG_BONUS

			defender_clip_weapon.take_damage(intdam, BRUTE, attacker_clip_weapon.d_type)
			defender_clip_weapon.remove_bintegrity(sharp_loss, src)

			user.visible_message(span_warning("<b>[user]</b> clips [src]'s weapon!"))
			playsound(user, 'sound/misc/weapon_clip.ogg', 100)
	dodgecd = FALSE
	var/ignore_penalty = FALSE
	if((defender.fixedeye && defender.goodluck(5)))
		ignore_penalty = TRUE
	if(!ignore_penalty && !ignore_DE_bonus && defender_dodge_expert)
		var/max_mod = 0
		max_mod = defender_skill - attacker_skill

		var/tempo_result = defender.get_tempo_bonus(TEMPO_TAG_DODGE_LOSS)
		//TEMPO_DODGE_LOSS_NONE results in this not being accessed at all, so no loss. We're in a 1v4 in that context, so, like, yeah.
		if(tempo_result == TEMPO_DODGE_LOSS_NORMAL || (tempo_result == TEMPO_DODGE_LOSS_LESS && prob(33)))
			defender.changeNext_def(clamp(dodgetime + 1, 0, CLICK_CD_DODGE))
			defender.changeMaxDodge(-1 + ((max_mod < 0) ? max_mod : 0))
//		if(defender_human)
//			if(defender_human.IsOffBalanced())
//				defender_human.Knockdown(1)
//				to_chat(defender_human, span_danger("I tried to dodge off-balance!"))
//		if(isturf(loc))
//			var/turf/T = loc
//			if(T.landsound)
//				playsound(T, T.landsound, 100, FALSE)
	return TRUE
