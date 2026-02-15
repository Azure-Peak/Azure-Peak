
// Initalize addon for the var for custom inhands 32x32.
/obj/item/Initialize()
	. = ..()
	if(!experimental_inhand)
		inhand_x_dimension = 32
		inhand_y_dimension = 32

// Helper items for spriters so they can see how in-hands look in game.
// They're basically red square sprites placed on the floor so spriters can adjust their sprites properly
// Used on admin testing area only.

GLOBAL_LIST_INIT(IconStates_cache, list())
GLOBAL_LIST_INIT(has_behind_cache, list()) // cheaty hack to avoid repeated list searches

// 32x32 in-hand helper item
/obj/item/inhand_tester
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "inhand_test"

// 64x64 in-hand helper item
/obj/item/inhand_tester/big
	icon = 'icons/roguetown/misc/64x64.dmi'

// START OF ROGUE PROCS NECESSARY FOR ITEM TRANSFORMS, ETC

/obj/item/proc/getmoboverlay(tag, prop, behind = FALSE, mirrored = FALSE)
	var/used_index = icon_state
	var/extra_index = get_extra_onmob_index()
	if(extra_index) //WIP, unimplemented
		used_index += extra_index
	if(HAS_BLOOD_DNA(src))
		used_index += "_b"
	var/static/list/onmob_sprites = list()
	var/icon/onmob = onmob_sprites["[tag][behind][mirrored][used_index]"]
	if(!onmob || force_reupdate_inhand)
		onmob = fcopy_rsc(generateonmob(tag, prop, behind, mirrored))
		onmob_sprites["[tag][behind][mirrored][used_index]"] = onmob
	return onmob

/obj/item/proc/get_extra_onmob_index()
	//perhaps in the future: force items like flasks to use getflaticon to get their filled states and drinking cups too. that's all
	return

///Wrapper so the deflection callback can work properly.
/obj/item/proc/fake_throw_at(atom/target, range, speed, mob/thrower)
	safe_throw_at(target, range, speed, thrower)
	return
///Throws the item 90, 270 or 180 degrees from wherever it was thrown relative to the deflector mob.
///Mob ref is only needed for their dir to know how to rotate it and for the throw proc.
/obj/item/proc/get_deflected(mob/deflector)
	var/turnangle = (prob(50) ? 270 : 90)
	if(prob(10))	
		turnangle = 0 //Right back at thee
	var/turndir = turn(deflector.dir, turnangle)
	var/dist = rand(1, 6)
	var/turf/current_turf = get_turf(src)
	var/turf/target_turf = get_ranged_target_turf(current_turf, turndir, dist)
	var/soundin = pick(list('sound/combat/parry/deflect_1.ogg','sound/combat/parry/deflect_2.ogg','sound/combat/parry/deflect_3.ogg','sound/combat/parry/deflect_4.ogg','sound/combat/parry/deflect_5.ogg','sound/combat/parry/deflect_6.ogg'))
	playsound(deflector, soundin, 100, TRUE)

	//If called immediately it does not work as intended, likely because the movement of the item is still being overridden by the original throw procchain.
	//This is basically the modern version of spawn(0) that "makes it work"
	addtimer(CALLBACK(src, PROC_REF(fake_throw_at), target_turf, dist, dist, deflector), 0.1 SECONDS)

/obj/item/proc/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.2,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -4,"wy" = -4,"ex" = 2,"ey" = -4,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("wielded")
				return null
			if("altgrip")
				return null
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = 1,"sy" = -1,"nx" = 1,"ny" = -1,"wx" = 4,"wy" = -1,"ex" = -1,"ey" = -1,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/proc/mirror_fix(shrink, big)
	if(!shrink)
		return FALSE
	switch(shrink)
		if(0.5)
			return 1
		if(0.6)
			if(big)
				return 1
			else
				return 2
		if(0.7)
			return 1

