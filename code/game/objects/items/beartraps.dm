//Legcuffs

/obj/item/restraints/legcuffs
	name = "leg cuffs"
	desc = ""
	gender = PLURAL
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "handcuff"
	flags_1 = CONDUCT_1
	throwforce = 0
	w_class = WEIGHT_CLASS_NORMAL
	slowdown = 7
	breakouttime = 30 SECONDS

/obj/item/restraints/legcuffs/beartrap
	icon = 'icons/roguetown/items/misc.dmi'
	name = "mantrap"
	gender = NEUTER
	throw_speed = 1
	throw_range = 1
	icon_state = "beartrap"
	desc = "A crude and rusty spring trap, used to snare interlopers, or prey on a hunt. Looks almost like falling apart."
	var/rusty = TRUE // Is it an old trap? Will most likely be destroyed if not handled right
	var/armed = FALSE // Is it armed?
	var/inv = FALSE //Lowers alpha for armed traps
	var/can_payload = FALSE //can use bombs
	var/bomb_in = FALSE
	var/list/bombs = list()
	var/trap_damage = 90 // How much brute damage the trap will do to its victim
	var/used_time = 12 SECONDS // How many seconds it takes to disarm the trap
	max_integrity = 100

	grid_width = 64
	grid_height = 64

/obj/item/restraints/legcuffs/beartrap/attack_hand(mob/user)
	if(iscarbon(user) && armed && isturf(loc))
		var/mob/living/carbon/C = user
		var/def_zone = "[(C.active_hand_index == 2) ? "r" : "l" ]_arm"
		var/obj/item/bodypart/BP = C.get_bodypart(def_zone)
		if(!BP)
			return FALSE
		if(C.badluck(5))
			add_mob_blood(C)
			if(!BP.is_object_embedded(src))
				BP.add_embedded_object(src)
			close_trap()
			C.visible_message(span_boldwarning("[C] triggers \the [src]."), \
					span_userdanger("I trigger \the [src]!"))
			C.emote("agony")
			if(bomb_in)
				var/obj/item/bomb/bomb = bombs[bombs.len]
				trap_damage = bomb.PVE_damage/2
				C.Stun(20)
				C.adjustFireLoss(trap_damage)
				bomb.fuze = 1 SECONDS
				bomb.light()
				bomb.forceMove(src)
				qdel(src)
				return FALSE
			C.Stun(80)
			BP.add_wound(/datum/wound/fracture)
			BP.update_disabled()
			C.apply_damage(trap_damage, BRUTE, def_zone)
			C.update_sneak_invis(TRUE)
			return FALSE
		else
			var/used_time = 10 SECONDS
			if(C.mind)
				used_time -= max((C.get_skill_level(/datum/skill/craft/traps) * 2 SECONDS), 2 SECONDS)
			if(do_after(user, used_time, target = src))
				close_trap(FALSE)
				C.visible_message(span_notice("[C] disarms \the [src]."), \
						span_notice("I disarm \the [src]."))
				return FALSE
			else
				add_mob_blood(C)
				if(!BP.is_object_embedded(src))
					BP.add_embedded_object(src)
				close_trap()
				C.visible_message(span_boldwarning("[C] triggers \the [src]."), \
						span_userdanger("I trigger \the [src]!"))
				C.emote("agony")
				if(bomb_in)
					var/obj/item/bomb/bomb = bombs[bombs.len]
					trap_damage = bomb.PVE_damage/2
					C.Stun(20)
					C.adjustFireLoss(trap_damage)
					bomb.fuze = 1 SECONDS
					bomb.light()
					bomb.forceMove(src)
					qdel(src)
					return FALSE
				C.Stun(80)
				BP.add_wound(/datum/wound/fracture)
				BP.update_disabled()
				C.apply_damage(trap_damage, BRUTE, def_zone)
				C.update_sneak_invis(TRUE)
				return FALSE
	..()

