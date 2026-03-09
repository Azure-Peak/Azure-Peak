/*
 * ========== Enchanting Rituals ==========
 *
 * Each enchantment is aligned with a realm. The material cost is exactly
 * one mob's worth of same-tier realm drops:
 *   T1: 4x T1 realm mat + cinnabar + scroll
 *   T2: 2x T2 realm mat + cinnabar + scroll
 *   T3: 1x T3 realm mat + cinnabar + scroll + leyline shard
 *   T4: 1x T4 realm mat + cinnabar + scroll + leyline shard
 *
 * Void-themed enchantments (Voidtouched, Chaos Storm) use voidstone
 * instead of a realm mat.
 *
 * Rune requirements:
 *   Imbuement Array — T1 through T3 enchantments.
 *   Greater Imbuement Array — all enchantments (T1 through T4).
 *
 * No melds required — enchanting is a solo activity. (In theory)
 * Melds gate binding instead.
 */

/datum/runeritual/enchanting
	name = "Enchanting"
	desc = "Parent enchanting."
	category = "Enchanting"
	abstract_type = /datum/runeritual/enchanting
	blacklisted = TRUE

// ----- T1 Enchantments (4x T1 realm mat + cinnabar + scroll) -----

/datum/runeritual/enchanting/woodcut
	name = "Woodcutting"
	desc = "Good for cutting wood."
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/elemental/mote = 4)
	result_atoms = list(/obj/item/enchantmentscroll/woodcut)

/datum/runeritual/enchanting/mining
	name = "Mining"
	desc = "Good for mining rock."
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/elemental/mote = 4)
	result_atoms = list(/obj/item/enchantmentscroll/mining)

/datum/runeritual/enchanting/xylix
	name = "Xylix's Grace"
	desc = "How fortunate!"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/fae/fairydust = 4)
	result_atoms = list(/obj/item/enchantmentscroll/xylix)

/datum/runeritual/enchanting/revealinglight
	name = "Revealing Light"
	desc = "Provides light!"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/infernal/ash = 4)
	result_atoms = list(/obj/item/enchantmentscroll/revealinglight)

/datum/runeritual/enchanting/magnifiedlight
	name = "Magnified Light"
	desc = "Doubles brightness!"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/infernal/ash = 4)
	result_atoms = list(/obj/item/enchantmentscroll/magnifiedlight)

// ----- T2 Enchantments (2x T2 realm mat + cinnabar + scroll) -----

/datum/runeritual/enchanting/nightvision
	name = "Dark Vision"
	desc = "Provides dark sight!"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/fae/iridescentscale = 2)
	result_atoms = list(/obj/item/enchantmentscroll/nightvision)

/datum/runeritual/enchanting/unbreaking
	name = "Unbreaking"
	desc = "Provides extra integrity!"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/elemental/shard = 2)
	result_atoms = list(/obj/item/enchantmentscroll/unbreaking)

/datum/runeritual/enchanting/featherstep
	name = "Feather Step"
	desc = "Makes your step lighter and speedier!"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/fae/iridescentscale = 2)
	result_atoms = list(/obj/item/enchantmentscroll/featherstep)

/datum/runeritual/enchanting/fireresist
	name = "Fire Resistance"
	desc = "Provides resistance from fire!"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/infernal/fang = 2)
	result_atoms = list(/obj/item/enchantmentscroll/fireresist)

/datum/runeritual/enchanting/climbing
	name = "Spider movements"
	desc = "Better climbing!"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/fae/iridescentscale = 2)
	result_atoms = list(/obj/item/enchantmentscroll/climbing)

/datum/runeritual/enchanting/thievery
	name = "Thievery"
	desc = "Better pickpocketting and lockpicks!"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/infernal/fang = 2)
	result_atoms = list(/obj/item/enchantmentscroll/thievery)

/datum/runeritual/enchanting/trekk
	name = "Longstriding"
	desc = "Provides easy movement through rough terrain."
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/elemental/shard = 2)
	result_atoms = list(/obj/item/enchantmentscroll/trekk)

/datum/runeritual/enchanting/smithing
	name = "Smithing"
	desc = "Better smithing."
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/elemental/shard = 2)
	result_atoms = list(/obj/item/enchantmentscroll/smithing)

// ----- T3 Enchantments (1x T3 realm mat + cinnabar + scroll + leyline shard) -----

/datum/runeritual/enchanting/lifesteal
	name = "Lyfestealing"
	desc = "Steals health from foes."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/leyline = 1, /obj/item/magic/infernal/core = 1)
	result_atoms = list(/obj/item/enchantmentscroll/lifesteal)

/datum/runeritual/enchanting/lightning
	name = "Lightning"
	desc = "Shocks foes."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/leyline = 1, /obj/item/magic/elemental/fragment = 1)
	result_atoms = list(/obj/item/enchantmentscroll/lightning)

/datum/runeritual/enchanting/voidtouched
	name = "voidtouched"
	desc = "Teleports the target nearby."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/leyline = 1, /obj/item/magic/voidstone = 1)
	result_atoms = list(/obj/item/enchantmentscroll/voidtouched)

/datum/runeritual/enchanting/frostveil
	name = "Lesser Freezing"
	desc = "Chills foes."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/leyline = 1, /obj/item/magic/elemental/fragment = 1)
	result_atoms = list(/obj/item/enchantmentscroll/frostveil)

/datum/runeritual/enchanting/returningweapon
	name = "Returning Weapon"
	desc = "Summons weapons."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/leyline = 1, /obj/item/magic/fae/heartwoodcore = 1)
	result_atoms = list(/obj/item/enchantmentscroll/returningweapon)

/datum/runeritual/enchanting/archery
	name = "Archery"
	desc = "Of bowmanship."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/leyline = 1, /obj/item/magic/infernal/core = 1)
	result_atoms = list(/obj/item/enchantmentscroll/archery)

// ----- T4 Enchantments (1x T4 realm mat + cinnabar + scroll + leyline shard) -----

/datum/runeritual/enchanting/briars
	name = "Briar's Curse"
	desc = "Harder hitting weapons at a cost."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/leyline = 1, /obj/item/magic/fae/sylvanessence = 1)
	result_atoms = list(/obj/item/enchantmentscroll/briars)

/datum/runeritual/enchanting/infernalflame
	name = "Infernal Flame"
	desc = "Sets foes aflame."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/leyline = 1, /obj/item/magic/infernal/flame = 1)
	result_atoms = list(/obj/item/enchantmentscroll/infernalflame)

/datum/runeritual/enchanting/freeze
	name = "Greater Freezing"
	desc = "Heavily chills foes."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/leyline = 1, /obj/item/magic/elemental/relic = 1)
	result_atoms = list(/obj/item/enchantmentscroll/freeze)

/datum/runeritual/enchanting/rewind
	name = "Temporal Rewind"
	desc = "Rewinds time."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/leyline = 1, /obj/item/magic/fae/sylvanessence = 1)
	result_atoms = list(/obj/item/enchantmentscroll/rewind)

/datum/runeritual/enchanting/chaosstorm
	name = "Chaos Storm"
	desc = "Causes random powerful effects."
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/paper/scroll = 1, /obj/item/magic/leyline = 1, /obj/item/magic/voidstone = 1)
	result_atoms = list(/obj/item/enchantmentscroll/chaos_storm)
