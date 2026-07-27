/datum/action/cooldown/spell/vizier
	source_aspect = /datum/magic_aspect/pseudo/vizier
	button_icon = 'icons/mob/actions/classuniquespells/vizier.dmi'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	click_to_activate = TRUE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_STAMINA
	charge_sound = 'sound/magic/charging.ogg'
	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	/// Fatigue/mana cost for the Vizier's origin magic system.
	var/cost

/datum/action/cooldown/spell/vizier/restoration/lesser
	cooldown_time = 24 SECONDS // w.Yogi gets double the cooldown of Vizier, who is a master at it, but there's a catch. INT gives CDR to this, so if you pick INT-based packs, Crystalhide, potions, etc. There may be a method to circumvent it being so high.

/datum/action/cooldown/spell/vizier/restoration
	name = "Restoration"
	desc = "Uses Origin Magick to gradually rewind a target's body to a healthier state. The effects happen in order, and only one at a time. Removes embedded objects, stops bleeding, grants health regeneration and energy recovery. The nature of time-based manipulation allows this to work on most targets."
	fluff_desc = "The Yogis of Naledi teach that time is not a river but a tapestry, every moment of a thing's existence woven into a single whole. Origin Magick draws upon this belief, allowing its practitioners to call forth echoes of an earlier state and impose them upon the present. To heal is to remember an unwounded body; to restore is to recall a form before it was broken. Though no mortal can truly stand outside the march of time, Origin Magick is regarded as the nearest approach to Psydon's divinity ever achieved by humenity."
	button_icon_state = "restoration"
	sound = list('sound/magic/regression1.ogg', 'sound/magic/regression2.ogg', 'sound/magic/regression3.ogg', 'sound/magic/regression4.ogg')
	cast_range = 4
	charge_required = FALSE
	cooldown_time = 12 SECONDS
	invocations = list("Ishfi!")
	invocation_type = INVOCATION_WHISPER

/datum/action/cooldown/spell/vizier/restoration/cast(atom/cast_on)
	. = ..()

	var/mob/living/target = cast_on
	if(!istype(target))
		return FALSE
	if(!isliving(target))
		return FALSE

	var/obj/effect/temp_visual/origin_restoration/V = new
	target.vis_contents += V

	var/turf/user_turf = get_turf(owner)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, NORTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, NORTHWEST)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, SOUTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, SOUTHWEST)

	if(!istype(target, /mob/living/carbon))
		target.apply_status_effect(/datum/status_effect/buff/originhealing)
		target.visible_message(span_info("Origin arts stabilize [target]!"), span_notice("A brief temporal correction passes through me."))
		return TRUE

	var/mob/living/carbon/C = target

	var/step_check = FALSE

	// Embedded objects
	if(length(C.bodyparts))
		for(var/obj/item/bodypart/BP in C.bodyparts)
			if(!BP)
				continue

			if(length(BP.embedded_objects))
				for(var/obj/item/embedded as anything in BP.embedded_objects)
					if(!embedded)
						continue
					BP.remove_embedded_object(embedded)
					playsound(C.loc, 'sound/surgery/organ1.ogg', 100)
					step_check = TRUE

	if(length(C.simple_embedded_objects))
		for(var/obj/item/embedded as anything in C.simple_embedded_objects)
			if(!embedded)
				continue
			C.simple_remove_embedded_object(embedded)
			playsound(C.loc, 'sound/surgery/organ1.ogg', 100)
			step_check = TRUE

	if(step_check)
		C.visible_message(span_info("Origin arts undo [C]'s embedded objects!"), span_notice("Foreign objects are rewound in time!"))
		return TRUE

	// Wound bleed
	var/list/wAmount = C.get_wounds()
	if(wAmount && length(wAmount))
		for(var/datum/wound/W as anything in wAmount)
			if(!W)
				continue
			if(W.bleed_rate > 0)
				W.set_bleed_rate(0)
				step_check = TRUE

	if(step_check)
		C.visible_message(span_info("Origin arts reverse [C]'s bleeding!"),	span_notice("My bleeding wounds close, as if reverting in time!"))
		return TRUE

	// Healing
	C.visible_message(span_info("Origin arts rewind [C]'s body!"), span_notice("My body slowly recalls to a prior form!"))

	C.apply_status_effect(/datum/status_effect/buff/originhealing)

	return TRUE

/obj/effect/temp_visual/origin_restoration
	icon = 'icons/effects/effects.dmi'
	icon_state = "anom"
	duration = 10
	layer = ABOVE_MOB_LAYER
	alpha = 200
	color = "#FFD966"

/obj/effect/temp_visual/origin_restoration/Initialize(mapload)
	. = ..()
	transform = matrix()*3
	animate(src, transform = matrix()*0.1, alpha = 0, time = duration, easing = EASE_IN)
	return INITIALIZE_HINT_NORMAL

/obj/effect/temp_visual/origin_restoration/Destroy()
	if(ismob(loc))
		var/mob/M = loc
		M.vis_contents -= src
	return ..()

/obj/effect/temp_visual/origin_restoration_burst
	icon = 'icons/effects/effects.dmi'
	icon_state = "medi_holo"
	duration = 8
	layer = ABOVE_MOB_LAYER
	alpha = 220
	color = "#FFD966"

/obj/effect/temp_visual/origin_restoration_burst/Initialize(mapload, dir_to_go)
	. = ..()
	var/turf/T = get_step(src, dir_to_go)
	if(T)
		animate(src, pixel_x = (T.x - x) * 32, pixel_y = (T.y - y) * 32, alpha = 0, time = duration)
	return INITIALIZE_HINT_NORMAL
