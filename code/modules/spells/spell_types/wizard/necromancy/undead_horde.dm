/datum/action/cooldown/spell/conjure_summon/undead/horde
	name = "Undead Horde"
	desc = "Toggle their loadout with Shift+G: Khopesh & Shield, Greatsword, Bardiche, Spear, Mace & Shield, or Crossbow. Recast to reinforce the horde up to three, or replace it once full."
	button_icon_state = "skeleton_formation"
	invocations = list("Evoca skeletos!")
	summon_noun = "skeleton"
	max_summons = 3
	summons_per_cast = 3
	overload_power = 1/3
	undead_type = /mob/living/carbon/human/species/skeleton/conjured/undead/horde
	modes = list(
		list("name" = "Khopesh & Shield", "tag" = "KHP", "loadout" = /datum/outfit/job/roguetown/undead_horde/khopesh, "color" = GLOW_COLOR_ZIZO, "invocation" = "Evoca skeletos!"),
		list("name" = "Greatsword", "tag" = "GSW", "loadout" = /datum/outfit/job/roguetown/undead_horde/greatsword, "color" = GLOW_COLOR_ZIZO, "invocation" = "Evoca skeletos!"),
		list("name" = "Bardiche", "tag" = "BAR", "loadout" = /datum/outfit/job/roguetown/undead_horde/bardiche, "color" = GLOW_COLOR_ZIZO, "invocation" = "Evoca skeletos!"),
		list("name" = "Spear", "tag" = "SPR", "loadout" = /datum/outfit/job/roguetown/undead_horde/spear, "color" = GLOW_COLOR_ZIZO, "invocation" = "Evoca skeletos!"),
		list("name" = "Mace & Shield", "tag" = "MAC", "loadout" = /datum/outfit/job/roguetown/undead_horde/mace, "color" = GLOW_COLOR_ZIZO, "invocation" = "Evoca skeletos!"),
		list("name" = "Crossbow", "tag" = "XBW", "loadout" = /datum/outfit/job/roguetown/undead_horde/crossbow, "color" = "#cfe8ff", "invocation" = "Evoca skeletos!"),
	)
