/obj/effect/temp_visual/hunting_phantom
	name = "approaching quarry"
	desc = "Something is moving in the brush..."
	icon_state = ""
	layer = MOB_LAYER
	plane = GAME_PLANE
	alpha = 50
	anchored = TRUE
	var/mob_type_to_spawn
	var/spawn_delay = 15 SECONDS
	var/rot_path
	var/list/target_factions
	var/skip_parent_call = FALSE
	duration = 20 SECONDS
	mouse_opacity = MOUSE_OPACITY_ICON

/obj/effect/temp_visual/hunting_phantom/Initialize(mapload, target_mob_path, target_rot, custom_delay)
	if(custom_delay)
		spawn_delay = custom_delay
	. = ..()
	if(skip_parent_call)
		return
	if(!ispath(target_mob_path))
		return INITIALIZE_HINT_QDEL

	mob_type_to_spawn = target_mob_path
	rot_path = target_rot
	var/mob/living/path_cast = target_mob_path
	src.icon = initial(path_cast.icon)
	src.icon_state = initial(path_cast.icon_state)
	src.pixel_x = initial(path_cast.pixel_x)
	src.pixel_y = initial(path_cast.pixel_y)
	src.color = "#777777" 
	appear_and_wait()

/obj/effect/temp_visual/hunting_phantom/proc/appear_and_wait()
	animate(src, alpha = 200, time = spawn_delay, easing = EASE_IN)
	playsound(src, 'sound/misc/jumpscare (4).ogg', 50, TRUE)
	addtimer(CALLBACK(src, .proc/finalize_spawn), spawn_delay)

/obj/effect/temp_visual/hunting_phantom/proc/finalize_spawn()
	var/turf/T = get_turf(src)
	if(T)
		var/mob/living/real_mob = new mob_type_to_spawn(T)
		if(rot_path)
			real_mob.rot_type = rot_path
		real_mob.faction |= "hunting_ambush"

		T.visible_message(span_boldwarning("The [real_mob.name] lunges out from the shadows!"))
		playsound(T, 'sound/items/seedextract.ogg', 100, TRUE)
	qdel(src)
