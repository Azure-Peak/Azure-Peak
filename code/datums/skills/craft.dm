/datum/skill/craft
	abstract_type = /datum/skill/craft
	name = "Craft"
	desc = ""
	color = "#4e7bb1"

/datum/skill/craft/crafting
	name = "Crafting"
	desc = "Determines whether you can craft various items not under any other crafting skills."
	dreams = list(
		"...you feel grass under your feet as you peer onto a meadow, you prepare a campfire and a tent and drift off into deep slumber...",
		"...you dig through the mud for worms with a spade you made from wood and stone gathered by the lakeside. Your fishing rod stands eager to bring you a meal, just like your grandfather taught you..."
	)
	expert_name = "Crafter"

/datum/skill/craft/weaponsmithing
	name = "Weaponsmithing"
	desc = "Determins whether you can smith various weapons. Required to repair weapons successfully on tables."
	dreams = list(
		"...tempered in gold and void, sharpened only by the sun and moon, your creation is finally complete. This one... This one will pierce the heavens...",
		"...sweat drips down your brow and your arms ache with every strike, but at last, the blade is forged. A masterpiece of steel and gold, adorned with rontz gems...",
		"...an old hunter stands in front of your counter and demands two dozen arrows. He hands you a bundle of sticks with a smile on his face..."
	)
	expert_name = "Weaponsmith"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY, TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/armorsmithing
	name = "Armorsmithing"
	desc = "Determines whether you can smith various armor. Required to repair armor successfully on tables."
	dreams = list(
		"...you stand amidst the deadite horde, their tooth and claw unable to dent your armor. Your creation. Your masterpiece...",
		"...the veteran's armor, battered beyond recognition, mirrors the scars upon his body. Yet, without your craft, he'd have fallen long ago. With skilled hands and a half a day's work, the armor is reborn - stronger than the day it was forged..."
	)
	expert_name = "Armorsmith"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY, TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/blacksmithing
	name = "Blacksmithing"
	desc = "Determines whether you can smith various non-weapons and armor items. Required to repair them successfully on table."
	dreams = list(
		"...you bow your head to the old master who scolds you for your wastefulness having left the forges unattended through the night...",
		"...you hammer away at a strange blue metal. It tempts you, begging to be formed into a crown of secrets...",
		"...the furnaces are lit and the forges roar. Today is a good day, and the lord of flame has blessed your smithy, the greatest in all the lands..."
	)
	expert_name = "Blacksmith"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY, TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/smelting
	name = "Smelting"
	desc = "Increases the quality of the ingots you smelt. Improves their sell price, but has no effect on the actual functionality of the items created."
	dream_cost_base = 1
	dreams = list(
		"...the slag falls away in glittering shards, leaving a bar of shining silver. It gleams with purpose, ready to be shaped...",
		"...you toil endlessly under the heat of the furnace; its fire roars with each sacrifice you offer, gifting you malleable metal in return..."

	)
	expert_name = "Smelter"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY, TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)


/datum/skill/craft/carpentry
	name = "Carpentry"
	desc = "Determines whether you can craft various wooden items, structures and repair them, including wooden limbs."
	dreams = list(
		"...with a precise stroke, you bring down the hammer, nailing another peg into place. Your art turns mere wood into shelter and comfort...",
		"...with every beam you set, the house takes shape. The smell of fresh wood and sawdust fills the air as walls rise, and the roof begins to form. A shelter born from your hands...",
		"...you take a seat and there is no noise. None at all. The nightmare of its horrid creak is dispelled, and your thoughts turn to its make..."
	)
	expert_name = "Carpenter"
	// Niche skill, no gating

/datum/skill/craft/masonry
	name = "Masonry"
	desc = "Determines whether you can craft various stone items, gems and repair them."
	dreams = list(
		"...a fortress. Impenetrable. Everlasting. Brick by brick. Layer by layer. Stone upon stone. This is your magnum opus. This is the way of creation...",
		"...'3, 4 and 5 lead to the corner of 90.' your master, a wizened old elf adrift in the void, shows you how their mason's square indicates straight and strange corners alike..."
	)
	expert_name = "Mason"
	// No longer niche with gemcarving etc
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/traps
	name = "Trapmaking"
	desc = "Determines whether you can craft mantraps and if you can spot and disable traps."
	dreams = list(
		"...you spin a quiet silver wire across a hallway, lying in wait for your prey. The monstrous pale volf approaches. This time, you are prepared...",
		"...the gleam of the trap's sharp teeth catches the dim light as you conceal it beneath layers of brush and foliage. To the untrained eye, it's nothing more than a harmless patch of grass - but you know better..."
	)
	expert_name = "Trapper"

