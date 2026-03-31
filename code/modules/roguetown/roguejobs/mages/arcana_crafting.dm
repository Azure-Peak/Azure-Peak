// No Arcana recipes gives XP, to prevent grinding a combat skills
// Through crafting. However, all of them are gated at only Craft Diff 2 
// Aka Apprentice, so high int novice can gate it. And every magic 
// Role can engage competently, thus removing the need to legitimately
// Grind crafting recipes for XP / crafting purpose.
/datum/crafting_recipe/roguetown/arcana
	req_table = TRUE
	tools = list()
	category = "Arcana"
	abstract_type = /datum/crafting_recipe/roguetown/arcana
	skillcraft = /datum/skill/magic/arcane
	subtype_reqs = TRUE
	xp_modifier = 0
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/crafting_recipe/roguetown/arcana/amethyst
	name = "amythortz"
	result = /obj/item/roguegem/amethyst
	reqs = list(/obj/item/natural/stone = 1,
				/datum/reagent/medicine/manapot = 15)

/datum/crafting_recipe/roguetown/arcana/chalk
	name = "chalk"
	result = /obj/item/chalk
	reqs = list(/obj/item/rogueore/cinnabar = 1,
				/datum/reagent/medicine/manapot = 15)

/datum/crafting_recipe/roguetown/arcana/infernalfeather
	name = "infernal feather"
	result = /obj/item/natural/feather/infernal
	reqs = list(/obj/item/natural/feather = 1,
				/obj/item/magic/infernal/ash = 2)

/datum/crafting_recipe/roguetown/arcana/sendingstone
	name = "sending stones"
	result = /obj/item/sendingstonesummoner
	reqs = list(/obj/item/natural/stone = 2,
				/obj/item/roguegem/amethyst = 2,
				/obj/item/magic/melded/t1 = 1)

/datum/crafting_recipe/roguetown/arcana/voidlamptern
	name = "void lamptern"
	result = /obj/item/flashlight/flare/torch/lantern/voidlamptern
	reqs = list(/obj/item/flashlight/flare/torch/lantern = 1,
				/obj/item/magic/voidstone = 1,
				/obj/item/magic/melded/t1 = 1)

/datum/crafting_recipe/roguetown/arcana/nomagiccollar
	name = "mana binding collar"
	result = /obj/item/clothing/neck/roguetown/collar/leather/nomagic
	reqs = list(/obj/item/clothing/neck/roguetown/collar = 1,
				/obj/item/roguegem/diamond = 1,
				/obj/item/magic/melded/t2 = 1)

/datum/crafting_recipe/roguetown/arcana/nomagicglove
	name = "mana binding gloves"
	result = /obj/item/clothing/gloves/roguetown/nomagic
	reqs = list(/obj/item/clothing/gloves/roguetown/leather = 1,
				/obj/item/roguegem/diamond = 1,
				/obj/item/magic/melded/t3 = 1)
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/crafting_recipe/roguetown/arcana/temporalhourglass
	name = "temporal hourglass"
	result = /obj/item/hourglass/temporal
	reqs = list(/obj/item/natural/wood/plank = 4,
				/obj/item/magic/leyline = 1,
				/obj/item/magic/melded/t2 = 1)
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/crafting_recipe/roguetown/arcana/shimmeringlens
	name = "shimmering lens"
	result = /obj/item/clothing/ring/active/shimmeringlens
	reqs = list(/obj/item/magic/fae/iridescentscale = 1,
				/obj/item/magic/leyline = 1,
				/obj/item/magic/melded/t2 = 1)
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/crafting_recipe/roguetown/arcana/mimictrinket
	name = "mimic trinket"
	result = /obj/item/mimictrinket
	reqs = list(/obj/item/natural/wood/plank = 2,
				/obj/item/magic/melded/t1 = 1)

/datum/crafting_recipe/roguetown/arcana/binding
	name = "binding shackles"
	result = /obj/item/rope/chain/bindingshackles
	reqs = list(/obj/item/rope/chain = 1,
				/obj/item/magic/melded/t1 = 1)

