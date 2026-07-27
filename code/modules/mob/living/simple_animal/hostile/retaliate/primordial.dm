						//PRIMORDIALS//
					//////////////////////
						//////////////

//The idea for Primordials is that they are conjurable companions for arcyne types. They should cost essentia to conjure, and will follow the command minion order spell.
//Three differant types, air water and fire. Potential for unique effects/attacks for all three. Perhaps delineate between speed health and damage.
//Might also be worth looking into a spell to adjust their 'modes' from melee to ranged, or a command for special abilities.

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
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
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

/datum/intent/simple/claw/primordial
	name = "claw"
	icon_state = "instrike"
	attack_verb = list("claws", "pecks")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = PEN_NONE
	candodge = TRUE
	canparry = TRUE
	miss_text = "slash the air"
	item_d_type = "slash"
	clickcd = 12

/mob/living/simple_animal/hostile/retaliate/rogue/primordial
	icon = 'icons/roguetown/mob/monster/primordial.dmi'
	AIStatus = AI_OFF
	can_have_ai = FALSE
	faction = list(FACTION_NEUTRAL)
	var/next_ability_use
	var/ability_cooldown = 20 SECONDS
	var/next_heal_time = 0
	var/datum/weakref/summoner_ref
	var/ability_ready_timer

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/death()
	..()
	spill_embedded_objects()
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/proc/ability(turf/target_location, mob/living/user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/proc/telegraph_turfs(list/turfs, telegraph_type = /obj/effect/temp_visual/trap/primordial, telegraph_time = 1 SECONDS)
	for(var/turf/T in turfs)
		new telegraph_type(T, telegraph_time)

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/proc/mark_ability_used()
	next_ability_use = world.time + ability_cooldown
	if(ability_ready_timer)
		deltimer(ability_ready_timer)
	ability_ready_timer = addtimer(CALLBACK(src, PROC_REF(announce_ability_ready)), ability_cooldown, TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/proc/announce_ability_ready()
	ability_ready_timer = null
	if(stat == DEAD)
		return
	var/mob/living/caster = summoner_ref?.resolve()
	if(QDELETED(caster))
		return
	balloon_alert(caster, "special ready!")
	to_chat(caster, span_notice("[src]'s special is ready."))

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/proc/cardinal_to(turf/target)
	if(!target)
		return dir
	var/dx = target.x - x
	var/dy = target.y - y
	if(!dx && !dy)
		return dir
	if(abs(dx) >= abs(dy))
		return dx > 0 ? EAST : WEST
	return dy > 0 ? NORTH : SOUTH

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/get_pilot_ability()
	return /datum/action/cooldown/spell/primordial_special

/datum/action/cooldown/spell/primordial_special
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	button_icon_state = "primordial_mark"
	name = "Elemental Surge"
	desc = "Unleash your elemental vessel's innate power at a spot within reach - a flame primordial breathes a searing blast, a water primordial floods the ground, an air primordial hurls a gale."
	sound = null
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CONJURATION

	click_to_activate = TRUE
	cast_range = 6
	self_cast_possible = FALSE

	charge_required = FALSE
	primary_resource_type = SPELL_COST_NONE
	cooldown_time = 20 SECONDS
	spell_tier = 3
	point_cost = 0
	spell_impact_intensity = SPELL_IMPACT_NONE
	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/primordial_special/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/rogue/primordial/P = owner
	if(!istype(P))
		return FALSE
	var/turf/T = get_turf(cast_on)
	if(!T)
		return FALSE
	if(world.time < P.next_ability_use)
		P.balloon_alert(P, "not ready yet!")
		return FALSE
	P.ability(T, P)
	return TRUE

/obj/effect/temp_visual/trap/primordial
	randomdir = FALSE
	duration = 1 SECONDS
	alpha = 0

/obj/effect/temp_visual/trap/primordial/Initialize(mapload, telegraph_time)
	if(telegraph_time)
		duration = telegraph_time
	. = ..()
	animate(src, alpha = 255, time = duration)

/obj/effect/temp_visual/trap/primordial/fire
	color = GLOW_COLOR_FIRE
	light_color = GLOW_COLOR_FIRE

/obj/effect/temp_visual/trap/primordial/water
	color = GLOW_COLOR_ICE
	light_color = GLOW_COLOR_ICE

/obj/effect/temp_visual/trap/primordial/air
	color = "#c0e8ff"
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
	health = 525
	maxHealth = 525
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
	next_ability_use
	STACON = 10
	STASTR = 10
	STASPD = 13
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	defprob = 30
	retreat_health = 0
	food = 0
	next_ability_use
	ai_controller = /datum/ai_controller/flame_primordial
	var/blast_damage = 60
	var/blast_push = 2
	var/blast_vulnerable_time = 3 SECONDS
	var/blast_range = 4

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/fire/ability(turf/target_location, mob/living/user)
	if(!target_location)
		return FALSE
	visible_message(span_danger("[src] inhales, heat gathering about its form!"))
	setDir(cardinal_to(target_location))
	var/list/turfs = get_cone_turfs(src, dir, blast_range)
	telegraph_turfs(turfs, /obj/effect/temp_visual/trap/primordial/fire)
	addtimer(CALLBACK(src, PROC_REF(do_fire_blast), turfs), 1 SECONDS)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/fire/proc/do_fire_blast(list/turfs)
	if(QDELETED(src) || stat == DEAD || !length(turfs))
		return
	visible_message(span_danger("[src] belches a searing blast of fire across the ground!"))
	playsound(src, 'sound/magic/fireball.ogg', 80, TRUE)
	var/list/hit = list(src)
	for(var/turf/T in turfs)
		if(T.density)
			continue
		new /obj/effect/temp_visual/dragonfire(T)
		for(var/atom/movable/A in T)
			if(isliving(A))
				continue
			A.fire_act()
		for(var/mob/living/L in T)
			if(L in hit)
				continue
			hit |= L
			scorch_target(L)

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/fire/proc/scorch_target(mob/living/L)
	if(HAS_TRAIT(L, TRAIT_NOFIRE))
		return
	if(L.guard_deflect_spell("the searing blast", FALSE, src))
		return
	var/armor_block = L.run_armor_check(BODY_ZONE_CHEST, "fire", blade_dulling = BCLASS_BURN, damage = blast_damage, flat_integ = TRUE)
	L.apply_damage(blast_damage, BURN, BODY_ZONE_CHEST, armor_block)
	apply_scorch_stack(L, 1)
	L.apply_status_effect(/datum/status_effect/debuff/vulnerable, blast_vulnerable_time)
	if(dir)
		L.safe_throw_at(get_ranged_target_turf(L, dir, blast_push), blast_push, 2, src, force = MOVE_FORCE_STRONG)

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

	health = 650
	maxHealth = 650
	melee_damage_lower = 30
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
	defprob = 20
	retreat_health = 0
	food = 0

	ai_controller = /datum/ai_controller/water_primordial

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/water/ability(turf/target_location, mob/living/user)
	var/turf/center = get_turf(src)
	if(!center)
		return FALSE
	visible_message(span_danger("[src] draws the moisture of the land into a pool!"))
	var/list/turfs = get_flood_turfs(center)
	telegraph_turfs(turfs, /obj/effect/temp_visual/trap/primordial/water)
	addtimer(CALLBACK(src, PROC_REF(do_deluge), turfs), 1 SECONDS)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/water/proc/get_flood_turfs(turf/center)
	var/list/turfs = list()
	if(!center)
		return turfs
	for(var/turf/open/T in range(2, center))
		if(istype(T, /turf/open/water) || T.density)
			continue
		turfs += T
	return turfs

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/water/proc/do_deluge(list/turfs)
	if(QDELETED(src) || stat == DEAD || !length(turfs))
		return
	visible_message(span_danger("[src] releases a surging flood across the ground!"))
	new /obj/effect/deluge(get_turf(src), turfs)

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

/obj/effect/deluge/Initialize(mapload, list/flood_turfs)
	. = ..()
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
		if(T)
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

	health = 450
	maxHealth = 450
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
	defprob = 40
	retreat_health = 0
	food = 0

	ai_controller = /datum/ai_controller/air_primordial
	var/gust_push = 3

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/air/ability(turf/target_location, mob/living/user)
	if(!target_location)
		return FALSE
	visible_message(span_danger("[src] draws a whirl of stormwinds about itself!"))
	var/dir_to_target = cardinal_to(target_location)
	setDir(dir_to_target)
	var/list/wave_rows = get_gust_rows(dir_to_target)
	var/list/telegraph = list()
	for(var/list/row in wave_rows)
		telegraph |= row
	telegraph_turfs(telegraph, /obj/effect/temp_visual/trap/primordial/air)
	addtimer(CALLBACK(src, PROC_REF(do_gust), wave_rows, dir_to_target), 1 SECONDS)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/air/proc/get_gust_rows(dir_to_target)
	var/list/wave_rows = list()
	var/turf/current = get_step(get_turf(src), dir_to_target)
	for(var/i = 1, i <= 3, i++)
		if(!current)
			break
		var/list/row = list()
		row += current
		row += get_step(current, turn(dir_to_target, 90))
		row += get_step(current, turn(dir_to_target, -90))
		wave_rows += list(row)
		current = get_step(current, dir_to_target)
	return wave_rows

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/air/proc/do_gust(list/wave_rows, dir_to_target)
	if(QDELETED(src) || stat == DEAD || !length(wave_rows))
		return
	visible_message(span_danger("[src] exhales a violent gust of wind!"))
	playsound(src, 'sound/weather/rain/wind_6.ogg', 100, TRUE)
	var/list/hit = list(src)
	for(var/list/row in wave_rows)
		gust_row(row, dir_to_target, hit)

/mob/living/simple_animal/hostile/retaliate/rogue/primordial/air/proc/gust_row(list/row, dir_to_target, list/hit)
	if(QDELETED(src) || stat == DEAD)
		return
	for(var/turf/T in row)
		if(!T)
			continue
		new /obj/effect/temp_visual/gust(T, dir_to_target)
		for(var/mob/living/L in T)
			if(L in hit)
				continue
			hit |= L
			if(L.guard_deflect_spell("the gale", FALSE, src))
				continue
			knockback(L, dir_to_target, gust_push)
			L.apply_status_effect(/datum/status_effect/buff/windswept)


/mob/living/simple_animal/hostile/retaliate/rogue/primordial/air/proc/knockback(mob/living/L, dir, distance)
	if(!L || !isturf(L.loc))
		return
	var/turf/target_turf = get_ranged_target_turf(L, dir, distance)
	if(!target_turf)
		return
	L.throw_at(target_turf, 7, 4)

/obj/effect/temp_visual/gust
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
	npc_simple_damage_mult = 1
	arcshot = TRUE

