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
	var/joins_cabal = TRUE
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
	var/default_ward = /datum/action/cooldown/spell/conjure_arcyne_ward
	var/list/traits
	var/taur_type
	var/list/taur_colors
	// Factional stat modifiers. These are applied on top of statpacks. They do not need to be even trade
	var/list/stat_modifiers

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
		H.set_patron(resolve_npc_pick(patron))
		if(!joins_cabal)
			H.faction -= FACTION_CABAL
	if(npc_statpack)
		npc_statpack.apply(H)
	apply_skills(H)
	apply_armor_training(H)
	if(ai_controller)
		H.upgrade_ai_controller(ai_controller)
	// Before the outfit, as Taurize drops worn shoes
	if(taur_type)
		H.Taurize(taur_type, length(taur_colors) ? pick(taur_colors) : "#ffffff")
	var/datum/outfit/npc/outfit = build_outfit()
	H.equipOutfit(outfit)
	grant_spellblade_chant(H, outfit.loadouts)
	grant_magic_aspect(H, outfit.loadouts)
	grant_npc_miracles(H, outfit.loadouts)
	apply_stat_modifiers(H)
	if(npc_body)
		npc_body.apply_appearance(H)
		npc_body.apply_name(H)
		npc_body.finish(H)

/datum/npc_archetype/proc/apply_stat_modifiers(mob/living/carbon/human/H)
	if(!H || !length(stat_modifiers))
		return
	H.STASTR += stat_modifiers["strength"]
	H.STASPD += stat_modifiers["speed"]
	H.STACON += stat_modifiers["constitution"]
	H.STAWIL += stat_modifiers["willpower"]
	H.STAPER += stat_modifiers["perception"]
	H.STAINT += stat_modifiers["intelligence"]
	H.recalculate_pain_threshold()

/datum/npc_archetype/proc/grant_spellblade_chant(mob/living/carbon/human/H, list/loadout_types)
	if(!H)
		return
	var/chant_name
	for(var/path in loadout_types)
		var/datum/npc_loadout/loadout = get_npc_part(path)
		if(loadout?.spellblade_chant)
			chant_name = loadout.spellblade_chant
	if(!chant_name)
		return
	var/datum/spellblade_chant/chant = GLOB.npc_spellblade_chants[chant_name]
	if(!chant)
		stack_trace("npc archetype [type] names unknown spellblade chant [chant_name]")
		return
	chant.apply_npc_chant(H)

/datum/npc_archetype/proc/grant_magic_aspect(mob/living/carbon/human/H, list/loadout_types)
	if(!H)
		return
	var/list/aspects = list()
	for(var/path in loadout_types)
		var/datum/npc_loadout/loadout = get_npc_part(path)
		for(var/aspect_type in loadout?.magic_aspects)
			aspects[aspect_type] = loadout.magic_aspects[aspect_type]
	if(!length(aspects))
		return
	for(var/aspect_type in aspects)
		var/datum/magic_aspect/aspect = GLOB.magic_aspect_singletons[aspect_type]
		if(!aspect)
			stack_trace("npc archetype [type] names unknown magic aspect [aspect_type]")
			continue
		aspect.grant_npc_spells(H, aspects[aspect_type])
	var/datum/action/cooldown/spell/conjure_arcyne_ward/ward = locate() in H.actions
	if(!ward && default_ward)
		ward = new default_ward(H)
		ward.Grant(H)
	for(var/datum/action/cooldown/spell/spell in H.actions)
		spell.npc_on_spawn(H)

/datum/npc_archetype/proc/grant_npc_miracles(mob/living/carbon/human/H, list/loadout_types)
	if(!H)
		return
	var/tier
	for(var/path in loadout_types)
		var/datum/npc_loadout/loadout = get_npc_part(path)
		if(isnull(loadout?.miracle_tier))
			continue
		tier = isnull(tier) ? loadout.miracle_tier : max(tier, loadout.miracle_tier)
	if(isnull(tier))
		return
	var/datum/patron/god = H.patron
	if(!length(god?.miracles))
		stack_trace("npc archetype [type] grants miracles but its patron has none")
		return
	var/datum/devotion/devotion = H.devotion || new /datum/devotion(H, god)
	devotion.level = tier
	devotion.max_devotion = tier >= CLERIC_T3 ? CLERIC_REQ_2 : CLERIC_REQ_1
	devotion.devotion = devotion.max_devotion
	devotion.passive_devotion_gain = CLERIC_REGEN_WEAK
	START_PROCESSING(SSobj, devotion)
	for(var/spell_type in god.miracles)
		if(god.miracles[spell_type] > tier || !ispath(spell_type, /datum/action/cooldown/spell))
			continue
		if((spell_type in GLOB.utility_spells) || (spell_type in GLOB.npc_skipped_spells))
			continue
		if(locate(spell_type) in H.actions)
			continue
		var/datum/action/cooldown/spell/miracle = new spell_type(H)
		miracle.Grant(H)

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
