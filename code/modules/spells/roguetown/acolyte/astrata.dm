/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/sacred_flame_rogue
	name = "Sacred Flame"
	desc = "Deals damage and ignites target, with extra damage done to undead."
	overlay_state = "sacredflame"
	base_icon_state = "regalyscroll"
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 25 SECONDS
	miracle = TRUE
	devotion_cost = 40
	projectile_type = /obj/projectile/magic/lightning/astratablast

/obj/projectile/magic/lightning/astratablast
	damage = 25
	name = "ray of holy fire"
	damage_type = BURN
	flag = "magic"
	light_color = "#a98107"
	light_outer_range = 7
	tracer_type = /obj/effect/projectile/tracer/solar_beam
	var/fuck_that_guy_multiplier = 2
	var/biotype_we_look_for = MOB_UNDEAD

/obj/projectile/magic/lightning/astratablast/on_hit(target, mob/user)
	if(!ismob(target))
		return FALSE
	var/mob/living/M = target
	if(M.anti_magic_check())
		visible_message(span_warning("[src] fizzles on contact with [target]!"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		qdel(src)
		return BULLET_ACT_BLOCK
	if(M.mob_biotypes & biotype_we_look_for || istype(M, /mob/living/simple_animal/hostile/rogue/skeleton) || !M.mind || istype(M, /mob/living/simple_animal)) //PVE
		damage *= fuck_that_guy_multiplier
	M.adjust_fire_stacks(4)
	M.ignite_mob()
	visible_message(span_warning("[src] ignites [target] in holy flame!"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/ignition
	name = "Ignition"
	desc = "Ignites target, living or object. No cooldown on objects."
	overlay_state = "sacredflame"
	base_icon_state = "regalyscroll"
	releasedrain = 15
	chargedrain = 0
	chargetime = 0
	range = 15
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/heal.ogg'
	invocations = list("Flame.")
	invocation_type = "whisper"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	miracle = TRUE
	devotion_cost = 15
	var/rechargefast = FALSE

/obj/effect/proc_holder/spell/invoked/ignition/cast(list/targets, mob/user = usr)
	..()
	. = ..()
	rechargefast = FALSE
	if(isliving(targets[1]))
		var/mob/living/L = targets[1]
		user.visible_message("<font color='yellow'>[user] points at [L]!</font>")
		if(L.anti_magic_check(TRUE, TRUE))
			return FALSE
		if(spell_guard_check(L, TRUE))
			L.visible_message(span_warning("[L] shields against the divine flame!"))
			return TRUE
		L.adjust_fire_stacks(2)
		L.ignite_mob()

		return TRUE

	// Spell interaction with ignitable objects (burn wooden things, light torches up)
	else if(isobj(targets[1]))
		var/obj/O = targets[1]
		if(O.fire_act())
			user.visible_message("<font color='yellow'>[user] points at [O], igniting it with sacred flames!</font>")
			O.fire_act()
			rechargefast = TRUE
			return TRUE
		else
			to_chat(user, span_warning("You point at [O], but it fails to catch fire."))
			return FALSE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/ignition/start_recharge()
	if(rechargefast)
		charge_counter = max(recharge_time - (1.5 SECONDS), 0)
		if(action)
			action.UpdateButtonIcon()
		STOP_PROCESSING(SSfastprocess, src)
		return
	. = ..()

/obj/effect/proc_holder/spell/invoked/ignition/after_cast(list/targets, mob/user = usr)
	. = ..()
	rechargefast = FALSE

/obj/effect/proc_holder/spell/invoked/revive
	name = "Anastasis"
	desc = "Focus Astratas energy through a stationary psycross, reviving the target from death."
	overlay_state = "revive"
	base_icon_state = "regalyscroll"
	releasedrain = 90
	chargedrain = 0
	chargetime = 50
	range = 1
	warnie = "sydwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/revive.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 2 MINUTES
	miracle = TRUE
	devotion_cost = 80
	/// Amount of PQ gained for reviving people
	var/revive_pq = PQ_GAIN_REVIVE

/obj/effect/proc_holder/spell/invoked/revive/start_recharge()
	var/old_recharge = recharge_time
	// Because the cooldown for anastasis is so incredibly low, not having tech impacts them more heavily than other faiths
	var/tech_resurrection_modifier = SSchimeric_tech.get_resurrection_multiplier()
	if(tech_resurrection_modifier > 1)
		recharge_time = initial(recharge_time) * (tech_resurrection_modifier * 1.25)
	else
		recharge_time = initial(recharge_time)
	if(charge_counter >= old_recharge && old_recharge > 0)
		charge_counter = recharge_time
	. = ..()

/obj/effect/proc_holder/spell/invoked/revive/cast(list/targets, mob/living/user)
	..()

	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	if(!target.check_revive(user))
		revert_cast()
		return FALSE
	if(GLOB.tod == "night")
		to_chat(user, span_warning("Let there be light."))
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		S.AOE_flash(user, range = 8)
	if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
		target.visible_message(
			span_danger("[target] is unmade by holy light!"),
			span_userdanger("I'm unmade by holy light!")
		)
		target.gib()
		return TRUE
	if(alert(target, "They are calling for you. Are you ready?", "Revival", "I need to wake up", "Don't let me go") != "I need to wake up")
		target.visible_message(span_notice("Nothing happens. They are not being let go."))
		return FALSE
	target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
	if(!target.revive(full_heal = FALSE))
		to_chat(user, span_warning("Nothing happens."))
		revert_cast()
		return FALSE

	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
	//GET OVER HERE!
	if(underworld_spirit)
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		qdel(underworld_spirit)
		ghost.mind.transfer_to(target, TRUE)
	target.grab_ghost(force = TRUE) // even suicides
	target.emote("breathgasp")
	target.Jitter(100)
	record_round_statistic(STATS_ASTRATA_REVIVALS)
	target.update_body()
	target.visible_message(span_notice("[target] is revived by holy light!"), span_green("I awake from the void."))
	if(revive_pq && !HAS_TRAIT(target, TRAIT_IWASREVIVED) && user?.ckey)
		adjust_playerquality(revive_pq, user.ckey)
		ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
	target.mind.remove_antag_datum(/datum/antagonist/zombie)
	target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it - Failsafe for it.
	target.apply_status_effect(/datum/status_effect/debuff/revived)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
	return TRUE

/obj/effect/proc_holder/spell/invoked/revive/cast_check(skipcharge, mob/user = usr)
	if(!..())
		return FALSE
	var/found = null
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		found = S
	if(!found)
		to_chat(user, span_warning("I need a holy cross."))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/astrataspark
	name = "Flame Order"
	desc = "Casting on a fire-based light source will make a searing explosion in a 3x3 area around the light source. \n\
	Casting on a burning mob will double their fire stacks.\n\
	Casting on yourself will ignite any flammable object in a 3x3 area around yourself."
	clothes_req = FALSE
	overlay_state = "astraflame"
	base_icon_state = "regalyscroll"
	sound = 'sound/magic/whiteflame.ogg'
	range = 8
	releasedrain = 30
	chargedrain = 1
	chargetime = 15
	recharge_time = 15 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokeholy
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	invocations = list("Fulmen!")
	invocation_type = "shout"
	var/firemodificator = 2
	devotion_cost = 50
	miracle = TRUE

/obj/effect/proc_holder/spell/invoked/astrataspark/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])
	if(T.z != user.z)
		to_chat(span_warning("You cannot cast this spell on a different z-level!"))
		revert_cast()
		return FALSE
	for(var/obj/effect/hotspot/H in T.contents)
		new /obj/effect/temp_visual/firewave/spark(T)
		sleep(1 SECONDS)
		explosion(T, -1, 0, 0, 0, 0, flame_range = 2, soundin = 'sound/misc/explode/incendiary (1).ogg')
	for(var/obj/machinery/light/rogue/O in T.contents)
		O.fire_act()
		new /obj/effect/temp_visual/firewave/spark(T)
		sleep(2 SECONDS)
		explosion(T, -1, 0, 0, 0, 0, flame_range = 2, soundin = 'sound/misc/explode/incendiary (1).ogg')
		sleep(12 SECONDS)
		O.extinguish()
	for(var/mob/living/L in T.contents) //doubles firestacks
		if(L == user)
			var/checkrange = 3 + user.get_skill_level(/datum/skill/magic/holy)
			for(var/obj/machinery/light/rogue/O in range(checkrange, user))
				O.fire_act()
			return TRUE
		if(L.anti_magic_check())
			L.visible_message(span_warning("The magic fades away around [L]!"))
			playsound(L, 'sound/magic/magic_nulled.ogg', 100)
			return
		if(spell_guard_check(L, TRUE))
			L.visible_message(span_warning("[L] resists the flame order!"))
			return TRUE
		if(L.fire_stacks != 0)
			if(L.fire_stacks >= 20) //cap
				firemodificator = 0 //any*0 = 0
			if(!L.mind || istype(L, /mob/living/simple_animal)) //PVE stuff. Fire not effective weapon.
				L.adjustFireLoss(10*L.fire_stacks) //Simple or carbon-AI creatures take 10 damage * 1 firestack.
				if(iscarbon(L)) //Carbon AI momentaly removes their firestaks.
					var/mob/living/carbon/C = L
					C.adjustFireLoss(C.getFireLoss()) //Double burn damage.
			var/firest = L.fire_stacks*firemodificator
			new /obj/effect/temp_visual/firewave/spark(T)
			sleep(1 SECONDS)
			L.adjust_fire_stacks(round(firest))
	if(istype(T, /turf/open/lava))
		new /obj/effect/temp_visual/firewave/spark(T)
		sleep(2 SECONDS)
		explosion(T, -1, 0, 0, 0, 0, flame_range = 3, soundin = 'sound/misc/explode/incendiary (1).ogg')
	return TRUE

/obj/effect/temp_visual/firewave/spark
	icon_state = "flame"
	duration = 20

//T0. Removes cone vision for a dynamic duration.
/obj/effect/proc_holder/spell/self/astrata_gaze
	name = "Astratan Gaze"
	desc = "Removes the limit on your vision, letting you see behind you for a time, lasts longer during the dae and gives a perception bonus to those skilled and holy arts."
	overlay_state = "astrata_gaze"
	base_icon_state = "regalyscroll"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = 'sound/magic/astrata_choir.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	invocations = list("Astrata show me true.")
	invocation_type = "shout"
	recharge_time = 90 SECONDS
	devotion_cost = 30
	miracle = TRUE

/obj/effect/proc_holder/spell/self/astrata_gaze/cast(list/targets, mob/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	H.apply_status_effect(/datum/status_effect/buff/astrata_gaze, user.get_skill_level(associated_skill))
	return TRUE

/atom/movable/screen/alert/status_effect/buff/astrata_gaze
	name = "Astratan's Gaze"
	desc = "She shines through me, illuminating all injustice."
	icon_state = "astrata_gaze"

/datum/status_effect/buff/astrata_gaze
	id = "astratagaze"
	alert_type = /atom/movable/screen/alert/status_effect/buff/astrata_gaze
	duration = 20 SECONDS

/datum/status_effect/buff/astrata_gaze/on_creation(mob/living/new_owner, assocskill)
	var/per_bonus = 0
	if(assocskill)
		if(assocskill > SKILL_LEVEL_NOVICE)
			per_bonus++
		duration *= assocskill
	if(GLOB.tod == "day" || GLOB.tod == "dawn" || GLOB.tod == "dusk") //dusk added, so long nights.
		per_bonus++
		duration *= 2
	if(per_bonus > 0)
		effectedstats = list(STATKEY_PER = per_bonus)
	. = ..()

/datum/status_effect/buff/astrata_gaze/on_apply(assocskill)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.viewcone_override = TRUE
		H.hide_cone()
		H.update_cone_show()
	to_chat(owner, span_info("She shines through me! I can perceive all clear as dae!"))
	. = ..()

/datum/status_effect/buff/astrata_gaze/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.viewcone_override = FALSE
		H.hide_cone()
		H.update_cone_show()

/obj/effect/proc_holder/spell/self/astrata_fireresist
	name = "Flame Body"
	desc = "Hide from the fire under the gaze of Astrata"
	overlay_state = "createlight"
	base_icon_state = "regalyscroll"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = 'sound/magic/astrata_choir.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	invocations = list("Accincti flammis.")
	invocation_type = "whisper"
	recharge_time = 0
	devotion_cost = 30
	miracle = TRUE

/obj/effect/proc_holder/spell/self/astrata_fireresist/cast(mob/living/carbon/human/user)
	var/skill = user.get_skill_level(/datum/skill/magic/holy)
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

	if(user.has_status_effect(/datum/status_effect/buff/dragonhide/fireresist))
		user.remove_status_effect(/datum/status_effect/buff/dragonhide/fireresist)
		user.remove_status_effect(/datum/status_effect/buff/dragonhide/fireresist/buff)
		user.fire_stacks = 0
		return TRUE
	else
		user.visible_message("[user] mutters an incantation and their skin hardens like coal.")
		if(skill >= 4) //Expert++
			user.apply_status_effect(/datum/status_effect/buff/dragonhide/fireresist/buff)
		else
			user.apply_status_effect(/datum/status_effect/buff/dragonhide/fireresist)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/dragonhide/fireresist
	name = "Fire Resistance"
	desc = "Flames dance at my heels, yet do not sting!"
	icon_state = "fire"

/datum/status_effect/buff/dragonhide/fireresist
	id = "fireresist"
	examine_text = "<font color='red'>SUBJECTPRONOUN is shielded by a veil of sacred flame!</font>"
	alert_type = /atom/movable/screen/alert/status_effect/buff/dragonhide/fireresist
	effectedstats = list(STATKEY_CON = -1) //Target body loosing CON, but getting fireresist.
	duration = 11 SECONDS

/datum/status_effect/buff/dragonhide/fireresist/on_apply()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(continue_proc), src), wait = (10 SECONDS))

/datum/status_effect/buff/dragonhide/fireresist/proc/continue_proc()
	var/mob/living/carbon/human/user = owner
	var/skill = user.get_skill_level(/datum/skill/magic/holy)
	var/cost = 30 //Novice
	switch(skill)
		if(2)
			cost = 25
		if(3)
			cost = 20
		if(4)
			cost = 10
		if(5)
			cost = 5
		if(6)
			cost = 0
	if(user.has_status_effect(/datum/status_effect/buff/dragonhide/fireresist) || user.has_status_effect(/datum/status_effect/buff/dragonhide/fireresist/buff))
		if((user.devotion?.devotion - cost) < 0)
			to_chat(user, span_warning("I do not have enough devotion!"))
			return
		user.devotion?.update_devotion(-cost)
		if(cost != 0)
			to_chat(user, "<font color='purple'>I lose [cost] devotion!</font>")
		if(skill >= 4) //Expert++
			user.apply_status_effect(/datum/status_effect/buff/dragonhide/fireresist/buff)
		else
			user.apply_status_effect(/datum/status_effect/buff/dragonhide/fireresist)
		addtimer(CALLBACK(src, PROC_REF(continue_proc), src), wait = (10 SECONDS))
	else
		return

/datum/status_effect/buff/dragonhide/fireresist/buff //you can step on lava

/datum/status_effect/buff/dragonhide/fireresist/buff/on_apply()
	. = ..()
	addtimer(CALLBACK(owner, PROC_REF(continue_proc), src), wait = (15 SECONDS))
	owner.weather_immunities += "lava"

/datum/status_effect/buff/dragonhide/fireresist/buff/on_remove()
	. = ..()
	owner.weather_immunities -= "lava"

/obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/astratagrasp // ASTRATAN HERETIC EXCLUSIVE
	name = "Astrata's Grasp"
	desc = "HER fire burnet eaternae. Summon Her flame from your soul and let it envelop your hand. Use on ashes, fire dust and fyritius flowers to convert them into devotion. Can ignite objects. Consumes fire stacks on people to do extra damage."
	clothes_req = FALSE
	drawmessage = "I prepare to perform a divine incantation."
	dropmessage = "I release my divine focus."
	overlay_state = "astratagrasp"
	base_icon_state = "regalyscroll"
	chargedrain = 0
	chargetime = 0
	releasedrain = 5 // this influences -every- cost involved in the spell's functionality, if you want to edit specific features, do so in handle_cost
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	hand_path = /obj/item/melee/touch_attack/rogueweapon/astratagrasp
	devotion_cost = 30
	miracle = TRUE

/obj/item/melee/touch_attack/rogueweapon/astratagrasp
	name = "Burning Hand"
	desc = "The Sacred Flame of Astrata"
	icon = 'icons/roguetown/misc/miraclestuff.dmi'
	mob_overlay_icon = 'icons/roguetown/misc/miraclestuff.dmi'
	lefthand_file = 'icons/roguetown/misc/miraclestuff.dmi'
	righthand_file = 'icons/roguetown/misc/miraclestuff.dmi'
	sleeved = 'icons/roguetown/misc/miraclestuff.dmi'
	icon_state = "flamei"
	item_state = "flameh"
	color = "#ffbb00ff"
	possible_item_intents = list(/datum/intent/mace/strike/astrata, /datum/intent/mace/smash/astrata, /datum/intent/use)
	tool_behaviour = TOOL_CAUTERY
	parrysound = list('sound/magic/magic_nulled.ogg')
	swingsound = list('sound/items/firelight.ogg')
	attached_spell = /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/astratagrasp
	wbalance = WBALANCE_HEAVY
	force = 0
	damtype = BURN
	wdefense = 0
	associated_skill = /datum/skill/magic/holy //EHEHEHEHEHEH
	can_parry = TRUE
	var/takespeed = 5
	var/fprob = 0
	var/cooldown = FALSE

/datum/intent/mace/strike/astrata
	hitsound = list('sound/items/firelight.ogg', 'sound/misc/frying.ogg', 'sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg')

/datum/intent/mace/smash/astrata
	hitsound = list('sound/items/firelight.ogg', 'sound/misc/frying.ogg', 'sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg')

/obj/item/melee/touch_attack/rogueweapon/astratagrasp/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(skillcheck), src), wait = 1)
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	item_flags |= SURGICAL_TOOL

