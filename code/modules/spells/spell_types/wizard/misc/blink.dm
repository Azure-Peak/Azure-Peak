/obj/effect/proc_holder/spell/invoked/blink
	name = "Blink"
	desc = "Teleport to a targeted location within your field of view. Limited to a range of 5 tiles. Only works on the same plane as the caster."
	school = "conjuration"
	cost = 3
	releasedrain = 30
	chargedrain = 1
	chargetime = 3
	recharge_time = 10 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	gesture_required = TRUE // Mobility spell
	spell_tier = 2
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "rune6"
	xp_gain = TRUE
	invocations = list("Nictare Teleporto!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	var/max_range = 5
	var/phase = /obj/effect/temp_visual/blink

/obj/effect/temp_visual/blink
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_blast"
	name = "teleportation magic"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 4 SECONDS
	layer = MASSIVE_OBJ_LAYER
	light_outer_range = 2
	light_color = COLOR_PALE_PURPLE_GRAY

/obj/effect/temp_visual/blink/Initialize(mapload, new_caster)
	. = ..()
	var/turf/src_turf = get_turf(src)
	playsound(src_turf,'sound/magic/blink.ogg', 65, TRUE, -5)

/obj/effect/proc_holder/spell/invoked/blink/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])
	var/turf/start = get_turf(user)

	var/dest_err = arcyne_validate_blink_dest(T, user)
	if(dest_err)
		to_chat(user, span_warning(dest_err))
		revert_cast()
		return

	var/distance = get_dist(start, T)
	if(distance > max_range)
		to_chat(user, span_warning("That location is too far away! I can only blink up to [max_range] tiles."))
		revert_cast()
		return

	var/path_err = arcyne_validate_blink_path(start, T)
	if(path_err)
		to_chat(user, span_warning(path_err))
		revert_cast()
		return

	user.visible_message(span_warning("<b>[user]'s body begins to shimmer with arcane energy as [user.p_they()] prepare[user.p_s()] to blink!</b>"),
						span_notice("<b>I focus my arcane energy, preparing to blink across space!</b>"))

	var/obj/spot_one = new phase(start, user.dir)
	var/obj/spot_two = new phase(T, user.dir)

	spot_one.Beam(spot_two, "purple_lightning", time = 1.5 SECONDS)
	playsound(T, 'sound/magic/blink.ogg', 25, TRUE)

	if(user.buckled) // don't stay remote-buckled to the guillotine/pillory
		user.buckled.unbuckle_mob(user, TRUE)
	do_teleport(user, T, channel = TELEPORT_CHANNEL_MAGIC)
	
	user.visible_message(span_danger("<b>[user] vanishes in a mysterious purple flash!</b>"), span_notice("<b>I blink through space in an instant!</b>"))
	return TRUE
