/mob/living/simple_animal/hostile/retaliate/rogue/elemental/colossus
	anatomy_type = /datum/anatomy/construct/apex
	icon = 'icons/mob/summonable/64x64.dmi'
	name = "earthen colossus"
	desc = "This looks like a truly gigantic - and thereby truly ancient - elemental \
	creature. It stands upon two legs, each as tall as a man; each footstep rings as thunder."
	icon_state = "colossus"
	icon_living = "colossus"
	icon_dead = "vvd"
	summon_primer = "You are an colossus, a massive elemental. Elementals such as yourself are immeasurably old. Now you've been pulled from your home into a new world, that is decidedly less peaceful then your carefully guarded plane. How you react to these events, only time can tell."
	summon_tier = 4
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_base_delay = MOVEMENT_DELAY_CRAWLING
	move_to_delay = 16
	base_intents = list(/datum/intent/simple/elementalt2_unarmed)
	butcher_results = list()
	death_loot = list(/obj/item/magic/elemental/relic = 1)
	faction = list(FACTION_ELEMENTAL)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 2000
	maxHealth = 2000
	threat_point = THREAT_LEGENDARY
	obj_damage = 150
	melee_damage_lower = 40
	melee_damage_upper = 70
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_WALLS
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	simple_detect_bonus = 20
	deaggroprob = 0
	canparry = TRUE
	// defdrain = 10
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0
	food = 0
	attack_sound = 'sound/combat/hits/onstone/wallhit.ogg'
	pixel_x = -32
	dodgetime = 0
	aggressive = 1

	STACON = 20
	STAWIL = 20
	STASTR = 16
	STASPD = 3

	ai_controller = /datum/ai_controller/elemental

	// Capped, or a long fight buries the party in crawlers.
	var/list/spawned_crawlers
	var/max_crawlers = 3

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/colossus/Initialize(mapload)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	. = ..()
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	var/datum/action/cooldown/spell/telegraphed_strike/mob_ability/elemental_slam/stomp/stomp = new(src)
	stomp.Grant(src)
	var/datum/action/cooldown/spell/projectile/earthen_chunk/chunk = new(src)
	chunk.Grant(src)

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/colossus/death(gibbed)
	..()
	update_icon()
	spill_embedded_objects()
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/colossus/proc/live_crawler_count()
	var/list/still_up = list()
	for(var/datum/weakref/ref as anything in spawned_crawlers)
		var/mob/living/crawler = ref.resolve()
		if(QDELETED(crawler) || crawler.stat == DEAD)
			continue
		still_up += ref
	spawned_crawlers = length(still_up) ? still_up : null
	return length(still_up)

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/colossus/proc/shed_crawlers(turf/where, count = 3)
	if(!where)
		return
	var/room = max_crawlers - live_crawler_count()
	if(room <= 0)
		return
	var/list/turflist = list()
	for(var/turf/open/candidate in RANGE_TURFS(1, where))
		if(candidate.is_blocked_turf())
			continue
		turflist += candidate
	if(!length(turflist))
		return
	for(var/i in 1 to min(count, room))
		var/mob/living/spawned = new /mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler(pick(turflist))
		spawned.faction = faction.Copy()
		LAZYADD(spawned_crawlers, WEAKREF(spawned))

/obj/projectile/earthenchunk
	name = "elemental chunk"
	icon_state = "rock"
	damage = 30
	damage_type = BRUTE
	flag = "fire"
	range = 10
	speed = 16 //higher is slower
	// Needed so the split counts against the thrower's cap instead of being free.
	var/datum/weakref/thrower
	var/split_chance = 20

/obj/projectile/earthenchunk/on_hit(target)
	. = ..()
	if(!prob(split_chance))
		return
	var/mob/living/simple_animal/hostile/retaliate/rogue/elemental/colossus/parent = thrower?.resolve()
	if(QDELETED(parent))
		return
	var/turf/where = get_turf(src)
	if(!where)
		return
	visible_message(span_notice("[src] breaks apart, scattering minor elementals about!"))
	parent.shed_crawlers(where)
