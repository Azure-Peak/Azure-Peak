/obj/item/leechtick
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "leechtick"
	name = "leech tick"
	desc = "A pestran invader of Abyssor's divine sea. These are well known to latch onto the corpses of underwater leviathans. More than a pest, leechticks suck the soul out of those that disturb them, digesting the lux of assailants."
	// Don't lower the size, they'll make effective throwing weapons otherwise.
	w_class = WEIGHT_CLASS_NORMAL
	isbait = TRUE
	baitpenalty = 5
	fishingMods=list(
		"commonFishingMod" = 0.8,
		"rareFishingMod" = 1.2,
		"treasureFishingMod" = 0.5,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 1.1,
		"ceruleanFishingMod" = 0, // 1 on cerulean aril, 0 on everything else
		"cheeseFishingMod" = 0 // Just for the funny gimmick of a chance for rats and rouses.
	)
	baitresilience = 5

/obj/item/leechtick_bloated
	icon_state = "leechthick"
	icon = 'icons/obj/structures/heart_items.dmi'
	name = "bloated leech tick"
	desc = "This leechtick has feasted on lux and digested it. A crazy person might use this for revival..."
	sellprice = 40
	isbait = TRUE
	baitpenalty = 0
	fishingMods=list(
		"commonFishingMod" = 0.65,
		"rareFishingMod" = 1.35,
		"treasureFishingMod" = 0.5,
		"trashFishingMod" = 0.9,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0, // 1 on cerulean aril, 0 on everything else
		"cheeseFishingMod" = 0 // Just for the funny gimmick of a chance for rats and rouses.
	)
	baitresilience = 10

/obj/item/leechtick/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return

	if(isliving(target) && do_after(user, 2 SECONDS, FALSE, target))
		try_attach(target, user)

/obj/item/leechtick/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(isliving(hit_atom))
		try_attach(hit_atom)

/obj/item/leechtick/proc/try_attach(mob/living/target, mob/user)
	// Don't attach to dead things
	if(!SSchimeric_tech.get_node_status("CORPSE_TICKS") && target.stat == DEAD)
		return FALSE

	if(target.has_status_effect(/datum/status_effect/debuff/devitalised))
		return FALSE

	var/datum/component/leechtick_attachment/existing = target.GetComponent(/datum/component/leechtick_attachment)
	if(existing)
		return FALSE

	if(target.cmode && prob(66))
		target.visible_message(
			span_warning("[src] bounces off [target]!"),
			span_notice("[src] bounces off of you, because you're too feisty to let it latch on!")
		)
		return FALSE

	// Add the component to the target
	var/datum/component/leechtick_attachment/attachment = target.AddComponent(/datum/component/leechtick_attachment, type)
	if(!attachment)
		return FALSE

	if(user)
		user.visible_message(
			span_warning("[user] attaches [src] to [target]!"),
			span_notice("You attach [src] to [target].")
		)
	else
		target.visible_message(span_warning("[src] latches onto [target]!"))

	// Delete the item now that it's attached as a component
	qdel(src)
	return TRUE

/datum/component/leechtick_attachment
	var/leechtick_type
	var/full_leechtick_type = /obj/item/leechtick_bloated
	var/mutable_appearance/attachment_overlay
	var/detach_timer
	var/zone_switch_timer
	var/current_zone
	var/static/list/possible_zones = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG
	)

/datum/component/leechtick_attachment/Initialize(leechtick_type)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()

	src.leechtick_type = leechtick_type

	attachment_overlay = mutable_appearance('icons/obj/structures/heart_items.dmi', "leechsuck")
	update_overlay()

	detach_timer = addtimer(CALLBACK(src, .proc/on_full), 1 MINUTES, TIMER_STOPPABLE)
	switch_zone()
	playsound(parent, 'sound/vo/mobs/spider/speak (1).ogg', 40)

	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/on_examine)
	RegisterSignal(parent, COMSIG_LIVING_GRAB_SELF_ATTEMPT, .proc/on_grab_self_attempt)

/datum/component/leechtick_attachment/Destroy()
	// Clean up timers
	if(detach_timer)
		deltimer(detach_timer)
	if(zone_switch_timer)
		deltimer(zone_switch_timer)

	var/mob/living/L = parent
	if(L && attachment_overlay)
		L.cut_overlay(attachment_overlay)

	return ..()

/datum/component/leechtick_attachment/proc/update_overlay()
	var/mob/living/L = parent
	if(!L || !attachment_overlay)
		return

	var/mutable_appearance/old_overlay_ref = attachment_overlay
	attachment_overlay = mutable_appearance('icons/obj/structures/heart_items.dmi', attachment_overlay.icon_state)
	attachment_overlay.icon_state = old_overlay_ref.icon_state
	L.cut_overlay(old_overlay_ref)

	switch(current_zone)
		if(BODY_ZONE_HEAD)
			attachment_overlay.pixel_x = -1
			attachment_overlay.pixel_y = 12
			attachment_overlay.icon_state = "leechsuck"
		if(BODY_ZONE_CHEST)
			attachment_overlay.pixel_x = -1
			attachment_overlay.pixel_y = 0
			attachment_overlay.icon_state = "leechsuck"
		if(BODY_ZONE_L_ARM)
			attachment_overlay.pixel_x = -8
			attachment_overlay.pixel_y = 0
			attachment_overlay.icon_state = "leechsuck_left"
		if(BODY_ZONE_R_ARM)
			attachment_overlay.pixel_x = 8
			attachment_overlay.pixel_y = 0
			attachment_overlay.icon_state = "leechsuck_right"
		if(BODY_ZONE_L_LEG)
			attachment_overlay.pixel_x = -4
			attachment_overlay.pixel_y = -8
			attachment_overlay.icon_state = "leechsuck_left"
		if(BODY_ZONE_R_LEG)
			attachment_overlay.pixel_x = 4
			attachment_overlay.pixel_y = -8
			attachment_overlay.icon_state = "leechsuck_right"

	L.add_overlay(attachment_overlay)
	L.update_icon()

