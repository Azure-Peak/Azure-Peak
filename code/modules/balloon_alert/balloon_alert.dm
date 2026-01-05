/**
 * Creates text that will float from the atom upwards to the viewer.
 *
 * Args:
 * * mob/viewer: The mob the text will be shown to. Nullable (But only in the form of it won't runtime).
 * * text: The text to be shown to viewer. Must not be null.
 */
/atom/proc/balloon_alert(mob/viewer, text, x_offset, y_offset)
	SHOULD_NOT_SLEEP(TRUE)

	INVOKE_ASYNC(src, PROC_REF(balloon_alert_perform), viewer, text, x_offset, y_offset)

/// Create balloon alerts (text that floats up) to everything within range.
/// Will only display to people who can see.
/atom/proc/balloon_alert_to_viewers(message, self_message, vision_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs, x_offset, y_offset)
	SHOULD_NOT_SLEEP(TRUE)

	var/list/hearers = get_hearers_in_view(vision_distance, src, RECURSIVE_CONTENTS_CLIENT_MOBS)
	hearers -= ignored_mobs

	for (var/mob/hearer in hearers)
		if (is_blind(hearer))
			continue

		balloon_alert(hearer, (hearer == src && self_message) || message, x_offset, y_offset)

// Do not use.
// MeasureText blocks. I have no idea for how long.
// I would've made the maptext_height update on its own, but I don't know
// if this would look bad on laggy clients.
/atom/proc/balloon_alert_perform(mob/viewer, text, x_offset, y_offset)

	var/client/viewer_client = viewer?.client
	if (isnull(viewer_client))
		return
	
	if(!(viewer_client.prefs.floating_text_toggles & FLOATING_TEXT))
		return

	var/image/balloon_alert = image(loc = isturf(src) ? src : get_atom_on_turf(src), layer = ABOVE_MOB_LAYER)
	balloon_alert.plane = BALLOON_CHAT_PLANE
	balloon_alert.appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM
	balloon_alert.maptext = MAPTEXT("<span style='text-align: center; -dm-text-outline: 1px #0005'>[text]</span>")
	balloon_alert.maptext_x = (BALLOON_TEXT_WIDTH - ICON_SIZE_X) * -0.5 - base_pixel_x + x_offset
	WXH_TO_HEIGHT(viewer_client?.MeasureText(text, null, BALLOON_TEXT_WIDTH), balloon_alert.maptext_height)
	balloon_alert.maptext_width = BALLOON_TEXT_WIDTH

	viewer_client?.images += balloon_alert

	var/length_mult = 1 + max(0, length(strip_html_simple(text)) - BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MIN) * BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MULT

	if(!y_offset)
		animate(
			balloon_alert,
			pixel_y = ICON_SIZE_Y * 1.2,
			time = BALLOON_TEXT_TOTAL_LIFETIME(length_mult),
			easing = SINE_EASING | EASE_OUT,
		)
	else
		balloon_alert.pixel_y = y_offset
		animate(
			balloon_alert,
			pixel_y = y_offset + 5,
			time = BALLOON_TEXT_TOTAL_LIFETIME(length_mult),
			easing = SINE_EASING | EASE_OUT,
		)


	animate(
		alpha = 175,
		time = BALLOON_TEXT_SPAWN_TIME,
		easing = CUBIC_EASING | EASE_OUT,
		flags = ANIMATION_PARALLEL,
	)

	animate(
		alpha = 0,
		time = BALLOON_TEXT_FULLY_VISIBLE_TIME * length_mult,
		easing = CUBIC_EASING | EASE_IN,
	)

	// These two timers are not the same
	// One manages the relation to the atom that spawned us, the other to the client we're displaying to
	// We could lose our loc, and still need to talk to our client, so they are done seperately
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_image_from_client), balloon_alert, viewer_client), BALLOON_TEXT_TOTAL_LIFETIME(length_mult))

///Proc for creating a balloon alert that only someone with a specific trait would see.
/atom/proc/filtered_balloon_alert(trait, text, x_offset, y_offset, show_self = TRUE)
	var/list/candidates = get_hearers_in_view(DEFAULT_MESSAGE_RANGE, src, RECURSIVE_CONTENTS_CLIENT_MOBS)
	if(trait)	
		for(var/mob/living/carbon/human/H in candidates)
			if(!show_self && H == src)
				candidates -= H
			if(HAS_TRAIT(H, trait))
				candidates -= H
	else
		CRASH("filtered_balloon_alert called without a trait, either it's an error or use balloon_alert instead.")
		
	if(length(candidates))
		balloon_alert_to_viewers(text, null, DEFAULT_MESSAGE_RANGE, candidates, x_offset, y_offset)
