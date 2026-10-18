/datum/action/cooldown/spell/conjure_summon/undead/champion
	name = "Undead Champion"
	desc = "Toggle its loadout with Shift+G: Khopesh & Shield, Greatsword, Bardiche, Spear, Mace & Shield, or Grand Mace. You can maintain only one at a time."
	button_icon_state = "skeleton"
	invocations = list("Convoca spectres custodes!")
	summon_noun = "undead champion"
	undead_type = /mob/living/carbon/human/species/skeleton/conjured/undead/champion
	modes = list(
		list("name" = "Khopesh & Shield", "tag" = "KHP", "loadout" = /datum/outfit/job/roguetown/undead_champion/khopesh, "color" = GLOW_COLOR_ZIZO, "invocation" = "Convoca spectres custodes!"),
		list("name" = "Greatsword", "tag" = "GSW", "loadout" = /datum/outfit/job/roguetown/undead_champion/greatsword, "color" = GLOW_COLOR_ZIZO, "invocation" = "Convoca spectres custodes!"),
		list("name" = "Bardiche", "tag" = "BAR", "loadout" = /datum/outfit/job/roguetown/undead_champion/bardiche, "color" = GLOW_COLOR_ZIZO, "invocation" = "Convoca spectres custodes!"),
		list("name" = "Spear", "tag" = "SPR", "loadout" = /datum/outfit/job/roguetown/undead_champion/spear, "color" = GLOW_COLOR_ZIZO, "invocation" = "Convoca spectres custodes!"),
		list("name" = "Mace & Shield", "tag" = "MAC", "loadout" = /datum/outfit/job/roguetown/undead_champion/mace, "color" = GLOW_COLOR_ZIZO, "invocation" = "Convoca spectres custodes!"),
		list("name" = "Grand Mace", "tag" = "GMC", "loadout" = /datum/outfit/job/roguetown/undead_champion/grand_mace, "color" = GLOW_COLOR_ZIZO, "invocation" = "Convoca spectres custodes!"),
	)
