/*

-- AOE INTENTS --
They're meant to be kept on the weapon and used via Strong stance's rclick.
At the moment the pattern is manually designated using coordinates in tile_coordinates.
This allows the devs to draw whatever shape they want at the cost of it feeling a little quirky.
*/
#define SPECIAL_AOE_AROUND_ORIGIN list(list(0,0), list(1,0), list(1,-1),list(1,-2),list(0,-2),list(-1,-2),list(-1,-1),list(-1,0))
#define CUSTOM_TIMER_INDEX 3

/datum/special_intent
	var/name = "special intent"
	var/desc = "desc"
	var/mob/living/carbon/human/howner
	var/obj/item/iparent

	/// The main place where we can draw out the pattern. Every tile entry is a list with two numbers.
	/// The origin (0,0) is one step forward from the dir the owner is facing.
	/// This is abstract, and can be modified, though it's best done before _assign_grid_indexes().
	/// For best effect, draw the coordinates as if the character is facing NORTH. That way it'll rotate as intended if dir is respected.
	/// Third entry can be used for custom timing. That turf will only start to be processed after the third index's delay.
	/// eg. list(0,0), list(0,1) -> two vertical turfs from origin, appearing and applying their effects instantly.
	/// list(0,0), list(0, 1, 0.1 SECONDS) -> one turf right in front of the origin, then the second 0.1 seconds later.
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

	/// Stamina cost to apply. Values <1 will apply a %-age cost. Values >1 will apply the flat value.
	/// 0 Is no cost.
	var/stamcost = 0


	// Hacky bools vv 

	/// The datum has been cancelled. Either the doafter failed or adjacency was not respected after the delay. 
	/// This means some or none of the effect will happen.
	var/cancelled = FALSE
	/// Datum has succeeded an adjacency / doafter check. This is to prevent re-checking / re-doing the doafter for every unique tile.
	var/succeeded = FALSE
	/// We are currently performing the doafter, preventing the code from trying to call new ones (thus failing them instantly).
	var/is_doing = FALSE

	// Hacky bool end ^^

	/// The delay for either the doafter or the timers on the turfs before calling post_delay() and apply_hit()
	/// Or in other words. The pause before the hit of the special happens.
	var/delay = 1 SECONDS

	///The amount of time the post-delay effect is meant to linger.
	var/fade_delay = 0.5 SECONDS

	///Whether we'll check if our howner is adjacent to any of the tiles post-delay. 
	///This is to prevent drop-and-run effect as if it was a spell.
	///If the datum is using multi-timed turfs, only the FIRST one's adjacency is checked ONCE.
	var/respect_adjacency = TRUE

	var/sfx_pre_delay
	var/sfx_post_delay

	var/_icon = 'icons/effects/effects.dmi'
	var/pre_icon_state = "blip"
	var/post_icon_state = "strike"

	var/datum/skill/custom_skill

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
	if(howner && howner.ckey)
		howner.log_message(span_danger("Used the Special [name]."), LOG_ATTACK)
	_reset()
	_clear_grid()
	_assign_grid_indexes()
	_create_grid()
	on_create()
	_manage_grid()
	apply_cooldown(cooldown)

///We reset everything to make sure it all works. Make sure the cooldown -never- becomes shorter than the active effect.
///Otherwise this proc will absolutely break everything, along with everything else breaking in general.
/datum/special_intent/proc/_reset()
	respect_adjacency = initial(respect_adjacency)
	cancelled = initial(cancelled)
	succeeded = initial(succeeded)
	is_doing = initial(is_doing)

/datum/special_intent/proc/_clear_grid()
	if(length(affected_turfs))
		LAZYCLEARLIST(affected_turfs)

///We go through our list of coordinates and check for custom timings. If we find any, we make a list to be managed later in _create_grid().
/datum/special_intent/proc/_assign_grid_indexes()
	affected_turfs[delay] = list()
	for(var/list/l in tile_coordinates)
		if(LAZYACCESS(l, CUSTOM_TIMER_INDEX))	//Third index is a custom timer.
			if(!affected_turfs[l[CUSTOM_TIMER_INDEX]])
				affected_turfs[l[CUSTOM_TIMER_INDEX]] = list()
			else
				continue

