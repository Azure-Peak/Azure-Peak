// Noc Spells

/*
This is a NEW version of blindness that should be less ass to deal with. If any better programmers can come along later
and rework the duration to be a clamped value based on holyskill, that's great, I couldn't get it working. Probably best
to still keep this unavailable to mages... for the moment, at least.
*/
/obj/effect/proc_holder/spell/invoked/blindness
	name = "Blindness"
	desc = "Direct a mote of living darkness to temporarily blind another. \n(-3 PERCEPTION, REDUCED VISION CONE)"
	overlay_state = "blindness"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/churn.ogg'
	spell_tier = 2 // Combat spell
	invocations = list("Blackest nite, blind!")
	invocation_type = "shout" //can be none, whisper, emote and shout
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 50
	recharge_time = 1.5 MINUTES
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE
	cost = 3

/obj/effect/proc_holder/spell/invoked/blindness/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target] shields their eyes from the darkness!"))
			return TRUE
		var/assocskill = user.get_skill_level(associated_skill)
		target.visible_message(span_warning("[user] points at [target]'s eyes!"), span_userdanger("[user] points at my eyes! Shadowy fingers are digging into my vision-- I can't SEE!"))
		target.apply_status_effect(STATUS_EFFECT_BLINDED, assocskill)
		return TRUE
	revert_cast()
	return FALSE

/atom/movable/screen/alert/status_effect/debuff/blindness
	name = "Blindness"
	desc = "I see naught but darkness! (-3 PER, vision cone reduced)"

/datum/status_effect/debuff/blindness
	id = "blindness"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blindness
	effectedstats = list(STATKEY_PER = -3)

/datum/status_effect/debuff/blindness/on_creation(mob/living/new_owner, assocskill)
	// Guaranteed at least five seconds. Technically not needed but Just In CaseTM.
	if(assocskill)
		duration = clamp(assocskill*5, 5, 30) * 1 SECONDS
	else
		duration = 5 SECONDS // Just in case someone somehow gets this W/O holy skill.
	. = ..()

/datum/status_effect/debuff/blindness/on_apply()
	// Blindness actually hooks into the vision_cone.dm as part of a status effect check.
	// If any of you can figure out how to get a fullscreen overlay working (imparied vision or the oxyloss if you want to be nicer)
	// that'd be awesome to add. Unfortunately, I couldnt! 
	. = ..()

/datum/status_effect/debuff/blindness/on_remove()
	. = ..()
	to_chat(owner, span_warning("My vision returns...!"))

/*
NOCCITE SILENCE.
This is going to be designed to work as an alternative to blindness that the cleric in question can pick.
Might require a bit of modification, but we'll see if it works well. 

Conceptually the miracle version of this chokes a mf out with their own shadow but I cant figure out how 2 only change the to_chat
about the wind-pipe or whatever. So itj ust. Its in my mind. Ok? Redoing the ENTIRE cast to just change ONE line is not worth the sovl.
*/

/obj/effect/proc_holder/spell/invoked/silence/miracle
	miracle = TRUE
	devotion_cost = 40 // "worse" than blindness in most practical cases so its a little less. we'll see.
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	invocations = list("Blackest nite, bind!")
	zizo_spell = FALSE // the Noc Intelligence Agency is here to kill you quietly

/*
BLINDNESS OR SILENCE CHOICE SPELL
I'm not a great coder, so this is basically repurposed arcyne affinity. This makes Noccite clerics have the most variety in the game.
Somewhat fitting, considering the broadness of their domains. I also just think Blindness AND Silence are too strong to give at the same time.
*/
/obj/effect/proc_holder/spell/self/blindnessorsilence
	name = "Blindness/Silence"
	desc = "Choose to blind the enemy's eyes (-3 PER, REDUCED VISION CONE) or bind their throat (MUTES, DOES NOT WORK ON FULL-FLEDGED MAGES)."
	miracle = TRUE
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	var/chosen_spell
	// this probably isnt necessary as these are no longer lists, but, uh, it's fine. i think.
	var/silence = /obj/effect/proc_holder/spell/invoked/silence/miracle
	var/blindness = /obj/effect/proc_holder/spell/invoked/blindness
	var/choosingspell = FALSE

