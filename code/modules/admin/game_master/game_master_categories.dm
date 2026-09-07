GLOBAL_LIST_INIT(gm_category_rules, list(
	/mob/living/carbon/human/species/goblin = FACTION_ORCS,
	/mob/living/carbon/human/species/hobgoblin = FACTION_ORCS,
	/mob/living/carbon/human/species/orc = FACTION_ORCS,

	/mob/living/carbon/human/species/skeleton = FACTION_UNDEAD,
	/mob/living/carbon/human/species/dwarfskeleton = FACTION_DUNDEAD,
	/mob/living/simple_animal/hostile/retaliate/rogue/revenant = FACTION_UNDEAD,
	/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = FACTION_UNDEAD,
	/mob/living/simple_animal/hostile/retaliate/rogue/headless = FACTION_UNDEAD,
	/mob/living/simple_animal/hostile/retaliate/rogue/white_stag_corpse = FACTION_UNDEAD,
	/mob/living/simple_animal/hostile/retaliate/rogue/terrorhog_corpse = FACTION_UNDEAD,
	/mob/living/simple_animal/hostile/rogue/haunt = FACTION_UNDEAD,
	/mob/living/simple_animal/hostile/retaliate/ghost = FACTION_UNDEAD,
	/mob/living/simple_animal/hostile/rogue/spirit_vengeance = FACTION_UNDEAD,

	/mob/living/carbon/human/species/human/northern/highwayman = FACTION_BANDITS,
	/mob/living/carbon/human/species/human/northern/bog_deserters = FACTION_BANDITS,
	/mob/living/carbon/human/species/human/northern/outlaw_tank = FACTION_BANDITS,
	/mob/living/carbon/human/species/human/northern/outlaw_ranger = FACTION_BANDITS,
	/mob/living/carbon/human/species/human/northern/outlaw_duelist = FACTION_BANDITS,
	/mob/living/carbon/human/species/human/northern/thief = FACTION_THIEVES,
	/mob/living/carbon/human/species/human/northern/bum = FACTION_BUMS,
	/mob/living/carbon/human/species/human/northern/border_reiver = FACTION_REIVER,
	/mob/living/simple_animal/hostile/rogue/border_reiver_lance_rider = FACTION_REIVER,
	/mob/living/simple_animal/hostile/rogue/border_reiver_crossbow = FACTION_REIVER,
	/mob/living/carbon/human/species/human/northern/searaider = FACTION_GRONNMEN,
	/mob/living/carbon/human/species/human/northern/militia = FACTION_STATION,

	/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter = FACTION_MADMEN,
	/mob/living/carbon/human/species/human/northern/deranged_knight = FACTION_MADMEN,
	/mob/living/carbon/human/species/human/northern/heretical_fiend_no_gear = FACTION_HERETICAL_FIEND,

	/mob/living/carbon/human/species/elf/dark/drowraider = FACTION_DROW,
	/mob/living/simple_animal/hostile/retaliate/rogue/drider = FACTION_DROW,
	/mob/living/carbon/human/species/lizardfolk = FACTION_LIZARDS,
	/mob/living/simple_animal/hostile/rogue/zardman_jailer_mage = FACTION_LIZARDS,

	/mob/living/simple_animal/hostile/retaliate/rogue/infernal = FACTION_INFERNAL,
	/mob/living/simple_animal/hostile/retaliate/rogue/fae = FACTION_FAE,
	/mob/living/simple_animal/hostile/retaliate/rogue/elemental = FACTION_ELEMENTAL,
	/mob/living/simple_animal/hostile/retaliate/rogue/primordial = FACTION_PRIMORDIAL,
	/mob/living/simple_animal/hostile/rogue/dreamfiend = FACTION_DREAM,
	/mob/living/simple_animal/hostile/rogue/deepone = FACTION_DEEPONE,
	/mob/living/simple_animal/hostile/retaliate/rogue/troll = FACTION_TROLLS,
	/mob/living/simple_animal/hostile/retaliate/rogue/mimic = FACTION_MIMIC,

	/mob/living/simple_animal/hostile/rogue/mirespider_lurker = FACTION_SPIDERS,
	/mob/living/simple_animal/hostile/rogue/mirespider_paralytic = FACTION_SPIDERS,
	/mob/living/simple_animal/hostile/retaliate/rogue/mirespider = FACTION_SPIDERS,
	/mob/living/simple_animal/hostile/retaliate/rogue/spider = FACTION_SPIDERS,

	/mob/living/simple_animal/hostile/retaliate/rogue/saiga = FACTION_SAIGA,
	/mob/living/simple_animal/hostile/retaliate/rogue/boar = FACTION_BOARS,
	/mob/living/simple_animal/hostile/retaliate/rogue/swine = FACTION_BOARS,
	/mob/living/simple_animal/hostile/retaliate/rogue/wolf = FACTION_WOLFS,
	/mob/living/simple_animal/hostile/retaliate/rogue/direbear = FACTION_BEARS,
	/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab = FACTION_CRABS,
	/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = FACTION_RATS,
	/mob/living/simple_animal/hostile/retaliate/smallrat = FACTION_RATS,
	/mob/living/simple_animal/mouse = FACTION_RATS,
	/mob/living/simple_animal/hostile/retaliate/rogue/mole = FACTION_MOLES,
	/mob/living/simple_animal/hostile/retaliate/goat = FACTION_GOATS,
	/mob/living/simple_animal/hostile/retaliate/rogue/goatmale = FACTION_GOATS,
	/mob/living/simple_animal/cow = FACTION_COWS,
	/mob/living/simple_animal/chicken = FACTION_CHICKENS,
	/mob/living/simple_animal/chick = FACTION_CHICKENS,
	/mob/living/simple_animal/hostile/lizard = FACTION_LIZARDS,
	/mob/living/simple_animal/pet = FACTION_NEUTRAL,

	/mob/living/simple_animal/hostile/retaliate/rogue/fox = FACTION_ROGUEANIMAL,
	/mob/living/simple_animal/hostile/retaliate/rogue/badger = FACTION_ROGUEANIMAL,
	/mob/living/simple_animal/hostile/retaliate/rogue/bobcat = FACTION_ROGUEANIMAL,
	/mob/living/simple_animal/hostile/retaliate/rogue/cat = FACTION_ROGUEANIMAL,
	/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = FACTION_ROGUEANIMAL,
	/mob/living/simple_animal/hostile/retaliate/rogue/mossback = FACTION_ROGUEANIMAL,
	/mob/living/simple_animal/hostile/retaliate/rogue/bull = FACTION_ROGUEANIMAL,
	/mob/living/simple_animal/hostile/retaliate/bat = FACTION_ROGUEANIMAL,
	/mob/living/simple_animal/hostile/retaliate/goose = FACTION_ROGUEANIMAL,
	/mob/living/simple_animal/hostile/retaliate/frog = FACTION_ROGUEANIMAL,
	/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = FACTION_ROGUEANIMAL,

	/mob/living/simple_animal/hostile/retaliate/rogue/werewolf_npc = FACTION_LEYLINE,
	/mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan = FACTION_LEYLINE,
	/mob/living/simple_animal/hostile/retaliate/rogue/hag_shapeshift = FACTION_HAG,
	/mob/living/carbon/human/species/wildshape = FACTION_HAG,

	/mob/living/carbon/human/species/human/northern/conjured_peasant = GM_CATEGORY_CONJURED,
	/mob/living/carbon/human/species/human/northern/conjured_champion = GM_CATEGORY_CONJURED,
	/mob/living/carbon/human/species/human/northern/conjured_attacker = GM_CATEGORY_CONJURED,
	/mob/living/carbon/human/species/dwarf/gnome/conjured_horde = GM_CATEGORY_CONJURED,
	/mob/living/simple_animal/flesh_decoy = GM_CATEGORY_CONJURED,

	/mob/living/simple_animal/hostile/retaliate/rogue/dragon = GM_CATEGORY_DRAGONS,
	/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon = GM_CATEGORY_DRAGONS,
	/mob/living/simple_animal/hostile/boss = GM_CATEGORY_BOSSES,
	/mob/living/simple_animal/hostile/retaliate/rogue/fogbeast = GM_CATEGORY_FOG,
))

/proc/gm_category_for_type(mob_type)
	var/best_category
	var/best_depth = 0
	for(var/rule_path in GLOB.gm_category_rules)
		if(!ispath(mob_type, rule_path))
			continue
		var/depth = length("[rule_path]")
		if(depth <= best_depth)
			continue
		best_depth = depth
		best_category = GLOB.gm_category_rules[rule_path]
	return best_category
