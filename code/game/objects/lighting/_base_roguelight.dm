/obj/machinery/light/rogue
	icon = 'icons/roguetown/misc/lighting.dmi'
	brightness = LIGHT_RANGE_TORCH + 2
	nightshift_allowed = FALSE
	fueluse = 60 MINUTES
	bulb_colour = LIGHT_COLOR_ORANGE
	bulb_power = LIGHT_POWER_BASE
	var/datum/looping_sound/soundloop = null // = /datum/looping_sound/fireloop
	pass_flags = LETPASSTHROW
	flags_1 = NODECONSTRUCT_1
	var/no_refuel = FALSE // For special holder that don't actually refuel
	var/cookonme = FALSE
	var/crossfire = TRUE
	var/can_damage = TRUE
	var/roundstart_forbid = FALSE
	var/refueling = FALSE

/obj/machinery/light/rogue/Initialize(mapload)
	if(soundloop)
		soundloop = new soundloop(src, FALSE)
		soundloop.start()
	GLOB.fires_list += src
	if(fueluse > 0)
		fueluse = fueluse - (rand(fueluse*0.1,fueluse*0.3))
	update_icon()
	if(!roundstart_forbid)
		seton(TRUE)
	. = ..()

/obj/machinery/light/rogue/weather_trigger(W)
	if(W==/datum/weather/rain)
		START_PROCESSING(SSweather,src)

/obj/machinery/light/rogue/OnCrafted(dirin, user)
	. = ..()
	can_damage = TRUE
	burn_out()

/obj/machinery/light/rogue/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(fueluse > 0)
			var/minsleft = fueluse / 600
			minsleft = round(minsleft)
			if(minsleft <= 1)
				minsleft = "less than a minute"
			else
				minsleft = "[round(minsleft)] minutes"
			. += span_info("The fire will last for <b>[minsleft]</b>.")
		else
			if(initial(fueluse) > 0)
				. += span_warning("The fire is burned out and hungry...")


/obj/machinery/light/rogue/extinguish()
	if(on)
		burn_out()
		new /obj/effect/temp_visual/small_smoke(src.loc)
	..()

/obj/machinery/light/rogue/burn_out()
	if(soundloop)
		soundloop.stop()
	if(on)
		playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
	..()
	update_icon()

/obj/machinery/light/rogue/update_icon()
	if(on)
		icon_state = "[base_state]1"
	else
		icon_state = "[base_state]0"

/obj/machinery/light/rogue/update()
	. = ..()
	if(on)
		GLOB.fires_list |= src
	else
		GLOB.fires_list -= src

/obj/machinery/light/rogue/Destroy()
	QDEL_NULL(soundloop)
	GLOB.fires_list -= src
	. = ..()

/obj/machinery/light/rogue/proc/on_ignited()
	return

/obj/machinery/light/rogue/fire_act(added, maxstacks)
	if(!on && ((fueluse > 0) || (initial(fueluse) == 0)))
		playsound(src.loc, 'sound/items/firelight.ogg', 100)
		on = TRUE
		update()
		update_icon()
		if(soundloop)
			soundloop.start()
		addtimer(CALLBACK(src, PROC_REF(trigger_weather)), rand(5,20))
		on_ignited()
		return TRUE

/obj/proc/trigger_weather()
	if(!QDELETED(src))
		if(isturf(loc))
			var/turf/T = loc
			T.trigger_weather(src)

/obj/machinery/light/rogue/CanAStarPass(ID, to_dir, atom/movable/caller)
	if(on && crossfire && isliving(caller))
		var/mob/living/crosser = caller
		if(!(crosser.movement_type & (FLYING|FLOATING)) && !HAS_TRAIT(crosser, TRAIT_NOFIRE))
			return FALSE
	return ..()

/obj/machinery/light/rogue/Crossed(atom/movable/AM, oldLoc)
	..()
	if(crossfire)
		if(on)
			if(isliving(AM))
				var/mob/living/L = AM
				if(L.is_jumping)
					return
				if(L.movement_type & (FLYING|FLOATING))
					return
			AM.fire_act(1,5)

/obj/machinery/light/rogue/spark_act()
	fire_act()

