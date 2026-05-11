/datum/action/cooldown/spell/dendor
	sound = 'sound/magic/churn.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'
	button_icon = 'icons/mob/actions/dendormiracles.dmi'
	spell_color = GLOW_COLOR_DENDOR
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
	required_items = list(/obj/item/clothing/neck/roguetown/psicross/dendor, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

///////////////////////
// T0 - Spider Speak //
///////////////////////

/datum/action/cooldown/spell/dendor/wildspeak
	name = "Wild Speak"
	desc = "Infuses a target with the mind, scent and instinct of the Wild. Beasts and primordial creatures will recognize them as kin, and they can speak the language of the beasts."
	fluff_desc = "The oldest druids spoke not with words, but scent, breath, instinct, and spirit. Through Dendor's blessing, the Wild remembers its own."
	button_icon_state = "tamebeast"
	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE
	primary_resource_cost = 25
	secondary_resource_cost = 25
	charge_required = FALSE
	cooldown_time = 30 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_SAME_Z
	var/duration = 30 MINUTES

/datum/action/cooldown/spell/dendor/wildspeak/cast(atom/cast_on)
	. = ..()

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(!isliving(spelltarget))
		to_chat(H, span_warning("The Wild cannot commune with that."))
		return FALSE

	if(spelltarget.has_status_effect(/datum/status_effect/buff/wildtongue))
		to_chat(owner, span_warning("They are already blessed with Wildtongue."))
		return FALSE

	if(spelltarget != H)
		H.visible_message(span_green("[H] invokes the ancient voice of the wild upon [spelltarget]!"))
	else	
		H.visible_message(span_green("[H] invokes the ancient voice of the wild upon themselves!"))

	if(spelltarget.anti_magic_check(TRUE, TRUE))
		return FALSE

	if(spell_guard_check(spelltarget, TRUE))
		spelltarget.visible_message(span_warning("[spelltarget] resists the voice of the Wild!"))
		return TRUE

	spelltarget.apply_status_effect(/datum/status_effect/buff/wildtongue, duration)
	to_chat(spelltarget,span_green("You feel the scent and instinct of the Wild settle into your spirit."))

	if(spelltarget == H)
		H.say(pick("Dendor, know me as thy kin.", "Treefather, let the wilds remember my spirit.",	"By fang, feather, soil, and rain! Let no beast raise tooth against me.", "Blessed Wilds, breathe thy scent upon my soul.", "From deepest burrow to eldest grove, let thy children know me in peace."), language = /datum/language/common)
	else
		H.say(pick("Dendor, know this soul as thy kin.", "Treefather, let the wilds remember this spirit kindly.", "By fang, feather, soil, and rain! May no beast raise tooth against thee.", "Blessed Wilds, breathe thy scent upon this wandering child.", "From deepest burrow to eldest grove, let thy children know peace with this one."),language = /datum/language/common)

	return TRUE

//////////////////////
// T0 - Bless Crops //
//////////////////////

/datum/action/cooldown/spell/dendor/blesscrop
	name = "Bless Crops"
	desc = "Bless crops in a small area, preventing their condition from decaying for 30 minutes. This revives dead plants, restores nutrition, and accelerates their growth. It does not restore hydration, nor can it be used on crops that are already blessed."
	fluff_desc = "The Treefather's mere gaze restores life to withered roots and calls bounty from the soil, for this is all within His domain, an extension of His will."
	button_icon = 'icons/mob/actions/dendormiracles.dmi'
	button_icon_state = "blesscrop"
	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	primary_resource_cost = 20
	secondary_resource_cost = 20
	charge_required = FALSE
	cooldown_time = 30 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/dendor/blesscrop/cast(atom/cast_on)
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE

	var/can_bless = FALSE

	for(var/turf/T in range(1, target_turf))
		for(var/obj/structure/soil/soil in T)
			// Skip soils still strongly blessed
			if(soil.blessed_time > 5 MINUTES)
				continue

			can_bless = TRUE
			break

		if(can_bless)
			break

	if(!can_bless)
		reset_spell_cooldown()
		return FALSE

	. = ..()

	var/blessed = FALSE
	var/amount_blessed = 0
	var/max_blessed = 9

	// 3x3 area
	for(var/turf/T in range(1, target_turf))
		if(amount_blessed >= max_blessed)
			break

		for(var/obj/structure/soil/soil in T)
			if(amount_blessed >= max_blessed)
				break

			// Cannot refresh unless near expiration
			if(soil.blessed_time > 5 MINUTES)
				continue

			soil.bless_soil()

			new /obj/effect/temp_visual/dendor_bless(T)

			blessed = TRUE
			amount_blessed++

	if(!blessed)
		reset_spell_cooldown()
		return FALSE

	owner.visible_message(span_green("[owner] calls upon Dendor's blessing, divine essence surging through the nearby soil!"), span_green("I call upon Dendor to bless the land."))
	owner.say(pick("The Treefather commands thee, be fruitful!", "In Dendor's name, be fruitful!", "May the harvest be bountiful this yil!", "May thine growth be blessed!", "Dendor's blessings and respite, o' nature's bounty!"))

	return TRUE

/obj/effect/temp_visual/dendor_bless
	name = "verdant blessing"
	icon = 'icons/effects/wizard_spell_effects.dmi'
	icon_state = "cleaning_pulse"
	duration = 8
	randomdir = 0
	color = "#00ff2a"

//T0 - Wild Hunt

#define DENDOR_AMBUSH_MIN 2
#define DENDOR_AMBUSH_MAX 9
#define WILD_HUNT_TRACK_RANGE 300

/datum/action/cooldown/spell/dendor/wildhunt
	name = "Wild Hunt"
	desc = "Invoke Dendor's primal call. Scour the land for signs of danger, track prey through instinct alone, or roar to draw the hunt to you."
	button_icon_state = "wildhunt"
	sound = 'sound/magic/whiteflame.ogg'
	primary_resource_cost = 30
	secondary_resource_cost = 30
	click_to_activate = FALSE
	charge_required = TRUE
	charge_time = 6 SECONDS
	charge_slowdown = 3
	cooldown_time = 2 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_SAME_Z
	var/list/hunt_howl_sounds = list('sound/vo/mobs/wwolf/howl (1).ogg', 'sound/vo/mobs/wwolf/howl (2).ogg')
	var/list/hunt_howl_sounds_far = list('sound/vo/mobs/wwolf/howldist (1).ogg', 'sound/vo/mobs/wwolf/howldist (2).ogg')

/datum/action/cooldown/spell/dendor/wildhunt/cast(atom/cast_on)
	. = ..()

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/choice = tgui_input_list(H, "Choose an aspect of the Wild Hunt.", "Wild Hunt", list(
		"Scour Area",
		"Thrill of the Hunt",
		"The Hunt is On!"
	))

	if(!choice)
		return FALSE

	switch(choice)

		if("Scour Area")
			scour_the_area(H)
			reset_spell_cooldown()
			return FALSE

		if("Thrill of the Hunt")
			if(!H.mind)
				reset_spell_cooldown()
				return FALSE

			if(!length(H.mind.known_people))
				to_chat(H, span_warning("I know no scents worth hunting."))
				reset_spell_cooldown()
				return FALSE

			var/mob/living/target = H.mind.display_known_people(H)

			if(!target)
				reset_spell_cooldown()
				return FALSE

			H.apply_status_effect(/datum/status_effect/buff/thrill_of_the_hunt, target)
			to_chat(H, span_red("My pulse quickens as I immerse in the thrill of the hunt..."))
			return TRUE

		if("The Hunt is On!")
			if(begin_wild_hunt(H))
				return TRUE

			reset_spell_cooldown()
			return FALSE

	return FALSE

/datum/action/cooldown/spell/dendor/wildhunt/proc/scour_the_area(mob/living/user)
	var/area/AR = get_area(user)
	var/datum/threat_region/TR = SSregionthreat.get_region(AR.threat_region)

	if(TR)
		to_chat(user, span_notice("This area is part of the [TR.region_name] threat region."))
	else
		to_chat(user, span_warning("This area lies beyond the Wild God's reach."))
		return FALSE

	if(TR.fixed_ambush)
		to_chat(user, span_warning("The creatures here are rooted to this place."))
		return TRUE

	if(user.get_will_block_ambush())
		to_chat(user, span_warning("This place is too well-lit for predators to gather."))
		return TRUE

	if(!user.get_possible_ambush_spawn(min_dist = DENDOR_AMBUSH_MIN, max_dist = DENDOR_AMBUSH_MAX))
		to_chat(user, span_warning("The land nearby is too sparse for lurking creatures."))
		return TRUE

	if(TR.last_induced_ambush_time && (world.time < TR.last_induced_ambush_time + 3 MINUTES))
		to_chat(user, span_warning("Something hunted here recently. The wilds are still unsettled."))
		return TRUE

	if(!TR.latent_ambush)
		to_chat(user, span_notice("The woods are calm. Nothing stirs nearby."))
		return TRUE

	switch(TR.latent_ambush)
		if(1 to 2)
			to_chat(user, span_notice("Something small prowls nearby."))
		if(3 to 4)
			to_chat(user, span_warning("Several hungry things roam these lands."))
		if(5 to 6)
			to_chat(user, span_userdanger("The wilds teem with dangerous life."))
		else
			to_chat(user, span_userdanger("A great hunt waits in the dark."))

	user.visible_message(span_boldwarning("[user] begins looking around with heightened senses..."))

	return TRUE

/datum/action/cooldown/spell/dendor/wildhunt/proc/begin_wild_hunt(mob/living/user)
	var/area/AR = get_area(user)
	var/datum/threat_region/TR = SSregionthreat.get_region(AR.threat_region)

	if(!TR || TR.fixed_ambush)
		to_chat(user, span_warning("The hunt cannot be called here."))
		return FALSE

	if(user.get_will_block_ambush())
		to_chat(user, span_warning("This place is too well-lit for the hunt to answer."))
		return FALSE

	if(!user.get_possible_ambush_spawn(min_dist = DENDOR_AMBUSH_MIN, max_dist = DENDOR_AMBUSH_MAX))
		to_chat(user, span_warning("There is nowhere for predators to emerge from here."))
		return FALSE

	if(TR.last_induced_ambush_time && (world.time < TR.last_induced_ambush_time + 3 MINUTES))
		to_chat(user, span_warning("The land has already tasted blood recently."))
		return FALSE

	if(!TR.latent_ambush)
		to_chat(user, span_notice("My howl fades into the distance. Nothing answers."))
		return FALSE

	user.visible_message(span_userdanger("[user] throws back their head and lets loose a primal hunting howl!"))

	user.apply_status_effect(/datum/status_effect/debuff/clickcd, 5 SECONDS)

	if(!do_after(user, 10 SECONDS))
		return FALSE

	user.visible_message(span_boldwarning("[user]'s howl echoes through the wilds!"))

	playsound(user, pick(hunt_howl_sounds), 100, TRUE)

	for(var/mob/living/player in GLOB.player_list)
		if(!player.mind)
			continue
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue
		if(player == user)
			continue
		var/turf/origin_turf = get_turf(user)
		var/player_distance = get_dist(player, origin_turf)
		// Only hear distant echo at range
		if(player_distance <= 7 || player_distance > 21)
			continue
		var/dirtext = "to the "
		var/direction = get_dir(player, origin_turf)
		switch(direction)
			if(NORTH)
				dirtext += "north"
			if(SOUTH)
				dirtext += "south"
			if(EAST)
				dirtext += "east"
			if(WEST)
				dirtext += "west"
			if(NORTHWEST)
				dirtext += "northwest"
			if(NORTHEAST)
				dirtext += "northeast"
			if(SOUTHWEST)
				dirtext += "southwest"
			if(SOUTHEAST)
				dirtext += "southeast"
			else
				dirtext = "though I cannot tell from where"

		player.playsound_local(get_turf(player), pick(hunt_howl_sounds_far), 50, FALSE, pressure_affected = FALSE)
		to_chat(player, span_warning("I hear a monstrous hunting howl somewhere [dirtext]!"))

	if(user.consider_ambush(always = TRUE, ignore_cooldown = TRUE, min_dist = DENDOR_AMBUSH_MIN, max_dist = DENDOR_AMBUSH_MAX, budget_multiplier_floor = rand(3, 6)))
		user.Immobilize(30)
		TR.last_induced_ambush_time = world.time
		return TRUE

	return FALSE

// THRILL OF THE HUNT branch
/atom/movable/screen/alert/status_effect/buff/thrill_of_the_hunt
	name = "Thrill of the Hunt"
	desc = "The hunt is on! They'll never escape from me now."

/datum/status_effect/buff/thrill_of_the_hunt
	id = "thrill_of_the_hunt"
	alert_type = /atom/movable/screen/alert/status_effect/buff/thrill_of_the_hunt
	duration = 5 MINUTES
	tick_interval = 2 SECONDS
	effectedstats = list(STATKEY_SPD = 2, STATKEY_WIL = 1)
	var/mob/living/tracked_target

/datum/status_effect/buff/thrill_of_the_hunt/on_creation(mob/living/new_owner, mob/living/target)
	. = ..()
	tracked_target = target

/datum/status_effect/buff/thrill_of_the_hunt/on_apply()
	ADD_TRAIT(owner, TRAIT_SLEUTH, "wild_hunt")
	ADD_TRAIT(owner, TRAIT_AZURENATIVE, "wild_hunt")
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, "wild_hunt")
	ADD_TRAIT(owner, TRAIT_NITEVISION, "wild_hunt")
	return TRUE

