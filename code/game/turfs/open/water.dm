///////////// OVERLAY EFFECTS /////////////
/obj/effect/overlay/water
	icon = 'icons/turf/newwater.dmi'
	icon_state = "bottom"
	density = 0
	mouse_opacity = 0
	layer = BELOW_MOB_LAYER
	anchored = TRUE

/obj/effect/overlay/water/top
	icon_state = "top"
	layer = BELOW_MOB_LAYER


/turf/open/water
	gender = PLURAL
	name = "water"
	desc = "Good enough to drink, wet enough to douse fires."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "together"
	baseturfs = /turf/open/water
	slowdown = 5
	var/obj/effect/overlay/water/water_overlay
	var/obj/effect/overlay/water/top/water_top_overlay
	bullet_sizzle = TRUE
	bullet_bounce_sound = null //needs a splashing sound one day.
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral,/turf/closed/wall/mineral/rogue, /turf/open/floor/rogue)
	footstep = null
	barefootstep = null
	clawfootstep = null
	heavyfootstep = null
	landsound = 'sound/foley/jumpland/waterland.wav'
	neighborlay_override = "edge"
	var/water_color = "#6a9295"
	var/water_reagent = /datum/reagent/water
	var/water_reagent_purified = /datum/reagent/water // If put through a water filtration device, provides this reagent instead
	var/mapped = TRUE // infinite source of water
	var/water_volume = 100 // 100 is 1 bucket
	var/water_maximum = 100
	water_level = 2
	var/wash_in = TRUE
	var/swim_skill = FALSE
	nomouseover = FALSE
	var/swimdir = FALSE

/turf/open/water/Initialize()
	.  = ..()
	water_overlay = new(src)
	water_top_overlay = new(src)
	update_icon()

/turf/open/water/update_icon()
	if(water_overlay)
		water_overlay.color = water_color
		water_overlay.icon_state = "bottom[water_level]"
	if(water_top_overlay)
		water_top_overlay.color = water_color
		water_top_overlay.icon_state = "top[water_level]"

/turf/open/water/Exited(atom/movable/AM, atom/newloc)
	. = ..()
	if(isliving(AM) && !AM.throwing)
		var/mob/living/user = AM
		if(isliving(user) && !user.is_floor_hazard_immune())
			for(var/obj/structure/S in src)
				if(S.obj_flags & BLOCK_Z_OUT_DOWN)
					return
			if(water_overlay)
				if((get_dir(src, newloc) == SOUTH))
					water_overlay.layer = BELOW_MOB_LAYER
					water_overlay.plane = GAME_PLANE
				else
					spawn(6)
						if(!locate(/mob/living) in src)
							water_overlay.layer = BELOW_MOB_LAYER
							water_overlay.plane = GAME_PLANE
			var/drained = get_stamina_drain(user, get_dir(src, newloc))
			if(drained && !user.stamina_add(drained))
				user.Immobilize(30)
				addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, Knockdown), 30), 1 SECONDS)

/turf/open/water/proc/get_stamina_drain(mob/living/swimmer, travel_dir)
	var/const/BASE_STAM_DRAIN = 15
	var/const/MIN_STAM_DRAIN = 2
	var/const/STAM_PER_LEVEL = 5
	var/const/UNSKILLED_ARMOR_PENALTY = 40
	var/const/HEAVY_ARMOR_PENALTY = 30
	var/const/MEDIUM_ARMOR_PENALTY = 20
	var/const/BASE_XP_GAIN = 0.5
	var/const/HEAVY_XP_GAIN = 0.01
	var/const/MEDIUM_XP_GAIN = 0.05
	if(!isliving(swimmer))
		return 0
	if(!swim_skill)
		return 0 // no stam cost
	if(swimmer.is_floor_hazard_immune())
		return 0 // floating!
	if(swimdir && travel_dir && travel_dir == dir)
		return 0 // going with the flow
	if(swimmer.buckled)
		return 0
	if(!ishuman(swimmer))
		return 0
	var/mob/living/carbon/human/H = swimmer
	var/ac = H.highest_ac_worn(check_hands = TRUE)
	var/xpmod = BASE_XP_GAIN
	var/base_drain = BASE_STAM_DRAIN

	switch(ac)
		if(ARMOR_CLASS_HEAVY)
			xpmod = HEAVY_XP_GAIN
			base_drain = HEAVY_ARMOR_PENALTY
		if(ARMOR_CLASS_MEDIUM)
			xpmod = MEDIUM_XP_GAIN
			base_drain = MEDIUM_ARMOR_PENALTY

	var/abyssor_swim_bonus = HAS_TRAIT(swimmer, TRAIT_ABYSSOR_SWIM) ? 5 : 0
	var/swimming_skill_level = swimmer.get_skill_level(/datum/skill/misc/swimming)
	. = max(base_drain - (swimming_skill_level * STAM_PER_LEVEL) - abyssor_swim_bonus, MIN_STAM_DRAIN)
	if(swimmer.mind)
		swimmer.mind.add_sleep_experience(/datum/skill/misc/swimming, swimmer.STAINT * xpmod)
