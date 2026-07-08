/datum/crafting_recipe/roguetown/sewing
	abstract_type = /datum/crafting_recipe/roguetown/sewing
	display_category = ITEM_CAT_GARMENT_COMMON
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	subtype_reqs = TRUE		//For subtypes of fur

/* craftdif of 0 */

/datum/crafting_recipe/roguetown/sewing/headband
	name = "headband"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/headband)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/tiyon
	name = "tiyon"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/tiyon)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/longveil
	name = "long veil"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/longveil)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/durag
	name = "durag"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/durag)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/faceveil
	name = "face veil"
	category = "Masks"
	display_category = ITEM_CAT_CLOTH_MASK
	result = list(/obj/item/clothing/mask/rogue/faceveil)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/allwrappings
	name = "cloth wrappings"
	category = "Bracers"
	display_category = ITEM_CAT_ARMOR_BRACERS
	result = list(/obj/item/clothing/wrists/roguetown/allwrappings)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/peasantcap
	name = "cap"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/cap)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/apron_waist
	name = "apron"
	category = "Misc"
	result = list(/obj/item/clothing/cloak/apron/waist)
	reqs = list(/obj/item/natural/cloth = 3) // 3 because it thas a storage, but it really just a apron.
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/apron/cook
	name = "cooking apron"
	category = "Misc"
	result = list(/obj/item/clothing/cloak/apron/cook)
	reqs = list(/obj/item/natural/cloth = 3)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/apron/blacksmith
	name = "leather apron"
	category = "Misc"
	result = list(/obj/item/clothing/cloak/apron/blacksmith)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/hide/cured = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/rags
	name = "rags"
	category = "Misc"
	result = list(/obj/item/clothing/suit/roguetown/shirt/rags)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/burial_shroud
	name = "winding sheet"
	category = "Misc"
	result = list(/obj/item/burial_shroud)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/loincloth
	name = "loincloth"
	category = "Misc"
	result = list(/obj/item/clothing/under/roguetown/loincloth)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/brownloincloth
	name = "brown loincloth"
	category = "Misc"
	result = list(/obj/item/clothing/under/roguetown/loincloth/brown)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/linedanklet
	name = "cloth lined anklet"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_BOOTS
	result = list(/obj/item/clothing/shoes/roguetown/boots/clothlinedanklets)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/necramask
	name = "death mask, reassembled"
	category = "Masks"
	display_category = ITEM_CAT_CLOTH_MASK
	result = list(/obj/item/clothing/head/roguetown/necramask)
	reqs = list(/obj/item/clothing/head/roguetown/necrahood = 1,
				/obj/item/natural/bone = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/physmask
	name = "plague mask, physicker's"
	category = "Masks"
	display_category = ITEM_CAT_CLOTH_MASK
	result = list(/obj/item/clothing/mask/rogue/physician/phys)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/bouquet/calendula = 1,
				/obj/item/natural/bone = 1)
	craftdiff = 3
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/sewing/feldmask
	name = "plague mask, feldsher's"
	category = "Masks"
	display_category = ITEM_CAT_CLOTH_MASK
	result = list(/obj/item/clothing/mask/rogue/physician/feld)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/bouquet/calendula = 1,
				/obj/item/natural/bone = 1)
	craftdiff = 4
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/sewing/nurseveil
	name = "nurse's veil, improvised"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/veiled)
	tools = list(/obj/item/rogueweapon/huntingknife)
	reqs = list(
		/obj/item/tablecloth/silk = 1
	)
	craftdiff = 1
	sellprice = 5
	bypass_dupe_test = TRUE // Uses the tablecloth, a much rarer and valuable article, in lieu of cloth.

/* craftdif of 1 */

/datum/crafting_recipe/roguetown/sewing/clothgloves
	name = "fingerless gloves"
	category = "Gloves"
	result = list(/obj/item/clothing/gloves/roguetown/fingerless)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/clothbedsheet
	name = "bedsheet, cloth"
	category = "Misc"
	display_category = ITEM_CAT_TAILOR_MISC
	result = list(/obj/item/bedsheet/rogue/cloth)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/fabricbedsheet // cloth bedsheet's fancier looking cousin
	name = "bedsheet, fabric"
	category = "Misc"
	display_category = ITEM_CAT_TAILOR_MISC
	result = list(/obj/item/bedsheet/rogue/fabric)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/doublefabricbedsheet
	name = "bedsheet, double fabric"
	category = "Misc"
	display_category = ITEM_CAT_TAILOR_MISC
	result = list(/obj/item/bedsheet/rogue/fabric_double)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/brimmed
	name = "brimmed hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/brimmed)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/tunic
	name = "tunic"
	category = "Shirts"
	result = list(/obj/item/clothing/suit/roguetown/shirt/tunic/white)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/lowcut_shirt
	name = "low cut tunic"
	category = "Shirts"
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1,
	)
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut

