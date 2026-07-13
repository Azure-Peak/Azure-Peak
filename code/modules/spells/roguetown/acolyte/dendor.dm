/datum/action/cooldown/spell/dendor
	background_icon = 'icons/mob/actions/dendormiracles.dmi'
	button_icon = 'icons/mob/actions/dendormiracles.dmi'
	spell_color = GLOW_COLOR_DENDOR

	attunement_school = null

	primary_resource_type = SPELL_COST_DEVOTION

	secondary_resource_type = SPELL_COST_STAMINA

	ignore_armor_penalty = TRUE

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/holy

	spell_tier = 0
	point_cost = 0

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/dendor, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

///////////////////
// T0 - Entangle //
///////////////////

/datum/action/cooldown/spell/dendor/entangle
	name = "Entangle"
	desc = "Lash out with line of vines, immobilizing your target and dealing damage."
	background_icon = 'icons/mob/actions/dendormiracles.dmi'
	button_icon = 'icons/mob/actions/dendormiracles.dmi'
	button_icon_state = "entangle"
	blade_class = BCLASS_LASHING
	windup_time = TELEGRAPH_DODGEABLE
	damage = 25
	npc_simple_damage_mult = 2
	sweep_step = 0
	impact_delay = 4
	detonate_sound = null
	immobilize_on_hit = 0.5 SECONDS

	parent_type = /datum/action/cooldown/spell/telegraphed_strike
	sound = 'sound/misc/chain_snap.ogg'

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR + 20

	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_MIRACLE

	invocations = list("Stay awhile!")
	invocation_type = INVOCATION_SHOUT

	cooldown_time = 45 SECONDS
	charging_slowdown = 1

	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN
	associated_stat = null
	associated_skill = /datum/skill/magic/holy

	telegraph_type = /obj/effect/temp_visual/trap/dendor

/datum/action/cooldown/spell/dendor/entangle/get_pattern_offsets()
	return list(
		list(0, 1),
		list(0, 2),
		list(0, 3),
	)

/datum/action/cooldown/spell/dendor/entangle/on_impact(mob/living/carbon/human/H, facing, atom/movable/visual)
	var/turf/T = get_step(get_turf(H), facing) || get_turf(H)
	if(!T)
		return
	playsound(T, pick('sound/combat/hits/onwood/woodimpact (1).ogg', 'sound/combat/hits/onwood/woodimpact (2).ogg'), 90, TRUE, 4)
	playsound(T, 'sound/magic/repulse.ogg', 55, TRUE, 3)
	new /obj/effect/temp_visual/spell_impact(T, spell_color, SPELL_IMPACT_HIGH)
	if(QDELETED(visual))
		return
/*	var/rest = visual.pixel_y
	animate(visual, pixel_y = rest + 4, time = 1, easing = SINE_EASING | EASE_OUT)
	animate(pixel_y = rest, time = 1, easing = SINE_EASING | EASE_IN)
	animate(alpha = 0, time = 3)
*/

/obj/effect/temp_visual/trap/dendor
	color = GLOW_COLOR_DENDOR
	light_color = GLOW_COLOR_DENDOR
	duration = 8

//////////////////////
// T0 - Bless Crops //
//////////////////////

