#define ICEWALL_FROST_PASS_KEY "icewall_frost_pass"

/datum/action/cooldown/spell/forcewall/ice
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "Ice Wall"
	desc = "Conjure a 5x1 wall of solid ice, blocking anyone and anything from shooting or moving through it. \
	Those caught beside it as it erupts are left frosted. The wall lasts for 20 seconds or until shattered."
	button_icon_state = "frost_blast"
	sound = 'sound/spellbooks/crystal.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CRYOMANCY
	charge_swingdelay_type = SWINGDELAY_NORMAL
	telegraph_type = /obj/effect/temp_visual/trapice
	invocations = list("Murus Glaciei!")

/datum/action/cooldown/spell/forcewall/ice/spawn_wall(turf/target, mob/caster)
	new /obj/structure/forcefield_weak/ice(target, caster)

/obj/structure/forcefield_weak/ice
	name = "wall of ice"
	desc = "A slab of conjured ice"
	icon = 'icons/effects/ice_wall.dmi'
	icon_state = "ice_cube"
	max_integrity = 120
	break_sound = 'sound/combat/fracture/fracturedry (1).ogg'

/obj/structure/forcefield_weak/ice/Initialize(mapload, mob/summoner)
	. = ..()
	frost_adjacent()

/obj/structure/forcefield_weak/ice/proc/frost_adjacent()
	for(var/mob/living/L in range(1, src))
		if(L == caster)
			continue
		if(L.mob_timers[ICEWALL_FROST_PASS_KEY] == world.time)
			continue
		L.mob_timers[ICEWALL_FROST_PASS_KEY] = world.time
		apply_frost_stack(L)

#undef ICEWALL_FROST_PASS_KEY
