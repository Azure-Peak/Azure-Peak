/datum/rmb_intent
	var/name = "intent"
	var/desc = ""
	var/icon_state = ""
	/// Whether this intent requires user to be adjacent to their target or not
	var/adjacency = TRUE
	/// Determines whether this intent can be used during click cd
	var/bypasses_click_cd = FALSE
	/// Whether the rclick will try to get turfs as target.
	var/prioritize_turfs = FALSE

/mob/living/carbon/human/on_cmode()
	if(!cmode)	//We just toggled it off.
		addtimer(CALLBACK(src, PROC_REF(purge_bait)), 30 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		addtimer(CALLBACK(src, PROC_REF(expire_peel)), 60 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	if(!HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
		filtered_balloon_alert(TRAIT_COMBAT_AWARE, (cmode ? ("<i><font color = '#831414'>Tense</font></i>") : ("<i><font color = '#c7c6c6'>Relaxed</font></i>")), y_offset = 32)

/datum/rmb_intent/proc/special_attack(mob/living/user, atom/target)
	return

/datum/rmb_intent/aimed
	name = "aimed"
	desc = "Your attacks are more precise but have a longer recovery time. Higher critrate with precise attacks.\n(RMB WHILE COMBAT MODE IS ACTIVE) Bait out your targeted limb to the enemy. If it matches where they're aiming, they will be thrown off balance."
	icon_state = "rmbaimed"

/datum/rmb_intent/aimed/special_attack(mob/living/user, atom/target)
	if(!user)
		return
	if(user.incapacitated())
		return
	if(!ishuman(user))
		return
	if(!ishuman(target))
		return
	if(user == target)
		return
	
	var/mob/living/carbon/human/HT = target
	var/mob/living/carbon/human/HU = user
	var/target_zone = HT.zone_selected
	var/user_zone = HU.zone_selected

	if(HT.has_status_effect(/datum/status_effect/debuff/baited) || user.has_status_effect(/datum/status_effect/debuff/baitcd))
		return	//We don't do anything if either of us is affected by bait statuses

	HU.visible_message(span_danger("[HU] baits an attack from [HT]!"))
	HU.apply_status_effect(/datum/status_effect/debuff/baitcd)

	if((target_zone != user_zone) || ((target_zone == BODY_ZONE_CHEST) || (user_zone == BODY_ZONE_CHEST))) //Our zones do not match OR either of us is targeting chest.
		var/guaranteed_fail = TRUE
		switch(target_zone)
			if(BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_R_EYE)
				if(user_zone == BODY_ZONE_PRECISE_L_EYE || user_zone == BODY_ZONE_PRECISE_R_EYE)
					guaranteed_fail = FALSE
		if(guaranteed_fail)
			to_chat(HU, span_danger("It didn't work! [HT.p_their(TRUE)] footing returned!"))
			to_chat(HT, span_notice("I fooled [HU.p_them()]! I've regained my footing!"))
			HU.emote("groan")
			HU.stamina_add(HU.max_stamina * 0.2)
			HT.bait_stacks = 0
			return

	var/fatiguemod	//The heavier the target's armor, the more fatigue (green bar) we drain.
	var/targetac = HT.highest_ac_worn()
	switch(targetac)
		if(ARMOR_CLASS_NONE)
			fatiguemod = 5
		if(ARMOR_CLASS_LIGHT, ARMOR_CLASS_MEDIUM)
			fatiguemod = 4
		if(ARMOR_CLASS_HEAVY)
			fatiguemod = 3


	HT.apply_status_effect(/datum/status_effect/debuff/baited)
	HT.apply_status_effect(/datum/status_effect/debuff/exposed)
	HT.apply_status_effect(/datum/status_effect/debuff/clickcd, 5 SECONDS)
	HT.bait_stacks++
	if(HT.bait_stacks <= 1)
		HT.Immobilize(0.5 SECONDS)
		HT.stamina_add(HT.max_stamina / fatiguemod)
		HT.Slowdown(3)
		HT.emote("huh")
		HU.purge_peel(BAIT_PEEL_REDUCTION)
		HU.changeNext_move(0.1 SECONDS, override = TRUE)
		to_chat(HU, span_notice("[HT.p_they(TRUE)] fell for my bait <b>perfectly</b>! One more!"))
		to_chat(HT, span_danger("I fall for [HU.p_their()]'s bait <b>perfectly</b>! I'm losing my footing! <b>I can't let this happen again!</b>"))
	
	if(HU.has_duelist_ring() && HT.has_duelist_ring() || HT.bait_stacks >= 2)	//We're explicitly (hopefully non-lethally) dueling. Flavor.
		HT.emote("gasp")
		HT.OffBalance(2 SECONDS)
		HT.Immobilize(2 SECONDS)
		to_chat(HU, span_notice("[HT.p_they(TRUE)] fell for it again and is off-balanced! NOW!"))
		to_chat(HT, span_danger("I fall for [HU.p_their()] bait <b>perfectly</b>! My balance is GONE!</b>"))
		HT.bait_stacks = 0


	if(!HT.pulling)
		return

	HT.stop_pulling()
	to_chat(HU, span_notice("[HT.p_they(TRUE)] fell for my dirty trick! I am loose!"))
	to_chat(HT, span_danger("I fall for [HU.p_their()] dirty trick! My hold is broken!"))
	HU.OffBalance(2 SECONDS)
	HT.OffBalance(2 SECONDS)
	playsound(user, 'sound/combat/riposte.ogg', 100, TRUE)

/datum/rmb_intent/strong
	name = "strong"
	desc = "Your attacks have +1 strength but use more stamina. Higher critrate with brutal attacks. Intentionally fails surgery steps."
	icon_state = "rmbstrong"
	adjacency = FALSE
	prioritize_turfs = TRUE
	
/datum/rmb_intent/strong/special_attack(mob/living/user, atom/target)
	if(!user)
		return
	if(user.incapacitated())
		return
	if(!user.mind)
		return
	if(user.has_status_effect(/datum/status_effect/debuff/specialcd))
		return

	var/obj/item/rogueweapon/W = user.get_active_held_item()
	if(istype(W, /obj/item/rogueweapon) && W.special)
		var/skillreq = W.associated_skill
		if(W.special.custom_skill)
			skillreq = W.special.custom_skill
		if(user.get_skill_level(skillreq) < SKILL_LEVEL_JOURNEYMAN)
			to_chat(user, span_info("I'm not knowledgeable enough in the arts of this weapon to use this."))
			return
		W.special.deploy(user, W, target)

/datum/rmb_intent/swift
	name = "swift"
	desc = "Your attacks have less recovery time but are less accurate."
	icon_state = "rmbswift"

/datum/rmb_intent/special
	name = "special"
	desc = "(RMB WHILE DEFENSE IS ACTIVE) A special attack that depends on the type of weapon you are using."
	icon_state = "rmbspecial"

/datum/rmb_intent/feint
	name = "feint"
	desc = "(RMB WHILE DEFENSE IS ACTIVE) A deceptive half-attack with no follow-through, meant to force your opponent to open their guard. Useless against someone who is dodging."
	icon_state = "rmbfeint"

/datum/rmb_intent/feint/special_attack(mob/living/user, atom/target)
	if(!isliving(target))
		return
	if(!user)
		return
	if(user.incapacitated())
		return
	if(!user.mind)
		return
	if(user.has_status_effect(/datum/status_effect/debuff/feintcd))
		return
	var/mob/living/L = target
	user.visible_message(span_danger("[user] feints an attack at [target]!"))
	var/perc = 50
	var/obj/item/I = user.get_active_held_item()
	var/ourskill = 0
	var/theirskill = 0
	var/skill_factor = 0
	if(I)
		if(I.associated_skill)
			ourskill = user.get_skill_level(I.associated_skill)
		if(L.mind)
			I = L.get_active_held_item()
			if(I?.associated_skill)
				theirskill = L.get_skill_level(I.associated_skill)
	perc += (ourskill - theirskill)*15 	//skill is of the essence
	perc += (user.STAINT - L.STAINT)*10	//but it's also mostly a mindgame
	skill_factor = (ourskill - theirskill)/2

	if(L.has_status_effect(/datum/status_effect/debuff/exposed))
		perc = 0

	user.apply_status_effect(/datum/status_effect/debuff/feintcd)
	perc = CLAMP(perc, 0, 90)

	if(!prob(perc)) //feint intent increases the immobilize duration significantly
		playsound(user, 'sound/combat/feint.ogg', 100, TRUE)
		if(user.client?.prefs.showrolls)
			to_chat(user, span_warning("[L.p_they(TRUE)] did not fall for my feint... [perc]%"))
		return

	if(L.has_status_effect(/datum/status_effect/buff/clash))
		L.remove_status_effect(/datum/status_effect/buff/clash)
		to_chat(user, span_notice("[L.p_their(TRUE)] Guard disrupted!"))
	L.apply_status_effect(/datum/status_effect/debuff/exposed, 7.5 SECONDS)
	L.apply_status_effect(/datum/status_effect/debuff/clickcd, max(1.5 SECONDS + skill_factor, 2.5 SECONDS))
	L.Immobilize(0.5 SECONDS)
	L.stamina_add(L.stamina * 0.1)
	L.Slowdown(2)
	to_chat(user, span_notice("[L.p_they(TRUE)] fell for my feint attack!"))
	to_chat(L, span_danger("I fall for [user.p_their()] feint attack!"))
	playsound(user, 'sound/combat/riposte.ogg', 100, TRUE)


/datum/rmb_intent/riposte
	name = "defend"
	desc = "No delay between dodge and parry rolls.\n(RMB WHILE NOT GRABBING ANYTHING AND HOLDING A WEAPON)\nEnter a defensive stance, guaranteeing the next hit is defended against.\nTwo people who hit each other with the Guard up will have their weapons Clash, potentially disarming them.\nLetting it expire or hitting someone with it who has no Guard up is tiresome."
	icon_state = "rmbdef"
	adjacency = FALSE
	bypasses_click_cd = TRUE

/datum/rmb_intent/riposte/special_attack(mob/living/user, atom/target)	//Wish we could breakline these somehow.
	if(!user.has_status_effect(/datum/status_effect/buff/clash) && !user.has_status_effect(/datum/status_effect/debuff/clashcd))
		if(!user.get_active_held_item()) //Nothing in our hand to Guard with.
			return 
		if(user.r_grab || user.l_grab || length(user.grabbedby)) //Not usable while grabs are in play.
			return
		if(user.IsImmobilized() || user.IsOffBalanced()) //Not usable while we're offbalanced or immobilized
			return
		if(user.m_intent == MOVE_INTENT_RUN)
			to_chat(user, span_warning("I can't focus on this while running."))
			return
		if(user.magearmor == FALSE && HAS_TRAIT(user, TRAIT_MAGEARMOR))	//The magearmor is ACTIVE, so we can't Guard. (Yes, it's active while FALSE / 0.)
			to_chat(user, span_warning("I'm already focusing on my mage armor!"))
			return
		user.apply_status_effect(/datum/status_effect/buff/clash)

/datum/rmb_intent/guard
	name = "guarde"
	desc = "(RMB WHILE DEFENSE IS ACTIVE) Raise your weapon, ready to attack any creature who moves onto the space you are guarding."
	icon_state = "rmbguard"

/datum/rmb_intent/weak
	name = "weak"
	desc = "Your attacks have -1 strength and will never critically-hit. Useful for longer punishments, play-fighting, and bloodletting.\nRight click will attempt to steal from the target."
	icon_state = "rmbweak"

/datum/rmb_intent/weak/special_attack(mob/living/user, atom/target)
	if(!target.Adjacent(user))
		return

	if(ishuman(target))
		var/mob/living/carbon/human/user_human = user
		var/mob/living/carbon/human/target_human = target
		var/thiefskill = user.get_skill_level(/datum/skill/misc/stealing) + (has_world_trait(/datum/world_trait/matthios_fingers) ? 1 : 0)
		var/stealroll = roll("[thiefskill]d6")
		var/targetperception = (target_human.STAPER)
		var/list/stealablezones = list("chest", "neck", "groin", "r_hand", "l_hand")
		var/list/stealpos = list()
		var/list/mobsbehind = list()
		var/exp_to_gain = user_human.STAINT
		to_chat(user, span_notice("I try to steal from [target_human]..."))	
		if(do_after(user, 5, target = target_human, progress = 0))
			if(stealroll > targetperception)
				//TODO add exp here
				// RATWOOD MODULAR START
				if(target_human.cmode)
					to_chat(user, "<span class='warning'>[target_human] is alert. I can't pickpocket them like this.</span>")
					return
				// RATWOOD MODULAR END
				if(user_human.get_active_held_item())
					to_chat(user, span_warning("I can't pickpocket while my hand is full!"))
					return
				if(!(user.zone_selected in stealablezones))
					to_chat(user, span_warning("What am I going to steal from there?"))
					return
				mobsbehind |= cone(target_human, list(turn(target_human.dir, 180)), list(user))
				if(mobsbehind.Find(user) || target_human.IsUnconscious() || target_human.eyesclosed || target_human.eye_blind || target_human.eye_blurry || !(target_human.mobility_flags & MOBILITY_STAND))
					switch(user_human.zone_selected)
						if("chest")
							if (target_human.get_item_by_slot(SLOT_BACK_L))
								stealpos.Add(target_human.get_item_by_slot(SLOT_BACK_L))
							if (target_human.get_item_by_slot(SLOT_BACK_R))
								stealpos.Add(target_human.get_item_by_slot(SLOT_BACK_R))
						if("neck")
							if (target_human.get_item_by_slot(SLOT_NECK))
								stealpos.Add(target_human.get_item_by_slot(SLOT_NECK))
						if("groin")
							if (target_human.get_item_by_slot(SLOT_BELT_R))
								stealpos.Add(target_human.get_item_by_slot(SLOT_BELT_R))
							if (target_human.get_item_by_slot(SLOT_BELT_L))
								stealpos.Add(target_human.get_item_by_slot(SLOT_BELT_L))
						if("r_hand", "l_hand")
							if (target_human.get_item_by_slot(SLOT_RING))
								stealpos.Add(target_human.get_item_by_slot(SLOT_RING))
					if(length(stealpos) > 0)
						var/obj/item/picked = pick(stealpos)
						target_human.dropItemToGround(picked)
						user.put_in_active_hand(picked)
						to_chat(user, span_green("I stole [picked]!"))
						target_human.log_message("has had \the [picked] stolen by [key_name(user_human)]", LOG_ATTACK, color="white")
						user_human.log_message("has stolen \the [picked] from [key_name(target_human)]", LOG_ATTACK, color="white")
						if(target_human.client && target_human.stat != DEAD)
							SEND_SIGNAL(user_human, COMSIG_ITEM_STOLEN, target_human)
							record_featured_stat(FEATURED_STATS_THIEVES, user_human)
							record_featured_stat(FEATURED_STATS_CRIMINALS, user_human)
							GLOB.azure_round_stats[STATS_ITEMS_PICKPOCKETED]++
						if(user.has_flaw(/datum/charflaw/addiction/kleptomaniac))
							user.sate_addiction()
					else
						exp_to_gain /= 2 // these can be removed or changed on reviewer's discretion
						to_chat(user, span_warning("I didn't find anything there. Perhaps I should look elsewhere."))
				else
					to_chat(user, "<span class='warning'>They can see me!")
			if(stealroll <= 5)
				target_human.log_message("has had an attempted pickpocket by [key_name(user_human)]", LOG_ATTACK, color="white")
				user_human.log_message("has attempted to pickpocket [key_name(target_human)]", LOG_ATTACK, color="white")
				user_human.visible_message(span_danger("[user_human] failed to pickpocket [target_human]!"))
				to_chat(target_human, span_danger("[user_human] tried pickpocketing me!"))
			if(stealroll < targetperception)
				target_human.log_message("has had an attempted pickpocket by [key_name(user_human)]", LOG_ATTACK, color="white")
				user_human.log_message("has attempted to pickpocket [key_name(target_human)]", LOG_ATTACK, color="white")
				to_chat(user, span_danger("I failed to pick the pocket!"))
				to_chat(target_human, span_danger("Someone tried pickpocketing me!"))
				exp_to_gain /= 5 // these can be removed or changed on reviewer's discretion
			// If we're pickpocketing someone else, and that person is conscious, grant XP
			if(user != target_human && target_human.stat == CONSCIOUS)
				user.mind.add_sleep_experience(/datum/skill/misc/stealing, exp_to_gain, FALSE)
			user.changeNext_move(CLICK_CD_MELEE)
	. = ..()
