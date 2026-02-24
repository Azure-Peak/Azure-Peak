/obj/effect/proc_holder/spell/invoked/ventriloquism
	name = "Ventriloquism"
	desc = "Throw one's voice into a object"
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "ventril"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 1
	no_early_release = TRUE
	associated_skill = /datum/skill/magic/holy
	recharge_time = 15 SECONDS
	
/obj/effect/proc_holder/spell/invoked/ventriloquism/cast(list/targets, mob/user = usr)
	if(isobj(targets[1]))
		var/obj/target = targets[1]
		var/input_message = input(usr, "What shall [target] say?", src) as null|text
		target.say("[input_message]")
		return TRUE
	revert_cast()
	return FALSE


/obj/effect/proc_holder/spell/invoked/mastersillusion
	name = "Set Decoy"
	desc = "Creates a body double of yourself and makes you invisible, after a delay your clone explodes into smoke."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "disguise"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 1
	no_early_release = TRUE
	movement_interrupt = FALSE
	chargedloop = /datum/looping_sound/invokeholy
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 30 SECONDS
	var/firstcast = TRUE
	var/icon/clone_icon

/obj/effect/proc_holder/spell/invoked/mastersillusion/cast(list/targets, mob/living/carbon/human/user = usr)
	if(firstcast)
		to_chat(user, span_italics("...Oh, oh, thy visage is so grand! Let us prepare it for tricks!"))
		clone_icon = get_flat_human_icon("[user.real_name] decoy", null, null, DUMMY_HUMAN_SLOT_MANIFEST, GLOB.cardinals, TRUE, user, TRUE) // We can only set our decoy icon once. This proc is sort of expensive on generation.
		firstcast = FALSE
		name = "Master's Illusion"
		to_chat(user, "There we are... Perfect.")
		revert_cast()
		return
	var/turf/T = get_turf(user)
	new /mob/living/simple_animal/hostile/rogue/xylixdouble(T, user, clone_icon)
	animate(user, alpha = 0, time = 0 SECONDS, easing = EASE_IN)
	user.mob_timers[MT_INVISIBILITY] = world.time + 7 SECONDS
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon/human, update_sneak_invis), TRUE), 7 SECONDS)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[user] fades back into view."), span_notice("You become visible again.")), 7 SECONDS)
	return TRUE

/mob/living/simple_animal/hostile/rogue/xylixdouble
	name = "Xylixian Double - You shouldnt be seeing this."
	desc = ""
	gender = NEUTER
	mob_biotypes = MOB_HUMANOID
	maxHealth = 20
	health = 20
	canparry = TRUE
	d_intent = INTENT_PARRY
	defprob = 50
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = TRUE
	loot = list(/obj/item/bomb/smoke/decoy)
	can_have_ai = FALSE
	AIStatus = AI_OFF
	ai_controller = /datum/ai_controller/mudcrab // doesnt really matter


/obj/item/bomb/smoke/decoy/Initialize()
	. = ..()
	playsound(loc, 'sound/magic/decoylaugh.ogg', 50)
	explode()

/mob/living/simple_animal/hostile/rogue/xylixdouble/Initialize(mapload, mob/living/carbon/human/copycat, icon/I)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal, death), TRUE), 7 SECONDS)
	icon = I
	name = copycat.name
	

/obj/effect/proc_holder/spell/invoked/mockery
	name = "Vicious Mockery"
	desc = "Mock your target, reducing their INT, SPD, STR and WIL for a time."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "mockery"
	releasedrain = 50
	associated_skill = /datum/skill/misc/music
	recharge_time = 2 MINUTES
	range = 7

