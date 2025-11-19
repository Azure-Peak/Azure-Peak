/*
* map spawners which represent different types and tiers of armor and weapons ฅ^•ﻌ•^ฅ
*/

/obj/effect/spawner/lootdrop/light_armor_spawner
	name = "light armor spawner"
	icon_state = "larmor"
	lootcount = 1
	loot = list(
		/obj/item/clothing/suit/roguetown/armor/leather = 6,
		/obj/item/clothing/suit/roguetown/armor/leather/cuirass = 4,
		/obj/item/clothing/suit/roguetown/armor/leather/hide = 5,
		/obj/item/clothing/suit/roguetown/armor/leather/studded = 1,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy = 1,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = 1,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket = 1,
		/obj/item/clothing/suit/roguetown/armor/leather/trophyfur = 1,
		/obj/item/clothing/suit/roguetown/armor/silkcoat = 1,
		/obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper = 1,
		/obj/item/clothing/under/roguetown/trou = 1,
		/obj/item/clothing/under/roguetown/trou/leather = 1,
		/obj/item/clothing/under/roguetown/heavy_leather_pants = 1,
		/obj/item/clothing/under/roguetown/trou/shadowpants = 1,
		/obj/item/clothing/under/roguetown/trou/leathertights = 1,
	)

/obj/effect/spawner/lootdrop/medium_armor_spawner
	name = "medium armor spawner"
	icon_state = "marmor"
	lootcount = 1
	loot = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail = 3,
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron = 6,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = 2,
		/obj/item/clothing/suit/roguetown/armor/plate/scale = 1,
		/obj/item/clothing/suit/roguetown/armor/brigandine/light = 2,
		/obj/item/clothing/under/roguetown/chainlegs = 3,
		/obj/item/clothing/under/roguetown/splintlegs = 2,
		/obj/item/clothing/under/roguetown/chainlegs/iron = 6,
		/obj/item/clothing/under/roguetown/chainlegs/kilt = 3,
		/obj/item/clothing/under/roguetown/chainlegs/iron/kilt = 6,
	)

/obj/effect/spawner/lootdrop/heavy_armor_spawner
	name = "heavy armor spawner"
	icon_state = "harmor"
	lootcount = 1
	loot = list(
		/obj/item/clothing/suit/roguetown/armor/plate = 6,
		/obj/item/clothing/suit/roguetown/armor/plate/fluted = 3,
		/obj/item/clothing/suit/roguetown/armor/plate/full = 2,
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted = 1,
		/obj/item/clothing/suit/roguetown/armor/brigandine = 6,
		/obj/item/clothing/suit/roguetown/armor/brigandine/coatplates = 4,
		/obj/item/clothing/under/roguetown/platelegs = 6, //how is there only one nonunique heavy leg armor
	)

/obj/effect/spawner/lootdrop/helmet_spawner
	name = "helmet spawner"
	icon_state = "helmetarmor"
	lootcount = 1
	loot = list(
		/obj/item/clothing/head/roguetown/helmet/coppercap = 10,
		/obj/item/clothing/head/roguetown/helmet/skullcap = 8,
		/obj/item/clothing/head/roguetown/helmet/horned = 8,
		/obj/item/clothing/head/roguetown/helmet/winged = 3,
		/obj/item/clothing/head/roguetown/helmet/kettle = 3,
		/obj/item/clothing/head/roguetown/helmet/sallet = 2,
		/obj/item/clothing/head/roguetown/helmet/sallet/visored = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/guard = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/knight = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/bucket = 1,
		/obj/item/clothing/head/roguetown/helmet/bascinet = 2,
		/obj/item/clothing/head/roguetown/helmet/bascinet/pigface = 1,
		/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/frogmouth = 1,
		/obj/item/clothing/head/roguetown/helmet/bascinet = 1,
		/obj/item/clothing/head/roguetown/helmet/leather = 9,
		/obj/item/clothing/head/roguetown/helmet/leather/volfhelm = 3,
		/obj/item/clothing/head/roguetown/helmet/leather/saiga = 3,
		/obj/item/clothing/head/roguetown/helmet/leather/advanced = 5,
	)

