GLOBAL_LIST_EMPTY(npc_aggro_lines)

/proc/get_npc_aggro_lines(file)
	if(!file)
		return null
	. = GLOB.npc_aggro_lines[file]
	if(!.)
		. = world.file2list(file)
		GLOB.npc_aggro_lines[file] = .

/datum/npc_body
	parent_type = /datum/npc_part
	abstract_type = /datum/npc_body
	var/species
	var/list/species_pool
	var/body_gender
	var/randomise_character = TRUE
	var/random_hair = TRUE
	var/beards = TRUE
	var/random_eyes = TRUE
	var/random_voice = TRUE
	var/male_name_file
	var/female_name_file
	var/aggro_system = TRUE
	var/aggro_lines_file
	var/death_line_chance = 0
	var/list/death_lines
	var/list/voicepacks
	var/voicepack_chance = 0
	var/list/traits = list(
		TRAIT_NOMOOD,
		TRAIT_NOHUNGER,
		TRAIT_BREADY,
		TRAIT_NPC_EXAMINE,
		TRAIT_LEECHIMMUNE,
	)

/datum/npc_body/proc/get_head_sellprice()
	return null

/datum/npc_body/proc/apply_early(mob/living/carbon/human/H)
	if(!H)
		return
	var/chosen_species = species
	if(!chosen_species && length(species_pool))
		chosen_species = pick(species_pool)
	if(chosen_species)
		H.set_species(chosen_species)
	H.gender = body_gender ? body_gender : pick(MALE, FEMALE)
	if(randomise_character)
		H.dna.species.random_character(H)

/datum/npc_body/proc/apply_setup(mob/living/carbon/human/H)
	if(!H)
		return
	if(aggro_system)
		H.AddComponent(/datum/component/ai_aggro_system)
	var/list/lines = get_npc_aggro_lines(aggro_lines_file)
	if(lines)
		SEND_SIGNAL(H, COMSIG_MOB_MODIFY_AGGRO_LINES, lines, TRUE)
	if(death_line_chance > 0)
		H.AddComponent(/datum/component/npc_death_line, death_lines, death_line_chance)
	for(var/trait in traits)
		var/trait_source = traits[trait] || INNATE_TRAIT
		ADD_TRAIT(H, trait, trait_source)

/datum/npc_body/proc/apply_appearance(mob/living/carbon/human/H)
	if(!H)
		return
	H.dna.species.handle_body(H)
	var/sellprice = get_head_sellprice()
	if(!isnull(sellprice))
		var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
		if(head)
			head.sellprice = sellprice
	if(random_voice)
		H.random_voice_NPC()
	if(random_hair)
		if(beards)
			H.random_hair_NPC()
		else
			H.random_hair_no_beard_NPC()
	if(random_eyes)
		H.random_eye_color_NPC()
	H.correct_features_NPC()
	apply_voicepack(H)

/datum/npc_body/proc/apply_voicepack(mob/living/carbon/human/H)
	if(!length(voicepacks) || !prob(voicepack_chance))
		return
	var/list/chosen = pick(voicepacks)
	if(!length(chosen))
		return
	H.dna.species.soundpack_m = GLOB.voice_packs[chosen[1]]
	H.dna.species.soundpack_f = GLOB.voice_packs[length(chosen) > 1 ? chosen[2] : chosen[1]]

/datum/npc_body/proc/apply_name(mob/living/carbon/human/H)
	if(!H)
		return
	var/name_file = (H.gender == FEMALE) ? female_name_file : male_name_file
	if(!name_file)
		return
	H.real_name = pick(world.file2list(name_file))

/datum/npc_body/proc/finish(mob/living/carbon/human/H)
	if(!H)
		return
	H.update_hair()
	H.update_body()
	H.regenerate_icons()
