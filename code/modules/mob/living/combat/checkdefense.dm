/mob/living/proc/checkdefense(datum/intent/intenty, mob/living/user)

	if(!cmode)
		return FALSE
	if(stat)
		return FALSE
	if(!canparry && !candodge) //mob can do neither of these
		return FALSE
	if(user == src)
		return FALSE
	if(!(mobility_flags & MOBILITY_MOVE))
		return FALSE
		
	var/datum/status_effect/swingdelay/disrupt/SW = has_status_effect(/datum/status_effect/swingdelay/disrupt)
	if(SW)
		if(!SW.is_disrupted())
			SW.attacked()
			swing_state = FALSE
			return FALSE

	if(client && used_intent)
		if(client.charging && used_intent.tranged && !used_intent.tshield)
			return FALSE

	if(channeling_spell?.blocks_defense_while_channeling)
		return FALSE

	if(has_flaw(/datum/charflaw/addiction/thrillseeker))
		var/datum/component/arousal/CAR = GetComponent(/datum/component/arousal)
		if(CAR)
			CAR.adjust_arousal_special(src, 2)

	if(has_status_effect(/datum/status_effect/debuff/vulnerable))
		if(!has_status_effect(/datum/status_effect/buff/weapon_binded) && !has_status_effect(/datum/status_effect/debuff/weapon_binded))
			if(ishuman(src) && user.get_tempo_bonus(TEMPO_TAG_BINDABLE) && mind && user?.mind)
				var/held = get_active_held_item()
				if(istype(held, /obj/item/rogueweapon))
					if(check_bait_subzone(zone_selected) == check_bait_subzone(user.zone_selected) && zone_selected != BODY_ZONE_CHEST)
						var/mob/living/carbon/human/HL = src
						if(HL.try_bind(held, user, TRUE))
							remove_status_effect(/datum/status_effect/debuff/vulnerable)
							return TRUE

	switch(d_intent)
		if(INTENT_PARRY)
			return attempt_parry(intenty, user)
		if(INTENT_DODGE)
			return attempt_dodge(intenty, user)
			