/obj/item/proc/generateonmob(tag, prop, behind, mirrored)
	var/list/used_prop = prop
	var/UH = 64
	var/UW = 64
	var/used_mask = 'icons/roguetown/helpers/inhand_64.dmi'
	var/icon/returned = icon(used_mask, "blank")
	var/icon/blended
	var/skipoverlays = FALSE

	// --- behind handling + icon_states cache ---
	if(behind)
		var/icon_key = "[icon]"
		if(!GLOB.IconStates_cache[icon_key])
			var/list/istates = icon_states(icon)
			GLOB.IconStates_cache[icon_key] = istates
			GLOB.has_behind_cache[icon_key] = ("[icon_state]_behind" in istates)

		if(GLOB.has_behind_cache[icon_key])
			blended = icon(icon = icon, icon_state = "[icon_state]_behind")
			skipoverlays = TRUE
		else
			blended = icon(icon = icon, icon_state = icon_state)
	else
		blended = icon(icon = icon, icon_state = icon_state)

	if(!blended)
		blended = getFlatIcon(src)

	if(!blended)
		return

	// --- overlays ---
	if(!skipoverlays && overlays.len)
		var/static/list/plane_whitelist = list(FLOAT_PLANE, GAME_PLANE, FLOOR_PLANE)

		for(var/mutable_appearance/overlay as anything in overlays)
			if(!(overlay.plane in plane_whitelist))
				continue

			if(!overlay.color)
				blended.Blend(icon(overlay.icon, overlay.icon_state), ICON_OVERLAY)
			else
				var/icon/image_overlay = icon(overlay.icon, overlay.icon_state)
				image_overlay.Blend(overlay.color, ICON_MULTIPLY)
				blended.Blend(image_overlay, ICON_OVERLAY)

	// --- size switch ---
	if(blended.Height() == 32)
		UW = 32
		UH = 32
		used_mask = 'icons/roguetown/helpers/inhand.dmi'

	var/icon/holder
	var/icon/masky
	var/px
	var/py
	var/ax
	var/usedtag
	var/render_this_dir

	// ================= NORTH =================
	render_this_dir = FALSE
	if(!behind)
		if(used_prop["northabove"] == 1)
			render_this_dir = TRUE
	else
		if(used_prop["northabove"] == 0)
			render_this_dir = TRUE

	if(render_this_dir)
		px = 0
		py = 0
		holder = icon(blended)
		masky = icon(icon = used_mask, icon_state = "north")
		holder.Blend(masky, ICON_MULTIPLY)

		if(!isnull(used_prop["nflip"]))
			holder.Flip(used_prop["nflip"])
		if(!isnull(used_prop["nturn"]))
			holder.Turn(used_prop["nturn"])

		if(!isnull(used_prop["nx"]))
			if(mirrored)
				px -= used_prop["nx"]
				if(mirror_fix(used_prop["shrink"], UH > 32))
					px += mirror_fix(used_prop["shrink"], UH > 32)
			else
				px += used_prop["nx"]

		if(!isnull(used_prop["ny"]))
			py += used_prop["ny"]

		ax = 0
		if(!isnull(used_prop["shrink"]))
			holder.Scale(UW * used_prop["shrink"], UH * used_prop["shrink"])
			ax = 32 - (holder.Width() / 2)

		px += ax
		py += ax

		if(mirrored)
			holder.Flip(WEST)

		returned.Blend(holder, ICON_OVERLAY, x = px, y = py)

	// ================= SOUTH =================
	render_this_dir = FALSE
	if(!behind)
		if(used_prop["southabove"] == 1)
			render_this_dir = TRUE
	else
		if(used_prop["southabove"] == 0)
			render_this_dir = TRUE

	if(render_this_dir)
		px = 0
		py = 0
		holder = icon(blended)
		masky = icon(icon = used_mask, icon_state = "south")
		holder.Blend(masky, ICON_MULTIPLY)

		if(!isnull(used_prop["sflip"]))
			holder.Flip(used_prop["sflip"])
		if(!isnull(used_prop["sturn"]))
			holder.Turn(used_prop["sturn"])

		if(!isnull(used_prop["sx"]))
			if(mirrored)
				px -= used_prop["sx"]
				if(mirror_fix(used_prop["shrink"], UH > 32))
					px += mirror_fix(used_prop["shrink"], UH > 32)
			else
				px += used_prop["sx"]

		if(!isnull(used_prop["sy"]))
			py += used_prop["sy"]

		ax = 0
		if(!isnull(used_prop["shrink"]))
			holder.Scale(UW * used_prop["shrink"], UH * used_prop["shrink"])
			ax = 32 - (holder.Width() / 2)

		px += ax
		py += ax

		if(mirrored)
			holder.Flip(EAST)

		returned.Blend(holder, ICON_OVERLAY, x = px, y = py)

	// ================= EAST =================
	render_this_dir = FALSE
	usedtag = mirrored ? "w" : "e"
	if(!behind)
		if(used_prop[mirrored ? "westabove" : "eastabove"] == 1)
			render_this_dir = TRUE
	else
		if(used_prop[mirrored ? "westabove" : "eastabove"] == 0)
			render_this_dir = TRUE

	if(render_this_dir)
		px = 0
		py = 0
		holder = icon(blended)
		masky = icon(icon = used_mask, icon_state = "east")
		holder.Blend(masky, ICON_MULTIPLY)

		if(!isnull(used_prop["[usedtag]flip"]))
			holder.Flip(used_prop["[usedtag]flip"])
		if(!isnull(used_prop["[usedtag]turn"]))
			holder.Turn(used_prop["[usedtag]turn"])

		if(!isnull(used_prop["[usedtag]x"]))
			px = used_prop["[usedtag]x"]
			if(mirrored)
				px *= -1

		if(!isnull(used_prop["[usedtag]y"]))
			py = used_prop["[usedtag]y"]

		ax = 0
		if(!isnull(used_prop["shrink"]))
			holder.Scale(UW * used_prop["shrink"], UH * used_prop["shrink"])
			ax = 32 - (holder.Width() / 2)

		px += ax
		py += ax

		if(mirrored)
			holder.Flip(EAST)

		returned.Blend(holder, ICON_OVERLAY, x = px, y = py)

	// ================= WEST =================
	render_this_dir = FALSE
	usedtag = mirrored ? "e" : "w"
	if(!behind)
		if(used_prop[mirrored ? "eastabove" : "westabove"] == 1)
			render_this_dir = TRUE
	else
		if(used_prop[mirrored ? "eastabove" : "westabove"] == 0)
			render_this_dir = TRUE

	if(render_this_dir)
		px = 0
		py = 0
		holder = icon(blended)
		masky = icon(icon = used_mask, icon_state = "west")
		holder.Blend(masky, ICON_MULTIPLY)

		if(!isnull(used_prop["[usedtag]flip"]))
			holder.Flip(used_prop["[usedtag]flip"])
		if(!isnull(used_prop["[usedtag]turn"]))
			holder.Turn(used_prop["[usedtag]turn"])

		if(!isnull(used_prop["[usedtag]x"]))
			px = used_prop["[usedtag]x"]
			if(mirrored)
				px *= -1

		if(!isnull(used_prop["[usedtag]y"]))
			py = used_prop["[usedtag]y"]

		ax = 0
		if(!isnull(used_prop["shrink"]))
			holder.Scale(UW * used_prop["shrink"], UH * used_prop["shrink"])
			ax = 32 - (holder.Width() / 2)

		px += ax
		py += ax

		if(mirrored)
			holder.Flip(EAST)

		returned.Blend(holder, ICON_OVERLAY, x = px, y = py)

	return returned