///Gathers up the grid from tile_coordinates and puts the turfs into affected_turfs. Does not draw anything, yet.
/datum/special_intent/proc/_create_grid()
	var/turf/origin = use_clickloc ? click_loc : (get_step(get_turf(howner), howner.dir))	//Origin is either target or 1 step in the dir of howner.
	for(var/list/l in tile_coordinates)
		var/dx = l[1]
		var/dy = l[2]
		var/dtimer
		if(LAZYACCESS(l, CUSTOM_TIMER_INDEX)) //Third index is a custom timer.
			dtimer = l[CUSTOM_TIMER_INDEX]
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
			addtimer(CALLBACK(src, PROC_REF(_process_grid), affected_turfs[newdelay], newdelay), newdelay)

///Called to process the grid of turfs. The main proc that draws, delays and applies the post-delay effects.
/datum/special_intent/proc/_process_grid(list/turfs, newdelay)
	_draw(turfs)
	pre_delay(turfs)
	_delay(turfs, newdelay)

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
/datum/special_intent/proc/_delay(list/turfs, newdelay)
	if(!cancelled)
		if(use_doafter && !is_doing)
			if(!succeeded)
				if(_try_doafter())
					post_delay(turfs)
			else
				post_delay(turfs)
		else
			addtimer(CALLBACK(src, PROC_REF(post_delay), turfs), is_doing ? (delay + newdelay) : delay)

/datum/special_intent/proc/_try_doafter()
	is_doing = TRUE
	if(do_after(howner, delay, same_direction = FALSE))
		succeeded = TRUE	//We only want to succeed one do after, cus otherwise it'll try to repeat it per-tile / timer. Glitchy!
		return TRUE
	else
		to_chat(howner, span_warning("I was interrupted!"))
		cancelled = TRUE
		return FALSE

/// This is called immediately after the delay of the intent.
/// It performs any needed adjacency checks and will try to draw the "post" visuals on any valid turfs.
/// It calls apply_hit() after where most of the logic for any on-hit effects should go.
/datum/special_intent/proc/post_delay(list/turfs)
	SHOULD_CALL_PARENT(TRUE)
	if(cancelled)	//Just in case we're here after a doafter that has failed.
		return

	if(respect_adjacency)
		var/is_adjacent = FALSE
		for(var/turf/T in turfs)
			if(howner.Adjacent(T))
				is_adjacent = TRUE
				respect_adjacency = FALSE //This ensures multi-timer patterns that call this proc won't get tripped up.
				break
		if(!is_adjacent)
			to_chat(howner, span_danger("I moved too far from my manoeuvre!"))
			return
	if(post_icon_state)
		for(var/turf/T in turfs)
			var/obj/effect/temp_visual/special_intent/fx = new (T, fade_delay)
			fx.icon = _icon
			fx.icon_state = post_icon_state
			apply_hit(T)
	if(sfx_post_delay)
		playsound(howner, sfx_post_delay, 100, TRUE)

/// Main proc where stuff should happen. This is called immediately after the post_delay of the intent.
/datum/special_intent/proc/apply_hit(turf/T)
	SHOULD_CALL_PARENT(TRUE)

/// This is called by post_delay() and _try_doafter() if the doafter fails.
/// If you dynamically tweak the cooldown remember that it will /stay/ that way on this datum without
/// refreshing it with Initial() somewhere.
/datum/special_intent/proc/apply_cooldown(cd, override = FALSE)
	if(override)
		howner.remove_status_effect(/datum/status_effect/debuff/specialcd)
		howner.apply_status_effect(/datum/status_effect/debuff/specialcd, cd)
		return
	howner.apply_status_effect(/datum/status_effect/debuff/specialcd, cd)