/obj/effect/proc_holder/spell/self/blindnessorsilence/cast(list/targets, mob/user)
	. = ..()
	if(choosingspell == TRUE)
		to_chat(user, span_warning("I'm already choosing a spell!"))
	else
		var/choice = chosen_spell
		choosingspell = TRUE
		if(!chosen_spell)
			choice = alert(user, "BIRD or WORM, Crescent?", "ORDER OR ANARCHY", "Blindness", "Silence")
			chosen_spell = choice
		switch(choice)
			if("Blindness")
				user.mind?.AddSpell(new blindness, user)
				user.mind?.RemoveSpell(src.type)
			if("Silence")
				user.mind?.AddSpell(new silence, user)
				user.mind?.RemoveSpell(src.type)
			else
				revert_cast()



// This is the OLD version of blindness that I am keeping just in case the admins need to use it, or whatever. IDK.
// Get free to yell at me if you want it out.

// Blindness is a cancerous spells and should not be available to everyone.
// But I am not nuking it from Acolyte yet so it will be unavailable to mage.
// I repathed it to avoid it becoming available to mages again.
/obj/effect/proc_holder/spell/invoked/old_blindness
	name = "Blindness"
	desc = "Direct a mote of living darkness to temporarily blind another."
	overlay_state = "blindness"
	base_icon_state = "wisescroll"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/churn.ogg'
	spell_tier = 2 // Combat spell
	invocations = list("Noc blinds thee of thy sins!")
	invocation_type = "shout" //can be none, whisper, emote and shout
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 15
	recharge_time = 15 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE
	cost = 3

/obj/effect/proc_holder/spell/invoked/old_blindness/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.visible_message(span_warning("[user] points at [target]'s eyes!"),span_userdanger("My eyes are covered in darkness!"))
		var/strength = min(user.get_skill_level(associated_skill) * 4, 4)
		target.blind_eyes(strength)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/invisibility
	name = "Invisibility"
	overlay_state = "invisibility"
	base_icon_state = "wisescroll"
	desc = "Make another (or yourself) invisible for some time. Duration scales with the arcyne skill. Casting, attacking or being attacked will cancel the duration."
	releasedrain = 30
	chargedrain = 5
	chargetime = 5
	clothes_req = FALSE
	recharge_time = 30 SECONDS
	range = 3
	warnie = "sydwarning"
	movement_interrupt = FALSE
	spell_tier = 1
	invocation_type = "none"
	sound = 'sound/misc/area.ogg' 
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = TRUE
	hide_charge_effect = TRUE
	cost = 3 // Very useful

/obj/effect/proc_holder/spell/invoked/invisibility/miracle
	miracle = TRUE
	desc = "Make another (or yourself) invisible for some time. Duration scales with the holy skill. Casting, attacking or being attacked will cancel the duration."
	devotion_cost = 25
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/invisibility/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.visible_message(span_warning("[target] starts to fade into thin air!"), span_notice("You start to become invisible!"))
		var/dur = max((5 * (user.get_skill_level(associated_skill))), 5)
		if(dur >= recharge_time)
			recharge_time = dur + 5 SECONDS
		animate(target, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
		target.mob_timers[MT_INVISIBILITY] = world.time + dur SECONDS
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), dur SECONDS)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[target] fades back into view."), span_notice("You become visible again.")), dur SECONDS)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/self/noc_spell_bundle
	name = "Arcyne Affinity"
	desc = "Allows you to learn a set of empowering, utility or combat spells."
	base_icon_state = "wisescroll"
	miracle = TRUE
	devotion_cost = 200
	recharge_time = 25 MINUTES
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	var/chosen_bundle
	var/list/utility_bundle = list(	//Utility means exactly that. Nothing offensive and nothing that can affect another person negatively. (Barring Fetch)
		/obj/effect/proc_holder/spell/self/message,
		/obj/effect/proc_holder/spell/invoked/leap,
		/obj/effect/proc_holder/spell/targeted/touch/lesserknock,
		/obj/effect/proc_holder/spell/invoked/mending,
		/obj/effect/proc_holder/spell/invoked/projectile/fetch,
		/obj/effect/proc_holder/spell/invoked/blink,
	)
	var/list/offensive_bundle = list(	//This is not meant to make them combat-capable. A weak offensive, and mostly defensive option.
		/obj/effect/proc_holder/spell/invoked/projectile/arcynebolt, // PLACEHOLDER
		/obj/effect/proc_holder/spell/self/conjure_armor/miracle,
		/obj/effect/proc_holder/spell/invoked/conjure_weapon/miracle,
		/obj/effect/proc_holder/spell/invoked/rebuke, // By points, this adds up to 8 points total. However it is the strongest Acolyte combo offensively.
	)
	var/list/buff_bundle = list(	//Buffs! An Acolyte being a supportive caster is 100% what they already are, so this fits neatly. No debuffs -- every patron already has a plethora of those.
		/obj/effect/proc_holder/spell/invoked/hawks_eyes::name 			= /obj/effect/proc_holder/spell/invoked/hawks_eyes,
		/obj/effect/proc_holder/spell/invoked/giants_strength::name 	= /obj/effect/proc_holder/spell/invoked/giants_strength,
		/obj/effect/proc_holder/spell/invoked/longstrider::name 		= /obj/effect/proc_holder/spell/invoked/longstrider,
		/obj/effect/proc_holder/spell/invoked/guidance::name 			= /obj/effect/proc_holder/spell/invoked/guidance,
		/obj/effect/proc_holder/spell/invoked/haste::name 				= /obj/effect/proc_holder/spell/invoked/haste,
		/obj/effect/proc_holder/spell/invoked/stoneskin::name 			= /obj/effect/proc_holder/spell/invoked/stoneskin,
		/obj/effect/proc_holder/spell/invoked/fortitude::name 			= /obj/effect/proc_holder/spell/invoked/fortitude, // Picking the most expensive options adds up to 12 points
	)