/datum/status_effect/buff/thrill_of_the_hunt/on_remove()
	REMOVE_TRAIT(owner, TRAIT_SLEUTH, "wild_hunt")
	REMOVE_TRAIT(owner, TRAIT_AZURENATIVE, "wild_hunt")
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, "wild_hunt")
	REMOVE_TRAIT(owner, TRAIT_NITEVISION, "wild_hunt")
	return ..()

/datum/status_effect/buff/thrill_of_the_hunt/tick()
	. = ..()

	if(!tracked_target || QDELETED(tracked_target))
		to_chat(owner, span_warning("The scent vanishes...?"))
		qdel(src)
		return
	if(tracked_target.stat == DEAD)
		to_chat(owner, span_notice("The prey's scent has gone cold."))
		qdel(src)
		return
	if(abs(owner.z - tracked_target.z) >= 2)
		to_chat(owner, span_warning("[tracked_target] (scent too thin)"))
		return
	var/dist = get_dist(owner, tracked_target)
	if(dist > WILD_HUNT_TRACK_RANGE)
		to_chat(owner, span_warning("[tracked_target] (scent too thin)"))
		return
	var/direction = dir2text(get_dir(owner, tracked_target))
	var/distance_text
	switch(dist)
		if(0 to 5)
			to_chat(owner, span_userdanger("I've found the prey."))
			qdel(src)
			return
		if(6 to 15)
			distance_text = "nearby"
		if(16 to 40)
			distance_text = "some distance away"
		if(41 to 100)
			distance_text = "far away"
		else
			distance_text = "very distant"

	to_chat(owner, span_green("I smell [tracked_target] to the [direction] — [distance_text]."))