#ifdef TESTSERVER

/client/verb/output_inhands()
	set category = "INHANDS"
	set name = "Output Variables"
	set desc = ""

	var/mob/living/carbon/human/LI = mob
	var/obj/item/I = LI.get_active_held_item()
	if(!I)
		I = LI.beltr
	if(!I)
		I = LI.beltl
	if(!I)
		I = LI.backr
	if(!I)
		I = LI.backl
	if(I)
		for(var/X in I.onprop)
			var/list/L = I.onprop[X]
			var/list/tegst = list()
			to_chat(mob, "\"[X]\"")
			tegst += "return list("
			if(L && L.len)
				for(var/P in L)
					tegst += "\"[P]\" = [L[P]],"
			to_chat(mob, "[tegst.Join()]")

/client/verb/inhand_xplus()
	set category = "INHANDS"
	set name = "X+1"

	if(!isliving(mob))
		return
	var/mob/living/carbon/human/LI = mob

	var/needtofind
	switch(LI.dir)
		if(NORTH)
			needtofind = "nx"
		if(SOUTH)
			needtofind = "sx"
		if(WEST)
			needtofind = "wx"
		if(EAST)
			needtofind = "ex"

	var/obj/item/I = LI.get_active_held_item()
	var/used_cat
	if(!I)
		I = LI.beltr
		used_cat = "onbelt"
	if(!I)
		I = LI.beltl
	if(!I)
		used_cat = "onback"
		I = LI.backr
	if(!I)
		I = LI.backl
	if(I)
		if(!used_cat && I.altgripped)
			used_cat = "altgrip"
		if(!used_cat && HAS_TRAIT(I, TRAIT_WIELDED))
			used_cat = "wielded"
		if(!used_cat)
			used_cat = "gen"

		for(var/X in I.onprop)
			if(X == used_cat)
				var/list/L = I.onprop[X]
				if(L.len)
					for(var/P in L)
						if(P == needtofind)
							L[P] += 1
							to_chat(LI, "[needtofind] = [L[P]]")
	LI.update_inv_hands()
	LI.update_inv_belt()
	LI.update_inv_back()

