// Spell Implement System
// Staves and Tomes are spell implements that grant Residual Focus when held while casting.
// The buff captures the spell's resource cost and returns a tier-dependent fraction as energy
// over 20 seconds. See residual_focus.dm and spell_cooldown.dm Activate() for the hook.
//
// Staff: Two-handed, best durability and parry. Melee defensive option.
// Tome: One-handed, lighter, less durable. Rebinds aspect spells;
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

GLOBAL_LIST_INIT(implement_choices, list(
		"lesser" = list(
			"Toper Staff" = /obj/item/rogueweapon/woodstaff/implement,
			"Amythorz Staff" = /obj/item/rogueweapon/woodstaff/implement/amethyst
			),
		"greater" = list(
			"Gemerald Staff" = /obj/item/rogueweapon/woodstaff/implement/greater,
			"Rontz Staff" = /obj/item/rogueweapon/woodstaff/implement/greater/ruby,
			"Blortz Staff" = /obj/item/rogueweapon/woodstaff/implement/greater/quartz,
			"Saffira Staff" = /obj/item/rogueweapon/woodstaff/implement/greater/sapphire
			),
		"grand" = list(
			"Dorpel Staff" = /obj/item/rogueweapon/woodstaff/implement/grand,
			"Staff of the Riddlesteel" = /obj/item/rogueweapon/woodstaff/implement/grand/riddle
			)
		))

/// Prompts the user to choose between a tome or staff implement of the given tier.
/// Returns the chosen implement type path, or staff by default.
/proc/choose_implement(mob/living/carbon/human/H, tier = "lesser")
	if(!(tier in GLOB.implement_choices))
		return null
	var/choice = tgui_input_list(H, "Choose your implement.", "IMPLEMENT", GLOB.implement_choices[tier])
	if(!choice)
		switch(tier)
			if("lesser")
				choice = "Toper Staff"
			if("greater")
				choice = "Gemerald Staff"
			if("grand")
				choice = "Dorpel Staff"
			else
				choice = "Toper Staff"
	if(!(choice in GLOB.implement_choices[tier]))
		return null
	var/implement_path = GLOB.implement_choices[tier][choice]

	return implement_path
