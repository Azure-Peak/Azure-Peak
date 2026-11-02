/mob/living/simple_animal/hostile/retaliate/rogue/hag_shapeshift
	// Hopefully the type name will make mappers NOT use this.
	// If you're a mapper and you've found your way here, ILU
	icon = 'icons/mob/unique_shapeshifts/hag_shape.dmi'
	name = "True Hag"
	desc = "Godless, ancient, pure evyl. Run."
	icon_state = "hag"
	icon_living = "hag"
	icon_dead = "hag_dead"
	pixel_x = -16
	speak_emote = list("clicks")
	emote_hear = list("clicks.")
	emote_see = list("clacks.")
	gender = MALE
	emote_hear = null
	emote_see = null
	see_in_dark = 10
	base_intents = list(/datum/intent/simple/claw/mossback)
	botched_butcher_results = list (/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 1, /obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 3,
							/obj/item/alch/viscera = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 5,
									/obj/item/alch/viscera = 2)
	faction = list(FACTION_HAG, FACTION_SPIDERS)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = HAG_TRUE_FORM_HEALTH
	maxHealth = HAG_TRUE_FORM_HEALTH
	melee_damage_lower = 25
	melee_damage_upper = 40
	milkies = FALSE
	pooptype = null
	deaggroprob = 0
	del_on_deaggro = 10 SECONDS
	food = 0
	attack_sound = list('sound/combat/wooshes/blunt/wooshhuge (1).ogg','sound/combat/wooshes/blunt/wooshhuge (2).ogg','sound/combat/wooshes/blunt/wooshhuge (3).ogg')
	dodgetime = 0
	aggressive = 1
	STACON = 10
	STAINT = 10
	STALUC = 10
	STAPER = 11
	STASPD = 5
	STASTR = 10
	STAWIL = 10

	ai_controller = null

/mob/living/simple_animal/hostile/retaliate/rogue/hag_shapeshift/Initialize(mapload)
	. = ..()
	name = initial(name)

/mob/living/simple_animal/hostile/retaliate/rogue/hag_shapeshift/death(gibbed)
	var/obj/shapeshift_holder/H = locate() in src
	if(H && H.stored)
		var/mob/living/carbon/human/hum = H.stored
		COOLDOWN_START(hum, hag_transform_lockout, 2 MINUTES)
	return ..()