/datum/crafting_recipe/roguetown/arcana/bindingt2
	name = "binding shackles (T2)"
	result = /obj/item/rope/chain/bindingshackles/t2
	reqs = list(/obj/item/rope/chain = 1,
				/obj/item/magic/melded/t2 = 1)

/datum/crafting_recipe/roguetown/arcana/bindingt3
	name = "binding shackles (T3)"
	result = /obj/item/rope/chain/bindingshackles/t3
	reqs = list(/obj/item/rope/chain = 1,
				/obj/item/magic/melded/t3 = 1)

/datum/crafting_recipe/roguetown/arcana/bindingt4
	name = "binding shackles (T4)"
	result = /obj/item/rope/chain/bindingshackles/t4
	reqs = list(/obj/item/rope/chain = 1,
				/obj/item/magic/melded/t4 = 1)

/datum/crafting_recipe/roguetown/arcana/bindingt5
	name = "binding shackles (T5)"
	result = /obj/item/rope/chain/bindingshackles/t5
	reqs = list(/obj/item/rope/chain = 1,
				/obj/item/magic/melded/t5 = 1)

/datum/crafting_recipe/roguetown/arcana/forge
	name = "infernal forge"
	req_table = FALSE
	result = /obj/machinery/light/rogue/forge/arcane
	reqs = list(/obj/item/magic/infernal/core = 1,
				/obj/item/natural/stone = 4)
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/crafting_recipe/roguetown/arcana/nullring
	name = "ring of null magic"
	result = /obj/item/clothing/ring/active/nomag
	reqs = list(/obj/item/clothing/ring/gold = 1,
				/obj/item/magic/voidstone = 1)
	craftdiff = SKILL_LEVEL_EXPERT

/datum/crafting_recipe/roguetown/arcana/meldt1
	name = "arcanic meld"
	result = /obj/item/magic/melded/t1
	reqs = list(/obj/item/magic/infernal/ash = 1,
				/obj/item/magic/fae/fairydust = 1,
				/obj/item/magic/elemental/mote = 1)

/datum/crafting_recipe/roguetown/arcana/meldt2
	name = "dense arcanic meld"
	result = /obj/item/magic/melded/t2
	reqs = list(/obj/item/magic/infernal/fang = 1,
				/obj/item/magic/fae/iridescentscale = 1,
				/obj/item/magic/elemental/shard = 1)

/datum/crafting_recipe/roguetown/arcana/meldt3
	name = "sorcerous weave"
	result = /obj/item/magic/melded/t3
	reqs = list(/obj/item/magic/infernal/core = 1,
				/obj/item/magic/fae/heartwoodcore = 1,
				/obj/item/magic/elemental/fragment = 1)

/datum/crafting_recipe/roguetown/arcana/meldt4
	name = "magical confluence"
	result = /obj/item/magic/melded/t4
	reqs = list(/obj/item/magic/infernal/flame = 1,
				/obj/item/magic/fae/sylvanessence = 1,
				/obj/item/magic/elemental/relic = 1)

/datum/crafting_recipe/roguetown/arcana/meldt5
	name = "arcanic abberation"
	result = /obj/item/magic/melded/t5
	reqs = list(/obj/item/magic/melded/t4 = 1,
				/obj/item/magic/voidstone = 1)

// ========== Fission (downgrade, same realm) ==========
// Lesser: 1 T2 → 2 T1. Greater: 1 T3 → 2 T2. Grand: 1 T4 → 1 T3.

// Infernal fission
/datum/crafting_recipe/roguetown/arcana/fission_infernal_lesser
	name = "lesser arcyne fission of hellhound fang"
	result = list(/obj/item/magic/infernal/ash, /obj/item/magic/infernal/ash)
	reqs = list(/obj/item/magic/infernal/fang = 1)

