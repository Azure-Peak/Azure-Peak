/mob/living/simple_animal/hostile/rogue/dreamfiend
	icon = 'icons/mob/abyssal_small.dmi'
	desc = "A dizzying sight ripped violently from a distant dream and brought where it never belonged. It folds in on itself in ways impossible, and seems to move without moving."
	name = "minor dream fiend"
	icon_state = "dreamfiend"
	icon_living = "dreamfiend"
	icon_dead = "dreamfiend"

	//Not a crab, but mossbacks respect other creations of Abyssor...
	faction = list("dream", "crabs")
	attack_sound = list('sound/mobs/abyssal/abyssal_attack.ogg','sound/mobs/abyssal/abyssal_attack2.ogg')

	base_intents = list(/datum/intent/simple/bite)

	health = MINOR_DREAMFIEND_HEALTH
	maxHealth = MINOR_DREAMFIEND_HEALTH
	melee_damage_lower = 25
	melee_damage_upper = 40

	AIStatus = AI_OFF
	can_have_ai = FALSE

	ai_controller = /datum/ai_controller/assassin
	melee_cooldown = MINOR_DREAMFIEND_ATTACK_SPEED
	var/next_blink = 0
	var/blink_cooldown = 5 SECONDS
	var/inner_tele_radius = 1
	var/outer_tele_radius = 2
	var/include_dense = FALSE
	var/include_teleport_restricted = FALSE
	var/sound1 = 'sound/mobs/abyssal/abyssal_idle.ogg'
	var/sound2 = 'sound/mobs/abyssal/abyssal_teleport.ogg'
	var/desummon_timer = 8 SECONDS

/mob/living/simple_animal/hostile/rogue/dreamfiend/major
	icon = 'icons/mob/abyssal_medium.dmi'
	name = "major dream fiend"
	pixel_x = -4

	STACON = 15
	STASTR = 15
	STAPER = 15

	health = MAJOR_DREAMFIEND_HEALTH
	maxHealth = MAJOR_DREAMFIEND_HEALTH
	melee_damage_lower = 50
	melee_damage_upper = 90
	melee_cooldown = MAJOR_DREAMFIEND_ATTACK_SPEED
	desummon_timer = 12 SECONDS

	attack_sound = list('sound/mobs/abyssal/abyssal_attack.ogg','sound/mobs/abyssal/abyssal_attack2.ogg')

/mob/living/simple_animal/hostile/rogue/dreamfiend/ancient
	icon = 'icons/mob/abyssal_large.dmi'
	name = "ancient dream fiend"
	desc = "A truly horrifying creature. It makes you dizzy just looking at it."
	pixel_x = -16

	health = ANCIENT_DREAMFIEND_HEALTH
	maxHealth = ANCIENT_DREAMFIEND_HEALTH
	melee_damage_lower = 40
	melee_damage_upper = 120
	base_intents = list(/datum/intent/simple/dreamfiend_ancient)
	melee_cooldown = ANCIENT_DREAMFIEND_ATTACK_SPEED
	desummon_timer = 20 SECONDS

	STACON = 20
	STASTR = 20
	STAPER = 20

	ai_controller = /datum/ai_controller/assassin/ancient
	attack_sound = list('sound/mobs/abyssal/abyssal_attack.ogg','sound/mobs/abyssal/abyssal_attack2.ogg')

/mob/living/simple_animal/hostile/rogue/dreamfiend/get_sound(input)
    switch(input)
        if("aggro")
            return pick('sound/mobs/abyssal/abyssal_aggro.ogg')
        if("pain")
            return pick('sound/mobs/abyssal/abyssal_pain.ogg')
        if("death")
            return pick('sound/mobs/abyssal/abyssal_pain.ogg')
        if("idle")
            return pick('sound/mobs/abyssal/abyssal_idle.ogg')

/mob/living/simple_animal/hostile/rogue/dreamfiend/Initialize()
	AddElement(/datum/element/ai_retaliate)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC) //Dreamfiends fall into the 'eldritch' category. Technically not 'unholy', but certainly monstrous.
	. = ..()

/mob/living/simple_animal/hostile/rogue/dreamfiend/ancient/Initialize()
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFIRE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BASHDOORS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_ORGAN_EATER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NASTY_EATER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOSTINK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	. = ..()

