

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!

// bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_heat_protection() and human/proc/get_cold_protection()
// The values here should add up to 1.
// Hands and feet have 2.5%, arms and legs 7.5%, each of the torso parts has 15% and the head has 30%
#define THERMAL_PROTECTION_HEAD			0.3
#define THERMAL_PROTECTION_CHEST		0.15
#define THERMAL_PROTECTION_GROIN		0.15
#define THERMAL_PROTECTION_LEG_LEFT		0.075
#define THERMAL_PROTECTION_LEG_RIGHT	0.075
#define THERMAL_PROTECTION_FOOT_LEFT	0.025
#define THERMAL_PROTECTION_FOOT_RIGHT	0.025
#define THERMAL_PROTECTION_ARM_LEFT		0.075
#define THERMAL_PROTECTION_ARM_RIGHT	0.075
#define THERMAL_PROTECTION_HAND_LEFT	0.025
#define THERMAL_PROTECTION_HAND_RIGHT	0.025
#define FILTER_UNDERWATER_BLUR "uw_blur"
#define FILTER_UNDERWATER_WAVE "uw_wave"

/mob/living/carbon/human
	var/leprosy = 2
	var/allmig_reward = 0

/mob/living/carbon/human/Life()
	if (notransform)
		return

	if(!client && mode == NPC_AI_SLEEP)
		return

	. = ..()

	if (QDELETED(src))
		return 0

	SEND_SIGNAL(src, COMSIG_HUMAN_LIFE)

	if(. && (mode != NPC_AI_OFF))
		handle_ai()

	if(advsetup)
		Stun(50)

	if(mind)
		mind.sleep_adv.add_stress_cycle(get_stress_amount())
		for(var/datum/antagonist/A as anything in mind.antag_datums)
			A.on_life(src)

	handle_vamp_dreams()
	if(IsSleeping())
		if(health > 0)
			if(has_status_effect(/datum/status_effect/debuff/sleepytime))
				remove_status_effect(/datum/status_effect/debuff/sleepytime)
				remove_stress(/datum/stressevent/sleepytime)
				if(mind)
					mind.sleep_adv.advance_cycle()
					handle_sleep_triumphs()
	if(leprosy == 1)
		adjustToxLoss(2)
	else if(leprosy == 2)
		if(client)
			if(check_blacklist(client.ckey))
				ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
				leprosy = 1
				var/obj/item/bodypart/B = get_bodypart(BODY_ZONE_HEAD)
				if(B)
					B.sellprice = rand(16, 33)
			else
				leprosy = 3
	//heart attack stuff
	handle_heart()
	update_energy()
	update_stamina()
	handle_swimming()
	for(var/datum/charflaw/cf in charflaws)
		if(!cf.ephemeral && mind)
			cf.flaw_on_life(src)
	if(health <= 0)
		adjustOxyLoss(0.5)
	if(mode == NPC_AI_OFF && !client && !HAS_TRAIT(src, TRAIT_NOSLEEP))
		if(mob_timers["slo"])
			if(world.time > mob_timers["slo"] + 90 SECONDS)
				Sleeping(100)
		else
			mob_timers["slo"] = world.time
	else
		if(mob_timers["slo"])
			mob_timers["slo"] = null

	if(dna?.species)
		dna.species.spec_life(src) // for mutantraces

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	handle_gas_mask_sound()

	if(world.time > next_tempo_cull)
		cull_tempo_list()
		next_tempo_cull = world.time + TEMPO_CULL_DELAY

	if(stat != DEAD)
		return 1

/mob/living/carbon/human/DeadLife()
	set invisibility = 0

	if(notransform)
		return

	if(mind)
		for(var/datum/antagonist/A as anything in mind.antag_datums)
			A.on_life(src)

	. = ..()
	name = get_visible_name()
	handle_swimming()

/mob/living/carbon/human/proc/on_daypass()
	if(dna?.species)
		if(STUBBLE in dna.species.species_traits)
			if(gender == MALE)
				has_stubble = TRUE
				update_hair()

/mob/living/carbon/human/handle_environment()

	dna.species.handle_environment(src)