/datum/crafting_recipe/roguetown/arcana/fission_infernal_greater
	name = "greater arcyne fission of infernal core"
	result = list(/obj/item/magic/infernal/fang, /obj/item/magic/infernal/fang)
	reqs = list(/obj/item/magic/infernal/core = 1)

/datum/crafting_recipe/roguetown/arcana/fission_infernal_grand
	name = "grand arcyne fission of abyssal flame"
	result = /obj/item/magic/infernal/core
	reqs = list(/obj/item/magic/infernal/flame = 1)

// Fae fission
/datum/crafting_recipe/roguetown/arcana/fission_fae_lesser
	name = "lesser arcyne fission of iridescent scale"
	result = list(/obj/item/magic/fae/fairydust, /obj/item/magic/fae/fairydust)
	reqs = list(/obj/item/magic/fae/iridescentscale = 1)

/datum/crafting_recipe/roguetown/arcana/fission_fae_greater
	name = "greater arcyne fission of heartwood core"
	result = list(/obj/item/magic/fae/iridescentscale, /obj/item/magic/fae/iridescentscale)
	reqs = list(/obj/item/magic/fae/heartwoodcore = 1)

/datum/crafting_recipe/roguetown/arcana/fission_fae_grand
	name = "grand arcyne fission of sylvan essence"
	result = /obj/item/magic/fae/heartwoodcore
	reqs = list(/obj/item/magic/fae/sylvanessence = 1)

// Elemental fission
/datum/crafting_recipe/roguetown/arcana/fission_elemental_lesser
	name = "lesser arcyne fission of elemental shard"
	result = list(/obj/item/magic/elemental/mote, /obj/item/magic/elemental/mote)
	reqs = list(/obj/item/magic/elemental/shard = 1)

/datum/crafting_recipe/roguetown/arcana/fission_elemental_greater
	name = "greater arcyne fission of elemental fragment"
	result = list(/obj/item/magic/elemental/shard, /obj/item/magic/elemental/shard)
	reqs = list(/obj/item/magic/elemental/fragment = 1)

/datum/crafting_recipe/roguetown/arcana/fission_elemental_grand
	name = "grand arcyne fission of elemental relic"
	result = /obj/item/magic/elemental/fragment
	reqs = list(/obj/item/magic/elemental/relic = 1)

// ========== Fusion (upgrade, same realm, inefficient) ==========
// Lesser: 4 T1 → 1 T2. Greater: 2 T2 → 1 T3. Grand: 2 T3 → 1 T4.

// Infernal fusion
/datum/crafting_recipe/roguetown/arcana/fusion_infernal_lesser
	name = "lesser arcyne fusion of infernal ashes"
	result = /obj/item/magic/infernal/fang
	reqs = list(/obj/item/magic/infernal/ash = 4)

/datum/crafting_recipe/roguetown/arcana/fusion_infernal_greater
	name = "greater arcyne fusion of infernal fangs"
	result = /obj/item/magic/infernal/core
	reqs = list(/obj/item/magic/infernal/fang = 2)

/datum/crafting_recipe/roguetown/arcana/fusion_infernal_grand
	name = "grand arcyne fusion of infernal cores"
	result = /obj/item/magic/infernal/flame
	reqs = list(/obj/item/magic/infernal/core = 2)

// Fae fusion
/datum/crafting_recipe/roguetown/arcana/fusion_fae_lesser
	name = "lesser arcyne fusion of iridescent scales"
	result = /obj/item/magic/fae/iridescentscale
	reqs = list(/obj/item/magic/fae/fairydust = 4)

/datum/crafting_recipe/roguetown/arcana/fusion_fae_greater
	name = "greater arcyne fusion of heartwood cores"
	result = /obj/item/magic/fae/heartwoodcore
	reqs = list(/obj/item/magic/fae/iridescentscale = 2)

/datum/crafting_recipe/roguetown/arcana/fusion_fae_grand
	name = "grand arcyne fusion of sylvan essence"
	result = /obj/item/magic/fae/sylvanessence
	reqs = list(/obj/item/magic/fae/heartwoodcore = 2)