/datum/action/cooldown/spell/dendor/bless
	name = "Bless Crops"
	desc = "Bless up to five crops around you. Revives dead plants, gives them nutrition and water if low and boosts their growth."
	button_icon_state = "blesscrop"
	sound = 'sound/magic/churn.ogg'

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_AURA

	primary_resource_cost = SPELLCOST_MIRACLE - 10

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocations = list("The Treefather commands thee, be fruitful!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 30 SECONDS

	spell_requirements = SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/dendor/bless/cast(atom/cast_on)
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
		usr.visible_message(span_green("[usr] blesses the nearby crops with Dendor's Favour!"))
	return growed

/datum/action/cooldown/spell/dendor/bless/secular
	primary_resource_cost = 0
	secondary_resource_cost = SPELLCOST_MIRACLE + 10

	invocations = list("Cow pie n' raw sod, makes th' rye! Drink it down an' kiss the sky!",
					   "Cow pie n' raw sod, makes th' rye! That foul drink'll make ye cry!",
					   "Cow pie n' raw sod, makes th' rye! By the gods, I'd rather die!",
					   "Cow pie n' raw sod, makes th' rye! Even goats refuse to try!",
					   "Compost rich n' dark as sin, makes the harvest rollin' in!",
					   "Compost steamed in morning dew, makes the garden fresh an' new!",
					   "Manure fresh from stable floor, makes the crops grow more an' more!",
					   "Manure n' maggots, squirm n' crawl, makes the tallest cornstalks tall!",
					   "Sludge n' slurry, thick n' brown, makes the greenest crop in town!")
	cooldown_time = 33 SECONDS
	required_items = null

///////////////////
// T1 - Wyldcall //
///////////////////

/datum/action/cooldown/spell/conjure_summon/dendor_wolf
	name = "Wyldcall"
	desc = "Conjure a Primordial to fight at your side. Toggle its element with Shift+G while the spell is selected: Flame, Water, or Air. \
	It grows mightier with your skill at Arcyne Armament - upgrading at Expert, and further at Master. You can maintain only one at a time - recast to re-summon, or use Dismiss Conjuration to release it safely."
	button_icon_state = "primetriangle"
	invocations = list("Volp :3")
	sound = 'sound/magic/dendor_summon.ogg'
	summon_noun = "dyrevolf"
	recoil_energy_floor = 150
	modes = list(
		list("name" = "Ancient", "tag" = "ANCIENT", "path" = /mob/living/simple_animal/hostile/retaliate/rogue/dyrevolf/ancient, "color" = GLOW_COLOR_DENDOR, "invocation" = "Ancient one, rise!"),
		//list("name" = "Water", "tag" = "WATER", "path" = /mob/living/simple_animal/hostile/retaliate/rogue/dyrevolf/water, "color" = GLOW_COLOR_ICE, "invocation" = "Exsurge, unda!"),
		//list("name" = "Air", "tag" = "AIR", "path" = /mob/living/simple_animal/hostile/retaliate/rogue/dyrevolf/air, "color" = "#cfe8ff", "invocation" = "Exsurge, ventus!"),
	)

/datum/action/cooldown/spell/conjure_summon/dendor_wolf/spawn_summon(turf/T, mob/living/user)
	var/mob_path = modes[current_mode]["path"]
	var/mob/living/simple_animal/hostile/retaliate/rogue/dyrevolf/conjured = new mob_path(T, user)
	scale_dyrevolf(conjured, user)
	return conjured

/datum/action/cooldown/spell/conjure_summon/dendor_wolf/proc/scale_dyrevolf(mob/living/simple_animal/hostile/retaliate/rogue/dyrevolf/P, mob/living/user)
	var/lvl = clamp(user.get_skill_level(/datum/skill/magic/holy), 1, 6)
	var/tier = get_summon_tier(user)
	var/mult = 0.7 + (lvl * 0.1) + (tier - 1) * 0.25
	P.maxHealth = round(P.maxHealth * mult)
	P.health = P.maxHealth
	P.melee_damage_lower = round(P.melee_damage_lower * mult)
	P.melee_damage_upper = round(P.melee_damage_upper * mult)

////////////////////////
// T2 - Howl (Dendor) //
////////////////////////

/datum/action/cooldown/spell/dendor/howl
	name = "Primal Howl"
	desc = "Grants you and all allies nearby a buff to their strength, willpower, and constitution while taking away willpower and constitution from ascendant worshippers."
	sound = 'sound/magic/dendor_howl.ogg'

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_AURA

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR - 10

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocation_type = INVOCATION_SHOUT
	invocations = list("By Ravox, stand and fight!")

	charge_required = FALSE
	cooldown_time = 5 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/dendor/howl/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	for(var/mob/living/carbon/target in view(cast_range, get_turf(owner)))
		if(istype(target.patron, /datum/patron/inhumen))
			target.apply_status_effect(/datum/status_effect/debuff/call_to_arms)	//Debuffs inhumen worshipers.
			continue
		if(istype(target.patron, /datum/patron/old_god))
			to_chat(target, span_danger("You feel a hot-wave wash over you, leaving as quickly as it came.."))	//No effect on Psydonians!
			continue
		if(!owner.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/buff/call_to_arms)
	return TRUE

































































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


///////////////////////
// T? - Spider Speak //
///////////////////////
//Kept here for the Hag not much else, the actual effect is on the ritual for Dendorites.
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
