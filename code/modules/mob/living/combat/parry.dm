#define STAM_DRAIN_PER_STR_DIFF_HEAVY_BAL -2

// Unarmed base weapon defense equivalents — fed into the same (skill * 20) + (wdef * 10) formula as weapons
#define UNARMED_BASE_WDEF_BARE 2		// Bare fists — still bad, but not hopeless
#define UNARMED_BASE_WDEF_EQUIPPED 7	// Bracers / knuckles / bandages — matches a rapier

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

	if(world.time < (last_parry + parrydelay))
		if(!istype(rmb_intent, /datum/rmb_intent/riposte))
			return FALSE
	if(has_status_effect(/datum/status_effect/debuff/exposed) || has_status_effect(/datum/status_effect/debuff/vulnerable))
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/riposted))
		return FALSE

	if(!intenty)
		intenty = user.used_intent

	if(intenty && !intenty.canparry)
		return FALSE

	last_parry = world.time
	if(!istype(rmb_intent, /datum/rmb_intent/riposte))
		var/parrytime = setparrytime
		parrytime -= get_tempo_bonus(TEMPO_TAG_PARRYCD_BONUS)
		changeNext_def(parrytime)
	
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
	var/obj/item/clothing/gloves/roguetown/knuckles/unarmed_knuckles
	var/obj/item/clothing/gloves/roguetown/bandages/unarmed_bandages

	// Calculate unarmed parry value from bracers/knuckles/bandages
	var/unarmed_skill = H.get_skill_level(/datum/skill/combat/unarmed)
	var/unarmed_defense = 0
	var/obj/B = H.get_item_by_slot(SLOT_WRISTS)
	var/obj/K = H.get_item_by_slot(SLOT_GLOVES)
	var/is_pugilist = HAS_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN) // Only expert pugilists get the generous unarmed wdef
	if(istype(B, /obj/item/clothing/wrists/roguetown/bracers))
		unarmed_defense = (unarmed_skill * 20) + ((is_pugilist ? UNARMED_BASE_WDEF_EQUIPPED : UNARMED_BASE_WDEF_BARE) * 10)
		unarmed_bracers = B
	else if(istype(K, /obj/item/clothing/gloves/roguetown/knuckles))
		unarmed_defense = (unarmed_skill * 20) + ((is_pugilist ? UNARMED_BASE_WDEF_EQUIPPED : UNARMED_BASE_WDEF_BARE) * 10)
		unarmed_knuckles = K
	else if(istype(K, /obj/item/clothing/gloves/roguetown/bandages))
		unarmed_defense = (unarmed_skill * 20) + ((is_pugilist ? UNARMED_BASE_WDEF_EQUIPPED : UNARMED_BASE_WDEF_BARE) * 10)
		unarmed_bandages = K
	else
		unarmed_defense = (unarmed_skill * 20) + (UNARMED_BASE_WDEF_BARE * 10)

	// If held weapon uses unarmed skill (katar, etc), allow unarmed parry fallback
	var/allow_unarmed_fallback = FALSE
	if(used_weapon)
		if(used_weapon.associated_skill == /datum/skill/combat/unarmed)
			allow_unarmed_fallback = TRUE
	else	//We have nothing.
		allow_unarmed_fallback = TRUE

	if(highest_defense > 0 && (!allow_unarmed_fallback || highest_defense >= unarmed_defense))
		// Weapon parry wins
		if(used_weapon)
			defender_skill = H.get_skill_level(used_weapon.associated_skill)
		else
			defender_skill = unarmed_skill
		prob2defend += highest_defense
		weapon_parry = TRUE
	else if(allow_unarmed_fallback && unarmed_defense > highest_defense)
		// Unarmed parry is better than the unarmed-skill weapon's own wdefense
		defender_skill = unarmed_skill
		prob2defend += unarmed_defense
		weapon_parry = FALSE
	else
		// No parry-capable weapon - pure unarmed
		defender_skill = unarmed_skill
		prob2defend += unarmed_defense
		weapon_parry = FALSE

	// We're one-handing a swift-balanced weapon (rapiers, sabers, etc). Small parry boost (1 wdef equiv.)
	if(mainhand && !offhand)
		if(used_weapon.wbalance == WBALANCE_SWIFT)
			prob2defend += 10

	if(intenty.masteritem)
		attacker_skill = U.get_skill_level(intenty.masteritem.associated_skill)

		if(intenty.sharpness_penalty)
			intenty.masteritem.remove_bintegrity(intenty.sharpness_penalty)

		prob2defend -= (attacker_skill * 20)
		if(!HAS_TRAIT(user, TRAIT_FENCERDEXTERITY))	// Yet another Frei related clamp
			if(!has_status_effect(/datum/status_effect/buff/weapon_binded))
				if((intenty.masteritem.wbalance == WBALANCE_SWIFT) && (user.STASPD > src.STASPD)) //enemy weapon is quick, so get a bonus based on spddiff
					var/spdmod = ((user.STASPD - src.STASPD) * 10)
					var/permod = ((src.STAPER - user.STAPER) * 5)
					var/intmod = ((src.STAINT - user.STAINT) * 3)
					if(mind)
						if(permod > 0)
							spdmod -= permod
						if(intmod > 0)
							spdmod -= intmod
					var/finalmod = spdmod
					if(mind)
						finalmod = clamp(spdmod, 0, 45)
					prob2defend -= finalmod
	else
		attacker_skill = U.get_skill_level(/datum/skill/combat/unarmed)
		prob2defend -= (attacker_skill * 20)
		if(user.STASPD > src.STASPD) //unarmed is inherently swift
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

	// --- Weapon binding! ---

	if(has_status_effect(/datum/status_effect/buff/weapon_binded))
		prob2defend += 20
	if(!has_status_effect(/datum/status_effect/buff/weapon_binded) && !has_status_effect(/datum/status_effect/debuff/weapon_binded))
		if(ishuman(src) && user.get_tempo_bonus(TEMPO_TAG_BINDABLE) && mind)
			var/mob/living/carbon/human/HL = src
			if(HL.try_bind(used_weapon, user))
				return TRUE	//Tentative, might be better if it only increased parry chance on the initial binding rather than a full block.

	// --- Weapon Binding End! ---

	if(HAS_TRAIT(src, TRAIT_GUIDANCE))
		prob2defend += FULL_GUIDANCE_CHANCE
	else if(HAS_TRAIT(src, TRAIT_LESSER_GUIDANCE))
		prob2defend += LESSER_GUIDANCE_CHANCE

	if(HAS_TRAIT(user, TRAIT_GUIDANCE))
		prob2defend -= FULL_GUIDANCE_CHANCE
	else if(HAS_TRAIT(user, TRAIT_LESSER_GUIDANCE))
		prob2defend -= LESSER_GUIDANCE_CHANCE

	if(HAS_TRAIT(src, TRAIT_REVERSE_GUIDANCE))
		prob2defend -= FULL_GUIDANCE_CHANCE
	else if(HAS_TRAIT(src, TRAIT_LESSER_REVERSE_GUIDANCE))
		prob2defend -= LESSER_GUIDANCE_CHANCE

	if(HAS_TRAIT(user, TRAIT_REVERSE_GUIDANCE))
		prob2defend += FULL_GUIDANCE_CHANCE
	else if(HAS_TRAIT(user, TRAIT_LESSER_REVERSE_GUIDANCE))
		prob2defend += LESSER_GUIDANCE_CHANCE
	
	if(HAS_TRAIT(user, TRAIT_CURSE_RAVOX))
		prob2defend -= 40

	// parrying while knocked down sucks ass
	if(!(mobility_flags & MOBILITY_STAND) && !has_status_effect(/datum/status_effect/buff/weapon_binded))
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
	var/untrained_armor = FALSE
	if(!H?.check_armor_skill())
		prob2defend = clamp(prob2defend, 5, 75)			//Caps your max parry to 75 if using armor you're not trained in. Bad dexerity.
		drained = drained + 5							//More stamina usage for not being trained in the armor you're using.
		untrained_armor = TRUE

	//Dual Wielding
	var/defender_dualw
	var/extradefroll

	//Dual Wielder defense disadvantage
	if(HAS_TRAIT(src, TRAIT_DUALWIELDER) && (istype(offhand, mainhand) || istype(mainhand, offhand)))
		extradefroll = prob(prob2defend)
		defender_dualw = TRUE

	var/text = "Roll to parry... [HAS_TRAIT(user, TRAIT_DECEIVING_MEEKNESS) ? "???" : prob2defend]%"
	if(defender_dualw)
		text += " Twice! Disadvantage! [!HAS_TRAIT(user, TRAIT_DECEIVING_MEEKNESS) ? "([(prob2defend / 100) * (prob2defend / 100) * 100]%)" : ""]"

	if(has_status_effect(/datum/status_effect/swingdelay/penalty))
		prob2defend = clamp(prob2defend - 50, 5, 90)

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
		if(!has_status_effect(/datum/status_effect/buff/weapon_binded))
			if(intenty.masteritem)
				if(intenty.masteritem.wbalance < WBALANCE_NORMAL && user.STASTR > src.STASTR) //enemy weapon is heavy, so get a bonus scaling on strdiff
					drained = drained + ( intenty.masteritem.wbalance * ((user.STASTR - src.STASTR) * STAM_DRAIN_PER_STR_DIFF_HEAVY_BAL) )
	else
		text += span_warning(" The enemy defeated my parry!")
	if(src.client?.prefs.showrolls)
		to_chat(src, span_info("[text]"))

	// Failed parry cutoff here
	if(!parry_status)
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
		if(do_parry(used_weapon, drained, user, untrained_armor)) //show message
			//only gain experience if attacker and defender aren't using non-combat skills for their weapons
			if(ispath(attacker_skill_type, /datum/skill/combat) && ispath(used_weapon.associated_skill, /datum/skill/combat))
				if ((mobility_flags & MOBILITY_STAND))
					var/skill_target = attacker_skill
					if(!HAS_TRAIT(U, TRAIT_GOODTRAINER))
						skill_target -= SKILL_LEVEL_NOVICE
					if(HAS_TRAIT(U, TRAIT_BADTRAINER))
						skill_target -= SKILL_LEVEL_APPRENTICE
					if (can_train_combat_skill(src, used_weapon.associated_skill, skill_target))
						mind.add_sleep_experience(used_weapon.associated_skill, max(round(STAINT*exp_multi), 0), FALSE)

				//attacker skill gain
				if(U.mind)
					if ((mobility_flags & MOBILITY_STAND))
						var/skill_target = defender_skill
						if(!HAS_TRAIT(src, TRAIT_GOODTRAINER))
							skill_target -= SKILL_LEVEL_NOVICE
						if(HAS_TRAIT(U, TRAIT_BADTRAINER))
							skill_target -= SKILL_LEVEL_APPRENTICE
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

			if(AB)
				var/dam2take = round((get_complex_damage(AB,user,used_weapon.blade_dulling)/2),1)
				if(dam2take)
					var/intdam = used_weapon.max_blade_int ? INTEG_PARRY_DECAY : INTEG_PARRY_DECAY_NOSHARP
					var/sharp_loss = SHARPNESS_ONHIT_DECAY
					if(used_weapon == offhand)
						intdam = INTEG_PARRY_DECAY_NOSHARP

					if(istype(user.rmb_intent, /datum/rmb_intent/strong))
						sharp_loss += STRONG_SHP_BONUS
						intdam += STRONG_INTG_BONUS

					// Heavy weapons chew through shields — use higher of demolition_mod or intent intdamage_factor
					if(istype(used_weapon, /obj/item/rogueweapon/shield) && intenty)
						var/shield_mult = max(intenty.demolition_mod, intenty.intent_intdamage_factor)
						intdam *= shield_mult

					var/tempobonus = H.get_tempo_bonus(TEMPO_TAG_DEF_INTEGFACTOR)
					if(tempobonus)	//It is either null or 0.1 to 1, multiplication by null results in 0, so we check.
						intdam *= tempobonus

					if(!has_status_effect(/datum/status_effect/buff/weapon_binded))
						used_weapon.take_damage(intdam, BRUTE, used_weapon.d_type)
						used_weapon.remove_bintegrity(sharp_loss, user)
			else
				// Unarmed attacker
				var/intdam = INTEG_PARRY_DECAY_UNARMED
				if(istype(used_weapon, /obj/item/rogueweapon/shield) && intenty)
					intdam *= intenty.intent_intdamage_factor
				used_weapon.take_damage(intdam, BRUTE, used_weapon.d_type)
			if(mind)
				dodgetime = CLAMP(dodgetime - 2, 0, CLICK_CD_DODGE)
				changeMaxDodge(2)
			return TRUE
		else
			return FALSE

	if(weapon_parry == FALSE)
		if(do_unarmed_parry(drained, user, untrained_armor))
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
			else if(unarmed_knuckles)
				unarmed_knuckles.take_damage(INTEG_PARRY_DECAY_NOSHARP, "slash", armor_penetration = 100)
			else if(unarmed_bandages)
				unarmed_bandages.take_damage(INTEG_PARRY_DECAY_NOSHARP, "slash", armor_penetration = 100)
			flash_fullscreen("blackflash2")
			if(mind)
				dodgetime = CLAMP(dodgetime - 2, 0, CLICK_CD_DODGE)
				changeMaxDodge(2)
			return TRUE
		else

			return FALSE

