/datum/action/cooldown/spell/projectile/retch
	name = "Retch"
	desc = "Retch up a glob of lux, excited into a volatile state"
	button_icon = 'icons/mob/actions/engineer_skills.dmi'
	button_icon_state = "stomach-lux"
	sound = 'sound/vo/vomit.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = 15

	primary_resource_type = SPELL_COST_LUX
	primary_resource_cost = 1

	charge_required = FALSE
	cooldown_time = 20 SECONDS

	projectile_type = /obj/projectile/magic/retch

	spell_tier = 0
	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN
	allow_cross_z = TRUE

/obj/projectile/magic/retch
	name = "glob of lux"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "lux_impure"
	nodamage = FALSE
	arcshot = TRUE
	var/areadamage = 20
	var/radius = 3

/obj/projectile/magic/retch/on_hit(target)
	. = ..()
	var/turf/T = get_turf(target)
	explode(T, target)

/obj/projectile/magic/retch/proc/explode(turf/T, hittarget)
	if(!nodamage)
		for(var/mob/living/target in dview(radius, T))
			var/dmg = areadamage * (1 - get_dist(target, T) / (radius + 1))
			var/armor_block = target.run_armor_check(BODY_ZONE_CHEST, flag, blade_dulling = BCLASS_BLUNT, damage = dmg, no_debuff = TRUE)
			target.apply_damage(dmg, damage_type, BODY_ZONE_CHEST, armor_block)
			target.apply_status_effect(/datum/status_effect/debuff/staggered)

/datum/action/cooldown/spell/projectile/retch/impure
	desc = "Retch up a glob of impure lux, excited into a volatile state. Explodes, and deals an extra 120 damage, over a radius of three tiles"
	projectile_type = /obj/projectile/magic/retch/impure

//roughly equivalent in power to a stick of dynamite, 'cept with added direct damage on hit, and a smaller radius
/obj/projectile/magic/retch/impure
	name = "glob of impure lux"
	damage = 40
	damage_type = BRUTE
	flag = "blunt"
	areadamage = 120

/obj/projectile/magic/retch/impure/explode(turf/T, target)
	. = ..()
	explosion(T, devastation_range = 0, heavy_impact_range = 1, light_impact_range = radius, smoke = FALSE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

/datum/action/cooldown/spell/projectile/retch/pure
	desc = "Retch up a glob of pure lux, excited into a volatile state. Explodes, and deals an extra 120 damage, over a radius of five tiles."
	primary_resource_cost = 2
	projectile_type = /obj/projectile/magic/retch/impure/pure

/obj/projectile/magic/retch/impure/pure
	name = "glob of pure lux"
	icon_state = "lux"
	radius = 5

/datum/action/cooldown/spell/projectile/retch/infernal
	desc = "Retch up a glob of infernal lux, excited into a volatile state. Explodes, and deals an extra 40 damage, over a radius of three tiles. Burning flame will be left behind."
	projectile_type = /obj/projectile/magic/retch/infernal

/obj/projectile/magic/retch/infernal
	name = "glob of infernal lux"
	icon_state = "lux_infernal"
	damage = 20
	damage_type = BURN
	areadamage = 40
	flag = "fire"

/obj/projectile/magic/retch/infernal/explode(turf/T, hittarget)
	if(!nodamage)
		for(var/mob/living/target in dview(radius, T))
			var/dmg = areadamage * (1 - get_dist(target, T) / (radius + 1))
			var/armor_block = target.run_armor_check(BODY_ZONE_CHEST, flag, blade_dulling = BCLASS_BLUNT, damage = dmg, no_debuff = TRUE)
			target.apply_damage(dmg, damage_type, BODY_ZONE_CHEST, armor_block)
			target.apply_status_effect(/datum/status_effect/debuff/staggered)
			apply_scorch_stack(target, 2)
	for(var/turf/open/O in dview(radius, T))
		if(istransparentturf(O) || cheap_hypotenuse(O.x, O.y, T.x, T.y) > radius || (locate(/obj/effect/curtain_fire) in O))
			continue
		new /obj/effect/curtain_fire(O)
	explosion(T, light_impact_range = radius, flame_range = radius, smoke = FALSE)


/datum/action/cooldown/spell/projectile/retch/tainted
	desc = "Retch up a glob of tainted lux, excited into a volatile state. Explodes, and deals an extra 120 damage, leaving a terrible stench over a radius of three tiles."
	projectile_type = /obj/projectile/magic/retch/impure/tainted

/obj/projectile/magic/retch/impure/tainted
	name = "glob of tainted lux"
	icon_state = "lux_tainted"

/obj/projectile/magic/retch/impure/tainted/explode(turf/T, hittarget)
	. = ..()
	for(var/turf/open/O in dview(radius, T))
		O.pollute_turf(/datum/pollutant/rot, 10)

/datum/action/cooldown/spell/projectile/retch/corrupt
	desc = "Retch up a glob of corrupt lux, excited into a volatile state. Explodes, and deals an extra 40 damage, over a radius of three tiles. Choking poison gas will be left behind."
	projectile_type = /obj/projectile/magic/retch/corrupt

//relatively low damage, but dealt as direct toxic damage. Not terribly dangerous if the target is armored, as long as they get out of the *smoke* it spreads
/obj/projectile/magic/retch/corrupt
	name = "glob of corrupt lux"
	icon = 'icons/roguetown/items/hag/hag_items.dmi'
	icon_state = "mosslux"
	damage = 20
	damage_type = TOX
	areadamage = 40
	flag = "fire" //Will do full damage to armor. it's not a lot, but if the chest is unarmored, that's 60 toxins- making this a scary finisher on a direct hit to the target

/obj/projectile/magic/retch/corrupt/explode(turf/T, hittarget)
	. = ..()
	var/datum/effect_system/smoke_spread/poison_gas/smoke = new /datum/effect_system/smoke_spread/poison_gas
	smoke.set_up(radius, T)
	smoke.start()
