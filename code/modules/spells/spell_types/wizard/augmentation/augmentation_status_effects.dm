// ============================================
// Augmentation Spell Status Effects
// Consolidated from buffs_debuffs/ spell files
// ============================================

// ---- HASTE ----

/atom/movable/screen/alert/status_effect/buff/attune_haste
	name = "Attune: Haste"
	desc = "My limbs move with uncanny swiftness. (+3 Speed, 0.85x Action Cooldown)"
	icon_state = "buff"

#define HASTE_FILTER "haste_glow"

/datum/status_effect/buff/attune_haste
	var/outline_colour ="#F0E68C" // Hopefully not TOO yellow
	id = "haste"
	alert_type = /atom/movable/screen/alert/status_effect/buff/attune_haste
	effectedstats = list(STATKEY_SPD = 3)
	duration = STAT_BUFF_SELF_DURATION

/datum/status_effect/buff/attune_haste/on_creation(mob/living/new_owner, var/new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/attune_haste/on_apply()
	. = ..()
	owner.balloon_alert_to_viewers("<font color='[outline_colour]'>attune: haste (+3 spd)!</font>")
	var/filter = owner.get_filter(HASTE_FILTER)
	if (!filter)
		owner.add_filter(HASTE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 25, "size" = 1))
	to_chat(owner, span_warning("My limbs move with uncanny swiftness."))

/datum/status_effect/buff/attune_haste/on_remove()
	. = ..()
	owner.remove_filter(HASTE_FILTER)
	to_chat(owner, span_warning("My body moves slowly again..."))

#undef HASTE_FILTER

/datum/status_effect/buff/attune_haste/nextmove_modifier()
	return 0.85

// ---- GIANT'S STRENGTH ----

#define GIANTSSTRENGTH_FILTER "giantsstrength_glow"

/atom/movable/screen/alert/status_effect/buff/attune_giant
	name = "Attune: Giant"
	desc = "My muscles are strengthened. (+4 Strength)"
	icon_state = "buff"

/datum/status_effect/buff/attune_giant
	var/outline_colour ="#8B0000" // Different from strength potion cuz red = strong
	id = "giantstrength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/attune_giant
	effectedstats = list(STATKEY_STR = 4)
	duration = STAT_BUFF_SELF_DURATION

