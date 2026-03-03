/* Leyline Anchor — Spellblade utility (replaces Greater Forcewall).
Anchor an arcyne tether to the leyline beneath your feet. Recast to recall.
Tether: 75 HP, 20s lifespan, 7 tile max recall range, same Z only.
Goes on cooldown (30s) when you recall OR the tether is destroyed/expires. */

/obj/effect/proc_holder/spell/self/leyline_anchor
	name = "Leyline Anchor"
	desc = "Anchor an arcyne tether to the leyline beneath your feet. Recast to recall. \
		The tether has 75 health and lasts 20 seconds. \
		7 tile maximum recall range. Same level only. \
		Cannot recall while grabbed, restrained, or buckled. \
		If the tether is destroyed or expires, the spell goes on full cooldown."
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/spellblade.dmi' 
	overlay_state = "leyline_anchor" // Icon by Prominence/Nobleed
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	invocations = list("Ancora Lineam!")
	invocation_type = "whisper"
	gesture_required = TRUE
	xp_gain = FALSE
	var/obj/structure/leyline_anchor_tether/active_portal
	var/max_range = 7
	var/teleport_delay = 5

/obj/effect/proc_holder/spell/self/leyline_anchor/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	// Recast while tether active — recall
	if(active_portal && !QDELETED(active_portal))
		var/turf/portal_turf = get_turf(active_portal)
		if(!portal_turf)
			to_chat(H, span_warning("The leyline tether has been severed!"))
			clear_portal()
			revert_cast()
			return
		if(H.pulledby || H.restrained() || H.buckled)
			to_chat(H, span_warning("I can't recall while restrained!"))
			revert_cast()
			return
		var/turf/caster_turf = get_turf(H)
		if(caster_turf.z != portal_turf.z)
			to_chat(H, span_warning("The leyline tether is on a different level!"))
			revert_cast()
			return
		if(get_dist(caster_turf, portal_turf) > max_range)
			to_chat(H, span_warning("Too far from the leyline tether!"))
			revert_cast()
			return
		H.visible_message(span_warning("Arcyne energy crackles around [H]!"))
		playsound(get_turf(H), 'sound/magic/shadowstep.ogg', 50, TRUE)
		addtimer(CALLBACK(src, PROC_REF(do_recall), H), teleport_delay)
		return TRUE

	// First cast — anchor tether
	var/turf/T = get_turf(H)
	active_portal = new /obj/structure/leyline_anchor_tether(T, src)
	to_chat(H, span_notice("I anchor the leyline beneath my feet."))
	playsound(T, 'sound/misc/portalactivate.ogg', 50, TRUE)
	revert_cast()

/obj/effect/proc_holder/spell/self/leyline_anchor/proc/do_recall(mob/living/carbon/human/user)
	if(QDELETED(user) || user.stat == DEAD)
		return
	if(!active_portal || QDELETED(active_portal))
		return
	var/turf/dest = get_turf(active_portal)
	if(!dest)
		return

	var/turf/start = get_turf(user)
	var/obj/effect/after_image/img = new(start, 0, 0, 0, 0, 0.5 SECONDS, 2 SECONDS, 0)
	img.name = user.name
	img.appearance = user.appearance
	img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	img.alpha = 80
	QDEL_IN(img, 2 SECONDS)

	do_teleport(user, dest, channel = TELEPORT_CHANNEL_MAGIC)
	playsound(dest, 'sound/magic/blink.ogg', 50, TRUE)
	user.visible_message(
		span_warning("[user] is pulled back through the leyline!"),
		span_notice("The leyline pulls me back."))
	active_portal.parent_spell = null // Prevent Destroy() from penalizing
	qdel(active_portal)
	active_portal = null

/obj/effect/proc_holder/spell/self/leyline_anchor/proc/clear_portal()
	active_portal = null
	charge_counter = 0
	start_recharge()
	if(action)
		action.UpdateButtonIcon()

// --- Tether object ---

/obj/structure/leyline_anchor_tether
	name = "leyline tether"
	desc = "An arcyne tether anchored to the leyline. Destroy it to sever the connection."
	icon = 'icons/effects/effects.dmi'
	icon_state = "leylinerupture"
	max_integrity = 75
	anchored = TRUE
	density = FALSE
	opacity = 0
	light_outer_range = 1
	break_sound = 'sound/magic/magic_nulled.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg')
	var/obj/effect/proc_holder/spell/self/leyline_anchor/parent_spell

/obj/structure/leyline_anchor_tether/Initialize(mapload, obj/effect/proc_holder/spell/self/leyline_anchor/spell)
	. = ..()
	parent_spell = spell
	QDEL_IN(src, 20 SECONDS)

/obj/structure/leyline_anchor_tether/Destroy()
	if(parent_spell)
		parent_spell.clear_portal()
		parent_spell = null
	return ..()