/mob/proc/do_parry(obj/item/W, parrydrain as num, mob/living/user, untrained_armor = FALSE)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		//Tempo bonus
		parrydrain -= H.get_tempo_bonus(TEMPO_TAG_STAMLOSS_PARRY)
		if(H.stamina_add(parrydrain))
			if(W)
				playsound(get_turf(src), pick(W.parrysound), 100, FALSE)
			if(src.client)
				record_round_statistic(STATS_PARRIES)
				log_combat(src, user, "parried")


			var/def_verb = "parries"
			var/att_verb = ""
			if(istype(rmb_intent, /datum/rmb_intent/riposte))
				def_verb = "[pick("expertly", "deftly")] parries"
			if(istype(user.rmb_intent, /datum/rmb_intent/strong))
				att_verb = "'s [pick("hefty", "strong")] attack"
			var/def_msg = "<b>[src]</b> [def_verb] [user][att_verb] with [W]!"
			if(untrained_armor)
				def_msg += " Untrained Armor Penalty!"

			visible_message(span_combatsecondary(def_msg), span_boldwarning(def_msg), COMBAT_MESSAGE_RANGE, list(user))
			to_chat(user, span_boldwarning(def_msg))

			for(var/mob/living/L in get_hearers_in_view(4, src, RECURSIVE_CONTENTS_CLIENT_MOBS))
				if(!L.has_flaw(/datum/charflaw/addiction/clamorous))
					continue
				if(prob(7 + (L.STALUC - 10)))
					L.sate_addiction(/datum/charflaw/addiction/clamorous)

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