/obj/effect/proc_holder/spell/self/noc_spell_bundle/cast(list/targets, mob/user)
	. = ..()
	var/choice = chosen_bundle
	if(!chosen_bundle)
		choice = alert(user, "What type of spells has Noc blessed you with?", "CHOOSE PATH", "Utility", "Offense", "Buffs")
		chosen_bundle = choice
	switch(choice)
		if("Utility")
			if(!user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
				var/secular_diagnose = new /obj/effect/proc_holder/spell/invoked/diagnose/secular
				user.mind?.AddSpell(secular_diagnose)
			add_spells(user, utility_bundle, grant_all = TRUE)
			user.mind?.RemoveSpell(src.type)
		if("Offense")
			add_spells(user, offensive_bundle, grant_all = TRUE)
			ADD_TRAIT(user, TRAIT_MAGEARMOR, TRAIT_MIRACLE)
			user.mind?.RemoveSpell(src.type)
		if("Buffs")
			add_spells(user, buff_bundle, choice_count = 4)
			ADD_TRAIT(user, TRAIT_MAGEARMOR, TRAIT_MIRACLE)
			user.mind?.RemoveSpell(src.type)
		else
			revert_cast()


/obj/effect/proc_holder/spell/self/noc_spell_bundle/proc/add_spells(mob/user, list/spells, choice_count = 1, grant_all = FALSE)
	for(var/spell_type in spells)
		if(user?.mind.has_spell(spells[spell_type]))
			spells.Remove(spell_type)
	if(!grant_all)
		var/choice_count_visual = choice_count
		for(var/i in 1 to choice_count)
			var/choice = input(user, "Choose a spell! Choices remaining: [choice_count_visual]") as null|anything in spells
			if(!isnull(choice))
				var/picked_spell = spells[choice]
				var/obj/effect/proc_holder/spell/new_spell = new picked_spell
				user?.mind.AddSpell(new_spell)
				choice_count_visual--
				spells.Remove(choice)
	else
		for(var/spell_type in spells)
			var/obj/effect/proc_holder/spell/new_spell = new spell_type
			user?.mind.AddSpell(new_spell)
	if(!length(spells))
		user.mind?.RemoveSpell(src.type)

//15 PER peer-ahead.
/obj/effect/proc_holder/spell/invoked/noc_sight
	name = "Noc's Gaze"
	overlay_state = "noc_sight"
	base_icon_state = "wisescroll"
	desc = "Peer ahead. (Use MMB to project your vision as if you had a very high perception.)"
	chargetime = 0
	chargedrain = 0
	clothes_req = FALSE
	recharge_time = 5 SECONDS
	devotion_cost = 5
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocations = list("Noc guide my gaze.")
	invocation_type = "whisper"
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	hide_charge_effect = TRUE
	miracle = TRUE


//Identical to peering ahead as if you had 15 PER. (the max)
/obj/effect/proc_holder/spell/invoked/noc_sight/cast(list/targets, mob/user)
	if(isturf(targets[1]) && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/turf/T = targets[1]
		var/_x = T.x-H.loc.x
		var/_y = T.y-H.loc.y
		var/ttime = 6
		var/dist = get_dist(H, T)
		if(dist > 7 || dist  <= 2)
			return
		H.hide_cone()
		var/offset = 5
		if(_x > 0)
			_x += offset
		else if(_x != 0)
			_x -= offset
		if(_y > 0)
			_y += offset
		else if(_y != 0)
			_y -= offset
		animate(H.client, pixel_x = world.icon_size*_x, pixel_y = world.icon_size*_y, ttime)
		H.update_cone_show()
		return TRUE
	revert_cast()
	return FALSE

//T0.
/obj/effect/proc_holder/spell/self/wise_moon
	name = "Enlightenment"
	desc = "Invoke a lesser form of the Moonlight Dance, temporarily increasing your intelligence. \
	Scales with holy skill and grows much more effective at nite."
	base_icon_state = "wisescroll"
	overlay_state = "noc_gaze"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = 'sound/magic/clang.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	invocations = list("His gaze upon me...!", "I beseech the stars; show me truth!") 
	invocation_type = "shout"
	recharge_time = 3 MINUTES
	devotion_cost = 30
	miracle = TRUE

/obj/effect/proc_holder/spell/self/wise_moon/cast(list/targets, mob/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	H.apply_status_effect(/datum/status_effect/buff/wise_moon, user.get_skill_level(associated_skill))
	return TRUE

/atom/movable/screen/alert/status_effect/buff/wise_moon
	name = "Enlightenment"
	desc = "Divine magic is boosting my intelligence."
	icon_state = "enlightenment"

/datum/status_effect/buff/wise_moon
	id = "wise_moon"
	alert_type = /atom/movable/screen/alert/status_effect/buff/wise_moon
	duration = 2 MINUTES

/datum/status_effect/buff/wise_moon/on_creation(mob/living/new_owner, assocskill)
	var/int_bonus = 0
	if(assocskill)
		int_bonus = 2
		if(assocskill >= 4)
			int_bonus = 3
	if(GLOB.tod == "night")
		if(assocskill <= 2)
			int_bonus = 3
		else
			int_bonus = assocskill
		duration *= 2
	if(GLOB.tod == "day")
		to_chat(owner, span_warning("ASTRATA IS RISEN! My spell loses some of it's potency! (-1 TO STAT BOOST.)"))
		int_bonus--
	if(int_bonus > 0)
		effectedstats = list(STATKEY_INT = int_bonus)
	. = ..()

//T0

/obj/effect/proc_holder/spell/invoked/moondream
	name = "Hypnagognian Inspiration"
	desc = "Touch a target. Their next dream will be inspired, granting more dream-points to the target and a few to yourself. \
	This spell will fail if it's dae or dawn. Points granted scales with holy skill."
	overlay_state = "moondream"
	base_icon_state = "wisescroll"
	releasedrain = 15
	chargedrain = 0
	chargetime = 1 SECONDS
	range = 1 // touch spell cause its cooler that way
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/owlhoot.ogg' // its cool
	invocation_type = "whisper"
	invocations = list("Good nite.") // good nite :) i love you :)
	associated_skill = /datum/skill/magic/holy
	recharge_time = 30 MINUTES
	gesture_required = TRUE
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/moondream/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/carbon/human/target = targets[1]
		var/mob/living/carbon/human/H = user
		if(target == user)
			to_chat(user, span_warning("I cannot cast this spell on myself!"))
			revert_cast()
			return FALSE
		if(!user.Adjacent(target)) // the range on this doesnt work for some reason. remove this if you can fix it. thx.
			to_chat(user, span_warning("I must be adjacent to the target to cast this spell!"))
			revert_cast()
			return FALSE
		if(!target.mind)
			to_chat(user, span_warning("They are too simple for this spell to work!"))
			revert_cast()
			return FALSE
		if(GLOB.tod == "day" || GLOB.tod == "dawn")
			to_chat(user, span_warning("ASTRATA IS RISEN! MY SPELL FIZZLES!"))
			revert_cast()
			return FALSE
		if(target.mind?.sleep_adv)
			user.visible_message(span_blue("[user] draws a glowing blue crescent on [target]\'s forehead!"))
			to_chat(target, span_blue("My mind flashes with inspiring images of the NOCMOS! My dreams will prove fruitful...!")) // the NOCMOS IS SPEAKING TO ME.
			target.mind.sleep_adv.sleep_adv_points += H.get_skill_level(associated_skill)
			H.mind.sleep_adv.sleep_adv_points += floor(H.get_skill_level(associated_skill)/2) //good boy, take a bun.
		return TRUE
	revert_cast()
	return FALSE

//T0

/obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/nocgrasp
	name = "Noc Grasp"
	desc = "Summon a vestige of Noc and let it envelop your hand. Use it on scrolls, parchment and books to convert them into devotion."
	clothes_req = FALSE
	drawmessage = "I prepare to perform a divine incantation."
	dropmessage = "I release my divine focus."
	overlay_state = "nocgrasp"
	base_icon_state = "wisescroll"
	chargedrain = 0
	chargetime = 0
	releasedrain = 5 // this influences -every- cost involved in the spell's functionality, if you want to edit specific features, do so in handle_cost
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	hand_path = /obj/item/melee/touch_attack/rogueweapon/nocgrasp
	devotion_cost = 30
	miracle = TRUE

/obj/item/melee/touch_attack/rogueweapon/nocgrasp
	name = "Shimmering Hand"
	desc = "The Sacred Light of Noc. \
	Touch yourself to dispel it."
	icon = 'icons/roguetown/misc/miraclestuff.dmi'
	mob_overlay_icon = 'icons/roguetown/misc/miraclestuff.dmi'
	lefthand_file = 'icons/roguetown/misc/miraclestuff.dmi'
	righthand_file = 'icons/roguetown/misc/miraclestuff.dmi'
	icon_state = "mooni"
	item_state = "mooni"
	possible_item_intents = list(/datum/intent/use)
	parrysound = list('sound/magic/magic_nulled.ogg')
	swingsound = list('sound/magic/cosmic_expansion.ogg')
	attached_spell = /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/nocgrasp
	wbalance = WBALANCE_HEAVY
	force = 0
	damtype = BURN
	wdefense = 0
	associated_skill = /datum/skill/magic/holy //EHEHEHEHEHEH
	can_parry = TRUE

/obj/item/melee/touch_attack/rogueweapon/nocgrasp/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(skillcheck), src), wait = 1)
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/melee/touch_attack/rogueweapon/nocgrasp/attack(mob/target, mob/living/carbon/user)
	if(!iscarbon(user)) //Look ma, no hands
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, "<span class='warning'>I cannot reach out!</span>")
		return
	..()

