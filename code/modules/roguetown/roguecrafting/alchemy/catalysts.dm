/obj/item/alch/catalyst
	name = "basic catalyst"
	icon = 'icons/roguetown/items/magic_resources.dmi'
	icon_state ="weave"
	desc = "You should not be seeing this."
	var/list/enabled_recipes	// list of recipe datum paths that the catalyst allows one to craft. initialized automatically
	var/recipe_base_type		// path to a base recipe that the initialize function will populate the above list with subtypes of

/obj/item/alch/catalyst/Initialize()
	. = ..()
	enabled_recipes = subtypesof(recipe_base_type)

/datum/catalyst_recipe
	var/name = "basic catalyst"			// should be the same as the catalyst name
	var/catalyst = /obj/item/alch/catalyst	// catalyst to create
	var/seed_item						// item used to start creating the catalyst. MUST BE UNIQUE
	var/difficulty = 5					// steps in the process. 5 is default, 4-7 the sane range. any less and it's trivial, any more and it feels unfair
	var/list/correct_steps				// don't touch this one it's randomized on roundstart

/obj/item/alch/catalyst/florid
	name = "florid catalyst"
	//icon_state = "florid"
	desc = "A small log of some esoteric plant-like material. It peels away like sheafs of paper, bends like flax and yet scratches steel. If you look, you can even see hyphae, exposed to the air."
	recipe_base_type = /datum/transmutation_recipe/florid

/obj/item/alch/catalyst/terran
	name = "terran catalyst"
	//icon_state = "terran"
	desc = "An angry stone that seethes inside. It smells like the earth upturned. Wet dirt, Freshly knapped flint and the stench of sulfur, all at once."
	recipe_base_type = /datum/transmutation_recipe/terran

/obj/item/alch/catalyst/aeneic
	name = "aeneic catalyst"
	//icon_state = "aeneic"
	desc = "A coin, a flat coin of brass and more, scored along its faces at the perfect angle. Looking too deeply at the crevasses makes your eyes hurt, like there's more to see that keeps moving."
	recipe_base_type = /datum/transmutation_recipe/aeneic

/obj/item/alch/catalyst/chrysopoeic
	name = "chrysopoeic catalyst"
	//icon_state = "chrysopoeic"
	desc = "A perfect trapezoid of glittering gold, warm to the touch and soft like putty. A small flick is all that is needed for it to remember what it was, and return to its ideal shape."
	recipe_base_type = /datum/transmutation_recipe/chrysopoeia

/obj/item/alch/catalyst/argyopoeic
	name = "argyopoeic catalyst"
	//icon_state = "argyopoeic"
	desc = "A gemstone of purest silver, banded in Her gold. Noc's greatest mystery, and Otava's biggest secret. It's warm in your hands - and burns at your fingers if they're bare, like you too have some small scorn from this object."
	recipe_base_type = /datum/transmutation_recipe/argyopoeia

/obj/item/alch/catalyst/nigredo
	name = "nigredo catalyst"
	//icon_state = "nigredo"
	desc = "A handful of ashy dust that clings together when pressed, like powdered clay, of a sort. It burns your fingers as you touch it - and the stains will not wash out easily."
	recipe_base_type = /datum/transmutation_recipe/nigredo

/obj/item/alch/catalyst/albedo
	name = "albedo catalyst"
	//icon_state = "albedo"
	desc = "A prismatic gem that radiates with an inner light that swirls, not unlike Lux. The more you look, the deeper it seems to be - and spots will form in your vision if you aren't careful."
	recipe_base_type = /datum/transmutation_recipe/albedo

/obj/item/alch/catalyst/xanthosis
	name = "xanthosis catalyst"
	//icon_state = "xanthosis"
	desc = "A massive, toper-hued gem that never seems to really sit still. When struck or even held, it resonates tonally, as if it's composing a song of its own, a Sygnal to the world in crystalline form."
	recipe_base_type = /datum/transmutation_recipe/xanthosis

/obj/item/alch/catalyst/rubedo
	name = "rubedo catalyst"
	//icon_state = "rubedo"
	desc = "A thick red paste that beats to the metronome of lyfe on it's own. Before the modern world had such need of His silver, this paste was the grandest craft of transmutation - a bridge between the material and the divine, through arcyne means."
	recipe_base_type = /datum/transmutation_recipe/rubedo
