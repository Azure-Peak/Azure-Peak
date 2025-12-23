/mob/living/proc/update_stamina() //update hud and regen after last_fatigued delay on taking
	max_stamina = max_energy / 10

	var/delay = 20
	if(HAS_TRAIT(src, TRAIT_APRICITY))
		switch(GLOB.tod)
			if("day", "dawn")
				delay = 13
			if("night", "dusk")
				delay = 16
	if(world.time > last_fatigued + delay) //regen fatigue
		var/added = energy / max_energy
		added = round(-10 + (added * - 40))
		if(src.climbing) // no stam regen while climbing guh
			added = 0
		if(HAS_TRAIT(src, TRAIT_MISSING_NOSE))
			added = round(added * 0.5, 1)
		if(HAS_TRAIT(src, TRAIT_MONK_ROBE))
			added = round(added * 1.25, 1)
		if(stamina >= 1)
			stamina_add(added)
		else
			stamina = 0

	update_health_hud()

/mob/living/proc/update_energy()
	var/athletics_skill = 0
	athletics_skill = get_skill_level(/datum/skill/misc/athletics)
	max_energy = (STAWIL + (athletics_skill/2 ) ) * 100
	if(cmode)
		if(!HAS_TRAIT(src, TRAIT_BREADY))
			energy_add(-2)
	if(HAS_TRAIT(src, TRAIT_INFINITE_ENERGY))
		energy = max_energy
	if(HAS_TRAIT(src, TRAIT_BREADY))
		energy_add(4) // Battle Ready now gives you a small amount of regeneration.
		// This generally cover most reasonable in combat usage.

/mob/proc/energy_add(added as num)
	return

/mob/living/energy_add(added as num)
	if(HAS_TRAIT(src, TRAIT_INFINITE_STAMINA))
		return TRUE
	if(HAS_TRAIT(src, TRAIT_INFINITE_ENERGY))
		return TRUE
	energy += added
	if(energy > max_energy)
		energy = max_energy
		update_health_hud()
		return FALSE
	else
		if(energy <= 0)
			energy = 0
			if(m_intent == MOVE_INTENT_RUN) //can't sprint at zero stamina
				toggle_rogmove_intent(MOVE_INTENT_WALK)
		update_health_hud()
		return TRUE

/mob/proc/stamina_add(added as num)
	return TRUE

/mob/living/proc/stamina_nutrition_mod(amt)
	// to simulate exertion, we deduct a mob's nutrition whenever it takes an action that would give us fatigue.
	var/nutrition_amount = amt * 0.15 // nutrition goes up to 1k at max (but constantly ticks down) so we need to work at a slightly bigger scale
	var/athletics_skill = get_skill_level(/datum/skill/misc/athletics)
	var/chip_amt = 2 + ceil(athletics_skill / 2)

	if (amt <= chip_amt)
		if (athletics_skill && prob(athletics_skill * 16)) // 16% chance per athletics skill to straight up negate nutrition loss
			return 0
		if (amt == 2 && prob(STACON * 5)) // only sprinting knocks off 2 stamina at a time, so test this vs our con to see if we drop it
			return 0

	var/tox_damage = getToxLoss()
	if (tox_damage >= (maxHealth * 0.2)) // if we have over 20% of our health as toxin damage, add 10% of our toxin damage as base loss
		nutrition_amount += (tox_damage * 0.1)

	if (stamina >= (max_stamina * 0.7)) // if you've spent 70% of your max fatigue, the base amount you lose is doubled
		nutrition_amount *= 2
	if (STACON <= 9) // 10% extra nutrition loss for every CON below 9
		var/low_end_malus = (10 - STACON) * 0.1
		nutrition_amount *= (1 + low_end_malus)
	if (STACON >= 11) // 5% less nutrition loss for every CON above 11
		var/high_end_buff = (STACON - 10) * 0.05
		nutrition_amount *= (1 - high_end_buff)
	if (STASTR >= 11) // 7.5% increased nutrition loss for every STR above 11. the gainz don't come cheap
		var/swole_malus = (10 - STASTR) * 0.075
		nutrition_amount *= (1 + swole_malus)
	if (athletics_skill)
		var/athletics_bonus = athletics_skill * 0.05 //each rank of athletics gives us 5% less nutrition loss
		nutrition_amount *= (1 - athletics_bonus)

	if (nutrition >= NUTRITION_LEVEL_WELL_FED) // we've only just eaten recently so just flat out reduce the total loss by half
		nutrition_amount *= 0.5

	if (reagents?.has_reagent(/datum/reagent/consumable/nutriment)) // we're still digesting so knock off a tiny bit
		nutrition_amount *= 0.9

	return nutrition_amount

