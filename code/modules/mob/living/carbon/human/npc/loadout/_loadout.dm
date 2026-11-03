GLOBAL_LIST_INIT(npc_loadout_slots, list(
	"head",
	"mask",
	"neck",
	"ears",
	"glasses",
	"id",
	"wrists",
	"gloves",
	"cloak",
	"suit",
	"suit_store",
	"armor",
	"shirt",
	"undershirt",
	"pants",
	"shoes",
	"saiga_shoes",
	"belt",
	"beltl",
	"beltr",
	"back",
	"backl",
	"backr",
	"l_pocket",
	"r_pocket",
	"mouth",
	"accessory",
	"l_hand",
	"r_hand",
))

GLOBAL_LIST_INIT(npc_parts, build_npc_parts())

/proc/build_npc_parts()
	. = list()
	for(var/root in list(/datum/npc_archetype, /datum/npc_body, /datum/npc_loadout, /datum/npc_statpack, /datum/npc_warband))
		for(var/datum/npc_part/part_type as anything in subtypesof(root))
			if(IS_ABSTRACT(part_type))
				continue
			.[part_type] = new part_type()

/proc/get_npc_part(datum/npc_part/part)
	if(istype(part))
		return part
	if(!ispath(part))
		return null
	. = GLOB.npc_parts[part]
	if(!.)
		stack_trace("get_npc_part called with unregistered part type [part]")

/proc/resolve_npc_pick(entry)
	if(!islist(entry))
		return entry
	var/list/options = entry
	if(!length(options))
		return null
	if(isnull(options[options[1]]))
		return pick(options)
	return pickweight(options.Copy())

/datum/npc_part
	abstract_type = /datum/npc_part

/datum/npc_loadout
	parent_type = /datum/npc_part
	abstract_type = /datum/npc_loadout
	var/statpack
	var/list/skills
	var/list/traits
	var/list/weapons
	var/list/clear_slots
	var/list/backpack_contents

	var/head
	var/mask
	var/neck
	var/ears
	var/glasses
	var/id
	var/wrists
	var/gloves
	var/cloak
	var/suit
	var/suit_store
	var/armor
	var/shirt
	var/datum/sprite_accessory/undershirt
	var/pants
	var/shoes
	var/saiga_shoes
	var/belt
	var/beltl
	var/beltr
	var/back
	var/backl
	var/backr
	var/l_pocket
	var/r_pocket
	var/mouth
	var/accessory
	var/l_hand
	var/r_hand

/datum/npc_loadout/proc/apply(datum/outfit/npc/outfit, mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!istype(outfit))
		CRASH("npc loadout [type] applied to a non-npc outfit")
	for(var/slot in clear_slots)
		if(!(slot in GLOB.npc_loadout_slots))
			stack_trace("npc loadout [type] clears unknown slot [slot]")
			continue
		outfit.vars[slot] = null
	for(var/slot in GLOB.npc_loadout_slots)
		var/entry = vars[slot]
		if(isnull(entry))
			continue
		var/resolved = resolve_npc_pick(entry)
		if(resolved == NPC_NOTHING)
			continue
		outfit.vars[slot] = resolved
	apply_weapons(outfit)
	apply_backpack(outfit)
	if(!visualsOnly)
		apply_statpack(H)
		apply_skills(H)
		apply_traits(H)

/datum/npc_loadout/proc/apply_statpack(mob/living/carbon/human/H)
	if(!H || !statpack)
		return
	var/datum/npc_statpack/pack = get_npc_part(statpack)
	pack?.apply(H)

/datum/npc_loadout/proc/apply_weapons(datum/outfit/npc/outfit)
	if(!length(weapons))
		return
	var/list/row = pick(weapons)
	if(row[1] == NPC_NOTHING)
		return
	outfit.r_hand = row[1]
	if(length(row) < 2)
		return
	if(prob(length(row) > 2 ? row[3] : 100))
		outfit.l_hand = row[2]

/datum/npc_loadout/proc/apply_backpack(datum/outfit/npc/outfit)
	for(var/path in backpack_contents)
		var/count = backpack_contents[path]
		if(!isnum(count))
			count = 1
		LAZYINITLIST(outfit.backpack_contents)
		outfit.backpack_contents[path] += count

/datum/npc_loadout/proc/apply_skills(mob/living/carbon/human/H)
	if(!H)
		return
	for(var/skill in skills)
		H.adjust_skillrank_up_to(skill, skills[skill], TRUE)

/datum/npc_loadout/proc/apply_traits(mob/living/carbon/human/H)
	if(!H)
		return
	for(var/trait in traits)
		var/trait_source = traits[trait] || INNATE_TRAIT
		ADD_TRAIT(H, trait, trait_source)

/datum/npc_loadout/armor
	abstract_type = /datum/npc_loadout/armor

/datum/npc_loadout/weapon
	abstract_type = /datum/npc_loadout/weapon

/datum/npc_loadout/kit
	abstract_type = /datum/npc_loadout/kit
