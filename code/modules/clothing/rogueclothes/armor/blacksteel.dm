 //--------------- BLACKSTEEL ---------------------

/obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/modern
	name = "blacksteel plate armor"
	desc = "A magnificent set of blacksteel plate armor; the greatest triumph of sixteenth-century metallurgy, forged from the rarest of manmade alloys. It befits only the presence of Psydonia's most renowned - be they a hero, a lord, or a monster."
	icon_state = "bplate"
	item_state = "bplate"

/obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel
	name = "ancient blacksteel plate armor"
	desc = "An antiquated set of blacksteel plate armor, from before Psydonia's blacksmiths had fully mastered the art of tempering such a coveted alloy. If you knew that todae was to be your last, would you've done anything different? Would you've communed with your friends and family, instead of loitering in a line and bickering about the specifics of steel-and-gold? </br>  </br>Cherish lyfe as it happens, or you will forever regret the memories you can no longer recall."
	icon_state = "bkarmor"
	item_state = "bkarmor"
	blocking_behavior = null
	equip_delay_self = 6 SECONDS
	unequip_delay_self = 6 SECONDS
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	chunkcolor = "#303036"
	smeltresult = /obj/item/ingot/blacksteel
	smelt_bar_num = 3

/obj/item/clothing/suit/roguetown/armor/plate/blacksteel/modern
	name = "blacksteel half-plate"
	desc = "A masterfully tempered blacksteel cuirass; a refined triumph of Psydonia's later metallurgists. Sloped pauldrons grant its bearer both dignity and dread presence upon the field."
	icon_state = "bhalfplate"
	item_state = "bhalfplate"

/obj/item/clothing/suit/roguetown/armor/plate/blacksteel
	name = "ancient blacksteel half-plate"
	desc = "An antiquated blacksteel cuirass, forged in an age when Psydonia's smiths still wrestled with the temperament of this jealous alloy. It's weight settles heavy upon the shoulders, and its pauldrons slope like a knight bowing to fate."
	body_parts_covered = COVERAGE_ALL_BUT_HANDLEGS
	icon_state = "bkhalfarmor"
	item_state = "bkhalfarmor"
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel
	chunkcolor = "#303036"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/blacksteel
	name = "blacksteel cuirass"
	desc = "A padded blacksteel cuirass; sleek, elegant, and mysterious."
	icon_state = "bcuirass"
	item_state = "bcuirass"
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel
	smelt_bar_num = 2
	chunkcolor = "#303036"