/mob/living/stamina_add(added as num, emote_override, force_emote = TRUE) //call update_stamina here and set last_fatigued, return false when not enough fatigue left
	if(HAS_TRAIT(src, TRAIT_INFINITE_STAMINA))
		return TRUE

	var/true_added = added
	if(HAS_TRAIT(src, TRAIT_FORTITUDE))
		added = added * 0.5

	if(added < 0 && HAS_TRAIT(src, TRAIT_FROZEN_STAMINA))
		added = 0

	if(mind && true_added > 0)
		// the amount of athletics skill gained is proportional to how much stamina is used
		// using a tenth of the bar gives 1 XP point of athletics skill, multiplied by your constitution divided by 10
		mind.add_sleep_experience(/datum/skill/misc/athletics, (STACON / 10) * ((true_added / max_stamina) * 10), show_xp = m_intent == MOVE_INTENT_RUN)

	stamina = CLAMP(stamina+added, 0, max_stamina)
	if(added > 0)
		energy_add(added * -1)
		adjust_nutrition(-stamina_nutrition_mod(added))
	if(added >= 5)
		if(energy <= 0)
			if(iscarbon(src))
				var/mob/living/carbon/C = src
				if(!HAS_TRAIT(C, TRAIT_NOHUNGER))
					if(C.nutrition <= 0)
						if(C.hydration <= 0)
							C.heart_attack()
							return FALSE

	if(ishuman(src) && mind && added > 0)
		var/mob/living/carbon/human/H = src
		var/text
		var/x_offset = 20
		var/y_offset
		var/stamratio = stamina / max_stamina
		if(stamratio >= 0.25 && ((stamina - added) / max_stamina) < 0.25)
			text = "<font color = '#a8af9b'>Winded</font>"
			y_offset = BALLOON_Y_OFFSET_TIER1
		if(stamratio >= 0.5 && ((stamina - added) / max_stamina) < 0.5)
			text = "<font color = '#d4d36c'>Drained</font>"
			y_offset = BALLOON_Y_OFFSET_TIER2
		if(stamratio >= 0.75 && ((stamina - added) / max_stamina) < 0.75)
			text = "<font color = '#a8665a'>Fatigued</font>"
			y_offset = BALLOON_Y_OFFSET_TIER3
		if(text)
			if(!HAS_TRAIT(H, TRAIT_DECEIVING_MEEKNESS))
				H.filtered_balloon_alert(TRAIT_COMBAT_AWARE, text, x_offset, y_offset)
			else
				if(prob(10))
					text = "<i>Tired...?</i>"
					H.filtered_balloon_alert(TRAIT_COMBAT_AWARE, text, x_offset, y_offset)

	if(stamina >= max_stamina)
		stamina = max_stamina
		update_health_hud()
		if(m_intent == MOVE_INTENT_RUN) //can't sprint at full fatigue
			toggle_rogmove_intent(MOVE_INTENT_WALK, TRUE)
		if(!emote_override)
			emote("fatigue", forced = force_emote)
		else
			emote(emote_override, forced = force_emote)
		blur_eyes(2)
		last_fatigued = world.time + 3 SECONDS //extra time before fatigue regen sets in
		stop_attack()
		changeNext_move(CLICK_CD_EXHAUSTED)
		flash_fullscreen("blackflash")

		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			var/balloon_text = "<font color = '#bb2b2b'>Exhausted... </font>"
			H.balloon_alert_to_viewers(balloon_text, balloon_text, DEFAULT_MESSAGE_RANGE)

		if(energy <= 0)
			addtimer(CALLBACK(src, PROC_REF(Knockdown), 30), 1 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(Immobilize), 30), 1 SECONDS)
		if(iscarbon(src))
			var/mob/living/carbon/C = src
			if(C.get_stress_amount() >= 30)
				C.heart_attack()
			if(!HAS_TRAIT(C, TRAIT_NOHUNGER))
				if(C.nutrition <= 0)
					if(C.hydration <= 0)
						C.heart_attack()
		return FALSE
	else
		last_fatigued = world.time
		update_health_hud()
		return TRUE

/mob/living/carbon
	var/heart_attacking = FALSE

/mob/living/carbon/proc/heart_attack()
	if(HAS_TRAIT(src, TRAIT_INFINITE_STAMINA))
		return
	if(!heart_attacking)
		heart_attacking = TRUE
		shake_camera(src, 1, 3)
		blur_eyes(10)
		var/stuffy = list("ZIZO GRABS MY WEARY HEART!","ARGH! MY HEART BEATS NO MORE!","NO... MY HEART HAS BEAT IT'S LAST!","MY HEART HAS GIVEN UP!","MY HEART BETRAYS ME!","THE METRONOME OF MY LIFE STILLS!")
		to_chat(src, span_userdanger("[pick(stuffy)]"))
		emote("breathgasp", forced = TRUE)
		addtimer(CALLBACK(src, PROC_REF(adjustOxyLoss), 110), 30)

/mob/living/proc/freak_out()
	return

/mob/proc/do_freakout_scream()
	emote("scream", forced=TRUE)

/mob/living/carbon/freak_out() // currently solely used for vampire snowflake stuff
	if(mob_timers["freakout"])
		if(world.time < mob_timers["freakout"] + 10 SECONDS)
			flash_fullscreen("stressflash")
			return
	mob_timers["freakout"] = world.time
	shake_camera(src, 1, 3)
	flash_fullscreen("stressflash")
	changeNext_move(CLICK_CD_EXHAUSTED)
	add_stress(/datum/stressevent/freakout)
	emote("fatigue", forced = TRUE)
	if(hud_used)
		var/matrix/skew = matrix()
		skew.Scale(2)
		var/matrix/newmatrix = skew
		for(var/C in hud_used.plane_masters)
			var/atom/movable/screen/plane_master/whole_screen = hud_used.plane_masters[C]
			if(whole_screen.plane == HUD_PLANE)
				continue
			animate(whole_screen, transform = newmatrix, time = 1, easing = QUAD_EASING)
			animate(transform = -newmatrix, time = 30, easing = QUAD_EASING)

/mob/living/proc/stamina_reset()
	stamina = 0
	last_fatigued = 0
	return
