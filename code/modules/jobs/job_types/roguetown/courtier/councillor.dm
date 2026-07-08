/datum/job/roguetown/councillor
	title = "Councillor"
	flag = COUNCILLOR
	department_flag = COUNCILLOR
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_ages = ALL_AGES_LIST
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)		//Nobility, so no constructs.
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_COUNCILLOR
	is_quest_giver = TRUE

	tutorial = "You may have inherited this position, bought your way into it, or were appointed to it by merit--perish the thought! Whatever the case though, you work as an assistant and agent of the crown in matters of state. Whether this be aiding the steward, the sheriff, or the crown itself, or simply enjoying the free food of the keep, your duties vary day by day. You may be the lowest rung of the ladder, but that rung still towers over everyone else in town."
	
	whitelist_req = FALSE
	outfit = /datum/outfit/job/roguetown/councillor
	advclass_cat_rolls = list(CTAG_COUNCILLOR = 2)

	give_bank_account = TRUE
	noble_income = 20
	min_pq = 1 //Probably a bad idea to have a complete newbie advising the monarch
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_noble.ogg'
	job_traits = list(TRAIT_NOBLE)
	vice_restrictions = list(/datum/charflaw/mute, /datum/charflaw/unintelligible, /datum/charflaw/wanted) //Needs to use the throat - sometimes
	job_subclasses = list(
		/datum/advclass/councillor/herald,
		/datum/advclass/councillor/huntmaster,
		/datum/advclass/councillor/cofferer,
		/datum/advclass/councillor/castellan,
		/datum/advclass/councillor/hexer,
		/datum/advclass/councillor/baron,
	)

/datum/advclass/councillor/herald
	name = "Herald"
	tutorial = "While lacking in some faculties, such as wealth and courtly advice, you have the uncanny ability to spread the word of the court, and rally people to your liege's cause. The crown saw it fit to employ you as a messenger, but may still lend an ear if you speak your mind. You may be the lowest rung of the ladder, but that rung still towers over everyone else in town."
	outfit = /datum/outfit/job/roguetown/councillor/herald
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled
	category_tags = list(CTAG_COUNCILLOR)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_STR = -1
	)

	// better movement skills
	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	)

/datum/advclass/councillor/cofferer
	name = "Cofferer"
	tutorial = "Whether born into wealth, or earned through working up from the bottom, you have quite the reserve of mammon at your disposal. Use your silver-tongue to acquire more, or buy more favour with the court. You may be the lowest rung of the ladder, but that rung still towers over everyone else in town."
	outfit = /datum/outfit/job/roguetown/councillor/cofferer
	category_tags = list(CTAG_COUNCILLOR)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	)

/datum/advclass/councillor/huntmaster
	name = "Huntmaster"
	tutorial = "Formerly a commoner, or perhaps you just like spending time in the woods too much. Organizing the hunt for their lordship is difficult, and you may not be as rich as your peers, but you'll make it work."
	outfit = /datum/outfit/job/roguetown/councillor/huntmaster
	category_tags = list(CTAG_COUNCILLOR)
	// Slightly worse than bow hunters
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 1,
		STATKEY_SPD = 1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		// One below spear hunters
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		// Too easy to get hurt hunting
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		// One below bow hunters
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		// One above hunters
		/datum/skill/misc/hunting = SKILL_LEVEL_MASTER,
	)

/datum/advclass/councillor/castellan
	name = "Castellan"
	tutorial = "Whilst not enjoying a position of leadership over the troops, you are in charge of overseeing the keep's defenses. You even know a thing or two about constructing siege weaponry, and defending against such devices."
	outfit = /datum/outfit/job/roguetown/councillor/castellan
	category_tags = list(CTAG_COUNCILLOR)
	// Mini Artificer
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/councillor
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/councillor/herald/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid // a mediocre pouch of coins
	shirt = /obj/item/clothing/suit/roguetown/shirt/fancyjacket
	pants = /obj/item/clothing/under/roguetown/trou/beltpants
	shoes = /obj/item/clothing/shoes/roguetown/boots
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/steward
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	cloak = /obj/item/clothing/cloak/half/red
	backpack_contents = list(
		/obj/item/storage/keyring = 1,
	)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_UPPER_MIDDLE_CLASS, H) // bumped from lower-middle so the lowest councillor rung still feels like nobility
	// give them the shitty see prices trait
	ADD_TRAIT(H, TRAIT_SEEPRICES_SHITTY, JOB_TRAIT)

/datum/outfit/job/roguetown/councillor/cofferer/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich // a fat pouch of coins
	shirt = /obj/item/clothing/suit/roguetown/shirt/fancyjacket
	pants = /obj/item/clothing/under/roguetown/trou/beltpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/gold
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/storage/keyring/steward
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	cloak = /obj/item/clothing/cloak/half/red
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_RICH, H) // wealth beyond measure
	// give them the good see prices trait
	ADD_TRAIT(H, TRAIT_SEEPRICES, JOB_TRAIT)