/client/verb/inhand_xminus()
	set category = "INHANDS"
	set name = "X-1"

	if(!isliving(mob))
		return
	var/mob/living/carbon/human/LI = mob

	var/needtofind
	switch(LI.dir)
		if(NORTH)
			needtofind = "nx"
		if(SOUTH)
			needtofind = "sx"
		if(WEST)
			needtofind = "wx"
		if(EAST)
			needtofind = "ex"

	var/obj/item/I = LI.get_active_held_item()
	var/used_cat
	if(!I)
		I = LI.beltr
		used_cat = "onbelt"
	if(!I)
		I = LI.beltl
	if(!I)
		used_cat = "onback"
		I = LI.backr
	if(!I)
		I = LI.backl
	if(I)
		if(!used_cat && I.altgripped)
			used_cat = "altgrip"
		if(!used_cat && HAS_TRAIT(I, TRAIT_WIELDED))
			used_cat = "wielded"
		if(!used_cat)
			used_cat = "gen"

		for(var/X in I.onprop)
			if(X == used_cat)
				var/list/L = I.onprop[X]
				if(L.len)
					for(var/P in L)
						if(P == needtofind)
							L[P] -= 1
							to_chat(LI, "[needtofind] = [L[P]]")
	LI.update_inv_hands()
	LI.update_inv_belt()
	LI.update_inv_back()

/client/verb/inhand_yplus()
	set category = "INHANDS"
	set name = "Y+1"

	if(!isliving(mob))
		return
	var/mob/living/carbon/human/LI = mob

	var/needtofind
	switch(LI.dir)
		if(NORTH)
			needtofind = "ny"
		if(SOUTH)
			needtofind = "sy"
		if(WEST)
			needtofind = "wy"
		if(EAST)
			needtofind = "ey"

	var/obj/item/I = LI.get_active_held_item()
	var/used_cat
	if(!I)
		I = LI.beltr
		used_cat = "onbelt"
	if(!I)
		I = LI.beltl
	if(!I)
		used_cat = "onback"
		I = LI.backr
	if(!I)
		I = LI.backl
	if(I)
		if(!used_cat && I.altgripped)
			used_cat = "altgrip"
		if(!used_cat && HAS_TRAIT(I, TRAIT_WIELDED))
			used_cat = "wielded"
		if(!used_cat)
			used_cat = "gen"

		for(var/X in I.onprop)
			if(X == used_cat)
				var/list/L = I.onprop[X]
				if(L.len)
					for(var/P in L)
						if(P == needtofind)
							L[P] += 1
							to_chat(LI, "[needtofind] = [L[P]]")
	LI.update_inv_hands()
	LI.update_inv_belt()
	LI.update_inv_back()

/client/verb/inhand_yminus()
	set category = "INHANDS"
	set name = "Y-1"

	if(!isliving(mob))
		return
	var/mob/living/carbon/human/LI = mob

	var/needtofind
	switch(LI.dir)
		if(NORTH)
			needtofind = "ny"
		if(SOUTH)
			needtofind = "sy"
		if(WEST)
			needtofind = "wy"
		if(EAST)
			needtofind = "ey"

	var/obj/item/I = LI.get_active_held_item()
	var/used_cat
	if(!I)
		I = LI.beltr
		used_cat = "onbelt"
	if(!I)
		I = LI.beltl
	if(!I)
		used_cat = "onback"
		I = LI.backr
	if(!I)
		I = LI.backl
	if(I)
		if(!used_cat && I.altgripped)
			used_cat = "altgrip"
		if(!used_cat && HAS_TRAIT(I, TRAIT_WIELDED))
			used_cat = "wielded"
		if(!used_cat)
			used_cat = "gen"

		for(var/X in I.onprop)
			if(X == used_cat)
				var/list/L = I.onprop[X]
				if(L.len)
					for(var/P in L)
						if(P == needtofind)
							L[P] -= 1
							to_chat(LI, "[needtofind] = [L[P]]")
	LI.update_inv_hands()
	LI.update_inv_belt()
	LI.update_inv_back()