/obj/effect/spawner/lootdrop/armored_gloves_spawner
	name = "armored gloves spawner"
	icon_state = "glovearmor"
	lootcount = 1
	loot = list(
		/obj/item/clothing/gloves/roguetown/leather = 6,
		/obj/item/clothing/gloves/roguetown/angle = 2,
		/obj/item/clothing/gloves/roguetown/fingerless_leather = 3,
		/obj/item/clothing/gloves/roguetown/chain = 1,
		/obj/item/clothing/gloves/roguetown/chain/iron = 3,
		/obj/item/clothing/gloves/roguetown/plate = 1,
	)

/obj/effect/spawner/lootdrop/armored_boots_spawner
	name = "armored boots spawner"
	icon_state = "bootarmor"
	lootcount = 1
	loot = list(
		/obj/item/clothing/shoes/roguetown/boots = 10,
		/obj/item/clothing/shoes/roguetown/boots/nobleboot = 5,
		/obj/item/clothing/shoes/roguetown/boots/leather = 8,
		/obj/item/clothing/shoes/roguetown/boots/armor = 1,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron = 4,
		/obj/item/clothing/shoes/roguetown/boots/furlinedboots = 2,
	)

/obj/effect/spawner/lootdrop/armored_wrists_spawner
	name = "armored wrists spawner"
	icon_state = "wristarmor"
	lootcount = 1
	loot = list(
		/obj/item/clothing/wrists/roguetown/bracers = 1,
		/obj/item/clothing/wrists/roguetown/bracers/leather = 8,
		/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = 6,
		/obj/item/clothing/wrists/roguetown/bracers/copper = 10,
		/obj/item/clothing/wrists/roguetown/splintarms = 1,
	)

/obj/effect/spawner/lootdrop/horny_armor_spawner
	name = "horny armor spawner"
	icon_state = "hornyarmor"
	lootcount = 1
	loot = list(
		/obj/item/clothing/suit/roguetown/armor/leather/bikini = 6,
		/obj/item/clothing/suit/roguetown/armor/leather/studded/bikini = 6,
		/obj/item/clothing/suit/roguetown/armor/leather/hide/bikini = 6,
		/obj/item/clothing/suit/roguetown/armor/chainmail/bikini = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/bikini = 1,
		/obj/item/clothing/under/roguetown/brayette = 6,
		/obj/item/clothing/under/roguetown/chainlegs/skirt = 1,
		/obj/item/clothing/under/roguetown/platelegs/skirt = 1,
	)

/obj/effect/spawner/lootdrop/peasant_weapon_spawner
	name = "peasant weapon spawner"
	icon_state = "pweapon"
	lootcount = 1
	loot = list(
		/obj/item/rogueweapon/flail/peasantwarflail = 3,
		/obj/item/rogueweapon/flail/militia = 2,
		/obj/item/rogueweapon/woodstaff/militia = 2,
		/obj/item/rogueweapon/greataxe/militia = 2,
		/obj/item/rogueweapon/spear/militia = 2,
		/obj/item/rogueweapon/scythe = 3,
		/obj/item/rogueweapon/pick/militia = 2,
		/obj/item/rogueweapon/pick/militia/steel = 1,
		/obj/item/rogueweapon/sword/falchion/militia = 2,
	)

/obj/effect/spawner/lootdrop/iron_copper_weapon_spawner
	name = "iron+copper weapon spawner"
	icon_state = "icweapon"
	lootcount = 1
	loot = list(
		/obj/item/rogueweapon/sword/iron = 1,
		/obj/item/rogueweapon/sword/short/iron = 3,
		/obj/item/rogueweapon/sword/short/gladius = 1,
		/obj/item/rogueweapon/sword/short/iron/chipped = 1,
		/obj/item/rogueweapon/sword/short/messer/iron = 1,
		/obj/item/rogueweapon/sword/short/messer/copper = 4,
		/obj/item/rogueweapon/woodstaff/quarterstaff/iron = 1,
		/obj/item/rogueweapon/spear = 5,
		/obj/item/rogueweapon/spear/improvisedbillhook = 1,
		/obj/item/rogueweapon/spear/stone/copper = 4,
		/obj/item/rogueweapon/halberd/bardiche = 1,
		/obj/item/rogueweapon/eaglebeak/lucerne = 1,
		/obj/item/rogueweapon/spear/bronze = 1,
		/obj/item/rogueweapon/greatsword/zwei = 2,
		/obj/item/rogueweapon/huntingknife = 2,
		/obj/item/rogueweapon/huntingknife/idagger = 3,
		/obj/item/rogueweapon/huntingknife/throwingknife = 1,
		/obj/item/rogueweapon/huntingknife/scissors = 1,
		/obj/item/rogueweapon/flail = 3,
		/obj/item/rogueweapon/mace = 2,
		/obj/item/rogueweapon/mace/cudgel/copper = 4,
		/obj/item/rogueweapon/mace/goden = 1,
		/obj/item/rogueweapon/mace/warhammer = 1,
		/obj/item/rogueweapon/stoneaxe/woodcut = 1,
		/obj/item/rogueweapon/stoneaxe/handaxe/copper = 2,
		/obj/item/rogueweapon/stoneaxe/handaxe = 1,
		/obj/item/rogueweapon/greataxe = 1,
	)

