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
	result = /obj/item/rogueweapon/woodstaff/implement
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/amethyst = 1)

/datum/crafting_recipe/roguetown/arcana/staff/greater_emerald
	name = "greater staff (gemerald)"
	result = /obj/item/rogueweapon/woodstaff/implement/greater
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/green = 1)

/datum/crafting_recipe/roguetown/arcana/staff/greater_sapphire
	name = "greater staff (saffira)"
	result = /obj/item/rogueweapon/woodstaff/implement/greater
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/violet = 1)

/datum/crafting_recipe/roguetown/arcana/staff/greater_quartz
	name = "greater staff (blortz)"
	result = /obj/item/rogueweapon/woodstaff/implement/greater
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/blue = 1)

/datum/crafting_recipe/roguetown/arcana/staff/greater_ruby
	name = "greater staff (rontz)"
	result = /obj/item/rogueweapon/woodstaff/implement/greater
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/ruby = 1)

/datum/crafting_recipe/roguetown/arcana/staff/grand_diamond
	name = "grand staff (dorpel)"
	result = /obj/item/rogueweapon/woodstaff/implement/grand
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/diamond = 1)

/datum/crafting_recipe/roguetown/arcana/staff/grand_riddle
	name = "grand staff (riddle of steel)"
	result = /obj/item/rogueweapon/woodstaff/implement/grand
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/riddleofsteel = 1)

// Wand recipes - arcana crafting, small log + gem
/datum/crafting_recipe/roguetown/arcana/wand
	abstract_type = /datum/crafting_recipe/roguetown/arcana/wand

/datum/crafting_recipe/roguetown/arcana/wand/lesser_toper
	name = "lesser wand (toper)"
	result = /obj/item/rogueweapon/wand
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/yellow = 1)

/datum/crafting_recipe/roguetown/arcana/wand/lesser_amethyst
	name = "lesser wand (amethyst)"
	result = /obj/item/rogueweapon/wand
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/amethyst = 1)

/datum/crafting_recipe/roguetown/arcana/wand/greater_emerald
	name = "greater wand (gemerald)"
	result = /obj/item/rogueweapon/wand/greater
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/green = 1)

/datum/crafting_recipe/roguetown/arcana/wand/greater_sapphire
	name = "greater wand (saffira)"
	result = /obj/item/rogueweapon/wand/greater
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/violet = 1)

/datum/crafting_recipe/roguetown/arcana/wand/greater_quartz
	name = "greater wand (blortz)"
	result = /obj/item/rogueweapon/wand/greater
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/blue = 1)

/datum/crafting_recipe/roguetown/arcana/wand/greater_ruby
	name = "greater wand (rontz)"
	result = /obj/item/rogueweapon/wand/greater
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/ruby = 1)

/datum/crafting_recipe/roguetown/arcana/wand/grand_diamond
	name = "grand wand (dorpel)"
	result = /obj/item/rogueweapon/wand/grand
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/diamond = 1)

/datum/crafting_recipe/roguetown/arcana/wand/grand_riddle
	name = "grand wand (riddle of steel)"
	result = /obj/item/rogueweapon/wand/grand
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/riddleofsteel = 1)

// Blacksteel staff upgrade - special recipe
/datum/crafting_recipe/roguetown/arcana/blacksteel_upgrade
	name = "upgrade blacksteel staff (dorpel)"
	result = /obj/item/rogueweapon/woodstaff/implement/grand/blacksteel
	reqs = list(/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel = 1,
				/obj/item/roguegem/diamond = 1)
