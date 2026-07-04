/mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead
	name = "deadite saiga"
	desc = "A deadite saiga, its eyes glow with an eerie light."
	icon = 'icons/roguetown/mob/monster/deadites/saiga_undead.dmi'
	icon_state = "saiga"
	icon_living = "saiga"
	icon_dead = "saiga_dead"

	base_intents = list(/datum/intent/simple/headbutt/saiga)

	health = SAIGA_HEALTH_UNDEAD
	maxHealth = SAIGA_HEALTH_UNDEAD
	dodgetime = 100
	melee_damage_lower = 60
	melee_damage_upper = 90
	aggressive = 1
	retreat_health = 0
	retreat_distance = 0
	minimum_distance = 0
	tame_chance = 0
	bonus_tame_chance = 0
	can_buckle = TRUE
	can_saddle = TRUE

	attack_sound = list('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
	pixel_x = -8

	head_butcher = /obj/item/natural/head/saiga/undead
	botched_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z = 1,
		/obj/item/natural/bone = 4,
		/obj/item/alch/sinew = 1,
	)
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z = 2,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_z = 0,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_z = 0,
		/obj/item/natural/bone = 6,
		/obj/item/alch/sinew = 1,
		/obj/item/alch/bone = 2,
		/obj/item/alch/viscera = 1
	)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z = 2,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_z = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_z = 1,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		/obj/item/natural/bone = 6,
		/obj/item/alch/sinew = 1,
		/obj/item/alch/bone = 2,
		/obj/item/alch/viscera = 1
	)
	ai_controller = /datum/ai_controller/undead
	AIStatus = AI_OFF
	can_have_ai = FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead/Initialize()
	. = ..()
	AddComponent(/datum/component/deadite)
