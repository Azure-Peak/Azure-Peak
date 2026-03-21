// I want to refactor Stoneskin to give ablative layer of armor but in the meantime Crit Res is too strong so I'll just nerf it and lower cost
/obj/effect/proc_holder/spell/invoked/stoneskin
	name = "Stoneskin"
	overlay_state = "stoneskin"
	desc = "Harden the target's skin like stone. (+5 Constitution)"
	cost = 2
	xp_gain = TRUE
	releasedrain = SPELLCOST_STAT_BUFF
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 2 MINUTES
	warnie = "spellwarning"
	school = "transmutation"
	spell_tier = 2
	invocations = list("Perstare Sicut Saxum.") // Endure like Stone
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7

/obj/effect/proc_holder/spell/invoked/stoneskin/cast(list/targets, mob/user)
	var/atom/A = targets[1]
	if(!isliving(A))
		revert_cast()
		return

	var/mob/living/spelltarget = A
	playsound(get_turf(spelltarget), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

	if(spelltarget != user)
		user.visible_message("[user] mutters an incantation and [spelltarget] 's skin hardens like stone.")
		to_chat(user, span_notice("With another person as a conduit, my spell's duration is doubled."))
		spelltarget.apply_status_effect(/datum/status_effect/buff/stoneskin/other)
	else
		user.visible_message("[user] mutters an incantation and their skin hardens.")
		spelltarget.apply_status_effect(/datum/status_effect/buff/stoneskin)

	return TRUE

#define STONESKIN_FILTER "stoneskin_glow"
/atom/movable/screen/alert/status_effect/buff/stoneskin
	name = "Stoneskin"
	desc = "My skin is hardened like stone. (+5 Constitution)"
	icon_state = "buff"

/datum/status_effect/buff/stoneskin
	var/outline_colour ="#808080" // Granite Grey
	id = "stoneskin"
	alert_type = /atom/movable/screen/alert/status_effect/buff/stoneskin
	effectedstats = list(STATKEY_CON = 5)
	var/hadcritres = FALSE
	duration = 1 MINUTES

/datum/status_effect/buff/stoneskin/other
	duration = 2 MINUTES

/datum/status_effect/buff/stoneskin/on_apply()
	. = ..()
	var/filter = owner.get_filter(STONESKIN_FILTER)
	if (!filter)
		owner.add_filter(STONESKIN_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("My skin hardens like stone."))

/datum/status_effect/buff/stoneskin/on_remove()
	. = ..()
	to_chat(owner, span_warning("The stone shell cracks away."))
	owner.remove_filter(STONESKIN_FILTER)

#undef STONESKIN_FILTER
