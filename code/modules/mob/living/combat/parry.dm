#define STAM_DRAIN_PER_STR_DIFF_HEAVY_BAL -2

/mob/living/proc/attempt_parry(datum/intent/intenty, mob/living/user)
	var/prob2defend = user.defprob
	var/mob/living/H = src
	var/mob/living/U = user
	if(H && U)
		prob2defend = 0
	
	if(!can_see_cone(user))
		if(!H.get_tempo_bonus(TEMPO_TAG_NOLOS_PARRY))
			return FALSE
		if(d_intent == INTENT_PARRY)
			return FALSE
		else
			prob2defend = max(prob2defend-15,0)

//	if(!cmode) // not currently used, see cmode check above
//		prob2defend = max(prob2defend-15,0)

	if(m_intent == MOVE_INTENT_RUN)
		prob2defend = max(prob2defend-15,0)

	if(HAS_TRAIT(src, TRAIT_CHUNKYFINGERS))
		return FALSE
	if(pulledby || pulling)
		return FALSE

	var/parrydelay = setparrytime
	parrydelay -= get_tempo_bonus(TEMPO_TAG_PARRYCD_BONUS)
	if(world.time < last_parry + parrydelay)
		if(!istype(rmb_intent, /datum/rmb_intent/riposte))
			return FALSE
	if(has_status_effect(/datum/status_effect/debuff/exposed))
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/riposted))
		return FALSE
	last_parry = world.time
	if(intenty && !intenty.canparry)
		return FALSE
	var/drained = BASE_PARRY_STAMINA_DRAIN
	var/weapon_parry = FALSE
	var/offhand_defense = 0
	var/mainhand_defense = 0
	var/highest_defense = 0
	var/obj/item/mainhand = get_active_held_item()
	var/obj/item/offhand = get_inactive_held_item()
	var/obj/item/used_weapon = mainhand
	var/obj/item/rogueweapon/shield/buckler/skiller = get_inactive_held_item()  // buckler code
	var/obj/item/rogueweapon/shield/buckler/skillerbuck = get_active_held_item()

	if(istype(offhand, /obj/item/rogueweapon/shield/buckler))
		skiller.bucklerskill(H)
	if(istype(mainhand, /obj/item/rogueweapon/shield/buckler))
		skillerbuck.bucklerskill(H)  //buckler code end

	if(mainhand)
		if(mainhand.can_parry)
			mainhand_defense += (H.get_skill_level(mainhand.associated_skill) * 20)
			mainhand_defense += (mainhand.wdefense_dynamic * 10)
	if(offhand)
		if(offhand.can_parry)
			offhand_defense += (H.get_skill_level(offhand.associated_skill) * 20)
			offhand_defense += (offhand.wdefense_dynamic * 10)

	if(mainhand_defense >= offhand_defense)
		highest_defense += mainhand_defense
	else
		used_weapon = offhand
		highest_defense += offhand_defense

	var/defender_skill = 0
	var/attacker_skill = 0
	var/obj/item/clothing/wrists/roguetown/bracers/unarmed_bracers

	if(highest_defense <= (H.get_skill_level(/datum/skill/combat/unarmed) * 20))
		defender_skill = H.get_skill_level(/datum/skill/combat/unarmed)
		var/obj/B = H.get_item_by_slot(SLOT_WRISTS)
		if(istype(B, /obj/item/clothing/wrists/roguetown/bracers))
			prob2defend += (defender_skill * 35)
			unarmed_bracers = B
		else
			prob2defend += (defender_skill * 10)		// no bracers gonna be butts.
		weapon_parry = FALSE
	else
		if(used_weapon)
			defender_skill = H.get_skill_level(used_weapon.associated_skill)
		else
			defender_skill = H.get_skill_level(/datum/skill/combat/unarmed)
		prob2defend += highest_defense
		weapon_parry = TRUE

	if(intenty.masteritem)
		attacker_skill = U.get_skill_level(intenty.masteritem.associated_skill)

		if(intenty.sharpness_penalty)
			intenty.masteritem.remove_bintegrity(intenty.sharpness_penalty)

		prob2defend -= (attacker_skill * 20)
		if((intenty.masteritem.wbalance == WBALANCE_SWIFT) && (user.STASPD > src.STASPD)) //enemy weapon is quick, so get a bonus based on spddiff
			var/spdmod = ((user.STASPD - src.STASPD) * 10)
			var/permod = ((src.STAPER - user.STAPER) * 10)
			var/intmod = ((src.STAINT - user.STAINT) * 3)
			if(mind)
				if(permod > 0)
					spdmod -= permod
				if(intmod > 0)
					spdmod -= intmod
			var/finalmod = spdmod
			if(mind)
				finalmod = clamp(spdmod, 0, 30)
			prob2defend -= finalmod
	else
		attacker_skill = U.get_skill_level(/datum/skill/combat/unarmed)
		prob2defend -= (attacker_skill * 20)

	if(HAS_TRAIT(src, TRAIT_GUIDANCE))
		prob2defend += 20

	if(HAS_TRAIT(user, TRAIT_GUIDANCE))
		prob2defend -= 20
	
	if(HAS_TRAIT(user, TRAIT_CURSE_RAVOX))
		prob2defend -= 40

	// parrying while knocked down sucks ass
	if(!(mobility_flags & MOBILITY_STAND))
		prob2defend *= 0.65

	if(HAS_TRAIT(H, TRAIT_SENTINELOFWITS))
		if(ishuman(H))
			var/mob/living/carbon/human/SH = H
			var/sentinel = SH.calculate_sentinel_bonus()
			prob2defend += sentinel

	if(HAS_TRAIT(U, TRAIT_ARMOUR_LIKED))
		if(HAS_TRAIT(U, TRAIT_FENCERDEXTERITY))
			prob2defend -= 5

	prob2defend = clamp(prob2defend, 5, 90)
	if(HAS_TRAIT(user, TRAIT_HARDSHELL) && H.client)	//Dwarf-merc specific limitation w/ their armor on in pvp
		prob2defend = clamp(prob2defend, 5, 70)
	if(!H?.check_armor_skill())
		prob2defend = clamp(prob2defend, 5, 75)			//Caps your max parry to 75 if using armor you're not trained in. Bad dexerity.
		drained = drained + 5							//More stamina usage for not being trained in the armor you're using.

	//Dual Wielding
	var/defender_dualw
	var/extradefroll

	//Dual Wielder defense disadvantage
	if(HAS_TRAIT(src, TRAIT_DUALWIELDER) && (istype(offhand, mainhand) || istype(mainhand, offhand)))
		extradefroll = prob(prob2defend)
		defender_dualw = TRUE

	if(src.client?.prefs.showrolls)
		var/text = "Roll to parry... [prob2defend]%"
		if(defender_dualw)
			text += " Twice! Disadvantage! ([(prob2defend / 100) * (prob2defend / 100) * 100]%)"
		to_chat(src, span_info("[text]"))


	if(HAS_TRAIT(src, TRAIT_NODEF))
		prob2defend = 0

	var/parry_status = FALSE
	if(defender_dualw)
		if(prob(prob2defend) && extradefroll)
			parry_status = TRUE
	else
		if(prob(prob2defend))
			parry_status = TRUE

	if(parry_status)
		if(intenty.masteritem)
			if(intenty.masteritem.wbalance < WBALANCE_NORMAL && user.STASTR > src.STASTR) //enemy weapon is heavy, so get a bonus scaling on strdiff
				drained = drained + ( intenty.masteritem.wbalance * ((user.STASTR - src.STASTR) * STAM_DRAIN_PER_STR_DIFF_HEAVY_BAL) )
	else
		to_chat(src, span_warning("The enemy defeated my parry!"))
		if(HAS_TRAIT(src, TRAIT_MAGEARMOR))
			if(H.magearmor == 0)
				H.magearmor = 1
				H.apply_status_effect(/datum/status_effect/buff/magearmor)
				to_chat(src, span_boldwarning("My mage armor absorbs the hit and dissipates!"))
				return TRUE
			else
				return FALSE
		else
			return FALSE

	drained = max(drained, 5)

	var/exp_multi = 1

	if(!U.mind)
		exp_multi = exp_multi/2
	if(istype(user.rmb_intent, /datum/rmb_intent/weak))
		exp_multi = exp_multi/2

	var/obj/item/AB = intenty.masteritem
	var/attacker_skill_type

	if(AB)
		attacker_skill_type = AB.associated_skill
	else
		attacker_skill_type = /datum/skill/combat/unarmed

	if(weapon_parry == TRUE)
		if(do_parry(used_weapon, drained, user)) //show message
			//only gain experience if attacker and defender aren't using non-combat skills for their weapons
			if(ispath(attacker_skill_type, /datum/skill/combat) && ispath(used_weapon.associated_skill, /datum/skill/combat))
				if ((mobility_flags & MOBILITY_STAND))
					var/skill_target = attacker_skill
					if(!HAS_TRAIT(U, TRAIT_GOODTRAINER))
						skill_target -= SKILL_LEVEL_NOVICE
					if(HAS_TRAIT(U, TRAIT_BADTRAINER))
						skill_target -= SKILL_LEVEL_NOVICE
					if (can_train_combat_skill(src, used_weapon.associated_skill, skill_target))
						mind.add_sleep_experience(used_weapon.associated_skill, max(round(STAINT*exp_multi), 0), FALSE)

				//attacker skill gain
				if(U.mind)
					if ((mobility_flags & MOBILITY_STAND))
						var/skill_target = defender_skill
						if(!HAS_TRAIT(src, TRAIT_GOODTRAINER))
							skill_target -= SKILL_LEVEL_NOVICE
						if(HAS_TRAIT(U, TRAIT_BADTRAINER))
							skill_target -= SKILL_LEVEL_NOVICE
						if (can_train_combat_skill(U, attacker_skill_type, skill_target))
							U.mind.add_sleep_experience(attacker_skill_type, max(round(STAINT*exp_multi), 0), FALSE)

			if(prob(66) && AB)
				if((used_weapon.flags_1 & CONDUCT_1) && (AB.flags_1 & CONDUCT_1))
					flash_fullscreen("whiteflash")
					user.flash_fullscreen("whiteflash")
					var/datum/effect_system/spark_spread/S = new()
					var/turf/front = get_step(src,src.dir)
					S.set_up(1, 1, front)
					S.start()
				else
					flash_fullscreen("blackflash2")
			else
				flash_fullscreen("blackflash2")

			var/dam2take = round((get_complex_damage(AB,user,used_weapon.blade_dulling)/2),1)
			if(dam2take)
				var/intdam = used_weapon.max_blade_int ? INTEG_PARRY_DECAY : INTEG_PARRY_DECAY_NOSHARP
				var/sharp_loss = SHARPNESS_ONHIT_DECAY
				if(used_weapon == offhand)
					intdam = INTEG_PARRY_DECAY_NOSHARP

				if(istype(user.rmb_intent, /datum/rmb_intent/strong))
					sharp_loss += STRONG_SHP_BONUS
					intdam += STRONG_INTG_BONUS
          
				var/tempobonus = H.get_tempo_bonus(TEMPO_TAG_DEF_INTEGFACTOR)
				if(tempobonus)	//It is either null or 0.1 to 1, multiplication by null results in 0, so we check.
					intdam *= tempobonus
         
				used_weapon.take_damage(intdam, BRUTE, used_weapon.d_type)
				used_weapon.remove_bintegrity(sharp_loss, user)
			return TRUE
		else
			return FALSE

	if(weapon_parry == FALSE)
		if(do_unarmed_parry(drained, user))
			//only gain experience if attacker isn't using a non-combat skill for their weapon
			if(ispath(attacker_skill_type, /datum/skill/combat))
				if((mobility_flags & MOBILITY_STAND))
					var/skill_target = attacker_skill
					if(!HAS_TRAIT(U, TRAIT_GOODTRAINER))
						skill_target -= SKILL_LEVEL_NOVICE
					if(HAS_TRAIT(U, TRAIT_BADTRAINER))
						skill_target -= SKILL_LEVEL_NOVICE
					if(can_train_combat_skill(H, /datum/skill/combat/unarmed, skill_target))
						H.mind?.add_sleep_experience(/datum/skill/combat/unarmed, max(round(STAINT*exp_multi), 0), FALSE)

			if(unarmed_bracers)
				unarmed_bracers.take_damage(INTEG_PARRY_DECAY_NOSHARP, "slash", armor_penetration = 100)
			flash_fullscreen("blackflash2")
			return TRUE
		else

			return FALSE

