GLOBAL_LIST_EMPTY(last_words)

/mob/living/gib(no_brain, no_organs, no_bodyparts, drop_items = FALSE, leave_gibs = TRUE)
	var/prev_lying = lying
	if(stat != DEAD)
		death(TRUE)
	if(client)
		SSdroning.kill_droning(client)
	playsound(src.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)

	if(!prev_lying)
		gib_animation()

	spill_embedded_objects()

	if(drop_items)
		unequip_everything()

	spill_organs(no_brain, no_organs, no_bodyparts)

	if(!no_bodyparts)
		spread_bodyparts(no_brain, no_organs)

	if (leave_gibs)
		spawn_gibs(no_bodyparts)
	qdel(src)

/mob/living/proc/gib_animation()
	return

/mob/living/proc/spawn_gibs()
	new /obj/effect/gibspawner/generic(drop_location(), src)

/mob/living/proc/spill_embedded_objects()
	for(var/obj/item/embedded_item as anything in simple_embedded_objects)
		simple_remove_embedded_object(embedded_item)

/mob/living/proc/spill_organs()
	return

/mob/living/proc/spread_bodyparts()
	return

/// Length of the animation in dust_animation.dmi
#define DUST_ANIMATION_TIME 1.3 SECONDS

/mob/living/dust(just_ash, drop_items, force)
	if(stat != DEAD)
		death(TRUE)

	spill_embedded_objects()

	if(drop_items)
		unequip_everything()

	if(buckled)
		buckled.unbuckle_mob(src, force = TRUE)

	dust_animation()
	addtimer(CALLBACK(src, PROC_REF(spawn_dust), just_ash), DUST_ANIMATION_TIME - 0.3 SECONDS)
	QDEL_IN(src, DUST_ANIMATION_TIME) // since this is sometimes called in the middle of movement, allow half a second for movement to finish, ghosting to happen and animation to play. Looks much nicer and doesn't cause multiple runtimes.

/// Animates turning into dust
/// Does not delete src afterwards, BUT it will become invisible (and grey), so ensure you handle that yourself
/atom/movable/proc/dust_animation(atom/anim_loc = src.loc)
	if(isnull(anim_loc)) // the effect breaks if we have a null loc
		return
	var/obj/effect/temp_visual/dust_animation_filter/dustfx = new(anim_loc, REF(src))
	add_filter("dust_animation", 1, displacement_map_filter(render_source = dustfx.render_target, size = 256))
	add_filter("dust_color", 1, color_matrix_filter())
	transition_filter("dust_color", color_matrix_filter(list(0.33,0.33,0.33,0, 0.59,0.59,0.59,0, 0.11,0.11,0.11,0, 0,0,0,1, 0,0,0,0)), DUST_ANIMATION_TIME - 0.3 SECONDS)
	animate(src, alpha = 0, time = DUST_ANIMATION_TIME - 0.1 SECONDS, easing = SINE_EASING | EASE_IN)

/// Holds the dust animation filter effect, so we can animate it
/obj/effect/temp_visual/dust_animation_filter
	icon = 'icons/mob/dust_animation.dmi'
	icon_state = "dust.1"
	duration = DUST_ANIMATION_TIME
	randomdir = FALSE

/obj/effect/temp_visual/dust_animation_filter/Initialize(mapload, anim_id = "random_default_anti_collision_text")
	. = ..()
	// we manually animate this, rather than just using an animated icon state or flick, to work around byond animated state memes
	// (normally, all animated icon states are synced to the same time, which would bad here)
	for(var/i in 2 to duration)
		animate(src, time = 1, icon_state = "dust.[i]", flags = ANIMATION_CONTINUE)
	render_target = "*dust-[anim_id]"

#undef DUST_ANIMATION_TIME

/mob/living/proc/spawn_dust(just_ash = FALSE)
	if(contract_spawned)
		return
	for(var/i in 1 to 3)
		new /obj/item/natural/ash(loc)



