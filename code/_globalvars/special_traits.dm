GLOBAL_LIST_INIT(special_traits, build_special_traits())

#define SPECIAL_TRAIT(trait_type) GLOB.special_traits[trait_type]

/proc/build_special_traits()
	. = list()
	for(var/type in typesof(/datum/special_trait))
		if(is_abstract(type))
			continue
		.[type] = new type()
	return .

/proc/print_special_text(mob/user, trait_type)
	var/datum/special_trait/special = SPECIAL_TRAIT(trait_type)
	to_chat(user, span_notice("<b>[special.name]</b>"))
	to_chat(user, special.greet_text)
	if(special.req_text)
		to_chat(user, span_boldwarning("Requirements: [special.req_text]"))

/proc/try_apply_character_post_equipment(mob/living/carbon/human/character, client/player)
	var/datum/job/job
	if(character.job)
		job = SSjob.name_occupations[character.job]
	if(!job)
		// Apply the stuff if we dont have a job for some reason
		apply_character_post_equipment(character, player)
		return
	if(length(job.advclass_cat_rolls))
		// Dont apply the stuff, let adv class handler do it later
		return
	// Apply the stuff if we have a job that has no adv classes
	apply_character_post_equipment(character, player)

/proc/apply_character_post_equipment(mob/living/carbon/human/character, client/player)
	if(!player)
		player = character.client
	apply_charflaw_equipment(character, player)
	apply_prefs_special(character, player)
	apply_prefs_virtue(character, player)
	apply_prefs_race_bonus(character, player)
	apply_voicepacks(character, player)
	if(player.prefs.dnr_pref)
		apply_dnr_trait(character, player)
	if(player.prefs.qsr_pref)
		apply_qsr_trait(character, player)
	for(var/item_name in player.prefs.gear_list)
		var/datum/loadout_item/LI = GLOB.loadout_items_by_name[item_name]
		if(!LI)
			continue
		if(LI.triumph_cost && character.get_triumphs() < LI.triumph_cost)
			continue
		if(LI.triumph_cost)
			character.adjust_triumphs(-LI.triumph_cost)
		character.mind.special_items[LI.name] = LI.path
	var/datum/job/assigned_job = SSjob.GetJob(character.mind?.assigned_role)
	if(assigned_job)
		assigned_job.clamp_stats(character)
	check_trait_incompatibilities(character)
	character.calculate_energy()
	character.calculate_stamina()
	character.energy = character.max_energy

/// Check for incompatible traits and remove one of them
/proc/check_trait_incompatibilities(mob/living/carbon/human/H)
	// Easy Dismemberment & Critical Resistance get both cancelled out
	if(HAS_TRAIT(H, TRAIT_EASYDISMEMBER) && HAS_TRAIT(H, TRAIT_CRITICAL_RESISTANCE))
		REMOVE_TRAIT(H, TRAIT_EASYDISMEMBER, null) // Doesn't care for source, they ARE getting canceled
		REMOVE_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, null)
		to_chat(H, span_warning("My limbs are too frail and my body too tough... the contradiction leaves me unable to resist critical wounds."))
	return TRUE

/proc/apply_voicepacks(mob/living/carbon/human/character, client/player)
	if(player.prefs.voice_pack != "Default")
		var/datum/voicepack/VP = GLOB.voice_packs_list[player.prefs.voice_pack]
		character.dna.species.soundpack_m = new VP()
		character.dna.species.soundpack_f = new VP()


/proc/apply_prefs_virtue(mob/living/carbon/human/character, client/player)
	if (!player)
		player = character.client
	if (!player)
		return
	if (!player.prefs)
		return

	var/virtuous = FALSE
	var/heretic = FALSE
	var/species = character.dna.species.type

	if(istype(player.prefs.selected_patron, /datum/patron/inhumen))
		heretic = TRUE

	if(player.prefs.statpack.virtuous)
		virtuous = TRUE

	var/datum/virtue/virtue_type = player.prefs.virtue
	var/datum/virtue/virtuetwo_type = player.prefs.virtuetwo
	var/datum/virtue/origin_type = player.prefs.virtue_origin
	var/language_type = player.prefs.extra_language
	if(virtue_type)
		if(virtue_check(virtue_type, heretic, species))
			apply_virtue(character, virtue_type)
		else
			to_chat(character, "Incorrect Virtue parameters! It will not be applied.")
	if(virtuetwo_type && virtuous)
		if(virtue_check(virtuetwo_type, heretic, species))
			apply_virtue(character, virtuetwo_type)
		else
			to_chat(character, "Incorrect Second Virtue parameters! It will not be applied.")
	if(origin_type)
		if((language_type && language_type != "None"))
			character.grant_language(language_type)
		if(origin_type.job_origin == TRUE)
			apply_virtue(character, origin_type)
			player.prefs.virtue_origin = origin_type.last_origin
		else
			if(origin_check(origin_type, species))
				apply_virtue(character, origin_type)
			else
				to_chat(character, "Incorrect Origin parameters! Resetting to default.")
				origin_type = new character.dna.species.origin_default
				apply_virtue(character, origin_type)

/proc/origin_check(var/datum/virtue/V, species)
	if(V)
		if(!istype(V,/datum/virtue/origin))
			return FALSE
		if(V.restricted == TRUE)
			if((species in V.races))
				return FALSE
		if(istype(V,/datum/virtue/origin/racial))
			if(!(species in V.races))
				return FALSE
		return TRUE
	return FALSE