/obj/item/melee/touch_attack/rogueweapon/astratagrasp/attack(mob/target, mob/living/carbon/user)
	if(!iscarbon(user)) //Look ma, no hands
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, "<span class='warning'>I cannot reach out!</span>")
		return
	..()

/obj/item/melee/touch_attack/rogueweapon/astratagrasp/proc/skillcheck()
	var/skill = usr.get_skill_level(/datum/skill/magic/holy)
	wdefense += skill
	wdefense_dynamic += skill
	fprob = 10 * skill
	if(skill <= 4)
		force = 5 * skill
	else
		force = 20

/obj/item/melee/touch_attack/rogueweapon/astratagrasp/attack_self()
	attached_spell.remove_hand()
	qdel(src)

/obj/item/melee/touch_attack/rogueweapon/astratagrasp/proc/cooldown()
	cooldown = FALSE

/obj/item/melee/touch_attack/rogueweapon/astratagrasp/afterattack(atom/target, mob/living/carbon/user, params, proximity)
	if(istype(user.a_intent, /datum/intent/use))
		if(isliving(target))
			var/mob/living/M = target
			var/skill = usr.get_skill_level(/datum/skill/magic/holy)
			if(M.fire_stacks <= 0)
				return
			if(cooldown)
				return
			if(skill == 1) //Nope, devoute user.
				return
			user.visible_message("<font color='yellow'>[user] points at [M], flame rends out!</font>")
			M.extinguish_mob()
			cooldown = TRUE
			addtimer(CALLBACK(src, PROC_REF(cooldown), src), wait = 5 SECONDS)
		if(isobj(target))
			var/obj/item/O = target
			var/mob/living/carbon/human/H = usr
			var/cost = 0
			var/dist = get_dist(O, user)
			if(dist > 1)
				return
			if(istype(O, /obj/item/ash))
				cost = 20
			if(istype(O, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius))
				cost = 50
			if(istype(O, /obj/item/alch/firedust))
				cost = 100
			if(cost >= 20)
				H.devotion?.update_devotion(cost)
				to_chat(user, "<font color='purple'>I gain [cost] devotion!</font>")
				qdel(O)
		return
	if(isliving(target))
		var/mob/living/M = target
		var/dist = get_dist(M, user)
		if(dist > 1)
			return
		if(istype(user.a_intent, /datum/intent/mace/smash/astrata))
			var/fire_stacks = M.fire_stacks
			if(fire_stacks > 4)
				M.adjustFireLoss(fire_stacks * 5) //i am confident in your ability to kill someone after doing this much damage
				M.adjust_fire_stacks(-fire_stacks)
				M.extinguish_mob()
				return
		if(prob(fprob))
			M.adjust_fire_stacks(1)
			M.ignite_mob()
	return

/obj/item/melee/touch_attack/rogueweapon/astratagrasp/pre_attack(atom/target, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	if(isliving(target))
		var/mob/living/L = target
		L.spark_act()
	if(isobj(target))
		var/obj/O = target
		O.fire_act()
	return ..()

// =====================
// Immolation Component
// =====================
/datum/component/immolation
	var/mob/living/carbon/caster
	var/mob/living/carbon/partner
	var/duration = 360 SECONDS
	var/max_distance = 7
	var/self_damage
	var/base_damage
	var/damage_amplifier
	var/target_bonus = 0.75
	var/simple_mob_bonus = 2.5
	var/ispartner = FALSE
	var/immolate = FALSE
	can_transfer = TRUE
	var/damage_cooldown = 1 SECONDS // Damage applied every second
	var/next_damage = 0
	var/message_cooldown = 8 SECONDS
	var/next_message = 0

/datum/component/immolation/partner
	ispartner = TRUE
	immolate = TRUE

/datum/component/immolation/Initialize(mob/living/partner_mob, mob/living/carbon/caster_mob, var/holy_skill, var/is_astrata)
	if(!isliving(parent) || !iscarbon(partner_mob))
		return COMPONENT_INCOMPATIBLE

	// Prevent duplicate immolation
	if(parent.GetComponent(/datum/component/immolation))
		return COMPONENT_INCOMPATIBLE

	caster = caster_mob
	partner = partner_mob

	// Configure damage based on patron and skill
	base_damage = 8
	self_damage = 0.95
	damage_amplifier = 0.95

	if(holy_skill >= 3)
		self_damage -= 0.1 // 85%
		damage_amplifier += 0.15 // 110%
	if(is_astrata)
		self_damage -= 0.1 // 75%
		damage_amplifier += 0.15 // 125%

	// Set up processing and expiration
	START_PROCESSING(SSprocessing, src)
	RegisterSignal(parent, COMSIG_LIVING_MIRACLE_HEAL_APPLY, PROC_REF(on_heal))
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(on_deletion))
	addtimer(CALLBACK(src, .proc/remove_immolation), duration)

	// Apply visual effect
	var/mob/living/L = parent
	if(parent == caster)
		L.apply_status_effect(/datum/status_effect/immolation, FALSE)
	else
		L.apply_status_effect(/datum/status_effect/immolation, TRUE)
	return ..()

