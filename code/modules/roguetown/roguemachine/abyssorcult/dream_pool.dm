/obj/structure/roguemachine/dream_pool
	name = "dream pool"
	desc = ""
	icon = 'icons/obj/structures/abyssor_pool.dmi'
	icon_state = "whirl"
	resistance_flags = INDESTRUCTIBLE
	pixel_x = -32
	pixel_y = -32
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
	var/obj/structure/dream_pool_door/linked_door
	/// Tracks if a group ritual is actively processing right now
	var/ritual_active = FALSE
	redstone_structure = TRUE

/obj/structure/roguemachine/dream_pool/Initialize(mapload)
	. = ..()
	linked_door = new /obj/structure/dream_pool_door(get_turf(src))
	linked_door.linked_pool = src
	update_icon()

/obj/structure/roguemachine/dream_pool/proc/get_outer_rim_turfs()
	var/list/turf/outer_rim = list()
	var/turf/center = get_turf(src)
	if(!center)
		return outer_rim
	for(var/turf/T in range(2, center))
		if(get_dist(center, T) == 2)
			outer_rim += T
	return outer_rim

/obj/structure/roguemachine/dream_pool/examine(mob/user)
	. = ..()
	if(linked_door?.gate_closed)
		. += "\n<span class='notice'>Incredibly heavy, rusty doors obscure the contents of this elaborate metallic indentation. It looks very old.</span>"
	else
		. += "\n<span class='notice'>The gate doors have retracted. A swirling vortex bombards you with imagery of a strange realm. Just looking into it makes you dizzy, best not to stare... Especially as something gazes back from beneath the surface.</span>"

/obj/structure/roguemachine/dream_pool/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(linked_door)
		linked_door.attack_hand(user, modifiers)

/obj/structure/dream_pool_door
	name = "dream pool door"
	desc = ""
	icon = 'icons/obj/structures/abyssor_pool.dmi'
	icon_state = "door"
	resistance_flags = INDESTRUCTIBLE
	pixel_x = -32
	pixel_y = -32
	layer = ABOVE_OBJ_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/gate_closed = TRUE
	var/animating = FALSE
	var/obj/structure/roguemachine/dream_pool/linked_pool
	var/mutable_appearance/frame_overlay

/obj/structure/dream_pool_door/Initialize(mapload)
	. = ..()
	frame_overlay = mutable_appearance(icon, "frame")
	update_icon()

/obj/structure/dream_pool_door/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(animating)
		to_chat(user, span_warning("The gate mechanism is currently operating!"))
		return
	if(gate_closed)
		open_gate(user)
	else
		close_gate(user)

/obj/structure/dream_pool_door/proc/open_gate(mob/user)
	animating = TRUE
	visible_message(span_notice("[src]'s heavy frame groans as the portal lock turns."))
	flick("door_opening", src)
	addtimer(CALLBACK(src, PROC_REF(finish_open_gate)), 50)

/obj/structure/dream_pool_door/proc/close_gate(mob/user)
	animating = TRUE
	visible_message(span_notice("The frame clangs as the pool doors begin sliding back into place."))
	flick("door_closing", src)
	addtimer(CALLBACK(src, PROC_REF(finish_close_gate)), 50)

/obj/structure/dream_pool_door/proc/finish_open_gate()
	gate_closed = FALSE
	animating = FALSE
	icon_state = null
	visible_message(span_purple("With a heavy hiss, the dream pool's gate slides fully open!"))
	update_icon()
	playsound(src, 'sound/foley/lever.ogg', 100)

/obj/structure/dream_pool_door/proc/finish_close_gate()
	gate_closed = TRUE
	animating = FALSE
	icon_state = "door"
	visible_message(span_notice("[src]'s rusty seal locks tightly into place."))
	update_icon()
	playsound(src, 'sound/foley/lever.ogg', 100)

/obj/structure/dream_pool_door/update_overlays()
	. = ..()
	if(frame_overlay)
		. += frame_overlay

/obj/structure/dream_pool_door/Destroy()
	if(linked_pool)
		linked_pool.linked_door = null
		linked_pool = null
	return ..()

/obj/structure/roguemachine/dream_pool/proc/handle_ritual_start(mob/living/carbon/human/user)
	if(!linked_door || linked_door.gate_closed)
		to_chat(user, span_warning("The dream pool's gate must be wide open to harness the abyss!"))
		return
	if(ritual_active)
		to_chat(user, span_warning("The pool is already fluctuating with a ritualistic current!"))
		return
	if(!length(GLOB.abyssal_rituals))
		initialize_abyssal_rituals()

	var/datum/tgui_module/vortex_ritual_selection/module = new(src, user)
	module.ui_interact(user)

