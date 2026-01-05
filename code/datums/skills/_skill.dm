/datum/skill
	abstract_type = /datum/skill
	var/name = "Skill"
	var/desc = ""

	var/dream_cost_base = 2
	var/dream_cost_per_level = 0.5
	var/dream_legendary_extra_cost = 1
	var/list/specific_dream_costs
	var/list/dreams

	// Can this skill be randomly chosen when the player is sleeping? Restricted to Level 2.
	var/randomable_dream_xp = TRUE

	var/max_skillbook_level = 6

	// Name for the expert level of this skill on Homesteader
	var/expert_name
	var/color = null

	// Maximum level a player can reach in this skill without any enabling traits
	var/max_untraited_level = SKILL_LEVEL_LEGENDARY
	// If the player has a certain trait(s), what is the maximum level they can reach in this skill
	var/list/trait_uncap
	// Example:
	// list(TRAIT_EXAMPLE = SKILL_LEVEL_MAXIMUM_WITH_TRAIT, TRAIT_EXAMPLE2 = SKILL_LEVEL_MAXIMUM_WITH_TRAIT2)
	// Originally designed for Medicine Expert and now used to protect economic roles's niche

/datum/skill/proc/get_skill_speed_modifier(level)
	return

/datum/skill/proc/get_dream_cost_for_level(level, mob/living/user)
	if(length(specific_dream_costs) >= level)
		return specific_dream_costs[level]
	var/cost = FLOOR(dream_cost_base + (dream_cost_per_level * (level - 1)), 1)
	if(level == SKILL_LEVEL_LEGENDARY)
		cost += dream_legendary_extra_cost

	// Malum worshippers (with TRAIT_FORGEBLESSED) spend fewer dream points on craft skills
	if(user && HAS_TRAIT(user, TRAIT_FORGEBLESSED) && (istype(src, /datum/skill/craft) || (istype(src, /datum/skill/craft/sewing))))
		cost = max(1, FLOOR(cost * 0.5, 1)) // 50% reduction, minimum cost of 1
	else if(user && HAS_TRAIT(user, TRAIT_JACKOFALLTRADES))
		cost = max(1, FLOOR(cost * 0.5, 1)) // Ditto for Homesteader towners
	return cost

/datum/skill/proc/skill_level_effect(level, datum/mind/mind)
	return

/datum/skill/proc/get_random_dream()
	if(!dreams)
		return null
	return pick(dreams)

/datum/skill/Topic(href, href_list)
	. = ..()

	if(href_list["skill_detail"])
		var/msg = ""
		msg += "[desc] <br>"
		#ifndef USES_TRAIT_SKILL_GATING
		msg += span_warning("Note: Trait based skill gating is disabled on this server. The traits exist, but the skill cap will not apply.")
		#endif
		#ifdef USES_TRAIT_SKILL_GATING
		if(max_untraited_level < SKILL_LEVEL_LEGENDARY)
			msg += "------ <br>"
			msg += "This skill is capped at [skill_to_string(max_untraited_level)] without the proper traits. The following traits increase the maximum level you can reach:<br>"
		if(LAZYLEN(trait_uncap))
			for(var/trait_name in trait_uncap)
				var/trait_level = trait_uncap[trait_name]
				msg += "[span_greentext(trait_name)]: [skill_to_string(trait_level)]. <br>"
		#endif
		to_chat(usr, span_info(msg))