/datum/component/immolation/proc/on_deletion()
	remove_immolation()

/datum/component/immolation/proc/on_heal()
	// Healing is removed.
	partner.remove_status_effect(/datum/status_effect/buff/healing)

/datum/component/immolation/process()
	if(!istype(partner) || !istype(caster) || partner.stat == DEAD || caster.stat != CONSCIOUS || get_dist(partner, caster) > max_distance)
		remove_immolation()
		return FALSE
	return TRUE

/datum/component/immolation/partner/process()
	if(!..()) // Parent handles removal checks
		return

	if(world.time < next_damage)
		return
	next_damage = world.time + damage_cooldown

	// Get all living mobs in 2 tiles range
	var/list/targets = list()
	for(var/mob/living/L in view(2, partner))
		if(L == partner || L == caster || L.stat == DEAD)
			continue
		targets += L

	var/num_targets = targets.len
	var/damage_modifier = damage_amplifier + (target_bonus * (num_targets - 1))
	var/total_damage = base_damage * damage_modifier
	var/damage_per_target = num_targets > 0 ? total_damage / num_targets : 0

	// Apply damage to targets
	for(var/mob/living/target in targets)
		// Apply to random limb for carbons
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/static/list/valid_limbs = list(
				BODY_ZONE_CHEST,
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_LEG,
				BODY_ZONE_R_LEG
			)

			// Get all existing limbs that are valid
			var/list/obj/item/bodypart/possible_limbs = list()
			for(var/zone in valid_limbs)
				var/obj/item/bodypart/BP = C.get_bodypart(zone)
				if(BP)
					possible_limbs += BP

			if(possible_limbs.len)
				// Select random limb
				var/obj/item/bodypart/BP = pick(possible_limbs)
				BP.receive_damage(damage_per_target)

				if(world.time > next_message)
					C.visible_message(span_danger("[C]'s [BP.name] is cut by holy flames!"))
					next_message = world.time + message_cooldown
				target.update_damage_overlays()

				// Dismember limb if damage exceeds max
				if(BP.brute_dam >= BP.max_damage)
					BP.dismember()
					C.visible_message(span_danger("[C]'s [BP.name] is dismembered violently by cutting flames!"))
		else
			// Simple brute damage for non-carbons
			target.adjustBruteLoss(damage_per_target * simple_mob_bonus)
			if(world.time > next_message)
				target.visible_message(span_danger("[target] is cut by holy flames!"))
				next_message = world.time + message_cooldown

	// Apply self-damage to caster
	if(num_targets > 0)
		partner.adjustBruteLoss(base_damage * self_damage)
	else
		partner.adjustBruteLoss(1) // Minimal damage when no targets

