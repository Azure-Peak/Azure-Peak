/*

-- AOE INTENTS --
They're meant to be kept on the weapon and used via Strong stance's rclick.
At the moment the pattern is manually designated using coordinates in tile_coordinates.
This allows the devs to draw whatever shape they want at the cost of it feeling a little quirky.
*/
/datum/special_intent
	var/name = "special intent"
	var/desc = "desc"
	var/mob/living/carbon/human/howner
	var/obj/item/iparent

	/// The main place where we can draw out the pattern. Every tile entry is a list with two numbers.
	/// The origin (0,0) is one step forward from the dir the owner is facing.
	/// This is abstract, and can be modified, though it's best be done before _draw_grid().
	var/list/tile_coordinates

	/// The list of turfs the grid will be drawn on and 
	var/list/affected_turfs = alist()

	/// Whether to have the howner pass through a doafter for the delay rather than it being on every turf.
	/// Default code here does not allow for dir switching during the do after.
	var/use_doafter = FALSE

	/// Whether the special uses the target atom that was clicked on. Generally best reserved to be a turf.
	/// This WILL change how the grid is drawn, as the 'origin' will become the clicked-on turf.
	var/use_clickloc = FALSE

	/// Whether the grid pattern will rotate with the howner's dir. Set to FALSE if you want to keep the grid
	/// In a static, consistent pattern regardless of how / where it's deployed.
	var/respect_dir = TRUE

	/// The target turf ref if we use_clickloc.
	var/turf/click_loc 

	var/cooldown = 30 SECONDS
	var/cancelled = FALSE

	///The delay for either the doafter or the timers on the turfs before calling post_delay() and apply_hit()
	var/delay = 1 SECONDS

	///The amount of time the post-delay effect is meant to linger.
	var/fade_delay = 0.5 SECONDS

	///Whether we'll check if our howner is adjacent to any of the tiles post-delay. 
	///This is to prevent drop-and-run effect as if it was a spell.
	var/respect_adjacency = TRUE

	var/sfx_pre_delay
	var/sfx_post_delay

	var/_icon = 'icons/effects/effects.dmi'
	var/pre_icon_state = "blip"
	var/post_icon_state = "strike"

///Called by external sources -- likely an rclick. By default the 'target' will be stored as a turf.
/datum/special_intent/proc/deploy(mob/living/user, obj/item/weapon, atom/target)
	if(!ishuman(user))
		CRASH("Special intent called from a non-human parent.")
	if(!isitem(weapon))
		CRASH("Special intent called without a valid item.")
	howner = user
	iparent = weapon
	cancelled = FALSE
	if(use_clickloc)
		if(isturf(target))
			click_loc = target
		else
			click_loc = get_turf(target)
		if(!click_loc)
			CRASH("Special intent with clickloc called on something that has no valid turf. Potentially used at the map's edge?")
	process_attack()

///Main pipeline. Note that _delay() calls post_delay() after a timer.
/datum/special_intent/proc/process_attack()
	SHOULD_CALL_PARENT(TRUE)
	_clear_grid()
	_assign_grid_indexes()
	_create_grid()
	on_create()
	_manage_grid()

/datum/special_intent/proc/_clear_grid()
	if(length(affected_turfs))
		LAZYNULL(affected_turfs)

///We go through our list of coordinates and check for custom timings. If we find any, we make a list to be managed later in _create_grid().
/datum/special_intent/proc/_assign_grid_indexes()
	affected_turfs[delay] = list()
	for(var/list/l in tile_coordinates)
		if(LAZYACCESS(l, 3))	//Third index is a custom timer.
			if(!affected_turfs[l[3]])
				affected_turfs[l[3]] = list()
			else
				continue

///Gathers up the grid from tile_coordinates and puts the turfs into affected_turfs. Does not draw anything, yet.
/datum/special_intent/proc/_create_grid()
	var/turf/origin = use_clickloc ? click_loc : (get_step(get_turf(howner), howner.dir))	//Origin is either target or 1 step in the dir of howner.
	for(var/list/l in tile_coordinates)
		var/dx = l[1]
		var/dy = l[2]
		var/dtimer
		if(LAZYACCESS(l, 3)) //Third index is a custom timer.
			dtimer = l[3]
		if(respect_dir)
			switch(howner.dir)
				//if(NORTH) Do nothing because the coords are meant to be written from north-facing perspective. All is well.
				if(SOUTH)
					dx = -dx
					dy = -dy
				if(WEST)
					var/holder = dx
					dx = -dy
					dy = holder
				if(EAST)
					var/holder = dx
					dx = dy
					dy = -holder
		var/turf/step = locate((origin.x + dx), (origin.y + dy), origin.z)
		if(step && isturf(step) && !step.density)
			var/list/timerlist
			if(dtimer)
				timerlist = affected_turfs[dtimer]
				timerlist.Add(step)
			else	//No custom timer, we just add it to the default datum's delay one.
				timerlist = affected_turfs[delay]
				timerlist.Add(step)

///More like manages gridS. Calls process on every made grid with the appropriate timer.
/datum/special_intent/proc/_manage_grid()
	if(!length(affected_turfs))	//Nothing to draw, but technically possible without being an error.
		return
	for(var/newdelay in affected_turfs)
		if(newdelay == delay)
			_process_grid(affected_turfs[delay])
		else
			addtimer(CALLBACK(src, PROC_REF(_process_grid), affected_turfs[newdelay]), newdelay)

///Called to process the grid of turfs. The main proc that draws, delays and applies the post-delay effects.
/datum/special_intent/proc/_process_grid(list/turfs)
	_draw(turfs)
	pre_delay(turfs)
	_delay(turfs)