/obj/machinery/light/rogue/attackby(obj/item/W, mob/living/user, params)
	var/datum/skill/craft/cooking/cs = user?.get_skill_level(/datum/skill/craft/cooking)
	var/cooktime_divisor = get_cooktime_divisor(cs)
	if(cookonme && on)
		if(istype(W, /obj/item/seeds))
			user.visible_message("<span class='notice'>[user] starts roasting [W] over [src]...</span>")
			if(do_after(user, 60 / cooktime_divisor, target = src))
				var/obj/item/result = W.heating_act(src)
				if(result)
					user.put_in_hands(result)
					qdel(W)
				return TRUE
		if(istype(W, /obj/item/reagent_containers/food/snacks))
			if(istype(W, /obj/item/reagent_containers/food/snacks/rogue/egg))
				to_chat(user, "<span class='warning'>I wouldn't be able to cook this over the fire...</span>")
				return FALSE
			var/obj/item/A = user.get_inactive_held_item()
			if(A)
				var/foundstab = FALSE
				for(var/X in A.possible_item_intents)
					var/datum/intent/D = new X
					if(D.blade_class in GLOB.stab_bclasses)
						foundstab = TRUE
						break
				if(foundstab)
					var/prob2spoil = 33
					if(user.get_skill_level(/datum/skill/craft/cooking))
						prob2spoil = 1
					var/already_rolled = FALSE
					user.visible_message("<span class='notice'>[user] starts to cook [W] over [src].</span>")
					for(var/i in 1 to 6)
						if(do_after(user, 30 / cooktime_divisor, target = src))
							var/obj/item/reagent_containers/food/snacks/S = W
							var/obj/item/C
							if(prob(prob2spoil) && !already_rolled)
								user.visible_message("<span class='warning'>[user] burns [S].</span>")
								if(user.client?.prefs.showrolls)
									to_chat(user, "<span class='warning'>Critfail... [prob2spoil]%.</span>")
								C = S.cooking(1000, 1000, null)
							else
								already_rolled = TRUE
								C = S.cooking(S.cooktime/4, S.cooktime/4, src)
							if(C)
								user.dropItemToGround(S, TRUE)
								qdel(S)
								C.forceMove(get_turf(user))
								user.put_in_hands(C)
								break
						else
							break
					return
	if(W.firefuel && !no_refuel)
		if(refueling)
			return TRUE

		refueling = TRUE

		var/choice

		if(W.smeltresult)
			choice = alert(user, "Fuel [src] with [W]?", "ROGUETOWN", "Fuel", "Smelt")
			if(choice != "Fuel")
				refueling = FALSE
				return TRUE

		if(alert(user, "Fuel [src] with [W]?", "ROGUETOWN", "Yes", "No") != "Yes")
			refueling = FALSE
			return TRUE

		if(!W || QDELETED(W))
			refueling = FALSE
			return TRUE

		if(user.get_active_held_item() != W)
			to_chat(user, span_warning("That item is no longer in my hand..."))
			refueling = FALSE
			return TRUE

		if(initial(fueluse))
			if(fueluse > initial(fueluse) - 5 SECONDS)
				to_chat(user, "<span class='warning'>[src] is fully fueled.</span>")
				refueling = FALSE
				return TRUE
		else
			if(!on)
				refueling = FALSE
				return TRUE

		var/fuel_amount = W.firefuel

		user.dropItemToGround(W)

		if(!W || QDELETED(W))
			refueling = FALSE
			return TRUE

		qdel(W)

		user.visible_message("<span class='warning'>[user] feeds [W] to [src].</span>")

		if(initial(fueluse))
			fueluse += fuel_amount
			if(fueluse > initial(fueluse))
				fueluse = initial(fueluse)

		refueling = FALSE
		return TRUE
	else
		if(on)
			if(istype(W, /obj/item/natural/dirtclod))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				on = FALSE
				set_light(0)
				update_icon()
				qdel(W)
				src.visible_message("<span class='warning'>[user] snuffs the fire.</span>")
				return
			if(user.used_intent?.type != INTENT_SPLASH)
				W.spark_act()
	. = ..()

/obj/machinery/light/rogue/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1)
	if(!can_damage)
		return
	. = ..()

/obj/machinery/light/rogue/broken_sparks(start_only = FALSE)
	return

/obj/machinery/light/rogue/break_light_tube(skip_sound_and_sparks = 0)
	return ..(TRUE)

/proc/pick_light_color(mob/user, atom/anchor, list/color_list, uniqueid, radius = 32, tooltips = TRUE)
	if(!color_list)
		color_list = list(
			"White" = LIGHT_COLOR_WHITE,
			"Red" = LIGHT_COLOR_RED,
			"Green" = LIGHT_COLOR_GREEN,
			"Blue" = LIGHT_COLOR_BLUE,
			"Blue-Green" = LIGHT_COLOR_BLUEGREEN,
			"Cyan" = LIGHT_COLOR_CYAN,
			"Light Cyan" = LIGHT_COLOR_LIGHT_CYAN,
			"Dark Blue" = LIGHT_COLOR_DARK_BLUE,
			"Pink" = LIGHT_COLOR_PINK,
			"Yellow" = LIGHT_COLOR_YELLOW,
			"Brown" = LIGHT_COLOR_BROWN,
			"Orange" = LIGHT_COLOR_ORANGE,
			"Purple" = LIGHT_COLOR_PURPLE,
			"Lavender" = LIGHT_COLOR_LAVENDER,
			//"Holy Magic" = LIGHT_COLOR_HOLY_MAGIC,
			//"Blood Magic" = LIGHT_COLOR_BLOOD_MAGIC,
			//"Fire" = LIGHT_COLOR_FIRE,
			//"Lava" = LIGHT_COLOR_LAVA,
			//"Flare" = LIGHT_COLOR_FLARE,
			//"Slime Lamp" = LIGHT_COLOR_SLIME_LAMP,
			//"Tungsten" = LIGHT_COLOR_TUNGSTEN,
			//"Halogen" = LIGHT_COLOR_HALOGEN,
			//"Bronze" = LIGHT_COLOR_BRONZE,
			//"Holy" = LIGHT_COLOR_HOLY
		)

	var/list/radial_options = list()
	for(var/color_name in color_list)
		var/hex = color_list[color_name]
		var/icon/swatch_icon = icon('icons/effects/32X64.dmi', "leylinestable")
		swatch_icon.Blend(hex, ICON_MULTIPLY)
		radial_options[color_name] = image(icon = swatch_icon)

	var/choice = show_radial_menu(user, anchor, radial_options, uniqueid, radius, tooltips = tooltips)
	if(!choice)
		return

	return color_list[choice]
