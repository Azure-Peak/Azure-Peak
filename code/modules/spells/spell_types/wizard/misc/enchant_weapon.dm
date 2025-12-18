#define ENCHANT_DURATION 15 MINUTES
#define ENCHANT_DURATION_GOLD 200 MINUTES

/obj/effect/proc_holder/spell/invoked/enchant_weapon
	name = "Enchant Weapon"
	desc = "Enchant a weapon of your choice in your hand or on the ground, replacing any existing enchantment. \n\
	The enchantment will lasts for 15 minutes, and will automatically refresh in the hand of an Arcyne user.\n\
	If the enchanter is holding a piece of gold ore in their hand, it will be consumed to enchant the weapon permanently (200 minutes).\n\
	An enchantment cannot be applied to an already enchanted weapon.\n\
	Force Blade: Increases the force of the weapon by 5.\n\
	Durability: Increases the integrity and max integrity of the weapon by 100.\n\
	Arcane Mark: Applies <b>Arcane Mark</b> to struck targets. 12 second cooldown."
	overlay_state = "enchant_weapon"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 30
	chargedrain = 2
	chargetime = 3 SECONDS // Can be used mid combat if needed.
	no_early_release = TRUE
	recharge_time = 1 MINUTES

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	antimagic_allowed = FALSE

	charging_slowdown = 3
	cost = 2 // Slightly discounted as it is mostly buff.
	spell_tier = 2 // Spellblade tier.

	invocations = list("Incantare Arma!") // Enchant Weapon(s)
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW

/obj/effect/proc_holder/spell/invoked/enchant_weapon/cast(list/targets, mob/user = usr)
	var/target = targets[1]
	var/obj/item/sacrifice

	var/list/enchant_types = list(
		"Force Blade" = FORCE_BLADE_ENCHANT,
		"Durability" = DURABILITY_ENCHANT,
		"Arcane Mark" = ARCANE_MARK_ENCHANT
	)

	for(var/obj/item/I in user.held_items)
		if(istype(I, /obj/item/rogueore/gold))
			sacrifice = I

	if(istype(target, /obj/item/rogueweapon))
		var/obj/item/I = target
		var/enchant_type = input(user, "Select the type of enchantment you want to apply:", "Enchant Weapon") as anything in enchant_types
		if(!enchant_type)
			return
		enchant_type = enchant_types[enchant_type]
		var/enchant_duration = sacrifice ? ENCHANT_DURATION_GOLD : ENCHANT_DURATION
		if(sacrifice)
			qdel(sacrifice)
			to_chat(user, "I consumes the [sacrifice] to enchant [I] permanently.")
		if(I.GetComponent(/datum/component/enchanted_weapon))
			qdel(I.GetComponent(/datum/component/enchanted_weapon))
		I.AddComponent(/datum/component/enchanted_weapon, enchant_duration, TRUE, /datum/skill/magic/arcane, enchant_type)
		user.visible_message("[user] enchants the [I], enveloping it in a magical glow.")
		return TRUE
	else
		to_chat(user, span_warning("That is not a valid target for enchantment! You need to enchant a weapon."))
		revert_cast()
		return FALSE

#undef ENCHANT_DURATION
#undef ENCHANT_DURATION_GOLD
