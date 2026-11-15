#define RUSH_FATIGUE_RATIO 0.75
#define RUSH_FATIGUE_SCORE 45
#define RUSH_BLOOD_SCORE 30
#define RUSH_HURT_RATIO 0.5
#define RUSH_HURT_SCORE 25
#define HAMSTRING_SCORE 40
#define HAMSTRING_FLEEING_BONUS 20
#define NET_SCORE 40
#define NET_SHOOTER_BONUS 25
#define NET_FLEEING_BONUS 20
#define ROAR_MIN_BUFFED 1
#define ROAR_BASE_SCORE 45
#define ROAR_PER_BUFFED 10
#define GRAGGAR_NPC_RESERVE 0.85

/proc/npc_graggar_within_reserve(datum/action/cooldown/spell/spell)
	if(spell.npc_escape)
		return TRUE
	var/mob/living/caster = spell.owner
	if(!isliving(caster))
		return FALSE
	return caster.stamina + spell.npc_stamina_cost() <= caster.max_stamina * GRAGGAR_NPC_RESERVE

/datum/action/cooldown/spell/graggar/npc_within_reserve(datum/ai_controller/controller)
	return npc_graggar_within_reserve(src)

/datum/action/cooldown/spell/projectile/graggar_net/npc_within_reserve(datum/ai_controller/controller)
	return npc_graggar_within_reserve(src)

/datum/action/cooldown/spell/graggar/rush
	npc_max_range = 7
	npc_escape = TRUE

/datum/action/cooldown/spell/graggar/rush/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/graggar/rush/npc_use_chance(atom/target)
	var/mob/living/carbon/human/H = owner
	if(!istype(H) || H.has_status_effect(/datum/status_effect/buff/adrenaline_rush))
		return 0
	. = 0
	if(H.stamina >= H.max_stamina * RUSH_FATIGUE_RATIO)
		. += RUSH_FATIGUE_SCORE
	if(H.blood_volume < BLOOD_VOLUME_SAFE)
		. += RUSH_BLOOD_SCORE
	if(H.maxHealth > 0 && H.health < H.maxHealth * RUSH_HURT_RATIO)
		. += RUSH_HURT_SCORE

/datum/action/cooldown/spell/graggar/hamstring
	npc_max_range = 2

/datum/action/cooldown/spell/graggar/hamstring/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/graggar/hamstring/npc_use_chance(atom/target)
	var/mob/living/caster = owner
	var/mob/living/victim = target
	if(!isliving(caster) || !isliving(victim) || npc_target_pinned(victim))
		return 0
	if(caster.has_status_effect(/datum/status_effect/hamstring) || victim.has_status_effect(/datum/status_effect/debuff/hamstring))
		return 0
	. = HAMSTRING_SCORE
	if(npc_target_fleeing(victim))
		. += HAMSTRING_FLEEING_BONUS

/datum/action/cooldown/spell/projectile/graggar_net
	npc_min_range = 1
	npc_max_range = 7

/datum/action/cooldown/spell/projectile/graggar_net/npc_use_chance(atom/target)
	var/mob/living/carbon/victim = target
	if(!iscarbon(victim) || victim.legcuffed || npc_target_pinned(victim))
		return 0
	if(victim.has_status_effect(/datum/status_effect/debuff/netted))
		return 0
	. = NET_SCORE
	if(npc_target_shooting(victim))
		. += NET_SHOOTER_BONUS
	if(npc_target_fleeing(victim))
		. += NET_FLEEING_BONUS

/datum/action/cooldown/spell/graggar/graggar_battlecry
	npc_max_range = 7

/datum/action/cooldown/spell/graggar/graggar_battlecry/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/graggar/graggar_battlecry/proc/npc_roar_spares(mob/living/carbon/C)
	if(istype(C.patron, /datum/patron/old_god) || istype(C.patron, /datum/patron/vheslyn))
		return TRUE
	return !!(C.mob_biotypes & MOB_UNDEAD)

/datum/action/cooldown/spell/graggar/graggar_battlecry/npc_use_chance(atom/target)
	var/mob/living/caster = owner
	if(!isliving(caster) || caster.has_status_effect(/datum/status_effect/buff/call_to_slaughter))
		return 0
	var/buffed = 0
	for(var/mob/living/carbon/C in view(cast_range, get_turf(owner)))
		if(C.stat == DEAD)
			continue
		var/allied = npc_is_ally(C)
		if(istype(C.patron, /datum/patron/inhumen))
			if(!C.has_status_effect(/datum/status_effect/buff/call_to_slaughter))
				buffed += allied ? 1 : -1
			continue
		if(allied && !npc_roar_spares(C))
			return 0
	if(buffed < ROAR_MIN_BUFFED)
		return 0
	return ROAR_BASE_SCORE + ROAR_PER_BUFFED * buffed

#undef RUSH_FATIGUE_RATIO
#undef RUSH_FATIGUE_SCORE
#undef RUSH_BLOOD_SCORE
#undef RUSH_HURT_RATIO
#undef RUSH_HURT_SCORE
#undef HAMSTRING_SCORE
#undef HAMSTRING_FLEEING_BONUS
#undef NET_SCORE
#undef NET_SHOOTER_BONUS
#undef NET_FLEEING_BONUS
#undef ROAR_MIN_BUFFED
#undef ROAR_BASE_SCORE
#undef ROAR_PER_BUFFED
#undef GRAGGAR_NPC_RESERVE
