/datum/action/cooldown/spell/forcewall
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "Forcewall"
	desc = "Conjure a 5x1 wall of arcyne force in front of you, preventing anyone and anything other than you from moving through it.\n\
	The wall lasts for 20 seconds or until destroyed."
	button_icon_state = "forcewall"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_AOE

	invocations = list("Murus!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/forcewall/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/front = get_turf(cast_on)
	if(!front)
		return FALSE

	var/list/affected_turfs = list()
	affected_turfs += front

	if(H.dir == SOUTH || H.dir == NORTH)
		affected_turfs += get_step(front, WEST)
		affected_turfs += get_step(get_step(front, WEST), WEST)
		affected_turfs += get_step(front, EAST)
		affected_turfs += get_step(get_step(front, EAST), EAST)
	else
		affected_turfs += get_step(front, NORTH)
		affected_turfs += get_step(get_step(front, NORTH), NORTH)
		affected_turfs += get_step(front, SOUTH)
		affected_turfs += get_step(get_step(front, SOUTH), SOUTH)

	for(var/turf/affected_turf in affected_turfs)
		new /obj/effect/temp_visual/trap_wall(affected_turf)
		addtimer(CALLBACK(src, PROC_REF(spawn_wall), affected_turf, H), 1 SECONDS)

	H.visible_message("[H] mutters an incantation and a wall of arcyne force manifests out of thin air!")
	return TRUE

/datum/action/cooldown/spell/forcewall/proc/spawn_wall(turf/target, mob/caster)
	new /obj/structure/forcefield_weak(target, caster)

/obj/structure/forcefield_weak
	desc = "A wall of pure arcyne force."
	name = "Arcyne Wall"
	icon = 'icons/effects/effects.dmi'
	icon_state = "arcynewall"
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	opacity = 0
	density = TRUE
	max_integrity = 150
	CanAtmosPass = ATMOS_PASS_DENSITY
	var/timeleft = 20 SECONDS
	var/mob/caster

/obj/structure/forcefield_weak/Initialize(mapload, mob/summoner)
	. = ..()
	caster = summoner
	if(timeleft)
		QDEL_IN(src, timeleft)

/obj/structure/forcefield_weak/CanPass(atom/movable/mover, turf/target)
	if(mover == caster)
		return TRUE
	if(ismob(mover))
		var/mob/M = mover
		if(M.anti_magic_check(chargecost = 0))
			return TRUE
	return FALSE

/obj/effect/temp_visual/trap_wall
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER
