/datum/action/cooldown/spell/avenging_kittens
	button_icon = 'icons/mob/actions/mage_kittenomancy.dmi'
	name = "Avenging Kittens"
	desc = "Summon three vengeful cat spirits to tear at an opponent. \
	The spirits will relentlessly pursue and attack the target for 30 seconds before fading."
	button_icon_state = "avenging_kittens"
	sound = 'sound/magic/magnet.ogg'
	spell_color = GLOW_COLOR_HEX
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_KITTENOMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Feles Vindimeow!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 25 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/avenging_kittens/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("I need a target for the spirits!"))
		return FALSE

	var/mob/living/target = cast_on
	if(target.anti_magic_check())
		to_chat(H, span_warning("The target's antimagic repels the spirits!"))
		return FALSE

	var/list/spawn_turfs = list()
	if(H.dir == SOUTH || H.dir == NORTH)
		spawn_turfs += get_turf(H)
		spawn_turfs += get_step(H, EAST)
		spawn_turfs += get_step(H, WEST)
	else
		spawn_turfs += get_turf(H)
		spawn_turfs += get_step(H, NORTH)
		spawn_turfs += get_step(H, SOUTH)

	for(var/turf/T in spawn_turfs)
		var/mob/living/simple_animal/hostile/rogue/avenging_cat/cat = new(T, H)
		cat.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)

	H.visible_message(span_warning("[H] summons a trio of vengeful cat spirits!"), span_notice("I unleash the avenging kittens!"))
	return TRUE

// Avenging cat spirit mob - based on spirit_vengeance but cat-themed
/mob/living/simple_animal/hostile/rogue/avenging_cat
	name = "avenging cat spirit"
	desc = "A spectral feline wreathed in arcyne fury. Its eyes burn with otherworldly malice."
	icon = 'icons/mob/pets.dmi'
	icon_state = "cat2"
	icon_living = "cat2"
	gender = FEMALE
	mob_biotypes = MOB_BEAST
	robust_searching = 1
	turns_per_move = 1
	move_to_delay = 3
	STACON = 9
	STASTR = 9
	STASPD = 14
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 24
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	base_intents = list(/datum/intent/simple/bite)
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/vo/mobs/cat/roar3.ogg'
	canparry = TRUE
	d_intent = INTENT_DODGE
	defprob = 20
	footstep_type = null
	del_on_death = TRUE
	can_have_ai = FALSE
	AIStatus = AI_OFF
	ai_controller = /datum/ai_controller/spirit_vengeance
	melee_cooldown = SKELETON_ATTACK_SPEED

/mob/living/simple_animal/hostile/rogue/avenging_cat/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/cat/roar1.ogg', 'sound/vo/mobs/cat/cat_meow1.ogg')
		if("death")
			return 'sound/vo/mobs/cat/cat_meow1.ogg'

/mob/living/simple_animal/hostile/rogue/avenging_cat/Initialize(mapload)
	. = ..()
	alpha = 180
	add_filter("cat_glow", 2, list("type" = "outline", "color" = GLOW_COLOR_HEX, "alpha" = 60, "size" = 1))
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal, death), TRUE), 30 SECONDS)
