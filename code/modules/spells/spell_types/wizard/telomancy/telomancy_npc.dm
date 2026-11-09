#define CIRCUMDATUM_BASE_NEED 10
#define CIRCUMDATUM_ENGAGED_NEED 30
#define CIRCUMDATUM_WOUNDED_NEED 20
#define CIRCUMDATUM_BASE_SCORE 25

/datum/action/cooldown/spell/circumdatum
	npc_max_range = 7
	npc_targets_allies = TRUE

/datum/action/cooldown/spell/circumdatum/npc_ally_need(mob/living/ally)
	if(!ishuman(ally) || ally.has_status_effect(/datum/status_effect/buff/circumdatum))
		return 0
	. = CIRCUMDATUM_BASE_NEED
	if(npc_ally_engaged(ally))
		. += CIRCUMDATUM_ENGAGED_NEED
	if(ally.maxHealth > 0)
		. += round(CIRCUMDATUM_WOUNDED_NEED * clamp(1 - ally.health / ally.maxHealth, 0, 1))

/datum/action/cooldown/spell/circumdatum/npc_use_chance(atom/target)
	var/mob/living/ally = target
	if(!isliving(ally))
		return 0
	var/need = npc_ally_need(ally)
	if(need <= 0)
		return 0
	return CIRCUMDATUM_BASE_SCORE + need

#undef CIRCUMDATUM_BASE_NEED
#undef CIRCUMDATUM_ENGAGED_NEED
#undef CIRCUMDATUM_WOUNDED_NEED
#undef CIRCUMDATUM_BASE_SCORE
