/// Tints the Light orb can be shifted between (use the orb in hand). Name -> light colour.
/// These are the lighter counterparts of the magelight mote's tints (see mote_light_tints in prestidigitation.dm).
GLOBAL_LIST_INIT(orb_light_tints, list(
	"white" = "#ffffff",
	"salt-gold" = "#ffe9a8",
	"copper-green" = "#b8f0c8",
	"tin-blue" = "#cfe8ff",
	"cinnabar-rose" = "#ffd0ca",
	"manganese-violet" = "#e4d0ff"
))

/// What the wielder sees when the orb shifts to each tint. Name -> message.
GLOBAL_LIST_INIT(orb_tint_messages, list(
	"white" = "The orb settles into a plain, pure white glow.",
	"salt-gold" = "Flecks of salt-gold drift through the orb, warming its glow.",
	"copper-green" = "A verdigris sheen creeps across the orb, turning its glow a soft copper-green.",
	"tin-blue" = "The orb cools to a pale tin-blue, like frost catching the light.",
	"cinnabar-rose" = "The orb blushes a pale cinnabar-rose.",
	"manganese-violet" = "A lilac haze gathers in the orb, tinging its glow with manganese-violet."
))

/datum/action/cooldown/spell/light
	button_icon = 'icons/mob/actions/roguespells.dmi'
	name = "Light"
	desc = "Summons a condensed orb of light."
	button_icon_state = "light"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_LIGHT
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Evoca Lucem.")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 0.5 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/item
	var/item_type = /obj/item/flashlight/flare/light
	var/delete_old = TRUE
	/// Index into GLOB.orb_light_tints. Remembered between casts so a recast keeps your chosen glow.
	var/tint_index = 1

/datum/action/cooldown/spell/light/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	if(delete_old && item && !QDELETED(item))
		var/obj/item/flashlight/flare/light/old_orb = item
		if(istype(old_orb))
			tint_index = old_orb.tint_index
		QDEL_NULL(item)
	if(user.dropItemToGround(user.get_active_held_item()))
		user.put_in_hands(make_item(), TRUE)
		user.visible_message(span_info("An orb of light condenses in [user]'s hand!"), span_info("You condense an orb of pure light!"))
	return TRUE

/datum/action/cooldown/spell/light/Destroy()
	if(item)
		qdel(item)
	return ..()

/datum/action/cooldown/spell/light/proc/make_item()
	item = new item_type
	var/obj/item/flashlight/flare/light/orb = item
	if(istype(orb))
		orb.set_tint(tint_index)
	else
		var/mutable_appearance/magic_overlay = mutable_appearance('icons/obj/projectiles.dmi', "gumball")
		item.add_overlay(magic_overlay)
	return item

/obj/item/flashlight/flare/light
	name = "condensed light"
	desc = "An orb of condensed light."
	w_class = WEIGHT_CLASS_NORMAL
	light_outer_range = 10
	light_color = LIGHT_COLOR_WHITE
	force = 10
	icon = 'icons/roguetown/rav/obj/cult.dmi'
	icon_state = "sphere0"
	item_state = "sphere0"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	light_color = "#ffffff"
	on_damage = 10
	flags_1 = null
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP
	var/datum/looping_sound/torchloop/soundloop
	max_integrity = 200
	fuel = 10 MINUTES
	/// Index into GLOB.orb_light_tints.
	var/tint_index = 1
	/// Orbs that must keep a fixed look (e.g. the Forlorne wisp) set this to FALSE.
	var/can_retint = TRUE
	var/mutable_appearance/orb_overlay

/// Sets the orb's glow (and the tint of its sprite) to the given entry of GLOB.orb_light_tints. Returns the tint's name.
/obj/item/flashlight/flare/light/proc/set_tint(index)
	var/list/tints = GLOB.orb_light_tints
	tint_index = WRAP(index, 1, length(tints) + 1)
	var/tint_name = tints[tint_index]
	var/tint_color = tints[tint_name]
	set_light_color(tint_color)
	if(orb_overlay)
		cut_overlay(orb_overlay)
	orb_overlay = mutable_appearance('icons/obj/projectiles.dmi', "gumball")
	orb_overlay.color = tint_color
	add_overlay(orb_overlay)
	return tint_name

/// Using the orb in hand shifts it to the next tint.
/obj/item/flashlight/flare/light/attack_self(mob/user)
	if(!can_retint)
		return ..()
	var/tint_name = set_tint(tint_index + 1)
	var/message = GLOB.orb_tint_messages[tint_name] || "The orb shifts to a [tint_name] glow."
	to_chat(user, span_notice(message))
	return TRUE

/obj/item/flashlight/flare/light5e/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -9,"sy" = 3,"nx" = 12,"ny" = 4,"wx" = -6,"wy" = 5,"ex" = 3,"ey" = 6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 2,"sturn" = 2,"wturn" = -2,"eturn" = -2,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/// Dim, short-lived orb dropped at the feet of those with the Forlorne vice.
/obj/item/flashlight/flare/light/forlorne
	name = "fading light"
	desc = "A faint wisp of condensed light. Your last hope to get home."
	light_outer_range = 3
	light_power = 0.6
	light_color = "#a0a0a0"
	can_retint = FALSE
	var/lifetime = 180 SECONDS

/obj/item/flashlight/flare/light/forlorne/Initialize(mapload)
	. = ..()
	// The Light spell adds this overlay in make_item(); that's the orb's actual sprite
	var/mutable_appearance/orb = mutable_appearance('icons/obj/projectiles.dmi', "gumball")
	orb.color = "#a0a0a0"
	add_overlay(orb)
	QDEL_IN(src, lifetime)

/obj/item/flashlight/flare/light/Initialize(mapload)
	. = ..()
	soundloop = new(list(src), FALSE)
	on = TRUE
	START_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/light/update_brightness(mob/user = null)
	..()
	item_state = "[initial(item_state)]"

/obj/item/flashlight/flare/light/process()
	item_state = "[initial(item_state)]"
	on = TRUE
	update_brightness()
	open_flame(heat)
	if(!fuel || !on)
		//turn_off()
		STOP_PROCESSING(SSobj, src)
		if(!fuel)
			item_state = "[initial(item_state)]"
		return
	if(!istype(loc, /obj/machinery/light/rogue/torchholder))
		if(!ismob(loc))
			if(prob(23))
				//turn_off()
				STOP_PROCESSING(SSobj, src)
				return

/obj/item/flashlight/flare/light/turn_off()
	playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
	soundloop.stop()
	STOP_PROCESSING(SSobj, src)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()
		M.update_inv_belt()
	damtype = BRUTE
	qdel(src)

/obj/item/flashlight/flare/light/update_brightness(mob/user = null)
	..()
	if(on)
		item_state = "[initial(item_state)]"
	else
		item_state = "[initial(item_state)]"