/obj/effect/proc_holder/spell/invoked/mockery/cast(list/targets, mob/user = usr)
	playsound(get_turf(user), 'sound/magic/mockery.ogg', 40, FALSE)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target] shrugs off the mockery!"))
			return TRUE
		if(!target.can_hear()) // Vicious mockery requires people to be able to hear you.
			revert_cast()
			return FALSE
		target.apply_status_effect(/datum/status_effect/debuff/viciousmockery)
		SEND_SIGNAL(user, COMSIG_VICIOUSLY_MOCKED, target)
		record_round_statistic(STATS_PEOPLE_MOCKED)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/mockery/invocation(mob/user = usr)
	if(ishuman(user))
		switch(pick(1,2,3,4,5,6,7,8,9,10,11,12,13))
			if(1)
				user.say("Your mother was a Rous, and your father smelled of jacksberries!", forced = "spell")
			if(2)
				user.say("What are you going to do for a face when the Archdevil wants his arse back?!", forced = "spell")
			if(3)
				user.say("Wandought thine blades stand, much like thine loving parts!", forced = "spell")
			if(4)
				user.say("That's a face not even Eora could love!", forced = "spell")
			if(5)
				user.say("Your breath smells like raw butter and cheap beer!.", forced = "spell")
			if(6)
				user.say("I bite mine thumb, ser!", forced = "spell")
			if(7)
				user.say("But enough talk- have at thee!", forced = "spell")
			if(8)
				user.say("My grandmother fights better than you!", forced = "spell")
			if(9)
				user.say("Need you borrow mine spectacles? Come get them!", forced = "spell")
			if(10)
				user.say("How much sparring did it take to become this awful?!", forced = "spell")
			if(11)
				user.say("You may need a smith- for you seem ill-equipped for a battle of wits!", forced = "spell")
			if(12)
				user.say("Looks as if thou art PSY-DONE! No? Too soon? Alright.", forced = "spell")
			if(13)
				user.say("Ravox bring justice to your useless mentor, ser!", forced = "spell")

/datum/status_effect/debuff/viciousmockery
	id = "viciousmockery"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/viciousmockery
	duration = 600 // One minute
	effectedstats = list(STATKEY_STR = -1, STATKEY_SPD = -1,STATKEY_WIL = -1, STATKEY_INT = -3)

/atom/movable/screen/alert/status_effect/debuff/viciousmockery
	name = "Vicious Mockery"
	desc = "<span class='warning'>THAT ARROGANT BARD! ARGH!</span>\n"
	icon_state = "mockery"

/obj/effect/proc_holder/spell/self/xylixslip
	name = "Xylixian Slip"
	desc = "Jumps you up to 3 tiles away."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "slip"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 12 SECONDS
	devotion_cost = 30
	miracle = TRUE
	var/leap_dist = 4	//3 tiles (+1 to account for origin tile)
	var/static/list/sounds = list('sound/magic/xylix_slip1.ogg','sound/magic/xylix_slip2.ogg','sound/magic/xylix_slip3.ogg','sound/magic/xylix_slip4.ogg')

/obj/effect/proc_holder/spell/self/xylixslip/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = user

	if(H.IsImmobilized() || !(H.mobility_flags & MOBILITY_STAND))
		revert_cast()
		return FALSE

	if(H.IsOffBalanced())
		H.visible_message(span_warning("[H] loses their footing!"))
		var/turnangle = (prob(50) ? 270 : 90)
		var/turndir = turn(dir, turnangle)
		var/dist = rand(1, 2)
		var/current_turf = get_turf(H)
		var/target_turf = get_ranged_target_turf(current_turf, turndir, dist)
		H.throw_at(target_turf, dist, 1, H, TRUE)
		playsound(H,'sound/magic/xylix_slip_fail.ogg', 100)
		H.Knockdown(10)
		return TRUE
	else
		var/current_turf = get_turf(H)
		var/turf/target_turf = get_ranged_target_turf(current_turf, H.dir, leap_dist)
		H.visible_message(span_warning("[H] slips away!"))
		H.throw_at(target_turf, leap_dist, 1, H, TRUE)
		if(target_turf.landsound)
			playsound(target_turf, target_turf.landsound, 100, FALSE)
		H.emote("jump", forced = TRUE)
		H.OffBalance(8 SECONDS)
		if(prob(50))
			playsound(H, pick(sounds), 100, TRUE)
		return TRUE

