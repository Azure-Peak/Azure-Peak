// Staff recipes - arcana crafting, multiple gems map to same tier
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

/datum/crafting_recipe/roguetown/arcana/staff/greater_emerald
	name = "greater staff (gemerald)"
	result = /obj/item/rogueweapon/woodstaff/implement/greater
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/green = 1)

/datum/crafting_recipe/roguetown/arcana/staff/greater_sapphire
	name = "greater staff (saffira)"
	result = /obj/item/rogueweapon/woodstaff/implement/greater/sapphire
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/violet = 1)

/datum/crafting_recipe/roguetown/arcana/staff/greater_quartz
	name = "greater staff (blortz)"
	result = /obj/item/rogueweapon/woodstaff/implement/greater/quartz
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/blue = 1)

/datum/crafting_recipe/roguetown/arcana/staff/greater_ruby
	name = "greater staff (rontz)"
	result = /obj/item/rogueweapon/woodstaff/implement/greater/ruby
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/ruby = 1)

/datum/crafting_recipe/roguetown/arcana/staff/grand_diamond
	name = "grand staff (dorpel)"
	result = /obj/item/rogueweapon/woodstaff/implement/grand
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/diamond = 1)

/datum/crafting_recipe/roguetown/arcana/staff/grand_riddle
	name = "grand staff (riddle of steel)"
	result = /obj/item/rogueweapon/woodstaff/implement/grand/riddle
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/riddleofsteel = 1)

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

/datum/crafting_recipe/roguetown/arcana/tome/greater_emerald
	name = "greater tome (gemerald)"
	result = /obj/item/rogueweapon/spellbook/greater
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/green = 1)

/datum/crafting_recipe/roguetown/arcana/tome/greater_sapphire
	name = "greater tome (saffira)"
	result = /obj/item/rogueweapon/spellbook/greater
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/violet = 1)

/datum/crafting_recipe/roguetown/arcana/tome/greater_quartz
	name = "greater tome (blortz)"
	result = /obj/item/rogueweapon/spellbook/greater
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/blue = 1)

/datum/crafting_recipe/roguetown/arcana/tome/greater_ruby
	name = "greater tome (rontz)"
	result = /obj/item/rogueweapon/spellbook/greater
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/ruby = 1)

/datum/crafting_recipe/roguetown/arcana/tome/grand_diamond
	name = "grand tome (dorpel)"
	result = /obj/item/rogueweapon/spellbook/grand
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/diamond = 1)

/datum/crafting_recipe/roguetown/arcana/tome/grand_riddle
	name = "grand tome (riddle of steel)"
	result = /obj/item/rogueweapon/spellbook/grand
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/riddleofsteel = 1)

// Blacksteel staff upgrade - the alchemical frame reaches grand output from a cheaper gem
/datum/crafting_recipe/roguetown/arcana/blacksteel_upgrade
	name = "upgrade blacksteel staff (gemerald)"
	result = /obj/item/rogueweapon/woodstaff/implement/grand/blacksteel
	reqs = list(/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel = 1,
				/obj/item/roguegem/green = 1)