/datum/crafting_recipe/roguetown/sewing/noblecoat
	name = "fancy coat"
	category = "Coats"
	display_category = ITEM_CAT_GARMENT_FINE
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
	reqs = list(/obj/item/natural/cloth = 3,
			/obj/item/natural/silk = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/shadowshirt
	name = "silk shirt"
	category = "Shirts"
	result = /obj/item/clothing/suit/roguetown/shirt/shadowshirt
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 3)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/clothshirt
	name = "shirt"
	category = "Shirts"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/clothtrou
	name = "work trousers"
	category = "Pants"
	result = list(/obj/item/clothing/under/roguetown/trou)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/longcoat
	name = "longcoat"
	category = "Coats"
	result = list(/obj/item/clothing/suit/roguetown/armor/longcoat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/workervest
	name = "striped tunic"
	category = "Shirts"
	result = list(/obj/item/clothing/suit/roguetown/armor/workervest)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/tights
	name = "tights"
	category = "Pants"
	result = list(/obj/item/clothing/under/roguetown/tights/random)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/clothhosen
	name = "cloth hosen"
	category = "Pants"
	result = list(/obj/item/clothing/under/roguetown/tights/hose)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/Reyepatch
	name = "right eye patch"
	category = "Misc"
	display_category = ITEM_CAT_CLOTH_MASK
	result = list(/obj/item/clothing/mask/rogue/eyepatch)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/Leyepatch
	name = "left eye patch"
	category = "Misc"
	display_category = ITEM_CAT_CLOTH_MASK
	result = list(/obj/item/clothing/mask/rogue/eyepatch/left)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/knitcap
	name = "knit cap"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/knitcap)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/strawhat
	name = "straw hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/strawhat)
	reqs = list(/obj/item/natural/fibers = 3)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/sack
	name = "sack hood"
	category = "Hoods"
	result = list(/obj/item/clothing/head/roguetown/menacing)
	reqs = list(/obj/item/natural/cloth = 3,)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/paddedmask
	name = "padded mask"
	category = "Hoods"
	result = list(/obj/item/clothing/mask/rogue/padded)
	reqs = list(/obj/item/natural/cloth = 3,)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/clothknapsack
	name = "cloth knapsack"
	category = "Container"
	result = /obj/item/storage/backpack/rogue/satchel/cloth
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 3)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/clothpouch
	name = "cloth pouch"
	category = "Container"
	result = /obj/item/storage/belt/rogue/pouch/cloth
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/lgambeson
	name = "light gambeson"
	category = "Gambesons"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/light)
	reqs = list(/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/lgambesonskirt
	name = "light gambesoned kilt"
	category = "Pants"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = list(/obj/item/clothing/under/roguetown/skirt/gambeson/light)
	reqs = list(/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/clothblindfold
	name = "blindfold"
	category = "Masks"
	display_category = ITEM_CAT_CLOTH_MASK
	result = list(/obj/item/clothing/mask/rogue/blindfold)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/duelmask
	name = "duelist's mask"
	category = "Masks"
	display_category = ITEM_CAT_CLOTH_MASK
	result = list(/obj/item/clothing/mask/rogue/duelmask)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/paddedcoif
	name = "padded coif"
	category = "Coifs"
	display_category = ITEM_CAT_ARMOR_NECK
	result = list(/obj/item/clothing/neck/roguetown/coif/padded)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/woolencollar
	name = "wool collar"
	category = "Coifs"
	display_category = ITEM_CAT_ARMOR_NECK
	result = list(/obj/item/clothing/neck/roguetown/collar/woolen)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/gbandages
	name = "bandages, gloved"
	category = "Gloves"
	result = list(/obj/item/clothing/gloves/roguetown/bandages)
	reqs = list(/obj/item/natural/cloth = 3)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/breechclothbelt
	name = "belt with breechcloth"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_BELTS
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/beltshawl
	name = "belt shawl"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_BELTS
	result = list(/obj/item/storage/belt/rogue/leather/beltshawl)
	reqs = list(
		/obj/item/natural/cloth = 3
	)
	craftdiff = 2


/datum/crafting_recipe/roguetown/sewing/breechclothbeltalt
	name = "belt with breechcloth, black"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_BELTS
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/blackbelt)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/breechclothbeltimprovised
	name = "belt with breechcloth, improvised"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_BELTS
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth)
	tools = list(/obj/item/rogueweapon/huntingknife)
	reqs = list(
		/obj/item/clothing/cloak/tabard = 1,
		/obj/item/storage/belt/rogue/leather = 1
	)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/breechclothbeltaltimprovised
	name = "belt with breechcloth, black, improvised"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_BELTS
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/blackbelt)
	tools = list(/obj/item/rogueweapon/huntingknife)
	reqs = list(
		/obj/item/clothing/cloak/tabard = 1,
		/obj/item/storage/belt/rogue/leather/black = 1
	)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/footwrap
	name = "bandages, ankles"
	category = ITEM_CAT_ARMOR_BOOTS
	result = list(/obj/item/clothing/shoes/roguetown/footwraps)
	reqs = list(/obj/item/natural/cloth = 3)
	craftdiff = 1

/* craftdif of 2+ */

/datum/crafting_recipe/roguetown/sewing/clothpaddedgloves
	name = "padded gloves"
	category = "Gloves"
	result = list(/obj/item/clothing/gloves/roguetown/cloth)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/wrappings
	name = "solar wrappings"
	category = "Gloves"
	display_category = ITEM_CAT_ARMOR_BRACERS
	result = list(/obj/item/clothing/wrists/roguetown/wrappings)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/nocwrappings
	name = "moon wrappings"
	category = "Gloves"
	display_category = ITEM_CAT_ARMOR_BRACERS
	result = list(/obj/item/clothing/wrists/roguetown/nocwrappings)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/nunveil
	name = "nun veil"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/nun)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/nunhabit
	name = "nun habit"
	category = "Shirts"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/nun)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/necramask
	name = "death mask"
	category = "Masks"
	display_category = ITEM_CAT_CLOTH_MASK
	result = list(/obj/item/clothing/head/roguetown/necramask)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/bone = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/bandage
	name = "bandages (sewing)"
	result = list(/obj/item/natural/cloth/bandage)
	reqs = list(/obj/item/natural/silk = 2,
				/obj/item/natural/cloth = 1)
	subtype_reqs = FALSE //so you cant continuously craft bandages from bandages

