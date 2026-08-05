/datum/crafting_recipe/roguetown/survival/peasantry
	abstract_type = /datum/crafting_recipe/roguetown/survival/peasantry
	display_category = ITEM_CAT_TOOLS_FIELD
	tools = list(/obj/item/rogueweapon/hammer)
	req_table = TRUE
	skillcraft = /datum/skill/craft/carpentry
	category = "Tools"

/datum/crafting_recipe/roguetown/survival/peasantry/thresher
	name = "thresher"
	reqs = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/ingot/iron = 1,
		)
	result = /obj/item/rogueweapon/thresher
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/peasantry/thresher/whetstone
	name = "thresher"
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/whetstone = 4,
		/obj/item/rope = 1,
		)
	result = /obj/item/rogueweapon/thresher
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/peasantry/shovel
	name = "shovel - iron ingot"
	reqs = list(
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/ingot/iron = 1,
		)
	result = /obj/item/rogueweapon/shovel
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/peasantry/shovel/whetstone
	name = "shovel - whetstone"
	reqs = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/natural/whetstone = 3,
		/obj/item/rope = 1,
		)
	result = /obj/item/rogueweapon/shovel
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/peasantry/hoe
	name = "hoe - iron ingot"
	reqs = list(
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/ingot/iron = 1,
		)
	result = /obj/item/rogueweapon/hoe
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/peasantry/hoe/whetstone
	name = "hoe - whetstone"
	reqs = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/natural/whetstone = 3,
		/obj/item/rope = 1,
		)
	result = /obj/item/rogueweapon/hoe
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/peasantry/pitchfork
	name = "pitchfork - iron ingot"
	reqs = list(
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/ingot/iron = 1,
		)
	result = /obj/item/rogueweapon/pitchfork
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/peasantry/pitchfork/whetstone
	name = "pitchfork - whetstone"
	reqs = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/natural/whetstone = 3,
		/obj/item/rope = 1,
		)
	result = /obj/item/rogueweapon/pitchfork
	craftdiff = 0


