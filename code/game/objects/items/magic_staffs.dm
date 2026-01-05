#define TOPER_CAST_TIME_REDUCTION 0.1
#define EMERALD_CAST_TIME_REDUCTION 0.15
#define SAPPHIRE_CAST_TIME_REDUCTION 0.2
#define QUARTZ_CAST_TIME_REDUCTION 0.25
#define RUBY_CAST_TIME_REDUCTION 0.3
#define DIAMOND_CAST_TIME_REDUCTION 0.35
#define RIDDLE_OF_STEEL_CAST_TIME_REDUCTION 0.4

//we use discrete staff objs so that they can be easily thrown into loot tables and maps without complex varediting

/obj/item/rogueweapon/woodstaff
	var/cast_time_reduction = null

/obj/item/rogueweapon/woodstaff/examine(mob/user)
	.=..()
	if(cast_time_reduction)
		. += span_notice("This staff has been augmented with a gem, reducing a mage's spell casting time by [cast_time_reduction * 100]% when they hold it in their hand.")
	else
		return

/obj/item/rogueweapon/woodstaff/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/gemstaff/toper_staff,
		/datum/crafting_recipe/gemstaff/amethyst_staff,
		/datum/crafting_recipe/gemstaff/emerald_staff,
		/datum/crafting_recipe/gemstaff/sapphire_staff,
		/datum/crafting_recipe/gemstaff/quartz_staff,
		/datum/crafting_recipe/gemstaff/ruby_staff,
		/datum/crafting_recipe/gemstaff/diamond_staff,
		/datum/crafting_recipe/gemstaff/riddle_of_steel_staff,
		/datum/crafting_recipe/gemstaff/blacksteelstaffupgrade,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/rogueweapon/woodstaff/toper
	name = "toper-focused staff"
	desc = "An amber focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'icons/obj/items/staffs.dmi'
	icon_state = "topazstaff"
	cast_time_reduction = TOPER_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF //imagine the salt
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 34

/obj/item/rogueweapon/woodstaff/amethyst
	name = "amethyst-focused staff"
	desc = "A purple focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'icons/obj/items/staffs.dmi'
	icon_state = "amethyststaff"
	cast_time_reduction = TOPER_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)

/obj/item/rogueweapon/woodstaff/emerald
	name = "gemerald-focused staff"
	desc = "A glistening green focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'icons/obj/items/staffs.dmi'
	icon_state = "emeraldstaff"
	cast_time_reduction = EMERALD_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 42

/obj/item/rogueweapon/woodstaff/emerald/blacksteelstaff
	name = "blacksteel staff"
	desc = "A fine wood staff that is reinforced with blacksteel rivets and furnishings often used by War-Magos that have graduated from the Celestial Academy of Magos. Perched atop it is an less efficient though equally beautiful alchemical Dorpel. Perhaps I could enhance it with a better Dorpel?"
	icon_state = "blacksteelstaff"
	max_integrity = 300 // 100 more integrity than a steel quarterstaff due to it's blacksteel nature. Can't smelt it down though :)

/obj/item/rogueweapon/woodstaff/sapphire
	name = "saffira-focused staff"
	desc = "A beautiful blue focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'icons/obj/items/staffs.dmi'
	icon_state = "sapphirestaff"
	cast_time_reduction = SAPPHIRE_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 56

/obj/item/rogueweapon/woodstaff/quartz
	name = "blortz-focused staff"
	desc = "A crystal-clear focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'icons/obj/items/staffs.dmi'
	icon_state = "quartzstaff"
	cast_time_reduction = QUARTZ_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 88

/obj/item/rogueweapon/woodstaff/ruby
	name = "ronts-focused staff"
	desc = "A sanguine focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'icons/obj/items/staffs.dmi'
	icon_state = "rubystaff"
	cast_time_reduction = RUBY_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 100

/obj/item/rogueweapon/woodstaff/diamond
	name = "dorpel-focused staff"
	desc = "A beautifully faceted focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'icons/obj/items/staffs.dmi'
	icon_state = "diamondstaff"
	cast_time_reduction = DIAMOND_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 121

/obj/item/rogueweapon/woodstaff/diamond/blacksteelstaff // Upgraded version, more CDR can be crafted by combining a base Blacksteel Staff with a dorpel
	name = "refined blacksteel staff"
	desc = "A fine wood staff that is reinforced with blacksteel rivets and furnishings often used by War-Magos that have graduated from the Celestial Academy of Magos. Perched atop it is a new beautiful Dorpel that shimmers with magical energies"
	icon_state = "blacksteelstaff"
	max_integrity = 300 // 100 more integrity than a steel quarterstaff due to it's blacksteel nature. Can't smelt it down though :)

/obj/item/rogueweapon/woodstaff/riddle_of_steel
	name = "\improper Staff of the Riddle-Steel"
	desc = "Flame dances within the focus-gem of this mighty staff at a rhythm and intensity to match the \
	mage that wields it."
	icon = 'icons/obj/items/staffs.dmi'
	icon_state = "riddlestaff"
	cast_time_reduction = RIDDLE_OF_STEEL_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 400

/obj/item/rogueweapon/woodstaff/riddle_of_steel/magos
	name = "\improper Staff of the Court Magos"
	icon_state = "courtstaff"

/obj/item/rogueweapon/woodstaff/naledi
	cast_time_reduction = DIAMOND_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	sellprice = 40

//crafting datums

/datum/crafting_recipe/gemstaff
	abstract_type = /datum/crafting_recipe/gemstaff

/datum/crafting_recipe/gemstaff/toper_staff
	name = "toper-focused staff"
	result = /obj/item/rogueweapon/woodstaff/toper
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/yellow = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/amethyst_staff
	name = "amethyst-focused staff"
	result = /obj/item/rogueweapon/woodstaff/amethyst
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/amethyst = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/emerald_staff
	name = "gemerald-focused staff"
	result = /obj/item/rogueweapon/woodstaff/emerald
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/green = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/sapphire_staff
	name = "saffira-focused staff"
	result = /obj/item/rogueweapon/woodstaff/sapphire
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/violet = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/quartz_staff
	name = "blortz-focused staff"
	result = /obj/item/rogueweapon/woodstaff/quartz
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/blue = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/ruby_staff
	name = "rontz-focused staff"
	result = /obj/item/rogueweapon/woodstaff/ruby
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/ruby = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/diamond_staff
	name = "dorpel-focused staff"
	result = /obj/item/rogueweapon/woodstaff/diamond
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/diamond = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/riddle_of_steel_staff
	name = "Staff of the Riddlesteel"
	result = /obj/item/rogueweapon/woodstaff/riddle_of_steel
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/riddleofsteel = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/blacksteelstaffupgrade
	name = "Refined Blacksteel Staff"
	result = /obj/item/rogueweapon/woodstaff/diamond/blacksteelstaff
	reqs = list(/obj/item/rogueweapon/woodstaff/emerald/blacksteelstaff = 1,
				/obj/item/roguegem/diamond = 1)
	craftdiff = 0


#undef TOPER_CAST_TIME_REDUCTION
#undef EMERALD_CAST_TIME_REDUCTION
#undef SAPPHIRE_CAST_TIME_REDUCTION
#undef QUARTZ_CAST_TIME_REDUCTION
#undef RUBY_CAST_TIME_REDUCTION
#undef DIAMOND_CAST_TIME_REDUCTION
#undef RIDDLE_OF_STEEL_CAST_TIME_REDUCTION
