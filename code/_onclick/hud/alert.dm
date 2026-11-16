//A system to manage and display alerts on screen without needing you to do it yourself

//PUBLIC -	call these wherever you want


/mob/proc/throw_alert(category, type, severity, obj/new_master, override = FALSE, timeout_override, no_anim = FALSE)

/* Proc to create or update an alert. Returns the alert if the alert is new or updated, 0 if it was thrown already
	category is a text string. Each mob may only have one alert per category; the previous one will be replaced
	path is a type path of the actual alert type to throw
	severity is an optional number that will be placed at the end of the icon_state for this alert
	For example, high pressure's icon_state is "highpressure" and can be serverity 1 or 2 to get "highpressure1" or "highpressure2"
	new_master is optional and sets the alert's icon state to "template" in the ui_style icons with the master as an overlay.
	Clicks are forwarded to master
	Override makes it so the alert is not replaced until cleared by a clear_alert with clear_override, and it's used for hallucinations.
 */

	if(!category || QDELETED(src))
		return

	var/atom/movable/screen/alert/thealert
	if(alerts[category])
		thealert = alerts[category]
		if(thealert.override_alerts)
			return 0
		if(new_master && new_master != thealert.master)
			WARNING("[src] threw alert [category] with new_master [new_master] while already having that alert with master [thealert.master]")

			clear_alert(category)
			return .()
		else if(thealert.type != type)
			clear_alert(category)
			return .()
		else if(!severity || severity == thealert.severity)
			if(thealert.timeout && timeout_override)
				addtimer(CALLBACK(src, PROC_REF(alert_timeout), thealert, category), timeout_override)
				thealert.timeout = world.time + timeout_override - world.tick_lag
				return thealert
			if(thealert.timeout)
				clear_alert(category)
				return .()
			else //no need to update
				return 0
	else
		thealert = new type()
		thealert.override_alerts = override
		if(override)
			thealert.timeout = null
	thealert.mob_viewer = src

	if(new_master)
		var/old_layer = new_master.layer
		var/old_plane = new_master.plane
		new_master.layer = FLOAT_LAYER
		new_master.plane = FLOAT_PLANE
		thealert.add_overlay(new_master)
		new_master.layer = old_layer
		new_master.plane = old_plane
		thealert.icon_state = "status" // We'll set the icon to the client's ui pref in reorganize_alerts()
		thealert.master = new_master
	else
		thealert.icon_state = "[initial(thealert.icon_state)][severity]"
		thealert.severity = severity

	alerts[category] = thealert
	if(client && hud_used)
		hud_used.reorganize_alerts()
	if(!no_anim)
		thealert.transform = matrix(32, 6, MATRIX_TRANSLATE)
		animate(thealert, transform = matrix(), time = 2.5, easing = CUBIC_EASING)
	if(timeout_override)
		thealert.timeout = timeout_override
	if(thealert.timeout)
		addtimer(CALLBACK(src, PROC_REF(alert_timeout), thealert, category), thealert.timeout)
		thealert.timeout = world.time + thealert.timeout - world.tick_lag
	return thealert

/mob/proc/alert_timeout(atom/movable/screen/alert/alert, category)
	if(alert.timeout && alerts[category] == alert && world.time >= alert.timeout)
		clear_alert(category)

// Proc to clear an existing alert.
/mob/proc/clear_alert(category, clear_override = FALSE)
	var/atom/movable/screen/alert/alert = alerts[category]
	if(!alert)
		return 0
	if(alert.override_alerts && !clear_override)
		return 0

	alerts -= category
	if(client && hud_used)
		hud_used.reorganize_alerts()
		client.screen -= alert
	qdel(alert)

/atom/movable/screen/alert
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "status"
	name = "Alert"
	desc = ""
	mouse_opacity = MOUSE_OPACITY_ICON
	var/timeout = 0 //If set to a number, this alert will clear itself after that many deciseconds
	var/severity = 0
	var/alerttooltipstyle = "rogue"
	var/override_alerts = FALSE //If it is overriding other alerts of the same type
	var/mob/mob_viewer //the mob viewing this alert
	var/alert_group = ALERT_STATUS //decides where on the screen the alert shows up, if it's a debuff, status effect, or buff
	nomouseover = FALSE
	var/atom/movable/screen/maptext_holder/maptext_holder
	var/last_countdown_text //Cached countdown string so we don't rewrite maptext every fast-process tick

