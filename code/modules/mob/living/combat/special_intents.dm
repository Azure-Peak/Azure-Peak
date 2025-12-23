#define WAVE_2_DELAY 0.75 SECONDS
#define WAVE_3_DELAY 2 SECONDS
#define SPECIAL_AOE_AROUND_ORIGIN list(list(0,0), list(1,0), list(1,-1),list(1,-2),list(0,-2),list(-1,-2),list(-1,-1),list(-1,0))
#define CUSTOM_TIMER_INDEX 3
/*

-- AOE INTENTS --
They're meant to be kept on the weapon and used via Strong stance's rclick.
At the moment the pattern is manually designated using coordinates in tile_coordinates.
This allows the devs to draw whatever shape they want at the cost of it feeling a little quirky.
*/
/datum/special_intent
	var/name = "special intent"
	var/desc = "desc"

	var/mob/living/howner
	var/atom/movable/iparent

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

	/// Max range at which this Special can be used. This only matters with use_clickloc.
	var/range = 0

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

///To be called by EXTERNAL SOURCES, preferably. We don't want to bog this datum down with built-in costs, but I won't stop you.
/datum/special_intent/proc/apply_cost(mob/living/L)
	if(L.has_status_effect(/datum/status_effect/buff/clash/limbguard))	//TODO: A more standardised way of checking for toggle Specials that should prevent others from being used.
		return FALSE
	if(L && stamcost)
		//If <1 it's %-age based, if >=1 it's just a flat amount.
		var/cost = (stamcost < 1) ? (L.max_stamina * stamcost) : stamcost
		return L.stamina_add(cost)
	else
		return TRUE

/datum/special_intent/proc/get_examine()
	var/str = "<details><summary><b>SPECIAL:</b> [name]</summary>"
	str +="<i>[desc]</i>"
	if(range)
		str += "\n<i>Max Range: ["\Roman [range]"]"
	str +="\n<i><font size = 1>This ability can be used by right clicking while in STRONG stance or by using the Special MMB.</font></i></details>"
	return str

///Called by external sources -- likely an rclick or mmb. By default the 'target' will be stored as a turf.
/datum/special_intent/proc/deploy(mob/living/user, atom/parent, atom/target)
	if(!isliving(user) && !ismovableatom(parent))
		CRASH("Special intent called with non-living parent AND non-movable atom source.")

	howner = user
	iparent = parent

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
	_add_log()
	_reset()
	_clear_grid()
	_assign_grid_indexes()
	_create_grid()
	on_create()
	_manage_grid()
	apply_cooldown(cooldown)

/// Completely indulgent proc cus I just want to see default process_attack() have no custom code
/datum/special_intent/proc/_add_log()
	if(howner && howner.ckey)
		howner.log_message(span_danger("Used the Special [name]."), LOG_ATTACK)
	else
		log_admin("[name] Special was deployed.")

/// Checks if the range & z levels are valid. Best handled by external sources just like the cost.
/// Really only usable with use_clickloc, as otherwise the Special will be anchored to the source on the same plane anyway.
/datum/special_intent/proc/check_range(atom/source, atom/target)
	if(range)
		if((get_dist(get_turf(source), get_turf(target)) > range) || source.z != target.z)
			to_chat(source, span_warning("It's too far!"))
			return FALSE
	return TRUE

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
	affected_turfs[0] = list()	//We always create a 0th index list for default-timer turfs.
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
		if(step && isturf(step) && !step.density)	//We try to avoid doing Specials in walls.
			var/list/timerlist
			if(dtimer)
				timerlist = affected_turfs[dtimer]
				timerlist.Add(step)
			else	//No custom timer, we just add it to the 0th index. Hopefully no one tries to add a custom timer of 0 SECONDS.
				timerlist = affected_turfs[0]
				timerlist.Add(step)

///More like manages gridS. Calls process on every made grid with the appropriate timer.
/datum/special_intent/proc/_manage_grid()
	if(!length(affected_turfs))	//Nothing to draw, but technically possible without being an error.
		return
	for(var/newdelay in affected_turfs)
		if(newdelay == 0)	//Default index without a custom delay, we process it immediately
			_process_grid(affected_turfs[0])
		else
			addtimer(CALLBACK(src, PROC_REF(_process_grid), affected_turfs[newdelay], newdelay), newdelay)

