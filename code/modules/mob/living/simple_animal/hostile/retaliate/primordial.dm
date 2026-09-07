						//PRIMORDIALS//
					//////////////////////
						//////////////

//The idea for Primordials is that they are conjurable companions for arcyne types. They should cost essentia to conjure, and will follow the command minion order spell.
//Three differant types, air water and fire. Potential for unique effects/attacks for all three. Perhaps delineate between speed health and damage.

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/Initialize(mapload, mob/user)
	if(user)
		summoner_ref = WEAKREF(user)
		if(user.mind && user.mind.current)
			summoner = user.mind.current.real_name
		else
			summoner = user.name
	// adds the name of the summoner to the faction, to avoid the hooded "Unknown" bug with Skeleton IDs
	if(user && user.mind && user.mind.current)
		faction = list("[user.mind.current.real_name]_faction")
	apply_fellowship_faction(user, src)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFIRE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BASHDOORS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOSTINK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	if(special_ability)
		var/datum/action/cooldown/spell/special = new special_ability(src)
		special.Grant(src)

/datum/intent/simple/claw/primordial
	name = "claw"
	icon_state = "instrike"
	attack_verb = list("claws", "pecks")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = PEN_NONE
	candodge = TRUE
	canparry = TRUE
	miss_text = "claws at nothing"
	item_d_type = "slash"
	clickcd = 12

/mob/living/simple_animal/hostile/retaliate/rogue/primordial
	anatomy_type = /datum/anatomy/construct/primordial
	icon = 'icons/roguetown/mob/monster/primordial.dmi'
	AIStatus = AI_OFF
	can_have_ai = FALSE
	faction = list(FACTION_NEUTRAL)
	var/next_heal_time = 0
	var/datum/weakref/summoner_ref
	var/special_ability

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/death()
	..()
	spill_embedded_objects()
	qdel(src)

/obj/effect/temp_visual/telegraph/primordial
	duration = 1 SECONDS
	fade_in = TRUE

/obj/effect/temp_visual/telegraph/primordial/fire
	light_color = GLOW_COLOR_FIRE

/obj/effect/temp_visual/telegraph/primordial/water
	light_color = GLOW_COLOR_ICE

/obj/effect/temp_visual/telegraph/primordial/air
	light_color = "#c0e8ff"

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/fire
	name = "flame primordial"
	desc = "Billowing heat strikes your face and threatens to singe your eyebrows! \
	It may be wise not to touch it."
	icon_state = "primordial_fire"
	icon_living = "primordial_fire"
	icon_dead = ""
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = null
	emote_see = null
	turns_per_move = 6
	see_in_dark = 10
	move_to_delay = 3

	base_intents = list(/datum/intent/simple/claw/primordial)
	health = 550
	maxHealth = 550
	melee_damage_lower = 30
	melee_damage_upper = 40
	vision_range = 10
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	ranged = 1
	ranged_cooldown_time = 4 SECONDS
	projectiletype = /obj/projectile/magic/spitfire/primordial
	projectilesound = 'sound/magic/whiteflame.ogg'
	STACON = 10
	STASTR = 10
	STASPD = 13
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	retreat_health = 0
	food = 0
	ai_controller = /datum/ai_controller/primordial
	move_base_delay = MOVEMENT_DELAY_SPD_17
	special_ability = /datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/primordial/flame

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/water
	name = "water primordial"
	desc = "A torrential flood, magically animated and bound to service. It seems \
	to draw moisture from the ground it traverses."
	icon_state = "primordial_water"
	icon_living = "primordial_water"
	icon_dead = ""
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 6
	see_in_dark = 10
	move_to_delay = 3

	attack_sound = list('sound/misc/undertow.ogg')

	base_intents = list(/datum/intent/simple/claw/primordial)

	health = 800
	maxHealth = 800
	melee_damage_lower = 25
	melee_damage_upper = 35
	vision_range = 10
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	ranged = 1
	ranged_cooldown_time = 4 SECONDS
	projectiletype = /obj/projectile/magic/frost_shard/primordial
	projectilesound = 'sound/spellbooks/icicle.ogg'

	STACON = 10
	STASTR = 10
	STASPD = 8
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	retreat_health = 0
	food = 0

	ai_controller = /datum/ai_controller/primordial
	move_base_delay = MOVEMENT_DELAY_SPD_10
	special_ability = /datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/primordial/deluge

/obj/effect/deluge
	name = "floodwaters"
	desc = "A surging flood churns across the ground."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = ""
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/list/turf_data = list()
	var/duration = 15 SECONDS
	var/flood_turf = /turf/open/water

/obj/effect/deluge/Initialize(mapload, list/flood_turfs, flood_duration)
	. = ..()
	if(flood_duration)
		duration = flood_duration
	for(var/turf/open/T in flood_turfs)
		if(istype(T, /turf/open/water) || T.density)
			continue
		turf_data[T] = T.type
		T.ChangeTurf(flood_turf, flags = CHANGETURF_IGNORE_AIR)
	if(!length(turf_data))
		return INITIALIZE_HINT_QDEL
	QDEL_IN(src, duration)

/obj/effect/deluge/Destroy()
	for(var/turf/T as anything in turf_data)
		if(!istype(T, flood_turf))
			continue
		T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/air
	name = "air primordial"
	desc = "Storm-winds whip at the air wherever this creature travels! \
	It is scarcely even easy to keep one's footing while close."
	icon_state = "primordial_air"
	icon_living = "primordial_air"
	icon_dead = ""
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 2
	see_in_dark = 10
	move_to_delay = 3

	attack_sound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')

	base_intents = list(/datum/intent/simple/claw/primordial)

	health = 400
	maxHealth = 400
	melee_damage_lower = 35
	melee_damage_upper = 45
	vision_range = 10
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	ranged = 1
	ranged_cooldown_time = 4 SECONDS
	projectiletype = /obj/projectile/magic/greater_arcyne_bolt/primordial
	projectilesound = 'sound/magic/vlightning.ogg'

	STACON = 10
	STASTR = 10
	STASPD = 13
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	retreat_health = 0
	food = 0

	ai_controller = /datum/ai_controller/primordial
	move_base_delay = MOVEMENT_DELAY_SPD_23
	special_ability = /datum/action/cooldown/spell/telegraphed_strike/dragons_breath/mob_ability/primordial/gale

/obj/effect/temp_visual/dir_setting/gust
	icon = 'icons/effects/effects.dmi'
	icon_state = "kick"
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	duration = 8

/datum/status_effect/buff/windswept
	id = "windswept"
	alert_type = /atom/movable/screen/alert/status_effect/buff/windswept
	duration = 4 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/buff/windswept
	name = "Windswept"
	desc = "Battering winds throw off my footing - I can't keep pace."
	icon_state = "debuff"

/datum/status_effect/buff/windswept/on_apply()
	. = ..()
	owner.add_movespeed_modifier(MOVESPEED_ID_WINDSWEPT, update = TRUE, priority = 100, multiplicative_slowdown = 1.5, movetypes = GROUND)

/datum/status_effect/buff/windswept/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_WINDSWEPT, TRUE)
	. = ..()

/obj/projectile/magic/spitfire/primordial
	name = "primordial flame"
	damage = 20
	arcshot = TRUE

/obj/projectile/magic/frost_shard/primordial
	name = "primordial frost shard"
	damage = 18
	reduced_damage = 5
	arcshot = TRUE

/obj/projectile/magic/greater_arcyne_bolt/primordial
	name = "primordial gale"
	damage = 27
	arcshot = TRUE