/mob/living/carbon/human/proc/get_thermal_protection()
	var/thermal_protection = 0 //Simple check to estimate how protected we are against multiple temperatures
	if(wear_armor)
		if(wear_armor.max_heat_protection_temperature >= FIRE_SUIT_MAX_TEMP_PROTECT)
			thermal_protection += (wear_armor.max_heat_protection_temperature*0.7)
	if(head)
		if(head.max_heat_protection_temperature >= FIRE_HELM_MAX_TEMP_PROTECT)
			thermal_protection += (head.max_heat_protection_temperature*THERMAL_PROTECTION_HEAD)
	thermal_protection = round(thermal_protection)
	return thermal_protection

/mob/living/carbon/human/ignite_mob()
	//If have no DNA or can be Ignited, call parent handling to light user
	//If firestacks are high enough
	if(!dna || dna.species.Canignite_mob(src))
		if(!on_fire)
			var/datum/status_effect/fire_handler/fire_stacks/fire_status = has_status_effect(/datum/status_effect/fire_handler/fire_stacks)
			var/datum/status_effect/fire_handler/fire_stacks/sunder_status = has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder)
			var/datum/status_effect/fire_handler/fire_stacks/divine_status = has_status_effect(/datum/status_effect/fire_handler/fire_stacks/divine)
			var/datum/status_effect/fire_handler/fire_stacks/sunder/blessed/blessed_sunder = has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
			if(fire_status?.stacks + sunder_status?.stacks + divine_status?.stacks + blessed_sunder?.stacks > 10)
				Immobilize(30)
				emote("firescream", TRUE)
			else
				emote("pain", TRUE)
		return ..()
	. = FALSE //No ignition

/mob/living/carbon/human/extinguish_mob()
	if(!dna || !dna.species.extinguish_mob(src))
		last_fire_update = null
		..()