/datum/component/leechtick_attachment/proc/switch_zone()
	if(!parent)
		return
	var/mob/living/L = parent
	if(prob(25))
		to_chat(L, span_notice("The leech tick skitters across my body!"))
	L.adjustBruteLoss(1, 0)
	current_zone = pick(possible_zones)
	update_overlay()
	zone_switch_timer = addtimer(CALLBACK(src, .proc/switch_zone), rand(10, 40), TIMER_STOPPABLE)

/datum/component/leechtick_attachment/proc/on_full()
	if(!parent)
		return
	safe_detach()

/datum/component/leechtick_attachment/proc/safe_detach()
	if(!parent)
		return
	var/mob/living/L = parent
	if(!L.has_status_effect(/datum/status_effect/debuff/devitalised) && !L.has_status_effect(/datum/status_effect/debuff/revived) && !L.has_status_effect(/datum/status_effect/debuff/leech_schizophrenia))
		L.visible_message(span_notice("The leech tick falls off of [L], looking full and satisfied."))
		new full_leechtick_type(get_turf(L))
		L.apply_status_effect(/datum/status_effect/debuff/devitalised)
	else
		L.visible_message(span_notice("The leech tick falls off of [L], looking the same as ever."))
		new leechtick_type(get_turf(L))

	playsound(parent, 'sound/vo/mobs/spider/pain.ogg', 40)
	L.cut_overlay(attachment_overlay)
	qdel(src)

/datum/component/leechtick_attachment/proc/on_examine(source, mob/living/examiner, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_warning("A leech tick is attached to [examiner == parent ? "you" : "them"]!")

/datum/component/leechtick_attachment/proc/on_grab_self_attempt(mob/living/source, mob/living/target, zone, params)
	SIGNAL_HANDLER
	// Only handle self-grabs on the correct zone
	if(source != parent || target != parent || zone != current_zone)
		return

	var/mob/living/L = parent
	if(!L.used_intent || !istype(L.used_intent, /datum/intent/grab))
		return
	L.visible_message(
		span_warning("[L] starts trying to remove the leech tick!"),
		span_notice("You start trying to remove the leech tick...")
	)

	// Use global do_after with callback instead of sleeping in signal handler
	INVOKE_ASYNC(src, .proc/start_removal_async, L)
	return COMPONENT_CANCEL_GRAB_ATTACK

/datum/component/leechtick_attachment/proc/start_removal_async(mob/living/L)
	// This runs in its own thread, so do_after is safe here
	if(move_after(L, 1 SECONDS, target = L))
		// Call back to the component to complete the removal
		complete_removal()

/datum/component/leechtick_attachment/proc/complete_removal()
	var/mob/living/L = parent
	if(!L)
		return

	L.visible_message(
		span_warning("[L] successfully removes the leech tick!"),
		span_notice("You successfully remove the leech tick.")
	)

	if(leechtick_type)
		new leechtick_type(get_turf(L))
	L.cut_overlay(attachment_overlay)
	qdel(src)

/atom/movable/screen/alert/status_effect/debuff/leech_schizophrenia
	name = "Aural Echoes"
	desc = "You hear faint whispers that don't belong to you. Your mind feels maladjusted and unsettled."

/datum/status_effect/debuff/leech_schizophrenia
	id = "leech_schizophrenia"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/leech_schizophrenia
	duration = 10 SECONDS

	var/message_cooldown = 4 MINUTES
	var/current_cooldown = 0
	var/list/creepy_msgs = list(
		span_italics("You feel a presence settling deep within your mind. 'Not... enough...'"),
		span_warning("You feel as if your head fills with a heavy, slimy ooze..."),
		span_userdanger("The silence is broken by a low, insistent clicking sound that only you can hear."),
		span_italics("For a moment, your own shadow seems to move independently of you."),
		span_warning("You suddenly question why you're holding what you're holding, and the world feels momentarily wrong."),
		span_italics("A voice that sounds like wet sand asks 'Why?'")
	)
	effectedstats = list(STATKEY_STR = -1, STATKEY_WIL = -2, STATKEY_CON = -2, STATKEY_SPD = -1, STATKEY_INT = -1)

/datum/status_effect/debuff/leech_schizophrenia/on_creation(mob/living/new_owner, ...)
	. = ..()

	duration = rand(14 MINUTES, 28 MINUTES) 
	current_cooldown = world.time + message_cooldown
	return .

/datum/status_effect/debuff/leech_schizophrenia/tick()
	. = ..()

	if(world.time >= current_cooldown)
		send_creepy_message()
		current_cooldown = world.time + message_cooldown

/datum/status_effect/debuff/leech_schizophrenia/proc/send_creepy_message()
	var/mob/living/L = owner
	if(!L)
		return
	to_chat(L, pick(creepy_msgs))