/obj/item/restraints/legcuffs/beartrap/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/natural/dirtclod) && !armed)
		if(user.get_skill_level(/datum/skill/craft/traps) >= 4 || HAS_TRAIT(user, TRAIT_EXPLOSIVE_SUPPLY)) //Expert or TRAIT_BOMBER_EXPERT (Bomb main classes). 
			inv = TRUE
			qdel(W)
	if(can_payload && !armed && !bomb_in)
		if(!do_after(user, 15, target = src))
			return
		if(istype(W, /obj/item/bomb) || istype(W, /obj/item/tntstick) || istype(W, /obj/item/impact_grenade) || istype(W, /obj/item/satchel_bomb))
			user.transferItemToLoc(W, bombs)
			bombs += W
			bomb_in = TRUE
			name = "trap with [W.name]"
			update_icon()
	if(W.force && armed)
		user.visible_message("<span class='warning'>[user] triggers \the [src] with [W].</span>", \
				"<span class='danger'>I trigger \the [src] with [W]!</span>")
		W.take_damage(20)
		close_trap()
		if(isliving(user))
			var/mob/living/L = user
			L.update_sneak_invis(TRUE)
		return
	..()

/obj/item/restraints/legcuffs/beartrap/attack_right(mob/user)
	if(bombs.len)
		var/mob/living/carbon/C = user
		if(HAS_TRAIT(user, TRAIT_EXPLOSIVE_SUPPLY)) //virtue and bomber roles
			var/obj/O = bombs[bombs.len]
			bombs -= O
			user.put_in_hands(O)
			bomb_in = FALSE
			update_icon()
		else
			if(do_after(user, 20, target = user))
				to_chat(user, span_notice("You fumble to draw a bomb..."))
				var/obj/O = bombs[bombs.len]
				bombs -= O
				user.put_in_hands(O)
				bomb_in = FALSE
				update_icon()
			else
				var/obj/item/bomb/bomb = bombs[bombs.len]
				trap_damage = bomb.PVE_damage/2
				C.Stun(20)
				C.adjustFireLoss(trap_damage)
				bomb.fuze = 1 SECONDS
				bomb.light()
				bomb.forceMove(src)
				qdel(src)
		return TRUE

/obj/item/restraints/legcuffs/beartrap/armed
	w_class = WEIGHT_CLASS_BULKY
	armed = TRUE
	anchored = TRUE // Pre mapped traps (bad mapping btw, don't) start anchored
	grid_width = 256
	grid_height = 256

/obj/item/restraints/legcuffs/beartrap/armed/camouflage
	w_class = WEIGHT_CLASS_BULKY
	armed = TRUE
	alpha = 80
	grid_width = 256
	grid_height = 256

/obj/item/restraints/legcuffs/beartrap/Initialize()
	. = ..()
	update_icon()

/obj/item/restraints/legcuffs/beartrap/update_icon()
	. = ..()
	icon_state = "[initial(icon_state)][armed][bomb_in]"

/obj/item/restraints/legcuffs/beartrap/examine(mob/user)
	. = ..()
	if(Adjacent(user) && bomb_in)
		. += "It contains: [counting_english_list(bombs)]"

