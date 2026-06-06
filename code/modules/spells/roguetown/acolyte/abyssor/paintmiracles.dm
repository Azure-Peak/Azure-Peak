/datum/action/cooldown/spell/ink_presence
	name = "Inky Presence"
	desc = "Exude an active aura of deep ink. Moving leaves trails that accelerate self and attuned allies, while crippling enemies."
	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "paint"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#00051f"

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Ink wept from the void, consume!")
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 0.5 SECONDS
	cooldown_time = 45 SECONDS
	devotion_cost = 25
	associated_skill = /datum/skill/magic/holy

	var/active_duration = 15 SECONDS

/datum/action/cooldown/spell/ink_presence/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user)
		return FALSE
	to_chat(user, span_blue("<i>Black ink begins weeping violently from your skin!</i>"))

	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/generate_ink_trail)
	addtimer(CALLBACK(src, .proc/stop_ink_presence, user), active_duration)
	return TRUE

/datum/action/cooldown/spell/ink_presence/proc/generate_ink_trail(mob/living/user, turf/old_turf, dir)
	SIGNAL_HANDLER
	if(!user || user.stat != CONSCIOUS)
		return
	var/turf/current_turf = get_turf(user)
	if(!current_turf || !isopenturf(current_turf))
		return

	var/obj/effect/temp_visual/ink_trail/existing_trail = locate(/obj/effect/temp_visual/ink_trail) in current_turf

	if(existing_trail)
		return
	else
		new /obj/effect/temp_visual/ink_trail(current_turf, user)

/datum/action/cooldown/spell/ink_presence/proc/stop_ink_presence(mob/living/user)
	if(user)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		to_chat(user, span_notice("Your ink pores close, drying up your aura."))