/client/verb/inhand_flip()
	set category = "INHANDS"
	set name = "FLIP"

	if(!isliving(mob))
		return
	var/mob/living/carbon/human/LI = mob

	var/needtofind
	switch(LI.dir)
		if(NORTH)
			needtofind = "nflip"
		if(SOUTH)
			needtofind = "sflip"
		if(WEST)
			needtofind = "wflip"
		if(EAST)
			needtofind = "eflip"

	var/obj/item/I = LI.get_active_held_item()
	var/used_cat
	if(!I)
		I = LI.beltr
		used_cat = "onbelt"
	if(!I)
		I = LI.beltl
	if(!I)
		used_cat = "onback"
		I = LI.backr
	if(!I)
		I = LI.backl
	if(I)
		if(!used_cat && I.altgripped)
			used_cat = "altgrip"
		if(!used_cat && HAS_TRAIT(I, TRAIT_WIELDED))
			used_cat = "wielded"
		if(!used_cat)
			used_cat = "gen"

		for(var/X in I.onprop)
			if(X == used_cat)
				var/list/L = I.onprop[X]
				if(L.len)
					if(!needtofind in L)
						L += needtofind
					for(var/P in L)
						if(P == needtofind)
							if(!L[P])
								L[P] = NORTH
							else
								switch(L[P])
									if(NORTH)
										L[P] = SOUTH
									if(SOUTH)
										L[P] = WEST
									if(WEST)
										L[P] = EAST
									if(EAST)
										L[P] = 0
							to_chat(LI, "[needtofind] = [L[P]]")
	LI.update_inv_hands()
	LI.update_inv_belt()
	LI.update_inv_back()

/client/verb/inhand_turnplus()
	set category = "INHANDS"
	set name = "Turn +1"

	if(!isliving(mob))
		return
	var/mob/living/carbon/human/LI = mob

	var/needtofind
	switch(LI.dir)
		if(NORTH)
			needtofind = "nturn"
		if(SOUTH)
			needtofind = "sturn"
		if(WEST)
			needtofind = "wturn"
		if(EAST)
			needtofind = "eturn"

	var/obj/item/I = LI.get_active_held_item()
	var/used_cat
	if(!I)
		I = LI.beltr
		used_cat = "onbelt"
	if(!I)
		I = LI.beltl
	if(!I)
		used_cat = "onback"
		I = LI.backr
	if(!I)
		I = LI.backl
	if(I)
		if(!used_cat && I.altgripped)
			used_cat = "altgrip"
		if(!used_cat && HAS_TRAIT(I, TRAIT_WIELDED))
			used_cat = "wielded"
		if(!used_cat)
			used_cat = "gen"

		for(var/X in I.onprop)
			if(X == used_cat)
				var/list/L = I.onprop[X]
				if(L.len)
					if(!needtofind in L)
						L += needtofind
					for(var/P in L)
						if(P == needtofind)
							L[P] += 1
							to_chat(LI, "[needtofind] = [L[P]]")
	LI.update_inv_hands()
	LI.update_inv_belt()
	LI.update_inv_back()

/client/verb/inhand_turnminus()
	set category = "INHANDS"
	set name = "Turn -1"

	if(!isliving(mob))
		return
	var/mob/living/carbon/human/LI = mob

	var/needtofind
	switch(LI.dir)
		if(NORTH)
			needtofind = "nturn"
		if(SOUTH)
			needtofind = "sturn"
		if(WEST)
			needtofind = "wturn"
		if(EAST)
			needtofind = "eturn"

	var/obj/item/I = LI.get_active_held_item()
	var/used_cat
	if(!I)
		I = LI.beltr
		used_cat = "onbelt"
	if(!I)
		I = LI.beltl
	if(!I)
		used_cat = "onback"
		I = LI.backr
	if(!I)
		I = LI.backl
	if(I)
		if(!used_cat && I.altgripped)
			used_cat = "altgrip"
		if(!used_cat && HAS_TRAIT(I, TRAIT_WIELDED))
			used_cat = "wielded"
		if(!used_cat)
			used_cat = "gen"

		for(var/X in I.onprop)
			if(X == used_cat)
				var/list/L = I.onprop[X]
				if(L.len)
					if(!needtofind in L)
						L += needtofind
					for(var/P in L)
						if(P == needtofind)
							L[P] -= 1
							to_chat(LI, "[needtofind] = [L[P]]")
	LI.update_inv_hands()
	LI.update_inv_belt()
	LI.update_inv_back()