/obj/effect/proc_holder/spell/targeted/touch/parlor_trick
	name = "Parlor Trick"
	desc = "Take the form of objects to make fools of them. R-Click to destroy, left click to copy objects. Use to take a form."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "parlor"
	clothes_req = FALSE
	chargedrain = 0
	chargetime = 2 SECONDS
	releasedrain = 5
	miracle = TRUE
	devotion_cost = 5
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	hand_path = /obj/item/melee/touch_attack/parlor_trick

/obj/item/melee/touch_attack/parlor_trick
	name = "parlor trick"
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#FFFFFF"
	slot_flags = ITEM_SLOT_BELT
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	var/can_use = 1
	var/obj/effect/dummy/parlor_trick/active_dummy = null
	var/saved_appearance = null

/obj/item/melee/touch_attack/parlor_trick/afterattack()
	return

/obj/item/melee/touch_attack/parlor_trick/Initialize(mapload)
	. = ..()
	var/obj/item/clothing/mask/cigarette/rollie/zig = /obj/item/clothing/mask/cigarette/rollie
	saved_appearance = initial(zig.appearance)

/obj/item/melee/touch_attack/parlor_trick/dropped()
	..()
	disrupt()

/obj/item/melee/touch_attack/parlor_trick/equipped()
	..()
	disrupt()

/obj/item/melee/touch_attack/parlor_trick/attack_self(mob/user)
	if (isturf(user.loc) || istype(user.loc, /obj/structure) || active_dummy)
		toggle(user)
	else
		to_chat(user, span_warning("You can't use [src] while inside something!"))

/obj/item/melee/touch_attack/parlor_trick/attack_obj(obj/item/interacting_with, mob/living/user, list/modifiers)
	make_copy(interacting_with, user)

/obj/item/melee/touch_attack/parlor_trick/attack_right(mob/user)
	qdel(src)

/obj/item/melee/touch_attack/parlor_trick/proc/make_copy(atom/target, mob/user)
	playsound(get_turf(src), 'sound/magic/decoylaugh.ogg', 20, TRUE, -6)
	to_chat(user, span_notice("Copied [target]."))
	var/obj/temp = new /obj()
	temp.appearance = target.appearance
	temp.layer = initial(target.layer)
	saved_appearance = temp.appearance

/obj/item/melee/touch_attack/parlor_trick/proc/check_sprite(atom/target)
	return icon_exists(target.icon, target.icon_state)

/obj/item/melee/touch_attack/parlor_trick/proc/toggle(mob/user)
	if(!can_use || !saved_appearance)
		return
	if(active_dummy)
		eject_all()
		playsound(get_turf(src), 'sound/magic/decoylaugh.ogg', 20, TRUE, -6)
		qdel(active_dummy)
		active_dummy = null
		to_chat(user, span_notice("You deactivate \the [src]."))
		new /obj/effect/temp_visual/gravpush(get_turf(src))
	else
		playsound(get_turf(src), 'sound/magic/decoylaugh.ogg', 20, TRUE, -6)
		var/obj/effect/dummy/parlor_trick/C = new/obj/effect/dummy/parlor_trick(user.drop_location())
		C.activate(user, saved_appearance, src)
		to_chat(user, span_notice("You activate \the [src]."))
		new /obj/effect/temp_visual/gravpush(get_turf(src))

/obj/item/melee/touch_attack/parlor_trick/proc/disrupt(delete_dummy = 1)
	if(active_dummy)
		for(var/mob/M in active_dummy)
			to_chat(M, span_danger("Your parlor trick wanes!"))
		new /obj/effect/temp_visual/gravpush(loc)
		eject_all()
		if(delete_dummy)
			qdel(active_dummy)
		active_dummy = null
		can_use = FALSE
		addtimer(VARSET_CALLBACK(src, can_use, TRUE), 5 SECONDS)

/obj/item/melee/touch_attack/parlor_trick/proc/eject_all()
	for(var/atom/movable/A in active_dummy)
		A.forceMove(active_dummy.loc)
		if(ismob(A))
			var/mob/M = A
			M.reset_perspective(null)

