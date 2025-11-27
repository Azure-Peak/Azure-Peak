//Cat
/mob/living/simple_animal/pet/cat
	name = "cat"
	desc = "A nuisance and a valued, pest-killing companion. Also symbols of the benevolent side of Saint Pestra for their enmity with vermin."
	icon = 'icons/mob/pets.dmi'
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	gender = MALE
	speak = list("Meow!", "Esp!", "Purr!", "HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows.", "mews.")
	emote_see = list("shakes its head.", "shivers.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	density = FALSE // moveblocking cat is annoying as hell
	pass_flags = PASSMOB
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = 200
	maxbodytemp = 400
	unsuitable_atmos_damage = 1
	animal_species = /mob/living/simple_animal/pet/cat
	childtype = list(/mob/living/simple_animal/pet/cat/kitten)
	butcher_results = list(
					/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
					/obj/item/organ/ears/cat = 1,
					/obj/item/organ/tail/cat = 1,
					)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	STASTR = 3
	STAWIL = 4
	STASPD = 3
	STACON = 3
	var/turns_since_scan = 0
	gold_core_spawnable = FRIENDLY_SPAWN

	footstep_type = FOOTSTEP_MOB_CLAW

	//new ai, old ai off
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/generic

/mob/living/simple_animal/pet/cat/Initialize()
	. = ..()
	verbs += /mob/living/proc/lay_down

/mob/living/simple_animal/pet/cat/update_mobility()
	..()
	if(client && stat != DEAD)
		if (resting)
			icon_state = "[icon_living]_rest"
		else
			icon_state = "[icon_living]"
	regenerate_icons()


/mob/living/simple_animal/pet/cat/Crossed(mob/living/L) // Gato Basado - makes it leave when people step too close
	. = ..()
	if(L)
		if(health > 1)
			icon_state = "[icon_living]"
			set_resting(FALSE)
			update_mobility()
			if(isturf(loc))
				dir = pick(GLOB.cardinals)
				step(src, dir)
			if(!stat && resting && !buckled)
				return

/mob/living/simple_animal/proc/personal_space()
	if(locate(/mob/living/carbon) in get_turf(src))
		sleep(1)
		dir = pick(GLOB.alldirs)
		step(src, dir)
		personal_space()
	else
		return

/mob/living/simple_animal/pet/cat/rogue/inn
	name = "inn cat"
	desc = "This old, fat cat keeps the inn free of rats... allegedly. It seems like he mostly lazes about in the sun and asks for treats."
	health = 5000
	maxHealth = 5000

/mob/living/simple_animal/pet/cat/rogue/black
	name = "black cat"
	desc = "Possessed of lamplike eyes and a meow that sounds like the rattle of bones. Black cats are sacred to Necra, said to bring wandering spirits to the Carriageman."
	gender = FEMALE
	icon = 'icons/roguetown/topadd/takyon/Cat.dmi'
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"

/mob/living/simple_animal/pet/cat/rogue/black/academy
    name = "Kalathrax the All Knowing"
    desc = "Whispers around the Academy say that this cat was once an Associate that decided they had achieved enough knowledge to challenge the Court Wizard for their role and failed. (Or maybe it's just a cat)"
    STAINT = 20
    health = 5000
    maxHealth = 5000

/mob/living/simple_animal/pet/cat/original
	name = "Batsy"
	desc = ""
	gender = FEMALE
	icon_state = "original"
	icon_living = "original"
	icon_dead = "original_dead"
	unique_pet = TRUE

/mob/living/simple_animal/pet/cat/kitten
	name = "kitten"
	desc = ""
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	density = FALSE
	pass_flags = PASSMOB
	mob_size = MOB_SIZE_SMALL

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/pet/cat/Runtime
	name = "Runtime"
	desc = ""
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	gender = FEMALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
	var/list/family = list()//var restored from savefile, has count of each child type
	var/list/children = list()//Actual mob instances of children
	var/cats_deployed = 0
	var/memory_saved = FALSE

/mob/living/simple_animal/pet/cat/Runtime/Initialize()
	if(prob(5))
		icon_state = "original"
		icon_living = "original"
		icon_dead = "original_dead"
	Read_Memory()
	. = ..()

/mob/living/simple_animal/pet/cat/Runtime/Life()
	if(!cats_deployed && SSticker.current_state >= GAME_STATE_SETTING_UP)
		Deploy_The_Cats()
	if(!stat && SSticker.current_state == GAME_STATE_FINISHED && !memory_saved)
		Write_Memory()
		memory_saved = TRUE
	..()

/mob/living/simple_animal/pet/cat/Runtime/make_babies()
	var/mob/baby = ..()
	if(baby)
		children += baby
		return baby

/mob/living/simple_animal/pet/cat/Runtime/death()
	if(!memory_saved)
		Write_Memory(TRUE)
	..()

/mob/living/simple_animal/pet/cat/Runtime/proc/Read_Memory()
	if(fexists("data/npc_saves/Runtime.sav")) //legacy compatability to convert old format to new
		var/savefile/S = new /savefile("data/npc_saves/Runtime.sav")
		S["family"] >> family
		fdel("data/npc_saves/Runtime.sav")
	else
		var/json_file = file("data/npc_saves/Runtime.json")
		if(!fexists(json_file))
			return
		var/list/json = json_decode(file2text(json_file))
		family = json["family"]
	if(isnull(family))
		family = list()

/mob/living/simple_animal/pet/cat/Runtime/proc/Write_Memory(dead)
	var/json_file = file("data/npc_saves/Runtime.json")
	var/list/file_data = list()
	family = list()
	if(!dead)
		for(var/mob/living/simple_animal/pet/cat/kitten/C in children)
			if(istype(C,type) || C.stat || !C.z || (C.flags_1 & HOLOGRAM_1))
				continue
			if(C.type in family)
				family[C.type] += 1
			else
				family[C.type] = 1
	file_data["family"] = family
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/mob/living/simple_animal/pet/cat/Runtime/proc/Deploy_The_Cats()
	cats_deployed = 1
	for(var/cat_type in family)
		if(family[cat_type] > 0)
			for(var/i in 1 to min(family[cat_type],100)) //Limits to about 500 cats, you wouldn't think this would be needed (BUT IT IS)
				new cat_type(loc)

/mob/living/simple_animal/pet/cat/Proc
	name = "Proc"
	gender = MALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE

/mob/living/simple_animal/pet/cat/Life()
	if(!stat && !buckled && !client)
		if(prob(1))
			emote("me", 1, pick("stretches out for a belly rub.", "wags its tail.", "lies down."))
			icon_state = "[icon_living]_rest"
			set_resting(TRUE)
		else if (prob(1))
			emote("me", 1, pick("sits down.", "crouches on its hind legs.", "looks alert."))
			icon_state = "[icon_living]_sit"
			set_resting(TRUE)
		else if (prob(2))
			if (resting)
				emote("me", 1, pick("gets up and meows.", "walks around.", "stops resting."))
				icon_state = "[icon_living]"
				set_resting(FALSE)
			else
				emote("me", 1, pick("grooms its fur.", "twitches its whiskers.", "shakes out its coat."))

		else if (prob(1))
			playsound(src, pick(
							'sound/vo/mobs/cat/cat_meow1.ogg',
							'sound/vo/mobs/cat/cat_meow2.ogg',
							'sound/vo/mobs/cat/cat_meow3.ogg',
							'sound/vo/mobs/cat/cat_purr1.ogg',
							'sound/vo/mobs/cat/cat_purr2.ogg',
							'sound/vo/mobs/cat/cat_purr3.ogg',
							'sound/vo/mobs/cat/cat_purr4.ogg',
							), 100, TRUE)

	..()

	make_babies()

// Life proc inherent to roguecats only
/mob/living/simple_animal/pet/cat/rogue/Life()
	..()
	// Gato Basado - catches RT rats too when not too lazy
	if((src.loc) && isturf(src.loc))
		if(!resting && !buckled && stat != DEAD)
			for(var/obj/item/reagent_containers/food/snacks/smallrat/M in view(1,src))
				if(Adjacent(M))
					if(!M.dead)
						walk_towards(src, M, 1)
						sleep(3)
						visible_message("<span class='notice'>\The [src] kills the rat!</span>")
						M.obj_destruction()
						stop_automated_movement = 0
						break





/mob/living/simple_animal/pet/cat/rogue/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if( (isdarkelf(M)) ) // l´cursed bonbonbon
		wuv(-1, M)
	else
		switch(M.used_intent.type)
			if(INTENT_HELP)
				wuv(1, M)
			if(INTENT_HARM)
				wuv(-1, M)


/mob/living/simple_animal/pet/cat/proc/wuv(change, mob/M)
	if(change)
		if(change > 0)
			if(M && stat != DEAD)
				new /obj/effect/temp_visual/heart(loc)
				emote("me", 1, "purrs!")
				if(flags_1 & HOLOGRAM_1)
					return
		else
			if(M && stat != DEAD)
				emote("me", 1, "hisses!")

/mob/living/simple_animal/pet/cat/inn/attack_hand(mob/living/carbon/human/M) // Gato Basado - not all pets are welcome
	. = ..()
	if((isdarkelf(M)))  // l´cursed bonbonbon
		visible_message("<span class='notice'>The cat hisses at [M] and recoils in disgust.</span>")
		icon_state = "[icon_living]"
		set_resting(FALSE)
		update_mobility()
		playsound(get_turf(src), 'modular/Creechers/sound/cathiss.ogg', 80, TRUE, -1)
		dir = pick(GLOB.alldirs)
		step(src, dir)
		personal_space()

	if(M.mind && M.mind.has_antag_datum(/datum/antagonist/vampire))
		visible_message("<span class='notice'>The cat hisses at [M] and recoils in disgust.</span>")
		icon_state = "[icon_living]"
		set_resting(FALSE)
		update_mobility()
		playsound(get_turf(src), 'modular/Creechers/sound/cathiss.ogg', 80, TRUE, -1)
		dir = pick(GLOB.alldirs)
		step(src, dir)
		personal_space()
