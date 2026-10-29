/obj/item/udder
	name = "udder"
	var/in_use // so you can't spam milking sounds

/obj/item/udder/Initialize(mapload)
	create_reagents(100)
	reagents.add_reagent(/datum/reagent/consumable/milk, rand(0,20))
	. = ..()

/obj/item/udder/proc/generateMilk()
	reagents.add_reagent(/datum/reagent/consumable/milk, 1)

/obj/item/udder/proc/milkAnimal(obj/O, mob/user)
	var/obj/item/reagent_containers/glass/G = O
	if(in_use)
		return
	if(G.reagents.total_volume >= G.volume)
		to_chat(user, span_warning("[O] is full."))
		return
	if(!reagents.has_reagent(/datum/reagent/consumable/milk, 5))
		to_chat(user, "<span class='warning'>The udder is dry. Wait a bit longer...</span>")
		return
	beingmilked()
	playsound(O, pick('modular/Creechers/sound/milking1.ogg', 'modular/Creechers/sound/milking2.ogg'), 100, TRUE, -1)
	if(do_after(user, 20, target = src))
		reagents.trans_to(O, rand(5,10))
		user.visible_message("<span class='notice'>[user] milks [src] using \the [O].</span>", "<span class='notice'>I milk [src] using \the [O].</span>")

/obj/item/udder/proc/beingmilked()
	in_use = TRUE
	sleep(20)
	in_use = FALSE

//grenchensnacker

/mob/living/simple_animal/grenchensnacker
	name = "grenchensnacker"
	desc = "Why is it smiling like that"
	icon_state = "grenchen"
	icon_living = "grenchen"
	icon_dead = "grenchen_dead"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak = list("GRA","AH!","HEEHEHE")
	speak_emote = list("squeeks")
	emote_hear = list("chops.")
	emote_see = list("dances.", "stares.")
	speak_chance = 1
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/generic/critter
	see_in_dark = 6
	butcher_results = list(/obj/item/roguekey/porta = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	attack_sound = 'sound/blank.ogg'
	health = 100
	maxHealth = 100
	gold_core_spawnable = FRIENDLY_SPAWN
	blood_volume = BLOOD_VOLUME_NORMAL
	food_type = list(/obj/item/rogueore/gold, /obj/item/rogueore/silver)
	tame_chance = 25
	bonus_tame_chance = 15
	footstep_type = FOOTSTEP_MOB_SHOE