#undef DENDOR_AMBUSH_MIN
#undef DENDOR_AMBUSH_MAX
#undef WILD_HUNT_TRACK_RANGE

/////////////////////
// T? - Tame Beast //
/////////////////////
//Apparently not for this PR and not for any other PR
/obj/effect/proc_holder/spell/targeted/beasttame
	name = "Tame Beast"
	desc = "Tames a targeted saiga, chicken, cow, goat, volf or spider to be non hostile and tamed."
	range = 5
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "tamebeast"
	releasedrain = 30
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("Be still and calm, brotherbeast.")
	invocation_type = "whisper" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 20
	var/beast_tameable_factions = list("saiga", "chickens", "cows", "goats", "wolfs", "spiders")

/obj/effect/proc_holder/spell/targeted/beasttame/cast(list/targets,mob/user = usr)
	. = ..()
	visible_message(span_green("[usr] soothes the beastblood with Dendor's whisper."))
	var/tamed = FALSE
	for(var/mob/living/simple_animal/hostile/retaliate/animal in get_hearers_in_view(2, usr))
		if((animal.mob_biotypes & MOB_UNDEAD))
			continue
		if(faction_check(animal.faction, beast_tameable_factions))
			animal.tamed(TRUE)
			animal.aggressive = FALSE
			if(animal.ai_controller)
				animal.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
				animal.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
				animal.ai_controller.set_blackboard_key(BB_BASIC_MOB_TAMED, TRUE)
			to_chat(usr, "With Dendor's aide, you soothe [animal] of their anger.")
	return tamed