/mob/proc/do_unarmed_parry(parrydrain as num, mob/living/user, untrained_armor = FALSE)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		//Tempo bonus
		parrydrain -= H.get_tempo_bonus(TEMPO_TAG_STAMLOSS_PARRY)

		if(H.stamina_add(parrydrain))
			playsound(get_turf(src), pick(parry_sound), 100, FALSE)
			var/parry_msg = "<b>[src]</b> parries [user]!"
			if(untrained_armor)
				parry_msg += " Untrained Armor Penalty!"
			src.visible_message(span_warning(parry_msg))
			if(src.client)
				record_round_statistic(STATS_PARRIES)
				log_combat(src, user, "parried")
			return TRUE
		else
			to_chat(src, span_boldwarning("I'm too tired to parry!"))
			return FALSE
	else
		if(src.client)
			record_round_statistic(STATS_PARRIES)
			log_combat(src, user, "parried")
		playsound(get_turf(src), pick(parry_sound), 100, FALSE)
		return TRUE

/mob/living/proc/pick_bind_sfx(wbalance)
	switch(wbalance)
		if(WBALANCE_NORMAL)
			return pick('sound/foley/binds/bind_normal1.ogg','sound/foley/binds/bind_normal2.ogg','sound/foley/binds/bind_normal3.ogg','sound/foley/binds/bind_normal4.ogg','sound/foley/binds/bind_normal5.ogg','sound/foley/binds/bind_normal6.ogg','sound/foley/binds/bind_normal7.ogg','sound/foley/binds/bind_normal8.ogg','sound/foley/binds/bind_normal9.ogg','sound/foley/binds/bind_normal10.ogg','sound/foley/binds/bind_normal11.ogg','sound/foley/binds/bind_normal12.ogg','sound/foley/binds/bind_normal13.ogg','sound/foley/binds/bind_normal14.ogg')
		if(WBALANCE_HEAVY)
			return pick('sound/foley/binds/bind_heavy1.ogg','sound/foley/binds/bind_heavy2.ogg','sound/foley/binds/bind_heavy3.ogg','sound/foley/binds/bind_heavy4.ogg','sound/foley/binds/bind_heavy5.ogg','sound/foley/binds/bind_heavy6.ogg','sound/foley/binds/bind_heavy7.ogg','sound/foley/binds/bind_heavy8.ogg','sound/foley/binds/bind_heavy9.ogg','sound/foley/binds/bind_heavy10.ogg','sound/foley/binds/bind_heavy11.ogg','sound/foley/binds/bind_heavy12.ogg')
		if(WBALANCE_SWIFT)
			return pick('sound/foley/binds/bind_swift1.ogg','sound/foley/binds/bind_swift2.ogg','sound/foley/binds/bind_swift3.ogg','sound/foley/binds/bind_swift4.ogg','sound/foley/binds/bind_swift5.ogg','sound/foley/binds/bind_swift6.ogg')
#undef STAM_DRAIN_PER_STR_DIFF_HEAVY_BAL
#undef UNARMED_BASE_WDEF_BARE
#undef UNARMED_BASE_WDEF_EQUIPPED