///Called to process the grid of turfs. The main proc that draws, delays and applies the post-delay effects.
/datum/special_intent/proc/_process_grid(list/turfs, newdelay)
	_draw(turfs, newdelay)
	pre_delay(turfs, newdelay)
	_delay(turfs, newdelay)

/datum/special_intent/proc/_draw(list/turfs, newdelay)
	for(var/turf/T in turfs)
		var/obj/effect/temp_visual/special_intent/fx = new (T, delay)
		fx.icon = _icon
		fx.icon_state = pre_icon_state
	
///Called after the affected_turfs list is populated, but before the grid is drawn.
/datum/special_intent/proc/on_create()

///Called after the grid has been drawn on every affected_turfs entry. The delay has not been initiated yet.
/datum/special_intent/proc/pre_delay(list/turfs, newdelay)
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
			addtimer(CALLBACK(src, PROC_REF(post_delay), turfs), delay)

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
	if(!length(turfs))	//Rare instance of there being 0 tiles without a custom timer.
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
///!This proc is inherently tied to iparent as a rogueweapon type! 
///!Do NOT use this for generic "magic" type of damage or if it's called from an obj like a trap!
/datum/special_intent/proc/apply_generic_weapon_damage(mob/living/target, dam, d_type, zone, bclass, no_pen = FALSE)
	if(!istype(iparent, /obj/item/rogueweapon))
		return
	var/obj/item/rogueweapon/W = iparent
	var/msg = "<font color = '#c2663c'>[name] strikes [target]!"
	if(ishuman(target))
		var/mob/living/carbon/human/HT = target
		var/obj/item/bodypart/affecting = HT.get_bodypart(zone)
		var/armor_block = HT.run_armor_check(zone, d_type, 0, damage = dam, used_weapon = W, armor_penetration = (no_pen ? -999 : 0))
		if(no_pen && armor_block)
			armor_block = 999
		if(HT.apply_damage(dam, W.damtype, affecting, armor_block))
			affecting.bodypart_attacked_by(bclass, dam, howner, armor = armor_block, crit_message = TRUE, weapon = W)
			msg += "<b> It pierces through to their flesh!</b>"
			playsound(HT, pick(W.hitsound), 80, TRUE)
	else
		target.attacked_by(W, howner)
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
	stamcost = 25
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
	var/statmod = max(howner.STASTR, howner.STASPD, howner.STAPER)	//It's a versatile weapon, so the scaling is versatile, too
	if(iparent)
		var/obj/item/rogueweapon/W = iparent
		dam = W.force * (statmod / 10)
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
		if(L != howner)
			L.apply_status_effect(/datum/status_effect/debuff/exposed, eff_dur)
			if(L.mobility_flags & MOBILITY_STAND)
				var/obj/item/rogueweapon/W = iparent
				apply_generic_weapon_damage(L, dam, W.d_type, t_zone, bclass = BCLASS_CUT)
	..()

/datum/special_intent/shin_swipe
	name = "Shin Prod"
	desc = "A hasty attack at the legs, extending ourselves. Slows down the opponent if hit."
	tile_coordinates = list(list(0,0), list(0,1))
	post_icon_state = "sweep_fx"
	pre_icon_state = "trap"
	sfx_post_delay = 'sound/combat/shin_swipe.ogg'
	delay = 0.5 SECONDS
	cooldown = 20 SECONDS
	stamcost = 15
	var/eff_dur = 5	//We do NOT want to use SECONDS macro here.
	var/dam

/datum/special_intent/shin_swipe/process_attack()
	var/obj/item/rogueweapon/W = iparent
	dam = W.force_dynamic * max((1 + (((howner.STASPD - 10) + (howner.STAPER - 10)) / 10)), 0.1)
	. = ..()


/datum/special_intent/shin_swipe/apply_hit(turf/T)	//This is applied PER tile, so we don't need to do a big check.
	for(var/mob/living/L in get_hearers_in_view(0, T))
		if(L != howner)
			L.Slowdown(eff_dur)
			L.apply_status_effect(/datum/status_effect/debuff/hobbled)	//-2 SPD for 8 seconds
			if(L.mobility_flags & MOBILITY_STAND)
				apply_generic_weapon_damage(L, dam, "stab", pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), bclass = BCLASS_CUT)
	..()