/proc/apply_prefs_race_bonus(mob/living/carbon/human/character, client/player)
	if (!player)
		player = character.client
	if (!player)
		return
	if (!player.prefs)
		return
	if (!player.prefs.race_bonus || player.prefs.race_bonus == "None")
		return
	var/bonus = player.prefs.race_bonus
	if(islist(bonus))
		var/list/bonuslist = bonus
		for(var/B in bonuslist)
			process_race_bonus_option(character, B, bonuslist)
	else
		process_race_bonus_option(character, bonus)

/proc/process_race_bonus_option(mob/living/carbon/human/character, bonus, list/parentlist)
	if(ispath(bonus))	//The bonus is a real path
		if(ispath(bonus, /datum/virtue))
			var/datum/virtue/v = bonus
			apply_virtue(character, new v)
	if(bonus in MOBSTATS)
		var/statchange = 1
		if(parentlist)
			statchange = parentlist[bonus]
		character.change_stat(bonus, statchange)
	if(bonus in GLOB.roguetraits)
		ADD_TRAIT(character, bonus, SPECIES_TRAIT)

/proc/virtue_check(var/datum/virtue/V, heretic = FALSE)
	if(V)
		if(istype(V,/datum/virtue/heretic) && !heretic)
			return FALSE
		return TRUE
	return FALSE

/proc/apply_charflaw_equipment(mob/living/carbon/human/character, client/player)
	for(var/datum/charflaw/cf in character.charflaws)
		cf.apply_post_equipment(character)
		record_featured_object_stat(FEATURED_STATS_VICES, cf.name)

/proc/apply_dnr_trait(mob/living/carbon/human/character, client/player)
	ADD_TRAIT(player.mob, TRAIT_DNR, TRAIT_GENERIC)

/proc/apply_qsr_trait(mob/living/carbon/human/character, client/player)
	ADD_TRAIT(player.mob, TRAIT_QUICKSILVERRESISTANT, TRAIT_GENERIC)

/proc/apply_prefs_special(mob/living/carbon/human/character, client/player)
	if(!player)
		player = character.client
	if(!player)
		return
	if(!player.prefs)
		return
	var/trait_type = player.prefs.next_special_trait
	if(!trait_type)
		return
	apply_special_trait_if_able(character, player, trait_type)
	player.prefs.next_special_trait = null

/proc/apply_special_trait_if_able(mob/living/carbon/human/character, client/player, trait_type)
	if(!charactet_eligible_for_trait(character, player, trait_type))
		log_game("SPECIALS: Failed to apply [trait_type] for [key_name(character)]")
		return FALSE
	log_game("SPECIALS: Applied [trait_type] for [key_name(character)] ([character.get_role_title()])")
	apply_special_trait(character, trait_type)
	return TRUE

/// Applies random special trait IF the client has specials enabled in prefs
/proc/apply_random_special_trait(mob/living/carbon/human/character, client/player)
	if(!player)
		player = character.client
	if(!player)
		return
	var/special_type = get_random_special_for_char(character, player)
	if(!special_type) // Ineligible for all of them, somehow
		return
	apply_special_trait(character, special_type)

/proc/charactet_eligible_for_trait(mob/living/carbon/human/character, client/player, trait_type)
	var/datum/special_trait/special = SPECIAL_TRAIT(trait_type)
	var/datum/job/job
	if(character.job)
		job = SSjob.name_occupations[character.job]
	if(!isnull(special.allowed_jobs))
		if(!job)
			return FALSE
		if(!(job.type in special.allowed_jobs))
			return FALSE
	if(!isnull(special.restricted_jobs) && job && (job.type in special.restricted_jobs))
		return FALSE
	if(!isnull(special.allowed_races) && !(character.dna.species.type in special.allowed_races))
		return FALSE
	if(!isnull(special.allowed_migrants))
		if(!character.migrant_type)
			return FALSE
		if(!(character.migrant_type in special.allowed_migrants))
			return FALSE
	if(!isnull(special.restricted_migrants) && character.migrant_type && (character.migrant_type in special.restricted_migrants))
		return FALSE
	if(!isnull(special.restricted_races) && (character.dna.species.type in special.restricted_races))
		return FALSE
	if(!isnull(special.allowed_sexes) && !(character.gender in special.allowed_sexes))
		return FALSE
	if(!isnull(special.allowed_ages) && !(character.age in special.allowed_ages))
		return FALSE
	if(!isnull(special.allowed_patrons) && !(character.patron.type in special.allowed_patrons))
		return FALSE
	if(!isnull(special.restricted_traits))
		var/has_trait
		for(var/trait in special.restricted_traits)
			if(HAS_TRAIT(character, trait))
				has_trait = TRUE
				break
		if(has_trait)
			return FALSE
	if(!special.can_apply(character))
		return FALSE
	return TRUE

/proc/get_random_special_for_char(mob/living/carbon/human/character, client/player)
	var/list/eligible_weight = list()
	for(var/trait_type in GLOB.special_traits)
		var/datum/special_trait/special = SPECIAL_TRAIT(trait_type)
		if(!charactet_eligible_for_trait(character, player, trait_type))
			continue
		eligible_weight[trait_type] = special.weight

	if(!length(eligible_weight))
		return null

	return pickweight(eligible_weight)

/proc/apply_special_trait(mob/living/carbon/human/character, trait_type, silent)
	var/datum/special_trait/special = SPECIAL_TRAIT(trait_type)
	special.on_apply(character, silent)
	if(!silent && special.greet_text)
		to_chat(character, special.greet_text)