/mob/living/death(gibbed, nocutscene = FALSE)
	if(stat == DEAD)
		return FALSE

	if(blood_toll_bucket && !mind?.assigned_role && !client)
		record_round_statistic(blood_toll_bucket)

	set_stat(DEAD)
	unset_machine()
	timeofdeath = world.time
	tod = station_time_timestamp()

	for(var/obj/item/I in contents)
		I.on_mob_death(src, gibbed)

	GLOB.alive_mob_list -= src
	if(!gibbed)
		GLOB.dead_mob_list += src

	SSdroning.kill_rain(client)
	SSdroning.kill_loop(client)
	SSdroning.kill_droning(client)

	if(!nocutscene)
		playsound_local(src, 'sound/misc/deth.ogg', 100)

	set_drugginess(0)
	set_disgust(0)
	SetSleeping(0, 0)
	set_sunder(0)
	reset_perspective(null)
	reload_fullscreen()
	update_mob_action_buttons()
	update_damage_hud()
	update_health_hud()
	update_mobility()
	stop_pulling()

	. = ..()

	SEND_SIGNAL(src, COMSIG_LIVING_DEATH, gibbed)

	if(client)
		client.move_delay = initial(client.move_delay)

		if(!nocutscene)
			var/atom/movable/screen/gameover/hog/H = new()
			H.layer = SPLASHSCREEN_LAYER + 0.1
			client.screen += H
			H.Fade()
			addtimer(CALLBACK(H, TYPE_PROC_REF(/atom/movable/screen/gameover, Fade), TRUE), 100)

		mob_timers["lastdied"] = world.time
		add_client_colour(/datum/client_colour/monochrome)
		add_verb(client, GLOB.ghost_verbs)
		client.init_verbs()

		if(last_words)
			GLOB.last_words |= last_words

	for(var/s in ownedSoullinks)
		var/datum/soullink/S = s
		S.ownerDies(gibbed)

	for(var/s in sharedSoullinks)
		var/datum/soullink/S = s
		S.sharerDies(gibbed)

	if(!gibbed && !QDELETED(src) && rot_type)
		LoadComponent(rot_type)

	clear_typing_indicator()

	if(HAS_TRAIT(src, TRAIT_UNFORGIVABLE))
		return unforgivable_death()

	if(client && !contract_spawned && !gibbed)
		if(!mind?.has_antag_datum(/datum/antagonist/skeleton) && !HAS_TRAIT(src, TRAIT_SECONDLIFE) && !HAS_TRAIT(src, TRAIT_IWASROTCURED) && !HAS_TRAIT(src, TRAIT_UNFORGIVABLE))
			for(var/mob/living/player in GLOB.player_list)
				if(player.stat == DEAD)
					continue
				if(!HAS_TRAIT(player, TRAIT_DEATHSIGHT))
					continue
				var/locale = prepare_deathsight_message(player)
				if(player.patron?.type == /datum/patron/divine/necra)
					to_chat(player, span_warning("Veiled whispers herald the Undermaiden's attention towards [locale]."))
				else
					to_chat(player, span_warning("I feel the faint passage of disjointed life essence as it flees [locale]."))

	has_luxplate()

	return TRUE

/mob/living/proc/unforgivable_death()
	flash_fullscreen("redflash3")
	visible_message(span_danger("[src] explodes violently as they are unmade in unholy fire!"))
	for(var/mob/living/carbon/stresstarget in view(7, src))
		if(HAS_TRAIT(stresstarget, TRAIT_UNFORGIVABLE))
			continue
		if(HAS_TRAIT(stresstarget, TRAIT_INQUISITION))
			stresstarget.add_stress(/datum/stressevent/witnessvheslyninquis)
		else
			stresstarget.add_stress(/datum/stressevent/witnessvheslyn)
	for(var/mob/living/flame_victim in view(3, src))
		flame_victim.adjust_fire_stacks(8, /datum/status_effect/fire_handler/fire_stacks/vheslyn)
		flame_victim.ignite_mob()
		if(HAS_TRAIT(flame_victim, TRAIT_UNFORGIVABLE))
			to_chat(flame_victim, span_notice("you are set ablaze in <b>restoring fire!</b>"))
		else
			to_chat(flame_victim, span_userdanger("you are violently set ablaze in <b>unholy fire!</b>"))
	explosion(get_turf(src), heavy_impact_range = 0, light_impact_range = 1, flash_range = 2, smoke = FALSE, soundin = 'sound/misc/explode/incendiary (2).ogg')
	playsound(src, 'sound/magic/soulshot.ogg', 60, FALSE)
	gib()
	return TRUE

