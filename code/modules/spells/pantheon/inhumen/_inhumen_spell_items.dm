////////
//ZIZO//
////////

/obj/item/storage/magebag/zizo
	name = "enochian artificer's pouch"
	desc = "A pouch to carry handfuls of ingredients for summoning and alchemy. It has a hateful aura about it..."
	aura_color = "#ff3737"
	color = "#696969"	

/obj/item/storage/magebag/zizo/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, (TRAIT_CABAL), "BLESSED BAG")

/obj/item/melee/touch_attack/sans_undertale
	name = "enochian force"
	desc = "A coalesced mass of primordial arcyne force, shaped by will and a deeper knowledge of Enochian language. It can let you push, pull, slam or tear open localized leylines at a target."
	catchphrase = null
	possible_item_intents = list(/datum/intent/sans/push, /datum/intent/sans/pull, /datum/intent/sans/slam, /datum/intent/sans/blast)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#c774ee"
	aura_color = "#9ca4a8"
	associated_skill = /datum/skill/magic/holy
	experimental_inhand = FALSE
	wdefense = 5	
	var/cd_push = 0
	var/cd_pull = 0
	var/cd_slam = 0
	var/cd_blast = 0
	var/deleting = FALSE

/obj/item/melee/touch_attack/sans_undertale/attack_self()
	if(deleting)
		return
	deleting = TRUE
	qdel(src)

/obj/item/melee/touch_attack/sans_undertale/dropped(mob/user)
	..()
	if(deleting)
		return
	deleting = TRUE
	qdel(src)

/obj/item/melee/touch_attack/sans_undertale/Destroy()
	if(deleting)
		return ..()
	deleting = TRUE
	return ..()

/datum/intent/sans/push
	name = "push"
	icon_state = "inshove"
	no_attack = TRUE
	candodge = FALSE
	canparry = FALSE
	tranged = 1

/datum/intent/sans/pull
	name = "pull"
	icon_state = "ingrab"
	no_attack = TRUE
	candodge = FALSE
	canparry = FALSE
	tranged = 1

/datum/intent/sans/slam
	name = "slam"
	icon_state = "inpunish"
	no_attack = TRUE
	candodge = FALSE
	canparry = FALSE
	tranged = 1

/datum/intent/sans/blast
	name = "blast"
	icon_state = "insmoke"
	no_attack = TRUE
	candodge = FALSE
	canparry = FALSE
	tranged = 1

/obj/item/melee/touch_attack/sans_undertale/proc/get_cd(is_npc, push=0, pull=0, slam=0, blast=0)
	if(is_npc)
		return list(push=2 SECONDS, pull=2 SECONDS, slam=15 SECONDS, blast=30 SECONDS)
	else
		return list(push=45 SECONDS, pull=45 SECONDS, slam=120 SECONDS, blast=60 SECONDS)

/obj/item/melee/touch_attack/sans_undertale/afterattack(atom/target, mob/living/user, proximity)
	if(!isliving(target))
		return

	var/mob/living/L = target
	if(QDELETED(L))
		return

	var/is_npc = !L.client
	var/list/cds = get_cd(is_npc)

	switch(user.used_intent.type)

		// SHOVE (Repulse-style)
		if(/datum/intent/sans/push)
			if(world.time < cd_push)
				return

			var/list/thrown = list(L)

			for(var/am in thrown)
				var/atom/movable/AM = am
				if(AM == user || AM.anchored)
					continue

				var/turf/throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
				var/dist = get_dist(user, AM)

				if(dist <= 1)
					if(isliving(AM))
						var/mob/living/M = AM
						M.set_resting(TRUE, TRUE)
						M.adjustBruteLoss(20)
						to_chat(M, span_danger("You're slammed into the ground by [user]!"))
				else
					if(isliving(AM))
						var/mob/living/M = AM
						M.set_resting(TRUE, TRUE)
						to_chat(M, span_danger("You're violently repelled by [user]!"))

					AM.safe_throw_at(
						throwtarget,
						CLAMP(6 - (dist - 1), 3, 6),
						1,
						user,
						force = MOVE_FORCE_EXTREMELY_STRONG
					)

			user.visible_message(
				span_notice("[user] releases a violent wave of force, repelling [L]!"),
				span_notice("I violently shove [L] away.")
			)

			cd_push = world.time + cds["push"]


		// PULL (inverse repulse)
		if(/datum/intent/sans/pull)
			if(world.time < cd_pull)
				return

			var/list/thrown = list(L)

			for(var/am in thrown)
				var/atom/movable/AM = am
				if(AM == user || AM.anchored)
					continue

				var/turf/throwtarget = get_turf(user)
				var/dist = get_dist(user, AM)

				if(dist <= 1)
					if(isliving(AM))
						var/mob/living/M = AM
						M.set_resting(TRUE, TRUE)
						M.adjustBruteLoss(15)
						to_chat(M, span_danger("You're violently crushed into [user]!"))
				else
					if(isliving(AM))
						var/mob/living/M = AM
						M.set_resting(TRUE, TRUE)
						to_chat(M, span_danger("You're dragged toward [user] by unseen force!"))

					AM.safe_throw_at(
						throwtarget,
						CLAMP(6 - (dist - 1), 3, 6),
						1,
						user,
						force = MOVE_FORCE_EXTREMELY_STRONG
					)

			user.visible_message(
				span_notice("[user] clenches their hand, dragging [L] forward!"),
				span_notice("I pull [L] toward me.")
			)

			cd_pull = world.time + cds["pull"]
		// SLAM
		if(/datum/intent/sans/slam)
			if(world.time < cd_slam)
				to_chat(user, span_warning("The force is still stabilizing."))
				return

			do_slam(user, L)

			cd_slam = world.time + cds["slam"]

		// BLAST
		if(/datum/intent/sans/blast)
			if(world.time < cd_blast)
				to_chat(user, span_warning("The force is still stabilizing."))
				return

			do_blast(user, L)

			cd_blast = world.time + cds["blast"]

/obj/item/melee/touch_attack/sans_undertale/proc/do_slam(mob/living/user, mob/living/target)
	if(!target || QDELETED(target))
		return

	user.visible_message(
		span_userdanger("[user] clenches the air while muttering a dark chant..."),
		span_notice("I attempt to seize [target] with primordial arcyne force.")
	)

	var/mob/living/carbon/C = user
	var/use_rend = FALSE

	if(istype(C))
		var/obj/item/bodypart/chest = C.get_bodypart(BODY_ZONE_CHEST)
		if((chest && chest.skeletonized) && !target.client)
			use_rend = TRUE

	// === CONTESTED CHECK ===
	var/user_int = user.get_stat(STATKEY_INT)
	var/target_wil = target.get_stat(STATKEY_WIL)

	// add swing so it's not static
	var/user_roll = user_int + rand(-5, 5)
	var/target_roll = target_wil + rand(-5, 5)

	if(user_roll >= target_roll)
		// SUCCESS
		if(use_rend)
			target.apply_status_effect(/datum/status_effect/enochian_rend)
		else
			target.apply_status_effect(/datum/status_effect/slam_rage)

		user.visible_message(
			span_userdanger("[target] is seized by invisible force!"),
			span_notice("My will overpowers [target]!")
		)
	else
		// FAILURE (partial effect instead of nothing)
		target.apply_damage(rand(1, 25), BRUTE)

		user.visible_message(
			span_warning("[target] resists the grasp!"),
			span_notice("[target]'s will pushes back against mine!")
		)

	playsound(target.loc, 'sound/misc/murderbeast.ogg', 100, FALSE)

#define SLAM_FILTER "slam_rage"

/atom/movable/screen/alert/status_effect/slam_rage
	name = "Crushing Force"
	desc = "An unseen force is violently slamming you!"

/datum/status_effect/slam_rage
	id = "slam_rage"
	duration = 3 SECONDS
	tick_interval = 0.5 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/slam_rage

	var/outline_color = "#c774ee"
	var/slam_count = 0
	var/max_slams = 4

/datum/status_effect/slam_rage/on_apply()
	if(!isliving(owner))
		return FALSE

	var/mob/living/L = owner

	L.Immobilize(duration)

	L.add_filter(SLAM_FILTER, 2, list(
		"type" = "outline",
		"color" = outline_color,
		"alpha" = 200,
		"size" = 2
	))

	L.update_icon()

	to_chat(L, span_userdanger("An invisible force seizes me!"))

	return TRUE

/datum/status_effect/slam_rage/tick()
	if(!isliving(owner))
		return

	var/mob/living/L = owner
	L.Immobilize(8)

	if(slam_count >= max_slams)
		return
	slam_count++

	var/base_y = L.pixel_y

	// VIOLENT LIFT (fast, high)
	animate(L,
		pixel_y = base_y + 48,
		time = 0.08 SECONDS,
		easing = CUBIC_EASING
	)

	// BRUTAL SLAM (faster, harder)
	animate(L,
		pixel_y = base_y - 8,
		time = 0.06 SECONDS,
		easing = BOUNCE_EASING
	)

	L.flash_fullscreen("redflash3", 1)

	var/damage = 8 + (slam_count * 4)
	L.adjustBruteLoss(damage)

	playsound(L.loc, 'sound/combat/hits/onstone/wallhit.ogg', 80, TRUE)

	if(prob(50))
		L.emote("painscream")

	// FINAL IMPACT
	if(slam_count == max_slams)
		L.Knockdown(3 SECONDS)
		L.visible_message(
			span_userdanger("[L] is violently smashed into the ground!"),
			span_userdanger("The final impact crushes me into the floor!")
		)

/datum/status_effect/slam_rage/on_remove()
	if(isliving(owner))
		var/mob/living/L = owner

		L.remove_filter(SLAM_FILTER)

		animate(L, pixel_y = 0, time = 0.2 SECONDS)

		L.visible_message(
			span_danger("The unseen force releases [L]!"),
			span_notice("The crushing force finally relents.")
		)

#undef SLAM_FILTER

#define ENOCHIAN_FILTER "enochian_rend"

/atom/movable/screen/alert/status_effect/enochian_rend // only works on NPCs!
	name = "Enochian Rend"
	desc = "Invisible force grips and tears at my form!"

/datum/status_effect/enochian_rend
	id = "enochian_rend"
	duration = 5 SECONDS
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/enochian_rend

	var/outline_color = "#c774ee"
	var/limb_removed = FALSE

/datum/status_effect/enochian_rend/on_apply()
	if(!isliving(owner))
		return FALSE

	var/mob/living/L = owner

	L.Immobilize(duration)

	L.add_filter(ENOCHIAN_FILTER, 2, list(
		"type" = "outline",
		"color" = outline_color,
		"alpha" = 210,
		"size" = 2
	))

	L.update_icon()

	to_chat(L, span_userdanger("An unseen force seizes me, locking my body in place!"))

	animate(L, pixel_y = L.pixel_y + 12, time = 0.3 SECONDS, easing = SINE_EASING)

	return TRUE

/datum/status_effect/enochian_rend/tick()
	if(!isliving(owner))
		return

	var/mob/living/L = owner

	L.flash_fullscreen("redflash3", 1)
	L.adjustBruteLoss(12)

	if(!limb_removed && iscarbon(L))
		var/mob/living/carbon/C = L
		remove_limb(C)

/datum/status_effect/enochian_rend/on_remove()
	if(isliving(owner))
		var/mob/living/L = owner

		L.remove_filter(ENOCHIAN_FILTER)

		animate(L, pixel_y = 0, time = 0.3 SECONDS, easing = SINE_EASING)

		L.visible_message(
			span_danger("The unseen force releases [L]!"),
			span_notice("The pressure suddenly vanishes.")
		)

/datum/status_effect/enochian_rend/proc/remove_limb(mob/living/carbon/C)
	var/obj/item/bodypart/left_arm = C.get_bodypart(BODY_ZONE_L_ARM)
	var/obj/item/bodypart/right_arm = C.get_bodypart(BODY_ZONE_R_ARM)
	var/obj/item/bodypart/left_leg = C.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/right_leg = C.get_bodypart(BODY_ZONE_R_LEG)

	if(left_arm || right_arm)
		if(left_arm)
			C.visible_message(
				span_userdanger("[C]'s left arm is torn away by unseen force!"),
				span_userdanger("My left arm is ripped free!")
			)
			left_arm.dismember()

		if(right_arm)
			C.visible_message(
				span_userdanger("[C]'s right arm is torn away by unseen force!"),
				span_userdanger("My right arm is ripped free!")
			)
			right_arm.dismember()

		playsound(C.loc, 'sound/magic/repulse.ogg', 70, TRUE)
		return

	if(left_leg || right_leg)
		if(left_leg)
			C.visible_message(
				span_userdanger("[C]'s left leg is violently removed!"),
				span_userdanger("My left leg is torn away!")
			)
			left_leg.dismember()

		if(right_leg)
			C.visible_message(
				span_userdanger("[C]'s right leg is violently removed!"),
				span_userdanger("My right leg is torn away!")
			)
			right_leg.dismember()

		playsound(C.loc, 'sound/magic/repulse.ogg', 80, TRUE)
		return

	var/obj/item/bodypart/head = C.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		C.visible_message(
			span_userdanger("[C] is overwhelmed by crushing arcyne force!"),
			span_userdanger("The force around me spikes catastrophically!")
		)
		C.emote("agony")
		head.dismember()
		C.adjustBruteLoss(200)
		playsound(C.loc, 'sound/magic/repulse.ogg', 90, TRUE)

/datum/status_effect/enochian_rend/proc/remove_head(mob/living/carbon/C)
	var/obj/item/bodypart/head = C.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		C.visible_message(
			span_userdanger("[C] is overwhelmed by crushing force!"),
			span_userdanger("The force around me spikes catastrophically!")
		)

		head.dismember()
		C.adjustBruteLoss(200)

		playsound(C.loc, 'sound/magic/repulse.ogg', 90, TRUE)

#undef ENOCHIAN_FILTER

/obj/item/melee/touch_attack/sans_undertale/proc/do_blast(mob/living/user, mob/living/target)
	if(!target || QDELETED(target))
		return

	var/turf/center = get_turf(target)
	if(!center)
		return

	user.visible_message(
		span_danger("[user] tears open space as reality fractures around [target]!"),
		span_warning("I call forth converging voidstone annihilation.")
	)

	// pick axis directions
	var/dir_ns = pick(NORTH, SOUTH)
	var/dir_ew = pick(EAST, WEST)

	var/list/spawn_turfs = list()

	// get positions within 2 tiles
	var/turf/T1 = get_step(center, dir_ns)
	if(T1)
		T1 = get_step(T1, dir_ns)

	var/turf/T2 = get_step(center, dir_ew)
	if(T2)
		T2 = get_step(T2, dir_ew)

	if(T1) spawn_turfs += T1
	if(T2) spawn_turfs += T2

	// TELEGRAPH EFFECT
	for(var/turf/T in spawn_turfs)
		if(!T) continue
		var/obj/effect/temp_visual/tele = new /obj/effect/temp_visual(T)
		tele.icon = 'icons/effects/effects.dmi'
		tele.icon_state = "leylinerupture"
		tele.duration = 1 SECONDS

	// wait for telegraph
	sleep(1 SECONDS)

	// SPAWN OBELISKS
	for(var/turf/T in spawn_turfs)
		if(!T) continue

		var/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/O = new(T)

		O.stop_automated_movement = TRUE
		O.wander = FALSE

		spawn()
			if(QDELETED(O) || QDELETED(target))
				return

			O.face_atom(target)

			// charge delay before firing
			sleep(1 SECONDS)

			if(QDELETED(O) || QDELETED(target))
				return

			if(O.fire_laser())
				sleep(25)

			explosion(O.loc, 0, 0, 0, 0, FALSE, 0, 1, 0, 0)
			qdel(O)

