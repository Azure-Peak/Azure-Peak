/datum/crafting_recipe/roguetown/arcana
	req_table = TRUE
	tools = list()
	category = "Arcana"
	abstract_type = /datum/crafting_recipe/roguetown/arcana
	skillcraft = /datum/skill/magic/arcane
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/arcana/amethyst
	name = "amythortz"
	result = /obj/item/roguegem/amethyst
	reqs = list(/obj/item/natural/stone = 1,
				/datum/reagent/medicine/manapot = 15)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/artifact
	name = "runed artifact"
	result = /obj/item/magic/artifact
	reqs = list(/obj/item/natural/rock = 1,
				/datum/reagent/medicine/manapot = 15)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/rawmana
	name = "mana crystal"
	result = /obj/item/magic/manacrystal
	reqs = list(/datum/reagent/medicine/manapot = 25)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/obsidian
	name = "Obsidian Shard"
	result = /obj/item/magic/obsidian
	reqs = list(/obj/item/natural/stone = 2, 
				/obj/item/alch/coaldust = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/chalk
	name = "chalk"
	result = /obj/item/chalk
	reqs = list(/obj/item/rogueore/cinnabar = 1,
				/datum/reagent/medicine/manapot = 15)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/infernalfeather
	name = "infernal feather"
	result = /obj/item/natural/feather/infernal
	reqs = list(/obj/item/natural/feather = 1,
				/obj/item/magic/infernal/ash = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/sendingstone
	name = "sending stones"
	result = /obj/item/sendingstonesummoner
	reqs = list(/obj/item/natural/stone = 2,
				/obj/item/roguegem/amethyst = 2,
				/obj/item/magic/melded/t1 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/voidlamptern
	name = "void lamptern"
	result = /obj/item/flashlight/flare/torch/lantern/voidlamptern
	reqs = list(/obj/item/flashlight/flare/torch/lantern = 1,
				/obj/item/magic/obsidian = 1,
				/obj/item/magic/melded/t1 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/nomagiccollar
	name = "mana binding collar"
	result = /obj/item/clothing/neck/roguetown/collar/leather/nomagic
	reqs = list(/obj/item/clothing/neck/roguetown/collar = 1,
				/obj/item/roguegem = 1,
				/obj/item/magic/melded/t2 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/nomagicglove
	name = "mana binding gloves"
	result = /obj/item/clothing/gloves/roguetown/nomagic
	reqs = list(/obj/item/clothing/gloves/roguetown/leather = 1,
				/obj/item/roguegem = 1,
				/obj/item/magic/melded/t3 = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/temporalhourglass
	name = "temporal hourglass"
	result = /obj/item/hourglass/temporal
	reqs = list(/obj/item/natural/wood/plank = 4,
				/obj/item/magic/leyline = 1,
				/obj/item/magic/melded/t2 = 1)
	craftdiff = 3


/datum/crafting_recipe/roguetown/arcana/shimmeringlens
	name = "shimmering lens"
	result = /obj/item/clothing/ring/active/shimmeringlens
	reqs = list(/obj/item/magic/iridescentscale = 1,
				/obj/item/magic/leyline = 1,
				/obj/item/magic/melded/t2 = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/mimictrinket
	name = "mimic trinket"
	result = /obj/item/mimictrinket
	reqs = list(/obj/item/natural/wood/plank = 2,
				/obj/item/magic/melded/t1 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/binding
	name = "binding shackles"
	result = /obj/item/rope/chain/bindingshackles
	reqs = list(/obj/item/rope/chain = 2,
				/obj/item/magic/melded/t1 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/bindingt2
	name = "binding shackles (T2)"
	result = /obj/item/rope/chain/bindingshackles/t2
	reqs = list(/obj/item/rope/chain/bindingshackles = 1,
				/obj/item/magic/melded/t2 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/bindingt3
	name = "binding shackles (T3)"
	result = /obj/item/rope/chain/bindingshackles/t3
	reqs = list(/obj/item/rope/chain/bindingshackles/t2 = 1,
				/obj/item/magic/melded/t3 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/bindingt4
	name = "binding shackles (T4)"
	result = /obj/item/rope/chain/bindingshackles/t4
	reqs = list(/obj/item/rope/chain/bindingshackles/t3 = 1,
				/obj/item/magic/melded/t4 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/bindingt5
	name = "binding shackles (T5)"
	result = /obj/item/rope/chain/bindingshackles/t5
	reqs = list(/obj/item/rope/chain/bindingshackles/t4 = 1,
				/obj/item/magic/melded/t5 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/forge
	name = "infernal forge"
	req_table = FALSE
	result = /obj/machinery/light/rogue/forge/arcane
	reqs = list(/obj/item/magic/infernal/core = 1,
				/obj/item/natural/stone = 4)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/nullring
	name = "ring of null magic"
	result = /obj/item/clothing/ring/active/nomag
	reqs = list(/obj/item/clothing/ring/gold = 1,
				/obj/item/magic/voidstone = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/arcana/meldt1
	name = "arcanic meld"
	result = /obj/item/magic/melded/t1
	reqs = list(/obj/item/magic/infernal/ash = 1,
				/obj/item/magic/fairydust = 1,
				/obj/item/magic/elemental/mote = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/meldt2
	name = "dense arcanic meld"
	result = /obj/item/magic/melded/t2
	reqs = list(/obj/item/magic/infernal/fang = 1,
				/obj/item/magic/iridescentscale = 1,
				/obj/item/magic/elemental/shard = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/meldt3
	name = "sorcerous weave"
	result = /obj/item/magic/melded/t3
	reqs = list(/obj/item/magic/infernal/core = 1,
				/obj/item/magic/heartwoodcore = 1,
				/obj/item/magic/elemental/fragment = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/meldt4
	name = "magical confluence"
	result = /obj/item/magic/melded/t4
	reqs = list(/obj/item/magic/infernal/flame = 1,
				/obj/item/magic/sylvanessence = 1,
				/obj/item/magic/elemental/relic = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/meldt5
	name = "arcanic abberation"
	result = /obj/item/magic/melded/t5
	reqs = list(/obj/item/magic/melded/t4 = 1,
				/obj/item/magic/voidstone = 1)
	craftdiff = 2

//upward conversions of materials

//fae conversions

/datum/crafting_recipe/roguetown/arcana/fairydust //T1 mage summon loot
	name = "fairy dust)"
	result = /obj/item/magic/fairydust
	reqs = list(/obj/item/magic/manacrystal = 1,
				/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/iridescentscale //T2 mage summon loot
	name = "iridescent scales"
	result = /obj/item/magic/iridescentscale
	reqs = list(/obj/item/magic/fairydust = 2,
				/obj/item/reagent_containers/food/snacks/fish = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/heartwoodcore //T3 mage summon loot
	name = "heartwood core"
	result = /obj/item/magic/heartwoodcore
	reqs = list(/obj/item/magic/iridescentscale = 2,
				/obj/item/grown/log/tree/small = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/arcana/sylvanessence //T4 mage summon loot
	name = "sylvan essence"
	result = /obj/item/magic/sylvanessence
	reqs = list(/obj/item/magic/heartwoodcore = 4,
				/obj/item/roguegem/green= 1)
	craftdiff = 5

//elemenmtal conversions

/datum/crafting_recipe/roguetown/arcana/elementalmote //T1 mage summon loot
	name = "elemental mote" //making this one a little harder as mining will also produce some
	result = /obj/item/magic/elemental/mote
	reqs = list(/obj/item/magic/manacrystal = 1,
				/obj/item/magic/artifact = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/elementalshard //T2 mage summon loot
	name = "elemental shard"
	result = /obj/item/magic/elemental/shard
	reqs = list(/obj/item/magic/elemental/mote = 2,
				/obj/item/rogueore/copper = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/elementalfragment //T3 mage summon loot
	name = "elemental fragment"
	result = /obj/item/magic/elemental/fragment
	reqs = list(/obj/item/magic/elemental/shard = 3,
				/obj/item/rogueore/iron = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/arcana/elementalrelic //T4 mage summon loot
	name = "elemental relic"
	result = /obj/item/magic/elemental/relic
	reqs = list(/obj/item/magic/elemental/fragment = 4,
				/obj/item/roguegem/yellow = 1)
	craftdiff = 5

//infernal conversions
/datum/crafting_recipe/roguetown/arcana/infernalash //T1 mage summon loot
	name = "infernal ash"
	result = /obj/item/magic/infernal/ash
	reqs = list(/obj/item/magic/manacrystal = 1,
				/obj/item/ash = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/hellhoundfang //T2 mage summon loot
	name = "hellhound fang"
	result = /obj/item/magic/infernal/fang
	reqs = list(/obj/item/magic/infernal/ash = 2,
				/obj/item/natural/bone = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/infernalcore //T3 mage summon loot
	name = "infernal core"
	result = /obj/item/magic/infernal/core
	reqs = list(/obj/item/magic/infernal/fang = 3,
				/obj/item/rogueore/coal = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/arcana/abyssalflame //T4 mage summon loot
	name = "abyssal flame"
	result = /obj/item/magic/infernal/flame
	reqs = list(/obj/item/magic/infernal/core = 2,
				/obj/item/roguegem/ruby = 1)
	craftdiff = 5

//conversion material for some hard to find materials that don't have a use
/datum/crafting_recipe/roguetown/arcana/arcynefission1 //gives some T1 and T2 arcane material
	name = "arcyne fission (nature essense)"
	result = list(/obj/item/magic/manacrystal, 
				  /obj/item/magic/manacrystal,
				  /obj/item/magic/manacrystal,
				  /obj/item/magic/infernal/ash,
				  /obj/item/magic/infernal/fang,
				  /obj/item/magic/fairydust,
				  /obj/item/magic/iridescentscale,
				  /obj/item/magic/elemental/mote,
				  /obj/item/magic/elemental/shard)
	reqs = list(/obj/item/natural/cured/essence = 1,
				/datum/reagent/water/salty = 15,
				/obj/item/natural/clay = 2,
				/obj/item/ingot/aaslag = 1,
				/obj/item/rogueore/cinnabar = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/arcynefission2 //gives T1, T2, and T3 arcane material, sorry Tudon
	name = "arcyne fission (lich phylactery)"
	result = list(/obj/item/magic/manacrystal,
				  /obj/item/magic/manacrystal,
				  /obj/item/magic/manacrystal,
				  /obj/item/magic/manacrystal,
				  /obj/item/magic/manacrystal,
				  /obj/item/magic/infernal/ash,
				  /obj/item/magic/infernal/ash,
				  /obj/item/magic/infernal/fang,
				  /obj/item/magic/infernal/fang,
				  /obj/item/magic/infernal/core,
				  /obj/item/magic/fairydust,
				  /obj/item/magic/fairydust,
				  /obj/item/magic/iridescentscale,
				  /obj/item/magic/iridescentscale,
				  /obj/item/magic/heartwoodcore,
				  /obj/item/magic/elemental/mote,
				  /obj/item/magic/elemental/mote,
				  /obj/item/magic/elemental/shard,
				  /obj/item/magic/elemental/shard,
				  /obj/item/magic/elemental/fragment,)
	reqs = list(/obj/item/phylactery = 1,
				/datum/reagent/water/salty = 15,
				/obj/item/natural/clay = 2,
				/obj/item/rogueore/silver= 1,
				/obj/item/rogueore/cinnabar = 1)
	craftdiff = 5

