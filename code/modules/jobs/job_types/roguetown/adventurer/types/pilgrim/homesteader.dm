/datum/advclass/homesteader
	name = "Homesteader"
	tutorial = "Azure population's tendency to take up arms and become unwashed beastslayers had forced you to take up jobs, small and large of most professions.\n A jack of all trades, what will you be known as this week?"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED)
	
	outfit = /datum/outfit/job/roguetown/homesteader
	traits_applied = list(TRAIT_JACKOFALLTRADES,
		TRAIT_ALCHEMY_EXPERT,
		TRAIT_SMITHING_EXPERT,
		TRAIT_SEWING_EXPERT,
		TRAIT_SURVIVAL_EXPERT,
		TRAIT_HOMESTEAD_EXPERT, // No medicine but they get the full package
		// No hunting, as it's a specialty skill.
	)
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	adaptive_name = TRUE
	subclass_stats = list(
		STATKEY_INT = 3,	//This guy's here to grind = baby.
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,

		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/ceramics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,

		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/smelting = SKILL_LEVEL_NOVICE,

		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_NOVICE
	)
	maximum_possible_slots = 20 // Should not fill, just a hack to make it shows what types of towners are in round
	var/list/custom_title_options = list(
		"Artisan",
		"Artisana",
		"Craftswoman",
		"Devotee",
		"Devotess",
		"Fieldworker",
		"Forager",
		"Freeholder",
		"Gardener",
		"Handiworker",
		"Hedgefolk",
		"Herbalist",
		"Homesteadress",
		"Housekeeper",
		"Householder",
		"Househusband",
		"Housewife",
		"Hunter",
		"Laborer",
		"Nurse",
		"Nun",
		"Pioneer",
		"Prospector",
		"Scholar",
		"Settler",
		"Shepherd",
		"Varlet",
		"Villager",
		"Weaver",
		"Woodsman",
		"Woodswoman",
		"Chirurgeon"
	)

/datum/outfit/job/roguetown/homesteader/pre_equip(mob/living/carbon/human/H)
	..()
	head = pick(/obj/item/clothing/head/roguetown/hatfur,
	/obj/item/clothing/head/roguetown/hatblu,
	/obj/item/clothing/head/roguetown/nightman,
	/obj/item/clothing/head/roguetown/roguehood,
	/obj/item/clothing/head/roguetown/roguehood/random,
	/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood,
	/obj/item/clothing/head/roguetown/fancyhat)

	if(prob(50))
		mask = /obj/item/clothing/mask/rogue/spectacles

	cloak = pick(/obj/item/clothing/cloak/raincloak/furcloak,
	/obj/item/clothing/cloak/half)

	armor = pick(/obj/item/clothing/suit/roguetown/armor/workervest,
	/obj/item/clothing/suit/roguetown/armor/leather/vest)

	pants = pick(/obj/item/clothing/under/roguetown/trou,
	/obj/item/clothing/under/roguetown/tights/random)

	shirt = pick(/obj/item/clothing/suit/roguetown/shirt/undershirt/random,
	/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan,
	/obj/item/clothing/suit/roguetown/armor/gambeson/light)

	shoes = pick(/obj/item/clothing/shoes/roguetown/boots/leather,
	/obj/item/clothing/shoes/roguetown/shortboots)

	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/dye_brush = 1,
						/obj/item/recipe_book/builder = 1,
						/obj/item/recipe_book/survival = 1,
						/obj/item/reagent_containers/powder/salt = 3,
						/obj/item/reagent_containers/food/snacks/rogue/cheddar = 2,
						/obj/item/natural/cloth = 2,
						/obj/item/book/rogue/yeoldecookingmanual = 1,
						/obj/item/natural/worms = 2,
						/obj/item/rogueweapon/shovel/small = 1,
						/obj/item/hair_dye_cream = 3,
						/obj/item/rogueweapon/chisel = 1,
						/obj/item/natural/clay = 3,
						/obj/item/natural/glassbatch = 1,
						/obj/item/rogueore/coal = 1,
						/obj/item/roguegear = 1,
	)
	if(H.mind)
		H.mind.special_items["Hammer"] = /obj/item/rogueweapon/hammer/steel
		H.mind.special_items["Sheathe"] = /obj/item/rogueweapon/scabbard/sheath
		H.mind.special_items["Hunting Knife"] = /obj/item/rogueweapon/huntingknife
		H.mind.special_items["Woodcutter's Axe"] = /obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter
		H.mind.special_items["[pick("Good", "Bad", "Normal")] Day's Wine"] = /obj/item/reagent_containers/glass/bottle/rogue/wine
		H.mind.special_items["Barber's Innocuous Bag"] = /obj/item/storage/belt/rogue/surgery_bag/full
		H.mind.special_items["Trusty Pick"] = /obj/item/rogueweapon/pick
		H.mind.special_items["Hoe"] = /obj/item/rogueweapon/hoe
		H.mind.special_items["Tuneful Instrument"] = pick(subtypesof(/obj/item/rogue/instrument))
		H.mind.special_items["Fishing Rod"] = /obj/item/fishingrod/crafted
		H.mind.special_items["Pan for Frying"] = /obj/item/cooking/pan

		H.adaptive_name_title = "Homesteader"
		add_verb(H, /datum/advclass/homesteader/proc/choose_homesteader_title)

		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_LOWER_CLASS, H)