/mob/proc/do_parry(obj/item/W, parrydrain as num, mob/living/user)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		//Tempo bonus
		parrydrain -= H.get_tempo_bonus(TEMPO_TAG_STAMLOSS_PARRY)
		if(H.stamina_add(parrydrain))
			if(W)
				playsound(get_turf(src), pick(W.parrysound), 100, FALSE)
			if(src.client)
				record_round_statistic(STATS_PARRIES)

			var/def_verb = "parries"
			var/att_verb = ""
			if(istype(rmb_intent, /datum/rmb_intent/riposte))
				def_verb = "[pick("expertly", "deftly")] parries"
			if(istype(user.rmb_intent, /datum/rmb_intent/strong))
				att_verb = "'s [pick("hefty", "strong")] attack"
			var/def_msg = "<b>[src]</b> [def_verb] [user][att_verb] with [W]!"

			visible_message(span_combatsecondary(def_msg), span_boldwarning(def_msg), COMBAT_MESSAGE_RANGE, list(user))
			to_chat(user, span_boldwarning(def_msg))

			if(!iscarbon(user))	//Non-carbon mobs never make it to the proper parry proc where the other calculations are done.
				if(W.max_blade_int)
					W.remove_bintegrity(SHARPNESS_ONHIT_DECAY, user)
					W.take_damage(INTEG_PARRY_DECAY, BRUTE, "slash")
				else
					W.take_damage(INTEG_PARRY_DECAY_NOSHARP, BRUTE, "slash")
			return TRUE
		else
			to_chat(src, span_warning("I'm too tired to parry!"))
			return FALSE //crush through
	else
		if(W)
			playsound(get_turf(src), pick(W.parrysound), 100, FALSE)
		return TRUE

/mob/proc/do_unarmed_parry(parrydrain as num, mob/living/user)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		//Tempo bonus
		parrydrain -= H.get_tempo_bonus(TEMPO_TAG_STAMLOSS_PARRY)

		if(H.stamina_add(parrydrain))
			playsound(get_turf(src), pick(parry_sound), 100, FALSE)
			src.visible_message(span_warning("<b>[src]</b> parries [user]!"))
			if(src.client)
				record_round_statistic(STATS_PARRIES)
			return TRUE
		else
			to_chat(src, span_boldwarning("I'm too tired to parry!"))
			return FALSE
	else
		if(src.client)
			record_round_statistic(STATS_PARRIES)
		playsound(get_turf(src), pick(parry_sound), 100, FALSE)
		return TRUE

#undef STAM_DRAIN_PER_STR_DIFF_HEAVY_BAL
