/mob/living/simple_animal/hostile/rogue/skeleton
	name = "Skeleton"
	desc = ""
	icon = 'modular_hearthstone/icons/mob/skeletons.dmi'
	icon_state = "skeleton"
	icon_living = "skeleton"
	icon_dead = "skeleton_dead"
	gender = MALE
	mob_biotypes = MOB_UNDEAD|MOB_HUMANOID
	robust_searching = 1
	turns_per_move = 1
	move_to_delay = 3
	STACON = 9
	STASTR = 9
	STASPD = 8
	maxHealth = SKELETON_HEALTH
	health = SKELETON_HEALTH
	harm_intent_damage = 10
	melee_damage_lower = 10
	melee_damage_upper = 25
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	limb_destroyer = 1
	base_intents = list(/datum/intent/simple/claw/skeleton)
	attack_verb_continuous = "hacks"
	attack_verb_simple = "hack"
	attack_sound = 'sound/blank.ogg'
	canparry = TRUE
	d_intent = INTENT_PARRY
	defprob = 50
	speak_emote = list("grunts")
	loot = list(/obj/item/natural/bone,	/obj/item/natural/bone, /obj/item/natural/bone,	/obj/item/skull)
	faction = list("undead")
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = TRUE
	var/start_take_damage = FALSE
	var/damage_check
	var/wither = 2.5
	var/newcolor = rgb(207, 135, 255) //used for livetime code.

	can_have_ai = FALSE //disable native ai
	AIStatus = AI_OFF
	ai_controller = /datum/ai_controller/simple_skeleton
	melee_cooldown = SKELETON_ATTACK_SPEED

/mob/living/simple_animal/hostile/rogue/skeleton/Initialize(mapload, mob/user, cabal_affine, is_summoned)
	. = ..()
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/rogue/skeleton/axe
	name = "Skeleton"
	desc = ""
	icon = 'modular_hearthstone/icons/mob/skeletons.dmi'
	base_intents = list(/datum/intent/simple/axe/skeleton)
	icon_state = "skeleton_axe"
	icon_living = "skeleton_axe"
	icon_dead = ""
	loot = list(/obj/item/natural/bone,	/obj/item/natural/bone, /obj/item/natural/bone,	/obj/item/rogueweapon/stoneaxe/woodcut, /obj/item/skull)

/mob/living/simple_animal/hostile/rogue/skeleton/spear
	name = "Skeleton"
	desc = ""
	icon = 'modular_hearthstone/icons/mob/skeletons.dmi'
	base_intents = list(/datum/intent/simple/spear/skeleton)
	icon_state = "skeleton_spear"
	icon_living = "skeleton_spear"
	icon_dead = ""
	attack_sound = 'sound/foley/pierce.ogg'
	loot = list(/obj/item/natural/bone,	/obj/item/natural/bone, /obj/item/natural/bone,	/obj/item/rogueweapon/spear, /obj/item/skull)
	ai_controller = /datum/ai_controller/skeleton_spear

/mob/living/simple_animal/hostile/rogue/skeleton/guard
	name = "Skeleton"
	desc = ""
	icon = 'modular_hearthstone/icons/mob/skeletons.dmi'
	base_intents = list(/datum/intent/simple/axe/skeleton)
	icon_state = "skeleton_guard"
	icon_living = "skeleton_guard"
	icon_dead = ""
	loot = list(/obj/item/natural/bone,	/obj/item/natural/bone, /obj/item/natural/bone,	/obj/item/rogueweapon/sword/iron, /obj/item/skull)
	maxHealth = 200
	health = 200

/mob/living/simple_animal/hostile/rogue/skeleton/bow
	name = "Skeleton"
	desc = ""
	icon = 'modular_hearthstone/icons/mob/skeletons.dmi'
	icon_state = "skeleton_bow"
	icon_living = "skeleton_bow"
	icon_dead = ""
	projectiletype = /obj/projectile/bullet/reusable/arrow/ancient
	projectilesound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	ranged_cooldown_time = 60
	check_friendly_fire = 1
	loot = list(
			/obj/item/natural/bone,
			/obj/item/natural/bone,
			/obj/item/natural/bone,
			/obj/item/skull,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow,
			/obj/item/ammo_casing/caseless/rogue/arrow/iron,
			/obj/item/ammo_casing/caseless/rogue/arrow/iron,
			/obj/item/ammo_casing/caseless/rogue/arrow/iron,
			)
	ai_controller = /datum/ai_controller/skeleton_ranged

