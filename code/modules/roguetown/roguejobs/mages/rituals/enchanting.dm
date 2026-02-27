////////////////ENCHANTING RITUALS///////////////////
/datum/runeritual/enchanting
	name = "Enchanting"
	desc = "Parent enchanting."
	category = "Enchanting"
	abstract_type = /datum/runeritual/enchanting
	blacklisted = TRUE

/datum/runeritual/enchanting/woodcut
	name = "Woodcutting"
	desc = "Good for cutting wood."
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1, /obj/item/magic/manacrystal = 1)
	result_atoms = list(/obj/item/enchantmentscroll/woodcut)

/datum/runeritual/enchanting/mining
	name = "Mining"
	desc = "Good for mining rock."
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1, /obj/item/magic/artifact = 1)
	result_atoms = list(/obj/item/enchantmentscroll/mining)

/datum/runeritual/enchanting/xylix
	name = "Xylix's Grace"
	desc = "How fortunate!"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1, /obj/item/magic/leyline = 1)
	result_atoms = list(/obj/item/enchantmentscroll/xylix)

/datum/runeritual/enchanting/light
	name = "Unyielding Light"
	desc = "Provides light!"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/mote = 2)
	result_atoms = list(/obj/item/enchantmentscroll/light)

/datum/runeritual/enchanting/holding
	name = "Compact Storing"
	desc = "Makes things hold more!"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/infernal/ash = 2, /obj/item/magic/fae/fairydust = 2)
	result_atoms = list(/obj/item/enchantmentscroll/holding)

/datum/runeritual/enchanting/revealing
	name = "Revealing Light"
	desc = "Doubles brightness!"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1, /obj/item/magic/fae/fairydust = 2)
	result_atoms = list(/obj/item/enchantmentscroll/revealing)

//T2 Below here


/datum/runeritual/enchanting/nightvision
	name = "Dark Vision"
	desc = "Provides dark sight!"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/fae/iridescentscale = 1, /obj/item/magic/manacrystal = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/nightvision)

/datum/runeritual/enchanting/unbreaking
	name = "Unbreaking"
	desc = "Provides extra integrity!"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/artifact = 1, /obj/item/magic/elemental/shard = 1, /obj/item/magic/manacrystal = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/unbreaking)

/datum/runeritual/enchanting/featherstep
	name = "Feather Step"
	desc = "Makes your step lighter and speedier!"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/fae/iridescentscale = 1, /obj/item/magic/fae/fairydust = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/featherstep)

/datum/runeritual/enchanting/fireresist
	name = "Fire Resistance"
	desc = "Provides resistance from fire!"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/infernal/fang = 1, /obj/item/magic/infernal/ash = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/fireresist)

/datum/runeritual/enchanting/climbing
	name = "Spider movements"
	desc = "Better climbing!"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/shard = 1, /obj/item/magic/infernal/ash = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/climbing)

/datum/runeritual/enchanting/thievery
	name = "Thievery"
	desc = "Better pickpocketting and lockpicks!"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/infernal/fang = 1, /obj/item/magic/obsidian = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/thievery)

/datum/runeritual/enchanting/trekk
	name = "Longstriding"
	desc = "Provides easy movement through rough terrain."
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/shard = 1, /obj/item/magic/artifact = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/trekk)

/datum/runeritual/enchanting/smithing
	name = "Smithing"
	desc = "Better smithing."
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/shard = 1, /obj/item/magic/elemental/mote = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/smithing)

//T3 below here

/datum/runeritual/enchanting/lifesteal
	name = "Lyfestealing"
	desc = "Steals health from foes."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/fae/heartwoodcore = 1, /obj/item/magic/infernal/fang = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/lifesteal)

/datum/runeritual/enchanting/lightning
	name = "Lightning"
	desc = "Shocks foes."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/infernal/core = 1, /obj/item/magic/leyline = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/lightning)

/datum/runeritual/enchanting/voidtouched
	name = "voidtouched"
	desc = "Teleports the target nearby."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1, /obj/item/magic/fae/heartwoodcore = 1, /obj/item/magic/voidstone = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/voidtouched)

/datum/runeritual/enchanting/frostveil	//armor enchantment
	name = "Frostveil"
	desc = "Chills foes."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/fragment = 1, /obj/item/magic/elemental/shard = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/frostveil)

/datum/runeritual/enchanting/returningweapon
	name = "Returning Weapon"
	desc = "Summons weapons."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/fragment = 1, /obj/item/magic/fae/fairydust = 2, /obj/item/magic/elemental/mote = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/returningweapon)

/datum/runeritual/enchanting/archery
	name = "Archery"
	desc = "Of bowmanship."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/infernal/fang = 2, /obj/item/magic/leyline = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/archery)


//T4 Below here


/datum/runeritual/enchanting/briars
	name = "Briar's Curse"
	desc = "Harder hitting weapons at a cost."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/fae/sylvanessence = 1, /obj/item/magic/fae/heartwoodcore = 2, /obj/item/magic/melded/t3 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/briars)

/datum/runeritual/enchanting/infernalflame	//weapon enchantment
	name = "Infernal Flame"
	desc = "Sets foes aflame."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/infernal/flame = 1, /obj/item/magic/obsidian = 4, /obj/item/magic/melded/t3 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/infernalflame)


/datum/runeritual/enchanting/freeze	//weapon enchantment
	name = "Freezing"
	desc = "Freezes Foes into cubes of ice."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/fae/sylvanessence = 1, /obj/item/magic/infernal/core = 2, /obj/item/magic/melded/t3 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/freeze)


/datum/runeritual/enchanting/rewind
	name = "Temporal Rewind"
	desc = "Rewinds time."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/relic = 1, /obj/item/magic/fae/heartwoodcore = 2,  /obj/item/magic/melded/t3 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/rewind)

/datum/runeritual/enchanting/chaosstorm
	name = "Chaos Storm"
	desc = "Causes random powerful effects."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/obsidian = 1, /obj/item/magic/manacrystal = 1,  /obj/item/magic/melded/t4 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/chaos_storm)