//////////////////////////////
// T3 - Fungal Illumination //
//////////////////////////////

/obj/effect/proc_holder/spell/targeted/conjure_glowshroom
	name = "Fungal Illumination"
	desc = "Summons glowing mushrooms that shock people that try moving into them. Dendorites are immune."
	range = 1
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "blesscrop"
	releasedrain = 30
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/items/dig_shovel.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("Treefather light the way.")
	invocation_type = "whisper" //can be none, whisper, emote and shout
	devotion_cost = 30

/obj/effect/proc_holder/spell/targeted/conjure_glowshroom/cast(list/targets, mob/user = usr)
	..()
	to_chat(user, span_notice("I begin enriching the soil around me!"))
	if(!do_after(user, 0.5 SECONDS, progress = TRUE))
		revert_cast()
		return FALSE

	var/turf/T = user.loc
	for(var/X in GLOB.cardinals)
		var/turf/TT = get_step(T, X)
		if(!isclosedturf(TT) && !locate(/obj/structure/glowshroom) in TT)
			new /obj/structure/glowshroom(TT)
	return TRUE


//////////////////////
// T3 - Vine Sprout //
//////////////////////

/obj/effect/proc_holder/spell/targeted/conjure_vines
	name = "Vine Sprout"
	desc = "Summon vines nearby."
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "blesscrop"
	releasedrain = 30
	invocations = list("Treefather, bring forth vines.")
	invocation_type = "shout"
	devotion_cost = 30
	range = 1
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/items/dig_shovel.ogg'
	associated_skill = /datum/skill/magic/holy
	miracle = TRUE

