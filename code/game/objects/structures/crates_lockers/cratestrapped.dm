/obj/structure/closet/crate/chest/trapped
	name = "chest"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "chest3s"
	locked = FALSE
	anchored = TRUE //meant for dungeons, maybe a craftable subtype in the future can be coded
	var/checks_antimagic = TRUE
	var/armed = TRUE // used for onlook detection and disabling
	var/trap_damage = 50 // baseline trap damage, reduced by armor checks. Wear your PPE in dungeons
	var/def_zone = BODY_ZONE_CHEST
	var/used_time = 14 // interaction time for disabling traps, scales down with trap skill
	var/static/list/ignore_typecache 

/obj/structure/closet/crate/chest/trapped/Initialize()
	. = ..()
	if(!ignore_typecache)
		ignore_typecache = typecacheof(list(
			/obj/effect,
			/mob/dead))

/obj/structure/closet/crate/chest/trapped/obj_break(damage_flag)
	if(!obj_broken && !(flags_1 & NODECONSTRUCT_1))
		bust_open()
		if(armed)
			trap_effect()
			armed = FALSE
		if(!armed)
			return
	..()

/obj/structure/closet/crate/chest/trapped/examine(mob/user)
	. = ..()
	if(!isliving(user))
		return
	if(!armed)
		return
	var/mob/living/luser = user
	if(get_dist(user, src) <= FLOOR((luser.STAPER-4)/4,1))
		to_chat(user,span_notice("\the [src] is trapped!"))
		return

/obj/structure/closet/crate/chest/trapped/proc/trap_effect(mob/living/L)
	return

/obj/structure/closet/crate/chest/trapped/attack_hand(mob/user)
	var/mob/living/carbon/C = user
	var/def_zone = "[(C.active_hand_index == 2) ? "r" : "l" ]_arm"
	var/obj/item/bodypart/BP = C.get_bodypart(def_zone)
	if(iscarbon(user) && armed && isturf(loc))
		if(!BP)
			return FALSE
		if(locked)
			C.visible_message(span_notice("\the [src] is locked."))
			playsound(src, 'sound/foley/doors/lock.ogg', 100)
			return FALSE
		if(C.get_skill_level(/datum/skill/craft/traps) < 1)
			bust_open()
			trap_effect()
			armed = FALSE
			return FALSE
		else
			used_time = 14 SECONDS
			if(C.mind)
				used_time -= max((C.get_skill_level(/datum/skill/craft/traps) * 2 SECONDS), 2 SECONDS)
				C.visible_message(span_notice("[C] begins disarming \the [src]."), \
						span_notice("I start disarming \the [src]."))
			if(do_after(user, used_time, target = src))
				armed = FALSE
				C.visible_message(span_notice("[C] disarms \the [src]."), \
						span_notice("I disarm \the [src]."))
				return FALSE
	if(iscarbon(user) && !armed && isturf(loc))
		user.changeNext_move(CLICK_CD_MELEE)
		toggle(user)

/obj/structure/closet/crate/chest/trapped/trap_effect(mob/living/L) // big badda boom
	..()
	explosion(src, light_impact_range = 1, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

/obj/structure/closet/crate/chest/trapped/locked
	name = "chest"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "chest3s"
	locked = TRUE
	var/list/loot_weighted_list = list(
		/obj/effect/spawner/lootdrop/general_loot_hi = 4,
		/obj/effect/spawner/lootdrop/general_loot_mid = 1,
	)
	var/loot_spawn_dice_string = "1d4+1"

/obj/structure/closet/crate/chest/trapped/locked/Initialize()
	. = ..()
	var/random_loot_amount = roll(loot_spawn_dice_string)
	for(var/loot_spawn in 1 to random_loot_amount)
		var/obj/new_loot = pick(loot_weighted_list)
		new new_loot(src)