/datum/component/immolation/proc/remove_immolation()
	var/mob/living/L = parent
	if(L)
		L.remove_status_effect(/datum/status_effect/immolation)
		UnregisterSignal(L, list(
			COMSIG_LIVING_MIRACLE_HEAL_APPLY,
			COMSIG_PARENT_QDELETING
		))

	if(partner)
		partner.remove_status_effect(/datum/status_effect/immolation)
		var/datum/component/immolation/other = partner.GetComponent(/datum/component/immolation)
		if(other)
			other.partner = null
			qdel(other)

	partner = null
	STOP_PROCESSING(SSprocessing, src)
	qdel(src)

// =====================
// Immolation Spell
// =====================
/obj/effect/proc_holder/spell/invoked/immolation
	name = "Immolation"
	desc = "Ignite a target in holy flames, burning those that surround them. Fire burns brighter within devout Astratans."
	overlay_state = "immolation"
	base_icon_state = "regalyscroll"
	range = 2
	chargetime = 0.5 SECONDS
	invocations = list("By sacred fire, be cleansed!")
	sound = 'sound/magic/fireball.ogg'
	recharge_time = 600 SECONDS
	miracle = TRUE
	devotion_cost = 60
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/immolation/cast(list/targets, mob/living/user)
	var/mob/living/carbon/target = targets[1]

	var/datum/component/immolation/existing = user.GetComponent(/datum/component/immolation)
	if(existing)
		to_chat(user, span_warning("You are already channeling someone"))
		revert_cast()
		return FALSE

	if(!istype(target, /mob/living/carbon) || target == user)
		revert_cast()
		return FALSE

	if(spell_guard_check(target, TRUE))
		target.visible_message(span_warning("[target] resists the immolation!"))
		return TRUE

	// Channeling requirement
	user.visible_message(span_danger("[user] begins lighting [target] ablaze with strange, divine fire!"))
	if(!do_after(user, 1 SECONDS, target = target))
		to_chat(user, span_warning("Astratan might requires unwavering focus to channel!"))
		revert_cast()
		return FALSE

	// Get caster properties
	var/holy_skill = target.get_skill_level(associated_skill)
	var/is_astrata = (istype(target.patron, /datum/patron/divine/astrata))

	// Apply component
	user.AddComponent(/datum/component/immolation, target, user, holy_skill, is_astrata)
	target.AddComponent(/datum/component/immolation/partner, target, user, holy_skill, is_astrata)

	// Visual feedback
	user.visible_message(span_notice("Holy flames erupt from [user]'s hands and engulf [target]!"))
	if(!is_astrata)
		target.visible_message(span_danger("[target] lights ablaze with sacred fire. Fire cutting like a blade in a small area around them."))
	else
		target.visible_message(span_danger("[target] lights ablaze with a grand, roaring pyre of divinity. Fire slashing violently like a blade in a small area around them."))
	return TRUE