/obj/item/rope/zizo
	name = "profane rope"
	desc = "A woven hemp rope. Useful for countless crafts, or to tie someone up in a pinch. It hums with a strong aura of hatred for this stagnant world."
	color = "#862626"
	aura_color = "#ff0000"
	smeltresult = /obj/item/ash

/obj/item/rope/zizo/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, (TRAIT_CABAL), "PROFANE ROPE")


// the zizo bitcoin dosh :tm:
/obj/item/ingot/aaslag_zizo
	name = "darkened slag"
	desc = "A mass of wrought avantyne, condensed and unusable, for one reason or another. It hums with a strong aura of hatred for this stagnant world."
	icon_state = "ancientslag"
	smeltresult = /obj/item/ingot/aaslag
	sellprice = 0
	aura_color = "#ff3737"
	color = "#634040"
	var/value = 1

/obj/item/ingot/aaslag_zizo/primed
	name = "volatile darkened slag"
	desc = "A mass of wriggling avantyne, condensed and usable. It hums with a strong aura of defiance for this stagnant world."
	color = "#ff0000"
	aura_color = "#ff8800"

/obj/item/ingot/aaslag_zizo/primed/attack_self(mob/living/user)
	if(!isliving(user))
		return

	var/holy = user.get_skill_level(/datum/skill/magic/holy)

	var/list/options = list() // idea here is mostly so Zizo and Matthios can have good feuds, one supporting the other

	if(holy >= SKILL_LEVEL_NOVICE) 
		options["Surgery Bag"] = /obj/item/storage/belt/rogue/surgery_bag
		options["Iron Anvil"] = /obj/machinery/anvil
		options["Forge"] = /obj/machinery/light/rogue/forge
		options["Water Bin"] = /obj/item/roguebin/water
	if(holy >= SKILL_LEVEL_APPRENTICE) 
		options["Operating Table"] = /obj/structure/table/optable
		options["Bronze Melter"] = /obj/machinery/light/rogue/smelter/bronze
		options["Iron Bloomery"] = /obj/machinery/light/rogue/smelter/hiron
		options["Serfstone"] = /obj/item/scomstone/bad	
	if(holy >= SKILL_LEVEL_JOURNEYMAN)
		options["Cooling Backpack"] = /obj/item/storage/backpack/rogue/artibackpack
		options["Purifier Waterskin"] = /obj/item/reagent_containers/glass/bottle/waterskin/purifier
		options["Engineering Wrench"] = /obj/item/contraption/linker
		options["SCOMStone"] = /obj/item/scomstone
	if(holy >= SKILL_LEVEL_EXPERT) 
		options["Drill"] = /obj/item/contraption/pick/drill
		options["Autosmither"] =  /obj/structure/autosmither
		options["Infernal Engine"] = /obj/structure/infernalengine
		options["Rouscker"] = /obj/item/contraption/hacker_doohickey // It hacks Stockpiles and SCOMs, TBD.

	if(!options.len)
		to_chat(user, span_warning("I lack the knowledge to shape this mass..."))
		return

	var/choice = input(user, "What shall be Artificed into existence?", src) as null|anything in options
	if(!choice)
		return

	// AGONIZING RITUAL
	to_chat(user, span_cultsmall("The slag writhes violently in my grasp..."))

	user.emote("agony")
	user.adjustBruteLoss(10)
	user.adjustFireLoss(5)

	if(!do_after(user, 50, src))
		return

	user.emote("agony")
	user.adjustBruteLoss(15)
	user.adjustFireLoss(10)

	// SPAWN LOCATION LOGIC
	var/turf/T = get_step(get_turf(user), user.dir)

	if(!T || T.density)
		T = get_turf(user)

	// fallback if blocked by dense object
	for(var/atom/A in T)
		if(A.density)
			T = get_turf(user)
			break

	// SPAWN RESULT
	var/typepath = options[choice]

	if(ispath(typepath, /obj))
		new typepath(T)

	to_chat(user, span_cultsmall("Reality buckles before Her design. Through a swirl of dust and sparks, the [choice] is forced into being."))

	qdel(src)

/obj/item/matthios_canister/zizo_corrosive
	name = "vial of corrosion"
	desc = "A writhing, unstable corrosive that hungrily seeks structure."
	current_color = "#1eff00"

/obj/item/matthios_canister/zizo_corrosive/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_CABAL))
		. += span_notice("A possessed acidic slime. Perfect for dealing with iron bars and blockades. Not so perfect to deal with anything else, for this is unfortunately possessed by a foul, stubborn spirit who bears a distinct grudge against bars.")

/obj/item/matthios_canister/zizo_corrosive/afterattack(atom/target, mob/living/user, proximity)
	if(!proximity)
		return

	if(istype(target, /obj/structure/bars))
		var/obj/structure/bars/B = target

		to_chat(user, span_necrosis("The corrosion eagerly devours the metal, and the spirit within the vial is set free..."))
		playsound(src.loc, 'sound/misc/lava_death.ogg', 100, TRUE)
		B.break_message = null
		B.obj_break()

		qdel(src)
		return
	else
		to_chat(user, span_necrosis("The vial's contents wriggle in disapproval... It wants only bars."))

	return ..()

// nothing really different from normal chalk here, just spooky aura color!
/obj/item/chalk/zizo
	name = "stick of corrupted chalk"
	desc = "A stark-white stick of chalk, possibly made from quicksilver but you can't confirm it. This one has an odd, necrotic aura about it..."
	aura_color = "#ff5c5c"

/obj/item/chalk/zizo/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_CABAL))
		. += span_artery("A mana-infused chalk conjured from your own blood, bone marrow and a minor Enochian enchant. The Cabal oft speak that this is how things were done back in the old days of sorcery.")

// this is a chalk for people without ritualist trait, used mostly for artificery and trolling mages
/obj/item/ritechalk_zizo
	name = "profane chalk"
	icon_state = "chalk"
	desc = "Simple white chalk made from dubious materials. A useful tool for rites. This one has an odd, necrotic aura about it..."
	icon = 'icons/roguetown/misc/rituals.dmi'
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = FALSE
	aura_color = "#ff3737"

/obj/item/ritechalk_zizo/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_CABAL))
		. += span_artery("Larger than its stick-like sibling, it helps concentrate more the essence of avantyne onto any rite you draw. Prying hands may suffer trying to keep this from your righteously-deserving ones.")
		. += span_warning("<b>Rune of Zizo:</b> While only the real devout can make use of it for armaments, this rune is known to appease your Dark Lady, and guarantee success on Lesser Work Rituos.")
		. += span_warning("<b>Rite of Profane Melding:</b> This rite allows you to recycle ancient corpses, skeletons, bones, organs and so on, into useful bits and pieces for Artificery.")
		. += span_warning("<b>Veil-Rending matrix:</b> The proper, progressive method to harvest useful materials from Leylines. Surrounding all the cardinals of a Leyline is required. On use, undergo a long, loud and painful ritual, attempting to extract the materials directly from it, destabilizing the natural formation permanently.")
		. += span_warning("<b>Great Work Rituos:</b> This rite attempts to forcefully tear out Lux from an unwilling subject. They must be crucified to a profane cross for this to work. Very painful and permanently scarring.")

/obj/item/ritechalk_zizo/attack_self(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_CABAL))
		to_chat(user, span_smallred("As you inspect it closer, the foreboding chalk ignites on your hand, crumbling to foul-smelling ashes..."))
		user.emote("pain")
		user.adjustFireLoss(5)
		user.adjust_fire_stacks(2)
		user.ignite_mob()
		qdel(src)
		return

	var/ritechoices = list()

 	// practically worthless without the RITUAL trait, but having people spam zizo runes for territory flexing is cool
	ritechoices+="Rune of ZIZO"

 	// used to convert various things, mainly ancient slag, into bronze or other useful things for artificery
	ritechoices+="Rite of Profane Melding"

	// used to sabotage leylines and get free mats out of them, including something that outright destroys the leyline but lets you use the following
	ritechoices+="Veil-Rending matrix" 

	// used to extract lux without medicine, pretty simple thing. traumatizes PCs, gibs NPCs
	ritechoices+="Great Work Rituos" 

	var/runeselection = input(user, "Which rune shall I inscribe?", src) as null|anything in ritechoices
	var/turf/step_turf = get_step(get_turf(user), user.dir)
	switch(runeselection)
		if("Rune of ZIZO")
			to_chat(user,span_cultsmall("I begin inscribing the rune of Her Knowledge..."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/zizo(step_turf)

		if("Rite of Profane Melding")
			to_chat(user,span_cultsmall("I begin inscribing the rune of Enochian melding sorcery..."))
			if(do_after(user, 40, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/profane/melding(step_turf)

		if("Veil-Rending matrix")
			to_chat(user,span_cultsmall("I begin inscribing the matrix that rends the veil and siphons from the Ley..."))
			if(do_after(user, 40, src)) 
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/profane/leyline(step_turf)

		if("Great Work Rituos")
			to_chat(user,span_cultsmall("I begin inscribing the runes in raw Enochian language... My fingers twist painfully during it. A replica of Her Great Work..."))
			if(do_after(user, 40, src)) 
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/profane/reaper(step_turf)

/obj/structure/ritualcircle/profane/melding
	name = "Profane Melding Circle"
	desc = "A malformed transmutation circle that holds a 'sweet', iron-like scent. Its purpose is unclear, but something about it feels profoundly heretical, beyond the inverted symbol of the Allfather."
	icon_state = "zizo_chalky"
	color = "#ff0000"
	var/stored_value = 0

/obj/structure/ritualcircle/profane/melding/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_CABAL))
		. += span_artery("A classic ritual circle of Enochian qualities. Plenty of buildings were raised from such a handy little thing. The Cabal has, however, taken this a step further, allowing me to recycle more things in the name of Progress.")
		. += span_cultsmall("[stored_value] motes of liquid hatred sloshes through this circle...")

/obj/structure/ritualcircle/profane/melding/proc/get_Z_item_value(obj/item/I)
	if(!I)
		return 0
	if(istype(I, /obj/item/ingot/aaslag_zizo))
		var/obj/item/ingot/aaslag_zizo/A = I
		return max(0, A.value)
	if(istype(I, /obj/effect/decal/remains) || istype(I, /obj/item/natural/bundle/bone) || istype(I, /obj/item/skull) || istype(I, /obj/item/natural/bone) || istype(I, /obj/item/grown/log/tree/small) || istype(I, /obj/item/natural/stone) || istype(I, /obj/item/natural/wood/plank) || istype(I, /obj/item/natural/stoneblock))
		return 1
	if(istype(I, /obj/item/rogueore) || istype(I, /obj/item/roguegem) || istype(I, /obj/item/ingot) || istype(I, /obj/item/natural/bone) || istype(I, /obj/item/organ) || istype(I, /obj/item/alch/viscera) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/steak))
		return 2
	if(istype(I, /obj/item/heart_blood_vial/filled) || istype(I, /obj/item/natural/bundle/bone/full))
		return 5
	if(istype(I, /obj/item/heart_blood_canister/filled))
		return 10
	if(istype(I, /obj/item/reagent_containers/lux_impure))
		return 50
	if(istype(I, /obj/item/reagent_containers/lux_moss) || istype(I, /obj/item/reagent_containers/lux))
		return 100

	return 0

/obj/structure/ritualcircle/profane/melding/attackby(obj/item/I, mob/living/user)
	if(!I || !user)
		return

	if((user.patron?.type) != /datum/patron/inhumen/zizo)
		to_chat(user, span_artery("Foreboding thing... I shouldn't mess with it."))
		return

	var/value = get_Z_item_value(I)
	if(value <= 0)
		return

	to_chat(user, span_artery("I begin feeding the circle..."))

	if(!do_after(user, 20, src))
		return

	if(QDELETED(I))
		return

	stored_value += value
	visible_message("Hooked avantyne chains spring out and latch on the [I], absorbing it into the circle...")
	to_chat(user, span_artery("+[value] liquid hatred added. ([stored_value] motes of liquid hatred in the circle.)"))

	playsound(src, 'sound/misc/smelter_sound.ogg', 50, FALSE)

	qdel(I)

/obj/structure/ritualcircle/profane/melding/attack_hand(mob/living/user)
	if(!..())
		return

	if((user.patron?.type) != /datum/patron/inhumen/zizo)
		to_chat(user, span_smallred("This rite is not meant for me..."))
		return

	// bleeding check (simplified)
	var/has_bleeding = FALSE
	for(var/mob/living/carbon/C in view(1, src))
		if(C.bleed_rate)
			has_bleeding = TRUE
			break

	if(!has_bleeding)
		to_chat(user, span_warning("The circle remains inert. It demands fresh blood from bleeding wounds."))
		return

	var/list/choices = list(
		"Meld Corpse",
		"Meld Materials",
		"Shape Molten Avantyne",
		"Create Avantyne Slag"
	)

	var/selection = input(user, "Choose rite", src) as null|anything in choices
	if(!selection)
		return

	switch(selection)
		if("Meld Corpse")
			meld_corpse(user)

		if("Meld Materials")
			meld_materials(user)

		if("Shape Molten Avantyne")
			shape_avantyne(user)

		if("Create Avantyne Slag")
			create_slag(user)

/obj/structure/ritualcircle/profane/melding/proc/meld_corpse(mob/living/user)
	var/turf/T = get_turf(src)
	if(!T)
		return

	var/list/valid_bodies = list()

	// COLLECT VALID CORPSES
	for(var/mob/living/carbon/C in T)
		if(C.stat != DEAD)
			continue

		if(!C.client || C.mind?.has_antag_datum(/datum/antagonist/skeleton))
			valid_bodies |= C

	if(!valid_bodies.len)
		to_chat(user, span_warning("A corpse is required, the condition departed, rotting or decrepit."))
		return

	if(!execute_rite(src, user, 10, 3, TRUE))
		return

	var/gained = 0

	// DUST CORPSES FIRST (drops items)
	for(var/mob/living/carbon/C in valid_bodies)
		if(QDELETED(C))
			continue

		C.dust(drop_items = TRUE)
		gained += 5

	// PROCESS DROPPED GEAR
	for(var/obj/item/I in T)
		if(QDELETED(I))
			continue

		if(I.smeltresult == /obj/item/ingot/iron || I.smeltresult == /obj/item/ingot/bronze || I.smeltresult == /obj/item/ingot/aaslag)
			gained += 1
			qdel(I)

	stored_value += gained

	visible_message("Hooked avantyne chains spring out and latch on the remains, as they soon disintegrate...")
	to_chat(user, span_artery("+[gained] liquid hatred added. ([stored_value] motes of liquid hatred in the circle.)"))

/obj/structure/ritualcircle/profane/melding/proc/meld_materials(mob/living/user)
	var/turf/T = get_turf(src)
	if(!T)
		return

	var/list/valid_items = list()

	// COLLECT VALID ITEMS
	for(var/obj/item/I in T)
		if(QDELETED(I))
			continue

		var/value = get_Z_item_value(I)
		if(value > 0)
			valid_items[I] = value // store value to avoid recalculating

	if(!valid_items.len)
		to_chat(user, span_warning("The circle finds nothing of value to consume."))
		return

	if(!execute_rite(src, user, 10, 3, TRUE))
		return

	var/gained = 0

	// PROCESS ITEMS
	for(var/obj/item/I in valid_items)
		if(QDELETED(I))
			continue

		var/value = valid_items[I]
		gained += value
		qdel(I)

	stored_value += gained

	visible_message("Hooked avantyne chains spring out and latch on the materials, as they soon disintegrate...")
	to_chat(user, span_artery("+[gained] liquid hatred added. ([stored_value] motes of liquid hatred in the circle.)"))

/obj/structure/ritualcircle/profane/melding/proc/shape_avantyne(mob/living/user)
	if(stored_value == 0)
		to_chat(user, span_warning("The circle lacks substance."))
		return

	var/miracle = max(1, user.get_skill_level(/datum/skill/magic/holy))
	var/turf/T = get_turf(src)
	if(!T)
		return

	var/list/options = list("Woods", "Stones", "Primed Avantyne Slag")
	var/choice = input(user, "Shape what?", src) as null|anything in options
	if(!choice)
		return

	if(choice == "Woods" || choice == "Stones")

		var/form = input(user, "Natural or processed?", src) as null|anything in list("Natural", "Processed")
		if(!form)
			return

		var/amount = round(input(user, "How many units do you want to conjure?", src) as num|null)
		if(!amount || amount <= 0)
			return

		var/max_amount = miracle * 5

		if(amount > stored_value)
			to_chat(user, span_warning("The circle cannot supply that much with its current liquid hatred..."))
			return

		if(amount > max_amount)
			to_chat(user, span_warning("I cannot shape that much at once. I lack a deeper faith to HER..."))
			return

		for(var/i = 1 to amount)
			if(choice == "Woods")
				if(form == "Natural")
					new /obj/item/grown/log/tree/small(T)
				else
					new /obj/item/natural/wood/plank(T)
			else
				if(form == "Natural")
					new /obj/item/natural/stone(T)
				else
					new /obj/item/natural/stoneblock(T)

		stored_value -= amount

		to_chat(user, span_cultsmall("I shape [amount] units of [lowertext(form)] [lowertext(choice)]. Remaining liquid hatred: [stored_value]."))
		return

	// slag branch
	if(choice == "Primed Avantyne Slag")
		var/cost = 100

		if(stored_value < cost)
			to_chat(user, span_warning("Insufficient value."))
			return

		if(miracle < 3)
			to_chat(user, span_warning("This form is beyond my capability."))
			return

		if(!execute_rite_lesser(src, user, 2, TRUE))
			return

		stored_value -= cost
		new /obj/item/ingot/aaslag_zizo/primed(T)

		to_chat(user, span_cultsmall("The mass condenses into a volatile slag, ready to be used. Remaining liquid hatred: [stored_value]."))

/obj/structure/ritualcircle/profane/melding/proc/create_slag(mob/living/user)
	if(stored_value <= 0)
		to_chat(user, span_warning("Nothing to extract."))
		return

	var/turf/T = get_turf(src)
	if(!T)
		return

	if(!do_after(user, 50, src))
		return

	playsound(src, 'sound/magic/swap.ogg', 60, TRUE)

	var/obj/item/ingot/aaslag_zizo/A = new(T)
	A.value = stored_value

	to_chat(user, span_artery("I condense [stored_value] motes of liquid hatred into a single slag."))

	stored_value = 0

/obj/structure/ritualcircle/profane/leyline
	name = "Veilrender Matrix"
	desc = "A jagged geometric matrix barely holding itself together, warped by heretical design. Its words defy comprehension, but to those attuned to Arcyne, it's as if the very world wants it gone."
	icon_state = "zizo_chalky"
	color = "#00eeff"
	layer = 1
	var/active = FALSE

/obj/structure/ritualcircle/profane/leyline/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_CABAL))
		. += span_artery("An advanced Artificery matrix, enhanced by Enochian language. For those backward mages, having to expose oneself to harm's way is part of the procedure, but for a Cabalist? Another's job, not theirs.")