//Hard to hit, freezes you in place. Offbalances & slows the targets hit. If they're already offbalanced they get knocked down.
/datum/special_intent/ground_smash
	name = "Ground Smash"
	desc = "Swings downward, leaving a traveling quake for a few tiles. Anyone struck by it will be slowed and offbalanced, or knocked down if they're already off-balanced."
	tile_coordinates = list(list(0,0), list(0,1, 0.1 SECONDS), list(0,2, 0.2 SECONDS))
	post_icon_state = "kick_fx"
	pre_icon_state = "trap"
	respect_adjacency = TRUE
	delay = 0.7 SECONDS
	cooldown = 25 SECONDS
	stamcost = 25
	var/slow_dur = 5	//We do NOT want to use SECONDS macro here. Slowdown() takes in an int and turns it into seconds already.
	var/KD_dur = 2 SECONDS
	var/Offb_dur = 5 SECONDS
	var/self_immob_dur = 1.1 SECONDS
	var/dam = 200

//We play the pre-sfx here because it otherwise it gets played per tile. Sounds funky.
/datum/special_intent/ground_smash/on_create()
	. = ..()
	howner.Immobilize(self_immob_dur)
	playsound(howner, 'sound/combat/ground_smash_start.ogg', 100, TRUE)

/datum/special_intent/ground_smash/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		if(L != howner)
			//We fling the target sideways from the attacker
			var/targetdir = get_dir(L, howner)
			var/throwdir = turn(targetdir, prob(50) ? 90 : 270)
			var/dist = rand(1, 3)
			var/turf/current_turf = get_turf(L)
			var/turf/target_turf = get_ranged_target_turf(current_turf, throwdir, dist)
			L.safe_throw_at(target_turf, dist, 1, howner, force = MOVE_FORCE_EXTREMELY_STRONG)
			//We slow them down
			L.Slowdown(slow_dur)
			L.apply_status_effect(/datum/status_effect/debuff/exposed, 2.5 SECONDS)
			//We offbalance them OR knock them down if they're already offbalanced
			if(L.IsOffBalanced())
				L.Knockdown(KD_dur)
			else
				L.OffBalance(Offb_dur)
			apply_generic_weapon_damage(L, dam, "blunt", BODY_ZONE_CHEST, bclass = BCLASS_BLUNT, no_pen = TRUE)
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
	delay = 0.7 SECONDS
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
		if(L != howner)
			if(L.mobility_flags & MOBILITY_STAND)
				victim_count++
				addtimer(CALLBACK(src, PROC_REF(apply_effect), L), 0.1 SECONDS)	//We need to count them all up first so this is an unfortunate (& janky) requirement.
	..()																		//An alternative could be a spatial grid count from howner called once.

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
	apply_generic_weapon_damage(victim, dam * victim_count, "blunt", BODY_ZONE_CHEST, bclass = BCLASS_BLUNT, no_pen = TRUE)
	victim.safe_throw_at(throwtarget, CLAMP(1, 5, victim_count), 1, howner, force = MOVE_FORCE_EXTREMELY_STRONG)

#define AXE_SWING_GRID_DEFAULT 	list(list(-1,0), list(0,0, 0.2 SECONDS), list(1,0, 0.4 SECONDS))
#define AXE_SWING_GRID_MIRROR	list(list(-1,0, 0.4 SECONDS), list(0,0, 0.2 SECONDS), list(1,0))

/datum/special_intent/axe_swing
	name = "Hefty Swing"
	desc = "Swings from left to right. Anyone caught in the swing get immobilized and exposed."
	tile_coordinates = AXE_SWING_GRID_DEFAULT
	post_icon_state = "sweep_fx"
	pre_icon_state = "trap"
	use_doafter = TRUE
	respect_adjacency = FALSE
	delay = 0.5 SECONDS
	cooldown = 25 SECONDS
	stamcost = 15
	var/immob_dur = 3.5 SECONDS
	var/exposed_dur = 6 SECONDS
	var/dam

/datum/special_intent/axe_swing/_reset()
	. = ..()

/datum/special_intent/axe_swing/process_attack()
	tile_coordinates = list()
	var/obj/item/rogueweapon/W = iparent
	dam = (W.force_dynamic * (howner.STASTR / 10)) + 50
	if(howner.used_hand == 1)	//We mirror it if it's the left arm.
		tile_coordinates += AXE_SWING_GRID_MIRROR
	else
		tile_coordinates += AXE_SWING_GRID_DEFAULT //Initial() doesn't work with lists so we copy paste the original
	. = ..()

