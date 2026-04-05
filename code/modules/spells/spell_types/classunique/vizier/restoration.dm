/obj/effect/proc_holder/spell/invoked/vizier_restoration
	name = "Restoration"
	desc = "Uses origin magick to restore the target's body to a prior state, granting health regeneration."
	overlay_state = "restoration"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	range = 3
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = list('sound/magic/regression1.ogg','sound/magic/regression2.ogg','sound/magic/regression3.ogg','sound/magic/regression4.ogg')
	action_icon = 'icons/mob/actions/classuniquespells/vizier.dmi'
	invocations = list("Ishfi!") // https://en.wiktionary.org/wiki/%D8%B4%D9%81%D9%89
	invocation_type = "whisper"
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = TRUE
	recharge_time = 12 SECONDS
	miracle = FALSE
	ignore_los = FALSE
	cost = 2
	devotion_cost = 0
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

/obj/effect/proc_holder/spell/invoked/vizier_restoration/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	target.visible_message(span_info("Origin magick restores [target]'s body!"), span_notice("My body recalls its prior form!"))
	var/healing = 3
	user.Beam(target, icon_state="lichbeam", time=1 SECONDS)
	target.apply_status_effect(/datum/status_effect/buff/healing, healing)
	return TRUE