/datum/special_intent/proc/_draw(list/turfs)
	for(var/turf/T in turfs)
		var/obj/effect/temp_visual/special_intent/fx = new (T, delay)
		fx.icon = _icon
		fx.icon_state = pre_icon_state
	
///Called after the affected_turfs list is populated, but before the grid is drawn.
/datum/special_intent/proc/on_create()

///Called after the grid has been drawn on every affected_turfs entry. The delay has not been initiated yet.
/datum/special_intent/proc/pre_delay(list/turfs)
	SHOULD_CALL_PARENT(TRUE)
	if(sfx_pre_delay)
		playsound(howner, sfx_pre_delay, 100, TRUE)

///Delay proc. Preferably it won't be hooked into.
/datum/special_intent/proc/_delay(list/turfs)
	if(!cancelled)
		if(use_doafter)
			if(_try_doafter())
				post_delay(turfs)
		else
			addtimer(CALLBACK(src, PROC_REF(post_delay), turfs), delay)

/datum/special_intent/proc/_try_doafter()
	if(do_after(howner, delay, same_direction = TRUE))
		return TRUE
	else
		to_chat(howner, span_warning("I was interrupted!"))
		cancelled = TRUE
		apply_cooldown()
		return FALSE

/// This is called immediately after the delay of the intent.
/// It performs any needed adjacency checks and will try to draw the "post" visuals on any valid turfs.
/// It calls apply_hit() after where most of the logic for any on-hit effects should go.
/datum/special_intent/proc/post_delay(list/turfs)
	SHOULD_CALL_PARENT(TRUE)
	if(respect_adjacency)
		var/is_adjacent = FALSE
		for(var/turf/T in turfs)
			if(howner.Adjacent(T))
				is_adjacent = TRUE
				break
		if(!is_adjacent)
			to_chat(howner, span_danger("I moved too far from my maneuvre!"))
			apply_cooldown()
			return
	if(post_icon_state)
		for(var/turf/T in turfs)
			var/obj/effect/temp_visual/special_intent/fx = new (T, fade_delay)
			fx.icon = _icon
			fx.icon_state = post_icon_state
			apply_hit(T)
	if(sfx_post_delay)
		playsound(howner, sfx_post_delay, 100, TRUE)
	apply_cooldown()

/// Main proc where stuff should happen. This is called immediately after the post_delay of the intent.
/datum/special_intent/proc/apply_hit(turf/T)
	SHOULD_CALL_PARENT(TRUE)

/// This is called by post_delay() and _try_doafter() if the doafter fails.
/// If you dynamically tweak the cooldown remember that it will /stay/ that way on this datum without
/// refreshing it with Initial() somewhere.
/datum/special_intent/proc/apply_cooldown()
	howner.apply_status_effect(/datum/status_effect/debuff/specialcd, cooldown)

/datum/special_intent/side_sweep
	name = "Side Sweep"
	desc = "Swings at your primary flank in a distracting fashion. Anyone caught in it will be exposed for a short while."
	tile_coordinates = list(list(0,0), list(1,0), list(1,-1))	//L shape that hugs our flank.
	post_icon_state = "emote"
	sfx_post_delay = 'sound/combat/sidesweep_hit.ogg'
	delay = 0.8 SECONDS
	cooldown = 20 SECONDS
	var/eff_dur = 7 SECONDS
	

/datum/special_intent/side_sweep/process_attack()
	if(howner.used_hand == 1)	//Left hand. We mirror the pattern.
		tile_coordinates = list(list(0,0), list(-1,0), list(-1,-1))
	else
		tile_coordinates = initial(tile_coordinates)
	..()

/datum/special_intent/side_sweep/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		L.apply_status_effect(/datum/status_effect/debuff/exposed, eff_dur)
	..()

/datum/special_intent/shin_swipe
	name = "Shin Swipe"
	desc = "A hasty attack at the legs, extending ourselves. Slows down the opponent if hit."
	tile_coordinates = list(list(0,0), list(0,1))
	post_icon_state = "emote"
	pre_icon_state = "blip"
	sfx_post_delay = 'sound/combat/shin_swipe.ogg'
	delay = 0.8 SECONDS
	cooldown = 15 SECONDS
	var/eff_dur = 5	//We do NOT want to use SECONDS macro here.

/datum/special_intent/side_sweep/apply_hit(turf/T)	//This is applied PER tile, so we don't need to do a big check.
	for(var/mob/living/L in get_hearers_in_view(0, T))
		L.Slowdown(eff_dur)	
	..()
/*
Example of a fun pattern that overlaps in three waves.
#define WAVE_2_DELAY 0.75 SECONDS
#define WAVE_3_DELAY 2 SECONDS
tile_coordinates = list(list(1,1), list(-1,1), list(-1,-1), list(1,-1),list(0,0),
					list(-1,0,WAVE_2_DELAY), list(-2,0,WAVE_2_DELAY), list(0,0,WAVE_2_DELAY), list(1,0,WAVE_2_DELAY), list(2,0,WAVE_2_DELAY),
					list(0,0,WAVE_3_DELAY),list(0,-1,WAVE_3_DELAY),list(0,-2,WAVE_3_DELAY),list(0,1,WAVE_3_DELAY),list(0,2,WAVE_3_DELAY))
*/

//Example of a sweeping line from left to right from the clicked turf. The second tile and the line will only appear after 1.1 seconds (the first delay).
//tile_coordinates = list(list(0,0), list(1,0, 1.1 SECONDS), list(2,0, 1.2 SECONDS), list(3,0,1.3 SECONDS), list(4,0,1.4 SECONDS), list(5,0,1.5 SECONDS))