/datum/crafting_recipe/roguetown/sewing/gweightedbandagesalt
	name = "bandages into weighted bandages, gloved"
	category = "Gloves"
	result = list(/obj/item/clothing/gloves/roguetown/bandages/weighted)
	reqs = list(/obj/item/clothing/gloves/roguetown/bandages = 1,
				/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/gweightedbandages
	name = "weighted bandages, gloved"
	category = "Gloves"
	result = list(/obj/item/clothing/gloves/roguetown/bandages/weighted)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/coif
	name = "coif"
	category = "Coifs"
	display_category = ITEM_CAT_ARMOR_NECK
	result = list(/obj/item/clothing/neck/roguetown/coif)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/physcollar
	name = "collar, physicker's"
	category = "Coifs"
	display_category = ITEM_CAT_ARMOR_NECK
	result = list(/obj/item/clothing/neck/roguetown/collar/surgcollar)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/feldcollar
	name = "collar, feldsher's"
	category = "Coifs"
	display_category = ITEM_CAT_ARMOR_NECK
	result = list(/obj/item/clothing/neck/roguetown/collar/feldcollar)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/tabard
	name = "tabard"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stabard
	name = "surcoat"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stabardheavy
	name = "surcoat, overvestments"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard/crusader/heavy)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/toga
	name = "toga"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/toga)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/psydonold
	name = "tabard, psydonian devotee"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/devotee/psydon)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/psydon
	name = "tabard, psydonic"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/psydontabard/black)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/psydonhood
	name = "hood, psydonic"
	category = "Hoods"
	result = list(/obj/item/clothing/head/roguetown/roguehood/psydon/black)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/psydon
	name = "robe, psydonic"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/absolutionistrobe/black)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/psydoninq
	name = "tabard, psydonian orthodoxist"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/psydontabard)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/psydonhoodinq
	name = "hood, psydonian orthodoxist"
	category = "Hoods"
	result = list(/obj/item/clothing/head/roguetown/roguehood/psydon)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/astrata
	name = "tabard, astratan devotee"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/devotee/astrata)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/astratatemplar
	name = "tabard, astratan templar"
	result = list(/obj/item/clothing/cloak/templar/astratan)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/noc
	name = "tabard, noccian devotee"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/devotee/noc)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/dendor
	name = "tabard, dendorite devotee"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/devotee/dendor)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/necra
	name = "tabard, necran devotee"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/devotee/necra)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/necratemplar
	name = "tabard, necran templar"
	result = list(/obj/item/clothing/cloak/templar/necran)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/abyssor
	name = "tabard, abyssorian devotee"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/devotee/abyssor)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/abyssortemplar
	name = "tabard, abyssorite templar"
	result = list(/obj/item/clothing/cloak/tabard/abyssorite)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/malum
	name = "tabard, malumite devotee"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/devotee/malum)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/malumtemplar
	name = "tabard, malumite templar"
	result = list(/obj/item/clothing/cloak/templar/malumite)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/eora
	name = "tabard, eoran devotee"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/devotee/eora)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/eoratemplar
	name = "tabard, eoran templar"
	result = list(/obj/item/clothing/cloak/templar/eoran)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/pestra
	name = "tabard, pestran devotee"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/devotee/pestra)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/pestratemplar
	name = "tabard, pestran templar"
	result = list(/obj/item/clothing/cloak/templar/pestran)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/undividedclerictabard
	name = "tabard, undivided devotee"
	result = list(/obj/item/clothing/cloak/templar/undividedcleric)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/undividedclericcloak
	name = "cloak, undivided devotee"
	result = list(/obj/item/clothing/cloak/undividedcleric)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/undividedtemplar
	name = "tabard, undivided templar"
	result = list(/obj/item/clothing/cloak/templar/undivided)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/ravox
	name = "tabard, ravoxian devotee"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/devotee/ravox)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/ravoxtemplar
	name = "tabard, ravoxian templar"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/templar/ravox)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/ravoxgorget
	name = "gorget, ravoxian templar"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_NECK
	result = list(/obj/item/clothing/head/roguetown/roguehood/ravoxgorget)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/xylix
	name = "tabard, xylixian devotee"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/devotee/xylix)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/xylixian
	name = "tabard, xylixian templar"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/templar/xylixian)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/battlenun
	name = "tabard, battle-nun"
	result = list(/obj/item/clothing/cloak/battlenun)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

//

/datum/crafting_recipe/roguetown/sewing/surcoatgold
	name = "surcoat of the golden order"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard/crusader)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/surcoatsilver
	name = "surcoat of the silver order"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard/crusader/t)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/surcoatgoldast
	name = "surcoat of the golden order, astratan"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard/crusader/astrata)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/surcoatsilverast
	name = "surcoat of the silver order, astratan"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard/crusader/t/astrata)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/surcoatgolduni
	name = "surcoat of the golden order, undivided"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard/crusader/undivided)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/surcoatsilveruni
	name = "surcoat of the silver order, undivided"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard/crusader/t/undivided)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/surcoatblacksteel
	name = "surcoat of the blacksteel order"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard/crusader/bsteel)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	tools = list(/obj/item/needle, /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader/blacksteel)

/datum/crafting_recipe/roguetown/sewing/surcoatgoldlegacy
	name = "ancient surcoat of the golden order"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard/crusader/legacy)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/surcoatsilverlegacy
	name = "ancient surcoat of the silver order"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard/crusader/t/legacy)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

//

/datum/crafting_recipe/roguetown/sewing/stabard/guard
	name = "surcoat, guard"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard/guard)

/datum/crafting_recipe/roguetown/sewing/stabard/bog
	name = "surcoat, bog"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard/bog)

/datum/crafting_recipe/roguetown/sewing/stabard/guardhood
	name = "guard hood"
	category = "Tabards"
	result = list(/obj/item/clothing/cloak/tabard/stabard/guardhood)