//At or above this, the countdown shows whole minutes ("27m"); below it, M:SS or Ns
#define ALERT_COUNTDOWN_CUTOFF (3 MINUTES)

/atom/movable/screen/alert/proc/update_countdown(remaining_deciseconds)
	if(remaining_deciseconds <= 0)
		if(istype(maptext_holder))
			maptext_holder.maptext = null
		last_countdown_text = null
		return

	var/countdown_text
	if(remaining_deciseconds >= ALERT_COUNTDOWN_CUTOFF)
		var/mins_left = max(round(remaining_deciseconds / (1 MINUTES), 1), 1)
		countdown_text = "[mins_left]m"
	else
		var/seconds_left = round(remaining_deciseconds / (1 SECONDS), 0.1)
		if(seconds_left >= 60)
			var/mins = round(seconds_left / 60)
			var/secs = round(seconds_left) % 60
			countdown_text = "[mins]:[secs < 10 ? "0[secs]" : "[secs]"]"
		else
			countdown_text = "[seconds_left]s"

	if(countdown_text == last_countdown_text)
		return
	last_countdown_text = countdown_text

	if(!istype(maptext_holder))
		maptext_holder = new(src)
		maptext_holder.x = 4
		maptext_holder.y = 0
		maptext_holder.color = "#800000"
		vis_contents.Add(maptext_holder)
	maptext_holder.maptext = MAPTEXT(countdown_text)

#undef ALERT_COUNTDOWN_CUTOFF

//Gas alerts
/atom/movable/screen/alert/not_enough_oxy
	name = "Choking"
	desc = ""
	icon_state = "not_enough_oxy"

/atom/movable/screen/alert/too_much_oxy
	name = "Choking (O2)"
	desc = ""
	icon_state = "too_much_oxy"

/atom/movable/screen/alert/not_enough_nitro
	name = "Choking (No N2)"
	desc = ""
	icon_state = "not_enough_nitro"

/atom/movable/screen/alert/too_much_nitro
	name = "Choking (N2)"
	desc = ""
	icon_state = "too_much_nitro"

/atom/movable/screen/alert/not_enough_co2
	name = "Choking (No CO2)"
	desc = ""
	icon_state = "not_enough_co2"

/atom/movable/screen/alert/too_much_co2
	name = "Choking (CO2)"
	desc = ""
	icon_state = "too_much_co2"

/atom/movable/screen/alert/not_enough_tox
	name = "Choking (No Plasma)"
	desc = ""
	icon_state = "not_enough_tox"

/atom/movable/screen/alert/too_much_tox
	name = "Choking (Plasma)"
	desc = ""
	icon_state = "too_much_tox"
//End gas alerts


/atom/movable/screen/alert/fat
	name = "Fat"
	desc = ""
	icon_state = "fat"

/atom/movable/screen/alert/hungry
	name = "Hungry"
	desc = ""
	icon_state = "hungry"

/atom/movable/screen/alert/starving
	name = "Starving"
	desc = ""
	icon_state = "starving"

/atom/movable/screen/alert/gross
	name = "Grossed out."
	desc = ""
	icon_state = "gross"

/atom/movable/screen/alert/verygross
	name = "Very grossed out."
	desc = ""
	icon_state = "gross2"

/atom/movable/screen/alert/disgusted
	name = "DISGUSTED"
	desc = ""
	icon_state = "gross3"

/atom/movable/screen/alert/hot
	name = "Too Hot"
	desc = ""
	icon_state = "hot"

/atom/movable/screen/alert/cold
	name = "Too Cold"
	desc = ""
	icon_state = "cold"

/atom/movable/screen/alert/lowpressure
	name = "Low Pressure"
	desc = ""
	icon_state = "lowpressure"

/atom/movable/screen/alert/highpressure
	name = "High Pressure"
	desc = ""
	icon_state = "highpressure"

/atom/movable/screen/alert/blind
	name = "Blind"
	desc = ""
	icon_state = "blind"

/atom/movable/screen/alert/high
	name = "High"
	desc = ""
	icon_state = "high"

/atom/movable/screen/alert/hypnosis
	name = "Hypnosis"
	desc = ""
	icon_state = "hypnosis"
	var/phrase

/atom/movable/screen/alert/mind_control
	name = "Mind Control"
	desc = ""
	icon_state = "mind_control"
	var/command

