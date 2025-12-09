/obj/effect/proc_holder/spell/invoked/conjure_tool
	name = "Conjure Tool"
	desc = "Conjure a tool of your choice in your hand or on the ground"
	action_icon = 'icons/mob/actions/malummiracles.dmi'
	overlay_icon = 'icons/mob/actions/malummiracles.dmi'
	overlay_state = "ctool"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 60
	chargedrain = 1
	chargetime = 2 SECONDS
	no_early_release = TRUE
	recharge_time = 1 MINUTES

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	antimagic_allowed = FALSE
	charging_slowdown = 3
	cost = 1
	spell_tier = 1 // Spellblade tier.

	invocations = list("O Malum, Grant me your tool!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW

	var/obj/item/conjured_tool = null

	var/list/tool_options = list(
		"Hoe" = /obj/item/rogueweapon/hoe,
		"Thresher" = /obj/item/rogueweapon/thresher,
		"Sickle" = /obj/item/rogueweapon/sickle,
		"Pitchfork" = /obj/item/rogueweapon/pitchfork,
		"Tongs" = /obj/item/rogueweapon/tongs,
		"Hammer" = /obj/item/rogueweapon/hammer/iron,
		"Shovel" = /obj/item/rogueweapon/shovel,
		"Fishing Rod" = /obj/item/fishingrod,
	)

/obj/effect/proc_holder/spell/invoked/conjure_tool/cast(list/targets, mob/living/user = usr)
	var/tool_choice = input(user, "Choose a tool", "Conjure Tool") as anything in tool_options
	if(!tool_choice)
		return
	tool_choice = tool_options[tool_choice]
	if(src.conjured_tool)
		qdel(src.conjured_tool)
		src.conjured_tool = null

	var/obj/item/R = new tool_choice(user.drop_location())
	R.blade_dulling = DULLING_SHAFT_CONJURED
	R.filters += filter(type = "drop_shadow", x=0, y=0, size=1, offset = 2, color = GLOW_COLOR_ARCANE)
	R.smeltresult = null
	R.salvage_result = null
	R.fiber_salvage = FALSE
	user.put_in_hands(R)
	src.conjured_tool = R
	return TRUE

/obj/effect/proc_holder/spell/invoked/conjure_tool/Destroy()
	if(src.conjured_tool)
		src.visible_message(span_warning("The [src]'s borders begin to shimmer and fade, before it vanishes entirely!"))
		qdel(src.conjured_tool)
		src.conjured_tool = null
	return ..()
