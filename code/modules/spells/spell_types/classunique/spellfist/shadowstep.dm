/*
	Old shadowstep got crept out and has like no in combat utilities
	This is a redesign basically just making it a stealthier blink.
*/

/obj/effect/proc_holder/spell/invoked/blink/shadowstep
	name = "Shadowstep"
	desc = "Project your shadow to swap places with it, teleporting several paces away. Limited to a range of 5 paces. Only works on the same plane as the caster.\n\
	A variation on the common Blink Spell, developed and perfected by the Yogi of Naledi to requires a much less forceful, whispered invocation and not alert their enemies, while retaining the same utility."
	action_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	overlay_state = "shadowstep"
	invocations = list("Intaqil.") // https://en.wiktionary.org/wiki/%D9%86%D9%82%D9%84 - "To transfer" in Arabic
	invocation_type = "whisper"
	phase = /obj/effect/temp_visual/blink/shadowstep
	phase_sound = 'sound/magic/shadowstep.ogg'
	phase_beam = null // No beam — silent teleport
	charging_slowdown = 0 // In line with Spellblade abilities no slowdown

/obj/effect/temp_visual/blink/shadowstep
	icon_state = "curse"
	light_color = COLOR_PALE_PURPLE_GRAY
