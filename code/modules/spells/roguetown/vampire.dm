/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/Shapeshift(mob/living/carbon/human/caster)
	if(!istype(caster)) // FVCK OFF
		return

	var/obj/shapeshift_holder/H = locate() in caster
	if(H)
		to_chat(caster, span_warning("You're already shapeshifted!"))
		return

	if(!do_after(caster, (SHAPESHIFT_MOVEAFTER - caster.get_vampire_generation()) SECONDS, target = caster))
		to_chat(caster, span_userdanger("You are unable to concentrate enough to shapeshift!"))
		return

	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat
	name = "Bat Form"
	desc = ""
	overlay_state = "bat_transform"
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form =  FALSE
	do_gib = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/bat

/obj/effect/proc_holder/spell/targeted/shapeshift/gaseousform
	name = "Mist Form"
	desc = ""
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form =  FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/gaseousform

/obj/effect/proc_holder/spell/targeted/shapeshift/rat
	name = "Rat Form"
	desc = ""
	recharge_time = 5 SECONDS
	cooldown_min = 5 SECONDS
	die_with_shapeshifted_form = FALSE
	do_gib = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/smallrat

/obj/effect/proc_holder/spell/targeted/shapeshift/cabbit
	name = "Cabbit Form"
	desc = ""
	recharge_time = 5 SECONDS
	cooldown_min = 5 SECONDS
	die_with_shapeshifted_form = FALSE
	do_gib = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit

/obj/effect/proc_holder/spell/invoked/vampire_float
	name = "Float"
	desc = "Float off the air without a sound"
	recharge_time = 5 SECONDS
	cooldown_min = 5 SECONDS
	releasedrain = 1
	chargedrain = 1
	chargetime = 2
	warnie = "spellwarning"
	school = "blood"
	no_early_release = TRUE
	movement_interrupt = FALSE
	invocation_type = "whisper"
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic.blood
	glow_color = GLOW_COLOR_VAMPIRIC
	glow_intensity = GLOW_INTENSITY_MEDIUM

/obj/effect/proc_holder/spell/invoked/vampire_float/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/carbon/human/vampire_caster = targets[1]
		if(!user)
			return

		if(vampire_caster.has_status_effect(/datum/status_effect/buff/vampire_float))
			to_chat(vampire_caster, span_warning("Already active."))
			return


		vampire_caster.apply_status_effect(/datum/status_effect/buff/vampire_float)
		to_chat(vampire_caster, span_redtext("! LIFT ME ABOVE IT ALL !"))
		vampire_caster.playsound_local(get_turf(vampire_caster), 'sound/misc/vampirespell.ogg', 100, FALSE, pressure_affected = FALSE)

#define VAMPIRIC_FILTER "vampiric_glow"


/datum/status_effect/buff/vampire_float/on_apply()
	. = ..()
	var/filter = owner.get_filter(VAMPIRIC_FILTER)
	if (!filter)
		owner.add_filter(VAMPIRIC_FILTER, 2, list("type" = "outline", "color" = "#8B0000", "alpha" = 100, "size" = 1))

/datum/status_effect/buff/vampire_float/on_remove()
	. = ..()
	to_chat(owner, span_warning("I'm no longer floating"))
	owner.remove_filter(VAMPIRIC_FILTER)

#undef VAMPIRIC_FILTER
