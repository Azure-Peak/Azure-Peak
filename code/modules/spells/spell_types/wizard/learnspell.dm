/datum/action/cooldown/spell/learnspell
	name = "Attempt to learn a new spell"
	desc = "Weave a new spell"
	button_icon_state = "book1"

	click_to_activate = FALSE
	self_cast_possible = TRUE

	charge_required = FALSE
	cooldown_time = 1 SECONDS

	primary_resource_type = SPELL_COST_NONE

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/learnspell/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user) || !user.mind)
		return FALSE
	if(!LAZYLEN(user.mind.mage_aspect_config))
		return FALSE
	var/list/config = user.mind.mage_aspect_config
	var/max_maj = config["major"] || 0
	var/max_min = config["minor"] || 0
	var/max_util = config["utilities"] || 0
	var/current_majors = LAZYLEN(user.mind.major_aspects)
	var/current_minors = LAZYLEN(user.mind.minor_aspects)
	var/util_points_spent = 0
	for(var/path in GLOB.utility_spells)
		if(user.mind.has_spell(path))
			var/is_picked = FALSE
			for(var/datum/action/cooldown/spell/S in user.mind.spell_list)
				if(S.type == path && S.utility_learned)
					is_picked = TRUE
					break
			if(!is_picked)
				continue
			if(ispath(path, /datum/action/cooldown/spell))
				var/datum/action/cooldown/spell/S = path
				util_points_spent += initial(S.point_cost)
			else
				var/obj/effect/proc_holder/spell/S = path
				util_points_spent += initial(S.cost)
	if(current_majors < max_maj || current_minors < max_min || util_points_spent < max_util)
		var/datum/aspect_picker/picker = new(user, TRUE, config)
		picker.ui_interact(user)
		return TRUE
	return FALSE
