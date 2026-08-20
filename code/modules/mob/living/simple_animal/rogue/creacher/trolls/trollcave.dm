// Port from Vanderlin with AP code for throwing the rock
/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave
	name = "cave troll"
	desc = "Dwarven tales of giants and trolls often contain these creatures, horrifying amalgamations of flesh and crystal who have long since abandoned Malum's ways."
	icon = 'icons/roguetown/mob/monster/trolls/troll_cave.dmi'
	health = CAVETROLL_HEALTH
	maxHealth = CAVETROLL_HEALTH
	ai_controller = /datum/ai_controller/troll_cave
	head_butcher = /obj/item/natural/head/troll/cave

	defprob = 15

/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave/Initialize(mapload)
	. = ..()
	var/datum/action/cooldown/mob_cooldown/stone_throw/throwstone = new(src)
	throwstone.Grant(src)
	ai_controller.set_blackboard_key(BB_TARGETED_ACTION, throwstone)
