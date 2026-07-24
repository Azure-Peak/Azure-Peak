/obj/item/alch/catalyst
	name = "basic catalyst"
	icon = 'icons/roguetown/items/magic_resources.dmi'
	icon_state ="weave"
	dropshrink = 0.8
	desc = "You should not be seeing this."
	var/list/enabled_recipes	// list of recipe datum paths that the catalyst allows one to craft. initialized automatically
	var/recipe_base_type		// path to a base recipe that the initialize function will populate the above list with subtypes of
	var/obj/item/seed_item		// item used to start creating the catalyst. MUST BE UNIQUE (if there are two catalysts with the same seed item one of them will be uncraftable and do not ask this one which will win)
	var/difficulty = 5			// steps in the process. 5 is default, 4-7 the sane range. any less and it's trivial, any more and it feels unfair

/obj/item/alch/catalyst/Initialize()
	. = ..()
	enabled_recipes = subtypesof(recipe_base_type)
	AddComponent(/datum/component/unsellable, "is an esoteric tool of the alchemical arts")

/obj/item/alch/catalyst/florid
	name = "florid catalyst"
	icon_state = "florid"
	desc = "A small log of some esoteric plant-like material. It peels away like sheafs of paper, bends like flax and yet scratches steel. If you look, you can even see hyphae, exposed to the air."
	recipe_base_type = /datum/transmutation_recipe/florid
	materia = list(/datum/materia_aspect/herb, /datum/materia_aspect/malleability)
	seed_item = /obj/item/natural/fibers
	difficulty = 4

/obj/item/alch/catalyst/terran
	name = "terran catalyst"
	icon_state = "terran"
	desc = "An angry stone that seethes inside. It smells like the earth upturned. Wet dirt, Freshly knapped flint and the stench of sulfur, all at once."
	recipe_base_type = /datum/transmutation_recipe/terran
	materia = list(/datum/materia_aspect/earth, /datum/materia_aspect/malleability)
	seed_item = /obj/item/rogueore/coal
	difficulty = 4

/obj/item/alch/catalyst/aeneic
	name = "aeneic catalyst"
	icon_state = "aeneic"
	desc = "A coin, a flat coin of brass and more, scored along its faces at the perfect angle. Looking too deeply at the crevasses makes your eyes hurt, like there's more to see that keeps moving."
	recipe_base_type = /datum/transmutation_recipe/aeneic
	materia = list(/datum/materia_aspect/metal, /datum/materia_aspect/malleability)
	seed_item = /obj/item/rogueore/iron
	difficulty = 5

/obj/item/alch/catalyst/chrysopoeia
	name = "chrysopoeia catalyst"
	icon_state = "chryso"
	desc = "A perfect trapezoid of glittering gold, warm to the touch and soft like putty. A small flick is all that is needed for it to remember what it was, and return to its ideal shape."
	recipe_base_type = /datum/transmutation_recipe/chrysopoeia
	materia = list(/datum/materia_aspect/solar, /datum/materia_aspect/malleability)
	seed_item = /obj/item/roguecoin/gold
	difficulty = 6

/obj/item/alch/catalyst/argyropoeia // DO NOT ADD A SEED ITEM TO THIS. IT IS SUPPOSED TO BE UNCRAFTABLE.
	name = "argyropoeia catalyst"	// IF I SEE YOU MAKING THIS CRAFTABLE IT MEANS SILVER IS CONSISTENTLY TRANSMUTABLE BY MAGES NOW
	icon_state = "argyro"			// AND YOU ACCEPT THE CONSEQUENCES OF THAT
	desc = "A gemstone of purest silver, banded in Her gold. Noc's greatest mystery, and Otava's biggest secret. It's warm in your hands - and burns at your fingers if they're bare, like you too have some small scorn from this object."
	recipe_base_type = /datum/transmutation_recipe/argyropoeia
	materia = list(/datum/materia_aspect/lunar, /datum/materia_aspect/malleability, /datum/materia_aspect/rubedo) // hey i wonder why this has the paradox slash divine aspect
	difficulty = 7 // (if it _was_ craftable it'd have the highest difficulty)

