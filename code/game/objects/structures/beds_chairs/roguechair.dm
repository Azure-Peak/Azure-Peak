/obj/structure/chair/bench
	name = "bench"
	desc = "A stouter, wider chair. It doesn't look terribly comfortable."
	icon_state = "bench"
	icon = 'icons/roguetown/misc/structure.dmi'
	buildstackamount = 1
	item_chair = null
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"
	sleepy = 0.5
//	pixel_y = 10
	layer = OBJ_LAYER

/obj/structure/chair/bench/church
	icon_state = "church_benchleft"

/obj/structure/chair/bench/church/mid
	icon_state = "church_benchmid"

/obj/structure/chair/bench/church/r
	icon_state = "church_benchright"

/obj/structure/chair/bench/Initialize()
	. = ..()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)
	handle_layer()

/obj/structure/chair/bench/handle_layer()
	if(dir == NORTH)
		layer = ABOVE_MOB_LAYER
		plane = GAME_PLANE_UPPER
	else
		layer = OBJ_LAYER
		plane = GAME_PLANE

/obj/structure/chair/bench/post_buckle_mob(mob/living/M)
	..()
	density = TRUE

/obj/structure/chair/bench/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE

/obj/structure/chair/bench/CanAStarPass(ID, travel_dir, caller)
	if(travel_dir == dir)
		return FALSE // don't even bother climbing over it
	return ..()

/obj/structure/chair/bench/CanPass(atom/movable/mover, turf/target)
	if(get_dir(mover,loc) == dir)
		return 0
	return !density

/obj/structure/chair/bench/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(istype(leaving, /obj/projectile))
		return
	if(get_dir(new_location, leaving.loc) == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/chair/bench/couch
	desc = "A comfortable-looking piece of furniture, padded with fabric!"
	icon_state = "redcouch"

/obj/structure/chair/bench/church/smallbench
	desc = "An unusually small, modest bench. Better than the floor."
	icon_state = "benchsmall"

/obj/structure/chair/bench/couch/r
	icon_state = "redcouch2"

/obj/structure/chair/bench/ultimacouch
	desc = "A particularly affluent piece of furniture, upholstered with brown-green fabric."
	icon_state = "ultimacouchleft"

/obj/structure/chair/bench/ultimacouch/r
	icon_state = "ultimacouchright"

/obj/structure/chair/bench/coucha
	desc = "A particularly affluent piece of furniture, upholstered with red fabric."
	icon_state = "couchaleft"

/obj/structure/chair/bench/coucha/r
	icon_state = "coucharight"

/obj/structure/chair/bench/couchablack
	desc = "A particularly affluent piece of furniture, upholstered with black fabric."
	icon_state = "couchablackaleft"

/obj/structure/chair/bench/couchablack/r
	icon_state = "couchablackaright"

/obj/structure/chair/bench/couchamagenta
	desc = "A particularly affluent piece of furniture, upholstered with magenta fabric."
	icon_state = "couchamagentaleft"

/obj/structure/chair/bench/couchamagenta/r
	icon_state = "couchamagentaright"

/obj/structure/chair/bench/couch/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/structure/chair/bench/couch/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/structure/chair/bench/couch/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "[icon_state]_primary", -(layer+0.1))
	M.color = secondary //looks better
	add_overlay(M)

/obj/structure/chair/wood/rogue
	icon_state = "chair2"
	icon = 'icons/roguetown/misc/structure.dmi'
	item_chair = /obj/item/chair/rogue
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"

/obj/structure/chair/wood/rogue/Initialize()
	. = ..()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/chair/wood/rogue/chair3
	icon_state = "chair3"
	icon = 'icons/roguetown/misc/structure.dmi'
	item_chair = /obj/item/chair/rogue
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"

/obj/structure/chair/wood/rogue/chair4
	icon_state = "chair4"
	icon = 'icons/roguetown/misc/structure.dmi'
	item_chair = /obj/item/chair/rogue
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"

/obj/structure/chair/wood/rogue/chair5
	icon_state = "chair5"
	icon = 'icons/roguetown/misc/structure.dmi'
	item_chair = /obj/item/chair/rogue
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"

/obj/structure/chair/wood/rogue/throne
	icon_state = "thronechair"
	desc = "Someone important must sit here."
	icon = 'icons/roguetown/misc/structure.dmi'
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"
	item_chair = null

/obj/item/chair/rogue
	name = "chair"
	icon = 'icons/roguetown/items/chairs.dmi'
	icon_state = "chair2"
	origin_type = /obj/structure/chair/wood/rogue
	blade_dulling = DULLING_BASHCHOP
	can_parry = TRUE
	force = 20
	force_wielded = 20
	throwforce = 25
	wdefense = 1
	possible_item_intents = list(/datum/intent/mace/strike/wood, /datum/intent/mace/smash/wood)
	gripped_intents = list(/datum/intent/mace/strike/wood, /datum/intent/mace/smash/wood)
	max_integrity = 50
	obj_flags = CAN_BE_HIT
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"

