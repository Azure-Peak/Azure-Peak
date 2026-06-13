/datum/action/cooldown/spell/noc
	background_icon = 'icons/mob/actions/nocmiracles.dmi'
	button_icon = 'icons/mob/actions/nocmiracles.dmi'
	spell_color = GLOW_COLOR_ILLUSION

	ignore_armor_penalty = TRUE

	attunement_school = null

	primary_resource_type = SPELL_COST_DEVOTION

	secondary_resource_type = SPELL_COST_STAMINA

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0

	point_cost = 0

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/noc, /obj/item/clothing/neck/roguetown/psicross/silver/noc, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/////////////////////
// T0 - Noc Sight. //
/////////////////////

/datum/action/cooldown/spell/noc/sight
	name = "Noc's Gaze"
	desc = "Peer ahead. (Use MMB to project your vision as if you had a very high perception.)"
	button_icon_state = "noc_sight"
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_CANTRIP

	secondary_resource_cost = SPELLCOST_CANTRIP

	invocation_type = INVOCATION_WHISPER
	invocations = list("Noc guide my gaze.")

	charge_required = FALSE
	cooldown_time = 5 SECONDS

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/sight/cast(atom/cast_on)
	. = ..()
	if(isturf(cast_on) && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/turf/T = cast_on
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
	return FALSE

/////////////////////////
// T1 - Enlightenment. //
/////////////////////////

/datum/action/cooldown/spell/noc/enlightenment
	name = "Enlightenment"
	desc = "Invoke a lesser form of the Moonlight Dance, temporarily increasing your intelligence. \
	Scales with holy skill and grows much more effective at nite."
	button_icon_state = "noc_gaze"
	sound = 'sound/magic/clang.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocation_type = INVOCATION_SHOUT
	invocations = list("His gaze upon me...!", "I beseech the stars; show me truth!") 

	charge_required = FALSE
	cooldown_time = 3 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/enlightenment/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/skill_level = H.get_skill_level(associated_skill)
	H.apply_status_effect(/datum/status_effect/buff/wise_moon, skill_level)
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
		to_chat(owner, span_warning("ASTRATA IS RISEN! My spell loses some of its potency! (-1 TO STAT BOOST.)"))
		int_bonus--
	if(int_bonus > 0)
		effectedstats = list(STATKEY_INT = int_bonus)
	. = ..()

///////////////////////
// T1 - Inspiration. //
///////////////////////

/datum/action/cooldown/spell/noc/inspiration
	name = "Inspiration"
	desc = "Touch a target. Their next dream will be inspired, granting more dream-points to the target and a few to yourself. \
	This spell will fail if it's dae or dawn. Points granted scales with holy skill."
	button_icon_state = "moondream"
	sound = 'sound/magic/owlhoot.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_MIRACLE_MINOR

	invocation_type = INVOCATION_WHISPER
	invocations = list("Good nite.")

	charge_required = FALSE
	cooldown_time = 30 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/inspiration/cast(atom/cast_on)
	. = ..()
	if(isliving(cast_on))
		var/mob/living/carbon/human/target = cast_on
		var/mob/living/carbon/human/H = owner
		if(!target.mind)
			to_chat(owner, span_warning("They are too simple for this spell to work!"))
			return FALSE
		if(GLOB.tod == "day" || GLOB.tod == "dawn")
			to_chat(owner, span_warning("ASTRATA IS RISEN! MY SPELL FIZZLES!"))
			return FALSE
		if(target.mind?.sleep_adv)
			owner.visible_message(span_blue("[owner] draws a glowing blue crescent on [target]\'s forehead!"))
			to_chat(target, span_blue("My mind flashes with inspiring images of the NOCMOS! My dreams will prove fruitful...!"))
			target.mind.sleep_adv.sleep_adv_points += H.get_skill_level(associated_skill)
			H.mind.sleep_adv.sleep_adv_points += floor(H.get_skill_level(associated_skill)/2)
		return TRUE
	return FALSE

////////////////////////
// T2 - Invisibility. //
////////////////////////

/datum/action/cooldown/spell/noc/invisibility
	name = "Moon Shroud"
	desc = "Make another (or yourself) invisible for some time. Duration scales with holy skill. Casting, attacking or being attacked will cancel the duration."
	button_icon_state = "invisibility"
	sound = 'sound/misc/area.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 3
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	ignore_stealth_reveal = TRUE

/datum/action/cooldown/spell/noc/invisibility/cast(atom/cast_on)
	. = ..()
	var/mob/living/spelltarget = cast_on

	if(isliving(cast_on))
		if(spelltarget.anti_magic_check(TRUE, TRUE))
			return FALSE
		cast_on.visible_message(span_warning("[cast_on] starts to fade into thin air!"), span_notice("You start to become invisible!"))
		var/dur
		dur = max((5 * (owner.get_skill_level(associated_skill))), 15)
		if(dur >= cooldown_time)
			cooldown_time = dur + 5 SECONDS
		animate(cast_on, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
		spelltarget.mob_timers[MT_INVISIBILITY] = world.time + dur SECONDS
		addtimer(CALLBACK(cast_on, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), dur SECONDS)
		addtimer(CALLBACK(cast_on, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[cast_on] fades back into view."), span_notice("You become visible again.")), dur SECONDS)
		return TRUE
	else
		return FALSE

// GENERIC OLD VERSION, UPDATE THIS SEPERATELY //
/obj/effect/proc_holder/spell/invoked/invisibility
	name = "Invisibility"
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "invisibility"
	desc = "Make another (or yourself) invisible for some time. Duration scales with intelligence. Casting, attacking or being attacked will cancel the duration."
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
	glow_color = GLOW_COLOR_ILLUSION
	sound = 'sound/misc/area.ogg'
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = TRUE
	hide_charge_effect = TRUE
	cost = 3 // Very useful
	ignore_stealth_reveal = TRUE

/obj/effect/proc_holder/spell/invoked/invisibility/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.visible_message(span_warning("[target] starts to fade into thin air!"), span_notice("You start to become invisible!"))
		var/dur
		if(miracle)
			dur = max((5 * (user.get_skill_level(associated_skill))), 15)
		else
			dur = 15 + min(max(user.STAINT - 10, 0) * 2.5, 12.5)
		if(dur >= recharge_time)
			recharge_time = dur + 5 SECONDS
		animate(target, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
		target.mob_timers[MT_INVISIBILITY] = world.time + dur SECONDS
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), dur SECONDS)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[target] fades back into view."), span_notice("You become visible again.")), dur SECONDS)
		return TRUE
	revert_cast()
	return FALSE


/////////////////////
// T2 - Blindness. //
/////////////////////

/datum/action/cooldown/spell/noc/blindness
	name = "Blindness"
	desc = "Direct a mote of living darkness to temporarily blind another. \n(-3 PERCEPTION, REDUCED VISION CONE)"
	button_icon_state = "blindness"
	sound = 'sound/magic/churn.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocation_type = INVOCATION_SHOUT
	invocations = list("Blackest nite, blind!")

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 3
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1.5 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/blindness/cast(atom/cast_on)
	. = ..()
	var/mob/living/spelltarget = cast_on

	if(isliving(cast_on))
		if(spelltarget.anti_magic_check(TRUE, TRUE))
			return FALSE
		if(spell_guard_check(cast_on, TRUE))
			cast_on.visible_message(span_warning("[cast_on] shields their eyes from the darkness!"))
			return TRUE
		var/assocskill = owner.get_skill_level(associated_skill)
		cast_on.visible_message(span_warning("[owner] points at [cast_on]'s eyes!"), span_userdanger("[owner] points at my eyes! Shadowy fingers are digging into my vision-- I can't SEE!"))
		spelltarget.apply_status_effect(STATUS_EFFECT_BLINDED, assocskill)
		return TRUE
	else
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

//////////////////////
// T3 - Moonscorch. //
//////////////////////

/datum/action/cooldown/spell/noc/moonscorch
	name = "Moonscorch"
	desc = "Calls down shimmering moonlight onto those around you in a certain radius, scaling with holy skill. \
	Mindless creachers will become critically weak. Simple creachers will burn. \
	Does not work during dae nor dawn."
	button_icon_state = "moon_light"
	sound = 'sound/magic/churn.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_AURA
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocation_type = INVOCATION_SHOUT
	invocations = list("YOUR TRUE FORM REVEALED!!")

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 3
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/moonscorch/cast(atom/cast_on)
	. = ..()

	if(GLOB.tod == "day" || GLOB.tod == "dawn")
		to_chat(owner, span_warning("ASTRATA IS RISEN! MY SPELL FIZZLES!"))
		return FALSE
	var/checkrange = (cast_range + owner.get_skill_level(/datum/skill/magic/holy)) //+1 range per holy skill up to a potential of 8.
	for(var/mob/living/M in range(checkrange, owner))
		if(M == owner)
			continue
		var/target_turf = get_turf(M)
		new /obj/effect/temp_visual/moon(target_turf)
		M.apply_status_effect(/datum/status_effect/light_buff/moon, 1)
	return TRUE

/obj/effect/temp_visual/moon
	icon_state = "moon"
	duration = 4 SECONDS
	layer = MASSIVE_OBJ_LAYER
	light_outer_range = 3
	light_color = "#1640d7ff"

/datum/status_effect/light_buff/moon
	id = "moon_light_buff"
	alert_type = /atom/movable/screen/alert/status_effect/light_buff
	duration = 15 SECONDS//This is geniunely permanent, I guess dude?
	color_mob_light = "#3936eacf"

/datum/status_effect/light_buff/moon/on_apply()
	..()
	if(!owner.mind) //PVE stuff.
		if(HAS_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS)) //skeletons...
			return
		ADD_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, TRAIT_MIRACLE)

/datum/status_effect/light_buff/moon/tick()
	if(!owner.mind || istype(owner, /mob/living/simple_animal)) //AI mobs take 3 burn damage per tick. 45 burn without 15 seconds.
		var/mob/living/target = owner
		target.adjustFireLoss(3)


///////////////////////////
// T3 - Arcyne Affinity. //
///////////////////////////

/datum/action/cooldown/spell/noc/spellpack
	name = "Arcyne Affinity"
	desc = "Allows you to learn a set of spells. \n \
	<b>MAGISTER</b>: Greater Arcyne Force Wall, Arcyne Ward, Blink, Message, Create Campfire \n \
	<b>ENCHANTER</b>: Gravel Blast, Dragon Hide, Mending, Arcyne Forge, Hawk Eyes, Stoneskin\n \
	<b>SEER</b>: Crystal Hide, Giants Strength, Guidance, Haste, Fortitude, Mindlink"
	button_icon_state = "spellpack"

	click_to_activate = FALSE
	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_cost = SPELLCOST_UTILITY_BUFF
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 5 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// var we use to flag we are currently choosing a bundle.
	var/choosing_bundle = FALSE
	var/chosen_bundle
	var/list/magister_bundle = list(
		/datum/action/cooldown/spell/projectile/greater_arcyne_bolt, //Offensive Tool
		/datum/action/cooldown/spell/forcewall,
		/datum/action/cooldown/spell/conjure_arcyne_ward,
		/datum/action/cooldown/spell/blink,
		/datum/action/cooldown/spell/message, //Utility
		/datum/action/cooldown/spell/create_campfire //Buff
	)
	var/list/enchanter_bundle = list(
		/datum/action/cooldown/spell/projectile/gravel_blast, //Offensive Tool
		/datum/action/cooldown/spell/conjure_arcyne_ward/dragonhide,
		/datum/action/cooldown/spell/mending,
		/datum/action/cooldown/spell/arcyne_forge, //Utility
		/datum/action/cooldown/spell/hawks_eyes,
		/datum/action/cooldown/spell/stoneskin //Buff
	)
	var/list/seer_bundle = list(
		/datum/action/cooldown/spell/conjure_arcyne_ward/crystalhide,
		/datum/action/cooldown/spell/giants_strength,
		/datum/action/cooldown/spell/guidance,
		/datum/action/cooldown/spell/haste,
		/datum/action/cooldown/spell/fortitude,
		/datum/action/cooldown/spell/mindlink
	)

/datum/action/cooldown/spell/noc/spellpack/cast(atom/cast_on)
	. = ..()

	if(choosing_bundle)
		return FALSE
	var/choice = chosen_bundle
	if(!chosen_bundle)
		choosing_bundle = TRUE
		choice = alert(owner, "What type of spells has Noc blessed you with?", "CHOOSE PATH", "Magister", "Enchanter", "Seer")
		chosen_bundle = choice
		choosing_bundle = FALSE

	switch(choice)
		if("Magister")
			add_spells(owner, magister_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Enchanter")
			add_spells(owner, enchanter_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Seer")
			add_spells(owner, seer_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
	return FALSE

/datum/action/cooldown/spell/noc/spellpack/proc/add_spells(mob/owner, list/spells, choice_count = 1, grant_all = FALSE)
	for(var/spell_type in spells)
		if(owner?.mind.has_spell(spells[spell_type]))
			spells.Remove(spell_type)
	if(!grant_all)
		var/choice_count_visual = choice_count
		for(var/i in 1 to choice_count)
			var/choice = input(owner, "Choose a spell! Choices remaining: [choice_count_visual]") as null|anything in spells
			if(!isnull(choice))
				var/picked_spell = spells[choice]
				var/datum/new_spell = new picked_spell
				owner?.mind.AddSpell(new_spell)
				choice_count_visual--
				spells.Remove(choice)
	else
		for(var/spell_type in spells)
			var/datum/new_spell = new spell_type
			owner?.mind.AddSpell(new_spell)
	if(!length(spells))
		owner.mind?.RemoveSpell(src.type)


//////////////////////////////
// T4 - Kytherian Grimoire. //
//////////////////////////////

/datum/action/cooldown/spell/noc/grimoire
	name = "Kytherian Grimoire"
	desc = "Using writing materials, and enough paper, create a great work: a Magic Scroll!\n\
	You will need to be holding a feather and to have 10 points worth of items around your person.\n\
	Piece of parchment - 1 point, scroll - 2 points, book - 5 points.\n\
	Uses your dream-points as ink."
	sound = 'sound/magic/clang.ogg'
	button_icon_state = "noc"

	click_to_activate = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_LEGENDARY*2

	secondary_resource_cost = SPELLCOST_MIRACLE_LEGENDARY

	invocation_type = INVOCATION_SHOUT
	invocations = list("Deepest dreaming, scribe!")

	charge_required = FALSE
	cooldown_time = 45 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/points_need = 10
	var/alreadychoosing = FALSE

/datum/action/cooldown/spell/noc/grimoire/cast(mob/living/carbon/human/user)
	if(alreadychoosing)
		to_chat(user, span_warning("I'm already picking a spell..."))
		return FALSE

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
		alreadychoosing = FALSE
		return FALSE

	var/choice = input("☾ Choose a scroll ☾, points left: [user.mind.sleep_adv.sleep_adv_points]") as null|anything in choices
	var/obj/item/book/granter/item = choices[choice]

	if(!item)
		alreadychoosing = FALSE
		return FALSE    // user canceled;
	if(alert(user, "[item.desc]", "[item.name]", "Write", "Remind") == "Cancel") //gives a preview of the spell's description to let people know what a spell does
		alreadychoosing = FALSE
		return FALSE
	if(item.dreamcost > user.mind.sleep_adv.sleep_adv_points)
		to_chat(user,span_warning("You do not have enough dream-points to create this spell."))
		alreadychoosing = FALSE
		return FALSE		// not enough spell points
	else
		for(var/obj/item/burn in books_burnt)
			new /obj/effect/temp_visual/moon/spell(get_turf(burn))
			qdel(burn)
		user.mind.sleep_adv.sleep_adv_points -= item.dreamcost
/*		if(item.dreamcost == 3) // this doesnt fucking work. our code doesnt allow for custom recharges to be done 
			cooldown_time = 5 MINUTES // in any convenient way. if you want to fix this later try using a status_effect
		if(item.dreamcost == 6) // secondary charge system instead of this shit. 
			cooldown_time = 15 MINUTES // kept in so the intent is understood.
		if(item.dreamcost >= 9)
			cooldown_time = 30 MINUTES*/
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

GLOBAL_LIST_INIT(noc_scrolls, (list(
	/obj/item/book/granter/spell/noc/fireball, 
	/obj/item/book/granter/spell/noc/lbolt, 
	/obj/item/book/granter/spell/noc/boulderstrike, 
	/obj/item/book/granter/spell/noc/message,
	/obj/item/book/granter/spell/noc/mindlink,
	/obj/item/book/granter/spell/noc/mending,
	/obj/item/book/granter/spell/noc/blink,
	/obj/item/book/granter/spell/noc/repulse
	)))
