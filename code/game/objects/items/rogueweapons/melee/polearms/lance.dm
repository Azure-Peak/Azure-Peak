/datum/intent/spear/thrust/lance
	damfactor = 1.25 // Turns its base damage into 30 on the 2hand thrust. It keeps the spear thrust one handed.

/datum/intent/lance
	name = "lance"
	icon_state = "inlance"
	attack_verb = list("lances", "runs through", "skewers")
	animname = "stab"
	item_d_type = "stab"
	penfactor = BLUNT_DEFAULT_PENFACTOR
	chargetime = 4 SECONDS
	damfactor = 4
	reach = 2
	cleave = /datum/cleave_pattern/lance

/datum/intent/lance/onehand
	chargetime = 4 SECONDS
	swingdelay = 1 SECONDS
	reach = 2
	damfactor = 4 // 25% less damage
	cleave = /datum/cleave_pattern/lance

// Lance - a sidegrade to spear that has two special AOE attack requiring a lot of charging
// But inflicts massive amount of non armor piercing damage.
// If we move to a tier based AP pattern, they can probably pierce armor. Until then
// It is an armor mulcher
/obj/item/rogueweapon/spear/lance
	name = "lance"
	desc = "A long polearm designed to be used from horseback, couched under the arm. It has a vambrace to prevent the arm sliding up \
	the shaft on impact. "
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "lance"
	force = 15 // Its gonna sucks for 1 handed use
	force_wielded = 20 // Lower damage because a 3 tiles thrust without full charge time still deal base damage.
	wdefense = 4 // 2 Lower than spear
	max_integrity = 200
	max_blade_int = 200 // Better sharpness
	possible_item_intents = list(SPEAR_THRUST, /datum/intent/lance/onehand, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/spear/thrust/lance, /datum/intent/lance, SPEAR_BASH)
	resistance_flags = null
	smeltresult = /obj/item/ingot/steel
