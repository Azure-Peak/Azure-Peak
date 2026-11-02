/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src,TRAIT_NOFIRE, "[type]")
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SHOCKIMMUNE, TRAIT_GENERIC)
	AddComponent(/datum/component/ai_aggro_system, aggro_range = 9, maintain_range = 9)
	beam = new(src)
	beam.Grant(src)

/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//no wounding the obelisk
	return

/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/Move(newloc)
	if(binded)
		to_chat(src,span_warning("You're currently bound and unable to move!"))
		return
	.=..()

/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/Life()
	..()
	if(pulledby)
		ai_controller?.force_aggro(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "voidstone obelisk"
	desc = "A construct from another age. It is marked by glowing sigils!"
	icon_state = "obelisk-combined"
	icon_living = "obelisk-combined"
	icon_dead = "obelisk-combined"

	faction = list(FACTION_ABBERANT)
	emote_hear = null
	emote_see = null
	ai_controller = /datum/ai_controller/voidstoneobelisk
	move_base_delay = MOVEMENT_DELAY_CRAWLING
	see_in_dark = 9
	movement_type = FLYING
	butcher_results = list()

	health = 750
	maxHealth = 750
	food_type = null

	base_intents = list(/datum/intent/simple/slam)
	attack_sound = list('sound/combat/hits/onstone/wallhit.ogg')
	obj_damage = 75
	melee_damage_lower = 30
	melee_damage_upper = 30
	STAWIL = 20
	STACON = 20
	STASTR = 12
	STASPD = 8

	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	environment_smash = ENVIRONMENT_SMASH_WALLS
	simple_detect_bonus = 60
	deaggroprob = 0
	food = 0
	dodgetime = 17
	aggressive = 1
	var/datum/action/cooldown/spell/obelisk_beam/beam
	summon_primer = "You are ancient. A construct built in an age before men, a time of dragons. Your builders don't seem to be around anymore, and time has past with you in standby. How you respond, is up to you."
	summon_tier = 3

/datum/intent/simple/slam
	name = "slam"
	icon_state = "instrike"
	attack_verb = list("slam", "rams")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = 'sound/combat/hits/onstone/wallhit.ogg'
	chargetime = 0
	penfactor = PEN_LIGHT
	swingdelay = 0
	candodge = TRUE
	canparry = TRUE
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/death(gibbed)
	..()
	var/turf/deathspot = get_turf(src)
	new /obj/item/magic/voidstone(deathspot)
	spill_embedded_objects()
	update_icon()
	spawn(1)
		qdel(src)


/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vobelisk/construct.ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/Destroy()
	QDEL_NULL(beam)
	return ..()

/// Segments of the actual beam, these hurt if you stand in them
/obj/effect/obeliskbeam
	name = "abberant beam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "obeliskbeam_mid"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_color = "#008080"
	light_power = 4
	light_outer_range = 3
	/// Who made us?
	var/datum/weakref/creator

/obj/effect/obeliskbeam/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSfastprocess, src)

/obj/effect/obeliskbeam/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/effect/obeliskbeam/process()
	var/atom/ignore = creator?.resolve()
	for(var/mob/living/hit_mob in get_turf(src))
		if(hit_mob == ignore)
			continue
		damage(hit_mob)

/// Hurt the passed mob
/obj/effect/obeliskbeam/proc/damage(mob/living/hit_mob)
	hit_mob.apply_damage(damage = 15, damagetype = BURN)
	to_chat(hit_mob, span_danger("You're damaged by [src]!"))

/// Ignore damage dealt to this mob
/obj/effect/obeliskbeam/proc/assign_creator(mob/living/maker)
	creator = WEAKREF(maker)

/// Disappear
/obj/effect/obeliskbeam/proc/disperse()
	animate(src, time = 0.5 SECONDS, alpha = 0)
	QDEL_IN(src, 0.5 SECONDS)
