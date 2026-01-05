//chest mimic, ported from ratwood

/mob/living/simple_animal/hostile/retaliate/rogue/mimic
	name = "chest"
	desc = "A wooden chest with a lid held on metal hinges."
	icon = 'icons/roguetown/mob/monster/mimic.dmi'
	icon_state = "mimicopen"
	icon_living = "mimicopen"
	icon_dead = "mimicdead"

	speed = 0
	maxHealth = MIMIC_HEALTH
	health = MIMIC_HEALTH
	gender = NEUTER
	mob_biotypes = NONE
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2, /obj/effect/spawner/lootdrop/valuable_jewelry_spawner = 1)
	retreat_distance = 0
	minimum_distance = 0
	aggro_vision_range = 2
	see_in_dark = 6

	damage_coeff = list(BRUTE = 1, BURN = 0, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 40
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = list('sound/vo/mobs/mimic/mimic_attack1.ogg',
						'sound/vo/mobs/mimic/mimic_attack2.ogg',
						'sound/vo/mobs/mimic/mimic_attack3.ogg')
	emote_taunt = list("howls")
	speak_emote = list("clatters")

	faction = list("mimic", "hostile")
	stop_automated_movement = 1
	wander = 0
	stat_attack = UNCONSCIOUS

	food_type = list(/obj/item/reagent_containers/food/snacks/rogue/meat, /obj/item/bodypart, /obj/item/organ)
	food = 0
	pooptype = null

	STACON = 15
	STASTR = 15
	STASPD = 5

	ai_controller = /datum/ai_controller/mimic
	AIStatus = AI_OFF
	can_have_ai = FALSE
	/// The typepath of the chest this mimic is mimicking.
	var/obj/structure/closet/crate/chest/mimicking_chest = /obj/structure/closet/crate/chest

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/Initialize(mapload)
	. = ..()
	if(mapload)//load objects into chest.
		for(var/obj/item/I in loc)
			I.forceMove(src)
	name = mimicking_chest::name
	icon = mimicking_chest::icon
	icon_state = mimicking_chest::icon_state
	AddComponent(/datum/component/anti_magic, TRUE, TRUE, TRUE, null, null, FALSE)

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/examine(mob/user)
	if(aggressive)
		return ..() // we've gone mask-off!
	. = list("[get_examine_string(user, TRUE)].[get_inspect_button()]")
	if(mimicking_chest::desc)
		. += span_info("[mimicking_chest::desc]")

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/find_food()
	. = ..()
	if(!.)
		return eat_bodies()

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/attack_hand(mob/user)
	..()
	Retaliate(user)
	GiveTarget(user)

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/proc/disguise()
	if(stat)
		return // can't disguise while unconscious or dead!
	name = mimicking_chest::name
	icon = mimicking_chest::icon
	icon_state = mimicking_chest::icon_state

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/proc/undisguise()
	name = "\improper MIMIC"
	icon = initial(icon)
	icon_state = (stat == DEAD) ? icon_dead : icon_living

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/Aggro()
	..()
	// go mask-off!
	undisguise()
	aggressive = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/death()
	// Drop loot onto tile.
	for(var/obj/O in src)
		O.forceMove(loc)
	..()

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/get_sound(input)
	switch(input)
		if("death")
			return pick('sound/vo/mobs/mimic/mimic_death.ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/simple_limb_hit(zone)
	if(!zone || !aggressive) // don't talk about bodyparts while disguised!
		return ""
	switch(zone)
		if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/mimic/gold
	mimicking_chest = /obj/structure/closet/crate/chest/gold

//////
// Landmark
//////

/obj/effect/landmark/chest_or_mimic
	var/mimic_type = /mob/living/simple_animal/hostile/retaliate/rogue/mimic
	var/chest_type = /obj/structure/closet/crate/chest

/obj/effect/landmark/chest_or_mimic/Initialize()
	..()
	var/C = pick(mimic_type, chest_type)
	new C(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/chest_or_mimic/gold
	mimic_type = /mob/living/simple_animal/hostile/retaliate/rogue/mimic/gold
	chest_type = /obj/structure/closet/crate/chest/gold

/obj/effect/landmark/chest_or_mimic/locked_or_trapped
	mimic_type = /obj/structure/closet/crate/chest/trapped/locked
	chest_type = /obj/structure/closet/crate/chest/loot_chest/locked