// Elemental fusion
/datum/crafting_recipe/roguetown/arcana/fusion_elemental_lesser
	name = "lesser arcyne fusion of elemental motes"
	result = /obj/item/magic/elemental/shard
	reqs = list(/obj/item/magic/elemental/mote = 4)

/datum/crafting_recipe/roguetown/arcana/fusion_elemental_greater
	name = "greater arcyne fusion of elemental shards"
	result = /obj/item/magic/elemental/fragment
	reqs = list(/obj/item/magic/elemental/shard = 2)

/datum/crafting_recipe/roguetown/arcana/fusion_elemental_grand
	name = "grand arcyne fusion of elemental relic"
	result = /obj/item/magic/elemental/relic
	reqs = list(/obj/item/magic/elemental/fragment = 2)

// Runed Artifacts are only found in bog and run out soon so this is a 
// Loreful way of "replicating" it but requires you to go out at least once

/datum/crafting_recipe/roguetown/arcana/runed_artifact_replication
	name = "arcyne replication of runed artifact"
	result = list(/obj/item/magic/artifact, /obj/item/magic/artifact)
	reqs = list(/obj/item/magic/artifact = 1,
				/datum/reagent/medicine/manapot = 45)

// ========== Gem Extraction (remove gem from staff) ==========

/datum/crafting_recipe/roguetown/arcana/extract_toper
	name = "extract toper from staff"
	result = list(/obj/item/rogueweapon/woodstaff, /obj/item/roguegem/yellow)
	reqs = list(/obj/item/rogueweapon/woodstaff/toper = 1)

/datum/crafting_recipe/roguetown/arcana/extract_amethyst
	name = "extract amythortz from staff"
	result = list(/obj/item/rogueweapon/woodstaff, /obj/item/roguegem/amethyst)
	reqs = list(/obj/item/rogueweapon/woodstaff/amethyst = 1)

/datum/crafting_recipe/roguetown/arcana/extract_emerald
	name = "extract gemerald from staff"
	result = list(/obj/item/rogueweapon/woodstaff, /obj/item/roguegem/green)
	reqs = list(/obj/item/rogueweapon/woodstaff/emerald = 1)

/datum/crafting_recipe/roguetown/arcana/extract_sapphire
	name = "extract saffira from staff"
	result = list(/obj/item/rogueweapon/woodstaff, /obj/item/roguegem/violet)
	reqs = list(/obj/item/rogueweapon/woodstaff/sapphire = 1)

/datum/crafting_recipe/roguetown/arcana/extract_quartz
	name = "extract blortz from staff"
	result = list(/obj/item/rogueweapon/woodstaff, /obj/item/roguegem/blue)
	reqs = list(/obj/item/rogueweapon/woodstaff/quartz = 1)

/datum/crafting_recipe/roguetown/arcana/extract_ruby
	name = "extract ronts from staff"
	result = list(/obj/item/rogueweapon/woodstaff, /obj/item/roguegem/ruby)
	reqs = list(/obj/item/rogueweapon/woodstaff/ruby = 1)

/datum/crafting_recipe/roguetown/arcana/extract_diamond
	name = "extract dorpel from staff"
	result = list(/obj/item/rogueweapon/woodstaff, /obj/item/roguegem/diamond)
	reqs = list(/obj/item/rogueweapon/woodstaff/diamond = 1)

/datum/crafting_recipe/roguetown/arcana/arcyne_dagger
	name = "arcyne silver dagger"
	result = /obj/item/rogueweapon/huntingknife/idagger/silver/arcyne
	reqs = list(/obj/item/rogueweapon/huntingknife/idagger/silver = 1,
				/obj/item/rogueore/cinnabar = 1)

/datum/crafting_recipe/roguetown/arcana/pre_arcyne_spellbook
	name = "tome in waiting"
	result = /obj/item/spellbook_unfinished/pre_arcyne
	reqs = list(/obj/item/natural/hide = 1,
				/obj/item/paper/scroll = 6)