///A proc that attempts to deal damage to the target, simple mob or carbon. 
///Does /not/ crit. Respects armor, but CAN pen unless "no_pen" is set to TRUE. Each Special can have its own way of scaling damage.
///Targets with no armor will always take damage, even if no_pen is set.
///!This proc is inherently tied to !iparent! Do NOT use this for generic "magic" type of damage or if it's called from an obj like a trap!
/datum/special_intent/proc/apply_generic_damage(mob/living/target, dam, d_type, zone, bclass, no_pen = FALSE)
	var/msg = "<font color = '#c2663c'>[name] strikes [target]!"
	if(ishuman(target))
		var/mob/living/carbon/human/HT = target
		var/obj/item/bodypart/affecting = HT.get_bodypart(zone)
		var/armor_block = HT.run_armor_check(zone, d_type, 0, damage = dam, used_weapon = iparent, armor_penetration = 0)
		if(no_pen)
			armor_block = 100
		if(HT.apply_damage(dam, iparent.damtype, affecting, armor_block))
			affecting.bodypart_attacked_by(bclass, dam, howner, armor = armor_block, crit_message = TRUE, weapon = iparent)
			msg += "<b> It pierces through to their flesh!</b>"
			playsound(HT, pick(iparent.hitsound), 80, TRUE)
	else
		target.attacked_by(iparent, howner)
	msg += "</font>"
	howner?.visible_message(msg)


//A subtype that creates a grid for us so we don't have to painstakingly define it tile by tile.
//Consequently, however, it does NOT support custom timers and will only work with the default delay var.
//If you want a pattern with multiple rectangles you'll either have to deploy multiples of these, or use a custom, tile-by-tile one.
/datum/special_intent/rectangle
	name = "base type of a rectangle preset"
	desc = "do not use me, use my children"
	tile_coordinates = list()
	use_clickloc = TRUE
	respect_adjacency = FALSE
	var/rect_width	//In tiles, width will count as the X axis
	var/rect_height	//Y axis. The grid will try to be centered around the origin, which would be the caster by default. Best mileage with use_clickloc.

//Complete override.
/datum/special_intent/rectangle/_create_grid()
	affected_turfs[delay] = create_rectangle()

///We try to make a grid using the width / height and the built-in DM block() proc.
/datum/special_intent/rectangle/proc/create_rectangle()
	var/list/newtiles = list()
	var/turf/origin = use_clickloc ? click_loc : (get_step(get_turf(howner), howner.dir))	//Origin is either target or 1 step in the dir of howner.

	var/x_lower = (origin.x - floor(rect_width / 2))
	var/x_upper = (origin.x + floor(rect_width / 2)) + (rect_width % 2 == 0 ? -1 : 0)	//We subtract 1 row / column from the block if it's even to keep it accurate.
	var/y_lower = (origin.y - floor(rect_height / 2))
	var/y_upper = (origin.y + floor(rect_height / 2)) + (rect_height % 2 == 0 ? -1 : 0)

	var/turf/block_lower = locate(x_lower, y_lower, origin.z)
	var/turf/block_upper = locate(x_upper, y_upper, origin.z)
	if(isnull(block_lower) || isnull(block_upper))
		CRASH("Rectangle Special was called with invalid corner turfs. Potentially used near the map's edge?")
	newtiles = block(block_lower, block_upper)
	return newtiles

/*
/datum/special_intent/rectangle/example_rect
	name = "Rectangle Example"
	desc = "You can attach this to a weapon to see what it looks like. Do not use for real."
	tile_coordinates = list()	//Kept blank on purpose, we make our own!
	
	rect_width = 5
	rect_height = 4

	use_clickloc = TRUE
	respect_adjacency = FALSE
	respect_dir = FALSE
	pre_icon_state = "chronofield"
	post_icon_state = "at_shield2"
	sfx_post_delay = 'sound/magic/repulse.ogg'
	delay = 1 SECONDS
	cooldown = 2 SECONDS 
*/

/*

*******************
SPECIALS START HERE
*******************

*/

/datum/special_intent/side_sweep
	name = "Distracting Swipe"
	desc = "Swings at your primary flank in a distracting fashion. Anyone caught in it will be exposed for a short while."
	tile_coordinates = list(list(0,0), list(1,0), list(1,-1))	//L shape that hugs our -right- flank.
	post_icon_state = "sweep_fx"
	pre_icon_state = "trap"
	sfx_post_delay = 'sound/combat/sidesweep_hit.ogg'
	delay = 0.6 SECONDS
	cooldown = 17 SECONDS 
	var/eff_dur = 5 SECONDS
	var/dam = 20
	var/t_zone