/obj/effect/dummy/parlor_trick
	name = ""
	desc = ""
	density = FALSE
	var/can_move = 0
	var/obj/item/melee/touch_attack/parlor_trick/master = null

/obj/effect/dummy/parlor_trick/proc/activate(mob/M, saved_appearance, obj/item/melee/touch_attack/parlor_trick/C)
	appearance = saved_appearance
	if(istype(M.buckled, /obj/vehicle))
		var/obj/vehicle/V = M.buckled
		V.unbuckle_mob(M, force = TRUE)
	M.forceMove(src)
	master = C
	master.active_dummy = src 


/obj/effect/dummy/parlor_trick/Destroy()
	if(master)
		master.disrupt(0)
		master = null
	return ..()

/obj/effect/dummy/parlor_trick/attackby()
	master.disrupt()

/obj/effect/dummy/parlor_trick/attack_hand()
	master.disrupt()

/obj/effect/proc_holder/spell/invoked/abscond
	name = "Abscond"
	desc = "Disappear in a flash of smoke! (With a range of 4 tiles)"
	releasedrain = 30
	warnie = "spellwarning"
	movement_interrupt = TRUE
	associated_skill = /datum/skill/magic/holy
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "abscond"
	chargedrain = 1
	chargetime = 0 SECONDS
	recharge_time = 60 SECONDS
	hide_charge_effect = TRUE
	gesture_required = FALSE // Slippery
	devotion_cost = 100
	miracle = TRUE
	var/area_of_effect = 1
	var/max_range = 4
	var/turf/destination_turf
	var/turf/user_turf
	var/mutable_appearance/tile_effect
	var/mutable_appearance/target_effect
	var/datum/looping_sound/invokeshadow/shadowloop
	var/static/list/sounds = list('sound/magic/xylix_slip1.ogg','sound/magic/xylix_slip2.ogg','sound/magic/xylix_slip3.ogg','sound/magic/xylix_slip4.ogg')

//Resets the tile and turf effects.
/obj/effect/proc_holder/spell/invoked/abscond/proc/reset(silent = FALSE)
	if(tile_effect && destination_turf)
		destination_turf.cut_overlay(tile_effect)
		qdel(tile_effect)
		destination_turf = null
	if(user_turf && target_effect)
		user_turf.cut_overlay(target_effect)
		qdel(target_effect)
		user_turf = null
	update_icon()

/obj/effect/proc_holder/spell/invoked/abscond/proc/check_path(turf/Tu, turf/Tt)
	var/dist = get_dist(Tt, Tu)
	var/last_dir
	var/turf/last_step
	if(Tu.z > Tt.z) 
		last_step = get_step_multiz(Tu, DOWN)
	else if(Tu.z < Tt.z)
		last_step = get_step_multiz(Tu, UP)
	else 
		last_step = locate(Tu.x, Tu.y, Tu.z)
	var/success = FALSE
	for(var/i = 0, i <= dist, i++)
		last_dir = get_dir(last_step, Tt)
		var/turf/Tstep = get_step(last_step, last_dir)
		if(!Tstep.density)
			success = TRUE
			var/list/contents = Tstep.GetAllContents()
			for(var/obj/structure/bars/B in contents)
				success = FALSE
				return success
			var/list/cont = Tstep.GetAllContents(/obj/structure/roguewindow)
			for(var/obj/structure/roguewindow/W in cont)
				if(W.climbable && !W.opacity)	//It's climbable and can be seen through
					success = TRUE
					continue
				else if(!W.climbable)
					success = FALSE
					return success
		else
			success = FALSE
			return success
		last_step = Tstep
	return success

