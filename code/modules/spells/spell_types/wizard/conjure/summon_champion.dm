/datum/action/cooldown/spell/conjure_summon/champion
	name = "Summon Champion"
	desc = "Call forth a bound humanoid champion to fight at your side. Toggle its loadout with Shift+G while the spell is selected: Sword & Shield, Bow, Crossbow, Greatsword, Greataxe, Axe & Shield, or Spear. \
	Its arms and prowess scale with your skill at Arcyne Armament - Experts call forth steel-clad champions, and Masters call forth blacksteel juggernauts. \
	You can maintain only one at a time - recast at capacity to re-summon, or use Dismiss Conjuration to release it safely."
	button_icon_state = "primetriangle"
	invocations = list("Exsurge, miles!")
	summon_noun = "champion"
	recoil_energy_floor = 200
	modes = list(
		list("name" = "Sword & Shield", "tag" = "SWD", "loadout" = "swordsman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, miles!"),
		list("name" = "Bow", "tag" = "BOW", "loadout" = "archer", "color" = "#cfe8ff", "invocation" = "Exsurge, sagittarius!"),
		list("name" = "Crossbow", "tag" = "XBW", "loadout" = "xbowman", "color" = "#cfe8ff", "invocation" = "Exsurge, sagittarius!"),
		list("name" = "Greatsword", "tag" = "GSW", "loadout" = "greatswordman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, miles!"),
		list("name" = "Greataxe", "tag" = "GAX", "loadout" = "greataxeman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, miles!"),
		list("name" = "Axe & Shield", "tag" = "AXE", "loadout" = "axeman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, miles!"),
		list("name" = "Spear", "tag" = "SPR", "loadout" = "spearman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, hastati!"),
	)

/datum/action/cooldown/spell/conjure_summon/champion/spawn_summon(turf/T, mob/living/user)
	var/mob/living/carbon/human/species/human/northern/conjured_champion/champion = new(T)
	champion.loadout = modes[current_mode]["loadout"]
	champion.arcane_scale = clamp(user.get_skill_level(/datum/skill/combat/arcyne), 1, 6)
	champion.gear_tier = get_summon_tier(user)
	champion.summoner_ref = WEAKREF(user)
	return champion

/datum/action/cooldown/spell/conjure_summon/champion/goblin
	name = "Summon Goblin Champion"
	desc = "Call forth a phantasmal rendition of an unusually large goblin - a lumbering brute that smashes through doors and shrugs off blows. Toggle its loadout with Shift+G while the spell is selected: Mace & Shield, Greataxe, Flail & Shield. \
	Its brawn and gear scale with your skill at Arcyne Armament. Cruder and slower than a true champion,. \
	You can maintain only one at a time."
	invocations = list("Exsurge, gobelinus!")
	summon_noun = "goblin champion"
	point_cost = 5
	modes = list(
		list("name" = "Mace & Shield", "tag" = "MCE", "loadout" = "brute", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, gobelinus!"),
		list("name" = "Greataxe", "tag" = "GAX", "loadout" = "berserker", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, gobelinus!"),
		list("name" = "Flail & Shield", "tag" = "FLL", "loadout" = "flailman", "color" = GLOW_COLOR_ARCANE, "invocation" = "Exsurge, gobelinus!"),
	)

/datum/action/cooldown/spell/conjure_summon/champion/goblin/spawn_summon(turf/T, mob/living/user)
	var/mob/living/carbon/human/species/goblin/npc/conjured/champion/gob = new(T)
	gob.loadout = modes[current_mode]["loadout"]
	gob.arcane_scale = clamp(user.get_skill_level(/datum/skill/combat/arcyne), 1, 6)
	gob.gear_tier = get_summon_tier(user)
	gob.summoner_ref = WEAKREF(user)
	return gob
