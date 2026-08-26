/mob/living/simple_animal/hostile/retaliate/rogue/troll/undead
	threat_point = THREAT_ELITE
	anatomy_type = /datum/anatomy/biped/tough/undead
	// Icon credit openkeep troll, edited by Ketrai for undeath
	icon = 'icons/roguetown/mob/monster/deadites/troll_undead.dmi'
	name = "deadite troll"
	desc = "The toil continues in undeath. Hulking muscles and old wounds cast a long shadow, it looks tortured... And salivating crimson spittle at the opportunity to make you experience the same fate."
	icon_state = "troll"
	icon_living = "troll"
	icon_dead = "troll_dead"
	prone_icon_states = list("troll_downed")
	pixel_x = -16
	health = TROLL_HEALTH_UNDEAD
	maxHealth = TROLL_HEALTH_UNDEAD
	ai_controller = /datum/ai_controller/undead_troll
	move_base_delay = MOVEMENT_DELAY_SPD_3

	head_butcher = /obj/item/natural/head/troll/undead
	// Troll flesh is unnatural and doesn't rot easily
	botched_butcher_results = list (
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll = 2,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll/fried = 1,
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/horn = 1,
		/obj/item/natural/hide = 1)
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll = 2,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll/fried = 2,
		/obj/item/natural/hide = 2,
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/sinew = 4,
		/obj/item/alch/horn = 2,
		/obj/item/alch/viscera = 3,
		)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll = 3,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll/fried = 3,
		/obj/item/natural/hide = 3,
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/sinew = 5,
		/obj/item/alch/horn = 2,
		/obj/item/alch/viscera = 3,
		)

/mob/living/simple_animal/hostile/retaliate/rogue/troll/undead/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/deadite, 15 MINUTES, "troll_downed", 0)
	var/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/hurled_rock/boulder_throw/boulder = new(src)
	boulder.Grant(src)
	var/datum/action/cooldown/spell/troll_shove/shove = new(src)
	shove.Grant(src)