//We play the pre-sfx here because it otherwise it gets played per tile. Sounds funky.
/datum/special_intent/axe_swing/on_create()
	..()
	playsound(howner, 'sound/combat/rend_start.ogg', 100, TRUE)

/datum/special_intent/axe_swing/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		if(L != howner)
			L.apply_status_effect(/datum/status_effect/debuff/exposed, exposed_dur)
			L.Immobilize(immob_dur)
			if(L.mobility_flags & MOBILITY_STAND)
				apply_generic_weapon_damage(L, dam, "slash", pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), bclass = BCLASS_CHOP)
	var/sfx = pick('sound/combat/sp_axe_swing1.ogg','sound/combat/sp_axe_swing2.ogg','sound/combat/sp_axe_swing3.ogg')
	playsound(T, sfx, 100, TRUE)
	..()

#undef AXE_SWING_GRID_DEFAULT
#undef AXE_SWING_GRID_MIRROR

/datum/special_intent/whip_coil
	name = "Whip Coil"
	desc = "A long-range lash that coils around the ankles of the target, immobilizing them."
	tile_coordinates = list(list(0,0))	//Just one tile exactly where our cursor is.
	post_icon_state = "strike"
	pre_icon_state = "trap"
	sfx_pre_delay = 'sound/combat/sp_whip_start.ogg'
	respect_adjacency = FALSE
	use_clickloc = TRUE
	delay = 0.4 SECONDS
	cooldown = 15 SECONDS
	range = 4
	stamcost = 20	//Stamina cost
	var/immob_dur = 3.5 SECONDS
	var/dam = 30

/datum/special_intent/whip_coil/apply_hit(turf/T)
	var/whiffed = TRUE
	for(var/mob/living/L in get_hearers_in_view(0, T))
		if(L != howner)
			L.Immobilize(immob_dur)
			apply_generic_weapon_damage(L, dam, "slash", pick(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT), bclass = BCLASS_LASHING)
			whiffed = FALSE
	if(!whiffed)
		playsound(T, 'sound/combat/sp_whip_hit.ogg', 100, TRUE)
	else
		playsound(T, 'sound/combat/sp_whip_whiff.ogg', 100, TRUE)
	..()

#define GAREN_WAVE1 0.7 SECONDS
#define GAREN_WAVE2 1.4 SECONDS

/datum/special_intent/greatsword_swing
	name = "Great Swing"
	desc = "Swing your greatsword all around you in a ring of Judgement."
	tile_coordinates = list(
		list(0,0), list(1,0), list(1,-1),list(1,-2),list(0,-2),list(-1,-2),list(-1,-1),list(-1,0),\
		list(0,1, GAREN_WAVE1), list(1,1, GAREN_WAVE1), list(-1,1, GAREN_WAVE1),list(1,-3, GAREN_WAVE1),list(0,-3, GAREN_WAVE1),list(-1,-3, GAREN_WAVE1),list(-2,0, GAREN_WAVE1),list(-2,-1, GAREN_WAVE1),list(-2,-2, GAREN_WAVE1),list(2,0, GAREN_WAVE1),list(2,-1, GAREN_WAVE1),list(2,-2, GAREN_WAVE1),\
		list(0,0, GAREN_WAVE2), list(1,0, GAREN_WAVE2), list(1,-1, GAREN_WAVE2),list(1,-2, GAREN_WAVE2),list(0,-2, GAREN_WAVE2),list(-1,-2, GAREN_WAVE2),list(-1,-1, GAREN_WAVE2),list(-1,0, GAREN_WAVE2)
		)
	post_icon_state = "sweep_fx"
	pre_icon_state = "fx_trap_long"
	sfx_pre_delay = 'sound/combat/rend_hit.ogg'
	respect_adjacency = FALSE
	respect_dir = TRUE
	delay = 0.7 SECONDS
	cooldown = 30 SECONDS
	stamcost = 25	//Stamina cost
	var/dam = 60
	var/slow_dur = 2
	var/hitcount = 0
	var/self_debuffed = FALSE
	var/self_immob = 2.2 SECONDS
	var/self_clickcd = 2.1 SECONDS
	var/self_expose = 2.3 SECONDS