/obj/item/melee/touch_attack/rogueweapon/nocgrasp/proc/skillcheck()
	var/skill = usr.get_skill_level(/datum/skill/magic/holy)
	wdefense_dynamic += skill
	wdefense += skill

/obj/item/melee/touch_attack/rogueweapon/nocgrasp/afterattack(atom/target, mob/living/carbon/user, params, proximity)
	if(isobj(target))
		var/obj/item/O = target
		var/mob/living/carbon/human/H = usr
		var/cost = 0
		var/dist = get_dist(O, user)
		if(dist > 1)
			return
		if(istype(O, /obj/item/paper))
			cost = 20
		if(istype(O, /obj/item/paper/scroll))
			cost = 50
		if(istype(O, /obj/item/skillbook) || istype(O, /obj/item/recipe_book) || istype(O, /obj/item/book))
			cost = 100
		if(cost >= 20)
			H.devotion?.update_devotion(cost)
			to_chat(user, "<font color='purple'>I gain [cost] devotion!</font>")
			qdel(O)
		return
	if(isliving(target))
		var/mob/living/M = target
		if(M == user)
			attached_spell.remove_hand()
			qdel(src)
	return

/obj/item/melee/touch_attack/rogueweapon/nocgrasp/pre_attack(atom/target, mob/living/user, params)
	if(isliving(target))
		var/mob/living/L = target
		L.extinguish_mob()
	if(isobj(target))
		var/obj/O = target
		O.extinguish()
	return ..()

