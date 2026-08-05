///////////////////////
// T0 - Spider Speak //
///////////////////////

/obj/effect/proc_holder/spell/invoked/spiderspeak
	name = "Spider Speak"
	desc = "Makes spiders not attack the target."
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "tamebeast"
	releasedrain = 15
	chargedrain = 0
	chargetime = 1 SECONDS
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/churn.ogg'
	invocations = list("Spiders of Psydonia, allow me to pass safely!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	recharge_time = 4 SECONDS
	miracle = TRUE
	devotion_cost = 25

/obj/effect/proc_holder/spell/invoked/spiderspeak/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		target.visible_message("<font color='yellow'>[user] infuses [target] with swirling strands of spectral webs!</font>", "<font color='yellow'>You feel your tongue shift strangely, producing odd clicking noises.</font>")
		target.apply_status_effect(/datum/status_effect/buff/spider_speak)
		return TRUE
	revert_cast()
	return FALSE

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

// What the blazes is a corn?
// Given to soilsons and farmers.
/obj/effect/proc_holder/spell/targeted/blesscrop/secular
	miracle = FALSE
	devotion_cost = 0
	req_items = list()
	// Slightly more since no psycross
	releasedrain = 40
	recharge_time = 33 SECONDS
	invocations = list("Cow pie n' raw sod, makes th' rye! Drink it down an' kiss the sky!",
					   "Cow pie n' raw sod, makes th' rye! That foul drink'll make ye cry!",
					   "Cow pie n' raw sod, makes th' rye! By the gods, I'd rather die!",
					   "Cow pie n' raw sod, makes th' rye! Even goats refuse to try!",
					   "Compost rich n' dark as sin, makes the harvest rollin' in!",
					   "Compost steamed in morning dew, makes the garden fresh an' new!",
					   "Manure fresh from stable floor, makes the crops grow more an' more!",
					   "Manure n' maggots, squirm n' crawl, makes the tallest cornstalks tall!",
					   "Sludge n' slurry, thick n' brown, makes the greenest crop in town!")

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