//	. += (swimmer.checkwornweight()*2)
	if(!swimmer.check_armor_skill())
		. += UNSKILLED_ARMOR_PENALTY
	if(.) // this check is expensive so we only run it if we do expect to use stamina
		for(var/obj/structure/S in src)
			if(S.obj_flags & BLOCK_Z_OUT_DOWN)
				return 0
		for(var/D in GLOB.cardinals) //adjacent to a floor to hold onto
			if(istype(get_step(src, D), /turf/open/floor))
				return 0

// Mobs won't try to path through water if low on stamina,
// and will take advantage of water flow to move faster.
/turf/open/water/get_heuristic_slowdown(mob/traverser, travel_dir)
	/// Mobs will heavily avoid pathing through this turf if their stamina is too low.
	var/const/LOW_STAM_PENALTY = 7 // only go through this if we'd have to go offscreen otherwise
	. = ..()
	if(isliving(traverser) && !HAS_TRAIT(traverser, TRAIT_INFINITE_STAMINA))
		var/mob/living/living_traverser = traverser
		var/remaining_stamina = (living_traverser.max_stamina - living_traverser.stamina)
		if(remaining_stamina < get_stamina_drain(living_traverser, travel_dir)) // not enough stamina reserved to cross
			. += LOW_STAM_PENALTY // really want to avoid this unless we don't have any better options

/turf/open/water/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_flag = "blunt")
	..()
	playsound(src, pick('sound/foley/water_land1.ogg','sound/foley/water_land2.ogg','sound/foley/water_land3.ogg'), 100, FALSE)


/turf/open/water/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/water/roguesmooth(adjacencies)
	var/list/Yeah = ..()
	if(water_overlay)
		water_overlay.cut_overlays(TRUE)
		if(Yeah)
			water_overlay.add_overlay(Yeah)
	if(water_top_overlay)
		water_top_overlay.cut_overlays(TRUE)
		if(Yeah)
			water_top_overlay.add_overlay(Yeah)

/turf/open/water/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	for(var/obj/structure/S in src)
		if(S.obj_flags & BLOCK_Z_OUT_DOWN)
			return
	if(istype(AM, /obj/item/reagent_containers/food/snacks/fish))
		var/obj/item/reagent_containers/food/snacks/fish/F = AM
		if (F.sinkable)
			SEND_GLOBAL_SIGNAL(COMSIG_GLOBAL_FISH_RELEASED, F.type, F.rarity_rank)
			F.visible_message("<span class='warning'>[F] dives into \the [src] and disappears!</span>")
			qdel(F)
	if(isliving(AM) && !AM.throwing)
		var/mob/living/L = AM
		if(HAS_TRAIT(L, TRAIT_CURSE_ABYSSOR))
			L.freak_out()
			L.visible_message(span_warning("[L] spasms violently upon touching the water!"), span_danger("The water... it burns me!"))
			L.adjustFireLoss(25)
			return
		if (istype(src,/turf/open/water/bloody))
			L.add_mob_blood(L)

		if(!(L.mobility_flags & MOBILITY_STAND) || water_level == 3)
			L.SoakMob(FULL_BODY)
		else
			if(water_level == 2)
				L.SoakMob(BELOW_CHEST)
		if(water_overlay)
			if(water_level > 1 && !istype(oldLoc, type))
				playsound(AM, 'sound/foley/waterenter.ogg', 100, FALSE)
			else
				playsound(AM, pick('sound/foley/watermove (1).ogg','sound/foley/watermove (2).ogg'), 100, FALSE)
			if(istype(oldLoc, type) && (get_dir(src, oldLoc) != SOUTH))
				water_overlay.layer = ABOVE_MOB_LAYER
				water_overlay.plane = GAME_PLANE_HIGHEST
			else
				spawn(6)
					if(AM.loc == src)
						water_overlay.layer = ABOVE_MOB_LAYER
						water_overlay.plane = GAME_PLANE_HIGHEST
		if(!istype(L, /mob/living/carbon/human/species/skeleton))
			return
		if(!istype(src, /turf/open/water/sewer))
			return
		if(!istype(src, /turf/open/water/swamp))
			return
		L.apply_damage(30, BRUTE, BODY_ZONE_CHEST, forced = TRUE)
		to_chat(L, span_warningbig("The water seeps into my pores. I am crumbling!"))