/atom/movable/screen/alert/mind_control/Click()
	..()
	var/mob/living/L = usr
	to_chat(L, span_mind_control("[command]"))

/atom/movable/screen/alert/drunk //Not implemented
	name = "Drunk"
	desc = ""
	icon_state = "drunk"

/atom/movable/screen/alert/embeddedobject
	name = "Embedded Objects"
	desc = ""
	icon_state = "embeddedobject"

/atom/movable/screen/alert/embeddedobject/Click()
	if(!..())
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			var/list/msg = list("***\n")
			for(var/obj/item/bodypart/BP as anything in H.bodyparts)
				for(var/obj/item/I as anything in BP.embedded_objects)
					msg += "<a href='?src=[REF(H)];embedded_object=[REF(I)];embedded_limb=[REF(BP)]' class='warning'>[I] - [BP.name]</a>\n"
			msg += "***"
			to_chat(H, "[msg.Join()]")

/atom/movable/screen/alert/weightless
	name = "Weightless"
	desc = ""
	icon_state = "weightless"

/atom/movable/screen/alert/fire
	name = "On Fire"
	desc = ""
	icon_state = "fire"

/atom/movable/screen/alert/fire/Click()
	..()
	var/mob/living/L = usr
	if(!istype(L) || !L.can_resist())
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if(L.mobility_flags & MOBILITY_MOVE)
		return L.resist_fire() //I just want to start a flame in your hearrrrrrtttttt.

/atom/movable/screen/alert/fire/vheslyn
	name = "Hellfire!"
	desc = ""
	icon_state = "vheslynfire"

/atom/movable/screen/alert/fire/sunder
	name = "Sundered!"
	desc = ""
	icon_state = "sunder"

/atom/movable/screen/alert/fire/sunder/blessed
	name = "Sundered!"
	desc = ""
	icon_state = "supersunder"

//BLOBS

/atom/movable/screen/alert/nofactory
	name = "No Factory"
	desc = ""
	icon_state = "blobbernaut_nofactory"
	alerttooltipstyle = "blob"

//GUARDIANS

/atom/movable/screen/alert/cancharge
	name = "Charge Ready"
	desc = ""
	icon_state = "guardian_charge"
	alerttooltipstyle = "parasite"

/atom/movable/screen/alert/canstealth
	name = "Stealth Ready"
	desc = ""
	icon_state = "guardian_canstealth"
	alerttooltipstyle = "parasite"

/atom/movable/screen/alert/instealth
	name = "In Stealth"
	desc = ""
	icon_state = "guardian_instealth"
	alerttooltipstyle = "parasite"

//Ethereal

/atom/movable/screen/alert/etherealcharge
	name = "Low Blood Charge"
	desc = ""
	icon_state = "etherealcharge"

//GHOSTS
//TODO: expand this system to replace the pollCandidates/CheckAntagonist/"choose quickly"/etc Yes/No messages
/atom/movable/screen/alert/notify_cloning
	name = "Revival"
	desc = ""
	icon_state = "template"
	timeout = 300

/atom/movable/screen/alert/notify_cloning/Click()
	if(!usr || !usr.client)
		return
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/atom/movable/screen/alert/notify_action
	name = "Body created"
	desc = ""
	icon_state = "template"
	timeout = 300
	var/atom/target = null
	var/action = NOTIFY_JUMP

/atom/movable/screen/alert/notify_action/Click()
	..()
	if(!usr || !usr.client)
		return
	if(!target)
		return
	var/mob/dead/observer/G = usr
	if(!istype(G))
		return
	switch(action)
		if(NOTIFY_ATTACK)
			target.attack_ghost(G)
		if(NOTIFY_JUMP)
			var/turf/T = get_turf(target)
			if(T && isturf(T))
				G.forceMove(T)
		if(NOTIFY_ORBIT)
			G.ManualFollow(target)

//OBJECT-BASED

/atom/movable/screen/alert/restrained/buckled
	name = "Sitting/laying"
	desc = ""
	icon_state = "buckled"

/atom/movable/screen/alert/restrained/handcuffed
	name = "Restrained (arms)"
	desc = ""
	icon_state = "restrained"

/atom/movable/screen/alert/restrained/legcuffed
	name = "Restrained (legs)"
	desc = ""
	icon_state = "restrained"