/datum/crafting_recipe/roguetown/survival/peasantry/peasantwarflail
	name = "peasant war flail (thresher)"
	result = /obj/item/rogueweapon/flail/peasantwarflail
	reqs = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/rope = 1,
		/obj/item/rogueweapon/thresher = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/goedendag
	name = "militia goedendag"
	result = /obj/item/rogueweapon/woodstaff/militia
	reqs = list(
		/obj/item/rogueweapon/woodstaff = 1,
		/obj/item/natural/whetstone = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/waraxe
	name = "militia shovel-waraxe"
	result = /obj/item/rogueweapon/greataxe/militia
	reqs = list(
		/obj/item/rogueweapon/shovel = 1,
		/obj/item/grown/log/tree/small = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/waraxe/silver
	name = "silver militia shovelaxe"
	result = /obj/item/rogueweapon/greataxe/militia/silver
	reqs = list(
		/obj/item/rogueweapon/shovel/silver = 1,
		/obj/item/grown/log/tree/small = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/waraxe/silver/preblessed
	name = "silver militia shovelaxe (preblessed)"
	result = /obj/item/rogueweapon/greataxe/militia/silver/preblessed
	reqs = list(
		/obj/item/rogueweapon/shovel/silver/preblessed = 1,
		/obj/item/grown/log/tree/small = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/warspear_hoe
	name = "militia warspear (hoe)"
	result = /obj/item/rogueweapon/spear/militia
	reqs = list(
		/obj/item/rogueweapon/hoe = 1,
		/obj/item/grown/log/tree/small = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/warspear_pitchfork
	name = "militia warspear (pitchfork)"
	result = /obj/item/rogueweapon/spear/militia
	reqs = list(
		/obj/item/rogueweapon/pitchfork = 1,
		/obj/item/grown/log/tree/small = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/scythe
	name = "scythe"
	result = /obj/item/rogueweapon/scythe
	reqs = list(
		/obj/item/natural/whetstone = 1,
		/obj/item/grown/log/tree/small = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/peasantry/silverscythe
	name = "silver scythe"
	result = /obj/item/rogueweapon/scythe/silver
	reqs = list(
		/obj/item/ingot/silver = 1,
		/obj/item/grown/log/tree/small = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/warflail
	name = "militia flail"
	result = /obj/item/rogueweapon/flail/militia
	reqs = list(
		/obj/item/natural/whetstone = 2,
		/obj/item/rogueweapon/thresher = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/warpick
	name = "militia warpick"
	result = /obj/item/rogueweapon/pick/militia
	reqs = list(
		/obj/item/rogueweapon/pick = 1,
		/obj/item/natural/whetstone = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/warpick_steel
	name = "militia steel warpick"
	result = /obj/item/rogueweapon/pick/militia/steel
	reqs = list(
		/obj/item/rogueweapon/pick/steel = 1,
		/obj/item/natural/whetstone = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/maciejowski_knife
	name = "maciejowski (hunting knife)"
	result = /obj/item/rogueweapon/sword/falchion/militia
	reqs = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/natural/whetstone = 2,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/maciejowski_messer
	name = "maciejowski (iron messer)"
	result = /obj/item/rogueweapon/sword/falchion/militia
	reqs = list(
		/obj/item/rogueweapon/sword/short/messer/iron = 1,
		/obj/item/natural/whetstone = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/stoneaxe
	name = "stone axe"
	display_category = ITEM_CAT_WEAPONS_AXES
	category = "Tools"
	result = /obj/item/rogueweapon/stoneaxe
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/stone = 1,
		)

/datum/crafting_recipe/roguetown/survival/woodhammer
	name = "wood mallet"
	display_category = ITEM_CAT_WEAPONS_MACES
	category = "Tools"
	result = /obj/item/rogueweapon/hammer/wood
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 1,
		)

/datum/crafting_recipe/roguetown/survival/stonehammer
	name = "stone hammer"
	display_category = ITEM_CAT_WEAPONS_MACES
	category = "Tools"
	result = /obj/item/rogueweapon/hammer/stone
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/stone = 1,
		)

/datum/crafting_recipe/roguetown/survival/stonehoe
	name = "stone hoe"
	display_category = ITEM_CAT_TOOLS_FIELD
	category = "Tools"
	result = /obj/item/rogueweapon/hoe/stone
	reqs = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/natural/fibers = 1,
		/obj/item/natural/stone = 1,
		)

/datum/crafting_recipe/roguetown/survival/stonetongs
	name = "stone tongs"
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	category = "Tools"
	result = /obj/item/rogueweapon/tongs/stone
	reqs = list(
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/stone = 1,
		)

/datum/crafting_recipe/roguetown/survival/stonepick
	name = "stone pick"
	display_category = ITEM_CAT_TOOLS_FIELD
	category = "Tools"
	result = /obj/item/rogueweapon/pick/stone
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/stone = 2,
		)

/datum/crafting_recipe/roguetown/survival/stoneknife
	name = "stone knife"
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	category = "Tools"
	result = /obj/item/rogueweapon/huntingknife/stoneknife
	reqs = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/stone = 1,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/stonespear
	name = "stone spear"
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	category = "Tools"
	result = /obj/item/rogueweapon/spear/stone
	reqs = list(
		/obj/item/rogueweapon/woodstaff = 1,
		/obj/item/natural/stone = 1,
		)
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/stonesword
	name = "stone sword"
	display_category = ITEM_CAT_WEAPONS_SWORDS
	category = "Tools"
	result = /obj/item/rogueweapon/sword/stone
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 1,
		/obj/item/natural/stone = 3,
		)
	craftdiff = 1


/datum/crafting_recipe/roguetown/survival/woodclub
	name = "wood club"
	display_category = ITEM_CAT_WEAPONS_MACES
	category = "Tools"
	result = /obj/item/rogueweapon/mace/woodclub/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/billhook
	name = "improvised billhook"
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	category = "Tools"
	result = /obj/item/rogueweapon/spear/improvisedbillhook
	reqs = list(
		/obj/item/rogueweapon/sickle = 1,
		/obj/item/rope = 1,
		/obj/item/grown/log/tree/small = 1,
		)
	tools = list(/obj/item/rogueweapon/hammer)
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/goedendag
	name = "goedendag"
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	category = "Tools"
	result = /obj/item/rogueweapon/mace/goden
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/rope = 1,
		/obj/item/rogueweapon/hoe = 1,
		)
	tools = list(/obj/item/rogueweapon/hammer)
	craftdiff = 3


/obj/item/rogueweapon/mace/woodclub/crafted

/datum/crafting_recipe/roguetown/survival/woodstaff
	name = "wood staff (x3)"
	display_category = ITEM_CAT_WEAPONS_MACES
	category = "Tools"
	result = list(
		/obj/item/rogueweapon/woodstaff,
		/obj/item/rogueweapon/woodstaff,
		/obj/item/rogueweapon/woodstaff,
		)
	reqs = list(/obj/item/grown/log/tree = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/quarterstaff
	name = "quarterstaff"
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	category = "Tools"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff)
	reqs = list(/obj/item/grown/log/tree = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/shillelagh
	name = "shillelagh (x3)"
	display_category = ITEM_CAT_WEAPONS_MACES
	category = "Tools"
	result = list(
		/obj/item/rogueweapon/woodstaff/polearm,
		/obj/item/rogueweapon/woodstaff/polearm,
		/obj/item/rogueweapon/woodstaff/polearm,
		)
	reqs = list(/obj/item/grown/log/tree = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/quarterstaff_iron
	name = "iron-reinforced quarterstaff"
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	category = "Tools"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff/iron)
	reqs = list(
		/obj/item/rogueweapon/woodstaff/quarterstaff = 1,
		/obj/item/ingot/iron = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/quarterstaff_steel
	name = "steel-reinforced quarterstaff"
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	category = "Tools"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff/steel)
	reqs = list(
		/obj/item/rogueweapon/woodstaff/quarterstaff = 1,
		/obj/item/ingot/steel = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/quarterstaff_silver
	name = "silver-reinforced quarterstaff"
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	category = "Tools"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff/silver)
	reqs = list(
		/obj/item/rogueweapon/woodstaff/quarterstaff = 1,
		/obj/item/ingot/silver = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/survival/quarterstaff_psydonic
	name = "psydonic silver-reinforced quarterstaff"
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	category = "Tools"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff/psy)
	reqs = list(
		/obj/item/rogueweapon/woodstaff/quarterstaff = 1,
		/obj/item/ingot/silverblessed = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 5

/datum/crafting_recipe/roguetown/survival/quarterstaff_psydonic/bullion
	name = "psydonic silver-reinforced quarterstaff"
	category = "Tools"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff/psy)
	reqs = list(
		/obj/item/rogueweapon/woodstaff/quarterstaff = 1,
		/obj/item/ingot/silverblessed/bullion = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 5

/datum/crafting_recipe/roguetown/survival/quarterstaff_blacksteel
	name = "blacksteel-reinforced quarterstaff"
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	category = "Tools"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel)
	reqs = list(
		/obj/item/rogueweapon/woodstaff/quarterstaff = 1,
		/obj/item/ingot/blacksteel = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 5

/datum/crafting_recipe/roguetown/survival/woodsword
	name = "wooden sword (x2)"
	display_category = ITEM_CAT_WEAPONS_SWORDS
	category = "Tools"
	result = list(
		/obj/item/rogueweapon/mace/wsword,
		/obj/item/rogueweapon/mace/wsword,
		)
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/sharpenedstake
	name = "stake, sharpened"
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	category = "Tools" 
	result = list(/obj/item/rogueweapon/huntingknife/idagger/stake)
	reqs = list(
		/obj/item/grown/log/tree/stake = 1,
		/obj/item/natural/whetstone = 1,
		)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/wood_dagger
	name = "wooden dagger (x3)"
	display_category = ITEM_CAT_WEAPONS_DAGGERS
	category = "Tools"
	result = list(
		/obj/item/rogueweapon/huntingknife/wood,
		/obj/item/rogueweapon/huntingknife/wood,
		/obj/item/rogueweapon/huntingknife/wood,
		)
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/woodshield
	name = "wooden shield"
	display_category = ITEM_CAT_WEAPONS_SHIELDS
	category = "Tools"
	result = /obj/item/rogueweapon/shield/wood
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/hide = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/heatershield
	name = "heater shield"
	display_category = ITEM_CAT_WEAPONS_SHIELDS
	category = "Tools"
	result = /obj/item/rogueweapon/shield/heater/crafted
	reqs = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/natural/hide/cured = 1,
		)
	skillcraft = /datum/skill/craft/carpentry

/obj/item/rogueweapon/shield/heater/crafted


/datum/crafting_recipe/roguetown/survival/bonespear
	name = "bone spear"
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	category = "Tools"
	result = /obj/item/rogueweapon/spear/bonespear
	reqs = list(
		/obj/item/rogueweapon/woodstaff = 1,
		/obj/item/natural/bone = 2,
		/obj/item/natural/fibers = 1,
		)
	craftdiff = 3


/datum/crafting_recipe/roguetown/survival/boneaxe
	name = "bone axe"
	display_category = ITEM_CAT_WEAPONS_AXES
	category = "Tools"
	result = /obj/item/rogueweapon/stoneaxe/boneaxe
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/bone = 2,
		/obj/item/natural/fibers = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/woodspade
	name = "wood spade"
	display_category = ITEM_CAT_TOOLS_FIELD
	category = "Tools"
	result = /obj/item/rogueweapon/shovel/small
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stick = 1,
		)
/obj/item/rogueweapon/shovel/small/crafted

/datum/crafting_recipe/roguetown/survival/rod
	name = "fishing rod"
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	category = "Tools"
	result = /obj/item/fishingrod/crafted
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 2,
		)

/obj/item/fishingrod/crafted

/datum/crafting_recipe/roguetown/survival/rodblacksteel
	name = "fishing rod, blacksteel"
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	category = "Tools"
	result = /obj/item/fishingrod/blacksteel
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 2,
		/obj/item/ingot/blacksteel = 1,
		)

/datum/crafting_recipe/roguetown/survival/bow
	name = "bow"
	display_category = ITEM_CAT_WEAPONS_AMMO
	category = "Tools"
	result = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/classic)
	reqs = list(
		/obj/item/grown/log/tree = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/natural/fibers = 3,
		)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/fishingcage
	name = "fishing cage"
	display_category = ITEM_CAT_TOOLS_FIELD
	category = "Tools"
	result = /obj/item/fishingcage
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stick = 2,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/strucrepairkit
	name = "Structure Repair Kit"
	display_category = ITEM_CAT_TOOLS_SUNDRIES
	category = "Tools"
	result = list(/obj/item/construction/repairkit/structure,
				  /obj/item/construction/repairkit/structure,
				  /obj/item/construction/repairkit/structure)
	reqs = list(/obj/item/construction/nail = 6,
				/obj/item/natural/wood/plank = 3,
				/obj/item/natural/stoneblock = 3)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 5

/datum/crafting_recipe/roguetown/survival/mortar
	name = "alchemical mortar"
	result = /obj/item/reagent_containers/glass/mortar
	reqs = list(/obj/item/natural/stone = 1)
	craftdiff = 1
	structurecraft = null
	verbage_simple = "create"

/datum/crafting_recipe/roguetown/survival/pestle
	name = "stone pestle"
	result = /obj/item/pestle
	reqs = list(/obj/item/natural/stone = 1)
	craftdiff = 1
	structurecraft = null
	verbage_simple = "create"