//T1

/obj/effect/proc_holder/spell/self/moon_light
	name = "Moonlight Glimmer"
	desc = "Calls down shimmering moonlight onto those around you in a certain radius, scaling with holy skill. \
	Mindless creachers will become critically weak. Simple creachers will burn. \
	This CASTS INSTANTLY on selection, and does not work during dae nor dawn."
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	invocations = list("ALL WILL BE REVEALED!!", "DARKNESS, AWAY!!") // this is a LOUD yell bc it can FUUUUCK shit up. and rogues.
	invocation_type = "shout"
	sound = 'sound/magic/churn.ogg'
	base_icon_state = "wisescroll"
	overlay_state = "moon_light"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 1 MINUTES
	miracle = TRUE
	devotion_cost = 30
	range = 3

/obj/effect/proc_holder/spell/self/moon_light/cast(list/targets, mob/user = usr)
	. = ..()
	if(GLOB.tod == "day" || GLOB.tod == "dawn")
		to_chat(user, span_warning("ASTRATA IS RISEN! MY SPELL FIZZLES!"))
		revert_cast()
		return FALSE
	var/checkrange = (range + user.get_skill_level(/datum/skill/magic/holy)) //+1 range per holy skill up to a potential of 8.
	for(var/mob/living/M in range(checkrange, user))
		if(M == user)
			continue
		var/target_turf = get_turf(M)
		new /obj/effect/temp_visual/moon(target_turf)
		M.apply_status_effect(/datum/status_effect/light_buff/moon, 1)
	return TRUE

