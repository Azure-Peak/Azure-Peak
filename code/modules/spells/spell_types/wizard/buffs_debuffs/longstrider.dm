/obj/effect/proc_holder/spell/invoked/longstrider
	name = "Longstrider"
	desc = "Grant yourself and any creatures adjacent to you free movement through rough terrain for 15 minutes."
	overlay_state = "longstrider"
	cost = 2
	xp_gain = TRUE
	school = "transmutation"
	releasedrain = 50
	chargedrain = 0
	chargetime = 1 SECONDS
	recharge_time = 1.5 MINUTES
	warnie = "spellwarning"
	no_early_release = TRUE
	spell_tier = 1 // Not direct combat useful but still good, replicated by polearm
	invocations = list("Aranea Deambulatio")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7

/obj/effect/proc_holder/spell/invoked/longstrider/cast(list/targets, mob/user = usr)

	user.visible_message("[user] mutters an incantation and a dim pulse of light radiates out from them.")

	for(var/mob/living/L in range(1, usr))
		L.apply_status_effect(/datum/status_effect/buff/longstrider)

	return TRUE