/datum/special_intent/greatsword_swing/_reset()
	hitcount = initial(hitcount)
	self_debuffed = initial(self_debuffed)
	. = ..()

//It's a bad idea to hook into _process_grid, but this is a ghetto way to check which "wave" we are at.
//As process grid is called for every set of tiles.
/datum/special_intent/greatsword_swing/_process_grid(list/turfs, newdelay)
	if(!self_debuffed)
		howner.Immobilize(self_immob) //we're committing
		howner.apply_status_effect(/datum/status_effect/debuff/exposed, self_expose)
		howner.apply_status_effect(/datum/status_effect/debuff/clickcd, self_clickcd)
		self_debuffed = TRUE
	hitcount++
	. = ..()

/datum/special_intent/greatsword_swing/post_delay(list/turfs)
	. = ..()
	playsound(howner, 'sound/combat/wooshes/bladed/wooshlarge (3).ogg', 100, TRUE)

/datum/special_intent/greatsword_swing/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		if(L != howner)
			L.Slowdown(slow_dur)
			if(L.mobility_flags & MOBILITY_STAND)
				var/hitdmg = dam
				switch(hitcount)
					if(2)
						hitdmg *= 1.5
					if(3)
						hitdmg *= 2
				apply_generic_weapon_damage(L, hitdmg, "slash", BODY_ZONE_CHEST, bclass = BCLASS_CUT)
				if(hitcount == 3)	//Last hit deals a bit of extra damage to integrity only. Facetanking it is highly discouraged!
					apply_generic_weapon_damage(L, (dam * 0.8), "slash", BODY_ZONE_CHEST, bclass = BCLASS_CUT, no_pen = TRUE)
			var/sfx = 'sound/combat/sp_gsword_hit.ogg'
			playsound(T, sfx, 100, TRUE)
	..()

#undef GAREN_WAVE1
#undef GAREN_WAVE2

/datum/special_intent/limbguard
	name = "Limb Guard"
	desc = "Raise your shield to protect a limb. You will deflect projectiles and anyone striking that limb will be severely penalized. \n\
		You cannot regain stamina while this is active. It can be cancelled by jumping, kicking or by using MMB again with the same shield out."
	respect_adjacency = FALSE
	cooldown = 60 SECONDS
	stamcost = 25

//apply_cost is called before anything else, so it works here for the toggle checks, but it's kind of a bad example -- don't do this.
/datum/special_intent/limbguard/apply_cost(mob/living/L)
	if(L.has_status_effect(/datum/status_effect/buff/clash) || L.toggle_timer > world.time)
		return FALSE
	var/datum/status_effect/buff/clash/limbguard/lg = L.has_status_effect(/datum/status_effect/buff/clash/limbguard)
	if(lg)
		lg.remove_self()
		return FALSE
	return ..()

//Complete override because the majority of the code is handled on the status effect.
/datum/special_intent/limbguard/process_attack()
	SHOULD_CALL_PARENT(FALSE)
	howner.apply_status_effect(/datum/status_effect/buff/clash/limbguard, check_zone(howner.zone_selected))
	howner.toggle_timer = world.time + howner.toggle_delay

//datum/status_effect/buff/clash/limbguard

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
tile_coordinates = list(list(1,1), list(-1,1), list(-1,-1), list(1,-1),list(0,0),
					list(-1,0,WAVE_2_DELAY), list(-2,0,WAVE_2_DELAY), list(0,0,WAVE_2_DELAY), list(1,0,WAVE_2_DELAY), list(2,0,WAVE_2_DELAY),
					list(0,0,WAVE_3_DELAY),list(0,-1,WAVE_3_DELAY),list(0,-2,WAVE_3_DELAY),list(0,1,WAVE_3_DELAY),list(0,2,WAVE_3_DELAY))
*/

//Example of a sweeping line from left to right from the clicked turf. The second tile and the line will only appear after 1.1 seconds (the first delay).
//tile_coordinates = list(list(0,0), list(1,0, 1.1 SECONDS), list(2,0, 1.2 SECONDS), list(3,0,1.3 SECONDS), list(4,0,1.4 SECONDS), list(5,0,1.5 SECONDS))

#undef WAVE_2_DELAY
#undef WAVE_3_DELAY
#undef SPECIAL_AOE_AROUND_ORIGIN
#undef CUSTOM_TIMER_INDEX
