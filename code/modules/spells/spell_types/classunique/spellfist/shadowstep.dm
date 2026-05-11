/datum/action/cooldown/spell/blink/shadowstep
	name = "Shadowstep"
	desc = "Project your shadow to swap places with it, teleporting several paces away. Limited to a range of 5 paces. Only works on the same plane as the caster.\n\
	A variation on the common Blink Spell, developed and perfected by the Yogi of Naledi to requires a much less forceful, whispered invocation and not alert their enemies, while retaining the same utility."
	button_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	button_icon_state = "shadowstep"
	invocations = list("Intaqil.")
	invocation_type = INVOCATION_WHISPER
	phase = /obj/effect/temp_visual/blink/shadowstep
	phase_sound = 'sound/magic/shadowstep.ogg'
	phase_beam = null
	charge_slowdown = 0

/obj/effect/temp_visual/blink/shadowstep
	icon_state = "curse"
	light_color = COLOR_PALE_PURPLE_GRAY