// =====================
// Immolation Status Effect
// =====================
#define IMMOLATION_FILTER "immolation_glow"

/datum/status_effect/immolation
	id = "immolation"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/immolation
	var/outline_colour = "#FF4500"
	var/flaming_hot = FALSE

/atom/movable/screen/alert/status_effect/immolation
	name = "Immolated"
	desc = "Holy flames consume you! Anyone will be cut down for stepping near."
	icon_state = "immolation"

/datum/status_effect/immolation/on_creation(mob/living/new_owner, light_ablaze)
	flaming_hot = light_ablaze
	. = ..()
	if(!flaming_hot)
		linked_alert.desc = "I'm channeling Immolation onto someone to burn all those that step near, I must remain close to them."

/datum/status_effect/immolation/on_apply()
	if(!owner.get_filter(IMMOLATION_FILTER))
		owner.add_filter(IMMOLATION_FILTER, 2, list(
			"type" = "outline",
			"color" = outline_colour,
			"alpha" = 60,
			"size" = 2,
		))
	if(flaming_hot)
		new/obj/effect/dummy/lighting_obj/moblight/fire(owner)
		var/fire_icon = "Generic_mob_burning"
		var/mutable_appearance/new_fire_overlay = mutable_appearance('icons/mob/OnFire.dmi', fire_icon, -FIRE_LAYER)
		new_fire_overlay.color = list(0,0,0, 0,0,0, 0,0,0, 1,1,1)
		new_fire_overlay.appearance_flags = RESET_COLOR
		owner.overlays_standing[FIRE_LAYER] = new_fire_overlay
		owner.apply_overlay(FIRE_LAYER)
	return TRUE

