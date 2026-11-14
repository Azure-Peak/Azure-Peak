#define FERRA_HAMMER_STILL_BONUS 30
#define FERRA_LANCE_STILL_BONUS 35
#define FERRA_REARM_SCORE 90

/datum/action/cooldown/spell/ferramancy_strike
	require_target_in_pattern = TRUE
	track_target = TRUE

/datum/action/cooldown/spell/ferramancy_strike/falling_crescent
	npc_max_range = 3

/datum/action/cooldown/spell/ferramancy_strike/falling_crescent/npc_use_chance(atom/target)
	return npc_strike_score(target, 50)

/datum/action/cooldown/spell/ferramancy_strike/sorcerers_lance
	npc_max_range = 5

/datum/action/cooldown/spell/ferramancy_strike/sorcerers_lance/npc_use_chance(atom/target)
	. = npc_strike_score(target, 25)
	if(. && npc_target_stationary(target))
		. += FERRA_LANCE_STILL_BONUS

/datum/action/cooldown/spell/ferramancy_strike/heavens_hammer
	npc_max_range = 3

/datum/action/cooldown/spell/ferramancy_strike/heavens_hammer/npc_use_chance(atom/target)
	. = npc_strike_score(target, 40)
	if(. && npc_target_stationary(target))
		. += FERRA_HAMMER_STILL_BONUS

/datum/action/cooldown/spell/form_blade/npc_on_spawn(mob/living/carbon/human/H)
	if(!conjured_weapon && H.get_empty_held_indexes())
		manifest_form(H, forms[form_index]["weapon"])

/datum/action/cooldown/spell/form_blade/can_use(atom/target)
	return isliving(owner)

/datum/action/cooldown/spell/form_blade/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/form_blade/npc_use_chance(atom/target)
	var/mob/living/carbon/human/H = owner
	if(!istype(H) || !H.get_empty_held_indexes())
		return 0
	if(conjured_weapon && !QDELETED(conjured_weapon) && H.is_holding(conjured_weapon))
		return 0
	for(var/obj/item/held in list(H.get_active_held_item(), H.get_inactive_held_item()))
		if(isweapon(held) && !istype(held, /obj/item/rogueweapon/shield))
			return 0
	return FERRA_REARM_SCORE

#undef FERRA_HAMMER_STILL_BONUS
#undef FERRA_LANCE_STILL_BONUS
#undef FERRA_REARM_SCORE