/datum/outfit/job/roguetown/councillor/huntmaster/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid // a mediocre pouch of coins
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light // Look, it would be silly to get mauled by a single wolf
	pants = /obj/item/clothing/under/roguetown/trou/beltpants
	shoes = /obj/item/clothing/shoes/roguetown/boots
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/steel
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/steward
	beltr = /obj/item/quiver/arrows
	cloak = /obj/item/clothing/cloak/half/red
	backpack_contents = list(
		/obj/item/hunting_map/white_stag = 1,
		/obj/item/hunting_map/boars = 1,
		/obj/item/storage/keyring = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
	)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_UPPER_MIDDLE_CLASS, H) // bumped from lower-middle to match councillor floor
	// give them the shitty see prices trait
	ADD_TRAIT(H, TRAIT_SEEPRICES_SHITTY, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_MASTERFUL_HUNTER, JOB_TRAIT)
	// Level up butchering
	ADD_TRAIT(H, TRAIT_SURVIVAL_EXPERT, JOB_TRAIT)

/datum/outfit/job/roguetown/councillor/castellan/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light // Technically an important figure
	pants = /obj/item/clothing/under/roguetown/trou/beltpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	// Less money of their own, but does need funds to oversee defenses
	beltl = /obj/item/storage/keyring/steward
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	cloak = /obj/item/clothing/cloak/half/red
	backpack_contents = list(
		/obj/item/storage/keyring = 1,
	)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_UPPER_MIDDLE_CLASS, H) // bumped from lower-middle to match councillor floor
	// give them the good see prices trait
	ADD_TRAIT(H, TRAIT_SEEPRICES, JOB_TRAIT)
	// Level past Jman if they want to
	ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, JOB_TRAIT)

/datum/advclass/councillor/hexer
	name = "Hexer"
	tutorial = "You are a retired Witch whose loyalty has earned you a humble place within the Duke's retinue. Either age or comfort has long since robbed you of the strength to wield greater magics, but necessity has honed your mastery of the old ways. Few can match your talent for seeing, learning and going where others cannot."
	outfit = /datum/outfit/job/roguetown/councillor/hexer
	category_tags = list(CTAG_COUNCILLOR)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_CON = -1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/councillor/hexer
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/councillor/hexer/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/witchhat
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/steward
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/keyring = 1,
		/obj/item/chalk = 1,
		/obj/item/pestle = 1,
		/obj/item/reagent_containers/glass/mortar = 1,
		/obj/item/rogueweapon/spellbook = 1,
	)
	ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_SEEPRICES, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
	H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)

	var/shapeshifts = list("Zad", "Cat", "Cat (Black)", "Bat", "Lesser Volf", "Cabbit", "Small Rous", "Lesser Venard")
	var/shapeshiftchoice = input(H, "What form does your second skin take?", "THE OLD WAYS") as anything in shapeshifts
	if(H.mind)
		switch (shapeshiftchoice)
			if("Zad")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/crow)
			if("Cat")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat)
			if("Cat (Black)")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat/black)
			if("Bat")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/bat)
			if("Lesser Volf")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_wolf)
			if("Lesser Venard")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_vernard)
			if("Small Rous")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/rous)
			if("Cabbit")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cabbit)
	
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonechill) // or else the 'hexer' deal wouldn't sell
		H.mind.AddSpell(new /datum/action/cooldown/spell/wither) // ditto from above
		H.mind.AddSpell(new /datum/action/cooldown/spell/arcyne_forge) // mostly to have a swiss knife out of your pocket
		H.mind.AddSpell(new /datum/action/cooldown/spell/conjure_arcyne_ward/crystalhide) // the moment this breaks you're history, mr. -2 CON
		SStreasury.grant_savings(ECONOMIC_UPPER_MIDDLE_CLASS, H)
		// NO poke spells for you, ser, keep asking! psydon is dead, your prayers wont reach him
		H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 6, "ward" = FALSE)) // no majors, no minors, no fbi(!!!), ward is there mostly as a consolation prize really
	// now you may ask "but kunai where is mystagogue and godsblood?!", my response is: "behind u!!!! *disappears*", also known as "your greed will be your downfall" also known as "your greed SICKENS me"

/datum/advclass/councillor/baron
	name = "Baron"
	tutorial = "Your title may grant you a seat at court, but so does your bladework earn respect. A skilled duelist and noble advisor, you represent your house through wit, honor, and steel. After all, a Baron's name is only as strong as the hand that defends it. Given your highest standing among other Councillors, you can even grant titles."
	outfit = /datum/outfit/job/roguetown/councillor/baron
	category_tags = list(CTAG_COUNCILLOR)
	// equivalent of a Daring Twit but weaker, as your role is to sit down and be pretty
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
		STATKEY_WIL = -1, // ur a lil fat, actually
	)

	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/councillor/baron
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/councillor/baron/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/circlet
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	pants = /obj/item/clothing/under/roguetown/trou/beltpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/gold
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/storage/keyring/steward
	beltr = /obj/item/rogueweapon/scabbard/sword/royal
	backl = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/half/red
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
	)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_RICH, H)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/grant_title) // you can do the duke thingy too!
	ADD_TRAIT(H, TRAIT_SEEPRICES, JOB_TRAIT)
	has_loadout = TRUE

/datum/outfit/job/roguetown/councillor/baron/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list( // copypaste from daring twit sure why not
	"Sabre",
	"Rapier",
	"Arming Sword"
	)
	var/weapon_choice = input(H, "Choose your weapon.", "ARMS TO INVITE ENVY") as anything in weapons
	switch(weapon_choice)
		if("Sabre")
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/dec)
		if("Rapier")
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/dec)
		if("Arming Sword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/decorated)