/datum/crafting_recipe/roguetown/sewing/poncho
	name = "cloth poncho"
	category = "Cloaks"
	result = /obj/item/clothing/cloak/poncho
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/robe
	name = "robe"
	category = "Robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/jesterchest
	name = "jester's tunick"
	category = "Shirts"
	result = list(/obj/item/clothing/suit/roguetown/shirt/jester)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/jesterhead
	name = "jester's hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/jester)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/jingle_bells = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/jestershoes
	name = "jester's shoes"
	category = "Misc"
	result = list(/obj/item/clothing/shoes/roguetown/jester)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/jingle_bells = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/bardress
	name = "bar dress"
	category = "Dresses"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/stockdress
	name = "dress"
	category = "Dresses"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

//datum/crafting_recipe/roguetown/sewing/Bladress
//	name = "black dress"
//	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/black)
//	reqs = list(/obj/item/natural/cloth = 3,
//				/obj/item/natural/fibers = 1)
//	craftdiff = 4

//datum/crafting_recipe/roguetown/sewing/Bludress
//	name = "blue dress"
//	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/blue)
//	reqs = list(/obj/item/natural/cloth = 3,
//				/obj/item/natural/fibers = 1)
//	craftdiff = 4

//datum/crafting_recipe/roguetown/sewing/Purdress
//	name = "purple dress"
//	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/purple)
//	reqs = list(/obj/item/natural/cloth = 3,
//				/obj/item/natural/fibers = 1)
//	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/slitdress
	name = "slitted dress"
	category = "Dresses"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/slit)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/fancyhat
	name = "fancy hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/fancyhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/larmingjacket
	name = "light arming jacket" //its a gambeson without leg cover
	category = "Gambesons"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/lord/light
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 2 //because if it was 3, you'd just make the proper arming jacket

/datum/crafting_recipe/roguetown/sewing/gambeson
	name = "gambeson"
	category = "Gambesons"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = /obj/item/clothing/suit/roguetown/armor/gambeson
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/gambesonskirt
	name = "gambesoned kilt"
	category = "Pants"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = /obj/item/clothing/under/roguetown/skirt/gambeson
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/paddedchausses
	name = "padded chausses"
	category = "Pants"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = list(/obj/item/clothing/under/roguetown/tights/clothlegs)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/paddedchaussesalt
	name = "padded chausses, alternate"
	category = "Pants"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = list(/obj/item/clothing/under/roguetown/tights/clothlegs)
	reqs = list(/obj/item/clothing/under/roguetown/tights/hose = 1,
				/obj/item/clothing/under/roguetown/trou/leather = 1,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 20
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/sewing/armingjacket
	name = "arming jacket"
	category = "Gambesons"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 3)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/armingcap
	name = "arming cap"
	category = "Hats"
	display_category = ITEM_CAT_ARMOR_HELMETS
	result = /obj/item/clothing/head/roguetown/armingcap
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 3)
	tools = list(/obj/item/needle)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/paddedcap
	name = "padded arming cap"
	category = "Hats"
	display_category = ITEM_CAT_ARMOR_HELMETS
	result = /obj/item/clothing/head/roguetown/armingcap/padded
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 5)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/bardhat
	name = "bard hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/bardhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/bucklehat
	name = "folded hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/bucklehat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/puritanhat
	name = "puritan's buckled hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/puritan)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/nurseveil
	name = "nurse's veil"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/veiled)
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1
	)
	craftdiff = 2
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/hgambeson/fencer
	name = "fencing shirt"
	category = "Gambesons"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = /obj/item/clothing/suit/roguetown/shirt/freifechter
	reqs = list(/obj/item/natural/cloth = 5,
				/obj/item/natural/fibers = 2)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/archer
	name = "archer cap"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/archercap)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/duelist
	name = "duelist hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/duelhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/witchhat
	name = "witch hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/witchhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/hgambeson
	name = "padded gambeson"
	category = "Gambesons"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 4)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/hgambesonskirt
	name = "padded gambesoned kilt"
	category = "Pants"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = list(/obj/item/clothing/under/roguetown/skirt/gambeson/heavy)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 4)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/harmingjacket
	name = "padded arming jacket"
	category = "Gambesons"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/lord/heavy)
	reqs = list(/obj/item/natural/cloth = 5,
				/obj/item/natural/fibers = 5)
	craftdiff = 4 //highest possible light-armor integ on a shirt layer, so should take some work

/datum/crafting_recipe/roguetown/sewing/monkwraps
	name = "padded arm wrappings"
	category = "Bracers"
	display_category = ITEM_CAT_ARMOR_BRACERS
	result = list(/obj/item/clothing/wrists/roguetown/bracers/cloth/monk)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 4)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/hunterheadband
	name = "roughspun headband"
	category = "Coifs"
	display_category = ITEM_CAT_ARMOR_HELMETS
	result = list(/obj/item/clothing/head/roguetown/headband/monk/barbarian)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/monkheadband
	name = "padded headband"
	category = "Coifs"
	display_category = ITEM_CAT_ARMOR_HELMETS
	result = list(/obj/item/clothing/head/roguetown/headband/monk)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 4)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/heavypadded
	name = "heavy padded coif"
	category = "Coifs"
	display_category = ITEM_CAT_ARMOR_NECK
	result = list(/obj/item/clothing/neck/roguetown/coif/heavypadding)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/chaperon
	name = "chaperon hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/chaperon)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/chaperon/noble
	name = "noble's chaperon"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/chaperon/noble)
	reqs = list(/obj/item/natural/cloth = 4,
                /obj/item/natural/fibers = 2)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/jupon
	name = "jupon"
	category = "Cloaks"
	result = list(/obj/item/clothing/cloak/tabard/stabard/surcoat)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/jupon_short
	name = "short jupon"
	category = "Cloaks"
	result = list(/obj/item/clothing/cloak/tabard/stabard/surcoat/short)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/cotehardie
	name = "fitted coat"
	category = "Cloaks"
	result = list(/obj/item/clothing/cloak/cotehardie)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/hide/cured = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/armordress
	name = "padded dress"
	category = "Dresses"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = list(/obj/item/clothing/suit/roguetown/armor/armordress)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/hide/cured = 1)
	craftdiff = 3
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/ragmask
	name = "rag mask"
	category = "Masks"
	display_category = ITEM_CAT_CLOTH_MASK
	result = list(/obj/item/clothing/mask/rogue/ragmask)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0
	sellprice = 3