/datum/status_effect/immolation/on_remove()
	owner.remove_filter(IMMOLATION_FILTER)
	if(flaming_hot)
		for(var/obj/effect/dummy/lighting_obj/moblight/fire/F in owner)
			qdel(F)
			owner.remove_overlay(FIRE_LAYER)

#undef IMMOLATION_FILTER

//T4 spell. Very slow turf-target ability to cast on day or in churh/nearby Bishop. Take devostating damage, gibs all not-pantheon carbons and kill all pantheon users.

/obj/effect/proc_holder/spell/invoked/sunstrike
	name = "Sun Strike"
	desc = "Focus Astratas energy through a stationary Psycross or Bishop's hands. Call down the mercy of the Sun Goddess upon the enemy."
	overlay_state = "sunstrike"
	base_icon_state = "regalyscroll"
	releasedrain = 200
	chargedrain = 0
	chargetime = 50
	range = 1
	warnie = "sydwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/revive.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 20 MINUTES //One per day
	miracle = TRUE
	devotion_cost = 200

/obj/effect/proc_holder/spell/invoked/sunstrike/start_recharge()
	var/old_recharge = recharge_time
	var/tech_resurrection_modifier = SSchimeric_tech.get_resurrection_multiplier()
	if(tech_resurrection_modifier > 1)
		recharge_time = initial(recharge_time) * (tech_resurrection_modifier * 1.25)
	else
		recharge_time = initial(recharge_time)
	if(charge_counter >= old_recharge && old_recharge > 0)
		charge_counter = recharge_time
	. = ..()

/obj/effect/proc_holder/spell/invoked/sunstrike/cast(list/targets, mob/living/user)
	..()

	if(!isliving(user))
		revert_cast()
		return FALSE
	var/check = null
	var/turf/target = get_turf(targets[1])
	for(var/turf/T in view(5, user))
		var/area/rogue/mercyarea = get_area(T)
		if(mercyarea.holy_area)
			check = 1
	if(GLOB.tod != "night")
		check = 1
	else
		to_chat(user, span_warning("Let there be light."))
	if(!check)
		revert_cast()
		return FALSE
	var/obj/effect/temp_visual/mark = new /obj/effect/temp_visual/firewave/sun_mark/pre_sunstrike(target)

	animate(mark, alpha = 255, time = 20, flags = ANIMATION_PARALLEL)

	var/obj/effect/temp_visual/mark_on_user = new /obj/effect/temp_visual/firewave/sun_mark(get_turf(user))
	animate(mark_on_user, alpha = 255, time = 20, flags = ANIMATION_PARALLEL)
	if(!do_after(user, 20 SECONDS, target = target))
		mark_on_user.alpha = 255
		to_chat(user, span_warning("Astratan might requires unwavering focus to channel!"))
		qdel(mark)
		qdel(mark_on_user)
		revert_cast()
		return FALSE
	qdel(mark_on_user)
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		S.AOE_flash(user, range = 8)
	new /obj/effect/temp_visual/firewave/sunstrike/primary(target)

/obj/effect/proc_holder/spell/invoked/sunstrike/cast_check(skipcharge, mob/user = usr)
	if(!..())
		return FALSE
	var/found = null
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		found = S
	for(var/turf/T in view(5, user))
		var/area/rogue/mercyarea = get_area(T)
		if(mercyarea.holy_area)
			found = T
	for(var/mob/living/carbon/human/H in view(7, user))
		if(H.mind?.assigned_role == "Bishop")
			found = H
	if(!found)
		to_chat(user, span_warning("I need to be near a Holy Cross, the Bishop or on Holy Land to cast it."))
		revert_cast()
		return FALSE
	return TRUE

/obj/effect/temp_visual/firewave/sun_mark
	icon = 'icons/effects/160x160.dmi'
	icon_state = "sun"
	alpha = 5
	duration = 1 MINUTES
	pixel_x = -64
	pixel_y = -64
	light_outer_range = 5
	light_color = "#ffb300ff"

/obj/effect/temp_visual/firewave/sun_mark/pre_sunstrike
	duration = 30 SECONDS

/obj/effect/temp_visual/firewave/sunstrike/primary
	alpha = 0
	duration = 11 SECONDS

/obj/effect/temp_visual/firewave/sunbeam
	icon = 'icons/effects/32x96.dmi'
	icon_state = "sunstrike"
	alpha = 5
	duration = 15.5

/obj/effect/temp_visual/firewave/sunstrike/primary/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/effect/temp_visual/firewave/sunstrike/primary, pre_strike), TRUE), 1 SECONDS)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/effect/temp_visual/firewave/sunstrike/primary, strike), TRUE), 10 SECONDS)

/obj/effect/temp_visual/firewave/sunstrike/primary/proc/pre_strike()
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/revive.ogg', 80, TRUE)
	loud_message("<font size = 9>[span_purple("THE SKY IS FLOODED WITH WHITE FIRE!!")]</font><br>", hearing_distance = 14)

	for(var/turf/Target_turf in range(1, get_turf(src)))
		for(var/mob/living/L in Target_turf.contents)
			to_chat(L, span_userdanger("I feel a terrifyingly heavy gaze upon me!!"))