/datum/skill/craft/engineering
	name = "Engineering"
	desc = "Determines whether you can craft or repair various mechanical structures including lever, trapdoors, and bronze items such as bronze limbs, grappler etc."
	dreams = list(
		"...strange devices are familiar faces to you. The inner workings of your machines are of cogs. Cogs are their hearts, their mind and their will...",
		"...three levers lay before you. One will drop you into acid, another will release toxic gas but only one will free you. The moonlight shines on one of them, and you reach out...",
		"...with steady hands you shape a new limb, each joint and cog designed to restore what was lost. Your work is a quiet promise; they will walk again..."
	)
	expert_name = "Engineer"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY, TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)


/datum/skill/craft/cooking
	name = "Cooking"
	desc = "Increases cooking & ingredients preparation speed. -25% if none, 0% if Novice, +50% per level after. At Journeyman you can ferment crops in a barrel."
	dreams = list(
		"...over a crackling campfire, a slab of fresh meat sizzles as it cooks, its scent filling the air. The simplest meals are often the most difficult to perfect...",
		"...your knife bears down onto a wheel of cheese, and you cut away at the imperfections that lie on its skin. Next would be the eggs and the dough, and they'll roll together into a wonderful meal...",
		"...a one-eyed chef begins mashing apples in front of you before filling some pie dough. He can barely stop himself from salivating as he teaches you his secret ingredient..."
	)
	expert_name = "Cook"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY, 
	TRAIT_SURVIVAL_EXPERT = SKILL_LEVEL_LEGENDARY, 
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/sewing
	name = "Sewing"
	desc = "Determines whether you can craft various sewing-related items and repair them."
	dreams = list(
		"...as the years go by, the mantra becomes increasingly oppressive. Stitch, sew, cut ties, stitch, sew, thread the needle twice...",
		"...you turn over the fabric, and within the two layers of the gown, you hide a secret stitched into the gown, your initials, hidden within. A forbidden mark in some cultures... you never liked the bride much..."
	)
	expert_name = "Sewer"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SEWING_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SURVIVAL_EXPERT = SKILL_LEVEL_JOURNEYMAN,
	TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_JOURNEYMAN, 
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/tanning
	name = "Skincrafting"
	desc = "Determines whether you can craft or repair various leather items. Reduces the work time on the tanning rack and improves minimum yield per hide by 1 per skill level. Also increases chance of getting an essence of wilderness from tanning hide."
	dreams = list(
		"...your knife scrapes away at skin, flesh and fat, cleaning up the piece of hide so that it may be made into a wonderful cloak for the lord...",
		"...the hunter, their voice as rough as bark and their skin weathered like grain lets out a hearty laugh as he shows you his stitching..."
	)
	expert_name = "Tanner"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SEWING_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SURVIVAL_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_JOURNEYMAN,  
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/ceramics
	name = "Pottery"
	desc = "Handles crafting and making of clay into vases and other fine-craft works."
	dreams = list(
		"...the wheel spins, and spins.. yet you watch as a work of art grows from its center...",
		"...a slab of clay is molded into a beautiful statue. A testiment to Malum's blessings, and Xylix's insperation. A pure work of beauty..."
	)
	expert_name = "Potter"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)
	
/datum/skill/craft/alchemy
	name = "Alchemy"
	desc = "Determines what kind of potions you can brew and the types of transmutation and alchemy recipes you have access to"
	dreams = list(
		"...the smell of sulfur singes your nostrils... you taste iron... the smoke clears as you stare down at the reflection in your cauldron... the Queen stares back at you... she looks like she's crying..."
	)
	expert_name = "Alchemist"
	max_untraited_level = SKILL_LEVEL_JOURNEYMAN // Special, we just gate the best potions away
	trait_uncap = list(TRAIT_ALCHEMY_EXPERT = SKILL_LEVEL_LEGENDARY)

/datum/skill/craft/alchemy/skill_level_effect(level, datum/mind/mind)
	if(level > SKILL_LEVEL_MASTER)
		ADD_TRAIT(mind?.current, TRAIT_LEGENDARY_ALCHEMIST, type)
		//SEND_GLOBAL_SIGNAL(COMSIG_ATOM_ADD_TRAIT, (mind?.current, TRAIT_LEGENDARY_ALCHEMIST)
	else if(HAS_TRAIT(mind?.current, TRAIT_LEGENDARY_ALCHEMIST))
		REMOVE_TRAIT(mind?.current, TRAIT_LEGENDARY_ALCHEMIST, type)
		//SEND_GLOBAL_SIGNAL(COMSIG_ATOM_ADD_TRAIT, (mind?.current, TRAIT_LEGENDARY_ALCHEMIST)
