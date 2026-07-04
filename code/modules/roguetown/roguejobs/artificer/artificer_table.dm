/obj/structure/artificer_table
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
	pass_flags = LETPASSTHROW

	// Rotational power
	rotation_structure = TRUE
	stress_use = 64
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_LEFT | CONN_DIR_RIGHT | CONN_DIR_FLIP

	/// Accumulates time (in seconds) for contraption charging — fires at 1s intervals (256 RPM) or 10s intervals (128 RPM)
	var/charge_accumulator = 0
	/// Accumulates time (in seconds) for construct healing
	var/heal_accumulator = 0
	/// RPM threshold for slow charging/healing
	var/RPM_SLOW = 128
	/// RPM threshold for fast charging/healing
	var/RPM_FAST = 256

/obj/structure/artificer_table/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/artificer_table/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/artificer_table/process()
	if(!rotation_network || rotation_network.overstressed || rotations_per_minute < RPM_SLOW)
		charge_accumulator = 0
		heal_accumulator = 0
		return

	var/is_fast = (rotations_per_minute >= RPM_FAST)

	// Charge interval: 1s at fast, 10s at slow
	var/charge_interval = is_fast ? 1 : 10
	// Heal interval: 10s at fast, 20s at slow
	var/heal_interval = is_fast ? 10 : 20

	charge_accumulator +=  world.time / 10
	heal_accumulator   +=  world.time / 10

	// --- Contraption charging ---
	if(charge_accumulator >= charge_interval)
		charge_accumulator -= charge_interval
		var/turf/T = get_turf(src)
		var/charged_any = FALSE
		for(var/obj/item/contraption/C in T.contents)
			if(istype(C, /obj/item/contraption/wood_metalizer))
				return //we won't charge the metalizer at this time
			if(C.current_charge >= C.max_stored_charge)
				continue
			C.current_charge++
			charged_any = TRUE
		if(charged_any)
			playsound(src, 'sound/misc/clockloop.ogg', 15, TRUE)

	// --- Construct healing ---
	if(heal_accumulator >= heal_interval)
		heal_accumulator -= heal_interval
		var/turf/T = get_turf(src)
		for(var/mob/living/carbon/human/H in T.contents)
			if(!istype(H.dna?.species, /datum/species/construct))
				continue
			if(!HAS_TRAIT(H, TRAIT_IRONMAN))
				continue
			if(H.stat == DEAD)
				continue
			// Don't heal while the construct is already processing minerals
			if(H.has_status_effect(/datum/status_effect/buff/ingotmuncher) \
			|| H.has_status_effect(/datum/status_effect/buff/oremuncher)   \
			|| H.has_status_effect(/datum/status_effect/buff/gemmuncher))
				continue

			var/brute_heal = is_fast ? 4 : 2
			var/fire_heal  = is_fast ? 4 : 2
			var/energy_gain = is_fast ? 10 : 5

			H.adjustBruteLoss(-brute_heal)
			H.adjustFireLoss(-fire_heal)
			H.energy_add(energy_gain)

			if(is_fast)
				to_chat(H, span_notice("The table's mechanisms hum at full speed, rapidly restoring my frame."))
				playsound(src, pick('sound/combat/hits/onmetal/sheet (1).ogg','sound/combat/hits/onmetal/sheet (2).ogg'), 20, TRUE)
			else
				to_chat(H, span_notice("The table's gentle rotation slowly mends my frame."))
				playsound(src, 'sound/misc/clockloop.ogg', 10, TRUE)

/obj/structure/artificer_table/examine(mob/user)
	. = ..()
	if(rotation_network && !rotation_network.overstressed && rotations_per_minute)
		if(rotations_per_minute >= RPM_FAST)
			. += span_notice("It spins at [rotations_per_minute] RPM — charging contraptions every second and rapidly restoring constructs.")
		else if(rotations_per_minute >= RPM_SLOW)
			. += span_warning("It spins at [rotations_per_minute] RPM — charging contraptions every 10 seconds and slowly restoring constructs.")
		else
			. += span_warning("It hums faintly at [rotations_per_minute] RPM, but needs at least [RPM_SLOW] RPM to do anything useful.")
	else
		. += span_warning("It is not connected to any rotational power source.")

/obj/structure/artificer_table/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("At [RPM_SLOW]+ RPM: charges contraptions on it every 10 seconds and slowly repairs constructs resting on it.")
	. += span_info("At [RPM_FAST]+ RPM: charges contraptions every second and rapidly repairs constructs.")

/obj/structure/artificer_table/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/storage/bag/tray))
		var/obj/item/storage/bag/tray/T = I
		if(T.contents.len > 0)
			SEND_SIGNAL(I, COMSIG_TRY_STORAGE_QUICK_EMPTY, drop_location())
			user.visible_message(span_notice("[user] empties [I] on [src]."))
			return
	if(!user.cmode)
		if(!(I.item_flags & ABSTRACT))
			if(user.transferItemToLoc(I, drop_location(), silent = FALSE))
				var/list/click_params = params2list(params)
				if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
					return
				I.pixel_x = initial(I.pixel_x) += CLAMP(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
				I.pixel_y = initial(I.pixel_y) += CLAMP(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
				return 1
	return ..()

/obj/structure/artificer_table/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSTABLE))
		return 1
	if(mover.throwing)
		return 1
	if(locate(/obj/structure/table) in get_turf(mover))
		return 1
	return !density

/obj/structure/artificer_table/CanAStarPass(ID, dir, caller)
	. = ..()
	if(ismovableatom(caller))
		var/atom/movable/mover = caller
		. ||= (mover.pass_flags & PASSTABLE)

//we're adding stress with the attached speed at 24, up this if we want to increase the setup difficulty
/obj/structure/artificer_table/set_rotations_per_minute(speed)
	. = ..()
	if(!.)
		return
	set_stress_use(24 * (speed / 8))
