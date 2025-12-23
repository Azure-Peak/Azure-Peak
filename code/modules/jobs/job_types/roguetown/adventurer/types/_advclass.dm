/datum/advclass
	var/name
	var/list/classes
	var/outfit
	var/tutorial = "Choose me!"
	var/list/allowed_sexes
	var/list/allowed_races = RACES_ALL_KINDS
	var/list/allowed_patrons
	var/list/allowed_ages
	var/pickprob = 100
	var/maximum_possible_slots = -1
	var/total_slots_occupied = 0
	var/min_pq = -100
	var/class_select_category

	var/horse = FALSE
	var/vampcompat = TRUE
	var/list/traits_applied
	var/cmode_music

	var/noble_income = FALSE //Passive income every day from noble estate

	/// This class is immune to species-based swapped gender locks
	var/immune_to_genderswap = FALSE

	//What categories we are going to sort it in
	var/list/category_tags = list(CTAG_DISABLED)

	/// Whether this class will apply the adaptive name to the job it belongs to.
	var/adaptive_name = FALSE

	/// Stat ceilings for the specific subclass.
	var/list/adv_stat_ceiling

	/// Subclass stat bonuses.
	var/list/subclass_stats

	/// Subclass skills. Everything here is leveled UP TO using adjust_skillrank_up_to EX. list(/datum/skill = SKILL_LEVEL_JOURNEYMAN)
	var/list/subclass_skills

	/// Subclass languages.
	var/list/subclass_languages

	/// Spellpoints. If More than 0, Gives Prestidigitation & the Learning Spell.
	var/subclass_spellpoints = 0

	/// List of items to put in an item stash
	var/list/subclass_stashed_items = list()

	/// Extra fluff added to the role explanation in class selection.
	var/extra_context

	/// Set to FALSE to skip apply_character_post_equipment() which applies virtue, flaw, loadout
	var/applies_post_equipment = TRUE

/datum/advclass/proc/equipme(mob/living/carbon/human/H, dummy = FALSE)
	// input sleeps....
	set waitfor = FALSE
	if(!H)
		return FALSE

	if(outfit)
		H.equipOutfit(outfit, dummy)

		if(dummy)	//This means we're doing a Char Sheet preview. We don't need to equip the dummy with anything else, the outfits are likely to runtime on their own.
			return

	post_equip(H)

	H.advjob = name

	var/turf/TU = get_turf(H)
	if(TU)
		if(horse)
			var/mob/horse_mob = new horse(TU)
			if(istype(horse_mob, /mob/living/simple_animal/hostile/retaliate/rogue))
				var/mob/living/simple_animal/hostile/retaliate/rogue/rogue_animal = horse_mob
				rogue_animal.owner = H
				rogue_animal.friends |= H

	for(var/trait in traits_applied)
		ADD_TRAIT(H, trait, ADVENTURER_TRAIT)

	if(noble_income)
		SStreasury.noble_incomes[H] = noble_income

	if(adaptive_name)
		H.adaptive_name = TRUE

	if(length(subclass_languages))
		for(var/lang in subclass_languages)
			H.grant_language(lang)

	if(length(subclass_stats))
		for(var/stat in subclass_stats)
			H.change_stat(stat, subclass_stats[stat])

	if(length(subclass_skills))
		for(var/skill in subclass_skills)
			H.adjust_skillrank_up_to(skill, subclass_skills[skill], TRUE)

	if(length(subclass_stashed_items))
		if(!H.mind)
			return
		for(var/stashed_item in subclass_stashed_items)
			H.mind?.special_items[stashed_item] = subclass_stashed_items[stashed_item]
	if(subclass_spellpoints > 0)
		H.mind?.adjust_spellpoints(subclass_spellpoints)

	// After the end of adv class equipping, apply a SPECIAL trait if able

	if(applies_post_equipment)
		apply_character_post_equipment(H)

/datum/advclass/proc/post_equip(mob/living/carbon/human/H)
	addtimer(CALLBACK(H,TYPE_PROC_REF(/mob/living/carbon/human, add_credit), TRUE), 20)
	if(cmode_music)
		H.cmode_music = cmode_music

/*
	Whoa! we are checking requirements here!
	On the datum! Wow!
*/
/datum/advclass/proc/check_requirements(mob/living/carbon/human/H)

	var/datum/species/pref_species = H.dna.species
	var/list/local_allowed_sexes = list()
	if(length(allowed_sexes))
		local_allowed_sexes |= allowed_sexes
	if(!immune_to_genderswap && pref_species?.gender_swapping)
		if(MALE in allowed_sexes)
			local_allowed_sexes -= MALE
			local_allowed_sexes += FEMALE
		if(FEMALE in allowed_sexes)
			local_allowed_sexes -= FEMALE
			local_allowed_sexes += MALE
	if(length(local_allowed_sexes) && !(H.gender in local_allowed_sexes))
		return FALSE

	if(length(allowed_races) && !(H.dna.species.type in allowed_races))
		return FALSE

	if(length(allowed_ages) && !(H.age in allowed_ages))
		return FALSE

	if(length(allowed_patrons) && !(H.patron.type in allowed_patrons))
		return FALSE

	if(maximum_possible_slots > -1)
		if(total_slots_occupied >= maximum_possible_slots)
			return FALSE

	#ifdef USES_PQ
	if(min_pq != -100) // If someone sets this we actually do the check.
		if(!(get_playerquality(H.client.ckey) >= min_pq))
			return FALSE
	#endif

	if(prob(pickprob))
		return TRUE

// Basically the handler has a chance to plus up a class, heres a generic proc you can override to handle behavior related to it.
// For now you just get an extra stat in everything depending on how many plusses you managed to get.
/datum/advclass/proc/boost_by_plus_power(plus_factor, mob/living/carbon/human/H)
	for(var/S in MOBSTATS)
		H.change_stat(S, plus_factor)


//Final proc in the set for really silly shit
///datum/advclass/proc/extra_slop_proc_ending(mob/living/carbon/human/H)

