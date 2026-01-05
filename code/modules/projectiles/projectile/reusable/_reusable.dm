/obj/projectile/bullet/reusable
	name = "reusable bullet"
	desc = ""
	icon = 'icons/roguetown/weapons/ammo.dmi'
	ammo_type = /obj/item/ammo_casing/caseless
	impact_effect_type = null
	var/has_dropped = FALSE  //Flag to track if we've already dropped the ammo

/obj/projectile/bullet/reusable/handle_drop()
	if(has_dropped)  //If we've already dropped an ammo, do nothing
		return
	has_dropped = TRUE  //Mark as dropped
	if(dropped)  //If it exists, move it to the turf
		dropped.forceMove(get_turf(src))
	else  //Otherwise create it
		var/turf/T = get_turf(src)
		dropped = new ammo_type(T)
	return dropped

/obj/projectile/bullet/reusable/on_hit()
	dropped = new ammo_type(src)
	..()

/obj/projectile/bullet/reusable/on_range()
	handle_drop()
	..()