/mob/living/carbon/human/SoakMob(locations)
	. = ..()
	var/coverhead
	//add belt slots to this for rusting
	var/list/body_parts = list(head, wear_mask, wear_wrists, wear_shirt, wear_neck, cloak, wear_armor, wear_pants, backr, backl, gloves, shoes, belt, s_store, glasses, ears, wear_ring) //Everything but pockets. Pockets are l_store and r_store. (if pockets were allowed, putting something armored, gloves or hats for example, would double up on the armor)
	for(var/bp in body_parts)
		if(!bp)
			continue
		if(bp && istype(bp , /obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(zone2covered(BODY_ZONE_HEAD, C.body_parts_covered))
				coverhead = TRUE
	if(locations & HEAD)
		// An exception for Abyssorites, since otherwise they gain stress in rain when they shouldn't.
		if(!coverhead && !HAS_TRAIT(src, TRAIT_ABYSSOR_SWIM))
			add_stress(/datum/stressevent/coldhead)

//END FIRE CODE


/mob/living/carbon/human/proc/handle_gas_mask_sound()
	if(!istype(wear_mask, /obj/item/clothing/mask/rogue/facemask/steel/confessor))
		if(breathe_tick)
			breathe_tick = 0
		return
	if(stat == DEAD)
		return
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return
	breathe_tick++
	var/mask_sound
	if(istype(wear_mask, /obj/item/clothing/mask/rogue/facemask/steel/confessor))
		if(breathe_tick>=rand(3,5))
			breathe_tick = 0
			mask_sound = pick('sound/items/confessormask1.ogg', 'sound/items/confessormask2.ogg', 'sound/items/confessormask3.ogg',
							'sound/items/confessormask4.ogg', 'sound/items/confessormask5.ogg', 'sound/items/confessormask6.ogg',
							'sound/items/confessormask7.ogg', 'sound/items/confessormask8.ogg', 'sound/items/confessormask9.ogg',
					 		'sound/items/confessormask10.ogg')
			playsound(src, mask_sound, 90, FALSE, 4, 0)
			return



//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, CHEST, GROIN, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = 0
	//Handle normal clothing
	if(head)
		if(head.max_heat_protection_temperature && head.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= head.heat_protection
	if(wear_armor)
		if(wear_armor.max_heat_protection_temperature && wear_armor.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_armor.heat_protection
	if(wear_pants)
		if(wear_pants.max_heat_protection_temperature && wear_pants.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_pants.heat_protection
	if(shoes)
		if(shoes.max_heat_protection_temperature && shoes.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= shoes.heat_protection
	if(gloves)
		if(gloves.max_heat_protection_temperature && gloves.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= gloves.heat_protection
	if(wear_mask)
		if(wear_mask.max_heat_protection_temperature && wear_mask.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_mask.heat_protection

	return thermal_protection_flags

/mob/living/carbon/human/proc/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_heat_protection_flags(temperature)

	var/thermal_protection = 0
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
		if(thermal_protection_flags & GROIN)
			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT


	return min(1,thermal_protection)

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	var/thermal_protection_flags = 0
	//Handle normal clothing

	if(head)
		if(head.min_cold_protection_temperature && head.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= head.cold_protection
	if(wear_armor)
		if(wear_armor.min_cold_protection_temperature && wear_armor.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_armor.cold_protection
	if(wear_pants)
		if(wear_pants.min_cold_protection_temperature && wear_pants.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_pants.cold_protection
	if(shoes)
		if(shoes.min_cold_protection_temperature && shoes.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= shoes.cold_protection
	if(gloves)
		if(gloves.min_cold_protection_temperature && gloves.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= gloves.cold_protection
	if(wear_mask)
		if(wear_mask.min_cold_protection_temperature && wear_mask.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_mask.cold_protection

	return thermal_protection_flags

/mob/living/carbon/human/proc/get_cold_protection(temperature)
	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)

	var/thermal_protection = 0
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
		if(thermal_protection_flags & GROIN)
			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

	return min(1,thermal_protection)

/mob/living/carbon/human/handle_random_events()
	..()
	//Puke if toxloss is too high
	if(!stat)
		if(prob(33) && getToxLoss() >= 75)
			mob_timers["puke"] = world.time
			vomit(1, blood = TRUE)

/mob/living/carbon/human/has_smoke_protection()
	if(wear_mask)
		if(wear_mask.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	if(glasses)
		if(glasses.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	if(head && istype(head, /obj/item/clothing))
		var/obj/item/clothing/CH = head
		if(CH.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	return ..()

/mob/living/carbon/human/proc/handle_heart()
	var/we_breath = !HAS_TRAIT_FROM(src, TRAIT_NOBREATH, SPECIES_TRAIT)

	if(!undergoing_cardiac_arrest())
		return

	if(we_breath)
		adjustOxyLoss(8)
		Unconscious(80)
	// Tissues die without blood circulation
	adjustBruteLoss(2)

/mob/living/carbon/human/proc/handle_vamp_dreams()
	if(!HAS_TRAIT(src, TRAIT_VAMP_DREAMS))
		return
	if(!mind)
		return
	if(!has_status_effect(/datum/status_effect/debuff/vamp_dreams))
		return
	if(!eyesclosed)
		return
	if(mobility_flags & MOBILITY_STAND)
		return
	if(!istype(loc, /obj/structure/closet/crate/coffin))
		return
	var/obj/structure/closet/crate/coffin/coffin = loc
	if(coffin.opened)
		return
	remove_status_effect(/datum/status_effect/debuff/vamp_dreams)
	mind.sleep_adv.advance_cycle()

/mob/living/carbon/human/proc/start_swimming()
	if(is_swimming) return
	is_swimming = TRUE
	

/mob/living/carbon/human/proc/stop_swimming()
	if(!is_swimming) return
	is_swimming = FALSE
	

/mob/living/carbon/human/proc/start_submersion()
	if(is_underwater) return
	is_underwater = TRUE
	add_client_colour(/datum/client_colour/underwater)
	apply_underwater_filters()
	
	remove_filter("swimming_cutter")
	update_icon()
	
	animate(src, pixel_x = pixel_x + 2, time = 20, loop = -1, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
	animate(pixel_x = pixel_x - 2, time = 20, easing = SINE_EASING)

/mob/living/carbon/human/proc/stop_submersion()
	if(!is_underwater) return
	is_underwater = FALSE
	remove_client_colour(/datum/client_colour/underwater)
	remove_underwater_filters()
	animate(src) 
	pixel_x = get_standard_pixel_x_offset()
	update_icon()

/mob/living/carbon/human/proc/apply_underwater_filters()
	if(!client) return
	if(swimming_filter_client == client) return

	var/list/planes = list(
		OPENSPACE_PLANE, 
		OPENSPACE_BACKDROP_PLANE, 
		FLOOR_PLANE, 
		WALL_PLANE, 
		GAME_PLANE, 
		GAME_PLANE_FOV_HIDDEN
	)
	for(var/atom/movable/screen/plane_master/PM in client.screen)
		if(PM.plane in planes)
			PM.add_filter(FILTER_UNDERWATER_BLUR, 10, list("type" = "blur", "size" = 0.8))
			PM.add_filter(FILTER_UNDERWATER_WAVE, 11, list("type" = "wave", "x" = 1, "y" = 1, "size" = 1))
			var/F = PM.get_filter(FILTER_UNDERWATER_WAVE)
			if(F) animate(F, offset = 10, time = 40, loop = -1)
			
	swimming_filter_client = client 

/mob/living/carbon/human/proc/remove_underwater_filters()
	if(!client) return
	for(var/atom/movable/screen/plane_master/PM in client.screen)
		PM.remove_filter(FILTER_UNDERWATER_BLUR)
		PM.remove_filter(FILTER_UNDERWATER_WAVE)
		
	swimming_filter_client = null // Очищаем трекер

/mob/living/carbon/human/proc/handle_swimming()
	var/turf/T = get_turf(src)
	var/area/A = get_area(src)
	

	var/is_on_water = istype(T, /turf/open/water)

	var/is_on_new_water = istype(T, /turf/open/water/transparent)
	
	var/is_true_swimming = is_swimming || is_underwater || istype(A, /area/underwater) || is_on_new_water

	var/sw_skill = get_skill_level(/datum/skill/misc/swimming)
	var/new_max_breath = (STACON * 5) + (sw_skill * 5)

	if(new_max_breath != max_breath)
		if(max_breath > 10)
			var/ratio = breath_remaining / max_breath
			max_breath = new_max_breath
			breath_remaining = max_breath * ratio
		else
			max_breath = new_max_breath
			breath_remaining = max_breath

	if(!is_on_water && !is_true_swimming && breath_remaining >= max_breath)
		if(get_filter("swimming_cutter"))
			remove_filter("swimming_cutter")
			update_icon()
		update_breath_hud() 
		return

	if(is_true_swimming && !is_underwater)
		if(stat == UNCONSCIOUS || IsImmobilized() || IsKnockdown())
			var/turf/below = GET_TURF_BELOW(T)
			if(below && istype(below, /turf/open/water/transparent))
				forceMove(below)
				set_resting(TRUE)
				return

	var/is_choking = FALSE
	if(is_underwater && !can_breathe_underwater())
		is_choking = TRUE
	else if(resting && is_on_water)
		is_choking = TRUE
		handle_inwater(T) 
	
	if(HAS_TRAIT(src, TRAIT_NOBREATH) || HAS_TRAIT(src, TRAIT_WATERBREATHING))
		breath_remaining = max_breath
		is_choking = FALSE

	if(is_choking)
		last_breath_spent = world.time
		var/breath_drain = (m_intent == MOVE_INTENT_RUN) ? 1.2 : 0.8
		breath_remaining = max(0, breath_remaining - (breath_drain / (1 + sw_skill * 0.1)))
		
		if(breath_remaining <= 0)
			var/oxy_damage = (stat == UNCONSCIOUS) ? 3.5 : 5 
			adjustOxyLoss(oxy_damage)
			if(prob(20) && stat != DEAD)
				playsound(src, (stat < UNCONSCIOUS ? 'sound/vo/throat.ogg' : 'sound/effects/bubbles.ogg'), 60, FALSE)
	else
		if(breath_remaining < max_breath)
			var/regen_speed = max_breath / 3.5 
			breath_remaining = min(breath_remaining + regen_speed, max_breath)

	if(!resting && stat == CONSCIOUS && (is_on_new_water || is_true_swimming))
		var/drain = 0
		if(is_true_swimming)
			switch(sw_skill)
				if(SKILL_LEVEL_NONE)       drain = 6.0 
				if(SKILL_LEVEL_NOVICE)     drain = 4.5
				if(SKILL_LEVEL_APPRENTICE) drain = 3.0
				if(SKILL_LEVEL_JOURNEYMAN) drain = 1.5
				if(SKILL_LEVEL_EXPERT)     drain = 1.0
				if(SKILL_LEVEL_MASTER)     drain = 0.5
				if(SKILL_LEVEL_LEGENDARY)  drain = 0.2
			drain *= 1.5 
		else
			drain = 1.2 

		if(m_intent == MOVE_INTENT_RUN) drain *= 1.4
		if(!client) drain *= 1.2
		stamina_add(drain, force_emote = FALSE)
		
	if(is_underwater && !resting)
		if(stamina >= max_stamina || IsKnockdown())
			set_resting(TRUE)

	update_breath_hud()

	
	if(is_true_swimming && !is_underwater && is_on_new_water)
		if(!get_filter("swimming_cutter"))
			add_filter("swimming_cutter", 1, alpha_mask_filter(y=-6, icon=icon('icons/effects/icon_cutter.dmi', "icon_cutter"), flags=MASK_INVERSE))
	else
		if(get_filter("swimming_cutter"))
			remove_filter("swimming_cutter")
			update_icon()

	if(stat != DEAD && is_underwater && client)
		var/filter_ok = FALSE
		if(!filter_ok) apply_underwater_filters()
	
	if(is_true_swimming && !is_underwater && is_on_new_water)
		if(!get_filter("swimming_cutter"))
			add_filter("swimming_cutter", 1, alpha_mask_filter(y=-6, icon=icon('icons/effects/icon_cutter.dmi', "icon_cutter"), flags=MASK_INVERSE))
	else
		if(get_filter("swimming_cutter"))
			remove_filter("swimming_cutter")
			update_icon()

	
	if(is_underwater && client)
		
		if(swimming_filter_client != client) 
			apply_underwater_filters()
	else if(!is_underwater && swimming_filter_client)
		remove_underwater_filters()

	
	if(stat >= UNCONSCIOUS || IsKnockdown() || handcuffed)
		drowning_drowniness++
		if(drowning_drowniness >= 3) adjustOxyLoss(10)
	else
		drowning_drowniness = max(0, drowning_drowniness - 1)

/mob/living/carbon/human/proc/update_breath_hud()
	if(!client || !hud_used || !hud_used.breath)
		return

	
	var/should_show = FALSE
	
	
	if(HAS_TRAIT(src, TRAIT_NOBREATH) || HAS_TRAIT(src, TRAIT_WATERBREATHING))
		should_show = FALSE
	
	else if(is_underwater || is_swimming || breath_remaining < max_breath || (resting && istype(loc, /turf/open/water)))
		should_show = TRUE

	var/target_alpha = should_show ? 255 : 0

	
	if(hud_used.breath.alpha != target_alpha)
		hud_used.breath.alpha = target_alpha
		if(hud_used.breath_bg) hud_used.breath_bg.alpha = target_alpha
		if(hud_used.breath_frame) hud_used.breath_frame.alpha = target_alpha
		if(hud_used.breath_mask) hud_used.breath_mask.alpha = target_alpha


	if(target_alpha == 0) return


	hud_used.breath.layer = 33.2
	
	var/percent = (breath_remaining / max_breath) * 100
	var/icon_num = round(percent / 5) * 5
	icon_num = clamp(icon_num, 0, 100)
	hud_used.breath.icon_state = "stam[icon_num]"
	
	if(percent < 25)
		hud_used.breath.color = list(1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1) 
	else
		hud_used.breath.color = list(0,0,0,0, 0,0.3,0,0, 0,0,1,0, 0,0.5,1,1) 

/mob/living/carbon/human/proc/can_breathe_underwater()
	
	var/list/allowed_gear = list( //For item to alloved breath underwater
	)
	
	for(var/typepath in allowed_gear)
		if(istype(wear_mask, typepath) || istype(head, typepath))
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/calculate_breath_values()
	var/sw_skill = get_skill_level(/datum/skill/misc/swimming)
	var/new_max = (STACON * 1.5) + (sw_skill * 10)
	
	if(new_max != max_breath)
		if(max_breath > 10)
			var/ratio = breath_remaining / max_breath
			max_breath = new_max
			breath_remaining = max_breath * ratio
		else
			max_breath = new_max
			breath_remaining = max_breath

#undef THERMAL_PROTECTION_HEAD
#undef THERMAL_PROTECTION_CHEST
#undef THERMAL_PROTECTION_GROIN
#undef THERMAL_PROTECTION_LEG_LEFT
#undef THERMAL_PROTECTION_LEG_RIGHT
#undef THERMAL_PROTECTION_FOOT_LEFT
#undef THERMAL_PROTECTION_FOOT_RIGHT
#undef THERMAL_PROTECTION_ARM_LEFT
#undef THERMAL_PROTECTION_ARM_RIGHT
#undef THERMAL_PROTECTION_HAND_LEFT
#undef THERMAL_PROTECTION_HAND_RIGHT
#undef FILTER_UNDERWATER_BLUR
#undef FILTER_UNDERWATER_WAVE
