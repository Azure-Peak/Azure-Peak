/obj/effect/proc_holder/spell/invoked/darkvision
	name = "Darkvision"
	desc = "Enhance the night vision of yourself and everyone around you for 5 minutes per level in the associated skill."
	overlay_state = "darkvision"
	clothes_req = FALSE
	school = "transmutation"
	releasedrain = 80
	chargedrain = 0
	chargetime = 1 SECONDS
	no_early_release = TRUE
	recharge_time = 1.5 MINUTES
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	invocations = list("Nox Oculus")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 1
	xp_gain = TRUE
	cost = 2

/obj/effect/proc_holder/spell/invoked/darkvision/miracle
	base_icon_state = "wisescroll"
	cost = 0
	spell_tier = 0
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/darkvision/cast(list/targets, mob/user = usr)
	for(var/mob/living/L in range(1, usr))
		L.apply_status_effect(/datum/status_effect/buff/darkvision, user.get_skill_level(associated_skill))
	return TRUE
