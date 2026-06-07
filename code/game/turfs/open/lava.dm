///LAVA

/turf/open/lava
	name = "lava"
	desc = "Thick viscous bubbles swell and burst with sprays of molten rock. What was once locked away in the bowels of the earth now thrashes and gurgles on the surface, glowing with unimaginable heat. If you touch it, you will die."
	icon_state = "lava"
	icon = 'icons/turf/roguefloor.dmi'
	gender = PLURAL //"That's some lava."
	baseturfs = /turf/open/lava //lava all the way down
	slowdown = 2

	light_outer_range =  4
	light_power = 0.75
	light_color = LIGHT_COLOR_LAVA
	bullet_bounce_sound = 'sound/blank.ogg'

	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/closed, /turf/open/floor/rogue/volcanic, /turf/open/floor/rogue/dirt, /turf/open/floor/rogue/dirt/road,/turf/open/floor/rogue/naturalstone)
	neighborlay_override = "lavedge"

/turf/open/lava/nosmooth
	smooth = SMOOTH_FALSE

/turf/open/lava/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/lava/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/lava/can_traverse_safely(atom/movable/traveler)
	return FALSE

/turf/open/lava/ex_act(severity, target)
	contents_explosion(severity, target)

/turf/open/lava/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return

/turf/open/lava/Melt()
	to_be_destroyed = FALSE
	return src

/turf/open/lava/acid_act(acidpwr, acid_volume)
	return

/turf/open/lava/MakeDry(wet_setting = TURF_WET_WATER)
	return

/turf/open/lava/Entered(atom/movable/AM)
	if(!AM.throwing)
		if(burn_stuff(AM))
			START_PROCESSING(SSobj, src)
		if(ishuman(AM))
			playsound(src, 'sound/misc/lava_death.ogg', 100, FALSE)
//			addomen("lava")

/turf/open/lava/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_flag = "blunt")
	if(burn_stuff(AM))
		START_PROCESSING(SSobj, src)
		playsound(src, 'sound/misc/lava_death.ogg', 100, FALSE)

/turf/open/lava/process()
	if(!burn_stuff()) // try to burn everything in our contents, stop once nothing left can burn
		STOP_PROCESSING(SSobj, src)

/turf/open/lava/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "basalt"
	return TRUE

/turf/open/lava/proc/is_safe()
	//if anything matching this typecache is found in the lava, we don't burn things
	var/static/list/lava_safeties_typecache = typecacheof(list(/obj/structure/stone_tile))
	var/list/found_safeties = typecache_filter_list(contents, lava_safeties_typecache)
	for(var/obj/structure/stone_tile/S in found_safeties)
		if(S.fallen)
			LAZYREMOVE(found_safeties, S)
	return LAZYLEN(found_safeties)

/turf/open/lava/can_traverse_safely(atom/movable/traveler)
	return ..() && !will_burn(traveler) // can traverse safely if you won't burn in it

/turf/open/lava/proc/will_burn(atom/movable/thing)
	if(isobj(thing))
		var/obj/O = thing
		if((O.resistance_flags & (LAVA_PROOF|INDESTRUCTIBLE)) || O.throwing)
			return FALSE
		return TRUE
	else if (isliving(thing))
		var/mob/living/L = thing
		if(L.movement_type & FLYING)
			return FALSE //YOU'RE FLYING OVER IT
		if("lava" in L.weather_immunities) // just flat-out immune. is this even used in RT?
			return FALSE
		var/buckle_check = L.buckling
		if(!buckle_check)
			buckle_check = L.buckled
		if(buckle_check && !will_burn(buckle_check))
			return FALSE // buckled to something lavaproof
		return TRUE
	return FALSE // no handling for this type burning, obj or living only