/turf/open/water/attackby(obj/item/C, mob/user, params)
	if(user.used_intent.type == /datum/intent/fill)
		if(C.reagents)
			if(C.reagents.holder_full())
				to_chat(user, span_warning("[C] is full."))
				return
			playsound(user, 'sound/foley/drawwater.ogg', 100, FALSE)
			if(do_after(user, 8, target = src))
				user.changeNext_move(CLICK_CD_MELEE)
				C.reagents.add_reagent(water_reagent, 200)
				to_chat(user, span_notice("I fill [C] from [src]."))
				// If the user is filling a water purifier and the water isn't already clean...
				if (istype(C, /obj/item/reagent_containers/glass/bottle/waterskin/purifier) && water_reagent != water_reagent_purified)
					var/obj/item/reagent_containers/glass/bottle/waterskin/purifier/P = C
					P.cleanwater(user)
			return
	. = ..()

/turf/open/water/attack_right(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
		playsound(user, pick_n_take(wash), 100, FALSE)
		var/obj/item2wash = user.get_active_held_item()
		if(!item2wash)
			if(istype(src, /turf/open/water/bath) && ishuman(user))
				var/mob/living/carbon/human/bather = user
				bather.relaxing_bath(1)
				return
			user.visible_message(span_info("[user] starts to wash in [src]."))
			if(do_after(L, 3 SECONDS, target = src))
				if(wash_in)
					wash_atom(user, CLEAN_STRONG)
					user.remove_stress(/datum/stressevent/sewertouched)
				playsound(user, pick(wash), 100, FALSE)
				if(istype(src,/turf/open/water/sewer) || istype(src,/turf/open/water/swamp) || istype(src, /turf/open/water/sewer))
					if (istype(src, /turf/open/water/sewer))
						user.add_stress(/datum/stressevent/sewertouched)
					if (!HAS_TRAIT(L,TRAIT_LEECHIMMUNE)) // cleaning yourself in nasty water is a wonderful way to get leeches.
						if (prob(20)) // 1 in 5 chance of getting leeched if you wash up in gross water.
							var/list/zones = list(BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_NECK, BODY_ZONE_HEAD)
							var/zone = pick(zones)
							var/obj/item/bodypart/BP = L.get_bodypart(zone)
							if (BP && !(BP.skeletonized))
								var/obj/item/natural/worms/leech/I = new(L)
								BP.add_embedded_object(I, silent = TRUE)
/*				if(water_reagent == /datum/reagent/water) //become shittified, checks so bath water can be naturally gross but not discolored
					water_reagent = /datum/reagent/water/gross
					water_color = "#a4955b"
					update_icon()*/
				if (istype(src,/turf/open/water/bloody))
					L.add_mob_blood(L) //Yes its their own DNA

		else
			user.visible_message(span_info("[user] starts to wash [item2wash] in [src]."))
			if(do_after(L, 30, target = src))
				if(wash_in)
					wash_atom(item2wash, CLEAN_STRONG)
					L.update_inv_hands()
				if(istype(src,/turf/open/water/bloody))
					item2wash.add_blood_DNA(list("Blood" = random_blood_type()))
				if(iscarbon(L))
					var/mob/living/carbon/C = user
					C.update_inv_hands()
				playsound(user, pick(wash), 100, FALSE)
		return
	..()

/turf/open/water/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.is_mouth_covered())
				return
		user.visible_message(span_info("[user] starts to drink from [src]."))
		drink_act(user, L)
		return
	..()

/turf/open/water/proc/drink_act(mob/user, mob/living/L)
	playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
	if(L.stat != CONSCIOUS)
		return

	if(do_after(L, 25, target = src))
		if (istype(src,/turf/open/water/sewer))
			to_chat(user, span_userdanger("Have I gone mad!? Why am I drinking sewage!?"))
		var/list/waterl = list(src.water_reagent = 5)
		var/datum/reagents/reagents = new()
		reagents.add_reagent_list(waterl)
		reagents.trans_to(L, reagents.total_volume, transfered_by = user, method = INGEST)
		playsound(user,pick('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg'), 100, TRUE)
		drink_act(user, L)
	return

/turf/open/water/Destroy()
	. = ..()
	if(water_overlay)
		QDEL_NULL(water_overlay)
	if(water_top_overlay)
		QDEL_NULL(water_top_overlay)