/obj/structure/ritualcircle/profane/leyline/attack_hand(mob/living/user)
	active = TRUE
	if(!..())
		active = FALSE
		return

	if((user.patron?.type) != /datum/patron/inhumen/zizo)
		to_chat(user, span_smallred("I cannot comprehend this structure's purpose... I feel a horrible sensation upon me."))
		active = FALSE
		return

	var/turf/T = get_turf(src)
	if(!T)
		active = FALSE
		return

	var/obj/structure/leyline/L = locate() in T

	if(!L || L.sabotaged)
		to_chat(user, span_warning("The rite demands a pure leyline. This one has already been reaped—or the circle is misplaced."))
		active = FALSE
		return

	// RITUAL EXECUTION
	if(!execute_rite(src, user, 5, 3))
		active = FALSE
		return

	playsound(src, 'sound/magic/swap.ogg', 60, TRUE)

	// APPLY SABOTAGE
	L.apply_sabotage()

	// GACHA TABLE
	var/list/loot_table = list(
		/obj/item/magic/infernal/ash = 40,
		/obj/item/magic/infernal/fang = 25,
		/obj/item/magic/infernal/core = 10,
		/obj/item/magic/infernal/flame = 2,

		/obj/item/magic/fae/fairydust = 40,
		/obj/item/magic/fae/iridescentscale = 25,
		/obj/item/magic/fae/heartwoodcore = 10,
		/obj/item/magic/fae/sylvanessence = 2,

		/obj/item/magic/elemental/mote = 40,
		/obj/item/magic/elemental/shard = 25,
		/obj/item/magic/elemental/fragment = 10,
		/obj/item/magic/elemental/relic = 2
	)

	// LOOT ROLLS
	for(var/i = 1 to 12)
		var/typepath = pickweight(loot_table)
		if(typepath)
			new typepath(T)

	visible_message(
		span_artery("The leyline shrieks as it is violently unraveled, spilling raw essence into reality!"),
		null,
		"<i>You hear a piercing, unnatural scream tear through the air! The world suffers...</i>"
	)
	active = FALSE

/obj/structure/ritualcircle/profane/reaper
	name = "Great Work Rituos circle"
	desc = "A transmutation circle coated in a bubbling, acidic sheen. The material resembles the acid pools of the Underdark. The heretical symbol feels like an open mockery to all that is righteous."
	icon_state = "zizo_chalky"
	color = "#00ff15"

/obj/structure/ritualcircle/profane/reaper/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_CABAL))
		. += span_artery("A strong reason to believe ZIZO is no myth, for this combined matrix and ritual circle completely written in advanced Enochian is but a thousand steps behind what SHE had attempted, and the heavy cost it took to achieve it. While only but a replica of her Great Work, it still does the trick on the matters of Lux extraction.")

/obj/structure/ritualcircle/profane/reaper/attack_hand(mob/living/user)
	if(!..())
		return

	if((user.patron?.type) != /datum/patron/inhumen/zizo)
		to_chat(user, span_smallred("This rite is not meant for me..."))
		return

	var/turf/T = get_turf(src)
	if(!T)
		return

	// ACTIVATION REQS
	var/has_bleeding = FALSE
	for(var/mob/living/carbon/C in view(1, src))
		if(C.bleed_rate)
			has_bleeding = TRUE
			break

	// Count blood resources on tile
	var/vial_count = 0
	var/canister_count = 0
	var/list/consumables = list()

	for(var/obj/item/I in T)
		if(istype(I, /obj/item/heart_blood_vial/filled))
			vial_count++
			consumables += I
		else if(istype(I, /obj/item/heart_blood_canister/filled))
			canister_count++
			consumables += I

	var/has_blood_cost = (canister_count >= 2) || (vial_count >= 6)

	if(!has_bleeding && !has_blood_cost)
		to_chat(user, span_warning("The rite demands either a cut wound's fresh blood, or the blood of a heartbeast."))
		return

	// TARGET COLLECTION
	var/list/valid_targets = list()

	for(var/obj/structure/fluff/psycross/zizocross/C in view(3, src))
		if(!C.buckled_mobs || !C.buckled_mobs.len)
			continue

		for(var/mob/living/L in C.buckled_mobs)
			if(QDELETED(L))
				continue
			valid_targets |= L // avoid duplicates

	if(!valid_targets.len)
		to_chat(user, span_warning("The rite demands subjects bound to profane crosses."))
		return

	// CONSUME BLOOD (if needed)
	if(!has_bleeding)
		var/needed_vials = 6
		var/needed_canisters = 2

		// Prefer canisters first (stronger)
		for(var/obj/item/heart_blood_canister/filled/C in consumables)
			if(needed_canisters <= 0)
				break
			qdel(C)
			needed_canisters--

		// If still missing, consume vials
		if(needed_canisters > 0)
			for(var/obj/item/heart_blood_vial/filled/V in consumables)
				if(needed_vials <= 0)
					break
				qdel(V)
				needed_vials--

		playsound(src, 'sound/misc/smelter_sound.ogg', 50, FALSE)

	// RITUAL EXECUTION
	to_chat(user, span_cultsmall("I begin invoking the Great Work... Yet far beneath Her true design."))

	if(!execute_rite(src, user, 10, 5, TRUE))
		return

	playsound(src, 'sound/magic/swap.ogg', 70, TRUE)

	for(var/mob/living/L in valid_targets)
		if(QDELETED(L))
			continue
		
		if (!L.has_status_effect(/datum/status_effect/buff/ozium))
			L.emote("agony")
		if (L.has_status_effect(/datum/status_effect/debuff/devitalised))
			L.emote("painscream")
			continue
		if(!L.client)
			L.gib(TRUE, TRUE, FALSE)
		
		var/apply_greater
		if (istype(L, /mob/living/carbon/human) && !(HAS_TRAIT(L, TRAIT_FEYTOUCHED) || HAS_TRAIT(L, TRAIT_DEATHLESS || HAS_TRAIT(L, TRAIT_FAKEDEATH)) ))
			new /obj/item/reagent_containers/lux(L.loc)
			apply_greater = TRUE
		else if (HAS_TRAIT(L, TRAIT_FEYTOUCHED))
			new /obj/item/reagent_containers/lux_moss(L.loc)
		else
			new /obj/item/reagent_containers/lux_impure(L.loc)

		SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, L)
		record_round_statistic(STATS_LUX_HARVESTED)
		L.apply_status_effect((apply_greater ? /datum/status_effect/debuff/devitalised/greater : /datum/status_effect/debuff/devitalised))
		
/obj/item/rogueweapon/huntingknife/idagger/zizo
	name = "luxdrinker blade"
	desc = "A profane blade shaped and made from a lesser alloy of avantyne. It does not look very deadly, but it has an odd, necrotic aura about it..."
	force = 10 // this isn't a weapon, good sire
	max_blade_int = 400 // but you can try shanking someone to death ig, hail zizo
	max_integrity = 120
	wdefense = 8
	associated_skill = (/datum/skill/magic/holy)
	tool_behaviour = TOOL_SCALPEL // It takes longer to use than a scalpel, but causes a different (AND EXTREMELY PAINFUL) incision that does different things.
	icon_state = "corruptdagger"
	aura_color = "#ff3737"

/obj/item/rogueweapon/huntingknife/idagger/zizo/Initialize()
	. = ..()
	set_light(5, 4, l_color = LIGHT_COLOR_RED)


/obj/item/contraption/hacker_doohickey
	name = "rouscker device"
	desc = "A creation of insanity with no exceptions. This curious contraption tampers with the little rous within devices, effectively sabotaging it. Needs cheese wedges!"
	icon_state = "metalizer"
	on_icon = "metalizer_flick"
	off_icon = "metalizer_off"
	w_class = WEIGHT_CLASS_NORMAL
	misfire_chance = 15
	charge_per_source = 5
	max_stored_charge = 100
	grid_height = 64
	grid_width = 64

/obj/item/contraption/hacker_doohickey/attack_obj(obj/O, mob/living/user)
	..() // TBD

/obj/item/storage/magebag


////////////
//MATTHIOS//
////////////

//ALCHEMY
/obj/
	var/aura_color = null

/obj/Initialize()
	. = ..()
	if(aura_color)
		apply_aura()

/obj/proc/apply_aura()
	if(!aura_color)
		return
	if(!filters)
		filters = list()
	remove_aura()
	var/aura_color_final = "[aura_color]40"
	filters += filter(type="outline", color=aura_color_final, size=2)

/obj/proc/remove_aura()
	if(!filters)
		return

	for(var/F in filters)
		if(islist(F))
			if(F["type"] == "outline")
				filters -= F

/obj/proc/refresh_aura()
	if(aura_color)
		apply_aura()

/obj/item/alchserum
	var/current_color = "#ffffff"

/obj/item/alchserum/Initialize()
	. = ..()
	update_icon()

/obj/item/alchserum/update_icon()
	cut_overlays()

/proc/funny_smoke(atom/source, radius = 0, sound_vol = 50)
	if(!source)
		return
	var/turf/T = get_turf(source)
	if(!T)
		return
	playsound(T, 'sound/items/smokebomb.ogg', sound_vol)
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(radius, T)
	smoke.start()

var/global/list/da_bubbles = list('sound/foley/bubb (1).ogg','sound/foley/bubb (2).ogg','sound/foley/bubb (3).ogg','sound/foley/bubb (4).ogg','sound/foley/bubb (5).ogg')

// admin spawnable only
/obj/item/matthios_canister
	name = "gilded alchemical canister"
	desc = "A strange, fragile alchemical vessel housing a silent power beyond human comprehension. Is this true?"
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	w_class = WEIGHT_CLASS_TINY
	var/current_color = "#ffffff"
	var/list/required_ingredients = list()
	var/list/inserted_ingredients = list()
	var/list/ingredient_colors = list()
	var/result_path = null

/obj/item/matthios_canister/Initialize()
	. = ..()
	update_icon()

/obj/item/matthios_canister/examine(mob/user)
	. = ..()

	if(HAS_TRAIT(user, TRAIT_FREEMAN))
		. += span_notice("[freeman_truth()]")
		. += span_warning("[freeman_progress(user)]")

/obj/item/matthios_canister/proc/freeman_truth()
	return "..."

/obj/item/matthios_canister/proc/freeman_progress(mob/user)
	return "..."

/obj/item/matthios_canister/update_icon()
	. = ..()
	cut_overlays()
	var/mutable_appearance/fluid = mutable_appearance(icon, "canister_fluid")
	fluid.color = current_color
	add_overlay(fluid)

/obj/item/matthios_canister/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		return TRUE

	return TRUE

/obj/item/matthios_canister/proc/check_completion(mob/user)
	for(var/T in required_ingredients)
		if(!(T in inserted_ingredients))
			return
	alch_transform(user)

/obj/item/matthios_canister/proc/alch_transform(mob/user)
	if(!result_path)
		return
	to_chat(user, span_notice("The mixture stabilizes successfully."))
	new result_path(get_turf(src))
	funny_smoke(src)
	qdel(src)

//////////////////////
//Vial of Lyfestruth//
//Uses all herbs in game, and one purified lux, explosively (literal!) revives your target.

