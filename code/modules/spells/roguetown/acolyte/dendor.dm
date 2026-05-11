///////////////////////
// T0 - Spider Speak //
///////////////////////

/datum/action/cooldown/spell/dendor/wildspeak
	name = "Wild Speak"
	desc = "Infuses a target with the mind, scent and instinct of the Wild. Beasts and primordial creatures will recognize them as kin, and they can speak the language of the beasts."
	fluff_desc = "The oldest druids spoke not with words, but scent, breath, instinct, and spirit. Through Dendor's blessing, the Wild remembers its own."
	button_icon = 'icons/mob/actions/dendormiracles.dmi'
	button_icon_state = "tamebeast"
	sound = 'sound/magic/churn.ogg'
	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE
	primary_resource_cost = 25
	secondary_resource_cost = SPELLCOST_CANTRIP
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 30 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	associated_skill = /datum/skill/magic/holy
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

/obj/effect/proc_holder/spell/targeted/blesscrop
	name = "Bless Crops"
	desc = "Bless up to five crops around you. Revives dead plants, gives them nutrition and water if low and boosts their growth."
	range = 5
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "blesscrop"
	releasedrain = 30
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("The Treefather commands thee, be fruitful!")
	invocation_type = "shout" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 20

/obj/effect/proc_holder/spell/targeted/blesscrop/cast(list/targets,mob/user = usr)
	. = ..()
	var/growed = FALSE
	var/amount_blessed = 0
	for(var/obj/structure/soil/soil in view(4))
		soil.bless_soil()
		growed = TRUE
		amount_blessed++
		// Blessed only up to 5 crops
		if(amount_blessed >= 5)
			break
	if(growed)
		visible_message(span_green("[usr] blesses the nearby crops with Dendor's Favour!"))
	return growed

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