/obj/structure/roguemachine/dream_pool/proc/coordinate_channeling_loop(mob/living/carbon/human/leader, datum/abyssal_ritual/R)
	ritual_active = TRUE
	visible_message(span_purple("[leader] begins chanting, calling upon the abyssal currents…"))

	var/duration = R.base_channel_time
	var/list/turf/outer_rim = get_outer_rim_turfs()
	var/list/mob/living/active_channelers
	var/list/datum/beam/active_beams

	var/list/invocations = R.invocation_phases
	if(!length(invocations))
		invocations = list("Abyssor, hwja'ajaba!")
	var/phases = invocations.len
	var/phase_time = duration / phases

	playsound(src, 'sound/magic/teleport_diss.ogg', 100, TRUE)

	for(var/phase in 1 to phases)
		active_channelers = list(leader)
		for(var/mob/living/carbon/human/M in range(2, src))
			if(M == leader || M.stat != CONSCIOUS)
				continue
			if(get_turf(M) in outer_rim)
				active_channelers += M

		if(!active_channelers.len)
			visible_message(span_warning("No one remains to channel the ritual! It collapses."))
			collapse_ritual()
			return

		var/phase_invocation = invocations[phase] || "Abyssor, hwja'ajaba!"
		for(var/mob/living/P in active_channelers)
			P.say(phase_invocation, language = /datum/language/abyssal, ignore_spam = TRUE)

		active_beams = list()
		var/turf/pool_turf = get_turf(src)
		for(var/mob/living/P in active_channelers)
			active_beams += pool_turf.Beam(P, icon_state = "b_beam", time = phase_time, maxdistance = 10)

		var/drain_per_phase = 15
		for(var/mob/living/P in active_channelers)
			if(P.energy)
				P.energy_add(-drain_per_phase)

		if(!do_after(leader, phase_time, target = src, extra_checks = CALLBACK(src, PROC_REF(channel_check), leader, outer_rim)))
			to_chat(leader, span_warning("Your connection falters! The ritual is interrupted."))
			for(var/datum/beam/B in active_beams)
				B.End()
			collapse_ritual()
			return

		for(var/datum/beam/B in active_beams)
			B.End()

		if(linked_door?.gate_closed || !R.check_ingredients(src))
			visible_message(span_warning("The pool's configuration changed mid-ritual! The abyss recoils."))
			collapse_ritual()
			return

	var/list/mob/living/final_channelers = list()
	for(var/mob/living/M in range(2, src))
		if(M.stat == CONSCIOUS && (get_turf(M) in outer_rim))
			final_channelers += M

	R.consume_ingredients(src, final_channelers)
	R.on_success(src, leader, final_channelers)
	playsound(src, 'sound/magic/cosmic_expansion.ogg', 100, TRUE)
	ritual_active = FALSE

/obj/structure/roguemachine/dream_pool/proc/collapse_ritual()
	ritual_active = FALSE
	playsound(src, 'sound/misc/slip.ogg', 100, TRUE)

/obj/structure/roguemachine/dream_pool/proc/channel_check(mob/living/carbon/human/leader, list/turf/outer_rim)
	if(QDELETED(leader) || leader.stat != CONSCIOUS)
		return FALSE
	return (get_turf(leader) in outer_rim)

/obj/structure/roguemachine/dream_pool/proc/spawn_deep_one_wave(list/deep_ones_left, list/landing_spots)
	if(!length(deep_ones_left) || !length(landing_spots))
		return

	var/deep_one_path = deep_ones_left[1]
	deep_ones_left -= deep_one_path

	var/turf/spawn_turf = pick(landing_spots)
	var/mob/living/D = new deep_one_path(spawn_turf)
	if(D)
		D.setDir(pick(NORTH, SOUTH, EAST, WEST))
		D.visible_message(span_purple("A secondary undertow surges, leaving [D] onto the ground!"))
		generate_inundation_loot(spawn_turf)

	if(length(deep_ones_left))
		addtimer(CALLBACK(src, PROC_REF(spawn_deep_one_wave), deep_ones_left, landing_spots), 1 SECONDS)

