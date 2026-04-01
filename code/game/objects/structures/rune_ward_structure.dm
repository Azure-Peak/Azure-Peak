#define RUNE_WARD_IMMUNITY_DURATION (3 SECONDS)
#define RUNE_WARD_IMMUNITY_KEY "rune_ward_immunity"

/obj/structure/rune_ward
	name = "arcyne rune"
	desc = "A faintly glowing symbol etched into the ground."
	icon = 'icons/roguetown/misc/rune_wards.dmi'
	icon_state = "rune"
	attacked_sound = 'sound/magic/magic_nulled.ogg'
	density = FALSE
	anchored = TRUE
	alpha = 180
	layer = TURF_LAYER + 0.1
	max_integrity = 100

	var/datum/weakref/owner_ref
	var/datum/weakref/spell_ref
	var/owner_name = "unknown"
	var/owner_ckey = "unknown"
	var/checks_antimagic = TRUE

/obj/structure/rune_ward/Crossed(atom/movable/AM)
	if(ismob(AM))
		var/mob/M = AM
		var/mob/owner = owner_ref?.resolve()
		if(M == owner)
			return
		var/datum/action/cooldown/spell/touch/rune_ward/spell = spell_ref?.resolve()
		if(spell && (M.real_name in spell.allowed_names))
			return
		if(checks_antimagic && M.anti_magic_check())
			trigger_visual()
			qdel(src)
			return
		if(AM.throwing)
			return
		if(isliving(AM))
			var/mob/living/L = AM
			if(L.movement_type & (FLYING|FLOATING))
				return
			if(L.is_jumping)
				return
			if(L.mob_timers[RUNE_WARD_IMMUNITY_KEY] && world.time < L.mob_timers[RUNE_WARD_IMMUNITY_KEY])
				return
	else
		return
	var/mob/living/L = AM
	if(!isliving(L))
		return
	L.mob_timers[RUNE_WARD_IMMUNITY_KEY] = world.time + RUNE_WARD_IMMUNITY_DURATION
	log_combat(AM, src, "triggered [name] placed by [owner_name] ([owner_ckey]) at [AREACOORD(src)]")
	rune_effect(L)
	trigger_visual()
	qdel(src)

/obj/structure/rune_ward/proc/trigger_visual()
	alpha = 255
	// Brief flash before deletion
	flick(icon_state, src)

/obj/structure/rune_ward/proc/rune_effect(mob/living/L)
	return

/obj/structure/rune_ward/Destroy()
	owner_ref = null
	spell_ref = null
	return ..()

/obj/structure/rune_ward/examine(mob/user)
	. = ..()
	if(max_integrity <= 50)
		. += span_info("This rune looks very fragile - a few solid hits would destroy it.")
	else
		. += span_info("A skilled mage can scrub this effortlessly. Otherwise, it must be destroyed by force.")
	. += span_info("Flying, jumping, or being thrown over the rune will not trigger it.")

// --- Subtypes ---

/obj/structure/rune_ward/stun
	name = "shock rune"
	icon_state = RUNE_WARD_ICON_STUN

/obj/structure/rune_ward/stun/rune_effect(mob/living/L)
	to_chat(L, span_danger("<B>The rune locks your muscles in place!</B>"))
	playsound(src, 'sound/magic/lightning.ogg', 80, TRUE)
	L.electrocute_act(10, src, flags = SHOCK_NOGLOVES)
	L.Paralyze(120)

/obj/structure/rune_ward/fire
	name = "flame rune"
	icon_state = RUNE_WARD_ICON_FIRE

/obj/structure/rune_ward/fire/rune_effect(mob/living/L)
	to_chat(L, span_danger("<B>The rune erupts in flames!</B>"))
	playsound(src, pick('sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg'), 80, TRUE)
	new /obj/effect/hotspot(get_turf(src))
	L.Knockdown(30)
	L.Slowdown(2)
	L.adjust_fire_stacks(5)
	L.ignite_mob()

/obj/structure/rune_ward/chill
	name = "frost rune"
	icon_state = RUNE_WARD_ICON_CHILL

/obj/structure/rune_ward/chill/rune_effect(mob/living/L)
	to_chat(L, span_danger("<B>Frost erupts from the rune and seizes your limbs!</B>"))
	playsound(src, 'sound/spellbooks/crystal.ogg', 80, TRUE)
	new /obj/effect/temp_visual/trapice(get_turf(src))
	L.Paralyze(20)
	L.adjustFireLoss(30)
	apply_frost_stack(L, 4)

/obj/structure/rune_ward/damage
	name = "force rune"
	icon_state = RUNE_WARD_ICON_DAMAGE
	var/rune_damage = 80

/obj/structure/rune_ward/damage/rune_effect(mob/living/L)
	to_chat(L, span_danger("<B>Arcyne blades erupt from the rune!</B>"))
	playsound(src, 'sound/magic/blade_burst.ogg', 80, TRUE)
	playsound(src, pick('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg'), 80, TRUE)
	new /obj/effect/temp_visual/blade_burst(get_turf(src))
	L.Knockdown(30)
	L.Slowdown(2)
	var/mob/living/carbon/human/owner = owner_ref?.resolve()
	if(ishuman(owner) && ishuman(L))
		arcyne_strike(owner, L, null, rune_damage, BODY_ZONE_CHEST, \
			BCLASS_STAB, armor_penetration = PEN_HEAVY, spell_name = "Force Rune", \
			damage_type = BRUTE, skip_animation = TRUE)
	else
		L.adjustBruteLoss(rune_damage)

/obj/structure/rune_ward/alarm
	name = "alarm rune"
	icon_state = RUNE_WARD_ICON_ALARM
	alpha = 40

/obj/structure/rune_ward/alarm/rune_effect(mob/living/L)
	to_chat(L, span_danger("<B>The rune chimes loudly!</B>"))
	playsound(src, 'sound/magic/charging.ogg', 80, TRUE)
	var/mob/owner = owner_ref?.resolve()
	if(owner)
		var/area/A = get_area(src)
		var/area_name = A ? A.name : "an unknown location"
		to_chat(owner, span_warning("One of my alarm runes has been triggered at [area_name]!"))
		if(owner.client)
			SEND_SOUND(owner, sound('sound/magic/charging.ogg', volume = 40))

#undef RUNE_WARD_IMMUNITY_DURATION
#undef RUNE_WARD_IMMUNITY_KEY