/obj/item/matthios_canister/lyfestruth
	name = "vial of lyfestruth base"
	desc = "Within the glass swells a searing draught, as though molten gold were stirred with the heartblood of a volcano. It glows too bright, too alive. The vessel ought crack, yet it does not. What is this impossible sorcery?"
	current_color = "#ffffff"	
	result_path = /obj/item/alchserum/matthios_lyfestruth
	var/has_lux = FALSE
	var/lux_types = list(
		/obj/item/reagent_containers/lux,
		/obj/item/reagent_containers/lux_impure,
		/obj/item/reagent_containers/lux_moss,
		/obj/item/leechtick_bloated,

	)
	required_ingredients = list(
		/obj/item/alch/atropa,
		/obj/item/alch/matricaria,
		/obj/item/alch/symphitum,
		/obj/item/alch/taraxacum,
		/obj/item/alch/euphrasia,
		/obj/item/alch/paris,
		/obj/item/alch/calendula,
		/obj/item/alch/mentha,
		/obj/item/alch/urtica,
		/obj/item/alch/salvia,
		/obj/item/alch/hypericum,
		/obj/item/alch/benedictus,
		/obj/item/alch/valeriana,
		/obj/item/alch/artemisia,
		/obj/item/reagent_containers/food/snacks/grown/manabloom,
		/obj/item/alch/rosa,
	)
	ingredient_colors = list(
		/obj/item/alch/atropa = "#8b37c4",
		/obj/item/alch/matricaria = "#f5e6a8",
		/obj/item/alch/symphitum = "#4f8f6a",
		/obj/item/alch/taraxacum = "#ffd84d",
		/obj/item/alch/euphrasia = "#cfe8ff",
		/obj/item/alch/paris = "#62a044",
		/obj/item/alch/calendula = "#ff9f1a",
		/obj/item/alch/mentha = "#3aff7a",
		/obj/item/alch/urtica = "#2f7f3f",
		/obj/item/alch/salvia = "#6b8e23",
		/obj/item/alch/hypericum = "#ffcc33",
		/obj/item/alch/benedictus = "#d4b24c",
		/obj/item/alch/valeriana = "#8e5a3c",
		/obj/item/alch/artemisia = "#7a9e7e",
		/obj/item/reagent_containers/food/snacks/grown/manabloom = "#66ccff",
		/obj/item/alch/rosa = "#ff4d6d"
	)

	result_path = /obj/item/alchserum/matthios_lyfestruth

/obj/item/matthios_canister/lyfestruth/Initialize()
	. = ..()
	required_ingredients = required_ingredients.Copy()

/obj/item/matthios_canister/lyfestruth/freeman_progress(mob/user)
	if(!required_ingredients.len && !has_lux)
		return "The draught is complete. You can feel the heat, but it lacks the life essence to stabilize it."

	var/typepath = pick(required_ingredients)
	var/atom/A = typepath
	var/initial_name = initial(A.name)

	if(has_lux)
		return "It lacks [initial_name], but gold dust may also serve. Lux has been bound, speeding the process. ([required_ingredients.len] components yet unbound)"

	return "It lacks [initial_name], but gold dust may also serve. ([required_ingredients.len] components yet unbound)"


/obj/item/matthios_canister/lyfestruth/freeman_truth()
	return "This is no vulgar tonic, but 'Geald', the stolen fyre of Astrata condensed into liquid form. Oft called 'liquid anastasis', it restores not flesh, but the moment before death was writ. However, it is a fact of its volatile nature."

/obj/item/matthios_canister/lyfestruth/attackby(obj/item/I, mob/user)
	. = ..()
	if(!I)
		return 

	var/is_gold = istype(I, /obj/item/alch/golddust)
	var/is_lux = FALSE

	for(var/L in lux_types)
		if(istype(I, L))
			is_lux = TRUE
			break

	var/is_valid = FALSE
	for(var/T in required_ingredients)
		if(istype(I, T))
			is_valid = TRUE
			break

	if(!is_valid && !is_gold && !is_lux)
		return

	if(do_after(user, 2 SECONDS))

		if(is_lux)
			if(has_lux)
				to_chat(user, span_warning("The vessel recoils—too much Lux would surely rupture it."))
				return

			has_lux = TRUE
			current_color = "#66ccff"

			var/remove_count = max(1, round(required_ingredients.len * 0.5))
			for(var/i = 1, i <= remove_count, i++)
				if(!required_ingredients.len)
					break
				var/chosen = pick(required_ingredients)
				required_ingredients -= chosen

			to_chat(user, span_notice("The mixture surges! Its progress hastened considerably by the life essence!"))

			qdel(I)
			playsound(user, 'sound/misc/lava_death.ogg', 15, FALSE)
			update_icon()
			check_completion(user)
			return

		if(is_gold)
			if(!required_ingredients.len)
				return

			var/chosen = pick(required_ingredients)
			required_ingredients -= chosen
			current_color = "#fff066"

			qdel(I)
			playsound(user, 'sound/misc/lava_death.ogg', 15, FALSE)
			update_icon()
			check_completion(user)
			return

		if(!(I.type in required_ingredients))
			to_chat(user, span_warning("That essence has already been bound."))
			return

		required_ingredients -= I.type

		if(ingredient_colors[I.type])
			current_color = ingredient_colors[I.type]

		qdel(I)
		playsound(user, pick(da_bubbles), 30, FALSE)
		update_icon()
		check_completion(user)

	return

/obj/item/matthios_canister/lyfestruth/check_completion(mob/user)
	if(!required_ingredients.len && !has_lux)
		to_chat(user, span_warning("The mixture writhes… yet something radiant and vital is still missing..."))
		return

	if(!required_ingredients.len && has_lux)
		alch_transform(user)

/obj/item/alchserum/matthios_lyfestruth
	name = "vial of lyfestruth"
	desc = "A radiant vial containing a volatile mixture. The liquid within churns with molten intensity, casting a searing orange-gold glow that flickers against its glass prison. It seems extremely volatile."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#ff9d00"
	aura_color = "#fffaad"
	w_class = WEIGHT_CLASS_TINY

/obj/item/alchserum/matthios_lyfestruth/attack(mob/living/target, mob/user)
	if(!istype(target, /mob/living/carbon))
		return
	if(target.stat != DEAD)
		to_chat(user, span_notice("They are not dead!"))
		return
	if(!target.mind || !target.mind.active)
		to_chat(user, "Strangely, the fluid seems a little colder when you try.")
		return
	if(HAS_TRAIT(target, TRAIT_DNR))
		to_chat(user, span_danger("The Geald within the vial does not react to them at all. Strange."))
		return	
	if(HAS_TRAIT(target, TRAIT_NOBLE))
		to_chat(user, span_notice("You have a feeling that Matthios would personally eviscerate you for trying this on them."))
		return

	to_chat(user, span_notice("You begin pouring the lyfestruth over [target.name]..."))

	if(do_after(user, 6 SECONDS, target))
		if(!target || target.stat != DEAD)
			return
		apply_effect(target, user)

/obj/item/alchserum/matthios_lyfestruth/proc/apply_effect(mob/living/carbon/target, mob/user)
	if(!target)
		return

	var/choice
	if(target.client)
		choice = alert(target, "You feel divine warmth offering you freedom from the shackles of Necra...", "Revival", "I need to wake up! Freedom!", "I'd rather be dead than free.")
	else
		choice = "I'd rather be dead than free."

	var/accepted = (choice == "I need to wake up! Freedom!")

	if(accepted)
		target.revive(full_heal = TRUE)
		to_chat(target, span_warning("Your body is violently forced back to life, as a searing heat floods from within— IT BURNS!!"))
		target.visible_message(span_warning("[target.name]'s body rewinds to life... only for a massive shockwave of fire to burst from them!"))
		target.adjust_fire_stacks(5)
		target.ignite_mob()
		target.emote("agony", forced = TRUE)
	else
		to_chat(target, span_warning("You refuse the call... but the warmth curdles into something volatile."))
		target.visible_message(span_warning("[target.name] does not rise. The Geald within them destabilizes violently!"))

	var/turf/T = get_turf(target)
	if(T)
		explosion(T, devastation_range = null, heavy_impact_range = null, light_impact_range = 4, flame_range = 8, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

	for(var/mob/living/M in range(4, target))
		if(M == target)
			continue
		var/dir = get_dir(target, M)
		var/turf/throw_target = get_edge_target_turf(M, dir)
		if(throw_target)
			M.throw_at(throw_target, 4, 2)

	qdel(src)

////////////////////
//Vial of Firstlaw//
//The core of Malchemy, harsher than the real deal. If you fail to produce the good, you lose all the ingredients.

/obj/item/matthios_canister/firstlaw
	name = "vial of firstlaw"
	desc = "A suffocating pressure coils within the glass, as though something immense has been forced into too small a space. The contents do not slosh nor settle... they weigh upon reality itself."
	current_color = "#e100ff"
	aura_color = "#ff00b3"

	var/stone_progress = 0
	var/current_choice = null

	required_ingredients = list(
		/obj/item/natural/dirtclod,
		/obj/item/natural/clay,
		/obj/item/natural/stone,
		/obj/item/rogueore/coal,
		/obj/item/rogueore/iron,
		/obj/item/rogueore/gold,
		/obj/item/roguegem/yellow,
		/obj/item/roguegem/green,
		/obj/item/roguegem/violet,
		/obj/item/roguegem/blue,
		/obj/item/roguegem/diamond,
	)

/obj/item/matthios_canister/firstlaw/freeman_truth()
	return "All things bend to the First Law. Equivalent exchange is not a rule, it is the only truth. To hold it is to feel a principle enforced: nothing is gained, nothing is lost, only exchanged."

/obj/item/matthios_canister/firstlaw/freeman_progress(mob/user)
	return "Stored Value: [stone_progress] stone\nChoice: [current_choice ? current_choice : "NONE"]"

/obj/item/matthios_canister/firstlaw/proc/get_stone_value(obj/item/I)
	if(istype(I, /obj/item/natural/dirtclod)) return 1
	if(istype(I, /obj/item/natural/clay)) return 1
	if(istype(I, /obj/item/natural/stone)) return 1
	if(istype(I, /obj/item/rogueore/coal)) return 4
	if(istype(I, /obj/item/rogueore/iron)) return 8
	if(istype(I, /obj/item/rogueore/gold)) return 32
	if(istype(I, /obj/item/roguegem/yellow)) return 65
	if(istype(I, /obj/item/roguegem/green)) return 129
	if(istype(I, /obj/item/roguegem/violet)) return 193
	if(istype(I, /obj/item/roguegem/blue)) return 257
	if(istype(I, /obj/item/roguegem/diamond)) return 578
	if(istype(I, /obj/item/riddleofsteel)) return 1184
	return 0

/obj/item/matthios_canister/firstlaw/proc/get_cost(choice)
	switch(choice)
		if("Dirt") return 0
		if("Clay") return 1
		if("Stone") return 1
		if("Mortar & Pestle") return 2
		if("Coal") return 4
		if("Iron") return 8
		if("Alchemy Station") return 10
		if("Cauldron") return 16
		if("Firstlaw Extract") return 18
		if("Gold") return 32
		if("Toper") return 65
		if("Gemerald") return 129
		if("Saffira") return 193
		if("Blortz") return 257
		if("Dorpel") return 578
		if("Riddle of Steel") return 1184

/obj/item/matthios_canister/firstlaw/proc/get_requirement(choice)
	switch(choice)
		if("Mortar & Pestle","Alchemy Station","Cauldron","Dirt","Clay","Stone") return SKILL_LEVEL_NONE
		if("Firstlaw Extract","Coal","Iron") return SKILL_LEVEL_JOURNEYMAN
		if("Gold","Toper","Gemerald","Saffira","Blortz") return SKILL_LEVEL_EXPERT
		if("Dorpel","Riddle of Steel") return SKILL_LEVEL_MASTER

/obj/item/matthios_canister/firstlaw/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The principle escapes me. This is nonsense and heresy."))
		return TRUE

	var/valid = FALSE
	for(var/T in required_ingredients)
		if(istype(I, T))
			valid = TRUE
			break

	if(!valid)
		return TRUE

	if(do_after(user, 1 SECONDS))
		var/value = get_stone_value(I)
		stone_progress += value
		to_chat(user, span_warning("[I] disintegrates into a refined dust...<br>(Current Value: [stone_progress])"))
		playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
		qdel(I)
		update_icon()

	return TRUE

/obj/item/matthios_canister/firstlaw/proc/process_stone_batch(mob/user, turf/T)
	var/level = user.get_skill_level(/datum/skill/magic/holy)
	var/batch_size = 2 + 2 * level

	var/found_any = FALSE
	for(var/obj/item/natural/stone/S in T)
		found_any = TRUE
		break

	if(!found_any)
		return FALSE

	var/processed_any = FALSE

	while(TRUE)
		var/list/batch = list()

		for(var/obj/item/natural/stone/S in T)
			batch += S
			if(batch.len >= batch_size)
				break

		if(!batch.len)
			break

		if(!do_after(user, 1 SECONDS, target = user))
			break

		for(var/obj/item/natural/stone/S in batch)
			if(QDELETED(S))
				continue
			stone_progress += 1
			qdel(S)
			processed_any = TRUE

		playsound(user.loc, 'sound/misc/smelter_sound.ogg', 25, FALSE)

	if(processed_any)
		to_chat(user, span_warning("You gather the stones together, dissolving them into a pile of fine dust.<br>(Current Value: [stone_progress])"))
		update_icon()

	return processed_any

/obj/item/matthios_canister/firstlaw/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag) return
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES)) return

	if(istype(target, /obj/item/natural/stone))
		var/obj/item/natural/stone/S = target
		if(do_after(user, 0.5 SECONDS, target = user))
			stone_progress += 1
			qdel(S)
			playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
			to_chat(user, span_warning("The stone crumbles into dust.<br>(Current Value: [stone_progress])"))
			update_icon()
		return

	if(istype(target, /obj/item/natural/rock))
		var/obj/item/natural/rock/R = target
		if(do_after(user, 2 SECONDS, target = user))
			var/gain = rand(1,4)
			stone_progress += gain

			if(prob(4))
				var/list/ores = list(
					/obj/item/natural/stone,
					/obj/item/rogueore/coal,
					/obj/item/rogueore/iron,
					/obj/item/rogueore/gold,
					/obj/item/roguegem/blue,
					/obj/item/roguegem/yellow,
					/obj/item/roguegem/green,
					/obj/item/roguegem/violet,
				)
				var/typepath = pick(ores)
				var/bonus = get_stone_value(new typepath)
				stone_progress += bonus

			qdel(R)
			playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
			to_chat(user, span_warning("The boulder is reduced to dust.<br>(Current Value: [stone_progress])"))
			update_icon()
		return

	if(isturf(target))
		var/turf/T = target
		process_stone_batch(user, T)