//Successful teleport, complete reset.
/obj/effect/proc_holder/spell/invoked/abscond/proc/tp(mob/user)
	if(destination_turf)
		if(do_teleport(user, destination_turf, no_effects=TRUE))
			log_admin("[user.real_name]([key_name(user)] Shadowstepped from X:[user_turf.x] Y:[user_turf.y] Z:[user_turf.z] to X:[destination_turf.x] Y:[destination_turf.y] Z:[destination_turf.z] in area: [get_area(destination_turf)]")
			if(user.m_intent == MOVE_INTENT_SNEAK)
				playsound(user_turf, pick(sounds), 20, TRUE)
				playsound(destination_turf, pick(sounds), 20, TRUE)
			else
				playsound(user_turf, pick(sounds), 100, TRUE)
				playsound(destination_turf, pick(sounds), 100, TRUE)
			reset(silent = TRUE)

/obj/effect/proc_holder/spell/invoked/abscond/cast(list/targets, mob/user)
	var/turf/O = get_turf(user)
	var/turf/T = get_turf(targets[1])
	var/datum/effect_system/smoke_spread/S = new /datum/effect_system/smoke_spread/fast
	if(!istransparentturf(T))
		var/reason
		if(max_range >= get_dist(user, T) && !T.density)
			if(check_path(get_turf(user), T))	//We check for opaque turfs or non-climbable windows in the way via a simple pathfind.
				if(get_dist(user, T) < 2 && user.z == T.z)
					to_chat(user, span_info("Too close!"))
					revert_cast()
					return FALSE
				to_chat(user, span_info("I begin to slip away!"))
				lockon(T, user)
				if(do_after(user, 3 SECONDS))
					S.set_up(1, O)
					S.start()
					tp(user)
					return TRUE
				else
					reset(silent = TRUE)
					revert_cast()
				return FALSE
			else
				to_chat(user, span_info("The path is blocked!"))
				revert_cast()
				return FALSE
		else if(get_dist(user, T) > max_range)
			reason = "It's too far."
			revert_cast()
			return FALSE
		else if (T.density)
			reason = "It's a wall!"
			revert_cast()
			return FALSE
		to_chat(user, span_info("I cannot slip there! "+"[reason]"))
	else
		to_chat(user, span_info("I cannot slip there!"))
		revert_cast()
		return
	. = ..()

//Plays affects at target Turf
/obj/effect/proc_holder/spell/invoked/abscond/proc/lockon(turf/T, mob/user)
	if(user.m_intent == MOVE_INTENT_SNEAK)
		playsound(T, 'sound/magic/shadowstep_destination.ogg', 20, FALSE, 5)
	else
		playsound(T, 'sound/magic/shadowstep_destination.ogg', 100, FALSE, 5)
	tile_effect = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "mist", layer = 18)
	target_effect = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "mist", layer = 18)
	user_turf = get_turf(user)
	destination_turf = T
	user_turf.add_overlay(target_effect)
	destination_turf.add_overlay(tile_effect)

