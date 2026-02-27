/mob/living/simple_animal/hostile/retaliate/rogue/troll/axe
	name = "troll skull-splitter"
	desc = "This one seems smarter than the rest... And its axe could cut a man in two."
	icon = 'icons/roguetown/mob/monster/trolls/troll_axe.dmi'
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 5,
		/obj/item/natural/hide = 5,
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/sinew = 7,
		/obj/item/alch/horn = 2,
		/obj/item/alch/viscera = 3,
	)
	head_butcher = /obj/item/natural/head/troll/axe
	health = CAVETROLL_HEALTH * 1.1 // More health compared to normal troll
	maxHealth = CAVETROLL_HEALTH
	melee_damage_lower = 55 // More damage compared to the normal troll
	melee_damage_upper = 70
	base_intents = list(/datum/intent/simple/troll_axe)
	attack_sound = list('sound/combat/wooshes/blunt/wooshhuge (1).ogg','sound/combat/wooshes/blunt/wooshhuge (2).ogg','sound/combat/wooshes/blunt/wooshhuge (3).ogg')
	loot = list(/obj/item/rogueweapon/stoneaxe/woodcut/troll)

/datum/intent/simple/troll_axe
	name = "troll axe"
	icon_state = "instrike"
	attack_verb = list("hacks at", "slashes", "chops", "crushes")
	animname = "blank22"
	hitsound = "genchop"
	blade_class = BCLASS_CHOP
	chargetime = 20
	penfactor = 10
	swingdelay = 3
