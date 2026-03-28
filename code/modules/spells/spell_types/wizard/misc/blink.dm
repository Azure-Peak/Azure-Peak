/datum/action/cooldown/spell/blink
	name = "Blink"
	desc = "Teleport to a targeted location within your field of view. Limited to a range of 5 tiles. Only works on the same plane as the caster."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "rune6"
	sound = 'sound/magic/blink.ogg'
	spell_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_TELEPORT

	invocations = list("Saltus Arcanus!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 12 SECONDS

	associated_skill = /datum/skill/magic/arcane
	point_cost = 3
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/max_range = 5
	var/phase = /obj/effect/temp_visual/blink
	var/phase_sound = 'sound/magic/blink.ogg'
	var/phase_beam = "purple_lightning"

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

/datum/action/cooldown/spell/blink/cast(atom/cast_on)
	. = ..()
	var/turf/T = get_turf(cast_on)
	var/turf/start = get_turf(owner)

	var/dest_err = arcyne_validate_blink_dest(T, owner)
	if(dest_err)
		to_chat(owner, span_warning(dest_err))
		return FALSE

	var/distance = get_dist(start, T)
	if(distance > max_range)
		to_chat(owner, span_warning("That location is too far away! I can only blink up to [max_range] tiles."))
		return FALSE

	var/path_err = arcyne_validate_blink_path(start, T)
	if(path_err)
		to_chat(owner, span_warning(path_err))
		return FALSE

	owner.visible_message(span_warning("<b>[owner]'s body begins to shimmer with arcane energy as [owner.p_they()] prepare[owner.p_s()] to blink!</b>"),
					span_notice("<b>I focus my arcane energy, preparing to blink across space!</b>"))

	var/obj/spot_one = new phase(start, owner.dir)
	var/obj/spot_two = new phase(T, owner.dir)

	if(phase_beam)
		spot_one.Beam(spot_two, phase_beam, time = 1.5 SECONDS)
	playsound(start, phase_sound, 65, TRUE)
	playsound(T, phase_sound, 25, TRUE)

	var/mob/living/L = owner
	if(istype(L) && L.buckled)
		L.buckled.unbuckle_mob(L, TRUE)

	// Afterimage at departure point
	var/obj/effect/after_image/img = new(start, 0, 0, 0, 0, 0.5 SECONDS, 2 SECONDS, 0)
	img.name = owner.name
	img.appearance = owner.appearance
	img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	img.alpha = 120
	animate(img, alpha = 0, time = 1.5 SECONDS, easing = LINEAR_EASING)
	QDEL_IN(img, 1.5 SECONDS)

	do_teleport(owner, T, channel = TELEPORT_CHANNEL_MAGIC)

	owner.visible_message(span_danger("<b>[owner] vanishes in a mysterious purple flash!</b>"), span_notice("<b>I blink through space in an instant!</b>"))
	return TRUE
