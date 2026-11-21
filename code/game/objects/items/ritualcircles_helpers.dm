// Helpers for ritualcircles.dm: rite effects, Toll animation, effects and items.

/obj/structure/ritualcircle/necra/proc/undermaidenbargain(src)
	var/ritualtargets = view(7, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.apply_status_effect(/datum/status_effect/buff/undermaidenbargain)

/obj/structure/ritualcircle/necra/proc/thetoll(mob/living/carbon/human/target, mob/living/user)
	var/revive_pq = PQ_GAIN_REVIVE
	if(target.mob_biotypes & MOB_UNDEAD)
		var/choice
		if(user.real_name in GLOB.excommunicated_players)
			choice = tgui_alert(user, "[target]'s body rattles and seizes under the divine force. You may unmake them or blaspheme against the divine order to restore their soul. What is your choice?", "Divine Revival", list("Unmake Them", "Blaspheme and Revive", "Cancel"), 15 SECONDS)
			if(isnull(choice))
				to_chat(user, span_notice("The rite falters before a decision can be made."))
				return FALSE
			switch(choice)
				if("Unmake Them")
					to_chat(user, span_danger("You condemn [target] to Her gaze, and retribution comes swiftly..."))
					target.visible_message(span_danger("[target] is ravaged by wrathful spirits!"), span_userdanger("Holy power tears my undead form apart!"))
					playsound(target.loc, 'sound/magic/churn.ogg', 100, TRUE)
					target.gib(no_organs = TRUE)
					return TRUE
				if("Blaspheme and Revive")
					to_chat(user, span_warning("You conceal Necra's eyes from this, and attempt to restore [target]'s soul."))
				if("Cancel")
					to_chat(user, span_notice("You halt the rite."))
					return FALSE
		else
			choice = tgui_alert(user, "[target]'s body rattles and seizes under the divine force. This will likely unmake them permanently. Continue?", "Divine Revival", list("PURGE THE UNCLEAN!", "Stop"), 15 SECONDS)
			if(choice != "PURGE THE UNCLEAN!")
				to_chat(user, span_notice("You halt the rite before the divine force can fully take hold."))
				return FALSE
			target.visible_message(span_danger("[target] is ravaged by wrathful spirits!"), span_userdanger("Holy power tears my undead form apart!"))
			playsound(target.loc, 'sound/magic/churn.ogg', 100, TRUE)
			target.gib(no_organs = TRUE)
			return TRUE

	var/mob/dead/observer/underworld_spirit = target.get_spirit()
	var/choice = tgui_alert(underworld_spirit || target, "A Toll is being offered for your soul, BREAK FREE?", "Revival", list("I need to wake up", "Don't let me go"), 15 SECONDS)

	if(isnull(choice))
		target.visible_message(span_notice("The tetter falters as the soul is distracted."))
		return FALSE

	if(choice == "Don't let me go")
		target.visible_message(span_warning("The soul forcefully breaks the tetter, they don't wish to come back."))
		return FALSE

	target.adjustOxyLoss(-target.getOxyLoss()) // Ye Olde CPR
	if(!target.revive(full_heal = FALSE))
		to_chat(user, span_warning("Nothing happens."))
		return FALSE
	user.say("For this toll, a soul!!")
	target.remove_status_effect(/datum/status_effect/incapacitating/sleeping)
	if(target.eyesclosed)
		target.eyesclosed = 0
		target.cure_blind("eyelids")
	var/mob/living/carbon/human/H = target
	H.freakout_hud_skew()
	target.grab_ghost(force = TRUE)
	target.emote("superagony")
	target.Jitter(100)
	target.update_body()
	target.visible_message(span_notice("[target] jumps awake, looking around frenetically while screaming like a deranged madman!"), span_green("I BARELY MANAGED TO GET PAST OTHER DESPERATE SPIRITS TO MY EMPTY BODY... IT IS SO COLD!"))
	if(revive_pq && !HAS_TRAIT(target, TRAIT_IWASREVIVED) && user?.ckey)
		adjust_playerquality(revive_pq, user.ckey)
		ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
	target.mind.remove_antag_datum(/datum/antagonist/zombie)
	target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
	target.apply_status_effect(/datum/status_effect/debuff/revived)
	target.apply_status_effect(/datum/status_effect/buff/healing, 14)
	if(HAS_TRAIT(target, TRAIT_IRONMAN))
		target.apply_status_effect(/datum/status_effect/debuff/integrity_rig, 11 MINUTES)
		target.visible_message(span_danger("[target] is looking on the verge of exploding again! Their core may need an extra whack from a hammer."))
	target.add_stress(/datum/stressevent/necrarevive)
	src.coinslot -= 1
	user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
	return TRUE

/obj/structure/ritualcircle/necra/proc/dagger_screams(obj/item/dagger, timeout)
	set waitfor = FALSE
	var/end_time = world.time + timeout // safety net in case something runtimes mid-cutscene
	while(shatter_active && world.time < end_time)
		sleep(rand(15, 40))
		if(!shatter_active || QDELETED(dagger))
			return
		dagger.say(span_cult(pick(profane_soul_screams)))
		playsound(dagger, pick(profane_soul_sounds), 60, FALSE, -1)

/obj/structure/ritualcircle/necra/proc/shatter_the_binds_cutscene(mob/living/user, obj/item/rogueweapon/huntingknife/idagger/steel/profane/dagger, turf/runeturf)
	var/base_y = dagger.pixel_y
	user.visible_message(span_warning("[user] places the dagger in the center of the rune, drawing spectral strands of Lux up through the air!"))
	playsound(user, 'sound/vo/mobs/ghost/whisper (3).ogg', 100, FALSE, -1)
	if(!do_after(user, 10 SECONDS, target = src))
		return
	if(QDELETED(dagger) || get_turf(dagger) != runeturf)
		return
	playsound(user, 'sound/vo/mobs/ghost/whisper (1).ogg', 100, FALSE, -1)
	dagger.visible_message(span_warning("[dagger] is suddenly thrust up into the air! Nigh-invisible threads tear at it, beginning to bend the metal!"))
	dagger.say(span_artery("YOU! HoW DArE YOU--!"))
	animate(dagger, pixel_y = base_y + 16, time = 10, loop = -1, easing = SINE_EASING)
	animate(pixel_y = base_y + 10, time = 10, easing = SINE_EASING)
	if(!do_after(user, 10 SECONDS, target = src))
		return
	if(QDELETED(dagger) || get_turf(dagger) != runeturf)
		return
	playsound(user, 'sound/magic/soulsteal_2.ogg', 80, TRUE)
	dagger.say(span_artery("STOp thIS, rIGHT-- NOW!!"))
	animate(dagger, transform = turn(matrix(), 12), time = 3, loop = -1, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
	animate(transform = turn(matrix(), -12), time = 3, easing = SINE_EASING)
	if(!do_after(user, 5 SECONDS, target = src))
		return
	if(QDELETED(dagger) || get_turf(dagger) != runeturf)
		return
	dagger.visible_message(span_warning("[dagger] is CRUSHED and TWISTED! TERRIBLE SCREAMS sounds from within!"))
	playsound(user, 'sound/vo/mobs/ghost/death.ogg', 100, FALSE, -1)
	shatter_active = FALSE // silence the souls before they're released
	dagger.say(span_artery("NO! MAaaASTErrrR, I DON'T WAaaNT TO GooO!!--"))
	animate(dagger) // cancel the bob + wobble chains
	var/matrix/squashed = matrix().Scale(0.7, 1.25)
	animate(dagger, transform = turn(squashed, 25), pixel_x = -2, pixel_y = base_y + 14, time = 1, loop = -1)
	animate(transform = turn(squashed, -25), pixel_x = 2, time = 1)
	if(!do_after(user, 5 SECONDS, target = src))
		return
	if(QDELETED(dagger) || get_turf(dagger) != runeturf)
		return
	animate(dagger)
	animate(dagger, transform = matrix().Scale(0.1, 0.1), alpha = 0, pixel_x = 0, pixel_y = base_y + 14, time = 3, easing = BACK_EASING)
	sleep(3)
	icon_state = "necra_active"
	user.say("Undermaiden, may you deliver the restless unto eternal silence...") // change this to something better thanks // I got you fam ~ Kunai
	playsound(user.loc, 'sound/misc/carriage2.ogg', 80, TRUE)
	dagger.release_profane_souls(user)
	dagger.shatter_dagger()
	playsound(get_turf(src), 'sound/foley/breaksound.ogg', 80, TRUE)
	playsound(get_turf(src), 'sound/misc/lava_death.ogg', 100, TRUE)
	user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
	spawn(120)
		icon_state = "necra_chalky"

/obj/effect/necra_rift
	name = "rift in the veil"
	desc = "A tear between lyfe and death. Something looks back."
	icon = 'icons/effects/effects.dmi'
	icon_state = "bhole3"
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	alpha = 0
	color = "#8fa8c0"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/necra_rift/Initialize(mapload)
	. = ..()
	set_light(3, 1, "#8fa8c0")

/obj/effect/necra_soul
	name = "restless soul"
	desc = "A wailing, half-seen shape."
	icon = 'icons/mob/mob.dmi' // PLACEHOLDER: troque pelo sprite de fantasma que preferir
	icon_state = "ghost"       // PLACEHOLDER
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	alpha = 0
	color = "#b8d4ea"
	pixel_y = 6
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/float_y = 6

/obj/effect/necra_soul/proc/glide_to(turf/T, time)
	var/turf/old = get_turf(src)
	if(T && old && T != old)
		var/dx = (old.x - T.x) * world.icon_size
		var/dy = (old.y - T.y) * world.icon_size
		forceMove(T)
		pixel_x = dx
		pixel_y = dy + float_y
	animate(src, pixel_x = 0, pixel_y = float_y, alpha = 190, time = time, easing = SINE_EASING)

/obj/effect/necra_soul/proc/start_bob()
	animate(src, pixel_y = float_y + 4, time = 10, loop = -1, easing = SINE_EASING)
	animate(pixel_y = float_y, time = 10, easing = SINE_EASING)

/datum/necra_toll_anim
	var/obj/structure/ritualcircle/necra/rune
	var/mob/living/user
	var/mob/living/carbon/human/target
	var/obj/effect/necra_rift/rift
	var/list/souls = list()
	var/list/beams = list()
	var/releasing = FALSE
	var/resolving = FALSE
	var/beam_icon = 'icons/effects/beam.dmi'
	var/beam_state = "b_beam"
	var/tetter_icon = 'icons/effects/beam.dmi'
	var/tetter_state = "fishing_line"
	var/tetter_color = "#c300ff"

/datum/necra_toll_anim/New(obj/structure/ritualcircle/necra/rune, mob/living/user, mob/living/carbon/human/target)
	src.rune = rune
	src.user = user
	src.target = target
	QDEL_IN(src, 3 MINUTES)

/datum/necra_toll_anim/Destroy()
	for(var/K in beams.Copy())
		drop_beam(K)
	beams.Cut()
	for(var/obj/effect/necra_soul/S in souls)
		qdel(S)
	souls.Cut()
	QDEL_NULL(rift)
	rune = null
	user = null
	target = null
	return ..()

/datum/necra_toll_anim/proc/tether(atom/source, atom/dest)
	if(!source)
		return
	drop_beam(source)
	if(QDELETED(source) || QDELETED(dest))
		return
	beams[source] = source.Beam(dest, icon_state = beam_state, icon = beam_icon, time = 3 MINUTES)

/datum/necra_toll_anim/proc/drop_beam(atom/key)
	if(!key)
		return
	var/datum/beam/B = beams[key]
	beams -= key
	if(B && !QDELETED(B))
		qdel(B)

/datum/necra_toll_anim/proc/open_rift()
	if(QDELETED(rune))
		return
	rift = new /obj/effect/necra_rift(get_step(user, NORTH))
	rift.transform = matrix().Scale(0.2)
	animate(rift, alpha = 255, transform = matrix(), time = 10)
	tether(user, rift)

/datum/necra_toll_anim/proc/release_souls()
	set waitfor = FALSE
	if(QDELETED(rift) || QDELETED(target))
		return
	releasing = TRUE
	var/turf/rift_turf = get_turf(rift)
	var/list/spots = list()
	for(var/turf/T in view(3, target))
		if(!T.density)
			spots += T
	if(!length(spots))
		spots += get_turf(target)
	for(var/i in 1 to rand(4, 6))
		if(QDELETED(src) || QDELETED(rift))
			break
		var/turf/spot = pick(spots)
		if(length(spots) > 1)
			spots -= spot
		var/obj/effect/necra_soul/S = new(rift_turf)
		souls += S
		playsound(rift_turf, 'sound/vo/mobs/ghost/whisper (1).ogg', 50, FALSE, -1)
		S.glide_to(spot, 8)
		sleep(rand(3, 6))
	sleep(8)
	for(var/obj/effect/necra_soul/S in souls)
		S.start_bob()
	releasing = FALSE

/datum/necra_toll_anim/proc/abort()
	resolve(FALSE)

/datum/necra_toll_anim/proc/resolve(success)
	set waitfor = FALSE
	if(resolving)
		return
	resolving = TRUE
	while(releasing)
		if(QDELETED(src))
			return
		sleep(1)
	if(QDELETED(src))
		return
	if(success && length(souls) && !QDELETED(target))
		accept_soul()
		if(QDELETED(src))
			return
		sleep(10)
	if(length(souls))
		recall_souls(souls.Copy())
	if(QDELETED(src))
		return
	close_rift()

/datum/necra_toll_anim/proc/accept_soul()
	var/obj/effect/necra_soul/chosen = pick(souls)
	tether(chosen, target)
	for(var/obj/effect/necra_soul/S in souls)
		if(S != chosen)
			tether(S, user)
	var/turf/dest = get_turf(target)
	while(!QDELETED(chosen) && get_turf(chosen) != dest)
		if(QDELETED(src))
			return
		chosen.glide_to(get_step_towards(chosen, dest), 8)
		sleep(8)
	if(QDELETED(chosen))
		return
	drop_beam(chosen)
	souls -= chosen
	playsound(dest, 'sound/vo/mobs/ghost/moan (1).ogg', 60, FALSE, -1)
	animate(chosen, alpha = 0, transform = matrix().Scale(0.3), time = 8)
	QDEL_IN(chosen, 8)

/datum/necra_toll_anim/proc/recall_souls(list/pending)
	var/turf/rift_turf = get_turf(rift)
	if(!rift_turf)
		return
	for(var/obj/effect/necra_soul/S in pending)
		tether(S, rift)
	while(length(pending))
		if(QDELETED(src))
			return
		for(var/obj/effect/necra_soul/S in pending.Copy())
			if(QDELETED(S))
				pending -= S
				souls -= S
				continue
			if(get_turf(S) == rift_turf)
				drop_beam(S)
				pending -= S
				souls -= S
				animate(S, alpha = 0, transform = matrix().Scale(0.2), time = 5)
				QDEL_IN(S, 5)
				continue
			S.glide_to(get_step_towards(S, rift_turf), 5)
		sleep(5)
	sleep(5)

/datum/necra_toll_anim/proc/close_rift()
	drop_beam(user)
	if(rift)
		animate(rift, alpha = 0, transform = matrix().Scale(0.2), time = 10)
		sleep(10)
	qdel(src)

/obj/item/soulthread
	name = "lux-thread"
	desc = "An eerie, softly glowing thread. It hums faintly with something that was once not quite at rest."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "luxthread"
	var/strungtogether = 1
	var/max_threads = 8
	sellprice = 3
	grid_width = 32
	grid_height = 32
	w_class = WEIGHT_CLASS_TINY

/obj/item/soulthread/examine(mob/user)
	. = ..()
	. += "</br><span class='notice'>[strungtogether]/[max_threads] threads woven together.</span>"

/obj/item/soulthread/proc/process_total(total, mob/user)
	var/turf/T = get_turf(src)
	var/tolls_to_make = total - (total % max_threads)
	tolls_to_make /= max_threads
	var/remainder = total % max_threads
	if(user)
		to_chat(user, "<span class='purple'>The threads entangle ethereally in your grasp... ([total]/[max_threads])</span>")
	if(tolls_to_make)
		for(var/i = 1 to tolls_to_make)
			new /obj/item/thetoll(T)
		if(user)
			to_chat(user, "<span class='boldnotice'>The gathered threads bind together, forming a weeping toll!</span>")
	if(remainder)
		strungtogether = remainder
		sellprice = 3 * remainder
	else
		qdel(src)

/obj/item/soulthread/proc/merge_into(obj/item/soulthread/target, mob/user)
	if(target == src)
		return

	var/total = target.strungtogether + src.strungtogether
	target.process_total(total, user)
	qdel(src)

/obj/item/soulthread/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/soulthread))
		return ..()

	var/obj/item/soulthread/other = attacking_item
	merge_into(other, user)

/obj/item/soulthread/afterattack(atom/target, mob/user, proximity_flag, click_params)
	if(!proximity_flag)
		return

	var/turf/T = get_turf(target)
	if(!T)
		return
	for(var/obj/item/soulthread/other in T)
		if(!other)
			return

	to_chat(user, "<span class='notice'>You begin gathering the scattered threads...</span>")

	for(var/obj/item/soulthread/other in T)
		if(other == src)
			continue

		if(strungtogether >= max_threads)
			break

		if(!do_after(user, 0.5 SECONDS, TRUE, src))
			break

		if(!(other in T.contents))
			continue

		var/total = strungtogether + other.strungtogether
		qdel(other)
		process_total(total, user)

		if(QDELETED(src))
			return

/obj/item/thetoll
	grid_width = 32
	grid_height = 32
	name = "toll"
	desc = "A hollow token of strange metal that softly weeps blood, mysteriously formed when enough shimmering lux-threads are tangled together as an offering. It is said the Ferryman grants tolls to those who aid in its work, and claim them back in exchange for favors."
	icon = 'icons/roguetown/underworld/enigma_husks.dmi'
	icon_state = "soultoken"
	sellprice = 30
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.5