/obj/item/matthios_canister/firstlaw/attack_self(mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("This is heresy beyond me."))
		return

	var/list/options_map = list(
		"Mortar & Pestle" = list(/obj/item/reagent_containers/glass/mortar, /obj/item/pestle),
		"Cauldron" = /obj/machinery/light/rogue/cauldron,
		"Alchemy Station" = /obj/structure/fluff/alch,
		"Firstlaw Extract" = /obj/item/alchserum/matthios_insight,
		"Dirt" = /obj/item/natural/dirtclod,
		"Clay" = /obj/item/natural/clay,
		"Stone" = /obj/item/natural/stone,
		"Coal" = /obj/item/rogueore/coal,
		"Iron" = /obj/item/rogueore/iron,
		"Gold" = /obj/item/rogueore/gold,
		"Toper" = /obj/item/roguegem/yellow,
		"Gemerald" = /obj/item/roguegem/green,
		"Saffira" = /obj/item/roguegem/violet,
		"Blortz" = /obj/item/roguegem/blue,
		"Dorpel" = /obj/item/roguegem/diamond,
		"Riddle of Steel" = /obj/item/riddleofsteel
	)

	var/level = user.get_skill_level(/datum/skill/magic/holy)

	if(current_choice)
		var/cost = get_cost(current_choice)
		var/remaining = max(cost - stone_progress, 0)

		var/finalize_text = (stone_progress >= cost) ? "Finalize Exchange (Ready!)" : "Finalize Exchange ([remaining] left.)"
		var/redirect_text = "Redirect Law"
		var/refund_text = "Refund Stones (75%)"
		var/nevermind_text = "Nevermind"

		var/list/choices = list(finalize_text, redirect_text, refund_text, nevermind_text)

		var/decision = input(user, "The Law is in motion.", "First Law") as null|anything in choices
		if(!decision || decision == nevermind_text)
			return

		if(decision == refund_text)
			var/refund_amt = round(stone_progress * 0.75)
			for(var/i in 1 to refund_amt)
				new /obj/item/natural/stone(get_turf(src))

			stone_progress = 0
			current_choice = null
			to_chat(user, span_warning("The Law unravels. Most is returned."))
			update_icon()
			return

		if(decision == redirect_text)
			var/list/display = list()
			var/list/lookup = list()

			for(var/K in options_map)
				var/c = get_cost(K)
				var/r = get_requirement(K)

				if(level >= r)
					var/entry = "[K] ([c])"
					display += entry
					lookup[entry] = K

			var/pick_choice = input(user, "Redirect the Law?", "First Law") as null|anything in display
			if(!pick_choice)
				return

			var/new_choice = lookup[pick_choice]
			current_choice = new_choice
			to_chat(user, span_notice("The Law bends toward [new_choice]."))

			var/new_cost = get_cost(new_choice)

			if(stone_progress >= new_cost)
				var/excess = stone_progress - new_cost
				stone_progress = 0

				var/result = options_map[new_choice]

				if(islist(result))
					for(var/typepath in result)
						if(ispath(typepath))
							new typepath(get_turf(src))
				else
					if(ispath(result))
						new result(get_turf(src))

				var/half = round(excess / 2)
				for(var/i in 1 to half)
					new /obj/item/natural/stone(get_turf(src))

				to_chat(user, span_notice("The Law resolves instantly into [new_choice], for a hefty cost..."))
				if(isliving(user))
					var/mob/living/U = user
					U.adjust_fire_stacks(2)
					U.adjustFireLoss(125)
					U.ignite_mob()
				funny_smoke(src)
				qdel(src)
				return

			return

		if(decision == finalize_text)
			if(stone_progress < cost)
				to_chat(user, span_warning("The Law demands more value to be transacted."))
				return

			if(do_after(user, 2.5 SECONDS, target = user, same_direction = TRUE))

				var/list/single_crafts = list(
					"Mortar & Pestle",
					"Cauldron",
					"Alchemy Station",
					"Firstlaw Extract"
				)

				var/is_single = (current_choice in single_crafts)

				var/amount
				var/excess

				if(is_single)
					amount = 1
					excess = stone_progress - cost
				else
					amount = (cost > 0) ? floor(stone_progress / cost) : 1
					excess = (cost > 0) ? (stone_progress % cost) : 0

				var/result = options_map[current_choice]

				var/base_fail = min(75, round(cost / 5))
				var/skill_bonus = level * 5

				var/total_spent = amount * cost
				var/overpay = max(0, stone_progress - total_spent)
				var/overpay_ratio = cost > 0 ? (overpay / cost) : 0
				var/overpay_bonus = round(overpay_ratio * 30)

				var/final_fail = max(0, base_fail - skill_bonus - overpay_bonus)
				if(final_fail)
					to_chat(user, span_notice("--[final_fail]% chance of failure per item! Matthios have mercy..."))

				for(var/i in 1 to amount)
					if(prob(final_fail))
						if(prob(50))
							var/list/fail_results = list(/obj/item/ingot/aaslag, /obj/item/scrap)
							var/typepath = pick(fail_results)
							new typepath(get_turf(src))
							to_chat(user, span_notice("The exchange falters..."))
						else
							to_chat(user, span_warning("The Law rejects part of the exchange."))
					else
						var/turf/spawn_turf = get_turf(src)

						if(is_single)
							var/turf/front = get_step(user, user.dir)

							if(front && !front.density)
								var/blocked = FALSE
								for(var/atom/A in front)
									if(A.density)
										blocked = TRUE
										break

								if(!blocked)
									spawn_turf = front
							else
								spawn_turf = get_turf(src)

						if(islist(result))
							for(var/typepath in result)
								if(ispath(typepath))
									new typepath(spawn_turf)
						else
							if(ispath(result))
								new result(spawn_turf)



				to_chat(user, span_notice("The exchange concludes. ([amount] attempted)"))

				if(excess > 0)
					for(var/i in 1 to excess)
						new /obj/item/natural/stone(get_turf(src))

				stone_progress = 0
				funny_smoke(src)
				qdel(src)
				return
	else
		var/list/display = list()
		var/list/lookup = list()

		for(var/K in options_map)
			var/cost = get_cost(K)
			var/req = get_requirement(K)

			if(level >= req)
				var/entry = "[K] ([cost])"
				display += entry
				lookup[entry] = K

		if(!display.len)
			to_chat(user, span_warning("Nothing may yet be chosen."))
			return

		var/choice = input(user, "What shall be defined?", "First Law") as null|anything in display
		if(!choice)
			return 

		current_choice = lookup[choice]
		to_chat(user, span_notice("The Law bends toward [current_choice]."))


//////////////////////
//Vial of Kingsfeast//
//Uses up to 10 organic items and converts them into 1 lavish food of choice. It can fail and become bread or worse.

/obj/item/matthios_canister/kingsfeast
	name = "vial of kingsfeast base"
	desc = "The brew within sloshes thick as spoiled blood. A stench rises from it most foul, resembling a mixture of rot and brine. The very vapours of said tincture can dissolve organic matter."

	var/max_ingredients = 10

	required_ingredients = list(
		/obj/item/alch/sinew,
		/obj/item/natural/bone,
		/obj/item/natural/bundle/bone,
		/obj/item/natural/fibers,
		/obj/item/natural/bundle/fibers,
		/obj/item/reagent_containers/powder/salt,
		/obj/item/reagent_containers/food
	)
	ingredient_colors = list(
		/obj/item/alch/sinew = "#a84a4a",
		/obj/item/natural/bone = "#e8e2cf",
		/obj/item/natural/bundle/bone = "#e8e2cf",
		/obj/item/natural/fibers = "#007e1f",
		/obj/item/natural/bundle/fibers = "#007e1f",
		/obj/item/reagent_containers/powder/salt = "#f0f0f0",
		/obj/item/reagent_containers/food = "#d67a4a"
	)

/obj/item/matthios_canister/kingsfeast/freeman_truth()
	return "A primal alchemical reduction tincture. All organic input is stripped to its nutritional and experiential essence, then recomposed into perfected sustenance. It does not cook, it outright defines what it means to be food."

/obj/item/matthios_canister/kingsfeast/freeman_progress(mob/user)
	var/remaining = max_ingredients - inserted_ingredients.len
	if(remaining <= 0)
		return "The feast is ready to take form."

	return "It needs [remaining] more organic offerings."

/obj/item/matthios_canister/kingsfeast/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return TRUE

	var/valid = FALSE
	for(var/T in required_ingredients)
		if(istype(I, T))
			valid = TRUE
			break

	if(!valid)
		return TRUE

	if(inserted_ingredients.len >= max_ingredients)
		to_chat(user, span_warning("The canister refuses to take more. It is... full."))
		return TRUE

	if(do_after(user, 1.5 SECONDS))

		if(istype(I, /obj/item/natural/bundle/fibers))
			var/obj/item/natural/bundle/fibers/B = I
			for(var/i = 1 to B.amount)
				inserted_ingredients += /obj/item/natural/fibers
		else
			inserted_ingredients += I.type

		var/color_to_use = null
		for(var/T in ingredient_colors)
			if(istype(I, T))
				color_to_use = ingredient_colors[T]
				break

		if(color_to_use)
			current_color = color_to_use

		var/list/absorb_flavor = list(
			"The mixture's vapors overtake the [I] at once, breaking it down into a fine, formless draught...",
			"A faint hiss rises as the [I] is rendered to its base components, drawn into the brew...",
			"The [I] loses all shape, reduced to a pale suspension within the thickened mixture...",
			"The [I] slackens and falls apart, its substance wholly undone and folded into the draught...",
			"The brew strips the [I] to its essence, leaving no trace of its former form...",
			"A subtle reaction passes through the vessel as the [I] is reduced and made one with it...",
			"The [I] collapses into a fine residue, its nature thoroughly dissolved into the mixture...",
			"The [I] is unmade in moments, rendered down and claimed by the alchemical base...",
			"The draught clouds as the [I] is broken to its simplest form and drawn within...",
			"The [I] yields entirely, reduced and recomposed within the vessel's thick contents..."
		)
		qdel(I)
		playsound(user, pick(da_bubbles), 30, FALSE)
		to_chat(user, span_notice(pick(absorb_flavor)))
		update_icon()
		check_completion(user)

	return TRUE

/obj/item/matthios_canister/kingsfeast/check_completion(mob/user)
	if(inserted_ingredients.len < max_ingredients)
		return

	alch_transform(user)

/obj/item/matthios_canister/kingsfeast/alch_transform(mob/user)
	var/ishungry = user.nutrition < NUTRITION_LEVEL_HUNGRY
	var/miraclecheck = 10 * user.get_skill_level(/datum/skill/magic/holy)
	to_chat(user, span_notice("You begin channeling your greed into the mixture..."))

	var/list/options = list(
		"Ducal Peppersteak" = /obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal,
		"Lobster Meal" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/meal,
		"Crabcake" = /obj/item/reagent_containers/food/snacks/rogue/crabcake,
		"Chocolate" = /obj/item/reagent_containers/food/snacks/chocolate,
		"Meat Tomatoplate" = /obj/item/reagent_containers/food/snacks/rogue/meattomatoplate,
		"Broth Brique" = /obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique,
		"Strawberry Cake" = /obj/item/reagent_containers/food/snacks/rogue/strawberrycake,
		"Cookies" = /obj/item/reagent_containers/food/snacks/rogue/cookiec,
		"Meat Handpie" = /obj/item/reagent_containers/food/snacks/rogue/handpie/meat,
	)

	var/choice = input(user, "What form shall your greed take?", "Kingsfeast") as null|anything in options
	if(!choice)
		return

	var/result_type = options[choice]

	if(prob(25) && !ishungry)
		to_chat(user, span_warning("The mixture ignites violently, collapsing into useless slag and bitter disappointment. It... technically is edible. I guess?"))
		new /obj/item/reagent_containers/food/snacks/badrecipe(get_turf(src))
		funny_smoke(src)
		qdel(src)
		return
	
	if(!ishungry && prob(80 - miraclecheck)) // bread troll
		to_chat(user, span_warning("The mixture shifts... simplifying itself into something more befitting your greed."))
		new /obj/item/reagent_containers/food/snacks/rogue/bread(get_turf(src))
		if(prob(20))
			user.emote(pick("sigh","groan"))
		funny_smoke(src)
		qdel(src)
		return

	if(ishungry && prob(25)) 
		to_chat(user, span_notice("Matthios takes pity on your mortal limitations. You compulsively shout in gratitude!"))
		user.say(pick("PRAISE YOU, O' GENEROUS MATTHIOS!!","AT LAST, THE TRUE GOLD OF CULINARY ALCHEMY!!","BLESSED BE THY HANDS WHICH GRANT ME SUSTENANCE, MATTHIOS!!","I SHALL GIVE ALL FOR THY SMILE, LORD OF FREEDOM!!"), language = /datum/language/common)

	to_chat(user, span_notice("The mixture responds to your greed, shaping and taking the desired form. It feels warm and tasty!"))

	new result_type(get_turf(src))
	funny_smoke(src)
	qdel(src)

/obj/item/matthios_canister/kingsfeast/attack_self(mob/user)
	if(inserted_ingredients.len < max_ingredients)
		to_chat(user, span_warning("It is not yet ready."))
		return

	to_chat(user, span_notice("The mixture churns expectantly, awaiting the weight of your greed..."))
	alch_transform(user)

/obj/item/matthios_canister/goodnite
	name = "vial of goodnite base"
	desc = "A dim, cloudy fluid rests inside, barely moving. Occasionally, something viscous streaks through it— like diluted brain matter. The glass feels warm, almost comforting. Staring at too long makes your eyelids heavy, and you get an odd compulsion to drink it."
	
	var/max_ingredients = 5

	required_ingredients = list(
		/obj/item/alch/bonemeal,
		/obj/item/alch/mentha,
		/obj/item/alch/manabloompowder,
		/obj/item/reagent_containers/powder,
		/obj/item/natural/bone,
		/obj/item/natural/bundle/bone,
	)

	ingredient_colors = list(
		/obj/item/alch/bonemeal = "#ffffff",
		/obj/item/alch/mentha = "#3aff7a",
		/obj/item/alch/manabloompowder = "#66ccff",
		/obj/item/reagent_containers/powder = "#ff00b3",
		/obj/item/natural/bone = "#e8e2cf",
		/obj/item/natural/bundle/bone = "#e8e2cf",
	)

/obj/item/matthios_canister/goodnite/freeman_truth()
	return "Condensed stellar residue. Dust harvested from a somnolent star that emits rhythmic sleep pulses. This is not sedation. It entrains the body to a universal resting cadence."

/obj/item/matthios_canister/goodnite/freeman_progress(mob/user)
	var/remaining = max_ingredients - inserted_ingredients.len

	if(remaining <= 0)
		return "The mixture has reached perfect stillness."

	return "It requires further refinement with any powdered drugs (such as ozium), bonemeal, manabloom dust or whole menthas. ([remaining] infusions remaining)"

/obj/item/matthios_canister/goodnite/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return TRUE

	var/valid = FALSE
	for(var/T in required_ingredients)
		if(istype(I, T))
			valid = TRUE
			break

	if(!valid)
		return TRUE

	if(inserted_ingredients.len >= max_ingredients)
		to_chat(user, span_warning("The vial will accept no more. It rests at perfect equilibrium."))
		return TRUE

	if(do_after(user, 1.5 SECONDS))
		inserted_ingredients += I.type

		var/color_to_use = null
		for(var/T in ingredient_colors)
			if(istype(I, T))
				color_to_use = ingredient_colors[T]
				break

		if(color_to_use)
			current_color = color_to_use

		qdel(I)
		playsound(user, pick(da_bubbles), 30, FALSE)

		var/list/absorb_flavor = list(
			"The mixture receives [I], its form dissolving into a calm, pale suspension...",
			"[I] softens and unravels, drawn quietly into the resting fluid...",
			"A faint stillness follows as [I] is reduced and folded into the mixture...",
			"[I] loses all distinction, rendered into a smooth, somnolent draught...",
			"The vial clouds gently as [I] is broken down and made one with it..."
		)

		to_chat(user, span_notice(pick(absorb_flavor)))

		update_icon()
		check_completion(user)

	return TRUE

/obj/item/matthios_canister/goodnite/check_completion(mob/user)
	if(inserted_ingredients.len < max_ingredients)
		return

	alch_transform(user)

/obj/item/matthios_canister/goodnite/alch_transform(mob/user)
	to_chat(user, span_notice("The mixture settles into a perfectly still, somnolent state."))
	new /obj/item/alchserum/matthios_goodnite(get_turf(src))
	funny_smoke(src)
	qdel(src)

/obj/item/alchserum/matthios_insight
	name = "vial of firstlaw extract"
	desc = "A soft-glowing concoction that hums with unbearable clarity. The liquid remains perfectly still, as if reality itself fears to disturb it. Those who glimpse too deeply may come to understand more than they were meant to."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#ff00b3"
	aura_color = "#1100ff"
	w_class = WEIGHT_CLASS_TINY

/obj/item/alchserum/matthios_insight/attack(mob/living/carbon/human/target, mob/user)
	if(!istype(target))
		return

	if(target == user)
		to_chat(user, span_notice("You begin administering the vial to [target.name]'s forehead..."))	
	else
		to_chat(user, span_notice("You begin administering the vial to your own forehead..."))

	if(do_after(user, 6 SECONDS, target))
		apply_firstlaw_insight(target, user)

