/obj/item/clothing/gloves/roguetown
	slot_flags = ITEM_SLOT_GLOVES
	body_parts_covered = HANDS
	body_parts_inherent = HANDS
	sleeved = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon = 'icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'
	bloody_icon_state = "bloodyhands"
	sleevetype = "shirt"
	max_heat_protection_temperature = 361
	experimental_inhand = TRUE
	/// Flat unarmed damage bonus (for pure fists / wrestling only)
	var/unarmed_bonus = 0
	/// If TRUE, this glove counts as the "weapon" for the purposes of on-hit item effects (silver ignition, magic_item enchantments) when used to throw an unarmed strike. Reserved for knuckledusters/wraps meant to fight barehanded, not everyday gloves.
	var/unarmed_weapon_effects = FALSE

/obj/item/clothing/gloves/roguetown/get_mechanics_examine(mob/user)
	. = ..()
	if(unarmed_bonus > 0)
		. += span_notice("Unarmed damage bonus: +[unarmed_bonus] (flat, applied after strength scaling).")

/**
 * Lets a worn glove act as the "weapon" for on-hit item effects (silver ignition, magic_item enchantments)
 * when it lands an unarmed strike, instead of only when wielded as a dedicated melee weapon.
 * Called from the unarmed attack resolution after damage is confirmed to land.
 */
/obj/item/clothing/gloves/roguetown/proc/apply_unarmed_weapon_effects(mob/living/user, obj/item/bodypart/affecting, datum/intent/intent, mob/living/victim, selzone)
	if(!unarmed_weapon_effects)
		return
	do_special_attack_effect(user, affecting, intent, victim, selzone)
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, victim, user, TRUE, null)
