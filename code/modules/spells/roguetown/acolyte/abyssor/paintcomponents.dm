#define UMBRAL_FILTER_COATING "umbral_coating"
#define UMBRAL_FILTER_GLOW    "umbral_glow"

#define UMBRAL_COLOR_INK      "#03000a"
#define UMBRAL_COLOR_GLOW     "#8a00e6"
#define UMBRAL_INK_ALPHA      230
#define UMBRAL_GLOW_ALPHA     180

#define UMBRAL_MINDLESS_DAMAGE 100
#define UMBRAL_CONSCIOUS_DAMAGE 10
#define UMBRAL_ENCHANT_DURATION (20 SECONDS)

/datum/component/umbral_enchant
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/obj/item/parent_weapon
	var/duration = UMBRAL_ENCHANT_DURATION
	var/outline_applied = FALSE
	var/datum/weakref/caster_ref

/datum/component/umbral_enchant/Initialize(mob/living/caster)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	parent_weapon = parent

	if(caster)
		caster_ref = WEAKREF(caster)

	apply_outline()
	RegisterSignal(parent_weapon, COMSIG_ITEM_ATTACK_SUCCESS, .proc/on_attack_success)
	RegisterSignal(parent_weapon, COMSIG_PARENT_QDELETING, .proc/on_qdel)
	addtimer(CALLBACK(src, .proc/remove_enchantment), duration)

/datum/component/umbral_enchant/proc/apply_outline()
	if(outline_applied)
		return

	parent_weapon.add_filter(UMBRAL_FILTER_COATING, 1, list(
		"type"  = "outline", 
		"color" = UMBRAL_COLOR_INK, 
		"alpha" = UMBRAL_INK_ALPHA, 
		"size"  = 1
	))

	parent_weapon.add_filter(UMBRAL_FILTER_GLOW, 2, list(
		"type"  = "outline", 
		"color" = UMBRAL_COLOR_GLOW, 
		"alpha" = UMBRAL_GLOW_ALPHA, 
		"size"  = 1
	))

	outline_applied = TRUE

/datum/component/umbral_enchant/proc/remove_outline()
	if(!outline_applied)
		return
	parent_weapon.remove_filter(UMBRAL_FILTER_COATING)
	parent_weapon.remove_filter(UMBRAL_FILTER_GLOW)
	outline_applied = FALSE

/datum/component/umbral_enchant/proc/on_attack_success(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(!isliving(target))
		return

	var/mob/living/caster = caster_ref?.resolve()
	var/is_mindless = FALSE

	if(istype(target, /mob/living/simple_animal) || !target.mind)
		is_mindless = TRUE

	if(is_mindless)
		user.visible_message(
			span_purple("The umbral paint on [parent_weapon] violently implodes against [target]"),
			span_purple("My strike seems more potent against those barely capable of dreaming.")
		)
		target.adjustBruteLoss(UMBRAL_MINDLESS_DAMAGE)
	else
		target.adjustBruteLoss(UMBRAL_CONSCIOUS_DAMAGE)
		to_chat(user, span_notice("My strike doesn't harm [target] much, but it does make them ooze beneficial ink."))

	target.apply_status_effect(/datum/status_effect/debuff/ink_leak, caster)

	remove_enchantment()

/datum/component/umbral_enchant/proc/on_qdel(datum/source)
	SIGNAL_HANDLER
	remove_enchantment()

/datum/component/umbral_enchant/proc/remove_enchantment()
	qdel(src)

/datum/component/umbral_enchant/Destroy()
	if(outline_applied)
		remove_outline()
	if(parent_weapon)
		parent_weapon.visible_message(span_warning("The heavy, glowing sediment completely drips off [parent_weapon], drying up."))
		UnregisterSignal(parent_weapon, list(COMSIG_ITEM_ATTACK_SUCCESS, COMSIG_PARENT_QDELETING))
		parent_weapon = null
	caster_ref = null
	return ..()

#undef UMBRAL_FILTER_COATING
#undef UMBRAL_FILTER_GLOW

#undef UMBRAL_COLOR_INK
#undef UMBRAL_COLOR_GLOW
#undef UMBRAL_INK_ALPHA
#undef UMBRAL_GLOW_ALPHA

#undef UMBRAL_MINDLESS_DAMAGE
#undef UMBRAL_CONSCIOUS_DAMAGE
#undef UMBRAL_ENCHANT_DURATION
