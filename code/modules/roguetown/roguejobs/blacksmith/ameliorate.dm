/obj/machinery/ameliorate
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "ameliorate"
	desc = "A mixture of artifice and smithing, made easy enough to use for anyone. This will clear up any dents or small tears made in armor, restoring its maximum integrity. Fitted light armor will end up ruined, however. \n\n<b>It's operated by an empty hand and affects all armor placed atop of it.</b>"
	icon_state = "ameliorate"
	max_integrity = 300
	density = TRUE
	damage_deflection = 45
	climbable = TRUE
	pass_flags_self = LETPASSTHROW
	var/in_use = FALSE
	var/use_delay = 1 SECONDS
	var/custom_dropshrink = 0.5

/obj/machinery/ameliorate/obj_break(damage_flag)
	. = ..()
	loud_message("A screeching noise echoes in the distance. An Ameliorate was destroyed.", 60)

/obj/machinery/ameliorate/attackby(obj/item/I, mob/user, params)
	if(!user || !I)
		return

	if(user.cmode)
		. = ..()
		return

	if(in_use)
		to_chat(user, span_warning("It's currently being used!"))
		return

	if(!(I.item_flags & ABSTRACT))
		if(user.transferItemToLoc(I, drop_location(), silent = FALSE))
			var/list/click_params = params2list(params)
			//Center the icon where the user clicked.
			if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
				return
			//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
			I.pixel_x = initial(I.pixel_x) += CLAMP(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
			I.pixel_y = initial(I.pixel_y) += CLAMP(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
			var/matrix/M = matrix()
			M.Scale(custom_dropshrink,custom_dropshrink)
			I.transform = M
			return

/obj/machinery/ameliorate/attack_hand(mob/living/user)
	. = ..()

	if(in_use)
		return

	for(var/obj/item/I in loc)
		if(I.max_integrity != I.obj_integrity)
			to_chat(user, span_warning("\The [I] still needs repairs before being ameliorated!"))
			continue

		if(floor(I.get_true_max_integ()) == floor(I.max_integrity))
			to_chat(user, span_warning("\The [I] does not need any amelioration. It is fine."))
			continue

		if(!istype(I, /obj/item/clothing))
			to_chat(user, span_warning("\The [I] cannot be ameliorated. It's only usable with clothing."))
			continue

		var/sfx
		if(I.anvilrepair && !I.sewrepair)
			sfx = 'sound/repair/ameliorate_metal.ogg'
		if(I.sewrepair && !I.anvilrepair)
			sfx = 'sound/repair/ameliorate_leather.ogg'

		var/datum/component/fit_clothing/has_fitting = I.GetComponent(/datum/component/fit_clothing)
		if(I.max_integrity != I.get_true_max_integ())
			if(sfx)
				playsound(src, sfx, 100, TRUE)
			in_use = TRUE
			if(do_after(user, use_delay, TRUE, same_direction = TRUE))
				visible_message(span_info("<b>[I] gets ameliorated and restored to its full integrity!</b>"))
				I.max_integrity = initial(I.max_integrity)

				if(istype(I, /obj/item/clothing))
					I.restore_max_integ()

				if(has_fitting)
					has_fitting.Destroy()
			else
				in_use = FALSE
				break
	in_use = FALSE