/obj/item/alch/nigredo_precursor
	name = "blackened materia"
	desc = "The first stage of what was once known as the Great Work, before Her ascension usurped the title: to decompose an object so thoroughly, it resembles raw materia more than anything physical. This 'blackening' - or, in <i>lingua arcana</i>, 'nigredo' - is the foundation of all alchemical decomposition."
	materia = list(/datum/materia_aspect/nigredo)
	gender = PLURAL

/obj/item/alch/catalyst/nigredo
	name = "nigredo catalyst"
	icon_state = "nigredo"
	desc = "A handful of ashy dust that clings together when pressed, like powdered clay, of a sort. It burns your fingers as you touch it - and the stains will not wash out easily."
	recipe_base_type = /datum/transmutation_recipe/nigredo
	seed_item = /obj/item/alch/nigredo_precursor
	difficulty = 5
	materia = list(/datum/materia_aspect/nigredo, /datum/materia_aspect/malleability)

/obj/item/alch/albedo_precursor
	name = "whitened materia"
	desc = "The second stage of what was once known as the Great Work, before Her ascension usurped the title: to purify materia so completely, it ceases to bear any aspect at all. This 'whitening' - or, in <i>lingua arcana</i>, 'albedo' - is the foundation of all alchemical purification."
	materia = list(/datum/materia_aspect/albedo)
	gender = PLURAL

/obj/item/alch/catalyst/albedo
	name = "albedo catalyst"
	icon_state = "albedo"
	desc = "A prismatic gem that radiates with an inner light which swirls, not unlike Lux. The more you look, the deeper it seems to be - and spots will form in your vision if you aren't careful."
	recipe_base_type = /datum/transmutation_recipe/albedo
	seed_item = /obj/item/alch/albedo_precursor
	difficulty = 6
	materia = list(/datum/materia_aspect/albedo, /datum/materia_aspect/malleability)

/obj/item/alch/xanthosis_precursor
	name = "yellowed materia"
	desc = "The third stage of what was once known as the Great Work, before Her ascension usurped the title: to enhance the nature of 'empty' materia, until it takes on a new aspect, created ex nihilo, bearing the nature of <i>prima materia</i> itself. This 'yellowing' - or, in <i>lingua arcana</i>, 'xanthosis' - is the foundation of all alchemical enhancement."
	materia = list(/datum/materia_aspect/xanthosis)
	gender = PLURAL

/obj/item/alch/catalyst/xanthosis
	name = "xanthosis catalyst"
	icon_state = "coalboy"
	desc = "A massive, toper-hued gem that never quite seems to sit still. When struck or even held, it resonates tonally, as if it's composing a song of its own, a Sygnal to the world in crystalline form."
	recipe_base_type = /datum/transmutation_recipe/xanthosis
	seed_item = /obj/item/alch/xanthosis_precursor
	difficulty = 6
	materia = list(/datum/materia_aspect/xanthosis, /datum/materia_aspect/malleability)

/obj/item/alch/rubedo_precursor
	name = "reddened materia"
	desc = "The fourth and final stage of what was once known as the Great Work, before Her ascension usurped the title: to unify the natures of the aspectless 'materia puritas' and the self-aspected 'materia potentia', creating a paradoxical power likened by radical scholars to divinity. This 'reddening' - or, in <i>lingua arcana</i>, 'rubedo' - is the mark of a true alchemist, and the closest a magos has to the power of miracles."
	materia = list(/datum/materia_aspect/rubedo)
	gender = PLURAL

/obj/item/alch/catalyst/rubedo
	name = "rubedo catalyst"
	icon_state = "rubedo"
	desc = "A thick red paste that beats to the metronome of lyfe on its own. Before the modern world had such need of His silver, this paste was the grandest craft of transmutation - a bridge between the material and the divine, through arcyne means."
	recipe_base_type = /datum/transmutation_recipe/rubedo
	seed_item = /obj/item/alch/rubedo_precursor
	difficulty = 7
	materia = list(/datum/materia_aspect/rubedo, /datum/materia_aspect/malleability)
