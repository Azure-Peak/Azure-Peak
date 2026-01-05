

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
		for(var/datum/antagonist/A in mind.antag_datums)
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
	update_stamina()
	update_energy()
	if(charflaw && !charflaw.ephemeral && mind)
		charflaw.flaw_on_life(src)
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
		for(var/datum/antagonist/A in mind.antag_datums)
			A.on_life(src)

	. = ..()
	name = get_visible_name()

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
//	var/coverfeet
	//add belt slots to this for rusting
	var/list/body_parts = list(head, wear_mask, wear_wrists, wear_shirt, wear_neck, cloak, wear_armor, wear_pants, backr, backl, gloves, shoes, belt, s_store, glasses, ears, wear_ring) //Everything but pockets. Pockets are l_store and r_store. (if pockets were allowed, putting something armored, gloves or hats for example, would double up on the armor)
	for(var/bp in body_parts)
		if(!bp)
			continue
		if(bp && istype(bp , /obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(zone2covered(BODY_ZONE_HEAD, C.body_parts_covered))
				coverhead = TRUE
//			if(zone2covered(BODY_ZONE_PRECISE_L_FOOT, C.body_parts_covered))
//				coverfeet = TRUE
	if(locations & HEAD)
		if(!coverhead)
			add_stress(/datum/stressevent/coldhead)
//	if(locations & FEET)
//		if(!coverfeet)
//			add_stress(/datum/stressevent/coldfeet)

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