/turf/open/water/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_flag = "blunt")
	if(!isobj(AM))
		return
	var/obj/O = AM
	if(!O.extinguishable)
		return
	O.extinguish()

/turf/open/water/get_slowdown(mob/user)
	var/returned = slowdown
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/ac = H.highest_ac_worn()
		switch(ac)
			if(ARMOR_CLASS_HEAVY)
				returned += 1.5
			if(ARMOR_CLASS_MEDIUM)
				returned += 1
		if(HAS_TRAIT(user, TRAIT_ABYSSOR_SWIM))
			returned -= 1
	return max(returned, 0.5)

//turf/open/water/Initialize()
//	dir = pick(NORTH,SOUTH,WEST,EAST)
//	. = ..()


/turf/open/water/bath
	name = "water"
	desc = "Soothing water, with soapy bubbles on the surface."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "bathtileW"
	water_level = 2
	water_color = "#FFFFFF"
	slowdown = 3
	water_reagent = /datum/reagent/water/bathwater

/turf/open/water/bath/Initialize()
	.  = ..()
	icon_state = "bathtile"

/turf/open/water/sewer
	name = "sewage"
	desc = "This dark water smells like dead rats and sulphur!"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "pavingW"
	water_level = 1
	water_color = "#705a43"
	slowdown = 3
	wash_in = FALSE
	water_reagent = /datum/reagent/water/gross/sewage

/turf/open/water/sewer/Initialize()
	icon_state = "paving"
	water_color = pick("#705a43","#697043")
	.  = ..()

/turf/open/water/swamp
	name = "murk"
	desc = "Weeds and algae cover the surface of the water."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "dirtW2"
	water_level = 2
	water_color = "#705a43"
	slowdown = 3
	wash_in = TRUE
	water_reagent = /datum/reagent/water/gross

/turf/open/water/bloody
	name = "blood"
	desc = "Is that... a river of blood? EVIL!"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "dirtW2"
	water_level = 2
	water_color = "#941010"
	slowdown = 3
	wash_in = FALSE
	water_reagent = /datum/reagent/blood/shitty

/turf/open/water/swamp/Initialize()
	icon_state = "dirt"
	dir = pick(GLOB.cardinals)
	water_color = pick("#705a43")
	.  = ..()

/turf/open/water/bloody/Initialize()
	icon_state = "dirt"
	dir = pick(GLOB.cardinals)
	water_color = pick("#880808")
	.  = ..()





/turf/open/water/swamp/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(HAS_TRAIT(AM, TRAIT_LEECHIMMUNE))
		return
	if(isliving(AM) && !AM.throwing)
		if(ishuman(AM))
			var/mob/living/carbon/human/C = AM
			// check if we're riding a boat or a mount (we can presume a living mob is a mount), no leeches if so
			if(istype(C.buckled, /obj/vehicle/ridden) || isliving(C.buckled))
				return
			var/chance = 3
			if(C.m_intent == MOVE_INTENT_RUN)
				chance = 6
			if(C.m_intent == MOVE_INTENT_SNEAK)
				chance = 1
			if(!prob(chance))
				return
			if(C.blood_volume <= 0)
				return
			var/list/zonee = list(BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_CHEST)
			for(var/i = 0, i <= zonee.len, i++)
				var/zone = pick(zonee)
				var/obj/item/bodypart/BP = C.get_bodypart(zone)
				if(!BP)
					continue
				if(BP.skeletonized)
					continue
				var/obj/item/natural/worms/leech/I = new(C)
				BP.add_embedded_object(I, silent = TRUE)
				return .

/turf/open/water/swamp/deep
	name = "murk"
	desc = "Deep water with several weeds and algae on the surface."
	icon_state = "dirtW"
	water_level = 3
	water_color = "#705a43"
	slowdown = 5
	swim_skill = TRUE

/turf/open/water/swamp/deep/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(HAS_TRAIT(AM, TRAIT_LEECHIMMUNE))
		return
	if(isliving(AM) && !AM.throwing)
		if(ishuman(AM))
			var/mob/living/carbon/human/C = AM
			// check if we're riding a boat or a mount (we can presume a living mob is a mount), no leeches if so
			if(istype(C.buckled, /obj/vehicle/ridden) || isliving(C.buckled))
				return
			var/chance = 6
			if(C.m_intent == MOVE_INTENT_RUN)
				chance = 12		//yikes
			if(C.m_intent == MOVE_INTENT_SNEAK)
				chance = 2
			if(!prob(chance))
				return
			if(C.blood_volume <= 0)
				return
			var/list/zonee = list(BODY_ZONE_CHEST,BODY_ZONE_R_LEG,BODY_ZONE_L_LEG,BODY_ZONE_R_ARM,BODY_ZONE_L_ARM)
			for(var/i = 0, i <= zonee.len, i++)
				var/zone = pick(zonee)
				var/obj/item/bodypart/BP = C.get_bodypart(zone)
				if(!BP)
					continue
				if(BP.skeletonized)
					continue
				var/obj/item/natural/worms/leech/I = new(C)
				BP.add_embedded_object(I, silent = TRUE)
				return .

