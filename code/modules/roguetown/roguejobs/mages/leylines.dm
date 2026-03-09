/*
 * ========== Leylines ==========
 *
 * Leylines are the sites where mages perform encounter rituals. Scattered across the world
 * in different regions, each aligned to a realm. Mages must travel to find them.
 *
 * Charge system (veil attunement): each mage has dayspassed + 1 charges, minus charges spent.
 * Each ritual costs 1 charge. This naturally gates early-week spam while
 * rewarding patience — by day 4-5 you can chain several rituals in one trip.
 * Since charges are limited, mages are expected to go out to realm-aligned leylines
 * rather than waste charges on tamed ones that always give fewer mobs.
 *
 * Day gating: T1 - T3 always available, T4 from day 3, T5 (Void Dragon) from day 4.
 * This keeps the first few days focused on lower-tier encounters.
 *
 * Leyline types:
 *   Tamed (hamlet/tower) — 4 uses/day, T1 only, neutral alignment.
 *     Neutral = not aligned with anything, so rituals always get -1 mob (training wheels).
 *   Normal (coast/grove/decap) — 2 uses/day, up to T4. Realm-aligned.
 *     Matching ritual alignment = full mob count. Wrong alignment = -1 mob.
 *   Powerful (bog) — 2 uses/day, up to T5. Void-aligned. Always +1 primary mob.
 *     Wrong alignment in Bog nets to normal — the +1 and -1 cancel out.
 *     Only leyline type that supports the T5 Void Dragon ritual (uses a T4 circle).
 */

#define LEYLINE_TELEPORT_COOLDOWN (5 MINUTES)

GLOBAL_LIST_EMPTY(leyline_sites)
GLOBAL_LIST_EMPTY(leyline_activations)

/proc/get_leyline_charges(mob/living/user)
	var/used = GLOB.leyline_activations[user.real_name] || 0
	return max(GLOB.dayspassed + 1 - used, 0)

/proc/spend_leyline_charge(mob/living/user)
	if(!GLOB.leyline_activations[user.real_name])
		GLOB.leyline_activations[user.real_name] = 0
	GLOB.leyline_activations[user.real_name]++

/proc/get_max_leyline_tier()
	if(GLOB.dayspassed >= 4)
		return 5
	if(GLOB.dayspassed >= 3)
		return 4
	return 3

/obj/structure/leyline
	name = "inactive leyline"
	desc = "You shouldn't see the base level leyline."
	icon = 'icons/effects/effects.dmi'
	icon_state = "inactiveleyline"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	max_integrity = -1
	var/active = FALSE
	var/mob/living/guardian = null
	var/time_between_uses = 12000
	var/last_process = 0
	var/alignment = "neutral"
	var/leyline_type = "normal"
	var/mega_region = ""
	var/max_uses_per_day = 2
	var/uses_today = 0
	var/last_reset_day = 0
	var/max_tier = 0
	var/last_used_for_teleport = -LEYLINE_TELEPORT_COOLDOWN

/obj/structure/leyline/Initialize()
	. = ..()
	last_process = world.time
	GLOB.leyline_sites += src
	set_light(l_outer_range = 5, l_power = 2, l_color = color, l_on = TRUE)

/obj/structure/leyline/Destroy()
	GLOB.leyline_sites -= src
	return ..()

/obj/structure/leyline/proc/on_teleport_cooldown()
	return (world.time - last_used_for_teleport) < LEYLINE_TELEPORT_COOLDOWN

/obj/structure/leyline/proc/set_teleport_cooldown()
	last_used_for_teleport = world.time

/obj/structure/leyline/proc/check_daily_reset()
	if(GLOB.dayspassed != last_reset_day)
		uses_today = 0
		last_reset_day = GLOB.dayspassed

/obj/structure/leyline/proc/has_uses_remaining()
	check_daily_reset()
	return uses_today < max_uses_per_day

/obj/structure/leyline/proc/use_charge()
	check_daily_reset()
	uses_today++

/obj/structure/leyline/examine(mob/living/user)
	. = ..()
	if(!isarcyne(user))
		. += span_info("You sense faint energy from the stones, but cannot comprehend its nature.")
		return
	check_daily_reset()
	var/charges = get_leyline_charges(user)
	var/remaining = max_uses_per_day - uses_today
	. += span_info("This [name] pulses with arcyne energy.")
	. += span_info("This leyline can be used [remaining] more time[remaining != 1 ? "s" : ""] todae. You have enough mana for [charges] more ritual[charges != 1 ? "s" : ""].")
	if(max_tier)
		. += span_info("Maximum ritual circle: [max_tier].")
	. += span_info("Draw a summoning circle nearby to begin a leyline encounter.")

/obj/structure/leyline/tamed
	name = "tamed leyline"
	desc = "A carefully warded and stabilized leyline. Its energy is weak but reliable."
	leyline_type = "tamed"
	alignment = "neutral"
	max_uses_per_day = 4
	max_tier = 1
	color = "#C0C0FF" // soft blue-white — tame, safe

/obj/structure/leyline/normal
	leyline_type = "normal"
	max_tier = 4

/obj/structure/leyline/normal/coast
	name = "earthen leyline"
	desc = "Stones arranged in a geometric pattern. Energy seems to be sucked into the ground."
	alignment = "elemental"
	mega_region = "coast"
	color = "#D4A04A" // amber/earth — elemental

/obj/structure/leyline/normal/grove
	name = "sylvan leyline"
	desc = "Moss-covered stones, humming with energy and lyfe. Flowers bloom around them."
	alignment = "fae"
	mega_region = "grove"
	color = "#81C784" // green — fae

/obj/structure/leyline/normal/decap
	name = "scorched leyline"
	desc = "Reddened stones radiating unnatural heat. The ground around them is cracked and ashen."
	alignment = "infernal"
	mega_region = "decap"
	color = "#EF5350" // red — infernal

/obj/structure/leyline/powerful
	name = "unstable leyline"
	desc = "A violent convergence of leyline energy. The stones tremble, and the very nature of space seems to distort around them."
	leyline_type = "powerful"
	alignment = "void"
	mega_region = "bog"
	max_tier = 5
	color = "#AB47BC" // purple — void

#undef LEYLINE_TELEPORT_COOLDOWN