/datum/crafting_recipe/roguetown/sewing/cape
	name = "cape"
	category = "Cloaks"
	result = list(/obj/item/clothing/cloak/cape)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/sexydress
	name = "sheer dress"
	category = "Dresses"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 3)
	craftdiff = 5
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/wizhatblue
	name = "blue wizard hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/wizhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/wizhatred
	name = "red wizard hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/wizhat/red)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/wizhatyellow
	name = "yellow wizard hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/wizhat/yellow)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/wizhatgreen
	name = "green wizard hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/wizhat/green)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/wizhatblack
	name = "black wizard hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/wizhat/black)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/cape/desert
	name = "desert cape"
	category = "Cloaks"
	result = list(/obj/item/clothing/cloak/cape/crusader)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/cape/goldenorder
	name = "cape, golden order"
	category = "Cloaks"
	result = list(/obj/item/clothing/cloak/cape/inquisitorgold)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/cape/silverorder
	name = "cape, silver order"
	category = "Cloaks"
	result = list(/obj/item/clothing/cloak/cape/inquisitorsilver)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/cape/rider
	name = "rider cloak"
	category = "Cloaks"
	result = list(/obj/item/clothing/cloak/half/rider)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/cape/half
	name = "half cloak"
	category = "Cloaks"
	result = list(/obj/item/clothing/cloak/half)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/undervestments
	name = "undervestments"
	category = "Misc"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/priest)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/basichood
	name = "hood"
	category = "Hoods"
	result = list(/obj/item/clothing/head/roguetown/roguehood)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/keffiyeh
	name = "keffiyeh"
	category = "Hoods"
	result = list(/obj/item/clothing/head/roguetown/roguehood/shalal)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/hijab
	name = "hijab"
	category = "Hoods"
	result = list(/obj/item/clothing/head/roguetown/roguehood/shalal/hijab)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/heavyhood
	name = "heavy hood"
	category = "Hoods"
	result = list(/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/royalgown
	name = "royal gown"
	category = "Shirts"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/royal)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 3)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 45

/datum/crafting_recipe/roguetown/sewing/royaldress
	name = "pristine dress"
	category = "Dresses"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/royal/princess)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/royalshirt
	name = "gilded dress shirt"
	category = "Shirts"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/royal/prince)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/formalsilks
	name = "formal silks"
	category = "Shirts"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/formalbreeches
	name = "formal breeches"
	category = "Pants"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list(/obj/item/clothing/under/roguetown/tights/puritan)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/formalsilkjacket
	name = "besilked jacket"
	category = "Shirts"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/lord/heavy/silkjacket)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 6)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/regalrobes
	name = "regal silks"
	category = "Shirts"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list(/obj/item/clothing/suit/roguetown/shirt/vampire)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/silktunic
	name = "ornate silk tunic"
	category = "Shirts"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list(/obj/item/clothing/suit/roguetown/shirt/tunic/silktunic)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 25

/datum/crafting_recipe/roguetown/sewing/silkdress
	name = "ornate silk dress"
	category = "Dresses"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/archivist
	name = "archivist's robes"
	category = "Robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/archivist)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 25

/datum/crafting_recipe/roguetown/sewing/apothshirt
	name = "apothecary shirt"
	category = "Shirts"
	result = list(/obj/item/clothing/suit/roguetown/shirt/apothshirt)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/artificer
	name = "tinker doublet"
	category = "Shirts"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/winterdress
	name = "winter dress"
	category = "Dresses"
	result = list(/obj/item/clothing/suit/roguetown/armor/armordress/winterdress)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 25

/datum/crafting_recipe/roguetown/sewing/skirt
	name = "skirt"
	category = "Misc"
	result = list(/obj/item/clothing/under/roguetown/skirt)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 10