/datum/status_effect/light_buff/moon
	id = "moon_light_buff"
	alert_type = /atom/movable/screen/alert/status_effect/light_buff
	duration = 15 SECONDS
	color_mob_light = "#3936eacf"

/obj/effect/temp_visual/moon
	icon_state = "moon"
	duration = 4 SECONDS
	layer = MASSIVE_OBJ_LAYER
	light_outer_range = 3
	light_color = "#1640d7ff"

/datum/status_effect/light_buff/moon/on_apply()
	..()
	if(!owner.mind) //PVE stuff.
		if(HAS_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS)) //skeletons...
			return
		ADD_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

/datum/status_effect/light_buff/moon/tick()
	if(!owner.mind || istype(owner, /mob/living/simple_animal)) //AI mobs take 3 burn damage per tick. 45 burn without 15 seconds.
		var/mob/living/target = owner
		target.adjustFireLoss(3)

//T3

/obj/effect/proc_holder/spell/self/wisescroll
	name = "Kytherian Grimoire"
	desc = "Using writing materials, and enough paper, create a great work: a Magic Scroll!\
	You will need to be holding a feather and to have 10 points worth of items around your person.\n\
	Piece of parchment - 1 point, scroll - 2 points, book - 5 points.\n\
	Uses your dream-points as ink."
	releasedrain = 200
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	invocations = list("Deepest dreaming, scribe!")
	invocation_type = "shout"
	overlay_state = "noc"
	sound = 'sound/magic/clang.ogg'
	base_icon_state = "wisescroll"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 MINUTES
	miracle = TRUE
	devotion_cost = 200
	var/points_need = 10
	var/alreadychoosing = FALSE