/obj/item/alchserum/matthios_insight/proc/apply_firstlaw_insight(mob/living/carbon/human/T, mob/user)
	if(T.get_skill_level(/datum/skill/craft/alchemy) <= 0)
		T.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_NOVICE, TRUE)
		to_chat(T, span_notice("For a fleeting moment, the principles of transmutation become clear. You have become more proficient in Alchemy!"))
	else
		to_chat(T, span_notice("For a fleeting moment, the principles of transmutation become clear... But you soon realize those are just the basics!"))

	qdel(src)
	playsound(T.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
	sleep(30)
	to_chat(T, span_artery("<i>...Huh?</i>"))
	sleep(30)
	to_chat(T, span_danger("--The Law's purest essence reveals itself. In nature, nothing is given, nothing is lost. Everything is transformed."))
	T.Knockdown(30)
	T.adjustBruteLoss(125)
	T.adjustFireLoss(150)
	explosion(get_turf(T), light_impact_range = 1, flame_range = 2, smoke = FALSE, adminlog = FALSE)

/obj/item/alchserum/matthios_goodnite
	name = "vial of goodnite"
	desc = "A soft-glowing concoction that induces immediate, restorative sleep. The fluid rests in perfect stillness, undisturbed by motion or time. Gazing into it too long draws a creeping heaviness into the body, as if the world itself is gently insisting you lie down and surrender to rest."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#5c6fb2"
	aura_color = "#5e53ff"
	w_class = WEIGHT_CLASS_TINY

/obj/item/alchserum/matthios_goodnite/attack(mob/living/target, mob/user)
	if(!istype(target))
		return

	to_chat(user, span_notice("You begin gently administering the concoction to [target.name]'s eyes..."))

	if(do_after(user, 6 SECONDS, target))
		apply_sleep(target, user)

/obj/item/alchserum/matthios_goodnite/proc/apply_sleep(mob/living/target, mob/user)
	if(!target)
		return

	if(HAS_TRAIT(target, TRAIT_NOSLEEP))
		to_chat(user, span_warning("[target.name] resists the effects entirely."))
		return

	to_chat(target, span_notice("A heavy calm overtakes your body..."))
	sleep(5)
	visible_message(span_notice("[target.name] suddenly goes limp, overtaken by unnatural sleep."))

	target.SetSleeping(600)
	target.SetUnconscious(0)
	target.stat = UNCONSCIOUS

	spawn()
		while(target && target.IsSleeping())
			target.energy_add(20)
			target.adjustBruteLoss(2)

			if(target.nutrition > 0)
				target.adjustBruteLoss(-1)
				target.adjustFireLoss(-1)

			if(target.hydration > 0)
				target.adjustOxyLoss(-2)
				target.adjustToxLoss(-1)

			sleep(20)

	to_chat(user, span_notice("The vial dulls and crumbles away."))
	playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
	qdel(src)

/obj/item/matthios_canister/warsmith
	name = "vial of warsmith base"
	desc = "A biting liquor gnaws within the vial, as though it would eat iron itself. Flecks of metal drift and vanish, then return as if unmade and remade. It reeks of rust and sharp ruin. No forge would suffer this thing near its works."

	var/needed_scrap = 3
	var/current_scrap = 0
	var/has_needle = FALSE
	var/current_fibers = 0
	var/needed_fibers = 6

	required_ingredients = list(
		/obj/item/needle,
		/obj/item/natural/bundle/fibers,
		/obj/item/natural/fibers,
		/obj/item/scrap,
		/obj/item/rogueore/iron,
	)
	ingredient_colors = list(
		/obj/item/needle = "#c0c0c0",
		/obj/item/natural/bundle/fibers = "#1fa712",
		/obj/item/natural/fibers = "#1fa712",
		/obj/item/scrap = "#6e6e6e",
		/obj/item/rogueore/iron = "#6e6e6e",
	)

/obj/item/matthios_canister/warsmith/freeman_truth()
	return "A cunning weave of filament and will. Metal and fiber undone to their first truths, that they may be rewrought aright. It does not destroy— it remembers the shape of perfection, and compels all things toward it."

/obj/item/matthios_canister/warsmith/freeman_progress(mob/user)
	return "Needle: [has_needle ? "set" : "wanting"]\nFibers: [current_fibers]/[needed_fibers]\nIron scrap: [current_scrap]/[needed_scrap]"

/obj/item/matthios_canister/warsmith/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return TRUE

	if((istype(I, /obj/item/scrap)) || (istype(I, /obj/item/rogueore/iron)))
		if(current_scrap >= needed_scrap)
			to_chat(user, span_warning("The mixture refuses more metal."))
			return TRUE

		if(do_after(user, 2 SECONDS))
			if(current_scrap >= needed_scrap)
				return TRUE

			current_scrap = min(current_scrap + 1, needed_scrap)
			playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
			qdel(I)

			var/color_to_use = ingredient_colors[/obj/item/scrap]
			if(color_to_use)
				current_color = color_to_use

			to_chat(user, span_notice("You feed scrap into the mixture. ([current_scrap]/[needed_scrap])"))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/needle))
		if(has_needle)
			to_chat(user, span_warning("A needle has already been integrated."))
			return TRUE

		if(do_after(user, 2 SECONDS))
			if(has_needle)
				return TRUE

			has_needle = TRUE
			playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
			qdel(I)

			var/color_to_use = ingredient_colors[/obj/item/needle]
			if(color_to_use)
				current_color = color_to_use

			to_chat(user, span_notice("The needle dissolves into fine metallic thread."))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/natural/bundle/fibers))
		if(current_fibers >= needed_fibers)
			to_chat(user, span_warning("The mixture will take no more fiber."))
			return TRUE

		var/obj/item/natural/bundle/fibers/B = I
		var/amount = B.amount
		var/space_left = needed_fibers - current_fibers
		var/to_transfer = min(amount, space_left)

		if(to_transfer <= 0)
			return TRUE

		if(do_after(user, 2 SECONDS))
			space_left = needed_fibers - current_fibers
			to_transfer = min(amount, space_left)
			if(to_transfer <= 0)
				return TRUE

			current_fibers = min(current_fibers + to_transfer, needed_fibers)

			if(to_transfer >= amount)
				qdel(B)
			else
				B.amount -= to_transfer
				B.update_icon()

			var/color_to_use = ingredient_colors[/obj/item/natural/bundle/fibers/full]
			if(color_to_use)
				current_color = color_to_use

			to_chat(user, span_notice("You feed [to_transfer] measure\s of fiber into the mixture. ([current_fibers]/[needed_fibers])"))
			playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
			update_icon()
			check_completion(user)

		return TRUE

	if(istype(I, /obj/item/natural/fibers))
		if(current_fibers >= needed_fibers)
			to_chat(user, span_warning("The mixture will take no more fiber."))
			return TRUE

		if(do_after(user, 2 SECONDS))
			if(current_fibers >= needed_fibers)
				return TRUE

			current_fibers = min(current_fibers + 1, needed_fibers)
			qdel(I)

			var/color_to_use = ingredient_colors[/obj/item/natural/bundle/fibers/full]
			if(color_to_use)
				current_color = color_to_use

			to_chat(user, span_notice("The fiber is reduced and drawn into the mixture. ([current_fibers]/[needed_fibers])"))
			playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
			update_icon()
			check_completion(user)

		return TRUE

	to_chat(user, span_warning("This does not belong in the canister."))
	return TRUE

/obj/item/matthios_canister/warsmith/check_completion(mob/user)
	if(current_scrap < needed_scrap)
		return
	if(!has_needle)
		return
	if(current_fibers < needed_fibers)
		return

	alch_transform(user)

/obj/item/matthios_canister/warsmith/alch_transform(mob/user)
	to_chat(user, span_notice("The mixture hardens, then liquefies into an amorphous, perfect balance of fiber and steel."))
	new /obj/item/alchserum/matthios_warsmith(get_turf(src))
	funny_smoke(src)
	qdel(src)

/obj/item/alchserum/matthios_warsmith
	name = "vial of warsmith"
	desc = "A volatile fusion of textile and metal-binding alchemy. Filaments of steel and fiber drift within the mixture, weaving and unweaving themselves in restless patterns. It hums faintly when held, as if anticipating fracture— and the satisfaction of making something whole again."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#9c7b45"
	aura_color = "#ffe4b9"
	w_class = WEIGHT_CLASS_TINY
	var/uses = 4

/obj/item/alchserum/matthios_warsmith/attack_obj(obj/O, mob/living/user)
	if(!isitem(O))
		return
	var/obj/item/I = O
	if(!I.max_integrity)
		to_chat(user, span_warning("This cannot be repaired."))
		return
	if(I.obj_integrity >= I.max_integrity)
		to_chat(user, span_warning("This is not broken."))
		return
	to_chat(user, span_notice("You begin applying the warsmith mixture to [I]..."))
	if(!do_after(user, 6 SECONDS, target = I))
		return
	playsound(loc, 'sound/magic/swap.ogg', 100, TRUE, -2)
	user.visible_message(span_info("[user] restores [I] with alchemical precision."))
	if(I.body_parts_covered != I.body_parts_covered_dynamic)
		I.repair_coverage()
	I.obj_integrity = I.max_integrity
	if(I.obj_broken)
		I.obj_fix()
	uses--
	if(uses > 0)
		to_chat(user, span_notice("The mixture settles, awkwardly. You estimate [uses] uses remain."))
	else
		to_chat(user, span_warning("The vial burns out, its contents fully spent."))
		playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
		qdel(src)

/obj/item/matthios_canister/kingswine
	name = "vial of kingswine base"
	desc = "A foul slurry churns within the glass, thick with rot and sugared decay. It smells of spoiled fruit left in gutters and something far worse beneath it... coppery, clinging, wrong. No proper alchemist would name this craft; it is theft of nature."
	var/needed_liquid = 10
	var/current_liquid = 0
	var/path = null

	required_ingredients = list(
		/obj/item/reagent_containers/glass,
		/obj/item/organ,
		/obj/item/alch/viscera,
		/obj/item/reagent_containers/food/snacks/grown/fruit,
	)
	ingredient_colors = list(
		/obj/item/reagent_containers/glass = "#9c6262",
		/obj/item/organ = "#5c0a0a",
		/obj/item/alch/viscera = "#971616",
		/obj/item/reagent_containers/food/snacks/grown/fruit = "#9c3b1f",
	)

/obj/item/matthios_canister/kingswine/freeman_truth()
	if(path == "blood")
		return "The path of Kingsblood is set. The vial now craves richer, vital inputs such as blood, viscera, even organs... refining them into a draught of a potent coagulant, or darker indulgence for the ashen ones."
	else if(path == "wine")
		return "A true miracle of Malchemy! Like the old tale of 'water to wine', this stands as proof that where miracles or alchemy begin, Malchem Arts had already long, long walked."
	else
		return "A simple base, eager to take on character. It accepts liquids, fruits, anything with juice… though, one notes, blood is a liquid as well."


/obj/item/matthios_canister/kingswine/freeman_progress(mob/user)
	return "Progress: [current_liquid]/[needed_liquid]\nPath: [path ? uppertext(path) : "UNFORMED"]"

/obj/item/matthios_canister/kingswine/attackby(obj/item/I, mob/user)
	var/miracle = user.get_skill_level(/datum/skill/magic/holy)
	var/can_blood = (miracle >= SKILL_LEVEL_JOURNEYMAN)

	if(current_liquid >= needed_liquid)
		to_chat(user, span_warning("The mixture will take no more."))
		return TRUE

	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return TRUE

	if(istype(I, /obj/item/organ) || istype(I, /obj/item/alch/viscera))
		if(path && path != "blood")
			to_chat(user, span_warning("The mixture rejects this. It has already chosen sweetness over blood."))
			return TRUE

		if(!can_blood)
			to_chat(user, span_warning("I lack the divine insight to work with this. It'll only ruin the tincture if I try."))
			return TRUE

		if(do_after(user, 2 SECONDS))
			path = "blood"
			current_liquid = min(current_liquid + 1, needed_liquid)

			qdel(I)
			current_color = "#5c0a0a"
			playsound(user.loc,'sound/misc/lava_death.ogg', 50, FALSE)
			to_chat(user, span_warning("The meaty component dissolves into a thick slurry. ([current_liquid]/[needed_liquid])"))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit))
		if(path && path != "wine")
			to_chat(user, span_warning("The mixture curdles. It refuses sweetness now."))
			return TRUE

		if(do_after(user, 2 SECONDS))
			path = "wine"
			current_liquid = min(current_liquid + 1, needed_liquid)

			qdel(I)
			current_color = "#9c3b1f"
			playsound(user, pick(da_bubbles), 30, FALSE)
			to_chat(user, span_notice("The mixture ferments the offering. ([current_liquid]/[needed_liquid])"))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/R = I

		if(!R.reagents || !R.reagents.total_volume)
			to_chat(user, span_warning("It holds nothing to extract."))
			return TRUE

		var/has_blood = FALSE
		for(var/datum/reagent/rg in R.reagents.reagent_list)
			if(rg.name in list("Blood", "Dirty blood", "Liquid gibs"))
				has_blood = TRUE
				break

		if(has_blood && !can_blood)
			to_chat(user, span_warning("I lack the divine insight to work with this. It'll only ruin the tincture if I try."))
			return TRUE

		if(path == "wine" && has_blood)
			to_chat(user, span_warning("The mixture recoils from blood."))
			return TRUE

		if(path == "blood" && !has_blood)
			to_chat(user, span_warning("It demands only blood now."))
			return TRUE

		var/amount = min(20, R.reagents.total_volume)
		
		if(do_after(user, 2 SECONDS))
			if(has_blood)
				path = "blood"
				current_color = "#5c0a0a"
			else
				path = "wine"
				current_color = "#7a1f1f"

			R.reagents.remove_any(amount)

			var/stacks = clamp(round(amount / 10), 1, 2)
			current_liquid = min(current_liquid + stacks, needed_liquid)

			to_chat(user, span_notice("The mixture siphons [amount] doses of liquid. ([current_liquid]/[needed_liquid])"))

			update_icon()
			check_completion(user)

		return TRUE

	to_chat(user, span_warning("This does not belong in the canister."))
	return TRUE

/obj/item/matthios_canister/kingswine/attack(atom/target, mob/user)
	var/miracle = user.get_skill_level(/datum/skill/magic/holy)
	var/can_blood = (miracle >= SKILL_LEVEL_JOURNEYMAN)

	if(current_liquid >= needed_liquid)
		to_chat(user, span_warning("The mixture is already complete."))
		return TRUE

	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return TRUE

	if(ishuman(target))
		var/mob/living/carbon/human/H = target

		if(path && path != "blood")
			to_chat(user, span_warning("The mixture refuses flesh now."))
			return TRUE

		if(!can_blood)
			to_chat(user, span_warning("I lack the divine insight to work with this. It'll only ruin the tincture if I try."))
			return TRUE

		if(!H.get_bleed_rate())
			to_chat(user, span_warning("There is no blood to take."))
			return TRUE

		if(H.mind.has_antag_datum((/datum/antagonist/vampire)||(/datum/antagonist/skeleton)||(/datum/antagonist/zombie)||(/datum/antagonist/zizo_knight)||(/datum/antagonist/werewolf)||(/datum/antagonist/gnoll)))
			to_chat(user, span_warning("Not your finest choice of blood for this. It won't work, even by the impossible Malchemical standards."))
			return TRUE

		if(do_after(user, 2 SECONDS, target = H))
			path = "blood"
			current_liquid = min(current_liquid + 1, needed_liquid)
			current_color = "#5c0a0a"

			to_chat(user, span_warning("The mixture drinks from the wound. ([current_liquid]/[needed_liquid])"))

			if(user == H)
				H.visible_message(span_danger("[user] presses a vial at their open wound, filling it a bit."))
			else
				H.visible_message(span_danger("[user] presses a vial at [H]'s open wound, filling it a bit."))

			var/drain_amt = round(BLOOD_VOLUME_NORMAL * 0.05)
			H.blood_volume -= drain_amt

			update_icon()
			check_completion(user)

		return TRUE

	return ..()