/turf/open/lava/proc/burn_stuff(AM)
	. = FALSE
	if(is_safe())
		return FALSE

	var/thing_to_check = src
	if (AM)
		thing_to_check = list(AM)
	for(var/thing in thing_to_check)
		if(!will_burn(thing))
			continue
		if(isobj(thing))
			var/obj/O = thing
			. = TRUE
			if((O.resistance_flags & (ON_FIRE))) // already on fire, don't bother. why do we do this exactly...? is this bad copypasta?
				continue
			if(!(O.resistance_flags & FLAMMABLE))
				O.resistance_flags |= FLAMMABLE //Even fireproof things burn up in lava
			if(O.resistance_flags & FIRE_PROOF)
				O.resistance_flags &= ~FIRE_PROOF
			if(O.armor.fire > 50) //obj with 100% fire armor still get slowly burned away.
				O.armor = O.armor.setRating(fire = 50)
			qdel(O)

		else if (isliving(thing))
			. = TRUE
			var/mob/living/L = thing

			if(iscarbon(L))
				var/mob/living/carbon/C = L
				var/obj/item/clothing/S = C.get_item_by_slot(SLOT_ARMOR)
				var/obj/item/clothing/H = C.get_item_by_slot(SLOT_HEAD)

				// we still catch fire if wearing lavaproof armor, but we don't get dusted when dead
				// is this really the intended behaviour, or was it just badly coded? idk
				if(S && H && S.clothing_flags & LAVAPROTECT && H.clothing_flags & LAVAPROTECT)
					continue

			if("lava" in L.weather_immunities)
				continue

			if(L)
				L.adjustFireLoss(100)
				L.adjust_fire_stacks(100)
				L.ignite_mob()

/turf/open/lava/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.is_mouth_covered())
				return
		playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		user.visible_message(span_info("[user] starts to drink from [src]."))
		if(do_after(L, 25, target = src))
			var/mob/living/carbon/C = user
			to_chat(C, span_userdanger("OH SWEET PSYDON, WHY DID I THINK THIS WAS A GOOD IDEA???"))
			C.flash_fullscreen("redflash3")
			C.emote("agony", forced = TRUE)
			C.adjust_fire_stacks(500) //you deserve this.
			C.ignite_mob()
			C.adjustFireLoss(1000) //you, literally, deserve this.

/turf/open/lava/smooth
	name = "lava"
	baseturfs = /turf/open/lava/smooth
	icon = 'icons/turf/floors/lava.dmi'
	icon_state = "unsmooth"
	smooth = SMOOTH_MORE | SMOOTH_BORDER
	canSmoothWith = list(/turf/open/lava/smooth)

/turf/open/lava/smooth/lava_land_surface

	baseturfs = /turf/open/lava/smooth/lava_land_surface

/turf/open/lava/smooth/airless

/turf/open/lava/acid
	name = "acid"
	icon_state = "acid"
	light_outer_range =  4
	light_power = 1
	light_color = "#56ff0d"

/turf/open/lava/acid/burn_stuff(AM)
	. = 0

	if(is_safe())
		return FALSE

	var/thing_to_check = src
	if (AM)
		thing_to_check = list(AM)
	for(var/thing in thing_to_check)
		if(isobj(thing))
			var/obj/O = thing
			if((O.resistance_flags & (ACID_PROOF|INDESTRUCTIBLE)) || O.throwing)
				continue
			O.obj_integrity -= O.max_integrity * 0.1
			if(O.obj_integrity <= 0)
				qdel(O)	
			. = 1

		else if (isliving(thing))
			. = 1
			var/mob/living/L = thing
			if(L.movement_type & FLYING)
				continue	//YOU'RE FLYING OVER IT
			var/buckle_check = L.buckling
			if(!buckle_check)
				buckle_check = L.buckled
			if(isobj(buckle_check))
				var/obj/O = buckle_check
				if(O.resistance_flags & ACID_PROOF)
					continue
			else if(isliving(buckle_check))
				var/mob/living/live = buckle_check
				if("lava" in live.weather_immunities)
					continue
			for(var/obj/item/clothing/C in L.contents)
				if(C.resistance_flags & (ACID_PROOF|INDESTRUCTIBLE))
					continue
				C.obj_integrity -= C.max_integrity * 0.1
				if(C.obj_integrity <= 0)
					to_chat(L, span_danger("Your [C.name] is destroyed by the acid!"))
					qdel(C)	

			L.adjustFireLoss(100)
			to_chat(L, span_userdanger("THE ACID BURNS!"))

/turf/open/lava/acid/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.is_mouth_covered())
				return
		playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		user.visible_message(span_info("[user] starts to drink from [src]."))
		if(do_after(L, 25, target = src))
			var/mob/living/carbon/C = user
			to_chat(C, span_userdanger("OH SWEET PSYDON, WHY DID I THINK THIS WAS A GOOD IDEA???"))
			C.flash_fullscreen("redflash3")
			C.emote("agony", forced = TRUE)
			C.gib() //YOU. LITERALLY. DESERVE THIS.
