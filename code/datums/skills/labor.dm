/datum/skill/labor
	abstract_type = /datum/skill/labor
	name = "Labor"
	desc = ""
	color = "#78c472"

/datum/skill/labor/farming
	name = "Farming"
	desc = "Allows you to identify seeds and increases workspeed and success chances on farming-related tasks."
	dreams = list(
		"...the smell of dung was once revolting but it now smells like opportunity. The soil is hungry, so you get your hands dirty...",
		"...you scrape and plow until your muscles ache. The day was long, and soon the apples you plucked today would be rolled into a delicious pie...",
		"...you kneel in the soil, watering the seeds you've sown. The rows stretch out before you, green and thriving. You are filled with satisfaction, knowing your labor will soon bloom into abundance..."
	)
	expert_name = "Farmer"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN, TRAIT_SELF_RELIANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/labor/mining
	name = "Mining"
	desc = "Increases mining speed."
	dreams = list(
		"...rock crumbles and the wall before you gives way, your pickaxe has become battered and broken from the long day. You've mined into a strangely well lit cavern...",
		"...the red, gleaming light seeps from the ancient stone, next to its guardian - a bearded hermit of short stature, who riddles you on the strongest of steels...",
		"...the dwarven master riddles you, 'The strongest metal is the goal; I am harvested from mountains to shoal, yet I am not a metal,' the ancient miner chokes on the ill-air of the underworld, before continuing...",
		"...the gemstone gleams in his grasp, as the old dwarf chokes out, 'I must be forged in fourths. What am I?'...",
		"...and then the answer to his riddle comes to you, as if it was there all along. A lump of coal. With a satisfied smile, the dwarf hands you the heart of the mountain..."
	)
	expert_name = "Miner"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN, TRAIT_SELF_RELIANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/labor/fishing
	name = "Fishing"
	desc = "Increases fishing speed down to a minimum of 2 seconds. Increases the chance of catching a fish. Novice is needed to not suffer a hefty penalty."
	dreams = list(
		"...you struggle to unknot the fishing line for what feels like hours, your clumsy digits pulling away at it while on a small boat in a chasmic void. A gigantic, calloused, pale hand takes it from you and untangles it immediately in its grasp...",
		"...the old merchant nods his head, and gives you a small sack of baits: worms, grubs and even slices of cheese - each said to bring you another of Abyssor's bounties..."
	)
	expert_name = "Fisher"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SURVIVAL_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN, TRAIT_SELF_RELIANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/labor/butchering
	name = "Butchering"
	desc = "Increases butchering speed. Increases yields from butchering a bodypart. If higher than your Skincrafting skill, will be used to determine the speed, yield and chance of getting an essence of wilderness when tanning hide."
	dreams = list(
		"...someone you recognize as a father twists the neck of the family rooster. He keeps you captivated as he guts it, speaking of gore and frugality...",
		"...your hands are bloodied and as you wipe them on your butcher's apron, a bell rings. A hooded customer enters your butcher's shop, and asks what meats you have for sale with a bemused look at your bloodied attire...",
		"...you pull the knife through fat, sinew and bone, the carcass giving way under your touch. The butcher's art is the transformation of life into sustenance...",
	)
	expert_name = "Butcher"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SEWING_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SURVIVAL_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN, TRAIT_SELF_RELIANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/labor/lumberjacking
	name = "Lumberjacking"
	desc = "Increases lumberjacking speed. At Novice or higher, guarantee at least two small log from a tree. Higher skills increases minimum yield and chance of getting an essence of wilderness."
	dreams = list(
		"...splinters fly off as a tree falls down on the ground, sending a thundering boom throughout the forest...",
		"...you pull on a saw, and the bearded lumberjack across from you pulls back on it. The great oak yawns as it threatens to topple over..."
	)
	expert_name = "Lumberjack"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN, TRAIT_SELF_RELIANCE = SKILL_LEVEL_JOURNEYMAN)