/atom/movable/screen/alert/restrained/Click()
	..()
	var/mob/living/L = usr
	if(!istype(L) || !L.can_resist())
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if((L.mobility_flags & MOBILITY_MOVE) && (L.last_special <= world.time))
		return L.resist_restraints()

/atom/movable/screen/alert/restrained/buckled/Click()
	var/mob/living/L = usr
	if(!istype(L) || !L.can_resist())
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if(L.last_special <= world.time)
		if(L.resist_buckle())
			L.set_resting(FALSE, FALSE)

// PRIVATE = only edit, use, or override these if you're editing the system as a whole

// Re-render all alerts - also called in /datum/hud/show_hud() because it's needed there
/datum/hud/proc/reorganize_alerts()
	var/list/alerts = mymob.alerts
	if(!hud_shown)
		for(var/i = 1, i <= alerts.len, i++)
			mymob.client.screen -= alerts[alerts[i]]
		return 1
	var/list/buffs = list()
	var/list/debuffs = list()
	var/list/status_effects = list()
	for(var/i = 1, i <= alerts.len, i++)
		var/atom/movable/screen/alert/alert = alerts[alerts[i]]
//		if(alert.icon_state == "template")
//			alert.icon = ui_style
		switch(alert.alert_group)
			if(ALERT_STATUS)
				status_effects += alert
				switch(status_effects.len)
					if(1)
						. = ui_alert1
					if(2)
						. = ui_alert2
					if(3)
						. = ui_alert3
					if(4)
						. = ui_alert4
					if(5)
						. = ui_alert5
					if(6)
						. = ui_alert6
					if(7)
						. = ui_alert7
					if(8)
						. = ui_alert8
					if(9)
						. = ui_alert9
					if(10)
						. = ui_alert10
					else
						. = ""
			if(ALERT_BUFF)
				buffs += alert
				switch(buffs.len)
					if(1)
						. = ui_balert1
					if(2)
						. = ui_balert2
					if(3)
						. = ui_balert3
					if(4)
						. = ui_balert4
					if(5)
						. = ui_balert5
					if(6)
						. = ui_balert6
					if(7)
						. = ui_balert7
					if(8)
						. = ui_balert8
					if(9)
						. = ui_balert9
					if(10)
						. = ui_balert10
					else
						. = ""
			if(ALERT_DEBUFF)
				debuffs += alert
				switch(debuffs.len)
					if(1)
						. = ui_dalert1
					if(2)
						. = ui_dalert2
					if(3)
						. = ui_dalert3
					if(4)
						. = ui_dalert4
					if(5)
						. = ui_dalert5
					if(6)
						. = ui_dalert6
					if(7)
						. = ui_dalert7
					if(8)
						. = ui_dalert8
					if(9)
						. = ui_dalert9
					if(10)
						. = ui_dalert10
					else
						. = ""
		alert.screen_loc = .
		mymob.client.screen |= alert
	return 1

/atom/movable/screen/alert/Destroy()
	QDEL_NULL(maptext_holder)
	severity = 0
	master = null
	mob_viewer = null
	screen_loc = ""
	return ..()

/atom/movable/screen/alert/poll_alert
	name = "Looking for candidates"
	icon_state = "status"
	timeout = 30 SECONDS
	/// If true you need to call START_PROCESSING manually
	var/show_time_left = FALSE
	/// MA for maptext showing time left for poll
	var/mutable_appearance/time_left_overlay
	/// MA for overlay showing that you're signed up to poll
	var/mutable_appearance/signed_up_overlay
	/// MA for maptext overlay showing how many polls are stacked together
	var/mutable_appearance/stacks_overlay
	/// MA for maptext overlay showing how many candidates are signed up to a poll
	var/mutable_appearance/candidates_num_overlay
	/// MA for maptext overlay of poll's role name or question
	var/mutable_appearance/role_overlay
	/// If set, on Click() it'll register the player as a candidate
	var/datum/candidate_poll/poll

/atom/movable/screen/alert/poll_alert/Initialize(mapload)
	. = ..()
	signed_up_overlay = mutable_appearance('icons/mob/screen_gen.dmi', icon_state = "selector")

