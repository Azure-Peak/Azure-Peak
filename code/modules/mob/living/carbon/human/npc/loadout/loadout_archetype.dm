GLOBAL_LIST_INIT(npc_melee_skills, list(
	/datum/skill/combat/knives,
	/datum/skill/combat/polearms,
	/datum/skill/combat/staves,
	/datum/skill/combat/maces,
	/datum/skill/combat/axes,
	/datum/skill/combat/swords,
	/datum/skill/combat/shields,
	/datum/skill/combat/whipsflails,
))

GLOBAL_LIST_INIT(npc_brawl_skills, list(
	/datum/skill/combat/unarmed,
	/datum/skill/combat/wrestling,
))

GLOBAL_LIST_INIT(npc_survival_skills, list(
	/datum/skill/misc/swimming,
	/datum/skill/misc/climbing,
))

GLOBAL_LIST_INIT(npc_athletics_skills, list(
	/datum/skill/misc/athletics,
))

GLOBAL_LIST_INIT(npc_crafting_skills, list(
	/datum/skill/craft/carpentry,
	/datum/skill/craft/masonry,
	/datum/skill/craft/crafting,
	/datum/skill/craft/sewing,
))

/datum/npc_archetype
	parent_type = /datum/npc_part
	abstract_type = /datum/npc_archetype
	var/name = "NPC"
	var/job
	var/category
	var/faction_tag
	var/threat_point = 0
	var/body
	var/statpack
	var/patron
	var/armor_training = ARMOR_CLASS_NONE
	var/melee
	var/brawl
	var/survival
	var/athletics
	var/crafting
	var/list/skills
	var/outfit_type = /datum/outfit/npc
	var/list/loadouts
	var/list/variants
	var/ai_controller
	var/list/traits

/datum/npc_archetype/proc/apply_early(mob/living/carbon/human/H)
	var/datum/npc_body/npc_body = get_npc_part(body)
	if(npc_body)
		npc_body.apply_early(H)

/datum/npc_archetype/proc/apply(mob/living/carbon/human/H)
	if(!H)
		return
	if(job)
		H.job = job
	var/datum/npc_body/npc_body = get_npc_part(body)
	var/datum/npc_statpack/npc_statpack = get_npc_part(statpack)
	if(npc_body)
		npc_body.apply_setup(H)
	for(var/trait in traits)
		var/trait_source = traits[trait] || INNATE_TRAIT
		ADD_TRAIT(H, trait, trait_source)
	if(patron)
		H.set_patron(patron)
	if(npc_statpack)
		npc_statpack.apply(H)
	apply_skills(H)
	apply_armor_training(H)
	if(ai_controller)
		H.upgrade_ai_controller(ai_controller)
	H.equipOutfit(build_outfit())
	if(npc_body)
		npc_body.apply_appearance(H)
		npc_body.apply_name(H)
		npc_body.finish(H)

/datum/npc_archetype/proc/apply_skills(mob/living/carbon/human/H)
	apply_skill_group(H, GLOB.npc_melee_skills, melee)
	apply_skill_group(H, GLOB.npc_brawl_skills, brawl)
	apply_skill_group(H, GLOB.npc_survival_skills, survival)
	apply_skill_group(H, GLOB.npc_athletics_skills, athletics)
	apply_skill_group(H, GLOB.npc_crafting_skills, crafting)
	for(var/skill in skills)
		H.adjust_skillrank_up_to(skill, skills[skill], TRUE)

/datum/npc_archetype/proc/apply_skill_group(mob/living/carbon/human/H, list/group, rank)
	if(isnull(rank))
		return
	for(var/skill in group)
		H.adjust_skillrank_up_to(skill, rank, TRUE)

/datum/npc_archetype/proc/apply_armor_training(mob/living/carbon/human/H)
	switch(armor_training)
		if(ARMOR_CLASS_MEDIUM)
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, NPC_LOADOUT_TRAIT)
		if(ARMOR_CLASS_HEAVY)
			ADD_TRAIT(H, TRAIT_HEAVYARMOR, NPC_LOADOUT_TRAIT)

/datum/npc_archetype/proc/resolve_variant()
	var/datum/npc_archetype/archetype = src
	for(var/depth in 1 to 5)
		if(!length(archetype.variants))
			return archetype
		var/datum/npc_archetype/next = get_npc_part(resolve_npc_pick(archetype.variants))
		if(!next)
			stack_trace("npc archetype [archetype.type] rolled an unregistered variant")
			return archetype
		archetype = next
	stack_trace("npc archetype [type] variants nest too deep")
	return archetype

/datum/npc_archetype/proc/build_outfit()
	var/datum/outfit/npc/outfit = new outfit_type
	outfit.loadouts = resolve_loadouts()
	return outfit

/datum/npc_archetype/proc/resolve_loadouts()
	. = list()
	for(var/entry in loadouts)
		var/picked = resolve_npc_pick(entry)
		if(picked && picked != NPC_NOTHING)
			. += picked

/mob/living/carbon/human/proc/init_npc_archetype()
	var/datum/npc_archetype/archetype = get_npc_part(npc_archetype)
	if(!archetype)
		return
	archetype = archetype.resolve_variant()
	npc_archetype = archetype.type
	archetype.apply_early(src)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/proc/apply_npc_archetype()
	var/datum/npc_archetype/archetype = get_npc_part(npc_archetype)
	if(!archetype)
		return
	archetype.apply(src)
