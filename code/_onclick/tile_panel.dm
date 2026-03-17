#define TILE_PANEL_UI_ID "TilePanel"
#define TILE_PANEL_UI_NAME "TilePanel"
#define TILEPANEL_ACT_CLOSE "close"
#define TILEPANEL_ACT_INTERACT "interact"
#define TILEPANEL_ACT_DROP "drop"
#define TILEPANEL_REFRESH_THROTTLE_DS 10

/mob
	var/datum/tile_panel/tile_panel

/mob/proc/get_tile_panel()
	if(!tile_panel)
		tile_panel = new(src)
	return tile_panel

/mob/proc/tile_panel_notify_changed(atom/context = null)
	if(!tile_panel)
		return
	tile_panel.request_refresh(context)

/mob/proc/can_open_tile_panel_turf(turf/T)
	if(!T || !client)
		return FALSE

	if(TurfAdjacent(T))
		return TRUE

	if(istype(src, /mob/dead/observer) && client?.holder)
		return TRUE

	return FALSE

/mob/proc/open_tile_panel_for(atom/A)
	if(!client)
		return FALSE

	var/turf/T = get_turf(A)
	if(!T)
		return FALSE

	if(!can_open_tile_panel_turf(T))
		return FALSE

	listed_turf = T
	client.statpanel = T.name

	var/datum/tile_panel/P = get_tile_panel()
	return P.open(T)

/datum/tile_panel
	var/mob/owner
	var/turf/target_turf
	var/last_refresh_at = 0
	var/refresh_queued = FALSE
	var/last_context_ref
	var/refresh_throttle_ds = TILEPANEL_REFRESH_THROTTLE_DS
	var/list/icon_cache
	var/icon_cache_ttl_ds = 100
	var/max_icon_renders_per_update = 12

/datum/tile_panel/New(mob/user)
	owner = user
	icon_cache = list()
	..()

/datum/tile_panel/Destroy()
	if(owner?.tile_panel == src)
		owner.tile_panel = null
	owner = null
	target_turf = null
	return ..()

/datum/tile_panel/proc/set_target(turf/T)
	if(!T)
		return FALSE
	target_turf = T
	return TRUE

/datum/tile_panel/proc/open(turf/T)
	if(!owner || !owner.client)
		return FALSE

	if(T)
		set_target(T)

	if(!target_turf)
		return FALSE

	if(!owner.can_open_tile_panel_turf(target_turf))
		return FALSE

	ui_interact(owner)
	request_refresh()
	return TRUE

/datum/tile_panel/proc/close()
	if(owner)
		SStgui.close_uis(src)

/datum/tile_panel/proc/_is_open()
	if(!owner || !owner.client)
		return FALSE
	return !!SStgui.get_open_ui(owner, src)

/datum/tile_panel/ui_state(mob/user)
	return GLOB.default_state

/datum/tile_panel/ui_status(mob/user, datum/ui_state/state)
	if(!user || !user.client)
		return UI_CLOSE

	if(user != owner)
		return UI_CLOSE

	if(!target_turf)
		return UI_CLOSE

	if(!user.can_open_tile_panel_turf(target_turf))
		return UI_CLOSE

	return UI_INTERACTIVE

/datum/tile_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, TILE_PANEL_UI_ID, TILE_PANEL_UI_NAME)
		ui.open()
		if(user?.client)
			user.client.refocus_map()

/datum/tile_panel/ui_data(mob/user)
	. = list()

	if(!target_turf)
		.["has_target"] = FALSE
		return

	.["has_target"] = TRUE
	.["name"] = target_turf.name

	var/list/atoms = list()
	var/renders_left = max_icon_renders_per_update

	var/turf_icon_b64 = null
	if(renders_left > 0)
		turf_icon_b64 = _get_cached_icon_b64(target_turf)
		renders_left--

	atoms += list(list(
		"name" = "[target_turf.name] (floor)",
		"ref" = REF(target_turf),
		"img64" = turf_icon_b64,
		"is_turf" = TRUE
	))

	for(var/atom/A in target_turf)
		if(istype(A, /obj/effect))
			continue
		if(istype(A, /atom/movable/lighting_object))
			continue
		if(QDELETED(A))
			continue
		if(!A.mouse_opacity)
			continue
		if(ismob(owner) && A.invisibility > owner.see_invisible)
			continue

		var/icon_b64 = null
		var/refid = REF(A)
		var/entry = icon_cache[refid]
		if(islist(entry))
			var/at = entry["at"]
			if(isnum(at) && (world.time - at) <= icon_cache_ttl_ds)
				icon_b64 = entry["b64"]

		if(isnull(icon_b64) && renders_left > 0)
			icon_b64 = _get_cached_icon_b64(A)
			renders_left--

		atoms += list(list(
			"name" = A.name,
			"ref" = refid,
			"img64" = icon_b64
		))

	.["atoms"] = atoms

