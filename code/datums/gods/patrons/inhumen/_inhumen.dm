/datum/patron/inhumen
	name = null
	associated_faith = /datum/faith/inhumen
	undead_hater = FALSE
	var/crafting_recipes = list() //Allows construction of unique crosses.
	profane_words = list("cock","dick","fuck","shit","pussy","cuck","cunt","asshole", "pintle")	//Same as master but 'Zizo' is allowed now.
	confess_lines = list(
		"PSYDON IS THE DEMIURGE!",
		"THE TEN ARE WORTHLESS COWARDS!",
		"THE TEN ARE DECEIVERS!",
	)

/datum/patron/inhumen/post_equip(mob/living/pious)
    . = ..()
    if(ishuman(pious))
        var/mob/living/carbon/human/human = pious
        if(human.mind && length(crafting_recipes))
            for(var/recipe_path in crafting_recipes)
                human.mind.teach_crafting_recipe(recipe_path)