/obj/effect/spawner/lootdrop/steel_weapon_spawner
	name = "steel weapon spawner"
	icon_state = "steelweapon"
	lootcount = 1
	loot = list(
		/obj/item/rogueweapon/sword = 3,
		/obj/item/rogueweapon/sword/short/falchion = 1,
		/obj/item/rogueweapon/sword/falx = 1,
		/obj/item/rogueweapon/sword/decorated = 1,
		/obj/item/rogueweapon/sword/long = 1,
		/obj/item/rogueweapon/sword/short/messer = 1,
		/obj/item/rogueweapon/sword/sabre = 2,
		/obj/item/rogueweapon/sword/rapier = 1,
		/obj/item/rogueweapon/sword/cutlass = 3,
		/obj/item/rogueweapon/katar = 1,
		/obj/item/rogueweapon/katar/punchdagger = 1,
		/obj/item/rogueweapon/knuckles = 2,
		/obj/item/rogueweapon/estoc = 1,
		/obj/item/rogueweapon/woodstaff/quarterstaff/steel = 1,
		/obj/item/rogueweapon/spear/billhook = 1,
		/obj/item/rogueweapon/fishspear = 1,
		/obj/item/rogueweapon/halberd = 2,
		/obj/item/rogueweapon/halberd/glaive = 1,
		/obj/item/rogueweapon/eaglebeak = 1,
		/obj/item/rogueweapon/greatsword = 1,
		/obj/item/rogueweapon/huntingknife/combat = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 3,
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
		/obj/item/rogueweapon/huntingknife/throwingknife/steel = 1,
		/obj/item/rogueweapon/huntingknife/scissors/steel = 1,
		/obj/item/rogueweapon/flail/sflail = 3,
		/obj/item/rogueweapon/mace/warhammer/steel = 1,
		/obj/item/rogueweapon/mace/steel = 4,
		/obj/item/rogueweapon/mace/goden/steel = 1,
		/obj/item/rogueweapon/mace/steel/morningstar = 1,
		/obj/item/rogueweapon/greataxe/steel = 1,
		/obj/item/rogueweapon/greataxe/steel/doublehead = 1,
		/obj/item/rogueweapon/stoneaxe/battle = 1,
		/obj/item/rogueweapon/stoneaxe/woodcut/steel = 1,
	)

/obj/effect/spawner/lootdrop/silver_weapon_spawner //doesn't include psydonian or elven
	name = "silver weapon spawner"
	icon_state = "silverweapon"
	lootcount = 1
	loot = list(
		/obj/item/rogueweapon/sword/silver = 1,
		/obj/item/rogueweapon/mace/steel/silver = 1,
		/obj/item/rogueweapon/greataxe/silver = 1,
		/obj/item/rogueweapon/flail/sflail/silver = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver = 3,
		/obj/item/rogueweapon/mace/warhammer/steel/silver = 1,
		/obj/item/rogueweapon/stoneaxe/woodcut/silver = 1,
		/obj/item/rogueweapon/spear/silver = 1,
		/obj/item/rogueweapon/sword/long/silver = 1,
		/obj/item/rogueweapon/sword/long/kriegmesser/silver = 1,
		/obj/item/rogueweapon/sword/short/silver = 1,
		/obj/item/rogueweapon/sword/rapier/silver = 1,
		/obj/item/rogueweapon/whip/silver = 1,
		/obj/item/rogueweapon/woodstaff/quarterstaff/silver = 1,
	)

