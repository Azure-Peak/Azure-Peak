#define HEAL_MIN_MISSING 0.2
#define HEAL_BASE_SCORE 25
#define HEAL_WOUNDED_SCORE 60
#define HEAL_ENGAGED_BONUS 10

/datum/action/cooldown/spell/miracle/heal
	npc_max_range = 4
	npc_targets_allies = TRUE
	self_targetable = TRUE

/datum/action/cooldown/spell/miracle/heal/proc/npc_heal_tears_embeds(mob/living/ally)
	for(var/object in ally.get_embedded_objects())
		if(!istype(object, /obj/item/natural/worms/leech))
			return TRUE
	return FALSE

/datum/action/cooldown/spell/miracle/heal/npc_ally_need(mob/living/ally)
	var/mob/living/caster = owner
	if(!ishuman(ally) || ally.maxHealth <= 0 || ally.has_status_effect(/datum/status_effect/buff/healing))
		return 0
	if(HAS_TRAIT(ally, TRAIT_PSYDONITE) || HAS_TRAIT(ally, TRAIT_UNFORGIVABLE) || HAS_TRAIT(ally, TRAIT_IRONMAN))
		return 0
	if(caster.patron?.undead_hater && (ally.mob_biotypes & MOB_UNDEAD))
		return 0
	if(npc_heal_tears_embeds(ally))
		return 0
	var/missing = clamp(1 - ally.health / ally.maxHealth, 0, 1)
	if(missing < HEAL_MIN_MISSING)
		return 0
	. = round(HEAL_WOUNDED_SCORE * missing)
	if(npc_ally_engaged(ally))
		. += HEAL_ENGAGED_BONUS

/datum/action/cooldown/spell/miracle/heal/npc_use_chance(atom/target)
	var/mob/living/ally = target
	if(!isliving(ally))
		return 0
	var/need = npc_ally_need(ally)
	if(need <= 0)
		return 0
	return HEAL_BASE_SCORE + need

#undef HEAL_MIN_MISSING
#undef HEAL_BASE_SCORE
#undef HEAL_WOUNDED_SCORE
#undef HEAL_ENGAGED_BONUS
