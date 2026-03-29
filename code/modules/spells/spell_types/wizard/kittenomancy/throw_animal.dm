#define KITTENOMANCY_EXPLODE_RADIUS 1
#define KITTENOMANCY_FRAGMENT_COUNT 4
#define KITTENOMANCY_FRAGMENT_DAMAGE 15

/datum/action/cooldown/spell/projectile/throw_kitten
	button_icon = 'icons/mob/actions/mage_kittenomancy.dmi'
	name = "Throw Kitten"
	desc = "Conjure and hurl a spectral kitten at a target. On impact, the kitten explodes into gore, \
	dealing 80 brute damage to the target and sending bone fragments flying. \
	Paints everyone nearby in blood. Arcable."
	button_icon_state = "throw_kitten"
	sound = 'sound/vo/mobs/cat/cat_meow1.ogg'
	spell_color = GLOW_COLOR_HEX
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_KITTENOMANCY

	projectile_type = /obj/projectile/magic/thrown_cat
	projectile_type_arc = /obj/projectile/magic/thrown_cat/arc
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Feles Meowrtem!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 6.5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_HIGH
	is_implement_scaled_spell = TRUE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/projectile/throw_puppy
	button_icon = 'icons/mob/actions/mage_kittenomancy.dmi'
	name = "Throw Puppy"
	desc = "Conjure and hurl a spectral puppy at a target. On impact, the puppy explodes into gore, \
	dealing 80 brute damage to the target and sending bone fragments flying. \
	Paints everyone nearby in blood. Arcable."
	button_icon_state = "throw_puppy"
	sound = 'sound/vo/mobs/cat/roar1.ogg'
	spell_color = GLOW_COLOR_HEX
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_KITTENOMANCY

	projectile_type = /obj/projectile/magic/thrown_cat/puppy
	projectile_type_arc = /obj/projectile/magic/thrown_cat/puppy/arc
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Canis Meowrtem!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 8 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_HIGH
	is_implement_scaled_spell = TRUE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

// Projectile - explodes into gore on impact
/obj/projectile/magic/thrown_cat
	name = "spectral kitten"
	icon = 'icons/obj/kittenomancy_projectiles.dmi'
	icon_state = "thrown_cat"
	damage = 80
	nodamage = FALSE
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	speed = MAGE_PROJ_VERY_SLOW // So they can see you throwing a kitten, you monster
	flag = "blunt"
	range = SPELL_RANGE_PROJECTILE
	speed = MAGE_PROJ_MEDIUM
	guard_deflectable = TRUE
	npc_simple_damage_mult = 1.5

/obj/projectile/magic/thrown_cat/arc
	arcshot = TRUE

/obj/projectile/magic/thrown_cat/on_hit(atom/target)
	. = ..()
	var/turf/T = get_turf(target)
	if(!T)
		return
	// Gore explosion
	playsound(T, 'sound/combat/gib (1).ogg', 100, TRUE)
	new /obj/effect/gibspawner/generic(T)
	// Blood splatter on everyone nearby
	for(var/turf/aoe_turf in range(KITTENOMANCY_EXPLODE_RADIUS, T))
		for(var/mob/living/L in aoe_turf.contents)
			if(L == firer)
				continue
			L.add_mob_blood(L)
	// Gore fragments
	var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	for(var/i in 1 to KITTENOMANCY_FRAGMENT_COUNT)
		var/dir = pick_n_take(dirs)
		var/turf/frag_target = get_ranged_target_turf(T, dir, 3)
		var/obj/projectile/magic/gore_fragment/frag = new(T)
		frag.damage = KITTENOMANCY_FRAGMENT_DAMAGE
		if(firer)
			frag.firer = firer
		frag.preparePixelProjectile(frag_target, T)
		frag.fire()

/obj/projectile/magic/gore_fragment
	name = "gore fragment"
	icon = 'icons/effects/blood.dmi'
	icon_state = "gib1"
	damage = 15
	nodamage = FALSE
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	range = 3
	speed = MAGE_PROJ_SLOW
	guard_deflectable = TRUE

/obj/projectile/magic/thrown_cat/puppy
	name = "spectral puppy"
	icon_state = "thrown_puppy"

/obj/projectile/magic/thrown_cat/puppy/arc
	arcshot = TRUE

#undef KITTENOMANCY_EXPLODE_RADIUS
#undef KITTENOMANCY_FRAGMENT_COUNT
#undef KITTENOMANCY_FRAGMENT_DAMAGE
