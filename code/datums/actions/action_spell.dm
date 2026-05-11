// Legacy spell action so I can complete the migration partially.
//Preset for spells
/datum/action/spell_action
	check_flags = NONE
	background_icon_state = "bg_spell"

/datum/action/spell_action/New(Target)
	..()
	var/obj/effect/proc_holder/S = target
	S.action = src
	name = S.name
	desc = S.desc
	background_icon = S.action_icon
	background_icon_state = S.action_icon_state
	button_icon = S.action_icon
	button_icon_state = S.overlay_state || S.action_icon_state
	overlay_icon_state = S.overlay_state

/datum/action/spell_action/Destroy()
	var/obj/effect/proc_holder/S = target
	S.action = null
	return ..()

/datum/action/spell_action/Trigger()
	if(!..())
		return FALSE
	if(target)
		var/obj/effect/proc_holder/S = target
		S.Click()
		return TRUE

/datum/action/spell_action/IsAvailable()
	if(!target)
		return FALSE
	return TRUE

/datum/action/spell_action/spell

/datum/action/spell_action/spell/IsAvailable()
	if(!target || !owner)
		return FALSE
	var/obj/effect/proc_holder/spell/S = target
	return S.can_cast(owner, feedback = FALSE)

/// Updates maptext on all viewer buttons. Used by the legacy spell recharge system.
/datum/action/spell_action/proc/update_all_maptext(cd_time)
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/button = viewers[hud]
		button.update_maptext(cd_time)

/datum/action/spell_action/proc/examine(mob/user)
	var/list/inspec = list("<br><span class='notice'><b>[name]</b></span>")
	if(desc)
		inspec += "\n[desc]"
	var/obj/effect/proc_holder/spell/S = target
	if(istype(S))
		var/list/stats = S.get_spell_statistics(user)
		if(length(stats))
			inspec += "<br>" + stats.Join("<br>")
	to_chat(user, "[inspec.Join()]")
