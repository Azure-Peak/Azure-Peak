/datum/action/cooldown/spell/conjure_summon/attacker
	name = "Summon Rogue"
	desc = "Call forth a swift, lightly-armored rogue. Toggle its loadout with Shift+G: Twin Sabres, Twin Rapiers, Twin Axes, Twin Daggers, Twin Hammers, or Twin Whips.  \
	Its prowess scales with your Arcyne Armament."
	button_icon_state = "primetriangle"
	invocations = list("Exsurge, sicarius!")
	summon_noun = "rogue"
	recoil_energy_floor = 200
	modes = list(
		list("name" = "Twin Sabres", "tag" = "SAB", "loadout" = "sabre", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, sicarius!"),
		list("name" = "Twin Rapiers", "tag" = "RAP", "loadout" = "rapier", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, sicarius!"),
		list("name" = "Twin Axes", "tag" = "AXE", "loadout" = "axe", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, sicarius!"),
		list("name" = "Twin Daggers", "tag" = "DAG", "loadout" = "dagger", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, sicarius!"),
		list("name" = "Twin Hammers", "tag" = "HAM", "loadout" = "hammer", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, sicarius!"),
		list("name" = "Twin Whips", "tag" = "WHP", "loadout" = "whip", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, sicarius!"),
	)

/datum/action/cooldown/spell/conjure_summon/attacker/spawn_summon(turf/T, mob/living/user)
	var/mob/living/carbon/human/species/human/northern/conjured_attacker/duelist = new(T)
	duelist.loadout = modes[current_mode]["loadout"]
	duelist.arcane_scale = clamp(user.get_skill_level(/datum/skill/combat/arcyne), 1, 6)
	duelist.gear_tier = get_summon_tier(user)
	duelist.summoner_ref = WEAKREF(user)
	return duelist
