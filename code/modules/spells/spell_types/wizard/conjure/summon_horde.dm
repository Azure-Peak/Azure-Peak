/datum/action/cooldown/spell/conjure_summon/hordes
	name = "Summon Horde"
	desc = "Call forth a pack of three phantasmal goblins to swarm your foes. Toggle their loadout with Shift+G: Raiders, Shieldwall, Slingers, Bowmen, Spears, or Flails. Each one killed gives a partial recoil, but nowhere as much as a champion. Recast to reinforce the pack up to three, or replace it once full."
	button_icon_state = "primetriangle"
	invocations = list("Exsurgite, cohors!")
	summon_noun = "goblin"
	max_summons = 3
	summons_per_cast = 3
	recoil_energy_floor = 700
	recoil_severity = CONJURE_RECOIL_PARTIAL
	modes = list(
		list("name" = "Raiders", "tag" = "RAI", "loadout" = "raider", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurgite, cohors!"),
		list("name" = "Shieldwall", "tag" = "SHW", "loadout" = "shieldwall", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurgite, cohors!"),
		list("name" = "Slingers", "tag" = "SLG", "loadout" = "sling", "color" = "#cfe8ff", "invocation" = "Exsurgite, cohors!"),
		list("name" = "Bowmen", "tag" = "BOW", "loadout" = "bow", "color" = "#cfe8ff", "invocation" = "Exsurgite, cohors!"),
		list("name" = "Spears", "tag" = "SPR", "loadout" = "spear", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurgite, cohors!"),
		list("name" = "Flails", "tag" = "FLL", "loadout" = "flail", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurgite, cohors!"),
	)

/datum/action/cooldown/spell/conjure_summon/hordes/spawn_summon(turf/T, mob/living/user)
	var/turf/dest = T
	var/list/open = list()
	for(var/turf/open/candidate in range(1, T))
		if(!candidate.is_blocked_turf())
			open += candidate
	if(length(open))
		dest = pick(open)
	var/mob/living/carbon/human/species/goblin/npc/conjured/goblin = new(dest)
	goblin.summoner_ref = WEAKREF(user)
	goblin.arcane_scale = clamp(user.get_skill_level(/datum/skill/combat/arcyne), 1, 6)
	goblin.gear_tier = get_summon_tier(user)
	goblin.loadout = modes[current_mode]["loadout"]
	return goblin

/datum/action/cooldown/spell/conjure_summon/peasant_swarm
	name = "Conjure Levy"
	desc = "Call forth a levy of three bound peasants, armed with the improvised tools of the field. Toggle their arms with Shift+G: Maciejowski, Bogbark Club, Militia Spear, Militia Scythe, Militia Flail, or Militia War Axe. Each one killed gives a partial recoil."
	button_icon_state = "primetriangle"
	invocations = list("Exsurgite, plebs!")
	summon_noun = "levyman"
	max_summons = 3
	summons_per_cast = 3
	recoil_energy_floor = 700
	recoil_severity = CONJURE_RECOIL_PARTIAL
	modes = list(
		list("name" = "Maciejowski", "tag" = "MAC", "loadout" = "maciejowski", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurgite, plebs!"),
		list("name" = "Bogbark Club", "tag" = "CLB", "loadout" = "club", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurgite, plebs!"),
		list("name" = "Militia Spear", "tag" = "SPR", "loadout" = "pitchfork", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurgite, plebs!"),
		list("name" = "Militia Scythe", "tag" = "SCY", "loadout" = "scythe", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurgite, plebs!"),
		list("name" = "Militia Flail", "tag" = "FLA", "loadout" = "thresher", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurgite, plebs!"),
		list("name" = "Militia War Axe", "tag" = "AXE", "loadout" = "woodcutter", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurgite, plebs!"),
	)

/datum/action/cooldown/spell/conjure_summon/peasant_swarm/spawn_summon(turf/T, mob/living/user)
	var/turf/dest = T
	var/list/open = list()
	for(var/turf/open/candidate in range(1, T))
		if(!candidate.is_blocked_turf())
			open += candidate
	if(length(open))
		dest = pick(open)
	var/mob/living/carbon/human/species/human/northern/conjured_peasant/peasant = new(dest)
	peasant.summoner_ref = WEAKREF(user)
	peasant.arcane_scale = clamp(user.get_skill_level(/datum/skill/combat/arcyne), 1, 6)
	peasant.gear_tier = get_summon_tier(user)
	peasant.loadout = modes[current_mode]["loadout"]
	return peasant
