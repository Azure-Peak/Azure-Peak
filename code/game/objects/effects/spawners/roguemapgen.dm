/obj/effect/spawner/roguemap/Initialize(mapload)
	..()
	do_spawn()
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/roguemap/proc/do_spawn()
	if(prob(probby))
		var/obj/new_type = pick(spawned)
		new new_type(get_turf(src))

/obj/effect/spawner/roguemap
	icon = 'icons/obj/structures_spawners.dmi'
	var/probby = 100
	var/list/spawned

/obj/effect/spawner/roguemap/pit
	icon_state = "pit"

/obj/effect/spawner/roguemap/pit/process()
	var/turf/T = get_turf(src)
	var/turf/below = get_step_multiz(src, DOWN)
	if(below)
		T.ChangeTurf(/turf/open/transparent/openspace)
		below.ChangeTurf(/turf/open/floor/rogue/dirt/road)

	STOP_PROCESSING(SSmapgen, src)
	qdel(src)


/obj/effect/spawner/roguemap/tree
	icon_state = "tree"
	name = "Tree spawner"
	probby = 80
	spawned = list(/obj/structure/flora/roguetree)

/obj/effect/spawner/roguemap/treeorbush
	icon_state = "Treeorbush"
	name = "Tree or bush spawner"
	probby = 50
	spawned = list(/obj/structure/flora/roguetree, /obj/structure/flora/roguegrass/bush)

/obj/effect/spawner/roguemap/treeorstump
	icon_state = "treeorstump"
	name = "Tree or stump spawner"
	probby = 50
	spawned = list(/obj/structure/flora/roguetree, /obj/structure/flora/roguetree/stump)

/obj/effect/spawner/roguemap/stump
	icon_state = "stump"
	name = "stump spawner"
	probby = 75
	spawned = list(/obj/structure/flora/roguetree/stump)

/obj/effect/spawner/roguemap/shroud
	icon_state = "shroud"
	name = "shroud sp"
	probby = 30
	spawned = list(/turf/closed/wall/shroud)

/obj/effect/spawner/roguemap/hauntpile
	icon_state = "hauntpile"
	name = "hauntpile"
	probby = 23
	spawned = list(/obj/structure/bonepile)

/obj/effect/spawner/roguemap/beartrap
	icon_state = "beartrap"
	name = "beartrap"
	probby = 50
	spawned = list(/obj/item/restraints/legcuffs/beartrap/armed/camouflage)

// Potions n shit

/obj/effect/spawner/lootdrop/potion_vitals
	icon_state = "lootpotion"
	lootcount = 1
	loot_value = LOOT_VALUE_POTION_VITALS
	junk_loot = list(/obj/item/reagent_containers/glass/bottle/claybottle = 5, /obj/item/ash = 3)
	loot = list(
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 5,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/manapot = 10,
		/obj/item/reagent_containers/glass/bottle/rogue/strongmanapot = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/stampot = 10,
		/obj/item/reagent_containers/glass/bottle/rogue/strongstampot = 1
	)

/obj/effect/spawner/lootdrop/potion_poisons
	icon_state = "lootpoison"
	lootcount = 1
	loot_value = LOOT_VALUE_POTION_POISONS
	junk_loot = list(/obj/item/reagent_containers/glass/bottle/claybottle = 5, /obj/item/ash = 3)
	loot = list(
		/obj/item/reagent_containers/glass/bottle/rogue/berrypoison = 10,
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 5,
		/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/stampoison = 10,
		/obj/item/reagent_containers/glass/bottle/rogue/strongstampoison = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/stampot = 10,
		/obj/item/reagent_containers/glass/bottle/rogue/strongstampot = 1
	)

/obj/effect/spawner/lootdrop/potion_ingredient
	icon_state = "lootpotioning"
	loot_value = LOOT_VALUE_POTION_INGREDIENT
	var/static/list/all_potion_ings = list()
	loot = list()

/obj/effect/spawner/lootdrop/potion_ingredient/Initialize(mapload)
	if(!all_potion_ings.len)
		all_potion_ings = subtypesof(/obj/item/alch)
	if(!loot.len)
		loot = all_potion_ings.Copy()
	return ..()

/obj/effect/spawner/lootdrop/potion_ingredient/herb
	icon_state = "lootpotionherb"
	lootcount = 2
	loot = list(
		/obj/item/alch/atropa = 5,
		/obj/item/alch/matricaria = 5,
		/obj/item/alch/symphitum = 5,
		/obj/item/alch/taraxacum = 5,
		/obj/item/alch/euphrasia = 5,
		/obj/item/alch/paris = 5,
		/obj/item/alch/calendula = 5,
		/obj/item/alch/mentha = 5,
		/obj/item/alch/urtica = 5,
		/obj/item/alch/salvia = 5,
		/obj/item/alch/hypericum = 5,
		/obj/item/alch/benedictus = 5,
		/obj/item/alch/valeriana = 5,
		/obj/item/alch/artemisia = 5,
		/obj/item/alch/rosa = 5
	)
/obj/effect/spawner/lootdrop/potion_stats
	icon_state = "lootstatpot"
	lootcount = 1
	loot_value = LOOT_VALUE_POTION_STATS
	junk_loot = list(/obj/item/reagent_containers/glass/bottle/claybottle = 5, /obj/item/ash = 3)
	loot = list(
		/obj/item/reagent_containers/glass/bottle/alchemical/strpot = 10,
		/obj/item/reagent_containers/glass/bottle/alchemical/perpot = 10,
		/obj/item/reagent_containers/glass/bottle/alchemical/endpot = 10,
		/obj/item/reagent_containers/glass/bottle/alchemical/conpot = 10,
		/obj/item/reagent_containers/glass/bottle/alchemical/intpot = 10,
		/obj/item/reagent_containers/glass/bottle/alchemical/spdpot = 10,
		/obj/item/reagent_containers/glass/bottle/alchemical/lucpot = 10
	)