/client/verb/inhand_scaleplus()
	set category = "INHANDS"
	set name = "Shrink+0.1"

	if(!isliving(mob))
		return
	var/mob/living/carbon/human/LI = mob

	var/needtofind = "shrink"

	var/obj/item/I = LI.get_active_held_item()
	var/used_cat
	if(!I)
		I = LI.beltr
		used_cat = "onbelt"
	if(!I)
		I = LI.beltl
	if(!I)
		used_cat = "onback"
		I = LI.backr
	if(!I)
		I = LI.backl
	if(I)
		if(!used_cat && I.altgripped)
			used_cat = "altgrip"
		if(!used_cat && HAS_TRAIT(I, TRAIT_WIELDED))
			used_cat = "wielded"
		if(!used_cat)
			used_cat = "gen"

		if(length(I.onprop?[used_cat]))
			var/list/L = I.onprop[used_cat]
			L[needtofind] += 0.1
			to_chat(LI, "[needtofind] = [L[needtofind]]")
	LI.update_inv_hands()
	LI.update_inv_belt()
	LI.update_inv_back()

/client/verb/inhand_scaleminus()
	set category = "INHANDS"
	set name = "Shrink-0.1"

	if(!isliving(mob))
		return
	var/mob/living/carbon/human/LI = mob

	var/needtofind = "shrink"

	var/obj/item/I = LI.get_active_held_item()
	var/used_cat
	if(!I)
		I = LI.beltr
		used_cat = "onbelt"
	if(!I)
		I = LI.beltl
	if(!I)
		used_cat = "onback"
		I = LI.backr
	if(!I)
		I = LI.backl
	if(I)
		if(!used_cat && I.altgripped)
			used_cat = "altgrip"
		if(!used_cat && HAS_TRAIT(I, TRAIT_WIELDED))
			used_cat = "wielded"
		if(!used_cat)
			used_cat = "gen"

		if(length(I.onprop?[used_cat]))
			var/list/L = I.onprop[used_cat]
			L[needtofind] -= 0.1
			to_chat(LI, "[needtofind] = [L[needtofind]]")
	LI.update_inv_belt()
	LI.update_inv_back()

/client/verb/give_me_money()
	set category = "DEBUGTEST"
	set name = "GiveMeMoney"
	if(mob)
		var/turf/T = get_turf(mob)
		if(T)
			new /obj/item/coin/gold/pile(T)
/*
/client/verb/wwolf()
	set category = "DEBUGTEST"
	set name = "Werewolf"
	if(mob.mind)
		if(mob.mind.has_antag_datum(/datum/antagonist/werewolf, TRUE))
			to_chat(mob, "I am already a werewolf.")
		else
			var/datum/antagonist/werewolf/new_antag = new /datum/antagonist/werewolf()
			mob.mind.add_antag_datum(new_antag)
*/

/client/verb/zoomtest()
	set category = "DEBUGTEST"
	set name = "ZoomTest"
	if(mob)
		if(iscarbon(mob))
			var/mob/living/carbon/C = mob
			var/list/screens = list(C.hud_used.plane_masters["[FLOOR_PLANE]"], C.hud_used.plane_masters["[GAME_PLANE]"], C.hud_used.plane_masters["[LIGHTING_PLANE]"])
			var/matrix/skew = matrix()
			skew.Scale(2)
			var/matrix/newmatrix = skew
			for(var/whole_screen in screens)
				animate(whole_screen, transform = newmatrix, time = 5, easing = QUAD_EASING, loop = -1)
				animate(transform = -newmatrix, time = 5, easing = QUAD_EASING)

/client/verb/zoomteststop()
	set category = "DEBUGTEST"
	set name = "ZoomTestEnd"
	if(mob)
		if(iscarbon(mob))
			var/mob/living/carbon/C = mob
			var/list/screens = list(C.hud_used.plane_masters["[FLOOR_PLANE]"], C.hud_used.plane_masters["[GAME_PLANE]"], C.hud_used.plane_masters["[LIGHTING_PLANE]"])
			for(var/whole_screen in screens)
				animate(whole_screen, transform = matrix(), time = 5, easing = QUAD_EASING)

#endif