/datum/special_intent/side_sweep/process_attack()
	tile_coordinates = list()
	t_zone = null
	if(howner.used_hand == 1)	//We invert it if it's the left arm.
		tile_coordinates += list(list(0,0), list(-1,0), list(-1,-1))
	else
		tile_coordinates += list(list(0,0), list(1,0), list(1,-1))	//Initial() doesn't work with lists so we copy paste the original
	var/statmod = max(howner.STASPD, howner.STASTR, howner.STASPD, howner.STAPER)
	if(iparent)
		dam = iparent.force * (statmod / 10)
	if(howner.zone_selected != BODY_ZONE_CHEST)
		if(check_zone(howner.zone_selected) != howner.zone_selected || howner.STAPER < 11)
			if(prob(33))
				t_zone = howner.zone_selected
		else
			t_zone = howner.zone_selected
	if(!t_zone)
		t_zone = BODY_ZONE_CHEST
	. = ..()

/datum/special_intent/side_sweep/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		L.apply_status_effect(/datum/status_effect/debuff/exposed, eff_dur)
		apply_generic_damage(L, dam, iparent.d_type, t_zone, bclass = BCLASS_CUT)
	..()

/datum/special_intent/shin_swipe
	name = "Shin Prod"
	desc = "A hasty attack at the legs, extending ourselves. Slows down the opponent if hit."
	tile_coordinates = list(list(0,0), list(0,1))
	post_icon_state = "sweep_fx"
	pre_icon_state = "trap"
	sfx_post_delay = 'sound/combat/shin_swipe.ogg'
	delay = 0.7 SECONDS
	cooldown = 15 SECONDS
	var/eff_dur = 5	//We do NOT want to use SECONDS macro here.
	var/dam

/datum/special_intent/shin_swipe/process_attack()
	dam = iparent.force_dynamic * min((1 + (((howner.STASPD - 10) + (howner.STAPER - 10)) / 10)), 0.1)
	. = ..()


/datum/special_intent/shin_swipe/apply_hit(turf/T)	//This is applied PER tile, so we don't need to do a big check.
	for(var/mob/living/L in get_hearers_in_view(0, T))
		L.Slowdown(eff_dur)
		apply_generic_damage(L, dam, "stab", pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), bclass = BCLASS_CUT)
	..()

//Hard to hit, freezes you in place. Offbalances & slows the targets hit. If they're already offbalanced they get knocked down.
/datum/special_intent/ground_smash
	name = "Ground Smash"
	desc = "Swings downward, leaving a traveling quake for a few tiles. Anyone struck by it will be slowed and offbalanced, or knocked down if they're already off-balanced."
	tile_coordinates = list(list(0,0), list(0,1, 0.1 SECONDS), list(0,2, 0.2 SECONDS))
	post_icon_state = "kick_fx"
	pre_icon_state = "trap"
	use_doafter = TRUE
	respect_adjacency = FALSE
	delay = 0.7 SECONDS
	cooldown = 20 SECONDS
	var/slow_dur = 5	//We do NOT want to use SECONDS macro here. Slowdown() takes in an int and turns it into seconds already.
	var/KD_dur = 2 SECONDS
	var/Offb_dur = 5 SECONDS
	var/Offbself_dur = 1.5 SECONDS
	var/dam = 80

//We play the pre-sfx here because it otherwise it gets played per tile. Sounds funky.
/datum/special_intent/ground_smash/on_create()
	. = ..()
	howner.OffBalance(Offbself_dur)
	playsound(howner, 'sound/combat/ground_smash_start.ogg', 100, TRUE)

/datum/special_intent/ground_smash/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		//We fling the target sideways from the attacker
		var/targetdir = get_dir(L, howner)
		var/throwdir = turn(targetdir, prob(50) ? 90 : 270)
		var/dist = rand(1, 3)
		var/turf/current_turf = get_turf(L)
		var/turf/target_turf = get_ranged_target_turf(current_turf, throwdir, dist)
		L.safe_throw_at(target_turf, dist, 1, howner, force = MOVE_FORCE_EXTREMELY_STRONG)
		//We slow them down
		L.Slowdown(slow_dur)
		//We offbalance them OR knock them down if they're already offbalanced
		if(L.IsOffBalanced())
			L.Knockdown(KD_dur)
		else
			L.OffBalance(Offb_dur)
		apply_generic_damage(L, dam, "blunt", BODY_ZONE_CHEST, bclass = BCLASS_BLUNT, no_pen = TRUE)
	var/sfx = pick('sound/combat/ground_smash1.ogg','sound/combat/ground_smash2.ogg','sound/combat/ground_smash3.ogg')
	playsound(T, sfx, 100, TRUE)
	..()


