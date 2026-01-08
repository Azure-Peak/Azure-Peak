/mob/living/simple_animal/hostile/retaliate/bat
	name = "bat"
	desc = ""
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	turns_per_move = 1
	response_help_continuous = "brushes aside"
	response_help_simple = "brush aside"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	maxHealth = 50
	health = 50
	see_in_dark = 10
	harm_intent_damage = 6
	melee_damage_lower = 6
	melee_damage_upper = 5
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1)
	pass_flags = PASSTABLE
	faction = list("hostile")
	attack_sound = 'sound/blank.ogg'
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	ventcrawler = VENTCRAWLER_ALWAYS
	mob_size = MOB_SIZE_TINY
	movement_type = FLYING
	speak_emote = list("squeaks")
	base_intents = list(/datum/intent/bite)
	sight = (SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_SELF)
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE

	var/fly_time = 5 //5 ticks because vampire bats are agile

	var/max_co2 = 0 //to be removed once metastation map no longer use those for Sgt Araneus
	var/min_oxy = 0
	var/max_tox = 0


	//Space bats need no air to fly in.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0

/mob/living/simple_animal/hostile/retaliate/bat/Initialize()
	. = ..()
	verbs += list(/mob/living/simple_animal/hostile/retaliate/bat/proc/fly_up,
	/mob/living/simple_animal/hostile/retaliate/bat/proc/fly_down) 

/mob/living/simple_animal/hostile/retaliate/bat/proc/fly_up()
	set category = "Winged Form"
	set name = "Fly Up"

	if(src.pulledby != null)
		to_chat(src, span_notice("I can't fly away while being grabbed!"))
		return
	src.visible_message(span_notice("[src] begins to ascend!"), span_notice("You take flight..."))
	if(do_after(src, fly_time, target))
		if(src.pulledby == null)
			src.zMove(UP, TRUE)
			to_chat(src, span_notice("I fly up."))
		else
			to_chat(src, span_notice("I can't fly away while being grabbed!"))

/mob/living/simple_animal/hostile/retaliate/bat/proc/fly_down()
	set category = "Winged Form"
	set name = "Fly Down"

	if(src.pulledby != null)
		to_chat(src, span_notice("I can't fly away while being grabbed!"))
		return
	src.visible_message(span_notice("[src] begins to descend!"), span_notice("You take flight..."))
	if(do_after(src, fly_time, target))
		if(src.pulledby == null)
			src.zMove(DOWN, TRUE)
			to_chat(src, span_notice("I fly down."))
		else
			to_chat(src, span_notice("I can't fly away while being grabbed!"))

/mob/living/simple_animal/hostile/retaliate/bat/crow
	name = "zad"
	desc = ""
	icon = 'icons/roguetown/mob/monster/crow.dmi'
	icon_state = "crow_flying"
	icon_living = "crow_flying"
	icon_dead = "crow1"
	icon_gib = "crow1"
	speak_emote = list("caws")
	base_intents = list(/datum/intent/unarmed/help)
	harm_intent_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	remains_type = /obj/effect/decal/remains/crow
	fly_time = 3 SECONDS // slowing down crow for witches
	sight = 0

/obj/effect/decal/remains/crow
	name = "zad remains"
	desc = "Nevermore..."
	gender = PLURAL
	icon_state = "crow1"
	icon = 'icons/roguetown/mob/monster/crow.dmi'