/obj/item/restraints/legcuffs/beartrap/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is sticking [user.p_their()] head in the [src.name]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(loc, 'sound/blank.ogg', 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/restraints/legcuffs/beartrap/attack_self(mob/user)
	..()
	if(ishuman(user) && !user.stat && !user.restrained())
		var/mob/living/carbon/C = user
		if(do_after(user, 50 - (C.STASTR*2), target = user))
			if(prob(50))
				armed = !armed
				if(armed)
					w_class = WEIGHT_CLASS_BULKY
					grid_width = 256
					grid_height = 256
					if(inv)
						alpha = (170 - (C.get_skill_level(/datum/skill/craft/traps)*20)) //40 alpha if user has LEGENDARY trapmaker
						if(HAS_TRAIT(C, TRAIT_BOMBER_EXPERT)) //+ one level
							if(alpha >= 60)
								alpha -= 20
				else
					w_class = WEIGHT_CLASS_NORMAL
					grid_width = 64
					grid_height = 64
				update_icon()
				to_chat(user, span_notice("[src] is now [armed ? "armed" : "disarmed"]"))
			else
				user.visible_message(span_warning("You couldn't get the shoddy [src.name] [armed ? "shut close!" : "to open up!"]"))

/obj/item/restraints/legcuffs/beartrap/proc/close_trap(play_sound = TRUE)
	armed = FALSE
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 64
	grid_height = 64
	anchored = FALSE // Take it off the ground
	alpha = 255
	update_icon()
	if(play_sound)
		playsound(src.loc, 'sound/items/beartrap.ogg', 300, TRUE, -1)

/obj/item/restraints/legcuffs/beartrap/Crossed(AM as mob|obj)
	if(armed && isturf(loc))
		if(isliving(AM))
			var/mob/living/L = AM
			var/snap = TRUE
			if(istype(L.buckled, /obj/vehicle))
				var/obj/vehicle/ridden_vehicle = L.buckled
				if(!ridden_vehicle.are_legs_exposed) //close the trap without injuring/trapping the rider if their legs are inside the vehicle at all times.
					close_trap()
					ridden_vehicle.visible_message("<span class='danger'>[ridden_vehicle] triggers \the [src].</span>")
					return ..()
			if(L.throwing)
				return ..()

			if(L.movement_type & (FLYING|FLOATING)) //don't close the trap if they're flying/floating over it.
				return ..()

			var/def_zone = BODY_ZONE_CHEST
			if(bomb_in)
				var/obj/item/bomb/bomb = bombs[bombs.len]
				if(!L.mind)
					trap_damage = bomb.PVE_damage
				else
					trap_damage = bomb.PVE_damage/2
			if(snap && iscarbon(L))
				var/mob/living/carbon/C = L
				if(C.mobility_flags & MOBILITY_STAND)
					def_zone = pick(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
					var/obj/item/bodypart/BP = C.get_bodypart(def_zone)
					if(bomb_in)
						C.Stun(20)
					if(BP)
						add_mob_blood(C)
						if(!BP.is_object_embedded(src))
							BP.add_embedded_object(src)
						C.emote("agony")
				//BP.set_disabled(BODYPART_DISABLED_WOUND)
				// BP.add_wound(/datum/wound/fracture)
			else if(snap && isanimal(L))
				var/mob/living/simple_animal/SA = L
				if(SA.mob_size <= MOB_SIZE_TINY) //don't close the trap if they're as small as a mouse.
					snap = FALSE
			if(snap)
				close_trap()
				L.visible_message("<span class='danger'>[L] triggers \the [src].</span>", \
						"<span class='danger'>I trigger \the [src]!</span>")
				if(bomb_in)
					var/obj/item/bomb/bomb = bombs[bombs.len]
					L.adjustFireLoss(trap_damage)
					bomb.fuze = 1 SECONDS
					bomb.light()
					bomb.forceMove(src)
					qdel(src)
				if(L.apply_damage(trap_damage, BRUTE, def_zone, L.run_armor_check(def_zone, "stab", damage = trap_damage)))
					L.Stun(80)
	..()

/obj/item/restraints/legcuffs/beartrap/dropped(mob/living/carbon/human/user)
	..()
	if(!armed)
		return
	for(var/obj/structure/fluff/traveltile/TT in range(1, src)) // don't allow armed traps to be placed near travel tiles
		close_trap(FALSE)
		log_combat(user, src, "armed and dropped [src] near travel tiles")
		break

/obj/item/restraints/legcuffs/beartrap/after_throw(datum/callback/callback)
	..()
	if(!armed)
		return
	for(var/obj/structure/fluff/traveltile/TT in range(1, src)) // don't allow armed traps to be placed near travel tiles
		close_trap()
		log_combat(src, null, "[src] was kicked towards travel tiles")
		break

// When craftable beartraps get added, make these the ones crafted.
/obj/item/restraints/legcuffs/beartrap/crafted
	rusty = FALSE
	desc = "Curious is the trapmaker's art. Their efficacy unwitnessed by their own eyes."
	smeltresult = /obj/item/ingot/iron

/obj/item/restraints/legcuffs/beartrap/crafted/landmine
	name = "payload trap"
	icon_state = "bombtrap"
	can_payload = TRUE
	desc = "Curious is the trapmaker's art. Their can filled by any bomb."
	smeltresult = /obj/item/ingot/iron
