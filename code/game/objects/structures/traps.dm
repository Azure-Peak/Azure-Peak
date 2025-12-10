/obj/structure/trap
	name = "IT'S A TRAP"
	desc = ""
	icon = 'icons/obj/hand_of_god_structures.dmi'
	icon_state = "trap"
	density = FALSE
	anchored = TRUE
	alpha = 60 //initially quite hidden when not "recharging"
	var/flare_message = span_warning("the trap flares brightly!")
	var/last_trigger = 0
	var/time_between_triggers = 600 //takes a minute to recharge
	var/charges = INFINITY
	var/checks_antimagic = TRUE
	var/armed = TRUE // used for onlook detection and disabling
	var/trap_damage = 50 // baseline trap damage, reduced by armor checks. Wear your PPE in dungeons
	var/def_zone = BODY_ZONE_CHEST //
	var/used_time = 14 // interaction time for disabling traps, scales down with trap skill
 

	var/list/static/ignore_typecache
	var/list/mob/immune_minds = list() //unused and a bit weird, helpful for making mobs immune to the traps without TRAIT_LIGHT_STEP

	var/sparks = TRUE
	var/datum/effect_system/spark_spread/spark_system
	var/scraptype = /obj/item/scrap

/obj/structure/trap/Initialize(mapload)
	. = ..()
	flare_message = span_warning("[src] flares brightly!")
	spark_system = new
	spark_system.set_up(4,1,src)
	spark_system.attach(src)

	if(!ignore_typecache)
		ignore_typecache = typecacheof(list(
			/obj/effect,
			/obj/projectile,
			/mob/dead))

/obj/structure/trap/Destroy()
	qdel(spark_system)
	spark_system = null
	. = ..()

/obj/structure/trap/examine(mob/user)
	. = ..()
	if(!isliving(user))
		return
	if(!armed)
		return
	var/mob/living/luser = user
	if(user.mind && (user.mind in immune_minds))
		return
	if(get_dist(user, src) <= FLOOR((luser.STAPER-4)/4,1))
		to_chat(user,span_notice("I reveal and temporarily disarm \the [src]"))
		flare()

/obj/structure/trap/attack_hand(mob/user)
	var/mob/living/carbon/C = user
	var/def_zone = "[(C.active_hand_index == 2) ? "r" : "l" ]_arm"
	var/obj/item/bodypart/BP = C.get_bodypart(def_zone)
	if(iscarbon(user) && armed && isturf(loc))
		if(!BP)
			return FALSE
		if(C.get_skill_level(/datum/skill/craft/traps) < 1)
			C.visible_message(span_notice("I don't know how to disarm \the [src]."))
			if(prob(50))
				trap_effect(C)
			return FALSE
		else
			used_time = 14 SECONDS
			if(C.mind)
				used_time -= max((C.get_skill_level(/datum/skill/craft/traps) * 2 SECONDS), 2 SECONDS)
				C.visible_message(span_notice("[C] begins disarming \the [src]."), \
						span_notice("I start disarming \the [src]."))
			if(do_after(user, used_time, target = src))
				armed = FALSE
				update_icon()
				alpha = 255
				C.visible_message(span_notice("[C] disarms \the [src]."), \
						span_notice("I disarm \the [src]."))
				return FALSE
			trap_effect(C)
	if(iscarbon(user) && !armed && isturf(loc))
		if(!BP)
			return FALSE
		if(C.get_skill_level(/datum/skill/craft/traps) < 1)
			C.visible_message(span_notice("I don't know how to arm \the [src]."))
			if(prob(50))
				trap_effect(C)
			return FALSE
		else
			used_time = 8 SECONDS
			if(C.mind)
				used_time -= max((C.get_skill_level(/datum/skill/craft/traps) * 2 SECONDS), 2 SECONDS)
			if(do_after(user, used_time, target = src))
				armed = TRUE
				update_icon()
				alpha = 35
				C.visible_message(span_notice("[C] arms \the [src]."), \
						span_notice("I arm \the [src]."))
				return FALSE
			trap_effect(C)
	..()