/obj/effect/proc_holder/spell/invoked/mimicry
	name = "Mimicry"
	desc = "Play a sound of your choice at the targeted location, you brilliant jester."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "mimicry"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 12 SECONDS
	devotion_cost = 30
	miracle = TRUE
	var/list/soundpick = list(
		"Angry Skeleton" = 'sound/vo/mobs/skel/skeleton_scream (1).ogg',
		"Armor Break" = 'sound/combat/armor_degrade1.ogg',
		"Attack Swing" = 'sound/combat/wooshes/bladed/wooshlarge (1).ogg',
		"Bell" = 'sound/misc/bell.ogg',
		"Bell Jingle" = 'sound/items/jinglebell1.ogg',
		"Broken Door" = 'sound/combat/hits/onwood/destroywalldoor.ogg',
		"Clap" = 'sound/vo/clap (1).ogg',
		"Clear Throat" = 'sound/vo/female/gen/clearthroat.ogg',
		"Defending" = 'sound/combat/clash_initiate.ogg',
		"Door Unlock" = 'sound/foley/doors/woodlock.ogg',
		"Explosion" = 'sound/magic/fireball.ogg',
		"Glass Shatter" = 'sound/combat/hits/onglass/glassbreak (2).ogg',
		"Goblin Jabber" = 'sound/vo/male/goblin/giggle (2).ogg',
		"Guard Houndstone" = 'sound/misc/garrisonscom.ogg',
		"Hallelujah" = 'sound/magic/hallelujah.ogg',
		"Howl" = 'sound/vo/mobs/wwolf/howl (1).ogg',
		"Jumping" = 'sound/vo/male/gen/jump.ogg',
		"Large Creecher Jump" = 'sound/vo/mobs/wwolf/jump (1).ogg',
		"Lockpick Click" = 'sound/items/pickbad.ogg',
		"Message" = 'sound/magic/message.ogg',
		"Psst" = 'sound/vo/psst.ogg',
		"Rat Chitter/SCOM" = 'sound/vo/mobs/rat/rat_life.ogg',
		"Relief" = 'sound/ddrelief.ogg',
		"Scream - Agony" = 'sound/vo/male/old/scream.ogg',
		"Scream - Rage" = 'sound/vo/female/gen/rage (1).ogg',
		"Skeleton Laugh" = 'sound/vo/mobs/skel/skeleton_laugh.ogg',
		"Snap Finger" = 'sound/foley/finger-snap.ogg',
		"Spider Chitter" = 'sound/vo/mobs/spider/idle (1).ogg',
		"Stress" = 'sound/ddstress.ogg',
		"Vicious Mockery" = 'sound/magic/mockery.ogg',
		"Volf Snarl" = 'sound/vo/mobs/vw/idle (1).ogg',
	)
	
/obj/effect/proc_holder/spell/invoked/mimicry/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1])
	var/pickedsound = input(user, "Choose a sound, my wise bureaucrat.", "Mimic Sound") as anything in soundpick
	if(!pickedsound)
		revert_cast()
		return FALSE
	if(T)
		new /obj/effect/temp_visual/soundping(T)
		playsound(T, soundpick[pickedsound], 100)
		return TRUE
	else
		to_chat(user, "<span class='warning'>The trick failed you poor fool.</span>")
		revert_cast()
		return FALSE

/obj/effect/proc_holder/spell/invoked/vendetta
	name = "Vendetta"
	desc = "Cast upon your foe a Vendetta, your battle will be dramatic. Both you and your opponent will clash more dramaically for the next two minutes."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "vendetta"
	releasedrain = 10
	chargedrain = 0
	chargetime = 1 SECONDS
	chargedloop = /datum/looping_sound/invokeholy
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 5 MINUTES
	devotion_cost = 50
	miracle = TRUE

/obj/effect/proc_holder/spell/invoked/vendetta/cast(list/targets, mob/living/user)
	var/atom/A = targets[1]
	if(!isliving(A))
		revert_cast()
		return FALSE
	var/mob/living/vendettatarget = A
	playsound(get_turf(vendettatarget), 'sound/combat/clash_struck.ogg', 80, TRUE, soundping = TRUE)
	if(vendettatarget != user)
		user.visible_message("[user] locks eyes with [vendettatarget].")
		to_chat(user, span_notice("I have formed a Vendetta against [vendettatarget], our battle shall be dramatic!"))
		to_chat(vendettatarget, span_notice("A Vendetta has been made agaisnt me and [user], our fight shall be dramatic!"))
		vendettatarget.apply_status_effect(/datum/status_effect/buff/vendetta)
		user.apply_status_effect(/datum/status_effect/buff/vendetta)
		if(istype(vendettatarget.patron, /datum/patron/inhumen)) // make the fight even more interesting
			vendettatarget.apply_status_effect(/datum/status_effect/buff/adrenaline_rush)
			user.apply_status_effect(/datum/status_effect/buff/adrenaline_rush)
		return TRUE
	else
		to_chat(user, span_notice("I sadly cannot have a Vendetta against myself."))
		revert_cast()
		return FALSE

/atom/movable/screen/alert/status_effect/buff/vendetta
	name = "Vendetta"
	desc = "I have a Vendetta! If both me and my opponent have a Vendetta when clashing, it will be far more dramatic!"
	icon_state = "buff"

