////////////////SUMMONING RITUALS///////////////////
/datum/runeritual/summoning
	name = "summoning ritual parent"
	desc = "summoning parent rituals."
	category = "Summoning"
	blacklisted = TRUE

/datum/runeritual/summoning/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return summon_ritual_mob(user, loc, mob_to_summon)

/datum/runeritual/summoning/proc/summon_ritual_mob(mob/living/user, turf/loc, mob/living/mob_to_summon)
	var/mob/living/simple_animal/summoned
	if(isliving(mob_to_summon))
		summoned = mob_to_summon
	else
		summoned = new mob_to_summon(loc)
		ADD_TRAIT(summoned, TRAIT_PACIFISM, TRAIT_GENERIC)	//can't kill while planar bound.
		summoned.status_flags += GODMODE//It's not meant to be killable until released from it's planar binding.
		summoned.candodge = FALSE
		animate(summoned, color = "#ff0000",time = 5)
		summoned.move_resist = MOVE_FORCE_EXTREMELY_STRONG
		summoned.binded = TRUE
		summoned.SetParalyzed(900)
		return summoned

/datum/runeritual/summoning/imp
	name = "T1 - lesser infernal"
	desc = "summons an infernal imp"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/ash = 2, /obj/item/magic/obsidian = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp

/datum/runeritual/summoning/hellhound
	name = "T2 - hellhound"
	desc = "summons a hellhound"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/magic/infernal/ash = 3, /obj/item/magic/obsidian = 2, /obj/item/magic/melded/t1 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound

/datum/runeritual/summoning/watcher
	name = "T3 - infernal watcher"
	desc = "summons an infernal watcher"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/magic/infernal/fang = 2, /obj/item/magic/obsidian = 2, /obj/item/magic/melded/t2 =1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/rogue/infernal/watcher

/datum/runeritual/summoning/archfiend
	name = "T4 - fiend"
	desc = "summons an fiend"
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/magic/infernal/core = 1, /obj/item/magic/obsidian = 3, /obj/item/magic/melded/t3 =1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend

/datum/runeritual/summoning/sprite
	name = "T1 - sprite"
	desc = "summons an fae sprite"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/reagent_containers/food/snacks/grown/manabloom = 1, /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite

/datum/runeritual/summoning/glimmer
	name = "T2 - glimmerwing"
	desc = "summons an fae spirit"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/reagent_containers/food/snacks/grown/manabloom = 2, /obj/item/magic/fae/fairydust = 3, /obj/item/magic/melded/t1 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing

/datum/runeritual/summoning/dryad
	name = "T3 - dryad"
	desc = "summons an drayd"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/reagent_containers/food/snacks/grown/manabloom = 2, /obj/item/magic/fae/iridescentscale = 2, /obj/item/magic/melded/t2 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad

/datum/runeritual/summoning/sylph
	name = "T4 - sylph"
	desc = "summons an archfae"
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/reagent_containers/food/snacks/grown/manabloom = 1, /obj/item/magic/fae/heartwoodcore = 1, /obj/item/magic/melded/t3 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph

/datum/runeritual/summoning/crawler
	name = "T1 - elemental crawler"
	desc = "summons a minor elemental"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/natural/stone = 2, /obj/item/magic/manacrystal = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler

/datum/runeritual/summoning/warden
	name = "T2 - elemental warden"
	desc = "summons an elemental"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/magic/elemental/mote = 3, /obj/item/magic/manacrystal = 2, /obj/item/magic/melded/t1 = 1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden

/datum/runeritual/summoning/behemoth
	name = "T3 - elemental behemoth"
	desc = "summons a large elemental"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/magic/elemental/shard = 2, /obj/item/magic/manacrystal = 2, /obj/item/magic/melded/t2 =1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth

/datum/runeritual/summoning/collossus
	name = "T4 - elemental colossus"
	desc = "summons an huge elemental"
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/magic/elemental/fragment = 1, /obj/item/magic/manacrystal = 1, /obj/item/magic/melded/t3 =1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/rogue/elemental/colossus

/datum/runeritual/summoning/abberant
	name = "T4 - abberant from the void"
	desc = "summons a long forgotten creature"
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/magic/melded/t5 =1)
	mob_to_summon = /mob/living/simple_animal/hostile/retaliate/rogue/voiddragon

