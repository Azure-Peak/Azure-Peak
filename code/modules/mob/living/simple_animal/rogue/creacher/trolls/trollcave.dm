// Port from Vanderlin with AP code for throwing the rock
/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave
	name = "cave troll"
	desc = "Dwarven tales of giants and trolls often contain these creatures, horrifying amalgamations of flesh and crystal who have long since abandoned Malum's ways."
	icon = 'icons/roguetown/mob/monster/trolls/troll_cave.dmi'
	health = CAVETROLL_HEALTH
	maxHealth = CAVETROLL_HEALTH
	ai_controller = /datum/ai_controller/troll_cave
	move_base_delay = MOVEMENT_DELAY_SPD_17
	head_butcher = /obj/item/natural/head/troll/cave


/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave/Initialize(mapload)
	. = ..()
	var/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/hurled_rock/stone_throw/throwstone = new(src)
	throwstone.Grant(src)
