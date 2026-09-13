/datum/preferences
	/// A preview of the current character
	var/atom/movable/screen/map_view/char_preview/character_preview_view
	/// Whether we have a boner or not lmao
	var/preview_boner_state = ERECT_STATE_NONE

/datum/preferences/proc/create_character_preview_view(mob/user)
	if(!character_preview_view)
		character_preview_view = new(null, src)
		character_preview_view.generate_view("character_preview_[REF(character_preview_view)]")
	character_preview_view.update_body()
	return character_preview_view

/datum/preferences/proc/render_new_preview_appearance(mob/living/carbon/human/dummy/mannequin)
	copy_to(mannequin, 1, TRUE, TRUE)
	var/obj/item/organ/penis/preview_penis = mannequin.getorganslot(ORGAN_SLOT_PENIS)
	if(preview_penis)
		preview_penis.update_erect_state(preview_boner_state)
	return mannequin.appearance

/datum/preferences/proc/cycle_boner_preview()
	switch(preview_boner_state)
		if(ERECT_STATE_NONE)
			preview_boner_state = ERECT_STATE_PARTIAL
		if(ERECT_STATE_PARTIAL)
			preview_boner_state = ERECT_STATE_HARD
		else
			preview_boner_state = ERECT_STATE_NONE

/datum/preferences/proc/update_preview(mob/user)
	character_preview_view?.update_body()
	SStgui.try_update_ui(user, src)


/// A preview of a character for use in the preferences menu
/atom/movable/screen/map_view/char_preview
	name = "character_preview"

	/// The preferences this refers to
	var/datum/preferences/preferences
	var/forced_grid_size = 0

	var/atom/movable/screen/background/char_preview/preview_background

/atom/movable/screen/map_view/char_preview/Initialize(mapload, datum/preferences/preferences)
	. = ..()
	src.preferences = preferences

/atom/movable/screen/map_view/char_preview/generate_view(map_key)
	. = ..()
	preview_background = new(null, preferences)
	preview_background.assigned_map = assigned_map

/atom/movable/screen/map_view/char_preview/display_to_client(client/show_to)
	show_to.register_map_obj(preview_background)
	. = ..()

/atom/movable/screen/map_view/char_preview/Destroy()
	QDEL_NULL(preview_background)
	preferences?.character_preview_view = null
	preferences = null
	return ..()

/atom/movable/screen/map_view/char_preview/Click(location, control, params)
	var/list/modifiers = params2list(params)
	preview_background?.cycle_background(modifiers["right"])

/// Updates the currently displayed body
/atom/movable/screen/map_view/char_preview/proc/update_body()
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)

	appearance = preferences.render_new_preview_appearance(mannequin)
	var/grid_size = forced_grid_size || ROUND_UP(mannequin.dna.current_body_size - 0.1) // arbitrarily chosen wiggle room
	// this calls wipe_state()
	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
	update_size(grid_size)

/atom/movable/screen/map_view/char_preview/proc/cycle_forced_size(mob/user)
	switch(forced_grid_size)
		if(0)
			forced_grid_size = 1
		if(1)
			forced_grid_size = 2
		if(2)
			forced_grid_size = 3
		else
			forced_grid_size = 0

	to_chat(user, span_notice("Your character will now be displayed [forced_grid_size == 0 ? "according to their size" : "on a [forced_grid_size]x[forced_grid_size] grid"]"))
	update_size(forced_grid_size || preferences.features["body_size"])

/atom/movable/screen/map_view/char_preview/proc/update_size(grid_size)
	// this isn't required upstream but helps tremendously with sizes >110% downstream
	preview_background.fill_rect(1, 1, grid_size, grid_size)
	set_position((grid_size + 1) / 2, 1)

/// This is an old-fashioned fix for the ByondUI Layout bug, changing the screen_loc slightly will force a re-layout
/atom/movable/screen/map_view/char_preview/proc/jiggle_map()
	var/old_pos = screen_loc
	sleep(1 TICKS)
	set_position(1, 1, 2, 2)
	sleep(1 TICKS)
	screen_loc = old_pos


// Cycling Background
GLOBAL_LIST_INIT(char_preview_bgs, icon_states('icons/hud/pref_backgrounds.dmi'))

/atom/movable/screen/background/char_preview
	icon = 'icons/hud/pref_backgrounds.dmi'
	del_on_map_removal = FALSE

	var/bg_idx = 1
	var/datum/preferences/preferences

/atom/movable/screen/background/char_preview/Initialize(mapload, datum/preferences/preferences)
	. = ..()
	icon_state = GLOB.char_preview_bgs[1]
	src.preferences = preferences

/atom/movable/screen/background/char_preview/Destroy()
	preferences = null
	return ..()

/atom/movable/screen/background/char_preview/Click(location, control, params)
	var/list/modifiers = params2list(params)
	cycle_background(modifiers["right"])

/atom/movable/screen/background/char_preview/proc/set_background(bg)
	var/index = GLOB.char_preview_bgs.Find(bg)
	if(index != 0)
		bg_idx = index
		icon_state = GLOB.char_preview_bgs[bg_idx]

/atom/movable/screen/background/char_preview/proc/cycle_background(right = FALSE)
	if(!right)
		bg_idx += 1
		if(bg_idx > LAZYLEN(GLOB.char_preview_bgs))
			bg_idx = 1
	else
		bg_idx -= 1
		if(bg_idx <= 0)
			bg_idx =  LAZYLEN(GLOB.char_preview_bgs)

	icon_state = GLOB.char_preview_bgs[bg_idx]
	preferences.update_pref_data_for_all_viewers()