/datum/status_effect/buff/attune_giant/on_creation(mob/living/new_owner, var/new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/attune_giant/on_apply()
	. = ..()
	owner.balloon_alert_to_viewers("<font color='[outline_colour]'>attune: giant (+4 str)!</font>")
	var/filter = owner.get_filter(GIANTSSTRENGTH_FILTER)
	if (!filter)
		owner.add_filter(GIANTSSTRENGTH_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("My muscles strengthen."))


/datum/status_effect/buff/attune_giant/on_remove()
	. = ..()
	to_chat(owner, span_warning("My strength fades away..."))
	owner.remove_filter(GIANTSSTRENGTH_FILTER)

#undef GIANTSSTRENGTH_FILTER

// ---- HAWK'S EYES ----

#define HAWKSEYES_FILTER "hawkseyes_glow"

/atom/movable/screen/alert/status_effect/buff/attune_hawk
	name = "Attune: Hawk"
	desc = "My vision is sharpened. (+1 Strength, +4 Perception)"
	icon_state = "buff"

/datum/status_effect/buff/attune_hawk
	var/outline_colour ="#ffff00" // Same color as perception potion
	id = "hawkseyes"
	alert_type = /atom/movable/screen/alert/status_effect/buff/attune_hawk
	effectedstats = list(STATKEY_STR = 1, STATKEY_PER = 4)
	duration = STAT_BUFF_SELF_DURATION

/datum/status_effect/buff/attune_hawk/on_creation(mob/living/new_owner, var/new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/attune_hawk/on_apply()
	. = ..()
	owner.balloon_alert_to_viewers("<font color='[outline_colour]'>attune: hawk (+1 str, +4 per)!</font>")
	var/filter = owner.get_filter(HAWKSEYES_FILTER)
	if (!filter)
		owner.add_filter(HAWKSEYES_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 25, "size" = 1))
	to_chat(owner, span_warning("My vision sharpens, like that of a hawk."))


/datum/status_effect/buff/attune_hawk/on_remove()
	. = ..()
	to_chat(owner, span_warning("My vision blurs, losing its unnatural keenness."))
	owner.remove_filter(HAWKSEYES_FILTER)

#undef HAWKSEYES_FILTER

// ---- GUIDANCE ----

#define GUIDANCE_FILTER "guidance_glow"

/atom/movable/screen/alert/status_effect/buff/guidance
	name = "Guidance"
	desc = "Arcyne focus sharpens my senses. (+3 Perception)"
	icon_state = "buff"

/datum/status_effect/buff/guidance
	var/outline_colour ="#f58e2d"
	id = "guidance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/guidance
	effectedstats = list(STATKEY_PER = 3)
	duration = STAT_BUFF_SELF_DURATION

/datum/status_effect/buff/guidance/on_creation(mob/living/new_owner, var/new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/guidance/on_apply()
	. = ..()
	owner.balloon_alert_to_viewers("<font color='[outline_colour]'>guidance (+3 per)!</font>")
	var/filter = owner.get_filter(GUIDANCE_FILTER)
	if (!filter)
		owner.add_filter(GUIDANCE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("The arcyne sharpens my senses."))

/datum/status_effect/buff/guidance/on_remove()
	. = ..()
	to_chat(owner, span_warning("The arcyne clarity fades from my senses."))
	owner.remove_filter(GUIDANCE_FILTER)

#undef GUIDANCE_FILTER

// ---- FORTITUDE ----

/atom/movable/screen/alert/status_effect/buff/fortitude
	name = "Fortitude"
	desc = "My humors have been hardened to the fatigues of the body. (-25% Stamina Usage)"
	icon_state = "buff"

#define FORTITUDE_FILTER "fortitude_glow"

/datum/status_effect/buff/fortitude
	var/outline_colour ="#008000" // Forest green to avoid le sparkle mage
	id = "fortitude"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fortitude
	duration = STAT_BUFF_SELF_DURATION

/datum/status_effect/buff/fortitude/on_creation(mob/living/new_owner, var/new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/fortitude/on_apply()
	. = ..()
	owner.balloon_alert_to_viewers("<font color='[outline_colour]'>fortitude (-25% stam)!</font>")
	var/filter = owner.get_filter(FORTITUDE_FILTER)
	if (!filter)
		owner.add_filter(FORTITUDE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("My body feels lighter..."))
	ADD_TRAIT(owner, TRAIT_FORTITUDE, MAGIC_TRAIT)

/datum/status_effect/buff/fortitude/on_remove()
	. = ..()
	owner.remove_filter(FORTITUDE_FILTER)
	to_chat(owner, span_warning("The weight of the world rests upon my shoulders once more."))
	REMOVE_TRAIT(owner, TRAIT_FORTITUDE, MAGIC_TRAIT)

#undef FORTITUDE_FILTER

// ---- FEATHERFALL ----
// (alert + status effect originally in roguebuff.dm)

/atom/movable/screen/alert/status_effect/buff/featherfall
	name = "Featherfall"
	desc = "I am somewhat protected against falling from heights."
	icon_state = "buff"

/datum/status_effect/buff/featherfall
	id = "featherfall"
	alert_type = /atom/movable/screen/alert/status_effect/buff/featherfall
	duration = UTILITY_AOE_BUFF_DURATION

/datum/status_effect/buff/featherfall/on_apply()
	. = ..()
	to_chat(owner, span_warning("I feel lighter."))
	ADD_TRAIT(owner, TRAIT_NOFALLDAMAGE2, MAGIC_TRAIT)

/datum/status_effect/buff/featherfall/on_remove()
	. = ..()
	to_chat(owner, span_warning("The feeling of lightness fades."))
	REMOVE_TRAIT(owner, TRAIT_NOFALLDAMAGE2, MAGIC_TRAIT)

// ---- DARKVISION ----
// (alert + status effect originally in roguebuff.dm)

/atom/movable/screen/alert/status_effect/buff/darkvision
	name = "Darkvision"
	desc = "I can see in the dark somewhat."
	icon_state = "darkvision"

/datum/status_effect/buff/darkvision
	id = "darkvision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/darkvision
	duration = UTILITY_AOE_BUFF_DURATION

/datum/status_effect/buff/darkvision/on_apply(mob/living/new_owner)
	. = ..()
	to_chat(owner, span_warning("The darkness fades somewhat."))
	ADD_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)

/datum/status_effect/buff/darkvision/on_remove()
	. = ..()
	to_chat(owner, span_warning("The darkness returns to normal."))
	REMOVE_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)

/atom/movable/screen/alert/status_effect/buff/nitevision
	name = "Nitevision"
	desc = "I can see in the dark."
	icon_state = "darkvision"

/datum/status_effect/buff/nitevision
	id = "nitevision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/nitevision
	duration = UTILITY_AOE_BUFF_DURATION

/datum/status_effect/buff/nitevision/on_apply(mob/living/new_owner)
	. = ..()
	to_chat(owner, span_warning("The darkness fades."))
	ADD_TRAIT(owner, TRAIT_NITEVISION, MAGIC_TRAIT)

/datum/status_effect/buff/nitevision/on_remove()
	. = ..()
	to_chat(owner, span_warning("The darkness returns to normal."))
	REMOVE_TRAIT(owner, TRAIT_NITEVISION, MAGIC_TRAIT)

// ---- IRON SKIN ----

#define IRON_SKIN_FILTER "iron_skin_glow"

/atom/movable/screen/alert/status_effect/buff/iron_skin
	name = "Iron Skin"
	desc = "Bits of arcyne iron and steel surround my armor, any attacks against me are blunted."
	icon_state = "buff"

/datum/status_effect/buff/iron_skin
	var/outline_colour = "#708090"
	id = "iron_skin"
	alert_type = /atom/movable/screen/alert/status_effect/buff/iron_skin
	duration = STAT_BUFF_SELF_DURATION

/datum/status_effect/buff/iron_skin/on_creation(mob/living/new_owner, var/new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/iron_skin/on_apply()
	. = ..()
	var/filter = owner.get_filter(IRON_SKIN_FILTER)
	if(!filter)
		owner.add_filter(IRON_SKIN_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 40, "size" = 1))
	to_chat(owner, span_notice("Bits of arcyne iron and steel surround my armor, any blows and attacks against me are blunted."))

/datum/status_effect/buff/iron_skin/on_remove()
	. = ..()
	to_chat(owner, span_warning("The iron shell flakes away."))
	owner.remove_filter(IRON_SKIN_FILTER)

#undef IRON_SKIN_FILTER