/datum/special_intent/flail_sweep
	name = "Flail Sweep"
	desc = "Swings in a perfect circle all around you, pushing people aside. The more are struck, the more powerful the effect."
	tile_coordinates = SPECIAL_AOE_AROUND_ORIGIN
	post_icon_state = "sweep_fx"
	pre_icon_state = "trap"
	sfx_pre_delay = 'sound/combat/flail_sweep.ogg'
	use_doafter = TRUE
	respect_adjacency = FALSE
	delay = 0.8 SECONDS
	cooldown = 25 SECONDS
	var/victim_count = 0
	var/slow_init = 2
	var/exposed_init = 3 SECONDS
	var/offbalanced_init = 1.5 SECONDS
	var/knockdown = 2 SECONDS
	var/immobilize_init = 1 SECONDS
	var/dam = 20

/datum/special_intent/flail_sweep/on_create()
	. = ..()
	victim_count = initial(victim_count)

/datum/special_intent/flail_sweep/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		victim_count++
		addtimer(CALLBACK(src, PROC_REF(apply_effect), L), 0.1 SECONDS)	//We need to count them all up first so this is an unfortunate (& janky) requirement.
	..()																//An alternative could be a spatial grid count from howner called once.

///This will apply the actual effect, as we need some way to count all the mobs in the zone first.
/datum/special_intent/flail_sweep/proc/apply_effect(mob/living/victim)
	var/newslow = slow_init + victim_count	//Slows take an int and applies its own logic in the Slowdown proc itself. Do NOT use SECONDS for slows.
	var/newexposed = exposed_init + (victim_count SECONDS)
	var/newoffb = offbalanced_init + (victim_count SECONDS)
	var/newimmob = immobilize_init + (victim_count SECONDS)

	var/throwtarget = get_edge_target_turf(howner, get_dir(howner, get_step_away(victim, howner)))
	switch(victim_count)
		if(1)
			victim.Slowdown(newslow)
		if(2)
			victim.Slowdown(newslow)
			victim.Immobilize(newimmob)
			victim.apply_status_effect(/datum/status_effect/debuff/exposed, newexposed)
		if(3 to 5)
			victim.Slowdown(newslow)
			victim.Immobilize(newimmob)
			victim.apply_status_effect(/datum/status_effect/debuff/exposed, newexposed)
			victim.Knockdown(knockdown)
		if(5 to 9)
			victim.Slowdown(newslow)
			victim.Immobilize(newimmob)
			victim.apply_status_effect(/datum/status_effect/debuff/exposed, newexposed)
			victim.Knockdown(knockdown)
			victim.OffBalance(newoffb)
			victim.Stun(5 SECONDS)
	if(victim_count < 3)
		playsound(howner, 'sound/combat/flail_sweep_hit_minor.ogg', 100, TRUE)
	else
		playsound(howner, 'sound/combat/flail_sweep_hit_major.ogg', 100, TRUE)
	apply_generic_damage(victim, dam * victim_count, "blunt", BODY_ZONE_CHEST, bclass = BCLASS_BLUNT, no_pen = TRUE)
	victim.safe_throw_at(throwtarget, CLAMP(1, 5, victim_count), 1, howner, force = MOVE_FORCE_EXTREMELY_STRONG)

/datum/special_intent/axe_swing
	name = "Hefty Swing"
	desc = "Swings from left to right. Anyone caught in the swing get immobilized and exposed."
	tile_coordinates = list(list(-1,0), list(0,0, 0.2 SECONDS), list(1,0, 0.3 SECONDS))
	post_icon_state = "sweep_fx"
	pre_icon_state = "trap"
	use_doafter = TRUE
	respect_adjacency = FALSE
	delay = 0.6 SECONDS
	cooldown = 25 SECONDS
	var/immob_dur = 3 SECONDS
	var/exposed_dur = 5 SECONDS
	var/dam