/obj/structure/trap/attack_right(mob/user)
	var/mob/living/carbon/C = user
	var/def_zone = "[(C.active_hand_index == 2) ? "r" : "l" ]_arm"
	var/obj/item/bodypart/BP = C.get_bodypart(def_zone)
	if(iscarbon(user) && armed && isturf(loc))
		if(!BP)
			return FALSE
		if(C.get_skill_level(/datum/skill/craft/traps) >= 4 || HAS_TRAIT(C, TRAIT_EXPLOSIVE_SUPPLY)) //Expert or TRAIT_BOMBER_EXPERT (Bomb main classes). 
			used_time = 14 SECONDS
			if(C.mind)
				used_time -= max((C.get_skill_level(/datum/skill/craft/traps) * 2 SECONDS), 2 SECONDS)
				C.visible_message(span_notice("[C] begins \the [src] reclamation."), \
						span_notice("I start disarming \the [src]."))
			if(do_after(user, used_time, target = src))
				var/obj/I = new scraptype(C)
				C.put_in_hands(I)
				C.visible_message(span_notice("[C] disassembles \the [src]."), \
						span_notice("I reclaim \the [src]."))
				qdel(src)
				return FALSE
			else
				trap_effect(C)
				return FALSE
		else
			trap_effect(C)

/obj/structure/trap/proc/flare()
	// Makes the trap visible, and starts the cooldown until it's
	// able to be triggered again.
	alpha = 200
	last_trigger = world.time
	charges--
	if(charges <= 0)
		animate(src, alpha = 0, time = 10)
		QDEL_IN(src, 10)
	else
		animate(src, alpha = initial(alpha), time = time_between_triggers)

/obj/structure/trap/Crossed(atom/movable/AM)
	if(last_trigger + time_between_triggers > world.time)
		return
	// Don't want the traps triggered by sparks, ghosts or projectiles.
	if(is_type_in_typecache(AM, ignore_typecache))
		return
	if(!armed)
		return
	if(ismob(AM))
		var/mob/M = AM
		if(M.mind in immune_minds)
			return
		if(checks_antimagic && M.anti_magic_check())
			flare()
			return
		if(HAS_TRAIT(AM, TRAIT_LIGHT_STEP))
			return
	if(charges <= 0)
		return
	flare()
	if(isliving(AM))
		trap_effect(AM)

/obj/structure/trap/proc/trap_effect(mob/living/L)
	return

/obj/structure/trap/stun
	name = "shock trap"
	desc = ""
	icon_state = "trap-shock"
	var/stun_time = 100

/obj/structure/trap/stun/trap_effect(mob/living/L)
	L.electrocute_act(30, src, flags = SHOCK_NOGLOVES) // electrocute act does a message.
	L.Paralyze(stun_time)

/obj/structure/trap/stun/hunter
	name = "bounty trap"
	desc = ""
	icon = 'icons/obj/objects.dmi'
	icon_state = "bounty_trap_on"
	stun_time = 200
	sparks = FALSE //the item version gives them off to prevent runtimes (see Destroy())
	checks_antimagic  = FALSE
	var/obj/item/bountytrap/stored_item
	var/caught = FALSE

/obj/structure/trap/stun/hunter/Initialize(mapload)
	. = ..()
	time_between_triggers = 10
	flare_message = span_warning("[src] snaps shut!")

/obj/structure/trap/stun/hunter/Crossed(atom/movable/AM)
	caught = TRUE
	. = ..()

/obj/structure/trap/stun/hunter/flare()
	..()
	stored_item.forceMove(get_turf(src))
	forceMove(stored_item)
	if(caught)
		stored_item.announce_fugitive()
		caught = FALSE