//==========

//=========
/datum/advclass/homesteader/proc/get_skill_title_options()
	var/list/skill_titles = list()
	for(var/title in custom_title_options)
		if(title && !(title in skill_titles))
			skill_titles += title
	for(var/skill_path in subclass_skills)
		if(ispath(skill_path, /datum/skill/combat))
			continue
		var/datum/skill/skill = skill_path
		var/title = initial(skill.expert_name)
		if(title && !(title in skill_titles))
			skill_titles += title
	return sortList(skill_titles)

/datum/advclass/homesteader/proc/choose_title(mob/living/carbon/human/H)
	if(!H?.client)
		return FALSE
	var/list/title_modes = list("Homesteader", "Single Skill Title", "Adaptive Skill Titles")
	var/default_mode = "Homesteader"
	if(!H.adaptive_name_title)
		default_mode = "Adaptive Skill Titles"
	else if(H.adaptive_name_title != name)
		default_mode = "Single Skill Title"

	var/title_mode = input(H, "How should I be known?", "Homesteader Title", default_mode) as null|anything in title_modes
	if(!title_mode)
		return FALSE
	switch(title_mode)
		if("Homesteader")
			H.adaptive_name_title = name
			H.advjob = name
		if("Single Skill Title")
			var/list/title_options = get_skill_title_options()
			if(!length(title_options))
				to_chat(H, span_warning("I do not have any titles to choose from."))
				return FALSE
			var/default_title = (H.adaptive_name_title && H.adaptive_name_title != name) ? H.adaptive_name_title : title_options[1]
			var/title_choice = input(H, "Which title should I use?", "Homesteader Title", default_title) as null|anything in title_options
			if(!title_choice)
				return FALSE
			H.adaptive_name_title = title_choice
			H.advjob = title_choice
		if("Adaptive Skill Titles")
			H.adaptive_name_title = null
			H.advjob = name
			H.update_adaptive_name()
	to_chat(H, span_notice("I will be known as [H.advjob]."))
	return TRUE

/datum/advclass/homesteader/proc/choose_homesteader_title()
	set name = "Choose Homesteader Title"
	set category = "IC"

	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(!istype(H.mind?.picked_advclass, /datum/advclass/homesteader))
		to_chat(H, span_warning("I am not a homesteader."))
		remove_verb(H, /datum/advclass/homesteader/proc/choose_homesteader_title)
		return
	if(world.time < H.next_homesteader_title_change)
		to_chat(H, span_warning("I must wait [round((H.next_homesteader_title_change - world.time)/600, 1)] minutes before changing my title again."))
		return
	var/datum/advclass/homesteader/homesteader_class = H.mind.picked_advclass
	if(homesteader_class.choose_title(H))
		H.next_homesteader_title_change = world.time + HOMESTEADER_TITLE_COOLDOWN
