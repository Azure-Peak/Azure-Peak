/mob/living/simple_animal/hostile/rogue/zardman_jailer_mage
	name = "Zardman Jailer"
	desc = ""
	icon = 'icons/mob/zard_guard_mage.dmi'
	icon_state = "zard_guard_mage"
	icon_living = "zard_guard_mage"
	icon_dead = "zard_guard_mage_dead"
	gender = FEMALE
	mob_biotypes = MOB_HUMANOID
	robust_searching = 1
	turns_per_move = 1
	move_to_delay = 3
	STACON = 10
	STASTR = 10
	STASPD = 10
	STAINT = 18
	maxHealth = DRAGGER_HEALTH
	health = DRAGGER_HEALTH
	ranged = 1
	rapid = 1
	rapid_fire_delay = 10
	ranged_message = "casts a spell"
	ranged_cooldown = 0
	ranged_cooldown_time = 45
	ranged_ignores_vision = TRUE
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	limb_destroyer = 1
	d_intent = INTENT_PARRY
	defprob = 50
	faction = list(FACTION_PSY_VAULT_GUARD)
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = FALSE

	can_have_ai = FALSE //disable native ai
	AIStatus = AI_OFF
	ai_controller = /datum/ai_controller/skeleton_ranged/event
	melee_cooldown = SKELETON_ATTACK_SPEED

	projectiletype = /obj/projectile/magic/zardman_jailer_mage/lightning
	projectilesound = list('sound/magic/charged.ogg')

/mob/living/simple_animal/hostile/rogue/zardman_jailer_mage/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/obj/projectile/magic/zardman_jailer_mage/lightning/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			L.Immobilize(1, src)
			playsound(get_turf(src), pick('sound/misc/elec (1).ogg', 'sound/misc/elec (2).ogg', 'sound/misc/elec (3).ogg'), 100, FALSE)
	qdel(src)

/obj/projectile/magic/zardman_jailer_mage/lightning
	name = "bolt of lightning"
	tracer_type = /obj/effect/projectile/tracer/stun
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	light_color = LIGHT_COLOR_WHITE
	damage = 25
	damage_type = BURN
	nodamage = FALSE
	speed = 0.3
	flag = "fire"
	light_color = "#ffffff"
/obj/projectile/magic/zardman_jailer_mage/lightning/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			L.Immobilize(1, src)
			playsound(get_turf(src), pick('sound/misc/elec (1).ogg', 'sound/misc/elec (2).ogg', 'sound/misc/elec (3).ogg'), 100, FALSE)
	qdel(src)

/mob/living/simple_animal/hostile/rogue/zardman_jailer_mage/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()

/obj/effect/oneway/psy_bog //one way barrier to the boss room. Can be despawned with the key the boss drops.
	name = "magical barrier"
	max_integrity = 99999
	desc = "Victory or death - once you pass this point you will either triumph or fall. Recommended 6 players or more."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	invisibility = SEE_INVISIBLE_LIVING
	anchored = TRUE

/obj/effect/oneway/psy_bog/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/roguekey/psy_bog/exit))
		visible_message(span_boldannounce("The magical barrier disperses!"))
		qdel(src)

/obj/effect/oneway/psy_bog_two //one way barrier to the boss room. Can be despawned with the key the boss drops.
	name = "magical barrier"
	max_integrity = 99999
	desc = "Victory or death - once you pass this point you will either triumph or fall. Recommended 6 players or more."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	invisibility = SEE_INVISIBLE_LIVING
	anchored = TRUE

/obj/effect/oneway/psy_bog_two/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/roguekey/psy_bog/two))
		visible_message(span_boldannounce("The magical barrier disperses!"))
		qdel(src)


//Loot
/obj/item/roguekey/psy_bog/exit
	name = "Rusted key"
	desc = "A strange key...ever enduring."
	icon_state = "rustkey"
	lockid = "psy_bog_dung_lootkey"

/obj/item/roguekey/psy_bog/two
	name = "Rusted key"
	desc = "A strange key...ever enduring."
	icon_state = "rustkey"
	lockid = "psy_bog_dung_lootkey_two"