/obj/structure/roguemachine/dream_pool/proc/generate_inundation_loot(turf/spawn_turf)
	if(!spawn_turf)
		return null

	var/list/loot_weights = list(
		/obj/item/reagent_containers/food/snacks/fish/oyster = 250,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 250,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 220,
		/obj/item/reagent_containers/food/snacks/fish/angler = 210,
		/obj/item/reagent_containers/food/snacks/fish/clam = 190,
		/obj/item/reagent_containers/food/snacks/fish/crab = 250,
		/obj/item/clothing/head/roguetown/octopus = 36,
		/obj/item/reagent_containers/food/snacks/fish/lobster = 420,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 360,
		/obj/item/reagent_containers/food/snacks/fish/creepy_eel = 30,
		/obj/item/reagent_containers/food/snacks/fish/creepy_squid = 30,
		/obj/item/reagent_containers/food/snacks/fish/creepy_shark = 30,

		/obj/item/reagent_containers/glass/bottle/rogue/wine = 63,
		/obj/item/clothing/ring/gold = 94,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 178,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 60,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 15,

		/obj/item/grown/log/tree/stick = 102,
		/obj/item/natural/cloth = 2,
		/obj/item/ammo_casing/caseless/rogue/arrow = 2,
		/obj/item/reagent_containers/glass/bottle/rogue = 3,

		/obj/item/roguegem/green = 15,
		/obj/item/roguegem/blue = 15,
		/obj/item/roguegem/yellow = 15,
		/obj/item/roguegem/violet = 15,
		/obj/item/roguegem/ruby = 15,
		/obj/item/roguegem/diamond = 1,
		/obj/item/roguegem/onyxa = 10,
		/obj/item/roguegem/jade = 10,
		/obj/item/roguegem/oyster = 50,
		/obj/item/roguegem/coral = 15,
		/obj/item/roguegem/turq = 15,
		/obj/item/roguegem/amber = 10,
		/obj/item/roguegem/opal = 5,

		/obj/item/carvedgem/shell/rawshell = 45,
		/obj/item/carvedgem/shell/cameo = 30,
		/obj/item/kitchen/fork/carved/jade = 25,
		/obj/item/kitchen/spoon/carved/onyxa = 25,
		/obj/item/reagent_containers/glass/bowl/carved/shell = 25,

		/obj/item/clothing/ring/jade = 20,
		/obj/item/clothing/neck/roguetown/carved/shellamulet = 20,
		/obj/item/carvedgem/jade/fish = 22,
		/obj/item/carvedgem/rose/fish = 22,
		/obj/item/carvedgem/onyxa/fish = 22,
		/obj/item/reagent_containers/glass/bucket/pot/carved/teapotshell = 15,

		/obj/item/carvedgem/jade/duck = 15,
		/obj/item/carvedgem/shell/duck = 15,
		/obj/item/carvedgem/rose/duck = 15,
		/obj/item/carvedgem/onyxa/duck = 15,
		/obj/item/clothing/wrists/roguetown/gem/jadebracelet = 12,
		/obj/item/clothing/head/roguetown/circlet/carvedgem/onyxa = 10,
		/obj/item/carvedgem/rose/fancyvase = 12,

		/obj/item/clothing/mask/rogue/facemask/carved/jademask = 6,
		/obj/item/clothing/mask/rogue/facemask/carved/shellmask = 6,
		/obj/item/carvedgem/shell/statue = 5,
		/obj/item/carvedgem/rose/statue = 5,
		/obj/item/carvedgem/onyxa/statue = 5,
		/obj/item/carvedgem/shell/turtle = 8,
		/obj/item/carvedgem/rose/carp = 8,
		/obj/item/carvedgem/jade/wyrm = 3,
		/obj/item/rogueweapon/huntingknife/combat/jadekukri = 4,
		/obj/item/rogueweapon/mace/cudgel/shellrungu = 4
	)

	var/chosen_loot_path = pickweight(loot_weights)
	if(!chosen_loot_path)
		return null

	return new chosen_loot_path(spawn_turf)

/turf/open/rebound
	name = "undercurrent"
	desc = "These waters reject those without proper will."
	icon_state = "water"
	icon = 'icons/turf/roguefloor.dmi'
	color = "#2a3852"
	alpha = 50

/turf/open/rebound/Entered(atom/movable/AM)
	..()
	if(AM.throwing)
		return

	if(!isliving(AM) && !isitem(AM))
		return
	var/turf/previous_turf = AM.loc
	if(istype(AM))
		previous_turf = get_step(src, REVERSE_DIR(AM.dir))

	var/entry_dir = get_dir(previous_turf, src)
	if(!entry_dir)
		entry_dir = AM.dir || pick(NORTH, SOUTH, EAST, WEST)

	var/rebound_dir = REVERSE_DIR(entry_dir)
	var/turf/target_turf = get_ranged_target_turf(src, rebound_dir, 5)
	if(istype(target_turf, /turf/open/rebound))
		var/list/safe_landings = list()
		for(var/turf/T in orange(2, target_turf))
			if(T.density || istype(T, /turf/open/rebound))
				continue
			safe_landings += T
		if(length(safe_landings))
			target_turf = pick(safe_landings)
	if(target_turf)
		if(isliving(AM))
			var/mob/living/L = AM
			to_chat(L, span_userdanger("The currents reject you!"))
			playsound(src, 'sound/magic/abyssor_splash.ogg', 70, TRUE)
			L.Knockdown(1 SECONDS)
		AM.throw_at(target_turf, 5, 1)

/obj/structure/roguemachine/dream_pool/redstone_triggered(mob/user)
	..()
	if(!linked_door || linked_door.animating)
		return

	if(linked_door.gate_closed)
		linked_door.open_gate(user)
	else
		linked_door.close_gate(user)