/obj/effect/temp_visual/firewave/sunstrike/primary/proc/strike()
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/astrata_choir.ogg', 100, TRUE)
	explosion(T, -1, 0, 0, 0, 0, flame_range = 0, soundin = 'sound/misc/explode/incendiary (1).ogg')
	var/obj/effect/temp_visual/mark = new /obj/effect/temp_visual/firewave/sunbeam(T)

	animate(mark, alpha = 255, time = 10, flags = ANIMATION_PARALLEL)
	for(var/turf/turf as anything in RANGE_TURFS(6, T))
		if(prob(20))
			new /obj/effect/hotspot(get_turf(turf))
	for(var/turf/Target_turf in range(5, T))
		for(var/mob/living/L in Target_turf.contents)
			to_chat(L, span_userdanger("The sun crushes you!!"))
			var/dist_to_epicenter = get_dist(T, L)
			var/firedamage = 200 - (dist_to_epicenter*15)
			var/firestack = 10 - dist_to_epicenter
			L.adjustFireLoss(firedamage)
			L.adjust_fire_stacks(firestack)
			L.ignite_mob()
			if(!L.mind || istype(L, /mob/living/simple_animal))
				L.adjustFireLoss(500)
				if(dist_to_epicenter <= 3)
					L.gib()
			if(dist_to_epicenter == 1) //pre-center
				L.adjustFireLoss(100) //185 firedamage
				new /obj/effect/hotspot(get_turf(L))
			if(dist_to_epicenter == 0) //center
				explosion(T, -1, 1, 1, 0, 0, flame_range = 1, soundin = 'sound/misc/explode/incendiary (1).ogg')
				new /obj/effect/hotspot(get_turf(L))
				if(!((L.patron?.type) == /datum/patron/divine))
					L.gib()
				else
					L.adjustFireLoss(500)
					L.stat = DEAD
	for(var/obj/item/I in range(1, T))
		qdel(I)
	for (var/obj/structure/damaged in view(2, T))
		if(!istype(damaged, /obj/structure/flora/newbranch))
			damaged.take_damage(500,BRUTE,"blunt",1)
	for (var/turf/closed/wall/damagedwalls in view(1, T))
		damagedwalls.take_damage(1100,BRUTE,"blunt",1)
	for (var/turf/closed/mineral/aoemining in view(2, T))
		aoemining.lastminer = usr
		aoemining.take_damage(1100,BRUTE,"blunt",1)
	sleep(10)
	animate(mark, alpha = 5, time = 10, flags = ANIMATION_PARALLEL)

/obj/effect/proc_holder/spell/self/astrata_sword
	name = "Solar Blade"
	desc = "Call for a blade to preserve light and order in Psydonia. Its strength is middling, but it glows fiercely and can be used to cauterize wounds."
	overlay_state = "sacredflame"
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	recharge_time = 5 MINUTES
	miracle = TRUE
	devotion_cost = 100

	invocations = list("raises their hand skyward, sacred light materializing into brilliant blade!")
	invocation_emote_self = "<span class='notice'>I hold my hand skyward, a glimmering blade forms from light itself.</span>"
	invocation_type = "emote"

	sound = list('sound/combat/clash_charge.ogg')

	var/obj/item/rogueweapon/conjured_sword = null

/obj/effect/proc_holder/spell/self/astrata_sword/cast(list/targets, mob/living/user = usr)
	if(src.conjured_sword)
		qdel(conjured_sword)
	var/obj/item/rogueweapon/astrata_blade = new /obj/item/rogueweapon/sword/astrata_sword(user.drop_location())

	user.put_in_hands(astrata_blade)
	src.conjured_sword = astrata_blade
	return TRUE

/obj/item/rogueweapon/sword/astrata_sword
	name = "Solar Sabre"
	desc = "More a holy tool of ceremony than a weapon of her fury.\
	  It harshly radiates sacred light, rebuking rot and darkness alike; \
	  it is a ruler's blade, knight your soldiers and cleanse their wounds."
	force = 15			//more comparable to a dagger than a sword, for it is ultimately a tool
	force_wielded = 20
	max_blade_int = 400 //Astrata made this out of light not dull, duh.
	max_integrity = 200
	minstr = 6
	wdefense = 5
	wdefense_wbonus = 3 //8 total. 1 better than a basic arming sword
	tool_behaviour = TOOL_CAUTERY //The Main Gimmick here
	smeltresult = null

	icon = 'icons/roguetown/weapons/special/astratablade.dmi'
	icon_state = "solar_blade"

	//These sounds were chosen bc they sound Light-ey and Wooshey, remove if this fucks with sound-queues.
	parrysound = list(
		'sound/combat/clash_disarm_us.ogg'
	)
	pickup_sound = 'sound/combat/clash_charge.ogg'

/obj/item/rogueweapon/sword/astrata_sword/Initialize()
	. = ..()
	set_light(5, 4, l_color = LIGHT_COLOR_WHITE)