/obj/item/matthios_canister/kingswine/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return

	var/miracle = user.get_skill_level(/datum/skill/magic/holy)
	var/can_blood = (miracle >= SKILL_LEVEL_JOURNEYMAN)

	if(current_liquid >= needed_liquid)
		to_chat(user, span_warning("The mixture is already complete."))
		return

	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return

	if(isturf(target))
		var/turf/T = target
		var/is_blood_water = istype(T, /turf/open/water/bloody)
		var/is_water = (istype(T, /turf/open/water/river) || istype(T, /turf/open/water/cleanshallow) || istype(T, /turf/open/water/pond) || istype(T, /turf/open/water/ocean) || istype(T, /turf/open/water/ocean/deep) || istype(T, /turf/open/water/swamp) || istype(T, /turf/open/water/swamp/deep))

		if(is_blood_water)
			if(path && path != "blood")
				to_chat(user, span_warning("The mixture recoils... This is not the path it chose."))
				return

			if(!can_blood)
				to_chat(user, span_warning("I lack the divine insight to work with this. It'll only ruin the tincture if I try."))
				return

			path = "blood"
			current_liquid = needed_liquid
			current_color = "#5c0a0a"

			to_chat(user, span_warning("The mixture greedily devours the blood water."))
			user.visible_message(span_danger("[user] dips a vial into [T], and it greedily fills."))

			update_icon()
			check_completion(user)
			return

		if(is_water)
			if(path && path != "wine")
				to_chat(user, span_warning("The mixture rejects the water, already tainted by blood."))
				return

			path = "wine"
			current_liquid = needed_liquid
			current_color = "#7a2f1b"

			to_chat(user, span_notice("The mixture eagerly drinks from the boundless waters."))
			user.visible_message(span_notice("[user] dips a vial into [T], and it greedily fills."))

			update_icon()
			check_completion(user)
			return

/obj/item/matthios_canister/kingswine/check_completion(mob/user)
	if(current_liquid < needed_liquid)
		return

	if(!path)
		return

	if(path == "wine")
		result_path = /obj/item/reagent_containers/glass/bottle/rogue/wine

	else if(path == "blood")
		result_path = /obj/item/alchserum/matthios_kingsblood

	alch_transform(user)

/obj/item/alchserum/matthios_kingsblood
	name = "vial of kingsblood"
	desc = "A dense, crimson tincture swirls within the glass, thick with vitality. It hums faintly with promise— a potent restorative said to replenish lost blood with unnatural efficiency. Though crude in origin, its effect is undeniable: where life has thinned, it forces it back in."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#ff0000"
	aura_color = "#8a0f0f"
	w_class = WEIGHT_CLASS_TINY
	var/uses = 4

/obj/item/alchserum/matthios_kingsblood/examine(mob/user)
	. = ..()

	if(user?.mind?.has_antag_datum(/datum/antagonist/vampire) || HAS_TRAIT(user, TRAIT_PALLID) || HAS_TRAIT(user, TRAIT_ORGAN_EATER))
		. += span_warning("TIP: You could drink this instead of applying it. Aim for your mouth and use it on yourself.")

/obj/item/alchserum/matthios_kingsblood/attack(mob/living/carbon/human/target, mob/living/user)
	if(!istype(target))
		return ..()

	var/is_vampire = target.mind?.has_antag_datum(/datum/antagonist/vampire)
	var/is_blood_drinker = is_vampire || HAS_TRAIT(target, TRAIT_PALLID) || HAS_TRAIT(target, TRAIT_ORGAN_EATER)

	if(target == user && user.zone_selected == BODY_ZONE_PRECISE_MOUTH && is_blood_drinker)
		if(do_after(user, 2 SECONDS, target = target))
			if(is_vampire)
				to_chat(target, span_notice("It tastes like very old wine... Rich, deep, and impossibly satisfying~"))
				target.bloodpool += 75
				target.apply_status_effect(/datum/status_effect/buff/vitae)
			else
				to_chat(target, span_notice("It tastes like old wine... Strange, but not entirely unpleasant."))

			target.visible_message(span_notice("[target] drinks from [src]."))

			for(var/datum/wound/W as anything in target.get_wounds())
				if(W && W.bleed_rate > 0)
					W.set_bleed_rate(0)

			playsound(user, 'sound/misc/drink_blood.ogg', 100)
			uses--
	else
		if(do_after(user, 2 SECONDS, target = target))

			if(!target.get_bleed_rate())
				to_chat(user, span_warning("[target] is not bleeding. The tincture finds nothing to mend."))
				return TRUE

			target.visible_message(
				span_notice("[user] applies [src] to [target]'s wounds."),
				span_notice("The tincture seeps into the flesh, cold and invasive...")
			)

			for(var/datum/wound/W as anything in target.get_wounds())
				if(W && W.bleed_rate > 0)
					W.set_bleed_rate(0)

			var/heal_amt = round(BLOOD_VOLUME_NORMAL * 0.2)
			target.blood_volume = min(target.blood_volume + heal_amt, BLOOD_VOLUME_NORMAL)

			to_chat(target, span_warning("Something sloshes around your wounds, forcing them to coagulate. The bleeding stops."))
			uses--

	if(uses > 0)
		to_chat(user, span_notice("The tincture settles uneasily. You estimate [uses] uses remain."))
	else
		to_chat(user, span_warning("The vial empties, its contents spent."))
		playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
		qdel(src)

	return TRUE
/*
/obj/item/matthios_canister/truthsnuke
	name = "gilded bomb canister"
	desc = "A sealed vessel packed with gray ruin and glimmering excess. Ash churns endlessly within, swallowing light, while a single mote of gold refuses to be consumed. It does not yearn for the Crown— it rejects it. Matthios once stole Astrata's fire not to kneel, but to prove no throne was sacred. This vessel follows that truth, straining to break authority itself."
	icon_state = "impact_grenade"
	icon = 'icons/roguetown/items/misc.dmi'
	aura_color = "#ffee01"

	var/needed_ash = 200
	var/current_ash = 0

	var/needed_coaldust = 100
	var/current_coaldust = 0

	var/needed_fire = 50
	var/current_fire = 0

	var/has_crown = FALSE
	var/has_flower = FALSE

	required_ingredients = list(
		/obj/item/ash,
		/obj/item/alch/coaldust,
		/obj/item/alch/firedust,
		/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius,
		/obj/item/clothing/head/roguetown/crown/serpcrown
	)

	ingredient_colors = list(
		/obj/item/ash = "#4a4a4a",
		/obj/item/alch/coaldust = "#2b2b2b",
		/obj/item/alch/firedust = "#ff4500",
		/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = "#ffae42",
		/obj/item/clothing/head/roguetown/crown/serpcrown = "#ffd700"
	)

/obj/item/matthios_canister/truthsnuke/freeman_truth()
	if(has_crown)
		return "You did it. You stole her fire, just as He once did. Not begged, not granted. Taken. Hopefully. Let the crowns of this world tremble, for they were always a lie. A king is only a man who has not yet been defied."
	else if(has_flower)
		return "Fire is fire, no matter how it is kindled. Even a lie can burn. Still… you feel it, don't you? This is not the same. A shadow of the act. Perhaps next time, you take the real thing."
	else
		return "Matthios did not ask. He did not kneel. He reached into the heavens and took what was denied, and in doing so proved the truth: no throne is sacred, no ruler chosen. Power belongs to those who seize it. This work follows that path, but it is not yet complete."

/obj/item/matthios_canister/truthsnuke/freeman_progress(mob/user)
	return "Ash: [current_ash]/[needed_ash]\nCoal Dust: [current_coaldust]/[needed_coaldust]\nFire Essentia: [current_fire]/[needed_fire]\nAstrata's Ultimate Authority: [has_crown ? "present" : "missing"]\nFyritius Replacement: [has_flower ? "present" : "missing"]"

/obj/item/matthios_canister/truthsnuke/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("You can't begin to think where to start with this... insanity."))
		return TRUE

	if(istype(I, /obj/item/ash))
		if(current_ash >= needed_ash)
			to_chat(user, span_warning("The vessel can hold no more ruin."))
			return TRUE

		if(do_after(user, 1 SECONDS))
			current_ash++
			qdel(I)
			current_color = ingredient_colors[/obj/item/ash]

			to_chat(user, span_notice("The ash is swallowed. ([current_ash]/[needed_ash])"))
			playsound(user, pick(da_bubbles), 30, FALSE)

			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/alch/coaldust))
		if(current_coaldust >= needed_coaldust)
			to_chat(user, span_warning("No more foundation can be laid."))
			return TRUE

		if(do_after(user, 1 SECONDS))
			current_coaldust++
			qdel(I)
			current_color = ingredient_colors[/obj/item/alch/coaldust]

			to_chat(user, span_notice("The dust settles into the mass. ([current_coaldust]/[needed_coaldust])"))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/alch/firedust))
		if(current_fire >= needed_fire)
			to_chat(user, span_warning("The essence within can grow no hotter."))
			return TRUE

		if(do_after(user, 1 SECONDS))
			current_fire++
			qdel(I)
			current_color = ingredient_colors[/obj/item/alch/firedust]

			to_chat(user, span_notice("The essence feeds the core. ([current_fire]/[needed_fire])"))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius))
		if(has_flower)
			to_chat(user, span_warning("The vessel already bears a fire within."))
			return TRUE

		if(has_crown)
			to_chat(user, span_warning("Why settle for a dream, when you already have the real deal?"))
			return TRUE

		if(do_after(user, 2 SECONDS))
			has_flower = TRUE
			qdel(I)
			current_color = ingredient_colors[/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius]

			to_chat(user, span_warning("The flower wilts… yet something answers. A lie, accepted."))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/clothing/head/roguetown/crown/serpcrown))
		if(has_crown)
			to_chat(user, span_warning("The vessel already bears true authority. But how can this be?"))
			return TRUE

		if(has_flower)
			to_chat(user, span_warning("The false fire burns away as if to make way for the real deal."))
			has_flower = FALSE

		if(do_after(user, 2 SECONDS))
			has_crown = TRUE
			qdel(I)
			current_color = ingredient_colors[/obj/item/clothing/head/roguetown/crown/serpcrown]

			to_chat(user, span_notice("The Crown resists… and soon submits. The fire of Astrata is stolen once more. You feel HIS smile upon you."))
			playsound(user, 'sound/misc/lava_death.ogg', 30, FALSE)

			update_icon()
			check_completion(user)
		return TRUE

	return TRUE

/obj/item/matthios_canister/truthsnuke/check_completion(mob/user)
	if(current_ash < needed_ash)
		return
	if(current_coaldust < needed_coaldust)
		return
	if(current_fire < needed_fire)
		return

	if(!has_crown && !has_flower)
		return

	alch_transform(user)

/obj/item/matthios_canister/truthsnuke/alch_transform(mob/user)
	to_chat(user, span_notice("The mixture collapses inward… then stabilizes."))

	if(has_crown)
		new /obj/item/impact_grenade/truthsnuke(get_turf(src))
	else
		new /obj/item/impact_grenade/truthsnuke/lesser(get_turf(src))
	funny_smoke(src)
	qdel(src)
*/

//EQUIPPABLES
/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded
	name = "strange gilded amulet"
	desc = "He was ever the one to make you ask questions: Why are we still here? Just to suffer? Nae. We are here to make a change. And a change we shall make, together."
	icon_state = "matthios"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	smeltresult = /obj/item/ash
	var/grant_chant = FALSE
	aura_color = "#ffe761"

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(obj_broken)
		return
	if(slot == (SLOT_NECK||SLOT_RING) && HAS_TRAIT(user, TRAIT_FREEMAN))
		if(!user.has_language(/datum/language/thievescant))
			to_chat(user, span_info("You gain insight on Thieves' Cant.<br><br><i>Keep in mind these are 'words' that come out as gestures, so blend it between normal speech to make it not so obvious.</i>"))
			user.grant_language(/datum/language/thievescant)
			grant_chant = TRUE
		else
			to_chat(user, span_info("You already know Thieves' Cant, but praise be Matthios."))

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user.get_item_by_slot((SLOT_NECK||SLOT_RING)) == src)
		if(grant_chant)
			to_chat(user, span_info("The knowledge fades from my mind."))
			user.remove_language(/datum/language/thievescant)
			grant_chant = FALSE

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios
	name = "gilded fingerless gloves"
	desc = "Those who grasp at Fyre, are bount to be burned."
	sewrepair = TRUE
	armor = ARMOR_LEATHER
	color = "#fce517" // we golden
	aura_color = "#fff385"

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(obj_broken)
		return
	if(slot == SLOT_GLOVES && HAS_TRAIT(user, TRAIT_FREEMAN))
		to_chat(user, span_info("Like Him, my hands ready to grasp the impossible."))
		ADD_TRAIT(user, TRAIT_SILENT_LOCKPICK, "matthiosboon")

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user.get_item_by_slot(SLOT_GLOVES) == src)
		to_chat(user, span_info("Once again, these hands are supplicant."))
		REMOVE_TRAIT(user, TRAIT_SILENT_LOCKPICK, "matthiosboon")

/obj/item/clothing/mask/rogue/spectacles/matthios
	name = "gilded spectacles"
	desc = "A drakkyne's eyes are oft blindsided by greed, yet such vision does hold some merit."
	armor = ARMOR_LEATHER
	color = "#faf5cb" // we golden
	aura_color = "#fffb00"

/obj/item/clothing/mask/rogue/spectacles/matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(obj_broken)
		return
	if(slot == SLOT_WEAR_MASK)
		if(HAS_TRAIT(user, TRAIT_FREEMAN))
			if(!user.has_status_effect(/datum/status_effect/buff/matthios_vision))
				to_chat(user, span_info("Gold gleams where truth once hid."))
				user.apply_status_effect(/datum/status_effect/buff/matthios_vision)
		else
			to_chat(user, span_warning("You look ridiculous and stupid. You are an amateur and a fool!"))

/obj/item/clothing/mask/rogue/spectacles/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user.get_item_by_slot(SLOT_WEAR_MASK) == src)
		to_chat(user, span_info("The gleam fades from my sight."))
		user.remove_status_effect(/datum/status_effect/buff/matthios_vision)

/atom/movable/screen/alert/status_effect/buff/matthios_vision
	name = "Gilded True Sight"
	desc = "Through Him, all is seen, and no locks shall bar me. Whether that it should be... is another matter."
	icon_state = "darkvision"

/datum/status_effect/buff/matthios_vision
	id = "matthios_vision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/matthios_vision
	duration = -1
	tick_interval = 15 SECONDS

/datum/status_effect/buff/matthios_vision/on_apply(mob/living/new_owner)
	. = ..()
	to_chat(owner, span_warning("The world sharpens. Nothing hides from His gaze, now yours."))
	ADD_TRAIT(owner, TRAIT_GILDED_SIGHT, "matthiosboon")
	ADD_TRAIT(owner, TRAIT_PSYCHOSIS, "matthiosboon")
	owner.update_sight()

/datum/status_effect/buff/matthios_vision/on_remove()
	. = ..()
	to_chat(owner, span_warning("The truth fades. Darkness returns, but so does peace."))
	REMOVE_TRAIT(owner, TRAIT_GILDED_SIGHT, "matthiosboon")
	REMOVE_TRAIT(owner, TRAIT_PSYCHOSIS, "matthiosboon")
	owner.update_sight()