/turf/open/water/cleanshallow
	name = "water"
	desc = "Clear and shallow water, what a blessing!"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "rockw2"
	water_level = 2
	slowdown = 3
	wash_in = TRUE
	water_reagent = /datum/reagent/water

/turf/open/water/cleanshallow/Initialize()
	icon_state = "rock"
	dir = pick(GLOB.cardinals)
	.  = ..()

/turf/open/water/river
	name = "river"
	desc = "A river of crystal clear water flows swiftly along the contours of the land."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "rivermove"
	water_level = 3
	slowdown = 5
	wash_in = TRUE
	swim_skill = TRUE
	swimdir = TRUE

/turf/open/water/river/flow
	icon_state = "rockwd"

/turf/open/water/river/flow/west
	dir = 8

/turf/open/water/river/flow/east
	dir = 4

/turf/open/water/river/flow/north
	dir = 1

/turf/open/water/river/update_icon()
	if(water_overlay)
		water_overlay.color = water_color
		water_overlay.icon_state = "riverbot"
		water_overlay.dir = dir
	if(water_top_overlay)
		water_top_overlay.color = water_color
		water_top_overlay.icon_state = "rivertop"
		water_top_overlay.dir = dir

/turf/open/water/river/Initialize()
	icon_state = "rock"
	.  = ..()

/turf/open/water/river/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	START_PROCESSING(SSrivers, src)

/turf/open/water/river/get_heuristic_slowdown(mob/traverser, travel_dir)
	var/const/UPSTREAM_PENALTY = 4
	var/const/DOWNSTREAM_BONUS = -1
	var/const/SIDESTREAM_PENALTY = 2
	. = ..()
	if(traverser.is_floor_hazard_immune())
		return
	for(var/obj/structure/S in src)
		if(S.obj_flags & BLOCK_Z_OUT_DOWN)
			return
	if(travel_dir == dir) // downriver
		. += DOWNSTREAM_BONUS // faster!
	else if(travel_dir == GLOB.reverse_dir[dir]) // upriver
		. += UPSTREAM_PENALTY // slower
	else
		. += SIDESTREAM_PENALTY // sidestream walking isn't free, bro

/turf/open/water/river/proc/process_river()
	var/found_movable = FALSE
	for(var/atom/movable/A in contents)
		found_movable = TRUE
		for(var/obj/structure/S in src)
			if(S.obj_flags & BLOCK_Z_OUT_DOWN)
				return
		if((A.loc == src))
			A.ConveyorMove(dir)

	if(found_movable)
		STOP_PROCESSING(SSrivers, src)
		return

/turf/open/water/river/CanPass(atom/movable/mover, turf/target)
	if(isliving(mover))
		var/mob/mover_mob = mover
		// prevent NPCs from constantly trying to go against the flow
		if(!mover_mob.mind && get_dir(src, mover) == dir)
			return FALSE
	return ..()

/turf/open/water/ocean
	name = "salt water"
	desc = "The waves lap at the coast, hungry to swallow the land. Doesn't look too deep."
	icon_state = "ash"
	icon = 'icons/turf/roguefloor.dmi'
	water_level = 2
	water_color = "#3e7459"
	slowdown = 4
	swim_skill = TRUE
	wash_in = TRUE
	water_reagent = /datum/reagent/water/salty

/turf/open/water/ocean/deep
	name = "salt water"
	desc = "Deceptively deep, be careful not to find yourself this far out."
	icon_state = "water"
	icon = 'icons/turf/roguefloor.dmi'
	water_level = 3
	water_color = "#3e7459"
	slowdown = 8
	swim_skill = TRUE
	wash_in = TRUE

/turf/open/water/pond
	name = "pond"
	desc = "Still and alarmingly idyllic water. Covered in concerning overgrowth of duckweed."
	icon_state = "pond"
	icon = 'icons/turf/roguefloor.dmi'
	water_level = 3
	water_color = "#367e94"
	slowdown = 3
	swim_skill = TRUE
	wash_in = TRUE
	water_reagent = /datum/reagent/water/gross
