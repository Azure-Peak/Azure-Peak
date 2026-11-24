//Fucked up and evil lightsnuff
/datum/action/cooldown/spell/zizo/snuff_lights
	npc_max_range = 7
	npc_escape = TRUE

/datum/action/cooldown/spell/zizo/snuff_lights/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/zizo/snuff_lights/npc_use_chance(atom/target)
	var/mob/living/carbon/human/H = owner
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	if(!istype(H) || H.has_status_effect(/datum/status_effect/buff/snuff_lights))
		return 0 //won't do if we somehow have the status effect (not it matters)
	if(victim.health < victim.maxHealth * 0.5)
		return 60 //we have a 60% chance to use this when target is at half-health (they are already dying)
	if(H.health < H.maxHealth * 0.5)
		return 50 //we have a 50% chance to use this at half-health (we are already dying)
	if(get_dist(H, victim) <= 3)
		return 20 //if we're close up (3 tiles) we'll have one out of five chance to use it (20%)
	. = 0

//Profane bone shard, also evil and fucked up
/datum/action/cooldown/spell/projectile/zizo/profane
	npc_min_range = 1
	npc_max_range = 7

/datum/action/cooldown/spell/projectile/zizo/profane/npc_use_chance(atom/target)
	var/mob/living/victim = target
	if(!isliving(victim))
		return 0
	if(HAS_TRAIT(victim, TRAIT_PIERCEIMMUNE) || (HAS_TRAIT(victim, TRAIT_BLOODLOSS_IMMUNE) && !HAS_TRAIT(victim, TRAIT_VAMP_DREAMS))) //we don't bother on true undead + embed immune people (we don't metagame vampires though)
		return 0
	. = 15
	if(get_dist(owner, target) >= 4)
		. += 35 //50% to use when you are more than 3 tiles away