/mob/living/simple_animal/hostile/rogue/skeleton/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/skel/skeleton_rage (1).ogg','sound/vo/mobs/skel/skeleton_rage (2).ogg','sound/vo/mobs/skel/skeleton_rage (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/skel/skeleton_pain (1).ogg','sound/vo/mobs/skel/skeleton_pain (2).ogg','sound/vo/mobs/skel/skeleton_pain (3).ogg', 'sound/vo/mobs/skel/skeleton_pain (4).ogg', 'sound/vo/mobs/skel/skeleton_pain (5).ogg')
		if("death")
			return pick('sound/vo/mobs/skel/skeleton_death (1).ogg','sound/vo/mobs/skel/skeleton_death (2).ogg','sound/vo/mobs/skel/skeleton_death (3).ogg','sound/vo/mobs/skel/skeleton_death (4).ogg','sound/vo/mobs/skel/skeleton_death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/skel/skeleton_idle (1).ogg','sound/vo/mobs/skel/skeleton_idle (2).ogg','sound/vo/mobs/skel/skeleton_idle (3).ogg')


/mob/living/simple_animal/hostile/rogue/skeleton/Initialize(mapload, mob/user, cabal_affine = FALSE, is_summoned = FALSE)
	. = ..()
	if(user)
		if(user.mind && user.mind.current)
			summoner = user.mind.current.real_name
		else
			summoner = user.name
	if (is_summoned || cabal_affine)
		faction = list("cabal") //No mix undead faction and cabal, summoned skeletons can attack any undead, mark your friends
	// adds the name of the summoner to the faction, to avoid the hooded "Unknown" bug with Skeleton IDs
	if(user && user.mind && user.mind.current)
		faction = list("[user.mind.current.real_name]_faction") //if you summon this, he not affected on cabal. This skeletons can attack any undead and other zizo affected characters
		// lich also gets to have friendlies, as a treat
		var/datum/antagonist/lich/lich_antag = user.mind.has_antag_datum(/datum/antagonist/lich)
		if(lich_antag && user.real_name)
			faction = list("undead", "[user.mind.current.real_name]_faction", "[user.real_name]_faction") //no changes. Undead faction + lich_name faction
		if(user.mind.warband_ID != 0)
			faction |= list("warband_[user.mind.warband_ID]")
	damage_check = world.time
	if(is_summoned) //check, if it NOT summoned skeleton, he lifetime - infinity. For mapping-spawned skeltons
		addtimer(CALLBACK(src, PROC_REF(deathtime)), 1 MINUTES)

/mob/living/simple_animal/hostile/rogue/skeleton/proc/deathtime()
	target.add_atom_colour(newcolor, ADMIN_COLOUR_PRIORITY)
	start_take_damage = TRUE

/mob/living/simple_animal/hostile/rogue/skeleton/Life(mob/user)
	. = ..()
	if(!target)
		if(prob(60))
			emote(pick("idle"), TRUE)
	if(start_take_damage == TRUE)
		if(world.time > damage_check + 5 SECONDS)
			src.adjustFireLoss(8) //+- one minute for 100 HP (any skeleton) and two minute for guard skeleton (200 HP)

/mob/living/simple_animal/hostile/rogue/skeleton/taunted(mob/user)
	emote("aggro")
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/rogue/skeleton/proc/can_control(mob/user)
	if(!(user.mind?.has_antag_datum(/datum/antagonist/lich)))
		return FALSE
	if (!(user.name in friends))
		return FALSE
	
	return TRUE

/mob/living/simple_animal/hostile/rogue/skeleton/beckoned(mob/user)
	if (can_control(user))
		for(var/mob/living/simple_animal/hostile/rogue/skeleton/target in viewers(user))
			target.LoseTarget()
			target.search_objects = 2
			target.add_overlay("peace_overlay")
		return

/mob/living/simple_animal/hostile/rogue/skeleton/shood(mob/user)
	if (can_control(user))
		for(var/mob/living/simple_animal/hostile/rogue/skeleton/target in viewers(user))
			target.RegainSearchObjects()
		return

/mob/living/simple_animal/hostile/rogue/skeleton/RegainSearchObjects(value)
	cut_overlay("peace_overlay")
	. = ..()


/datum/intent/simple/claw/skeleton_unarmed
	attack_verb = list("claws", "strikes", "punches")
	blade_class = BCLASS_CHOP
	animname = "cut"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	chargetime = 2
	penfactor = 5
	swingdelay = 8

/obj/item/skull
	name = "skull"
	desc = "A skull"
	icon = 'modular_hearthstone/icons/mob/skeletons.dmi'
	icon_state = "skull"
	w_class = WEIGHT_CLASS_SMALL

/datum/intent/simple/axe/skeleton
	clickcd = SKELETON_ATTACK_SPEED

/datum/intent/simple/claw/skeleton
	clickcd = SKELETON_ATTACK_SPEED
	
/datum/intent/simple/spear/skeleton
	reach = 2
	clickcd = SKELETON_ATTACK_SPEED * 1.2
	chargetime = 1
	animname = "stab"



/mob/living/simple_animal/hostile/rogue/skeleton/axe/event
	ai_controller = /datum/ai_controller/simple_skeleton/event
/mob/living/simple_animal/hostile/rogue/skeleton/spear/event
	ai_controller = /datum/ai_controller/skeleton_spear/event
/mob/living/simple_animal/hostile/rogue/skeleton/guard/event
	ai_controller = /datum/ai_controller/simple_skeleton/event
/mob/living/simple_animal/hostile/rogue/skeleton/bow/event
	ai_controller = /datum/ai_controller/skeleton_ranged/event

/mob/living/simple_animal/hostile/rogue/skeleton/axe/Initialize(mapload, mob/user, cabal_affine = FALSE, is_summoned = FALSE)
    . = ..(mapload, user, cabal_affine, is_summoned)

/mob/living/simple_animal/hostile/rogue/skeleton/spear/Initialize(mapload, mob/user, cabal_affine = FALSE, is_summoned = FALSE)
    . = ..(mapload, user, cabal_affine, is_summoned)

/mob/living/simple_animal/hostile/rogue/skeleton/guard/Initialize(mapload, mob/user, cabal_affine = FALSE, is_summoned = FALSE)
    . = ..(mapload, user, cabal_affine, is_summoned)

/mob/living/simple_animal/hostile/rogue/skeleton/bow/Initialize(mapload, mob/user, cabal_affine = FALSE, is_summoned = FALSE)
    . = ..(mapload, user, cabal_affine, is_summoned)