/mob/living/proc/has_luxplate()
	var/static/list/luxplate_results = list(/obj/item/ingot/component/zizo, /obj/item/ingot/component/matthios, /obj/item/ingot/component/baotha, /obj/item/ingot/component/graggar)
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	var/consumed = 0
	for(var/obj/item/I as anything in get_equipped_items())
		if(istype(I, /obj/item/rogueweapon))
			continue
		if(!(I.smeltresult in luxplate_results))
			continue
		qdel(I)
		new /obj/item/natural/ash(T)
		new /obj/item/natural/ash(T)
		consumed++

	if(!consumed)
		return FALSE

	var/list/pantheons = list(ALL_DIVINE_PATRONS, ALL_INHUMEN_PATRONS, OLD_GOD_PATRON)
	for(var/mob/living/witness in view(7, src))
		if(witness == src)
			continue
		var/same_pantheon = FALSE
		if((witness in GLOB.apostasy_players) || (witness in GLOB.cursed_players) || (witness in GLOB.excommunicated_players) || (witness in GLOB.heretical_players) || witness.job == "Wretch")
			same_pantheon = TRUE
		else
			for(var/list/pantheon as anything in pantheons)
				if((patron?.type in pantheon) && (witness.patron?.type in pantheon))
					same_pantheon = TRUE
					break
		if(same_pantheon)
			witness.apply_status_effect(/datum/status_effect/buff/recuperation)
			to_chat(witness, span_boldgreen("The departing essence washes over me, like a warm mantle..."))
		else
			witness.apply_status_effect(/datum/status_effect/debuff/luxplate_curse)
			to_chat(witness, span_boldred("The tearing essence lashes out at me. I feel cursed..."))

	if(HAS_TRAIT(src, TRAIT_DNR))
		visible_message(span_artery("[src]'s supernatural plating ruptures with a deafening shriek. A blinding surge of essence tears through [p_their()] body, ripping [p_their()] soul from its mortal vessel. Flesh blackens, bones crumble, and the entirety of [p_their()] remains is reduced to drifting ash."),
			span_artery("<i>The heraldry of my patron burns away, and with it, all that remains of me. My soul is claimed, my body surrendered. Let there be no grave for me, no remains to mourn. I have given everything, and I die a MARTYR to my beliefs!</i>"))
		dust(TRUE, TRUE)
	else
		visible_message(span_artery("[src]'s supernatural plating fractures violently, its pieces bursting apart as the essence sustaining [p_them()] escapes in a violent torrent. The heraldry of [p_their()] patron lies shattered alongside [p_their()] broken body."),
			span_artery("<i>The heraldry of my patron burns away, and with it, all that remains of my pride...</i>"))
	playsound(src, 'sound/magic/soulshot.ogg', 60, FALSE)
	playsound(src, 'sound/misc/lava_death.ogg', 100, FALSE)
	return TRUE

/mob/living/proc/prepare_deathsight_message(mob/observer)
	var/area/A = get_area(src)
	if(!A)
		return "an unknown locale, wreathed in enigmatic fog" // fallback if we can't find the area somehow?? -- This was not clear enough for me ICly that it's somewhere I shouldn't care about, now it should
	if(!A.deathsight_message)
		log_game("Deathsight: area [A.type] has no deathsight_message set. Death occurred at [AREACOORD(src)].")
		return generate_relative_deathsight(observer) // area is misconfigured; give the watcher a rough bearing instead of a broken message
	return A.deathsight_message

/mob/living/proc/generate_relative_deathsight(mob/observer)
	var/turf/death_turf = get_turf(src)
	var/turf/observer_turf = get_turf(observer)
	if(!death_turf || !observer_turf)
		return "an unknown locale, wreathed in enigmatic fog"

	var/list/parts = list()
	var/paces = round(get_dist(observer_turf, death_turf), 20) // nearest 20 paces, so the bearing stays imprecise
	var/dir_text = dir2text(get_dir(observer_turf, death_turf))
	if(paces <= 0)
		parts += "somewhere close at hand"
	else if(dir_text)
		parts += "roughly [paces] paces to the [dir_text]"
	else
		parts += "roughly [paces] paces away"

	var/zdiff = death_turf.z - observer_turf.z
	if(zdiff > 0)
		parts += "[zdiff] level\s above me"
	else if(zdiff < 0)
		parts += "[abs(zdiff)] level\s below me"

	return jointext(parts, ", ")