/datum/status_effect/buff/vendetta
	id = "vendetta"
	alert_type = /atom/movable/screen/alert/status_effect/buff/vendetta
	duration = 3 MINUTES

/datum/status_effect/buff/vendetta/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_VENDETTA, MAGIC_TRAIT)

/datum/status_effect/buff/vendetta/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_VENDETTA, MAGIC_TRAIT)

/obj/effect/proc_holder/spell/invoked/tipscales
	name = "Tip Scales"
	desc = "Tip the Scales! Pick between Boon and Woe. Boon increases fortune from 1-3 and lets someone cheat at gambling, Woe decreases their mood and fortune by 1-3."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "tipscale"
	releasedrain = 10
	chargedrain = 0
	chargetime = 1 SECONDS
	range = 1
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	sound = 'sound/misc/letsgogambling.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 3 MINUTES
	devotion_cost = 50
	var/list/boonwoechoice = list(
		"Boon" = "Boon",
		"Woe" = "Woe",
		"Nevermind!" = "Nevermind"
	)
		
/obj/effect/proc_holder/spell/invoked/tipscales/cast(list/targets, mob/user = usr)
	if(!isliving(targets[1]))
		to_chat(usr, span_notice("You missed that one, try another!"))
		revert_cast()
		return FALSE
	else
		var/boonwoe = input(usr, "Boon or Woe, my poor fool?", "Boon/Woe") as anything in boonwoechoice
		if(boonwoe == "Nevermind")
			revert_cast()
			return FALSE
		if(boonwoe == "Boon")
			if(isliving(targets[1]))
				var/mob/living/target = targets[1]
				if(target.anti_magic_check(TRUE, TRUE))
					return FALSE
				target.apply_status_effect(/datum/status_effect/boon)
				to_chat(target, "<span class='warning'>The scales tipped, in your favor! How fortuitous.</span>")
				return TRUE
		if(boonwoe == "Woe")
			if(isliving(targets[1]))
				var/mob/living/target = targets[1]
				if(target.anti_magic_check(TRUE, TRUE))
					return FALSE
				target.apply_status_effect(/datum/status_effect/woe)
				to_chat(target, "<span class='warning'>That bastard, that fool! Oh whatever shall you do.</span>")
				return TRUE
		revert_cast()
		return FALSE
	
/datum/status_effect/boon
	id = "xylixboon"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/boon
	var/booneffect

/atom/movable/screen/alert/status_effect/boon
	name = "Xylix's Boon"
	desc = "The scales feel tipped in my favor! How lucky. (You can cheat in coinflips/dice by holding a coin/dice in your offhand, and then right clicking the coin/dice while an empty hand is active!)"
	icon_state = "asleep"
	
/datum/status_effect/boon/on_apply()
	. = ..()
	booneffect = rand(1,3)
	owner.change_stat(STATKEY_LCK, booneffect)
	ADD_TRAIT(owner, TRAIT_BLACKLEG, MAGIC_TRAIT)

/datum/status_effect/boon/on_remove()
	. = ..()
	owner.change_stat(STATKEY_LCK, -booneffect)
	REMOVE_TRAIT(owner, TRAIT_BLACKLEG, MAGIC_TRAIT)
	
/datum/status_effect/woe
	id = "xylixwoe"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/woe
	var/woeeffect

/atom/movable/screen/alert/status_effect/woe
	name = "Xylix's Woe"
	desc = "That damned fool has tipped the scales out of my favor, this day cannot get any worse..."
	icon_state = "asleep"
	
/datum/status_effect/woe/on_apply()
	. = ..()
	woeeffect = rand(-1,-3)
	owner.change_stat(STATKEY_LCK, woeeffect)
	ADD_TRAIT(owner, TRAIT_BAD_MOOD, MAGIC_TRAIT)

/datum/status_effect/woe/on_remove()
	. = ..()
	owner.change_stat(STATKEY_LCK, -woeeffect)
	REMOVE_TRAIT(owner, TRAIT_BAD_MOOD, MAGIC_TRAIT)
