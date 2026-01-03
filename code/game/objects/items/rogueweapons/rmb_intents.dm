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
		addtimer(CALLBACK(src, PROC_REF(clear_tempo_all)), 30 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
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
	var/newcd = (BASE_RCLICK_CD - HU.get_tempo_bonus(TEMPO_TAG_RCLICK_CD_BONUS))
	HU.apply_status_effect(/datum/status_effect/debuff/baitcd, newcd)

	if((target_zone != user_zone) || ((target_zone == BODY_ZONE_CHEST) || (user_zone == BODY_ZONE_CHEST))) //Our zones do not match OR either of us is targeting chest.
		var/guaranteed_fail = TRUE
		if(check_face_subzone(target_zone) && check_face_subzone(user_zone))	//We simplify the myriad of face targeting zones
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

	if(HT.has_status_effect(/datum/status_effect/buff/clash/limbguard))
		HT.bad_guard()

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
	desc = "Your attacks have +1 STR extra damage that ignores limits. Your attacks will cost the enemy more sharpness and integrity to defend against. Higher critrate with brutal attacks. Intentionally fails surgery steps.\nCosts more stamina per hit."
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

	user.face_atom(target)

	var/obj/item/rogueweapon/W = user.get_active_held_item()
	if(istype(W, /obj/item/rogueweapon) && W.special)
		var/skillreq = W.associated_skill
		if(W.special.custom_skill)
			skillreq = W.special.custom_skill
		if(!HAS_TRAIT(user, TRAIT_BATTLEMASTER))
			if(user.get_skill_level(skillreq) < SKILL_LEVEL_JOURNEYMAN)
				to_chat(user, span_info("I'm not knowledgeable enough in the arts of this weapon to use this."))
				return
		if(W.special.check_range(user, target))
			if(W.special.apply_cost(user))
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
	desc = "(RMB WHILE IN COMBAT MODE) A deceptive half-attack with no follow-through, meant to force your opponent to open their guard. Will fail on targets that are relaxed and less alert."
	icon_state = "rmbfeint"
	var/feintdur = 7.5 SECONDS

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

	var/special_msg

	if(L.has_status_effect(/datum/status_effect/debuff/exposed))
		perc = 0

	if(L.has_status_effect(/datum/status_effect/debuff/feinted))
		perc = 0
		special_msg = span_warning("Too soon! They were expecting it!")

	if(!L.can_see_cone(user) && L.mind)
		perc = 0
		special_msg = span_warning("They need to see me for me to feint them!")

	perc = CLAMP(perc, 0, 90)

	if(!prob(perc)) //feint intent increases the immobilize duration significantly
		playsound(user, 'sound/combat/feint.ogg', 100, TRUE)
		if(user.client?.prefs.showrolls)
			to_chat(user, span_warning("[L.p_they(TRUE)] did not fall for my feint... [perc]%"))
		user.apply_status_effect(/datum/status_effect/debuff/feintcd)
		if(special_msg)
			to_chat(user, special_msg)
		return

	if(L.has_status_effect(/datum/status_effect/buff/clash))
		L.remove_status_effect(/datum/status_effect/buff/clash)
		to_chat(user, span_notice("[L.p_their(TRUE)] Guard disrupted!"))
	L.apply_status_effect(/datum/status_effect/debuff/exposed, feintdur)
	L.apply_status_effect(/datum/status_effect/debuff/clickcd, max(1.5 SECONDS + skill_factor, 2.5 SECONDS))
	L.apply_status_effect(/datum/status_effect/debuff/feinted, 30 SECONDS + feintdur)
	L.Immobilize(0.5 SECONDS)
	L.stamina_add(L.stamina * 0.1)
	L.Slowdown(2)

	var/newcd = (BASE_RCLICK_CD - user.get_tempo_bonus(TEMPO_TAG_RCLICK_CD_BONUS)) + feintdur
	user.apply_status_effect(/datum/status_effect/debuff/feintcd, newcd)
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
	if(!user.has_status_effect(/datum/status_effect/buff/clash) && !user.has_status_effect(/datum/status_effect/debuff/clashcd) && !user.has_status_effect(/datum/status_effect/buff/clash/limbguard))
		if(!user.get_active_held_item()) //Nothing in our hand to Guard with.
			return 
		if(user.r_grab || user.l_grab || length(user.grabbedby)) //Not usable while grabs are in play.
			return
		if(user.IsImmobilized() || user.IsOffBalanced()) //Not usable while we're offbalanced or immobilized
			return
		if(user.m_intent == MOVE_INTENT_RUN)
			to_chat(user, span_warning("I can't focus on this while running."))
			return
		if(user.magearmor == 0 && HAS_TRAIT(user, TRAIT_MAGEARMOR))	//The magearmor is ACTIVE, so we break magearmor to guard.
			user.magearmor = 1
			user.apply_status_effect(/datum/status_effect/buff/magearmor)
			to_chat(user, span_warning("I drop my Mage Armor to protect myself!"))
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
	if(!ishuman(user) || !ishuman(target))
		return
	var/mob/living/carbon/human/H = user
	H.attempt_steal(user, target)
	. = ..()
