/obj/item/blueprint
	name = "papyrus"
	icon_state = "scroll"
	slot_flags = null
	dropshrink = 0.6
	firefuel = 30 SECONDS
	gender = NEUTER
	icon = 'icons/roguetown/items/misc.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 1
	throw_speed = 1
	resistance_flags = FLAMMABLE
	max_integrity = 100
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound =  'sound/blank.ogg'

/obj/item/blueprint/mace_mushroom
	name = "Lithmyc mace blueprint"
	desc = "A tattered, damp parchment that smells of wet earth and copper."
	color = "#124d00"

/obj/item/blueprint/mace_mushroom/examine(mob/user)
	. = ..()
	. += span_notice("The scroll lists the following requirements: <b>1x Lithmyc Ingot, 1x blueprint, and a Weaponsmithing Anvil.</b>")
	. += span_notice("Originally conceived of by the drow weaponsmith, Lithmyc is a liquid-solid metal made out of a particular metallic mushroom. This mushroom can be found in the underdark, but it's only seen some weeks rather than others.")
