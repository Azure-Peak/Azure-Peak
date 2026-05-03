/obj/machinery/artificer_table
	name = "artificer table"
	desc = "An artificer's wood work station, blessed by some odd machination, or perhaps... magic..."
	icon_state = "art_table"
	icon = 'icons/roguetown/misc/tables.dmi'
	var/obj/item/material
	damage_deflection = 25
	max_integrity = 200
	density = TRUE
	climbable = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	pass_flags = LETPASSTHROW //You can throw objects over this, despite it's density.")

/obj/machinery/artificer_table/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/storage/bag/tray))
		var/obj/item/storage/bag/tray/T = I
		if(T.contents.len > 0) // If the tray isn't empty
			SEND_SIGNAL(I, COMSIG_TRY_STORAGE_QUICK_EMPTY, drop_location())
			user.visible_message(span_notice("[user] empties [I] on [src]."))
			return
		// If the tray IS empty, continue on (tray will be placed on the table like other items)

	if(!user.cmode)
		if(!(I.item_flags & ABSTRACT))
			if(user.transferItemToLoc(I, drop_location(), silent = FALSE))
				var/list/click_params = params2list(params)
				//Center the icon where the user clicked.
				if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
					return
				//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
				I.pixel_x = initial(I.pixel_x) += CLAMP(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
				I.pixel_y = initial(I.pixel_y) += CLAMP(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
				return 1

	return ..()
/obj/machinery/artificer_table/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSTABLE))
		return 1
	if(mover.throwing)
		return 1
	if(locate(/obj/structure/table) in get_turf(mover))
		return 1
	else
		return !density

/obj/machinery/artificer_table/CanAStarPass(ID, dir, caller)
	. = ..()
	if(ismovableatom(caller))
		var/atom/movable/mover = caller
		. ||= (mover.pass_flags & PASSTABLE)
