/particles/hotspring_steam
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state	= list("steam_cloud_1"=5, "steam_cloud_2"=5, "steam_cloud_3"=5, "steam_cloud_4"=5, "steam_cloud_5"=5)
	color = "#FFFFFF8A"
	count = 2
	spawning = 0.3
	lifespan = 3 SECONDS
	fade = 1.2 SECONDS
	fadein = 0.4 SECONDS
	position = generator(GEN_BOX, list(-17,-15,0), list(24,15,0), NORMAL_RAND)
	scale = generator(GEN_VECTOR, list(0.9,0.9), list(1.1,1.1), NORMAL_RAND)
	drift = generator(GEN_SPHERE, list(-0.01,0), list(0.01,0.01), UNIFORM_RAND)
	spin = generator(GEN_NUM, list(-2,2), NORMAL_RAND)
	gravity = list(0.05, 0.28)
	friction = 0.3
	grow = 0.037

///these were unfortunately requested to not be smoothed. I will likely create a smooth helper version aswell though
///the issue is they would need atleast a 2x2 to smooth proper.
/obj/structure/hotspring
	abstract_type = /obj/structure/hotspring
	name = "hot spring"
	icon = 'icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring"
	nomouseover = TRUE
	plane = FLOOR_PLANE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	object_slowdown = 5

	var/edge = FALSE

	var/obj/effect/abstract/particle_holder/cached/particle_effect

/obj/structure/hotspring/Initialize()
	. = ..()
	particle_effect = new(src, /particles/hotspring_steam, 6)
	//render the steam over mobs and objects on the game plane
	particle_effect.vis_flags &= ~VIS_INHERIT_PLANE

	var/turf/turf = get_turf(src)
	turf.turf_flags |= TURF_NO_LIQUID_SPREAD
	if(!edge)
		turf.path_weight += 1
		AddElement(/datum/element/mob_overlay_effect, 2, -2, 100)

/obj/structure/hotspring/Destroy()
	var/turf/turf = get_turf(src)
	turf.turf_flags &= ~TURF_NO_LIQUID_SPREAD
	if(!edge)
		turf.path_weight -= 1
	. = ..()

/obj/structure/hotspring/Crossed(atom/movable/AM)
	. = ..()
	for(var/obj/structure/S in get_turf(src))
		if(S.obj_flags & BLOCK_Z_OUT_DOWN)
			return

	if(!edge)
		playsound(AM, pick('sound/foley/watermove (1).ogg','sound/foley/watermove (2).ogg'), 40, FALSE)

//Copying turf/water cleaning functionality here
/obj/structure/hotspring/attack_right(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
		playsound(user, pick_n_take(wash), 100, FALSE)
		var/obj/item2wash = user.get_active_held_item()
		if(!item2wash)
			if(get_turf(src) == get_turf(user) && ishuman(user))
				var/mob/living/carbon/human/bather = user
				bather.relaxing_bath(2)
				return
			user.visible_message(span_info("[user] starts to wash in [src]."))
			if(do_after(L, 3 SECONDS, target = src))
				wash_atom(user, CLEAN_STRONG)
				user.remove_stress(/datum/stressevent/sewertouched)
				playsound(user, pick(wash), 100, FALSE)
		else
			user.visible_message(span_info("[user] starts to wash [item2wash] in [src]."))
			if(do_after(L, 30, target = src))
				wash_atom(item2wash, CLEAN_STRONG)
				L.update_inv_hands()
				if(iscarbon(L))
					var/mob/living/carbon/C = user
					C.update_inv_hands()
				playsound(user, pick(wash), 100, FALSE)
		return
	..()



/obj/structure/hotspring/border
	icon_state = "hotspring_border_1"
	object_slowdown = 0
	edge = TRUE

/obj/structure/hotspring/border/two
	icon_state = "hotspring_border_2"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/three
	icon_state = "hotspring_border_3"
	object_slowdown = 0
	edge = TRUE

/obj/structure/hotspring/border/four
	icon_state = "hotspring_border_4"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/five
	icon_state = "hotspring_border_5"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/six
	icon_state = "hotspring_border_6"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/seven
	icon_state = "hotspring_border_7"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/eight
	icon_state = "hotspring_border_8"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/nine
	icon_state = "hotspring_border_9"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/ten
	icon_state = "hotspring_border_10"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/eleven
	icon_state = "hotspring_border_11"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/twelve
	icon_state = "hotspring_border_12"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/thirteen
	icon_state = "hotspring_border_13"
	object_slowdown = 0
	edge = TRUE

/obj/structure/hotspring/border/fourteen
	icon_state = "hotspring_border_14"
	object_slowdown = 0
	edge = TRUE

/obj/structure/flora/hotspring_rocks
	name = "large rock"
	desc = "Swept smooth by the slow erosion of water."
	icon = 'icons/obj/structures/hotspring.dmi'
	icon_state = "bigrock"
	obj_flags = CAN_BE_HIT | IGNORE_SINK
	density = TRUE

/obj/structure/flora/hotspring_rocks/grassy
	name = "grassy large rock"
	icon_state = "bigrock_grass"

/obj/structure/flora/hotspring_rocks/small
	name = "small rock"
	density = FALSE
	icon_state = "stones_1"

/obj/structure/flora/hotspring_rocks/small/two
	icon_state = "stones_2"

/obj/structure/flora/hotspring_rocks/small/three
	icon_state = "stones_3"

/obj/structure/flora/hotspring_rocks/small/four
	icon_state = "stones_4"

/obj/structure/flora/hotspring_rocks/small/five
	icon_state = "stones_5"

/obj/machinery/light/rogue/torchholder/hotspring
	name = "stone lantern"
	desc = "A stone lantern, built in Kazengunese style. It is believed these lanterns attracts spirits and guide their way."
	icon = 'icons/obj/structures/hotspring.dmi'
	icon_state = "stonelantern1"
	torch_off_state = "stonelantern"
	base_state = "stonelantern"

/obj/machinery/light/rogue/torchholder/hotspring/standing
	name = "standing stone lantern"
	icon_state = "stonelantern_standing1"
	torch_off_state = "stonelantern_standing"
	base_state = "stonelantern_standing"

/obj/effect/lily_petal
	name = "lily petals"
	icon = 'icons/obj/structures/hotspring.dmi'
	icon_state = "lilypetals1"

/obj/effect/lily_petal/two
	icon_state = "lilypetals2"

/obj/effect/lily_petal/three
	icon_state = "lilypetals3"

/obj/structure/chair/hotspring_bench
	name = "park bench"
	icon_state = "parkbench_sofamiddle"
	icon = 'icons/obj/structures/hotspring.dmi'
	buildstackamount = 1
	item_chair = null
	anchored = TRUE

/obj/structure/chair/hotspring_bench/left
	icon_state = "parkbench_sofaend_left"

/obj/structure/chair/hotspring_bench/right
	icon_state = "parkbench_sofaend_right"

/obj/structure/chair/hotspring_bench/corner
	icon_state = "parkbench_corner"

/obj/structure/flora/sakura
	name = "cherry blossom tree"
	desc = "A tree that has been introduced from the far east. A symbol of the transience of life. In the islands of Kazengun,\
	it is strongly associated with both romance and death. On the mainland, it is known as a representation of brotherhood.\ "
	icon = 'icons/obj/structures/sakura_tree.dmi'
	icon_state = "sakura_tree"
	obj_flags = CAN_BE_HIT | IGNORE_SINK
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER

	bound_height = 128
	bound_width = 128