/atom/movable/screen/alert/poll_alert/proc/set_role_overlay()
	var/role_or_only_question = poll.role || "?"
	role_overlay = new
	role_overlay.screen_loc = screen_loc
	role_overlay.maptext = MAPTEXT("<span style='text-align: right; color: #B3E3FC'>[full_capitalize(role_or_only_question)]</span>")
	role_overlay.maptext_width = 128
	role_overlay.transform = role_overlay.transform.Translate(-128, 0)
	add_overlay(role_overlay)

/atom/movable/screen/alert/poll_alert/Destroy()
	role_overlay = null
	time_left_overlay = null
	stacks_overlay = null
	candidates_num_overlay = null
	signed_up_overlay = null
	if(poll)
		poll.alert_buttons -= src
	poll = null
	return ..()

/atom/movable/screen/alert/poll_alert/process()
	if(show_time_left)
		var/timeleft = timeout - world.time
		if(timeleft <= 0)
			return PROCESS_KILL
		cut_overlay(time_left_overlay)
		time_left_overlay = new
		time_left_overlay.maptext = MAPTEXT("<span style='color: [(timeleft <= 10 SECONDS) ? "red" : "white"]'><b>[ceil(timeleft / (1 SECONDS))]</b></span>")
		time_left_overlay.transform = time_left_overlay.transform.Translate(4, 19)
		add_overlay(time_left_overlay)

/atom/movable/screen/alert/poll_alert/Click(location, control, params)
	..()
	if(!usr?.client || usr != mob_viewer || isnull(poll))
		return
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICKED))
		return
	if(LAZYACCESS(modifiers, ALT_CLICKED) && poll.ignoring_category)
		set_never_round()
		return
	if(LAZYACCESS(modifiers, CTRL_CLICKED) && poll.jump_to_me)
		jump_to_jump_target()
		return
	handle_sign_up()

/atom/movable/screen/alert/poll_alert/proc/handle_sign_up()
	if(mob_viewer in poll.signed_up)
		poll.remove_candidate(mob_viewer)
	else if(!(mob_viewer.ckey in GLOB.poll_ignore[poll.ignoring_category]))
		poll.sign_up(mob_viewer)
	update_signed_up_overlay()

/atom/movable/screen/alert/poll_alert/proc/set_never_round()
	if(!(mob_viewer.ckey in GLOB.poll_ignore[poll.ignoring_category]))
		poll.do_never_for_this_round(mob_viewer)
		color = "red"
		update_signed_up_overlay()
		return
	poll.undo_never_for_this_round(mob_viewer)
	color = initial(color)

/atom/movable/screen/alert/poll_alert/proc/jump_to_jump_target()
	if(!poll?.jump_to_me || !isobserver(mob_viewer))
		return
	var/turf/target_turf = get_turf(poll.jump_to_me)
	if(target_turf && isturf(target_turf))
		mob_viewer.forceMove(target_turf)

/atom/movable/screen/alert/poll_alert/Topic(href, href_list)
	if(href_list["never"])
		set_never_round()
		return
	if(href_list["signup"])
		handle_sign_up()
	if(href_list["jump"])
		jump_to_jump_target()
		return

/atom/movable/screen/alert/poll_alert/proc/update_signed_up_overlay()
	if(mob_viewer in poll.signed_up)
		add_overlay(signed_up_overlay)
	else
		cut_overlay(signed_up_overlay)

/atom/movable/screen/alert/poll_alert/proc/update_candidates_number_overlay()
	cut_overlay(candidates_num_overlay)
	if(!length(poll.signed_up))
		return
	candidates_num_overlay = new
	candidates_num_overlay.maptext = MAPTEXT("<span style='text-align: right; color: aqua'>[length(poll.signed_up)]</span>")
	candidates_num_overlay.transform = candidates_num_overlay.transform.Translate(-4, 2)
	add_overlay(candidates_num_overlay)

/atom/movable/screen/alert/poll_alert/proc/update_stacks_overlay()
	cut_overlay(stacks_overlay)
	var/stack_number = 1
	for(var/datum/candidate_poll/other_poll as anything in SSpolling.currently_polling)
		if(other_poll != poll && other_poll.poll_key == poll.poll_key && !other_poll.finished)
			stack_number++
	if(stack_number <= 1)
		return
	stacks_overlay = new
	stacks_overlay.maptext = MAPTEXT("<span style='color: yellow'>[stack_number]x</span>")
	stacks_overlay.transform = stacks_overlay.transform.Translate(3, 2)
	stacks_overlay.layer = layer
	add_overlay(stacks_overlay)
