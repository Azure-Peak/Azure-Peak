/datum/intent/whips
	name = "strike"
	blade_class = BCLASS_BLUNT
	attack_verb = list("whips", "strikes", "smacks")
	penfactor = 0 //40
	chargetime = 5
	item_d_type = "slash"

/obj/item/rope/chain
	name = "chain"
	desc = "A heavy iron chain."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "chain"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 1
	throw_range = 3
	breakouttime = 10 SECONDS
	slipouttime = 2 MINUTES
	cuffsound = 'sound/misc/chains.ogg'
	possible_item_intents = list(/datum/intent/tie, /datum/intent/whips)
	firefuel = null
	smeltresult = /obj/item/ingot/iron
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/blacksmithing
	resistance_flags = FIRE_PROOF
