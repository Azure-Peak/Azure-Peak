// Spell Implement System
// Staves and Wands are spell implements that grant Residual Focus when held while casting.
// The buff captures the spell's resource cost and returns a tier-dependent fraction as energy
// over 20 seconds. See residual_focus.dm and spell_cooldown.dm Activate() for the hook.
//
// Staff: Two-handed, best durability and parry. Melee defensive option.
// Wand: One-handed, shield-compatible. Lighter, less durable.
//
// Tiers:
//   Lesser  (Toper/Amethyst gems) - 20% refund, lowest durability
//   Greater (Emerald-Ruby gems)   - 25% refund, mid durability
//   Grand   (Riddle of Steel)     - 30% refund, highest durability
//
// Attunement glow: After a spell with an attunement_school is cast through the implement,
// it takes on the spell's color as a subtle glow. Changes if a different element is cast.
// Higher tiers glow more intensely. Visual update is throttled to once per minute.

#define IMPLEMENT_GLOW_FILTER "implement_attunement"
#define IMPLEMENT_ATTUNE_COOLDOWN 1 MINUTES

/obj/item/rogueweapon
	var/attuned_color = null
	var/base_implement_name = null
	var/implement_tier = 0
	/// Fraction (0..1) of a spell's resource cost returned by the arcyne refund buff when this item is held.
	var/implement_refund = 0
	COOLDOWN_DECLARE(attunement_cd)

/obj/item/rogueweapon/proc/attune_implement(spell_color, spell_name)
	if(!implement_tier)
		return
	apply_attunement_glow(src, spell_color, implement_tier, spell_name)

/proc/apply_attunement_glow(obj/item/rogueweapon/implement, spell_color, implement_tier, spell_name)
	if(implement.attuned_color == spell_color)
		return
	if(!COOLDOWN_FINISHED(implement, attunement_cd))
		return
	COOLDOWN_START(implement, attunement_cd, IMPLEMENT_ATTUNE_COOLDOWN)
	implement.attuned_color = spell_color
	if(spell_name && implement.base_implement_name)
		implement.name = "[implement.base_implement_name] of [spell_name]"
	var/glow_alpha
	switch(implement_tier)
		if(IMPLEMENT_TIER_LESSER)
			glow_alpha = 80
		if(IMPLEMENT_TIER_GREATER)
			glow_alpha = 120
		if(IMPLEMENT_TIER_GRAND)
			glow_alpha = 155
		else
			glow_alpha = 80
	implement.remove_filter(IMPLEMENT_GLOW_FILTER)
	implement.add_filter(IMPLEMENT_GLOW_FILTER, 2, list("type" = "outline", "color" = spell_color, "alpha" = glow_alpha, "size" = 1))

/// Prompts the user to choose between a wand or staff implement of the given tier.
/// Returns the chosen implement type path, or staff by default.
/// If Wand is chosen, additionally puts a wooden shield in H's hands and grants
/// Apprentice-level Shields skill so the wand+shield loadout is actually usable.
/proc/choose_implement(mob/living/carbon/human/H, tier = "lesser")
	var/choice = tgui_input_list(H, "Choose your implement.", "IMPLEMENT", list("Staff", "Wand & Shield"))
	if(!choice)
		choice = "Staff"
	var/implement_path
	switch(tier)
		if("lesser")
			implement_path = choice == "Wand & Shield" ? /obj/item/rogueweapon/wand : /obj/item/rogueweapon/woodstaff/implement
		if("greater")
			implement_path = choice == "Wand & Shield" ? /obj/item/rogueweapon/wand/greater : /obj/item/rogueweapon/woodstaff/implement/greater
		if("grand")
			implement_path = choice == "Wand & Shield" ? /obj/item/rogueweapon/wand/grand : /obj/item/rogueweapon/woodstaff/implement/grand
		else
			implement_path = /obj/item/rogueweapon/woodstaff/implement

	if(choice == "Wand & Shield" && H)
		H.put_in_hands(new implement_path(H))
		H.put_in_hands(new /obj/item/rogueweapon/shield/wood(H))
		H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_APPRENTICE, TRUE)
		return null

	return implement_path