/datum/tile_panel/proc/_build_mouse_params(list/params)
	var/button = text2num(params["button"])
	var/shift = text2num(params["shift"])
	var/ctrl = text2num(params["ctrl"])
	var/alt = text2num(params["alt"])

	var/list/L = list()
	if(button == 2)
		L["right"] = "1"
	else if(button == 1)
		L["middle"] = "1"
	else
		L["left"] = "1"

	if(shift) L["shift"] = "1"
	if(ctrl)  L["ctrl"]  = "1"
	if(alt)   L["alt"]   = "1"

	var/icon_x = params["icon-x"]
	var/icon_y = params["icon-y"]
	if(!icon_x) icon_x = "16"
	if(!icon_y) icon_y = "16"
	L["icon-x"] = "[icon_x]"
	L["icon-y"] = "[icon_y]"

	return L

/datum/tile_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if(TILEPANEL_ACT_CLOSE)
			close()
			return TRUE

		if(TILEPANEL_ACT_INTERACT)
			var/ref_text = params["ref"]
			if(!ref_text)
				return TRUE

			var/atom/target = locate(ref_text)
			if(!istype(target) || QDELETED(target))
				return TRUE

			if(!owner || !owner.client || !target_turf)
				return TRUE

			if(!owner.can_open_tile_panel_turf(target_turf))
				return TRUE

			if(target != target_turf && target.loc != target_turf)
				return TRUE

			var/list/click_params = _build_mouse_params(params)
			var/obj/item/W = owner.get_active_held_item()

			if(W && click_params["left"] && istype(target, /obj/structure/table))
				target.attackby(W, owner, click_params)
				return TRUE

			owner.ClickOn(target, click_params)
			return TRUE

		if(TILEPANEL_ACT_DROP)
			var/src_ref_text = params["src"]
			var/over_ref_text = params["over"]
			if(!src_ref_text || !over_ref_text)
				return TRUE

			var/atom/src_atom = locate(src_ref_text)
			var/atom/over_atom = locate(over_ref_text)
			if(!istype(src_atom) || QDELETED(src_atom))
				return TRUE
			if(!istype(over_atom) || QDELETED(over_atom))
				return TRUE

			if(!owner || !owner.client || !target_turf)
				return TRUE

			if(!owner.can_open_tile_panel_turf(target_turf))
				return TRUE

			if(src_atom != target_turf && src_atom.loc != target_turf)
				return TRUE
			if(over_atom != target_turf && over_atom.loc != target_turf)
				return TRUE

			var/list/drop_params = _build_mouse_params(params)

			var/mob/old_usr = usr
			usr = owner
			src_atom.MouseDrop(over_atom, null, null, null, null, list2params(drop_params))
			usr = old_usr
			return TRUE

	return TRUE

/datum/tile_panel/proc/request_refresh(atom/context = null)
	if(!owner || !owner.client)
		return FALSE
	if(!_is_open())
		return FALSE

	if(context)
		last_context_ref = REF(context)

	var/now = world.time
	var/next_allowed = last_refresh_at + refresh_throttle_ds
	if(now >= next_allowed)
		last_refresh_at = now
		refresh_queued = FALSE
		SStgui.try_update_ui(owner, src, null)
		return TRUE

	if(!refresh_queued)
		refresh_queued = TRUE
		addtimer(CALLBACK(src, PROC_REF(_queued_refresh)), next_allowed - now)

	return TRUE

/datum/tile_panel/proc/_queued_refresh()
	refresh_queued = FALSE
	if(!owner || !owner.client)
		return
	if(!_is_open())
		return
	last_refresh_at = world.time
	SStgui.try_update_ui(owner, src, null)

/datum/tile_panel/proc/_atom_icon2base64(atom/A)
	if(!A || QDELETED(A))
		return null

	var/icon/icon_obj = null

	if(ismob(A) || isturf(A))
		icon_obj = getFlatIcon(A)
	else
		var/icon/i = A.icon
		var/state = A.icon_state
		var/d = A.dir || SOUTH

		if(i && state)
			var/list/states = icon_states(i)
			if(islist(states) && (state in states))
				icon_obj = icon(i, state, d, 1)

		if(!icon_obj)
			var/mutable_appearance/ap = A.appearance
			if(ap)
				var/icon/ap_icon = ap.icon
				var/ap_state = ap.icon_state
				var/ap_dir = ap.dir || d
				if(ap_icon && ap_state)
					var/list/ap_states = icon_states(ap_icon)
					if(islist(ap_states) && (ap_state in ap_states))
						icon_obj = icon(ap_icon, ap_state, ap_dir, 1)

		if(!icon_obj)
			icon_obj = getFlatIcon(A)

	if(!icon_obj)
		return null

	return icon2base64(icon_obj)

/datum/tile_panel/proc/_get_cached_icon_b64(atom/A)
	if(!A || QDELETED(A))
		return null

	var/refid = REF(A)
	var/now = world.time
	var/entry = icon_cache[refid]
	if(islist(entry))
		var/at = entry["at"]
		if(isnum(at) && (now - at) <= icon_cache_ttl_ds)
			return entry["b64"]

	var/b64 = _atom_icon2base64(A)
	if(!b64)
		icon_cache -= refid
		return null

	icon_cache[refid] = list("b64" = b64, "at" = now)
	return b64

#undef TILE_PANEL_UI_ID
#undef TILE_PANEL_UI_NAME
#undef TILEPANEL_ACT_CLOSE
#undef TILEPANEL_ACT_INTERACT
#undef TILEPANEL_ACT_DROP
#undef TILEPANEL_REFRESH_THROTTLE_DS