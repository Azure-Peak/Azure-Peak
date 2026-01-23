GLOBAL_LIST_INIT(ambush_encounters, init_ambush_encounters())

/proc/init_ambush_encounters()
    var/list/L = list()

	// --- Trash Tier ---

	// Revenant Human (Weak)
    var/datum/ambush_entry/mob/human_weak = new
    human_weak.mob_type = /mob/living/simple_animal/hostile/retaliate/rogue/revenant
    human_weak.unlock_score = 5
    human_weak.point_cost = 5
    human_weak.weight = 5
    L += human_weak

    // --- Low Tier ---

    // Mire Crawler (Cheap, swarmable)
    var/datum/ambush_entry/mob/crawler = new
    crawler.mob_type = /mob/living/simple_animal/hostile/retaliate/rogue/revenant/mirespider
    crawler.unlock_score = 10
    crawler.point_cost = 10
    crawler.weight = 20
    L += crawler

    // Revenant Human (Standard)
    var/datum/ambush_entry/mob/human = new
    human.mob_type = /mob/living/simple_animal/hostile/retaliate/rogue/revenant
    human.unlock_score = 15
    human.point_cost = 15
    human.weight = 20
    L += human

    // --- Mid Tier ---

    // Volf Revenant
    var/datum/ambush_entry/mob/wolf = new
    wolf.mob_type = /mob/living/simple_animal/hostile/retaliate/rogue/revenant/wolf
    wolf.unlock_score = 25
    wolf.point_cost = 25
    wolf.weight = 15
    L += wolf

    // Group: The Hunting Pack (2 Volves + 1 Human)
    var/datum/ambush_entry/group/pack = new
    pack.mob_types = list(
        /mob/living/simple_animal/hostile/retaliate/rogue/revenant/wolf,
        /mob/living/simple_animal/hostile/retaliate/rogue/revenant/wolf,
        /mob/living/simple_animal/hostile/retaliate/rogue/revenant
    )
    pack.unlock_score = 50
    pack.point_cost = 50
    pack.weight = 10
    L += pack

    // --- High Tier ---

    // Mire Lurker Revenant
    var/datum/ambush_entry/mob/lurker = new
    lurker.mob_type = /mob/living/simple_animal/hostile/retaliate/rogue/revenant/mirespider_lurker
    lurker.unlock_score = 40
    lurker.point_cost = 40
    lurker.weight = 10
    L += lurker

    // Group: Spider Swarm (1 Lurker + 3 Crawlers)
    var/datum/ambush_entry/group/swarm = new
    swarm.mob_types = list(
        /mob/living/simple_animal/hostile/retaliate/rogue/revenant/mirespider_lurker,
        /mob/living/simple_animal/hostile/retaliate/rogue/revenant/mirespider,
        /mob/living/simple_animal/hostile/retaliate/rogue/revenant/mirespider,
        /mob/living/simple_animal/hostile/retaliate/rogue/revenant/mirespider
    )
    swarm.unlock_score = 65
    swarm.point_cost = 65
    swarm.weight = 8
    L += swarm

    // --- Boss Tier ---

    // The Dragon (Cannot Repeat)
    var/datum/ambush_entry/mob/dragon = new
    dragon.mob_type = /mob/living/simple_animal/hostile/retaliate/rogue/revenant/dragon
    dragon.unlock_score = 150 // Requires a large group or very long exposure
    dragon.point_cost = 150
    dragon.weight = 20
    dragon.can_repeat = FALSE
    L += dragon

    return L

// --- Base Datum ---

/datum/ambush_entry
    var/unlock_score = 0
    var/point_cost = 0 // Used for cooldown calculation
    var/weight = 10
    var/can_repeat = TRUE

/datum/ambush_entry/proc/spawn_at(turf/T)
    return list()

// --- Single Mob Type ---

/datum/ambush_entry/mob
    var/mob_type

/datum/ambush_entry/mob/spawn_at(turf/T)
    if(!mob_type) return list()
    var/mob/M = new mob_type(T)
    return list(M)

// --- Group Type ---

/datum/ambush_entry/group
    var/list/mob_types = list()

/datum/ambush_entry/group/spawn_at(turf/T)
    var/list/spawned = list()
    for(var/path in mob_types)
        // Scatter slightly so they don't stack perfectly
        var/turf/spawn_loc = T
        if(prob(50))
            spawn_loc = get_step(T, pick(NORTH, NORTHEAST, NORTHWEST, EAST, WEST, SOUTH, SOUTHEAST, SOUTHWEST))
        if(spawn_loc.is_blocked_turf())
            spawn_loc = T
            
        spawned += new path(spawn_loc)
    return spawned