/obj/item/chair/rogue/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("wieldedl")
				return list("shrink" = 0.7,"sx" = 2,"sy" = 1,"nx" = -17,"ny" = 0,"wx" = -11,"wy" = 0,"ex" = 2,"ey" = 0,"westabove" = 1,"eastbehind" = 0,"nturn" = 9,"sturn" = -42,"wturn" = 21,"eturn" = -27,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 2,"sy" = 1,"nx" = -17,"ny" = 0,"wx" = -11,"wy" = 0,"ex" = 2,"ey" = 0,"westabove" = 1,"eastbehind" = 0,"nturn" = 9,"sturn" = -42,"wturn" = 21,"eturn" = -27,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,)
	..()

/obj/structure/chair/wood/rogue/CanPass(atom/movable/mover, turf/target)
	if(isliving(mover))
		var/mob/living/M = mover
		if((M.mobility_flags & MOBILITY_STAND))
			if(isturf(loc))
				var/movefrom = get_dir(M.loc, loc)
				if(movefrom == dir && item_chair)
					playsound(loc, 'sound/foley/chairfall.ogg', 100, FALSE)
					var/obj/item/I = new item_chair(loc)
					item_chair = null
					I.dir = dir
					qdel(src)
					return FALSE
	return ..()


/obj/structure/chair/wood/rogue/onkick(mob/user)
	if(!user)
		return
	if(isturf(loc))
		playsound(loc, 'sound/foley/chairfall.ogg', 100, FALSE)
		var/obj/item/I = new item_chair(loc)
		item_chair = null
		I.dir = dir
		qdel(src)
		return FALSE

/obj/structure/chair/wood/rogue/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(!isliving(leaving))
		return
	var/mob/living/M = leaving
	if(!(M.mobility_flags & MOBILITY_STAND))
		return
	if(get_dir(leaving.loc, new_location) == REVERSE_DIR(dir))
		playsound(loc, 'sound/foley/chairfall.ogg', 100, FALSE)
		var/obj/item/I = new item_chair(loc)
		item_chair = null
		I.dir = dir
		qdel(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/chair/wood/rogue/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1)
	if(damage_amount > 5 && item_chair != null)
		playsound(loc, 'sound/foley/chairfall.ogg', 100, FALSE)
		var/obj/item/I = new item_chair(loc)
		item_chair = null
		I.dir = dir
		qdel(src)
		return FALSE
	return ..()

/obj/structure/chair/wood/rogue/fancy
	icon_state = "chair1"
	item_chair = /obj/item/chair/rogue/fancy

/obj/item/chair/rogue/fancy
	icon_state = "chair1"
	origin_type = /obj/structure/chair/wood/rogue/fancy

/obj/structure/chair/wood/rogue/attack_right(mob/user)
	var/datum/component/simple_rotation/rotcomp = GetComponent(/datum/component/simple_rotation)
	if(rotcomp)
		rotcomp.HandRot(rotcomp,user,ROTATION_CLOCKWISE)

/obj/structure/chair/wood/rogue
//	pixel_y = 5

/obj/structure/chair/wood/rogue/post_buckle_mob(mob/living/M)
	..()
	density = TRUE
//	M.set_mob_offsets("bed_buckle", _x = 0, _y = 5)

/obj/structure/chair/wood/rogue/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE
//	M.reset_offsets("bed_buckle")


/obj/structure/chair/stool/rogue
	name = "stool"
	desc = "Three stubby legs nailed to the underside of a small round seat. Stable, if simple."
	icon_state = "barstool"
	icon = 'icons/roguetown/misc/structure.dmi'
	item_chair = /obj/item/chair/stool/bar/rogue
	max_integrity = 100
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"

/obj/item/chair/stool/bar/rogue
	name = "stool"
	desc = "Three stubby legs nailed to the underside of a small round seat. Stable, if simple."
	icon_state = "baritem"
	icon = 'icons/roguetown/misc/structure.dmi'
	origin_type = /obj/structure/chair/stool/rogue
	blade_dulling = DULLING_BASHCHOP
	can_parry = TRUE
	force = 15
	force_wielded = 15
	throwforce = 20
	wdefense = 1
	possible_item_intents = list(/datum/intent/mace/strike/wood, /datum/intent/mace/smash/wood)
	gripped_intents = list(/datum/intent/mace/strike/wood, /datum/intent/mace/smash/wood)
	max_integrity = 50
	obj_flags = CAN_BE_HIT
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"

/obj/item/chair/stool/bar/rogue/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("wieldedl")
				return list("shrink" = 0.8,"sx" = 3,"sy" = -8,"nx" = -19,"ny" = -6,"wx" = -13,"wy" = -7,"ex" = 1,"ey" = -5,"westabove" = 1,"eastbehind" = 0,"nturn" = 30,"sturn" = -18,"wturn" = 30,"eturn" = -24,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = -20,"sy" = -6,"nx" = 0,"ny" = -7,"wx" = -18,"wy" = -5,"ex" = -4,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -42,"sturn" = 33,"wturn" = 33,"eturn" = -21,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)

