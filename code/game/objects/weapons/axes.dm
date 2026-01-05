/obj/item/rogueweapon/greataxe/dreamscape
	force = 10
	force_wielded = 35
	name = "otherworldly axe"
	desc = "A strange axe, who knows where it came from. It feels cold and unusually heavy."
	icon_state = "dreamaxe"
	minstr = 13
	max_blade_int = 250
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = null
	associated_skill = /datum/skill/combat/axes
	blade_dulling = DULLING_BASHCHOP
	wdefense = 5
	item_flags = DREAM_ITEM
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/greataxe/dreamscape/active
	// to do, make this burn you if you don't regularly soak it.
	force = 15
	force_wielded = 40
	desc = "A strange axe, who knows where it came from. It is searing hot to the blade, the hilt is barely able to be held."
	icon_state = "dreamaxeactive"
	max_blade_int = 500
	wdefense = 6