/mob/living/simple_animal/hostile/rogue/dreamfiend/proc/blink_to_target(var/mob/target)
	if(world.time < next_blink || QDELETED(target) || target.stat == DEAD)
		return FALSE

	var/turf/target_turf = get_turf(target)
	var/list/turfs = list()

	for(var/turf/T in range(target,outer_tele_radius))
		if(T in range(target,inner_tele_radius))
			continue
		if(istransparentturf(T))
			continue
		if(T.density && !include_dense)
			continue
		if(T.teleport_restricted && !include_teleport_restricted)
			continue
		if(T.x>world.maxx-outer_tele_radius || T.x<outer_tele_radius)
			continue	//putting them at the edge is dumb
		if(T.y>world.maxy-outer_tele_radius || T.y<outer_tele_radius)
			continue
		turfs += T

	if(!length(turfs))
		for(var/turf/T in orange(target_turf, outer_tele_radius))
			if(!(T in orange(target_turf, inner_tele_radius)))
				turfs += T

	if(!length(turfs))
		return FALSE

	var/turf/tele_turf = pick(turfs)
	playsound(src, sound1, 50, TRUE)
	new /obj/effect/temp_visual/decoy(loc, src)

	if(do_teleport(src, tele_turf, forceMove = TRUE, channel = TELEPORT_CHANNEL_MAGIC))
		playsound(tele_turf, sound2, 50, TRUE)
		next_blink = world.time + blink_cooldown
		return TRUE

	return FALSE

/mob/living/simple_animal/hostile/rogue/dreamfiend/proc/return_to_abyssor()
	src.visible_message(span_notice("The [src] starts to fade out of reality!"))
	if(do_after(src, desummon_timer, FALSE, target = src))
		qdel(src)

/mob/living/simple_animal/hostile/rogue/dreamfiend/death()
	if(prob(5))
		new /obj/item/roguegem/yellow(loc)
	//Was it even real?!
	new /obj/effect/decal/cleanable/dreamfiend_ichor(loc)
	qdel(src)

/mob/living/simple_animal/hostile/rogue/dreamfiend/major/death()
	if(prob(25))
		new /obj/effect/spawner/lootdrop/roguetown/abyssor(loc)
	new /obj/effect/decal/cleanable/dreamfiend_ichor/large(loc)
	var/main_target = ai_controller.blackboard[BB_MAIN_TARGET]
	for(var/i in 1 to 2)
		var/mob/living/simple_animal/hostile/rogue/dreamfiend/F = new(loc)
		F.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, main_target)
		F.ai_controller.set_blackboard_key(BB_MAIN_TARGET, main_target)
	if(main_target)
		src.visible_message(span_notice("some dreamfiends split forth front the body of the [src] following after [main_target]... countless teeth bared with hostility!"))
	qdel(src)

/mob/living/simple_animal/hostile/rogue/dreamfiend/ancient/death()
	if(prob(100))
		if(prob(1))
			new /obj/item/rogueweapon/greataxe/dreamscape/active(loc)
		else
			new /obj/effect/spawner/lootdrop/roguetown/abyssor(loc)
	new /obj/effect/decal/cleanable/dreamfiend_ichor/huge(loc)
	qdel(src)

/obj/effect/decal/cleanable/dreamfiend_ichor
	name = "vile ichor"
	desc = "This dark shifting liquid looks impossibly deep."
	icon = 'icons/mob/abyssal_small.dmi'
	icon_state = "dreamfiend_dead"
	beauty = -100
	alpha = 200
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = NO_CLIENT_COLOR

/obj/effect/decal/cleanable/dreamfiend_ichor/large
	pixel_x = -4
	icon = 'icons/mob/abyssal_medium.dmi'

/obj/effect/decal/cleanable/dreamfiend_ichor/huge
	pixel_x = -16
	icon = 'icons/mob/abyssal_large.dmi'

/datum/intent/simple/dreamfiend_ancient
	name = "devastating bite"
	icon_state = "inchop"
	attack_verb = list("eviscerates", "tears at")
	animname = "cut"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/mobs/abyssal/abyssal_attack.ogg','sound/mobs/abyssal/abyssal_attack2.ogg')
	penfactor = 30

// EVENT mobs and mappable mobs. (USE SPARINGLY)
/mob/living/simple_animal/hostile/rogue/dreamfiend/unbound
	attack_sound = list('sound/mobs/abyssal/abyssal_attack.ogg','sound/mobs/abyssal/abyssal_attack2.ogg')
	ai_controller = /datum/ai_controller/dreamfiend_unbound

/mob/living/simple_animal/hostile/rogue/dreamfiend/major/unbound
	attack_sound = list('sound/mobs/abyssal/abyssal_attack.ogg','sound/mobs/abyssal/abyssal_attack2.ogg')
	ai_controller = /datum/ai_controller/dreamfiend_unbound

/mob/living/simple_animal/hostile/rogue/dreamfiend/major/unbound/death()
	if(prob(25))
		new /obj/effect/spawner/lootdrop/roguetown/abyssor(loc)
	new /obj/effect/decal/cleanable/dreamfiend_ichor/large(loc)
	for(var/i in 1 to 2)
		new /mob/living/simple_animal/hostile/rogue/dreamfiend/unbound(loc)
	src.visible_message(span_notice("Some dreamfiends split forth front the body of the [src]!"))
	qdel(src)

/mob/living/simple_animal/hostile/rogue/dreamfiend/ancient/unbound
	attack_sound = list('sound/mobs/abyssal/abyssal_attack.ogg','sound/mobs/abyssal/abyssal_attack2.ogg')
	ai_controller = /datum/ai_controller/dreamfiend_unbound_ancient