/obj/structure/bed/rogue
	icon_state = "bed"
	icon = 'icons/roguetown/misc/beds.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	sleepy = 3
	debris = list(/obj/item/grown/log/tree/small = 1)

/obj/structure/bed/rogue/OnCrafted(dirin)
	dirin = turn(dirin, 180)
	. = ..(dirin)
	update_icon()

/obj/structure/bed/rogue/attack_right(mob/user)
	var/datum/component/simple_rotation/rotcomp = GetComponent(/datum/component/simple_rotation)
	if(rotcomp)
		rotcomp.HandRot(rotcomp,user,ROTATION_CLOCKWISE)

/obj/structure/bed/rogue/shit
	name = "straw bed"
	desc = "A rough bed of straw. It's scratchy, and probably hides lots of bugs, but at least it's dry and warm."
	icon_state = "shitbed"
	sleepy = 1.5

/obj/structure/bed/rogue/post_buckle_mob(mob/living/M)
	..()
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 5)

/obj/structure/bed/rogue/post_unbuckle_mob(mob/living/M)
	..()
	M.reset_offsets("bed_buckle")

/obj/structure/bed/rogue/bedroll
	name = "bedroll"
	desc = "So you can sleep on the ground in relative peace."
	icon_state = "bedroll"
	attacked_sound = 'sound/foley/cloth_rip.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	sleepy = 2

/obj/structure/bed/rogue/bedroll/attack_hand(mob/user, params)
	..()
	user.visible_message(span_notice("[user] begins rolling up \the [src]."))
	if(do_after(user, 2 SECONDS, TRUE, src))
		var/obj/item/bedroll/new_bedroll = new /obj/item/bedroll(get_turf(src))
		new_bedroll.color = src.color
		qdel(src)

/obj/item/bedroll
	name = "rolled bedroll"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bedroll_r"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	grid_width = 32
	grid_height = 64

/obj/item/bedroll/attack_self(mob/user, params)
	..()
	var/turf/T = get_turf(loc)
	if(!isfloorturf(T))
		to_chat(user, span_warning("I need ground to plant this on!"))
		return
	for(var/obj/A in T)
		if(istype(A, /obj/structure))
			to_chat(user, span_warning("I need some free space to deploy a [src] here!"))
			return
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(user, span_warning("There is already something here!</span>"))
			return
	user.visible_message(span_notice("[user] begins placing \the [src] down on the ground."))
	if(do_after(user, 2 SECONDS, TRUE, src))
		var/obj/structure/bed/rogue/bedroll/new_bedroll = new /obj/structure/bed/rogue/bedroll(get_turf(src))
		new_bedroll.color = src.color
		qdel(src)

/obj/structure/bed/rogue/inn
	icon_state = "inn_bed"
	icon = 'icons/roguetown/misc/beds.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	sleepy = 3
	debris = list(/obj/item/grown/log/tree/small = 1)

/obj/structure/bed/rogue/inn/wooldouble
	icon_state = "double_wool"
	icon = 'icons/roguetown/misc/beds.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	pixel_y = 0
	sleepy = 3
	debris = list(/obj/item/grown/log/tree/small = 2)

/obj/structure/bed/rogue/inn/double
	icon_state = "double"
	icon = 'icons/roguetown/misc/beds.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	pixel_y = 0
	sleepy = 3
	debris = list(/obj/item/grown/log/tree/small = 2)
/*            ///////WIP  This will essentially allow for multiple mobs to buckle, just needs to change mousedrop function
/obj/structure/bed/rogue/inn/double
	var/list/buckled_mobs = list()

/obj/structure/bed/rogue/inn/double/post_buckle_mob(mob/living/M)
	. = ..()
	if(!buckled_mobs)
		buckled_mobs = list()
	buckled_mobs += M
	M.set_mob_offsets("bed_buckle", _x = buckled_mobs.len * 10, _y = 5)

/obj/structure/bed/rogue/inn/double/post_unbuckle_mob(mob/living/M)
	. = ..()
	if(M in buckled_mobs)
		buckled_mobs -= M
	M.reset_offsets("bed_buckle")

	var/x_offset = 0
	for(var/mob/living/buckled_mob in buckled_mobs)
		buckled_mob.set_mob_offsets("bed_buckle", _x = x_offset, _y = 5)
		x_offset += 10
*/
/obj/structure/bed/rogue/inn/hay
	icon_state = "haybed"
	icon = 'icons/roguetown/misc/beds.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	sleepy = 2
	debris = list(/obj/item/grown/log/tree/small = 1)

/obj/structure/bed/rogue/inn/wool
	icon_state = "woolbed"
	icon = 'icons/roguetown/misc/beds.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	sleepy = 3
	debris = list(/obj/item/grown/log/tree/small = 1)

/obj/structure/bed/rogue/inn/pileofshit
	icon_state = "shitbed2"
	icon = 'icons/roguetown/misc/beds.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	sleepy = 1