/obj/item/bountytrap
	name = "bounty trap"
	desc = ""
	icon = 'icons/obj/objects.dmi'
	icon_state = "bounty_trap_off"
	var/obj/structure/trap/stun/hunter/stored_trap
	var/datum/effect_system/spark_spread/spark_system

/obj/item/bountytrap/Initialize(mapload)
	. = ..()
	spark_system = new
	spark_system.set_up(4,1,src)
	spark_system.attach(src)
	name = "[name] #[rand(1, 999)]"
	stored_trap = new(src)
	stored_trap.name = name
	stored_trap.stored_item = src

/obj/item/bountytrap/proc/announce_fugitive()
	spark_system.start()
	playsound(src, 'sound/blank.ogg', 50, TRUE)

/obj/item/bountytrap/attack_self(mob/living/user)
	var/turf/T = get_turf(src)
	if(!user || !user.transferItemToLoc(src, T))//visibly unequips
		return
	to_chat(user, "<span class=notice>I set up [src]. Examine while close to disarm it.</span>")
	stored_trap.forceMove(T)//moves trap to ground
	forceMove(stored_trap)//moves item into trap

/obj/item/bountytrap/Destroy()
	qdel(stored_trap)
	QDEL_NULL(spark_system)
	. = ..()

/obj/structure/trap/fire
	name = "flame trap"
	desc = ""
	icon_state = "trap-fire"
	scraptype = /obj/item/alch/firedust

/obj/structure/trap/fire/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>Spontaneous combustion!</B>"))
	L.Paralyze(20)
	new /obj/effect/hotspot(get_turf(src))

/obj/structure/trap/chill
	name = "frost trap"
	desc = ""
	icon_state = "trap-frost"
	scraptype = /obj/item/magic/manacrystal

/obj/structure/trap/chill/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>You're frozen solid!</B>"))
	L.Paralyze(20)
	L.adjust_bodytemperature(-300)
	L.apply_status_effect(/datum/status_effect/freon)

/obj/structure/trap/damage
	name = "earth trap"
	desc = ""
	icon_state = "trap-earth"
	scraptype = /obj/item/alch/earthdust

/obj/structure/trap/damage/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>The ground quakes beneath your feet!</B>"))
	L.Paralyze(100)
	L.adjustBruteLoss(35)
	var/obj/structure/flora/rock/giant_rock = new(get_turf(src))
	QDEL_IN(giant_rock, 200)

/obj/structure/trap/ward
	name = "divine ward"
	desc = ""
	icon_state = "ward"
	density = TRUE
	time_between_triggers = 1200 //Exists for 2 minutes

/obj/structure/trap/ward/Initialize()
	. = ..()
	QDEL_IN(src, time_between_triggers)

/obj/structure/trap/saw_blades // vanderlin traps and AP traps below
	name = "saw plate trap"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "saw_trap_plate"
	time_between_triggers = 100
	max_integrity = 500

/obj/structure/trap/saw_blades/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>A whirling blade erupts from beneath your feet!</B>"))
	def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	L.apply_damage(trap_damage, BRUTE, def_zone, L.run_armor_check(def_zone, "stab", damage = trap_damage))
	playsound(src, 'sound/gore/flesh_eat_01.ogg', 70, TRUE)
	var/obj/structure/sawblade_trap/saw = new(get_turf(src))
	last_trigger = 0 // override to keep slicing you every time you step onto the trap
	QDEL_IN(saw, 100)

/obj/structure/sawblade_trap
	name = "saw blade"
	desc = "A fast spinning saw blade, propelled by some unknown mechanism"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "trap_saw"
	density = FALSE
	anchored = TRUE

/obj/structure/trap/bomb // fire can RR easily, dangerous
	name = "bomb plate trap"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "bomb_trap_plate"
	time_between_triggers = 100
	max_integrity = 500
	scraptype = /obj/item/impact_grenade/explosion

