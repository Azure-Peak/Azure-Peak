// Staff recipes - arcana crafting
/datum/crafting_recipe/roguetown/arcana/staff
	abstract_type = /datum/crafting_recipe/roguetown/arcana/staff

/datum/crafting_recipe/roguetown/arcana/staff/lesser_toper
	name = "lesser staff (toper)"
	result = /obj/item/rogueweapon/woodstaff/implement
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/yellow = 1)

/datum/crafting_recipe/roguetown/arcana/staff/lesser_amethyst
	name = "lesser staff (amethyst)"
	result = /obj/item/rogueweapon/woodstaff/implement/amethyst
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/amethyst = 1)

// Tome recipes - arcana crafting, small log + gem
/datum/crafting_recipe/roguetown/arcana/tome
	abstract_type = /datum/crafting_recipe/roguetown/arcana/tome

/datum/crafting_recipe/roguetown/arcana/tome/lesser_toper
	name = "lesser tome (toper)"
	result = /obj/item/rogueweapon/spellbook
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/yellow = 1)

/datum/crafting_recipe/roguetown/arcana/tome/lesser_amethyst
	name = "lesser tome (amethyst)"
	result = /obj/item/rogueweapon/spellbook
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/amethyst = 1)