/obj/effect/spawner/lootdrop/decrepit_equipment_spawner
	name = "decrepit equipment spawner"
	icon_state = "dweapon/armor"
	lootcount = 1
	loot = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail/aalloy = 1,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/aalloy = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/aalloy = 1,
		/obj/item/clothing/shoes/roguetown/boots/aalloy = 1,
		/obj/item/clothing/shoes/roguetown/sandals/aalloy = 1,
		/obj/item/clothing/gloves/roguetown/plate/aalloy = 1,
		/obj/item/clothing/gloves/roguetown/chain/aalloy = 1,
		/obj/item/clothing/under/roguetown/platelegs/aalloy = 1,
		/obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy = 1,
		/obj/item/clothing/wrists/roguetown/bracers/aalloy = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/aalloy = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/guard/aalloy = 1,
		/obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy = 1,
		/obj/item/clothing/neck/roguetown/gorget/aalloy = 1,
		/obj/item/rogueweapon/sword/short/ashort = 1,
		/obj/item/rogueweapon/sword/short/gladius/agladius = 1,
		/obj/item/rogueweapon/sword/sabre/alloy = 1,
		/obj/item/rogueweapon/knuckles/aknuckles = 1,
		/obj/item/rogueweapon/spear/aalloy = 1,
		/obj/item/rogueweapon/halberd/bardiche/aalloy = 1,
		/obj/item/rogueweapon/greatsword/aalloy = 1,
		/obj/item/rogueweapon/huntingknife/idagger/adagger = 1,
		/obj/item/rogueweapon/huntingknife/throwingknife/aalloy = 1,
		/obj/item/rogueweapon/flail/aflail = 1,
		/obj/item/rogueweapon/mace/alloy = 1,
		/obj/item/rogueweapon/mace/goden/aalloy = 1,
		/obj/item/rogueweapon/mace/warhammer/alloy = 1,
		/obj/item/rogueweapon/stoneaxe/woodcut/aaxe = 1,
	)

/obj/effect/spawner/lootdrop/ancient_equipment_spawner
	name = "ancient equipment spawner"
	icon_state = "paweapon/armor"
	lootcount = 1
	loot = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail/paalloy = 1,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/paalloy = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/paalloy = 1,
		/obj/item/clothing/gloves/roguetown/plate/paalloy = 1,
		/obj/item/clothing/gloves/roguetown/chain/paalloy = 1,
		/obj/item/clothing/under/roguetown/platelegs/paalloy = 1,
		/obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy = 1,
		/obj/item/clothing/wrists/roguetown/bracers/paalloy = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/paalloy = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/guard/paalloy = 1,
		/obj/item/clothing/neck/roguetown/gorget/paalloy = 1,
		/obj/item/rogueweapon/sword/short/gladius/pagladius = 1,
		/obj/item/rogueweapon/sword/sabre/palloy = 1,
		/obj/item/rogueweapon/spear/paalloy = 1,
		/obj/item/rogueweapon/halberd/bardiche/paalloy = 1,
		/obj/item/rogueweapon/greatsword/paalloy = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/padagger = 1,
		/obj/item/rogueweapon/huntingknife/throwingknife/steel/palloy = 1,
		/obj/item/rogueweapon/mace/steel/palloy = 1,
		/obj/item/rogueweapon/mace/goden/steel/paalloy = 1,
		/obj/item/rogueweapon/mace/warhammer/steel/paalloy = 1,
		/obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe = 1,
	)

/obj/effect/spawner/lootdrop/elven_equipment_spawner
	name = "elven equipment spawner"
	icon_state = "eweapon/armor"
	lootcount = 1
	loot = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/elven = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/elven_plate = 1,
		/obj/item/clothing/shoes/roguetown/boots/leather/elven_boots = 1,
		/obj/item/clothing/gloves/roguetown/elven_gloves = 1,
		/obj/item/rogueweapon/sword/sabre/elf = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/elvish = 1,
		/obj/item/clothing/head/roguetown/helmet/sallet/elven = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm = 1,
		/obj/item/clothing/head/roguetown/helmet/elvenbarbute = 1,
		/obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged = 1,
	)

/obj/effect/spawner/lootdrop/blacksteel_equipment_spawner
	name = "blacksteel equipment spawner"
	icon_state = "bsweapon/armor"
	lootcount = 1
	loot = list(
		/obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/blacksteel = 1,
		/obj/item/clothing/shoes/roguetown/boots/blacksteel/plateboots = 1,
		/obj/item/clothing/gloves/roguetown/blacksteel/plategloves = 1,
		/obj/item/clothing/head/roguetown/helmet/blacksteel/bucket = 1,
		/obj/item/clothing/under/roguetown/platelegs/blacksteel = 1,
		/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel = 1,
	)