/obj/structure/trap/bomb/trap_effect(mob/living/L)
	..()
	explosion(src, light_impact_range = 1, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

/obj/structure/trap/flame // fire can RR easily, dangerous
	name = "flamejet plate trap"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "trap_plate"
	time_between_triggers = 100
	max_integrity = 500
	scraptype = /obj/item/bomb

/obj/structure/trap/flame/trap_effect(mob/living/L)
	..()
	to_chat(L,span_danger("The ground suddenly erupts in flame!"))
	new /obj/effect/hotspot(get_turf(src))

/obj/structure/trap/shock
	name = "lightning plate trap"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "shock_trap_plate"
	time_between_triggers = 100
	max_integrity = 500
	var/stun_time = 5 SECONDS

/obj/structure/trap/shock/trap_effect(mob/living/L)
	..()
	L.electrocute_act(30, src, flags = SHOCK_NOGLOVES) // electrocute act does a message.
	L.Paralyze(stun_time)

/obj/structure/trap/wall_projectile
	name = "arrow plate trap"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "arrow_trap_plate"
	time_between_triggers = 100
	max_integrity = 500
	var/turf/closed/home_wall
	///How far we look for a 'home' wall
	var/wall_range = 7
	///What're we shooting at the victim? Should be an /obj/projectile/
	var/fired = /obj/projectile/bullet/reusable/arrow/stone/wall_projectile

/obj/projectile/bullet/reusable/arrow/stone/wall_projectile
	speed = 6

/obj/structure/trap/wall_projectile/Initialize(mapload)
	. = ..()
	for(var/step in 1 to wall_range)
		var/location = get_ranged_target_turf(src,dir,step)
		if(isclosedturf(location))
			home_wall = location
			break
	if(!home_wall)
		return INITIALIZE_HINT_QDEL

/obj/structure/trap/wall_projectile/trap_effect(mob/living/L)
	..()
	if(!home_wall || !ispath(fired,/obj/projectile))
		return
	var/obj/projectile/suprise = new fired(get_step_towards2(home_wall,src))
	suprise.preparePixelProjectile(L,home_wall)
	suprise.fire()
	to_chat(L, span_danger("\The [suprise] erupts from a hidden slit in \the [home_wall]!"))

/obj/structure/trap/wall_projectile/Destroy()
	home_wall = null
	. = ..()

/obj/structure/trap/wall_projectile/frostbolt
	name = "frost plate trap"
	fired = /obj/projectile/magic/frostbolt/wall_projectile
	scraptype = /obj/item/magic/manacrystal

/obj/projectile/magic/frostbolt/wall_projectile
	speed = 6
	damage = 20
	armor_penetration = 5

/obj/structure/trap/wall_projectile/acidsplash
	name = "acid plate trap"
	fired = /obj/projectile/magic/acidsplash/wall_projectile

/obj/projectile/magic/acidsplash/wall_projectile
	speed = 6

/obj/structure/trap/rock_fall
	name = "rock fall trap"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "rockfall_trap_plate"
	time_between_triggers = 100
	max_integrity = 500
	scraptype = /obj/item/alch/earthdust

/obj/structure/trap/rock_fall/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>The ground above you shakes violently!</B>"))
	def_zone = BODY_ZONE_HEAD
	L.apply_damage(trap_damage, BRUTE, def_zone, L.run_armor_check(def_zone, "stab", damage = trap_damage))
	playsound(src, 'sound/foley/smash_rock.ogg', 70, TRUE)
	L.set_blurriness(10)
	var/obj/structure/flora/rock/giant_rock = new(get_turf(src))
	QDEL_IN(giant_rock, 100)

/obj/structure/trap/water
	name = "water trap"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "water_trap_plate"
	time_between_triggers = 100
	max_integrity = 500
	scraptype = /obj/item/alch/waterdust

/obj/structure/trap/water/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>You are doused and knocked off your feet by a torrent of water!</B>"))
	for(var/obj/O in L.contents) //Checks for light sources in the mob's inventory. Tyvm to LynxSolstice for the extinguish code
		O.extinguish() //Extinguishes light sources on the mob hit by the trap.
	playsound(src, 'sound/foley/water_land2.ogg', 70, TRUE)
	L.Paralyze(10)
	var/obj/effect/particle_effect/water/spray = new(get_turf(src))
	QDEL_IN(spray, 100)

/obj/structure/trap/curse
	name = "deactivated trap" //Im not activated guys I swear Im a broken trap I dont work
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "base_trap_plate"
	time_between_triggers = 100
	max_integrity = 500
	alpha = 255

/obj/structure/trap/curse/hidden
	name = "curse trap"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "base_trap_plate"
	time_between_triggers = 100
	max_integrity = 500
	alpha = 35

/obj/structure/trap/curse/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>A cruel joke has been played on you!</B>"))
	L.add_stress(/datum/stressevent/thefool)
	playsound(src, 'sound/magic/mockery.ogg', 60, TRUE)
	L.apply_status_effect(/datum/status_effect/debuff/viciousmockery)

/datum/stressevent/thefool
	timer = 10 MINUTES
	stressadd = 2
	desc = span_boldgreen("I've been made a fool of.")

// BANDIT THING STARTS HERE //
/obj/structure/trap/bogtrap
	name = "trapbog"
	desc = "A cleverly concealed device with a nasty surprise."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "beartrap"
	name = "mantrap"
	time_between_triggers = 100 //feel free to add more than 1 use
	max_integrity = 100
	trap_damage = 50
	alpha = 60
	charges = 1 //feel free to add more than 1 use

	var/tmp/list/personal_reveal_images = list()
	var/bandit_reveal_alpha = 140
	var/others_reveal_alpha = 35

/obj/structure/trap/bogtrap/flare()
	alpha = 200
	last_trigger = world.time
	charges--
	animate(src, alpha = 0, time = 2)
	QDEL_IN(src, 2)

/obj/structure/trap/bogtrap/Destroy()
	if(personal_reveal_images)
		for(var/client/C in personal_reveal_images)
			var/image/I = personal_reveal_images[C]
			if(C && I)
				C.images -= I
	personal_reveal_images = null
	. = ..()

/obj/structure/trap/bogtrap/proc/has_exempt_role(mob/living/H)
	if(!H || !H.mind)
		return FALSE

	var/assigned = lowertext("[H.mind.assigned_role]")
	var/special  = lowertext("[H.mind.special_role]")

	if(assigned == "bandit" || special == "bandit")
		return TRUE

	if(assigned == "wretch")
		return TRUE

	if(special == "lich" || special == "vampire lord")
		return TRUE

	if(assigned == "bogguard")
		return TRUE

	return FALSE

/obj/structure/trap/bogtrap/proc/has_required_trigger_trait(mob/living/H)
	if(!H) return FALSE
	if(HAS_TRAIT(H, TRAIT_MEDIUMARMOR)) return TRUE
	if(HAS_TRAIT(H, TRAIT_HEAVYARMOR))  return TRUE
	if(HAS_TRAIT(H, TRAIT_DODGEEXPERT)) return TRUE
	if(HAS_TRAIT(H, TRAIT_CRITICAL_RESISTANCE)) return TRUE

	return FALSE

/obj/structure/trap/bogtrap/proc/is_trap_exception(mob/living/H)
	if(!H) return FALSE
	if(has_exempt_role(H))
		return TRUE
	if(!has_required_trigger_trait(H))
		return TRUE
	return FALSE

/obj/structure/trap/bogtrap/proc/is_exempt_viewer(mob/living/H)
	if(!H || !H.mind)
		return FALSE
	var/assigned = lowertext("[H.mind.assigned_role]")
	var/special  = lowertext("[H.mind.special_role]")

	return (assigned == "bandit" || special == "bandit" \
		|| assigned == "bogguard" \
		|| assigned == "warden" || special == "warden")

/obj/structure/trap/bogtrap/proc/show_personal_reveal(mob/user)
	if(!user || !user.client)
		return
	var/image/I = image(icon = src.icon, loc = src, icon_state = src.icon_state)
	I.layer = src.layer
	I.plane = src.plane
	I.appearance_flags = src.appearance_flags
	I.color = src.color
	I.transform = src.transform
	I.alpha = is_exempt_viewer(user) ? bandit_reveal_alpha : others_reveal_alpha
	user.client.images += I
	if(!personal_reveal_images)
		personal_reveal_images = list()
	personal_reveal_images[user.client] = I
	addtimer(CALLBACK(src, PROC_REF(hide_personal_reveal), user), 3 SECONDS)

/obj/structure/trap/bogtrap/proc/hide_personal_reveal(mob/user)
	if(user && user.client && personal_reveal_images && personal_reveal_images[user.client])
		var/image/I = personal_reveal_images[user.client]
		user.client.images -= I
		personal_reveal_images[user.client] = null

/obj/structure/trap/bogtrap/examine(mob/user)
	if(!isliving(user) || !armed)
		return
	var/mob/living/L = user
	if(user.mind && (user.mind in immune_minds))
		return
	if(get_dist(user, src) <= FLOOR((L.STAPER-4)/4,1))
		to_chat(user, span_notice("I spot the [src]."))
		show_personal_reveal(user)


/obj/structure/trap/bogtrap/Crossed(atom/movable/AM)
	if(ismob(AM))
		var/mob/living/H = AM
		if(is_trap_exception(H))
			return
	. = ..()

/obj/structure/trap/bogtrap/freeze
    name = "trapbog (frost)"
    checks_antimagic = FALSE

/obj/structure/trap/bogtrap/freeze/trap_effect(mob/living/L)
    to_chat(L, span_danger("<B>You're frozen solid!</B>"))
    L.Paralyze(50)
    L.adjust_bodytemperature(-300)
    playsound(src, 'sound/misc/explode/bottlebomb (1).ogg', 60, TRUE)


/obj/structure/trap/bogtrap/bomb
	name = "trapbog (blast)"
	checks_antimagic = FALSE

/obj/structure/trap/bogtrap/bomb/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>A buried charge detonates!</B>"))
	explosion(src, light_impact_range = 1, flame_range = 3, smoke = TRUE)
	playsound(src, 'sound/misc/explode/bottlebomb (1).ogg', 200, TRUE)

//kneestingers

/obj/structure/trap/bogtrap/kneestingers
	name = "trapbog (kneestingers)"
	desc = "A hidden charge that bursts into a patch of kneestingers."
	charges = 1

/obj/structure/trap/bogtrap/kneestingers/trap_effect(mob/living/L)
	var/turf/center = get_turf(src)
	to_chat(L, span_danger("<B>Something skitters out from the ground!</B>"))
	playsound(src, 'sound/items/beartrap.ogg', 200, TRUE)

	for(var/dx in -1 to 1)
		for(var/dy in -1 to 1)
			var/turf/T = locate(center.x + dx, center.y + dy, center.z)
			if(!T || isclosedturf(T))
				continue
			new /obj/structure/glowshroom(T)

 //Poison tr*p

/obj/structure/trap/bogtrap/poison
	name = "trapbog (toxic)"
	charges = 1

/obj/structure/trap/bogtrap/poison/trap_effect(mob/living/L)
	to_chat(L, span_danger("<B>A noxious cloud engulfs you!</B>"))
	L.Paralyze(30)
	new /obj/effect/particle_effect/smoke/poison_gas(get_turf(src))
	playsound(src, 'sound/items/beartrap.ogg', 200, TRUE)
