/obj/item/clothing/gloves/roguetown/chain
	name = "chain gauntlets"
	desc = "Gauntlets made of interlinked steel rings. They offer decent protection against common weaponries, except for arrows."
	icon_state = "cgloves"
	armor = ARMOR_MAILLE
	resistance_flags = FIRE_PROOF
	blocksound = CHAINHIT
	max_integrity = ARMOR_INT_SIDE_STEEL
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	unarmed_bonus = 1.15

/obj/item/clothing/gloves/roguetown/chain/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/gloves/roguetown/chain/aalloy
	name = "decrepit chain gauntlets"
	desc = "Frayed bronze rings, interlinked together to form sagging mittens. Fingers, talons, claws; they're all the same, when smothered beneath maille and left to rot away."
	icon_state = "acgloves"
	max_integrity = ARMOR_INT_SIDE_DECREPIT
	color = "#bb9696"
	chunkcolor = "#532e25"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/gloves/roguetown/chain/paalloy
	name = "ancient chain gauntlets"
	desc = "Polished gilbranze rings, delicately daisy-chained together into mittens. The filament is ruptured, and it will never heal; Zizo's ascension made sure of that. By the hands of Her disciples, the final obstacle preventing this world's salvation shall be dismantled - lyfe."
	icon_state = "acgloves"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/gloves/roguetown/chain/psydon
	name = "psydonic chain-wrapped gloves"
	desc = "Blacksteel-bound gauntlets. These ritualistic restraints, when left to dangle-and-sway, assist in the deflection of unpredictable blows. </br>I can adjust these chains to solely hang from my wrists, rather than having them wound across my arms."
	icon_state = "psydongloveschain"
	item_state = "psydongloveschains"
	smeltresult = null	//So you can't melt down your start gear for blacksteel brigadines etc.
	var/wrapped = FALSE

/obj/item/clothing/gloves/roguetown/chain/psydon/attack_right(mob/user)
	. = ..()
	if(!wrapped)
		icon_state = "psydongloveschainwrap"
		item_state = "psydongloveschainwrap"
		user.update_inv_wrists()
		user.update_inv_gloves()
		user.update_inv_armor()
		user.update_inv_shirt()
		playsound(user, 'sound/foley/equip/chain_equip.ogg', 50, TRUE)
		wrapped = TRUE
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
		user.update_inv_wrists()
		user.update_inv_gloves()
		user.update_inv_armor()
		user.update_inv_shirt()
		playsound(user, 'sound/foley/equip/chain_equip.ogg', 50, TRUE)
		wrapped = FALSE


/obj/item/clothing/gloves/roguetown/chain/iron
	icon_state = "icgloves"
	desc = "Gauntlets made of interlinked iron rings. They offer decent protection against common weaponries, except for arrows."
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_SIDE_IRON
