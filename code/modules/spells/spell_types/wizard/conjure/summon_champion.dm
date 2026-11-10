/datum/action/cooldown/spell/conjure_summon/champion
	name = "Summon Champion"
	desc = "Call forth a bound humanoid champion to fight at your side. Toggle its loadout with Shift+G while the spell is selected: Sword & Shield, Bow, Crossbow, Greatsword, Greataxe, Axe & Shield, Flail & Shield, Great Flail, Spear, or Greatmace. \
	Its arms and prowess scale with your skill at Arcyne Armament - ordinary magi raise iron-clad soldiers, while Experts and Masters call forth steel-clad champions. \
	You can maintain only one at a time - recast at capacity to re-summon, or use Dismiss Conjuration to release it safely."
	button_icon_state = "primetriangle"
	invocations = list("Exsurge, miles!")
	summon_noun = "champion"
	modes = list(
		list("name" = "Sword & Shield", "tag" = "SWD", "loadout" = "swordsman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, miles!"),
		list("name" = "Bow", "tag" = "BOW", "loadout" = "archer", "color" = "#cfe8ff", "invocation" = "Exsurge, sagittarius!"),
		list("name" = "Crossbow", "tag" = "XBW", "loadout" = "xbowman", "color" = "#cfe8ff", "invocation" = "Exsurge, sagittarius!"),
		list("name" = "Greatsword", "tag" = "GSW", "loadout" = "greatswordman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, miles!"),
		list("name" = "Greataxe", "tag" = "GAX", "loadout" = "greataxeman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, miles!"),
		list("name" = "Axe & Shield", "tag" = "AXE", "loadout" = "axeman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, miles!"),
		list("name" = "Flail & Shield", "tag" = "FLL", "loadout" = "flailman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, miles!"),
		list("name" = "Great Flail", "tag" = "GFL", "loadout" = "greatflailman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, miles!"),
		list("name" = "Spear", "tag" = "SPR", "loadout" = "spearman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, hastati!"),
		list("name" = "Greatmace", "tag" = "GMC", "loadout" = "maceman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, miles!"),
	)

/datum/action/cooldown/spell/conjure_summon/champion/spawn_summon(turf/T, mob/living/user)
	var/mob/living/carbon/human/species/human/northern/conjured_champion/champion = new(T)
	champion.loadout = modes[current_mode]["loadout"]
	champion.arcane_scale = clamp(user.get_skill_level(/datum/skill/combat/arcyne), 1, 6)
	champion.gear_tier = get_summon_tier(user)
	champion.summoner_ref = WEAKREF(user)
	return champion

// Slightly stronger, Grenz flavored Champion summon
/datum/action/cooldown/spell/conjure_summon/champion/doppelsoldner
	name = "Conjure Doppel Soldner"
	desc = "One soldner worth the pae of two, for the pae of none. Toggle its arms with Shift+G: Zweihander, Kriegsmesser & Buckler, Halberd, Partizan, or Crossbow."
	invocations = list("Erhebe dich, Doppel Soldner!")
	summon_noun = "doppel soldner"
	modes = list(
		list("name" = "Zweihander", "tag" = "ZWE", "loadout" = "dopp_zweihander", "color" = GLOW_COLOR_ARCANE, "invocation" = "Erhebe dich, Doppel Soldner!"),
		list("name" = "Kriegsmesser & Buckler", "tag" = "KRM", "loadout" = "dopp_kriegsmesser", "color" = GLOW_COLOR_ARCANE, "invocation" = "Erhebe dich, Doppel Soldner!"),
		list("name" = "Halberd", "tag" = "HAL", "loadout" = "dopp_halberd", "color" = GLOW_COLOR_ARCANE, "invocation" = "Erhebe dich, Doppel Soldner!"),
		list("name" = "Partizan", "tag" = "PRT", "loadout" = "dopp_partizan", "color" = GLOW_COLOR_ARCANE, "invocation" = "Erhebe dich, Doppel Soldner!"),
		list("name" = "Crossbow", "tag" = "XBW", "loadout" = "dopp_xbow", "color" = "#cfe8ff", "invocation" = "Erhebe dich, Doppel Soldner!"),
	)
