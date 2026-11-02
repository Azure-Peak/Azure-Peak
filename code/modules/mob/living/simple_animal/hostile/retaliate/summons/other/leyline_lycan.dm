/mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan/Initialize(mapload, obj/structure/portal)
	. = ..()
	source = portal
	AddComponent(/datum/component/ai_aggro_system)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "Leyline Lycan"
	desc = "A creature made of leyline energy. It is highly territorial and guards its home leyline jealously."
	icon_state = "leycreature"
	icon_living = "leycreature"
	icon_dead = "leycreature"

	faction = list(FACTION_LEYLINE)
	emote_hear = null
	emote_see = null
	see_in_dark = 9
	ai_controller = /datum/ai_controller/leyline_lycan

	butcher_results = list()
	death_loot = list(/obj/item/magic/leyline = 1)

	health = 240
	maxHealth = 240
	food_type = list()

	base_intents = list(/datum/intent/simple/bite)
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	melee_damage_lower = 20
	melee_damage_upper = 30

	STACON = 7
	STASTR = 8
	STASPD = 15

	food = 0
	dodgetime = 30
	var/teleport_cooldown
	var/obj/structure/leyline/source

/mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//No wounding the lycan.
	return

/mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan/death(gibbed)
	..()
	if(source)
		source.guardian = null
	spill_embedded_objects()
	update_icon()
	qdel(src)

/obj/effect/temp_visual/lycan
	icon = 'icons/effects/effects.dmi'
	icon_state = "rift"
	duration = 3

/mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan/proc/leyline_teleport(target)
	teleport_cooldown = world.time + 70
	var/turf/turf_target = get_step(get_turf(target), get_dir(target, src))
	if(!isopenturf(turf_target) || !(turf_target in view(12, src)))
		return
	var/turf/source = get_turf(src)
	new /obj/effect/temp_visual/lycan(turf_target, src)
	new /obj/effect/temp_visual/lycan(source, src)
	playsound(source,'sound/misc/portalactivate.ogg', 200, 1)
	addtimer(CALLBACK(src, PROC_REF(leyline_teleport_2), turf_target, source), 0.2 SECONDS)

/mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan/proc/leyline_teleport_2(turf/T, turf/source)
	animate(src, alpha = 0, time = 2, easing = EASE_OUT) //fade out
	visible_message(span_warning("[src] dives into a leyline rift!"))
	addtimer(CALLBACK(src, PROC_REF(leyline_teleport_3), T), 0.2 SECONDS)

/mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan/proc/leyline_teleport_3(turf/T)
	forceMove(T)
	animate(src, alpha = 255, time = 2, easing = EASE_IN) //fade IN
	visible_message(span_warning("[src] tears its way out of the leyline rift!"))