/datum/special_intent/axe_swing/process_attack()
	tile_coordinates = list()
	dam = iparent.force_dynamic * (howner.STASTR / 10)
	if(howner.used_hand == 1)	//We mirror it if it's the left arm.
		tile_coordinates += list(list(-1,0, 0.3 SECONDS), list(0,0, 0.2 SECONDS), list(1,0))
	else
		tile_coordinates += list(list(-1,0), list(0,0, 0.2 SECONDS), list(1,0, 0.3 SECONDS)) //Initial() doesn't work with lists so we copy paste the original
	. = ..()

//We play the pre-sfx here because it otherwise it gets played per tile. Sounds funky.
/datum/special_intent/axe_swing/on_create()
	..()
	playsound(howner, 'sound/combat/rend_start.ogg', 100, TRUE)

/datum/special_intent/axe_swing/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		L.apply_status_effect(/datum/status_effect/debuff/exposed, exposed_dur)
		L.Immobilize(immob_dur)
		apply_generic_damage(L, dam, "slash", pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), bclass = BCLASS_CHOP)
	var/sfx = pick('sound/combat/sp_axe_swing1.ogg','sound/combat/sp_axe_swing1.ogg','sound/combat/sp_axe_swing1.ogg')
	playsound(T, sfx, 100, TRUE)
	..()

/* 				EXAMPLES
/datum/special_intent/another_example_cast
	name = "Expanding Rectangle Pattern"
	desc = "I'm just an example of a bigger pattern."
	tile_coordinates = list(list(0,0),list(1,0, 0.3 SECONDS),list(-1,0, 0.3 SECONDS),list(1,1, 0.3 SECONDS),list(-1,1, 0.3 SECONDS),list(1,-1, 0.3 SECONDS),list(-1,-1, 0.3 SECONDS),list(0,1, 0.3 SECONDS),list(0,-1, 0.3 SECONDS),
						list(2,0, 0.6 SECONDS),list(2,1, 0.6 SECONDS),list(2,2, 0.6 SECONDS),list(2,-1, 0.6 SECONDS),list(2,-2, 0.6 SECONDS),list(1,-2, 0.6 SECONDS),list(1,2, 0.6 SECONDS),list(0,-2, 0.6 SECONDS),list(0,2, 0.6 SECONDS),
						list(-1,-2, 0.6 SECONDS),list(-1,2, 0.6 SECONDS),list(-2,0, 0.6 SECONDS),list(-2,1, 0.6 SECONDS),list(-2,2, 0.6 SECONDS),list(-2,-1, 0.6 SECONDS),list(-2,-2, 0.6 SECONDS))
	use_clickloc = TRUE
	respect_adjacency = FALSE
	respect_dir = FALSE
	pre_icon_state = "chronofield"
	post_icon_state = "at_shield2"
	sfx_post_delay = 'sound/magic/repulse.ogg'
	delay = 1 SECONDS
	cooldown = 2 SECONDS 

Example of a fun pattern that overlaps in three waves. Use with default delay at 1 SECONDS
#define WAVE_2_DELAY 0.75 SECONDS
#define WAVE_3_DELAY 1.2 SECONDS
tile_coordinates = list(list(1,1), list(-1,1), list(-1,-1), list(1,-1),list(0,0),
					list(-1,0,WAVE_2_DELAY), list(-2,0,WAVE_2_DELAY), list(0,0,WAVE_2_DELAY), list(1,0,WAVE_2_DELAY), list(2,0,WAVE_2_DELAY),
					list(0,0,WAVE_3_DELAY),list(0,-1,WAVE_3_DELAY),list(0,-2,WAVE_3_DELAY),list(0,1,WAVE_3_DELAY),list(0,2,WAVE_3_DELAY))
*/

//Example of a sweeping line from left to right from the clicked turf. The second tile and the line will only appear after 1.1 seconds (the first delay).
//tile_coordinates = list(list(0,0), list(1,0, 1.1 SECONDS), list(2,0, 1.2 SECONDS), list(3,0,1.3 SECONDS), list(4,0,1.4 SECONDS), list(5,0,1.5 SECONDS))

#undef SPECIAL_AOE_AROUND_ORIGIN
#undef CUSTOM_TIMER_INDEX
