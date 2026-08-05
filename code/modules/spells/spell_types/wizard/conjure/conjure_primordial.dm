/datum/action/cooldown/spell/conjure_summon/primordial
	name = "Conjure Primordial"
	desc = "Conjure a Primordial to fight at your side. Toggle its element with Shift+G while the spell is selected: Flame, Water, or Air. \
	It grows mightier with your skill at Arcyne Armament - upgrading at Expert, and further at Master.\
	You may summon three types of Primordial:\n\
	- Flame - An elemental of moderate health and damage, able to breathe a searing blast of fire in front of them.\n\
	- Water - A slow elemental with high health able to flood the ground and bog down enemies\n\
	- Air - A fast elemental with the highest melee damage, lowest health able to throw targets back with a gust of wind and slows them down"
	button_icon_state = "primetriangle"
	invocations = list("Exsurge, primordiale!")
	summon_noun = "primordial"
	recoil_energy_floor = 150
	modes = list(
		list("name" = "Flame", "tag" = "FIRE", "path" = /mob/living/simple_animal/hostile/retaliate/rogue/primordial/fire, "color" = GLOW_COLOR_FIRE, "invocation" = "Exsurge, ignis!"),
		list("name" = "Water", "tag" = "WATER", "path" = /mob/living/simple_animal/hostile/retaliate/rogue/primordial/water, "color" = GLOW_COLOR_ICE, "invocation" = "Exsurge, unda!"),
		list("name" = "Air", "tag" = "AIR", "path" = /mob/living/simple_animal/hostile/retaliate/rogue/primordial/air, "color" = "#cfe8ff", "invocation" = "Exsurge, ventus!"),
	)

/datum/action/cooldown/spell/conjure_summon/primordial/spawn_summon(turf/T, mob/living/user)
	var/mob_path = modes[current_mode]["path"]
	var/mob/living/simple_animal/hostile/retaliate/rogue/primordial/conjured = new mob_path(T, user)
	scale_primordial(conjured, user)
	return conjured

/datum/action/cooldown/spell/conjure_summon/primordial/proc/scale_primordial(mob/living/simple_animal/hostile/retaliate/rogue/primordial/P, mob/living/user)
	var/tier = get_summon_tier(user)
	var/mult = 1 + (tier - 1) * 0.2
	P.maxHealth = round(P.maxHealth * mult)
	P.health = P.maxHealth
	P.melee_damage_lower = round(P.melee_damage_lower * mult)
	P.melee_damage_upper = round(P.melee_damage_upper * mult)
