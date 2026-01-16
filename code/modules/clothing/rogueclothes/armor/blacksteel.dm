 //--------------- BLACKSTEEL ---------------------

/obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/modern
	name = "blacksteel plate armor"
	desc = "A magnificent set of blacksteel plate armor; the greatest triumph of sixteenth-century metallurgy, forged from the rarest of manmade alloys. It befits only the presence of Psydonia's most renowned - be they a hero, a lord, or a monster."
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplate"
	item_state = "bplate"
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	armor = ARMOR_PLATE_BSTEEL
	blocking_behavior = null
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel
	strip_delay = 6 SECONDS
	smelt_bar_num = 4
	chunkcolor = "#303036"

/obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel
	name = "ancient blacksteel plate armor"
	desc = "An antiquated set of blacksteel plate armor, from before Psydonia's blacksmiths had fully mastered the art of tempering such a coveted alloy. If you knew that todae was to be your last, would you've done anything different? Would you've communed with your friends and family, instead of loitering in a line and bickering about the specifics of steel-and-gold? </br>‎  </br>Cherish lyfe as it happens, or you will forever regret the memories you can no longer recall."
	body_parts_covered = COVERAGE_FULL
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bkarmor"
	item_state = "bkarmor"
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel
	chunkcolor = "#303036"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/blacksteel
	name = "blacksteel cuirass"
	desc = "A padded blacksteel cuirass; sleek, elegant, and mysterious."
	body_parts_covered = COVERAGE_TORSO
	icon_state = "grenzelcuirass"
	item_state = "grenzelcuirass"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2
	chunkcolor = "#303036"

/obj/item/clothing/suit/roguetown/armor/plate/blacksteel
	slot_flags = ITEM_SLOT_ARMOR
	name = "blacksteel half-plate"
	desc = "A padded blacksteel cuirass, fitted with sloped pauldrons and tassets. Mysterious and elegant, but most-certainly not sleek."
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bs_halfplate"
	item_state = "bs_halfplate"
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	nodismemsleeves = TRUE
	smeltresult = /obj/item/ingot/blacksteel
	chunkcolor = "#303036"