/datum/crafting_recipe/roguetown/sewing/desert_skirt
	name = "desert skirt"
	category = "Misc"
	result = list(/obj/item/clothing/under/roguetown/skirt/desert)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/sailorspants
	name = "sailor's pants"
	category = "Pants"
	result = list(/obj/item/clothing/under/roguetown/tights/sailor)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/shadowpants
	name = "silk tights"
	category = "Pants"
	result = list(/obj/item/clothing/under/roguetown/trou/shadowpants)
	reqs = list(/obj/item/natural/cloth = 2,
	            /obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 18

/datum/crafting_recipe/roguetown/sewing/apothpants
	name = "apothecary trousers"
	category = "Pants"
	result = list(/obj/item/clothing/under/roguetown/trou/apothecary)
	reqs = list(/obj/item/natural/cloth = 2,
	            /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/royalsleeves
	name = "royal sleeves"
	category = "Misc"
	result = list(/obj/item/clothing/wrists/roguetown/royalsleeves)
	reqs = list(/obj/item/natural/cloth = 1,
	            /obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 19

/datum/crafting_recipe/roguetown/sewing/nemes
	name = "nemes"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/headdress)
	reqs = list(/obj/item/natural/cloth = 2,
	            /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 10

/datum/crafting_recipe/roguetown/sewing/hatfur
	name = "fur hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/hatfur)
	reqs = list(/obj/item/natural/cloth = 1,
	            /obj/item/natural/fibers = 1,
				/obj/item/natural/fur = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/shawl
	name = "shawl"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/shawl)
	reqs = list(/obj/item/natural/cloth = 1)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/articap
	name = "artificer's cap"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/articap)
	reqs = list(/obj/item/natural/cloth = 1,
	            /obj/item/natural/fibers = 1,
				/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/lordlycloak
	name = "lordly cloak"
	category = "Cloaks"
	result = list(/obj/item/clothing/cloak/lordcloak)
	reqs = list(/obj/item/natural/cloth = 3,
	            /obj/item/natural/fibers = 2,
				/obj/item/natural/fur = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 35

/datum/crafting_recipe/roguetown/sewing/ladycloak
	name = "ladylike shortcloak"
	category = "Cloaks"
	result = list(/obj/item/clothing/cloak/lordcloak/ladycloak)
	reqs = list(/obj/item/natural/cloth = 2,
	            /obj/item/natural/fibers = 2,
			    /obj/item/natural/silk = 2,
				/obj/item/natural/fur = 1)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/furovercoat
	name = "fur overcoat"
	category = "Cloaks"
	result = list(/obj/item/clothing/cloak/black_cloak)
	reqs = list(/obj/item/natural/cloth = 3,
	            /obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 1,
				/obj/item/natural/fur = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 22

/datum/crafting_recipe/roguetown/sewing/guildedjacket
	name = "guilder jacket"
	category = "Robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/merchant)
	reqs = list(/obj/item/natural/cloth = 3,
	            /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 19

/datum/crafting_recipe/roguetown/sewing/buttonedlongcoat
	name = "plague coat"
	category = "Robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/physician)
	reqs = list(/obj/item/natural/cloth = 3,
	            /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/sleevelessrobephys
	name = "physicker's robe"
	category = "Robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/phys)
	reqs = list(/obj/item/natural/cloth = 3,
	            /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/sleevelessrobefeld
	name = "feldsher's robe"
	category = "Robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/feld)
	reqs = list(/obj/item/natural/cloth = 3,
	            /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/sleevelessrobewhite
	name = "robed tabard"
	category = "Robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/tabardwhite)
	reqs = list(/obj/item/natural/cloth = 3,
	            /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/hoodphys
	name = "physicker's hood"
	category = "Hoods"
	result = list(/obj/item/clothing/head/roguetown/roguehood/phys)
	reqs = list(/obj/item/natural/cloth = 2,
	            /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/hoodfeld
	name = "feldsher's hood"
	category = "Hoods"
	result = list(/obj/item/clothing/head/roguetown/roguehood/feld)
	reqs = list(/obj/item/natural/cloth = 2,
	            /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/hoodwhite
	name = "robed tabard's hood"
	category = "Hoods"
	result = list(/obj/item/clothing/head/roguetown/roguehood/shroudwhite)
	reqs = list(/obj/item/natural/cloth = 2,
	            /obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/weddingdress
	name = "wedding silk dress"
	category = "Dresses"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/weddingdress)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2,
				/obj/item/alch/golddust = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 40

/datum/crafting_recipe/roguetown/sewing/silkydress
	name = "silky dress"
	category = "Dresses"
	display_category = ITEM_CAT_GARMENT_FINE
	result = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 3)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 50

/datum/crafting_recipe/roguetown/sewing/weaving/springgown
	name = "gown (spring)"
	category = "Dresses"
	display_category = ITEM_CAT_GARMENT_FINE
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 4)
	craftdiff = 6
	sellprice = 85

/datum/crafting_recipe/roguetown/sewing/weaving/summergown
	name = "gown (summer)"
	category = "Dresses"
	display_category = ITEM_CAT_GARMENT_FINE
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown
	reqs = list(/obj/item/natural/fibers = 2,
				/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 3)
	craftdiff = 6
	sellprice = 70

/datum/crafting_recipe/roguetown/sewing/weaving/fallgown
	name = "gown (fall, silk)"
	category = "Dresses"
	display_category = ITEM_CAT_GARMENT_FINE
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown/fallgown
	reqs = list(/obj/item/natural/fibers = 3,
				/obj/item/natural/silk = 2,
				/obj/item/natural/cloth = 2)
	craftdiff = 6
	sellprice = 75

/datum/crafting_recipe/roguetown/sewing/weaving/wintergown
	name = "gown (winter)"
	category = "Dresses"
	display_category = ITEM_CAT_GARMENT_FINE
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown
	reqs = list(/obj/item/natural/fibers = 3,
				/obj/item/natural/silk = 2,
				/obj/item/natural/fur = 1)
	craftdiff = 6
	sellprice = 90

/datum/crafting_recipe/roguetown/sewing/silkbra
	name = "giltsilk bra"
	category = "Misc"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list (/obj/item/clothing/suit/roguetown/shirt/silkbra)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/desertbra
	name = "desert bra"
	result = list (/obj/item/clothing/suit/roguetown/shirt/desertbra)
	reqs = list(/obj/item/natural/fibers = 5)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/anklets
	name = "giltsilk anklets"
	aliases = "golden anklets"
	category = "Misc"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list (/obj/item/clothing/shoes/roguetown/anklets)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/silkbelt
	name = "giltsilk belt"
	category = "Misc"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list (/obj/item/storage/belt/rogue/leather/silkbelt)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/silkmask
	name = "giltsilk mask"
	category = "Masks"
	display_category = ITEM_CAT_GARMENT_FINE
	result = list (/obj/item/clothing/mask/rogue/silkmask)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/strapless_dress
	name = "strapless dress"
	category = "Dresses"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/strapless_dress_alt
	name = "strapless dress alt"
	category = "Dresses"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/alt)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/spellsingerrobes
	name = "spellsinger robes"
	category = "Robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe)
	reqs = list(/obj/item/natural/cloth = 6,
	            /obj/item/natural/fibers = 4,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/spellsingerhat
	name = "spellsinger hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/spellcasterhat)
	reqs = list(/obj/item/natural/cloth = 1,
	            /obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/beekeeper
	name = "beekeeper's hood"
	category = "Hoods"
	result = list(/obj/item/clothing/head/roguetown/beekeeper)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 4)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/bandithood
	name = "free man's shroud"
	category = "Masks"
	result = list(/obj/item/clothing/head/roguetown/menacing/bandit)
	reqs = list(/obj/item/natural/cloth = 3)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/battleskirt
	name = "cloth military skirt"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_BELTS
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/fauldedbelt
	name = "belt with faulds"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_BELTS
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/faulds)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/breechclothbelt
	name = "belt with breechcloth"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_BELTS
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/breechclothbeltalt
	name = "belt with breechcloth, black"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_BELTS
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/blackbelt)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/breechclothbeltimprovised
	name = "belt with breechcloth, improvised"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_BELTS
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth)
	tools = list(/obj/item/rogueweapon/huntingknife)
	reqs = list(
		/obj/item/clothing/cloak/tabard = 1,
		/obj/item/storage/belt/rogue/leather = 1
	)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/breechclothbeltaltimprovised
	name = "belt with breechcloth, black, improvised"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_BELTS
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/blackbelt)
	tools = list(/obj/item/rogueweapon/huntingknife)
	reqs = list(
		/obj/item/clothing/cloak/tabard = 1,
		/obj/item/storage/belt/rogue/leather/black = 1
	)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/maiddress
	name = "maid dress"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/maid)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/maidhead
	name = "maid headband"
	result = list(/obj/item/clothing/head/roguetown/maidhead)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/maidapron
	name = "maid apron"
	result = list(/obj/item/clothing/cloak/apron/waist/maid)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/maidsash
	name = "maid sash"
	display_category = ITEM_CAT_ARMOR_BELTS
	result = list(/obj/item/storage/belt/rogue/leather/sash/maid)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 2

//---deployable carpets

/datum/crafting_recipe/roguetown/sewing/standardcarpet
	name = "Standard Carpet (6 use)"
	category = "Misc"
	display_category = ITEM_CAT_DECORATION
	result = list(/obj/item/carpet/standard)
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/silk = 4
	)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/exoticcarpet
	name = "Exotic Carpet (1 use)"
	category = "Misc"
	display_category = ITEM_CAT_DECORATION
	result = list(/obj/item/carpet/exotic)
	reqs = list(/obj/item/natural/silk = 4)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 5

// -- caparisons

/datum/crafting_recipe/roguetown/sewing/caparison
	name = "caparison"
	display_category = ITEM_CAT_ARMOR_BARDING
	result = list(/obj/item/caparison)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/caparison/psy
	name = "psydonite caparison"
	display_category = ITEM_CAT_ARMOR_BARDING
	result = list(/obj/item/caparison/psy)

/datum/crafting_recipe/roguetown/sewing/caparison/astrata
	name = "astratan caparison"
	display_category = ITEM_CAT_ARMOR_BARDING
	result = list(/obj/item/caparison/astrata)

/datum/crafting_recipe/roguetown/sewing/caparison/eora
	name = "eoran caparison"
	display_category = ITEM_CAT_ARMOR_BARDING
	result = list(/obj/item/caparison/eora)

/datum/crafting_recipe/roguetown/sewing/caparison/fogbeast
	name = "fogbeast caparison"
	display_category = ITEM_CAT_ARMOR_BARDING
	result = list(/obj/item/caparison/fogbeast)

// -- barding

/datum/crafting_recipe/roguetown/sewing/barding
	name = "padded barding (saiga)"
	category = "Misc"
	display_category = ITEM_CAT_ARMOR_BARDING
	result = list(/obj/item/clothing/barding)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/barding/fogbeast
	name = "padded barding (fogbeast)"
	display_category = ITEM_CAT_ARMOR_BARDING
	result = list(/obj/item/clothing/barding/fogbeast)

/datum/crafting_recipe/roguetown/sewing/sanguinetrousers
	name = "sanguine trousers"
	result = /obj/item/clothing/under/roguetown/trou/leather/courtphysician
	reqs = list(
		/obj/item/natural/silk = 3
	)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/sanguinevest
	name = "sanguine vest"
	result = /obj/item/clothing/suit/roguetown/shirt/courtphysician
	reqs = list(
		/obj/item/natural/silk = 3
	)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/sanguineblouse
	name = "sanguine blouse"
	result = /obj/item/clothing/suit/roguetown/shirt/courtphysician/female
	reqs = list(
		/obj/item/natural/silk = 3
	)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/sanguineskirt
	name = "sanguine skirt"
	result = /obj/item/clothing/under/roguetown/skirt/courtphysician
	reqs = list(
		/obj/item/natural/silk = 3
	)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/sanguinehat
	name = "sanguine hat"
	result = /obj/item/clothing/head/roguetown/courtphysician
	reqs = list(
		/obj/item/natural/silk = 2
	)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/sanguinecap
	name = "sanguine cap"
	result = /obj/item/clothing/head/roguetown/courtphysician/female
	reqs = list(
		/obj/item/natural/silk = 2
	)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/paperparasol
	name = "paper parasol"
	result = list(/obj/item/rogueweapon/mace/parasol)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2,
				/obj/item/paper/scroll = 3)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/fineparasol
	name = "fine parasol"
	result = list(/obj/item/rogueweapon/mace/parasol/noble)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 4,
				/obj/item/paper/scroll = 2)
	craftdiff = 5
	sellprice = 45

/////////////////////////////////
// LOCKED RECIPES BEHIND BOOKS //
/////////////////////////////////

/datum/crafting_recipe/roguetown/sewing/tailor
	always_availible = FALSE

/datum/crafting_recipe/roguetown/sewing/tailor/naledisash
	name = "hierophant's sash"
	category = "Cloaks"
	result = list(/obj/item/clothing/cloak/hierophant)
	reqs = list(/obj/item/natural/cloth = 2,
	            /obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/tailor/halfrobe
	name = "hierophant's shawl"
	category = "Gambesons"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant)
	reqs = list(/obj/item/natural/cloth = 6,
	            /obj/item/natural/fibers = 5)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/tailor/monkrobe
	name = "pontifex's qaba"
	category = "Robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/pointfex)
	reqs = list(/obj/item/natural/cloth = 6,
	            /obj/item/natural/fibers = 5)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/tailor/desertgown
	name = "hierophant's kandys"
	category = "Robes"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/hierophant)
	reqs = list(/obj/item/natural/cloth = 6,
	            /obj/item/natural/fibers = 4)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 17

/datum/crafting_recipe/roguetown/sewing/tailor/otavangambeson
	name = "otavan gambeson"
	category = "Gambesons"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan)
	reqs = list(/obj/item/natural/cloth = 6,
	            /obj/item/natural/fibers = 5)
	tools = list(/obj/item/needle)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/tailor/grenzelhat
	name = "grenzelhoftian hat"
	category = "Hats"
	result = list(/obj/item/clothing/head/roguetown/grenzelhofthat)
	reqs = list(/obj/item/natural/cloth = 1,
	            /obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/tailor/grenzelshirt
	name = "grenzelhoftian hip-shirt"
	category = "Shirts"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 4,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/tailor/grenzelpants
	name = "grenzelhoftian paumpers"
	category = "Pants"
	display_category = ITEM_CAT_ARMOR_LEGS
	result = list(/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 25

/* uniquely-skilled subrecipes */
/datum/crafting_recipe/roguetown/sewing/astratahoodstonekeep
	name = "turn sun hood into sunwrought visage"
	category = "Misc"
	result = list(/obj/item/clothing/head/roguetown/roguehood/astrata/stonekeep)
	reqs = list(
		/obj/item/clothing/head/roguetown/roguehood/astrata = 1,
		/obj/item/clothing/mask/rogue/facemask/goldmask = 1
	)
	skillcraft = /datum/skill/magic/holy //Uniquely requires a Holy skill to craft, to encourage its stricter use amongst Acolytes and Clerics.
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/astratahoodstonekeepalt
	name = "turn sun hood into sunwrought visage"
	category = "Misc"
	result = list(/obj/item/clothing/head/roguetown/roguehood/astrata/stonekeep)
	reqs = list(
		/obj/item/clothing/head/roguetown/roguehood/astrata = 1,
		/obj/item/clothing/mask/rogue/facemask/goldmaskc = 1
	)
	skillcraft = /datum/skill/magic/holy
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/astratahoodstonekeeptri
	name = "turn sun hood into sunwrought visage"
	category = "Misc"
	result = list(/obj/item/clothing/head/roguetown/roguehood/astrata/stonekeep)
	reqs = list(
		/obj/item/clothing/head/roguetown/roguehood/astrata = 1,
		/obj/item/clothing/mask/rogue/facemask/goldmask/triumph = 1
	)
	skillcraft = /datum/skill/magic/holy
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/astratahoodstonekeeptrialt
	name = "turn sun hood into sunwrought visage"
	category = "Misc"
	result = list(/obj/item/clothing/head/roguetown/roguehood/astrata/stonekeep)
	reqs = list(
		/obj/item/clothing/head/roguetown/roguehood/astrata = 1,
		/obj/item/clothing/mask/rogue/facemask/goldmaskc/triumph = 1
	)
	skillcraft = /datum/skill/magic/holy
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/maidband
	name = "valorian maid headband"
	result = list(/obj/item/clothing/head/roguetown/maidband)
	reqs = list(
		/obj/item/natural/cloth = 1,
		/obj/item/natural/fibers = 2
	)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/maiddress
	name = "valorian maid dress"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/maidfancy)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/fibers = 2
	)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/maidapron
	name = "valorian maid apron"
	result = list(/obj/item/clothing/cloak/apron/waist/fancymaid)
	reqs = list(
		/obj/item/natural/cloth = 1,
		/obj/item/natural/fibers = 1
	)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/formalshirt
	name = "formal shirt"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/formal)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/fibers = 2
	)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/trousershorts
	name = "trouser shorts"
	result = list(/obj/item/clothing/under/roguetown/tights/shorts)
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 2
	)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/servantdress
	name = "servant gown"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/maidservant)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/fibers = 2
	)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/formaltrousers
	name = "formal trousers"
	result = list(/obj/item/clothing/under/roguetown/tights/formalfancy)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/fibers = 2
	)
	craftdiff = 4
	category = "Pants"
/datum/crafting_recipe/roguetown/sewing/velvetdress
	name = "velvet dress"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/velvetdress)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/fibers = 2
	)
	craftdiff = 3
/datum/crafting_recipe/roguetown/sewing/noble
	name = "noble's pinafore"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/nobledress)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/fibers = 2
	)
	craftdiff = 3
