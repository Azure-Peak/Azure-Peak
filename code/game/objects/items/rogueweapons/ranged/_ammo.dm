//parent of all bolts and arrows ฅ^•ﻌ•^ฅ
/obj/item/ammo_casing/caseless/rogue
	firing_effect_type = null
	icon = 'icons/roguetown/weapons/ammo.dmi'
	var/ammo_weight = 1 // Weight cost in a quiver. Default 1, heavy ammo costs more.

/obj/item/ammo_casing/caseless/rogue/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Projectiles have maximum and minimum falloff ranges, with particular falloff factors for damage.")
	. += span_info("If the target is hit between the maximum and minimum tile range, then the full force is delivered.")