/datum/status_effect/buff/matthios_vision/tick()
	. = ..()
	var/mob/living/carbon/crazymofo = owner
	var/pickLV = crazymofo.get_skill_level(/datum/skill/misc/lockpicking)
	var/miracleLV = crazymofo.get_skill_level(/datum/skill/magic/holy)
	var/hallucAMT = 62 - (miracleLV * 10)
	if(miracleLV <= SKILL_LEVEL_JOURNEYMAN || pickLV <= SKILL_LEVEL_JOURNEYMAN)
		if(prob(hallucAMT))
			crazymofo.adjustFireLoss(5)
		if(prob(hallucAMT))
			crazymofo.adjustFireLoss(10)
		if(prob(hallucAMT))
			crazymofo.adjustFireLoss(5)
		if(prob(hallucAMT))
			crazymofo.adjustFireLoss(5)
	if(crazymofo.hallucination < 200)
		crazymofo.hallucination += rand(1,hallucAMT)
		to_chat(crazymofo, span_warning(pick("Is this TRVE??","DAFUQ?","I am NOT meant to see this.","What... WHAT is this?","This doesn't make SENSE.","I don't UNDERSTAND.","Why does it LOOK like that?","Something is WRONG here.","I can't make SENSE of this.","This isn't RIGHT.","What am I looking at?","None of THIS adds up.","I shouldn't be SEEING this.","This feels... INCORRECT.","Why is everything like this?","I CAN'T process this.","This ISN'T how it should be.","I don't get it.","What is happening?","This is all WRONG.","I CAN'T tell what's REAL.","Why does it feel off?","I don't recognize this.","This SHOULDN'T exist.","What is THIS supposed to be?","I can't FOLLOW this.","This isn't making sense anymore.","I think SOMETHING is broke.", "Why can't I understand THIS?", "This feels IMPOSSIBLE.", "I don't KNOW what I'm seeing.")))
		crazymofo.Jitter(5)
		if(prob(10+hallucAMT))
			crazymofo.emote(pick("giggle","laugh","chuckle"))
	if(prob(10+hallucAMT) && crazymofo.hallucination > 100)
		crazymofo.blur_eyes(5)
		crazymofo.adjust_blurriness(10)
		crazymofo.blind_eyes(1.5)
		crazymofo.adjustBruteLoss(10)
		if(prob(10))
			crazymofo.emote("agony")
		to_chat(crazymofo, span_alert("MY EYES!!! THEY BURN!!!"))

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios //I guess in case someone wants to make generic muffled boots? Change it to muffle/matthios if you do
	name = "gilded leather boots"
	desc = "Those who bear His fyre often cower in its shadow."
	icon_state = "matthiosboots"
	sewrepair = TRUE
	armor = ARMOR_LEATHER
	color = "#fff9c0" // we golden
	aura_color = "#ffe600"

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_SHOES && HAS_TRAIT(user, TRAIT_FREEMAN))
		to_chat(user, span_info("Like Him, I slink into the shadows."))
		ADD_TRAIT(user, TRAIT_SILENT_FOOTSTEPS, "matthiosboon")
		ADD_TRAIT(user, TRAIT_LIGHT_STEP, "matthiosboon")

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.shoes == src)
		to_chat(user, span_info("Once again, I am under Her gaze."))
		REMOVE_TRAIT(user, TRAIT_SILENT_FOOTSTEPS, "matthiosboon")
		REMOVE_TRAIT(user, TRAIT_LIGHT_STEP, "matthiosboon")

//THROWABLES
/obj/item/impact_grenade/truthsnuke/lesser
	name = "Incomplete TRUTHSNUKE"
	desc = "A fragile canister, filled with an explosive surprise. Shards of flint line its thin sleeve, aching to ignite at the slightest disturbance. The fire of Astrata does not seem to be imbuing it, but..."

/obj/item/impact_grenade/truthsnuke/lesser/explodes()
	STOP_PROCESSING(SSfastprocess, src)

	var/turf/T = get_turf(src)
	if(!T)
		qdel(src)
		return

	for(var/mob/living/target in range(3, T))

		if(HAS_TRAIT(target, TRAIT_NOBLE) || HAS_TRAIT(target, TRAIT_CLERGY))
			target.visible_message(span_danger("[target]'s skin begins to SLOUGH AND BURN HORRIFICALLY, glowing like molten metal!"), span_userdanger("MY LIMBS BURN IN AGONY..."))
			target.Stun(80)
			target.emote("agony")
			target.adjustFireLoss(50)
			target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
			target.ignite_mob()
			playsound(target, 'sound/magic/churn.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			sleep(80)
			target.visible_message(span_danger("[target]'s limbs REND into coin and gem!"), span_userdanger("WEALTH. POWER. THE FINAL SIGHT UPON MYNE EYE IS A DRAGON'S MAW TEARING ME IN TWAIN. MY ENTRAILS ARE OF GOLD AND SILVER."))  		//this one's actually pretty good. i like this
			playsound(target, 'sound/magic/churn.ogg', 100, TRUE)
			playsound(target, 'sound/magic/whiteflame.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			new /obj/item/roguecoin/silver/pile(target.loc)
			new /obj/item/roguecoin/gold/pile(target.loc)
			new /obj/item/roguegem/random(target.loc)
			new /obj/item/roguegem/random(target.loc)
			var/list/possible_limbs = list()
			for(var/zone in list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
				var/obj/item/bodypart/limb = target.get_bodypart(zone)
				if(limb)
					possible_limbs += limb
				var/limbs_to_gib = min(rand(1, 4), possible_limbs.len)
				for(var/i in 1 to limbs_to_gib)
					var/obj/item/bodypart/selected_limb = pick(possible_limbs)
					possible_limbs -= selected_limb
					if(selected_limb?.drop_limb())
						var/turf/limb_turf = get_turf(selected_limb) || get_turf(target) || target.drop_location()
						if(limb_turf)
							new /obj/effect/decal/cleanable/blood/gibs/limb(limb_turf)
			target.death()
			continue

		var/is_heretic = HAS_TRAIT(target, TRAIT_FREEMAN) || HAS_TRAIT(target, TRAIT_CABAL) || HAS_TRAIT(target, TRAIT_HORDE) || HAS_TRAIT(target, TRAIT_DEPRAVED)
		target.apply_status_effect(/datum/status_effect/buff/alch/fire_resist)

		if(is_heretic)
			to_chat(target, span_artery("They called us Inhumen. They called this Heresy. Yet here we stand—unbroken, unburned. Let the world choke on truth."))
			target.visible_message(span_notice("[target] stands untouched amidst the inferno."))

		else
			target.emote("agony")
			target.Stun(2)
			target.Knockdown(2)
			target.adjustFireLoss(40)
			to_chat(target, span_artery("IT BURNS! THE TRUTH! IT BURNS!!!"))

	for(var/turf/affected in range(3, T))

		for(var/obj/structure/mineral_door/D in affected)
			if(!(D.resistance_flags & INDESTRUCTIBLE))
				qdel(D)

		for(var/obj/structure/roguewindow/W in affected)
			if(!(W.resistance_flags & INDESTRUCTIBLE))
				qdel(W)
		
		for(var/obj/O in affected)
			if(!(O.resistance_flags & INDESTRUCTIBLE))
				O.visible_message(span_danger("[O] is torn apart by the blast!"))
				qdel(O)

		if(istype(affected, /turf/closed) && !istype(affected, /turf/closed/indestructible))
			var/turf/closed/C = affected
			C.ChangeTurf(/turf/open/floor/rogue/dirt)
			continue

		if(istype(affected, /turf/open) && !istype(affected, /turf/open/floor/rogue/dirt))
			var/turf/open/O = affected
			O.ChangeTurf(/turf/open/floor/rogue/dirt)


	for(var/mob/living/M in range(3, T))
		var/dir = get_dir(T, M)
		M.throw_at(get_edge_target_turf(M, dir), 6, 3)

	explosion(T, devastation_range = 0,	heavy_impact_range = 0,	light_impact_range = 4, flame_range = 8, flash_range = 8, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
	qdel(src)

//I'll leave it as an admin spawnable cause why not, but as is right now there's no way anything can get access to this.
/obj/item/impact_grenade/truthsnuke
	name = "TRUTHSNUKE"
	desc = "A fragile canister, filled with an explosive surprise. Shards of flint line its thin sleeve, aching to ignite at the slightest disturbance. It glows with a divine might, and once again stolen fire."
	aura_color = "#fbff00"

/obj/item/impact_grenade/truthsnuke/explodes()
	STOP_PROCESSING(SSfastprocess, src)

	var/turf/T = get_turf(src)
	if(!T)
		qdel(src)
		return

	for(var/mob/living/target in range(15, T))

		if(HAS_TRAIT(target, TRAIT_NOBLE) || HAS_TRAIT(target, TRAIT_CLERGY))
			target.visible_message(span_danger("[target]'s skin begins to SLOUGH AND BURN HORRIFICALLY, glowing like molten metal!"), span_userdanger("MY LIMBS BURN IN AGONY..."))
			target.Stun(80)
			target.emote("agony")
			target.adjustFireLoss(50)
			target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
			target.ignite_mob()
			playsound(target, 'sound/magic/churn.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			sleep(80)
			target.visible_message(span_danger("[target]'s limbs REND into coin and gem!"), span_userdanger("WEALTH. POWER. THE FINAL SIGHT UPON MYNE EYE IS A DRAGON'S MAW TEARING ME IN TWAIN. MY ENTRAILS ARE OF GOLD AND SILVER."))  		//this one's actually pretty good. i like this
			playsound(target, 'sound/magic/churn.ogg', 100, TRUE)
			playsound(target, 'sound/magic/whiteflame.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			new /obj/item/roguecoin/silver/pile(target.loc)
			new /obj/item/roguecoin/gold/pile(target.loc)
			new /obj/item/roguegem/random(target.loc)
			new /obj/item/roguegem/random(target.loc)
			var/list/possible_limbs = list()
			for(var/zone in list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
				var/obj/item/bodypart/limb = target.get_bodypart(zone)
				if(limb)
					possible_limbs += limb
				var/limbs_to_gib = min(rand(1, 4), possible_limbs.len)
				for(var/i in 1 to limbs_to_gib)
					var/obj/item/bodypart/selected_limb = pick(possible_limbs)
					possible_limbs -= selected_limb
					if(selected_limb?.drop_limb())
						var/turf/limb_turf = get_turf(selected_limb) || get_turf(target) || target.drop_location()
						if(limb_turf)
							new /obj/effect/decal/cleanable/blood/gibs/limb(limb_turf)
			target.death()
			continue

		var/is_heretic = HAS_TRAIT(target, TRAIT_FREEMAN) || HAS_TRAIT(target, TRAIT_CABAL) || HAS_TRAIT(target, TRAIT_HORDE) || HAS_TRAIT(target, TRAIT_DEPRAVED)
		target.apply_status_effect(/datum/status_effect/buff/alch/fire_resist)

		if(is_heretic)
			to_chat(target, span_artery("They called us Inhumen. They called this Heresy. Yet here we stand—unbroken, unburned. Let the world choke on truth."))
			target.visible_message(span_notice("[target] stands untouched amidst the inferno."))

		else
			target.emote("agony")
			target.Stun(2)
			target.Knockdown(2)
			target.adjustFireLoss(40)
			to_chat(target, span_artery("IT BURNS! THE TRUTH! IT BURNS!!!"))

	for(var/turf/affected in range(15, T))

		for(var/obj/structure/mineral_door/D in affected)
			if(!(D.resistance_flags & INDESTRUCTIBLE))
				qdel(D)

		for(var/obj/structure/roguewindow/W in affected)
			if(!(W.resistance_flags & INDESTRUCTIBLE))
				qdel(W)
		
		for(var/obj/O in affected)
			if(!(O.resistance_flags & INDESTRUCTIBLE))
				O.visible_message(span_danger("[O] is torn apart by the blast!"))
				qdel(O)

		if(istype(affected, /turf/closed) && !istype(affected, /turf/closed/indestructible))
			var/turf/closed/C = affected
			C.ChangeTurf(/turf/open/floor/rogue/dirt)
			continue

		if(istype(affected, /turf/open) && !istype(affected, /turf/open/floor/rogue/dirt))
			var/turf/open/O = affected
			O.ChangeTurf(/turf/open/floor/rogue/dirt)


	for(var/mob/living/M in range(12, T))
		var/dir = get_dir(T, M)
		M.throw_at(get_edge_target_turf(M, dir), 6, 3)

	explosion(T, devastation_range = 0,	heavy_impact_range = 0,	light_impact_range = 10, flame_range = 15, flash_range = 15, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

	qdel(src)

/obj/item/impact_grenade/pocketsand
	name = "pocket sand"
	desc = "A fistful of fine, irritating sand. Guaranteed to be clawing at the eyes of the unwise."
	icon_state = "clod1"
	icon = 'icons/roguetown/items/natural.dmi'

/obj/item/impact_grenade/pocketsand/explodes()
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		for(var/mob/living/target in range(0, T))
			if(!target.mind || istype(target, /mob/living/simple_animal))
				target.adjustBruteLoss(5)
			if(iscarbon(target))
				target.blur_eyes(5)
				target.adjust_blurriness(10)
				target.blind_eyes(1.5)
			target.visible_message(
				span_warning("[target] is blasted with a cloud of sand!"),
				span_warning("Sand gets into my eyes! I can't see!")
			)
			target.emote("pain")
			target.apply_status_effect(/datum/status_effect/debuff/clickcd, 3 SECONDS)
		qdel(src)

//MISC

/datum/component/storage/concrete/roguetown/pouch/matthios
	screen_max_rows = 4
	screen_max_columns = 2

/obj/item/storage/belt/rogue/pouch/matthios
	aura_color = "#fff385"
	desc = "A small sack with a drawstring that allows it to be worn around the neck. Or at the hips, provided you have a belt. It has a strange, gilded glow to it."
	component_type = /datum/component/storage/concrete/roguetown/pouch/matthios

/obj/item/storage/belt/rogue/pouch/matthios/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, (TRAIT_FREEMAN||TRAIT_XYLIX), "BLESSED POUCH")

/obj/item/storage/backpack/rogue/backpack/matthios
	name = "smuggling bag"
	desc = "A sack tied with some 'blessed' rope. There is a carving of a grinning symbol within the side of it. It has a strange, gilded glow to it."
	aura_color = "#fff385"
	icon_state = "rucksack_untied"
	item_state = "rucksack"
	component_type = /datum/component/storage/concrete/roguetown/backpack
	max_integrity = 100

/obj/item/storage/backpack/rogue/backpack/matthios/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, (TRAIT_FREEMAN||TRAIT_XYLIX), "BLESSED RUCKSACK")

/obj/item/rope/chain/matthios
	name = "gilded chain"
	desc = "A heavy, gilded chain that thrums with latent divine power. It resonates negatively with the essence of nobility, as if stirred by divine rebuke."	
	color = "#fdff86"
	aura_color = "#fff385"
	matthios_chains = TRUE
	smeltresult = /obj/item/ash

/obj/item/melee/touch_attack/lesserknock/matthios
	name = "Gilded Lockpick"
	desc = "A golden, glowing lockpick that appears to be held together by the truth of Matthios. To dispel it, simply use it on anything that isn't a door."
	catchphrase = null
	possible_item_intents = list(/datum/intent/use)
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lockpick"
	color = "#eeff00" // we golden now, bij
	max_integrity = 20
	destroy_sound = 'sound/items/pickbreak.ogg'
	resistance_flags = FIRE_PROOF
	aura_color = "#ffe761"

/obj/item/melee/touch_attack/lesserknock/attack_self()
	qdel(src)