/obj/effect/proc_holder/spell/targeted/conjure_vines/cast(list/targets, mob/user = usr)
	. = ..()
	var/turf/target_turf = get_step(user, user.dir)
	var/turf/target_turf_two = get_step(target_turf, turn(user.dir, 90))
	var/turf/target_turf_three = get_step(target_turf, turn(user.dir, -90))
	if(!locate(/obj/structure/vine) in target_turf)
		new /obj/structure/vine/dendor(target_turf)
	if(!locate(/obj/structure/vine) in target_turf_two)
		new /obj/structure/vine/dendor(target_turf_two)
	if(!locate(/obj/structure/vine) in target_turf_three)
		new /obj/structure/vine/dendor(target_turf_three)

	return TRUE

///////////////////////////
// T4 - Call of the Moon //
///////////////////////////

/obj/effect/proc_holder/spell/self/howl/call_of_the_moon
	name = "Call of the Moon"
	desc = "Draw upon the secrets of the hidden firmament to converse with the mooncursed."
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "howl"
	antimagic_allowed = FALSE
	recharge_time = 600
	ignore_cockblock = TRUE
	use_language = TRUE
	var/first_cast = FALSE

/obj/effect/proc_holder/spell/self/howl/call_of_the_moon/cast(mob/living/carbon/human/user)
	// only usable at night
	if (!GLOB.tod == "night")
		to_chat(user, span_warning("I must wait for the hidden moon to rise before I may call upon it."))
		revert_cast()
		return
	// if they don't have beast language somehow, give it to them
	if (!user.has_language(/datum/language/beast))
		user.grant_language(/datum/language/beast)
		to_chat(user, span_boldnotice("The vestige of the hidden moon high above reveals His truth: the knowledge of beast-tongue was in me all along."))
	
	if (!first_cast)
		to_chat(user, span_boldwarning("So it is murmured in the Earth and Air: the Call of the Moon is sacred, and to share knowledge gleaned from it with those not of Him is a SIN."))
		to_chat(user, span_boldwarning("Ware thee well, child of Dendor."))
		first_cast = TRUE
	. = ..()
