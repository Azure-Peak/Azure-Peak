/datum/action/cooldown/spell/eyescry
	name = "Lux Scrying"
	desc = "With a sacrifice of Lux, invoke knowledge of a target's true name to observe them from afar through artificed eyes."
	button_icon = 'icons/mob/actions/engineer_skills.dmi'
	button_icon_state = "eyeball-lux"
	sound = 'sound/foley/whiz (1).ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_LUX
	primary_resource_cost = 1 //effective 5 minute cooldown after using this

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS //equivalent to a scrying orb
	spell_tier = 0
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/eyescry/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!istype(user) || !user.mind)
		return FALSE
	var/input = input(user, "WHO DO YOU SEEK?", "INVOCATION OF NAMES") as text|null
	if(!input)
		return
	if(!user.key)
		return
	var/mob/living/carbon/human/target = null
	for(var/mob/living/carbon/human/HL in GLOB.player_list)
		if(HL.real_name == input)
			if(HAS_TRAIT(HL, TRAIT_ANTISCRYING))
				to_chat(user, span_warning("They slip my gaze..."))
				return
			target = HL
			message_admins("SCRYING: [user.real_name] ([user.ckey]) has fixated on [target.real_name] ([target.ckey]) via black mirror.")
			log_game("SCRYING: [user.real_name] ([user.ckey]) has fixated on [target.real_name] ([target.ckey]) via black mirror.")
			ADD_TRAIT(user, TRAIT_NOSSDINDICATOR, "luxeye")
			var/mob/dead/observer/eye/screye/blackmirror/S = user.scry_ghost()
			if(!S)
				return FALSE
			S.ManualFollow(target)
			var/luxtype = user.get_lux_type()
			switch(luxtype)
				if("tainted")
					target.throw_alert(usr, "luxeye", /atom/movable/screen/alert/eyescry, override = TRUE)
					if(target.stat != DEAD && target.stat != UNCONSCIOUS)
						to_chat(target, span_warning("I feel a revolting gaze settle upon me."))
				if("corrupted")//if you have fey lux, falseflag as a hag or feytouch scrying! funny!
					target.throw_alert(usr, "luxeye", /atom/movable/screen/alert/hagscry, override = TRUE)
					if(target.stat != DEAD && target.stat != UNCONSCIOUS)
						to_chat(target, span_warning("I feel as though the ground is watching me."))
				if("infernal")
					S.add_client_colour(/datum/client_colour/nocshaded)
					target.throw_alert(usr, "luxeye", /atom/movable/screen/alert/eyescry, override = TRUE)
					if(target.stat != DEAD && target.stat != UNCONSCIOUS)
						to_chat(target, span_warning("I feel an infernal gaze upon my shoulder!."))
				if("impure")
					S.add_client_colour(/datum/client_colour/nocshaded)
					target.throw_alert(usr, "luxeye", /atom/movable/screen/alert/eyescry, override = TRUE)
					if(target.stat != DEAD && target.stat != UNCONSCIOUS)
						to_chat(target, span_warning("I feel a pair of unknown eyes on me."))
				if("pure")
					target.throw_alert(usr, "luxeye", /atom/movable/screen/alert/eyescry, override = TRUE)
					if(target.stat != DEAD && target.stat != UNCONSCIOUS)
						to_chat(target, span_warning("I feel a divine gaze upon my shoulder!"))
			user.visible_message(span_warning("A bronze iris spins shut over [user]'s eyes, and they stop moving"))
			addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), 8 SECONDS)
			sleep(81)
			user.visible_message(span_warning("The bronze recedes from [user]'s eyes, and they awaken"))
			REMOVE_TRAIT(user, TRAIT_NOSSDINDICATOR, "luxeye")
			return TRUE
	return FALSE

/atom/movable/screen/alert/eyescry
	name = "MECHANICAL OBSERVER"
	desc = "I SEE YOU."
	icon_state = "luxeye"
	timeout = 8 SECONDS