/obj/effect/proc_holder/spell/self/wisescroll/cast(mob/living/carbon/human/user)
	if(alreadychoosing)
		to_chat(user, span_warning("I'm already picking a spell..."))
		revert_cast()
		return

	alreadychoosing = TRUE

	. = ..()
	// commentened out until someone fixes the cooldown code. 
	/*
	if(GLOB.tod == "day" || GLOB.tod == "dawn")
		to_chat(user, span_warning("ASTRATA IS RISEN! MY SPELL FIZZLES!"))
		revert_cast()
		alreadychoosing = FALSE
		return FALSE*/

	var/feather_check = FALSE

	for(var/obj/item/I in range(1, user))
		if(istype(I, /obj/item/natural/feather))
			feather_check = TRUE

	if(feather_check == FALSE)
		to_chat(user, "I need a feather!")
		revert_cast()
		alreadychoosing = FALSE
		return FALSE

	var/points = 0
	var/pointlock = TRUE
	var/list/books_burnt = list()

	for(var/obj/item/I in range(1, user))
		if(points < points_need)
			if(istype(I, /obj/item/paper))
				points += 1
				books_burnt += I
			if(istype(I, /obj/item/paper/scroll))
				points += 2
				books_burnt += I
			if(istype(I, /obj/item/skillbook) || istype(I, /obj/item/recipe_book) || istype(I, /obj/item/book))
				points += 5
				books_burnt += I
			if(points >= points_need)
				pointlock = FALSE

	// Ensure we have enough pages...
	if(pointlock == TRUE)
		to_chat(user, span_warning("I need more papers!"))
		revert_cast()
		alreadychoosing = FALSE
		return FALSE

	var/list/choices = list()

	var/list/scroll_choices  = GLOB.noc_scrolls

	for(var/i = 1, i <= scroll_choices.len, i++)
		var/obj/item/book/granter/scroll_item = scroll_choices [i]
		if(scroll_item.dreamcost > user.mind.sleep_adv.sleep_adv_points)
			continue
		choices["☾ [scroll_item.dreamcost] |☾| [scroll_item.name] ☾"] = scroll_item

	choices = sortList(choices)

	if(user.mind.sleep_adv.sleep_adv_points == 0)
		to_chat(user, "Not enough dreampoints!")	
		revert_cast()
		alreadychoosing = FALSE
		return FALSE

	var/choice = input("☾ Choose a scroll ☾, points left: [user.mind.sleep_adv.sleep_adv_points]") as null|anything in choices
	var/obj/item/book/granter/item = choices[choice]

	if(!item)
		revert_cast()
		alreadychoosing = FALSE
		return FALSE    // user canceled;
	if(alert(user, "[item.desc]", "[item.name]", "Write", "Remind") == "Cancel") //gives a preview of the spell's description to let people know what a spell does
		revert_cast()
		alreadychoosing = FALSE
		return FALSE
	if(item.dreamcost > user.mind.sleep_adv.sleep_adv_points)
		to_chat(user,span_warning("You do not have enough dream-points to create this spell."))
		revert_cast()
		alreadychoosing = FALSE
		return FALSE		// not enough spell points
	else
		for(var/obj/item/burn in books_burnt)
			new /obj/effect/temp_visual/moon/spell(get_turf(burn))
			qdel(burn)
		user.mind.sleep_adv.sleep_adv_points -= item.dreamcost
		if(item.dreamcost == 3) // this doesnt fucking work. our code doesnt allow for custom recharges to be done 
			recharge_time = 5 MINUTES // in any convenient way. if you want to fix this later try using a status_effect
		if(item.dreamcost == 6) // secondary charge system instead of this shit. 
			recharge_time = 15 MINUTES // kept in so the intent is understood.
		if(item.dreamcost >= 9)
			recharge_time = 30 MINUTES
		var/obj/item/I = new item (get_turf(user))
		user.put_in_hands(I)
		alreadychoosing = FALSE
		return TRUE

/obj/effect/temp_visual/moon/spell
	icon_state = "spellwarning"
	duration = 2 SECONDS
	layer = MASSIVE_OBJ_LAYER
	light_outer_range = 3
	color = "#1640d7ff"
	light_color = "#1640d7ff"

GLOBAL_LIST_INIT(noc_scrolls, (list(/obj/item/book/granter/spell/blackstone/fireball,
		/obj/item/book/granter/spell/blackstone/lightning,
		/obj/item/book/granter/spell/blackstone/fetch,
		/obj/item/book/granter/spell/blackstone/invisibility,
		/obj/item/book/granter/spell/blackstone/acidsplash,
		/obj/item/book/granter/spell/blackstone/spitfire,
		/obj/item/book/granter/spell/blackstone/lesserknock,
		/obj/item/book/granter/spell/blackstone/repel,

		/obj/item/book/granter/spell/blackstone/guidance,
		/obj/item/book/granter/spell/blackstone/frostbolt,
		/obj/item/book/granter/spell/blackstone/fortitude,
		/obj/item/book/granter/spell/blackstone/message,
		/obj/item/book/granter/spell/blackstone/ensnare,
		/obj/item/book/granter/spell/blackstone/forcewall_weak,
		/obj/item/book/granter/spell/blackstone/featherfall,
		/obj/item/book/granter/spell/blackstone/enlarge,
		/obj/item/book/granter/spell/blackstone/leap,
		/obj/item/book/granter/spell_points,
		/obj/item/book/granter/arcynetyr,
		/obj/item/book/granter/spell/blackstone/repulse,
		/obj/item/book/granter/spell/blackstone/blade_burst,
		/obj/item/book/granter/spell/blackstone/haste,
		/obj/item/book/granter/spell/blackstone/longstrider,
		/obj/item/book/granter/spell/blackstone/arcynebolt,
		/obj/item/book/granter/spell/blackstone/counterspell,
		/obj/item/book/granter/spell/blackstone/blink,
		/obj/item/book/granter/spell/blackstone/mirror_transform,
		/obj/item/book/granter/spell/blackstone/stoneskin,
		/obj/item/book/granter/spell/blackstone/hawks_eyes,
		/obj/item/book/granter/spell/blackstone/mending,
		)
))
