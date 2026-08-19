/mob/living/simple_animal/hostile/retaliate/rogue/drider //lol
	anatomy_type = /datum/anatomy/spider
	icon = 'icons/roguetown/mob/monster/drider.dmi'
	name = "drider spider"
	desc = "A monstrously large spider utilised by drow as mounts, better suited \
	for the Underdark than any mammmalian mount. Fairly terrifying, but a sight one \
	acclimates to with enough exposure."
	pixel_x = -16
	pixel_y = 7
	faction = list(FACTION_SPIDER_LOWERS)
	threat_point = THREAT_DANGEROUS
	ambush_faction = "underdark"
	blood_toll_bucket = STATS_KILLED_GREATER_BEASTS
	gender = MALE
	icon_state = "drider"
	icon_living = "drider"
	icon_dead = "drider_dead"
	animal_species = null
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 3, /obj/item/natural/bone = 3)
	base_intents = list(/datum/intent/simple/bite/mirespider_lurker)
	health = DRIDER_HEALTH
	maxHealth = DRIDER_HEALTH
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	milkies = FALSE
	melee_damage_lower = 60
	melee_damage_upper = 90
	retreat_distance = 0
	minimum_distance = 0
	retreat_health = 0.3
	STASPD = 18
	STACON = 8
	STASTR = 10
	tame = FALSE
	tame_chance = 25
	bonus_tame_chance = 15
	can_saddle = TRUE
	can_buckle = TRUE
	aggressive = 1
	move_to_delay = 8

/mob/living/simple_animal/hostile/retaliate/rogue/drider/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/drider/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE2, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFIRE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/rogue/drider/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		add_saddleicon("saddle-above", "saddle")
		add_ridericon("drider_mounted")

/mob/living/simple_animal/hostile/retaliate/rogue/drider/tamed()
	..()
	deaggroprob = 20
	setup_mount()

/mob/living/simple_animal/hostile/retaliate/rogue/drider/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/spider/aggro (1).ogg','sound/vo/mobs/spider/aggro (2).ogg','sound/vo/mobs/spider/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/spider/pain.ogg')
		if("death")
			return pick('sound/vo/mobs/spider/death.ogg')
		if("idle")
			return pick('sound/vo/mobs/spider/idle (1).ogg','sound/vo/mobs/spider/idle (2).ogg','sound/vo/mobs/spider/idle (3).ogg','sound/vo/mobs/spider/idle (4).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/drider/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/drider/eat_plants()
	..()
	var/obj/structure/vine/SV = locate(/obj/structure/vine) in loc
	if(SV)
		SV.eat(src)
		food = max(food + 30, 100)

/mob/living/simple_animal/hostile/retaliate/rogue/drider/Life()
	..()
	if(stat == CONSCIOUS)
		if(!pulledby)
			for(var/direction in shuffle(list(1,2,4,8,5,6,9,10)))
				var/step = get_step(src, direction)
				if(step)
					if(locate(/obj/structure/vine) in step || locate(/obj/structure/glowshroom) in step)
						Move(step, get_dir(src, step))
	if(stat != DEAD)
		if(has_buckled_mobs())
			icon_state = "drider_mounted"
			icon_living = "drider_mounted"
		else
			icon_state = "drider"
			icon_living = "drider"

/mob/living/simple_animal/hostile/retaliate/rogue/drider/tame/saddled/Initialize(mapload)
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()
