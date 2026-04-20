// Spell Implement System
// Staves and Wands are spell implements that boost staple spell damage when held.
// implement_tier and implement_multiplier vars live on /obj/item/rogueweapon, defaulting to 0 (non-implement).
// The multiplier is applied in ready_projectile() for is_implement_scaled_spell spells.
//
// Staff: Two-handed, best durability and parry. Melee defensive option.
// Wand: One-handed, shield-compatible. Lighter, less durable.
//
// Tiers:
//   Lesser  (Toper/Amethyst gems) - 20% bonus, lowest durability
//   Greater (Emerald-Ruby gems)   - 22.5% bonus, mid durability
//   Grand   (Riddle of Steel)     - 25% bonus, highest durability
//
// Attunement glow: After the first implement-scaled spell is cast through the implement,
// it takes on the spell's color as a subtle glow. Changes if a different element is cast.
// Higher tiers glow more intensely. Visual update is throttled to once per minute.

#define IMPLEMENT_GLOW_FILTER "implement_attunement"
#define IMPLEMENT_ATTUNE_COOLDOWN 1 MINUTES

/obj/item/rogueweapon
	var/attuned_color = null
	var/base_implement_name = null
	var/implement_tier = 0
	var/implement_multiplier = 0
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
/proc/choose_implement(mob/living/carbon/human/H, tier = "lesser")
	var/choice = tgui_input_list(H, "Choose your implement.", "IMPLEMENT", list("Staff", "Wand"))
	if(!choice)
		choice = "Staff"
	switch(tier)
		if("lesser")
			return choice == "Wand" ? /obj/item/rogueweapon/wand : /obj/item/rogueweapon/woodstaff/implement
		if("greater")
			return choice == "Wand" ? /obj/item/rogueweapon/wand/greater : /obj/item/rogueweapon/woodstaff/implement/greater
		if("grand")
			return choice == "Wand" ? /obj/item/rogueweapon/wand/grand : /obj/item/rogueweapon/woodstaff/implement/grand
	return /obj/item/rogueweapon/woodstaff/implement
