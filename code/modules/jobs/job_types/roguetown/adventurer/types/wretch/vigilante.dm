/datum/advclass/wretch/vigilante
	name = "Masked Lunatic"
	tutorial = "You were a disenfranchised pauper, sickened by the rampant corruption of the garrison - or perhaps, just a crazed vagrant in a costume? Whether those brutalized 'thieves' were justified in their acts is up to YOU to decide, not them! You specialize in utilizing your various gadgets and thrown projectiles to dote out JUSTICE, however you see it fit."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/vigilante
	cmode_music = 'sound/music/combatmaniac.ogg'
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_DECEIVING_MEEKNESS, TRAIT_PERFECT_TRACKER)
	maximum_possible_slots = 1 // There can only be one. 
	extra_context = "This class is best experienced without preparation."
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT, //To make a clean getaway from the constables
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, // RUN BOY RUN
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT, // To escape grapplers, fuck you
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE, //To make your own costumes.
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //You WILL be getting neckstabbed A LOT. 
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT, //SNIFF OUT JUSTICE.
	)

/datum/outfit/job/roguetown/wretch/vigilante/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/chaincoif/ //So your skull isn't caved in if you decide to wear a cool hat. 
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/steel
	gloves = /obj/item/clothing/gloves/roguetown/plate
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	if(H.mind)
		var/classes = list("The Watchman", "The Gadgeteer", "I AM JUSTICE INCARNATE!!!")
		var/classchoice = input(H, "Choose your archetypes", "Available archetypes") as anything in classes
		switch(classchoice)
			if("The Watchman") //Face-to-face CQC. No crit resist. Pure aura. Rorschach. 
				H.set_blindness(0)
				watchman_equip(H)
			if("The Gadgeteer") //Make gadgets, be precise and smart. Think ahead before you start swinging. Nite Owl. 
				H.set_blindness(0)
				owl_equip(H)
			if("I AM JUSTICE INCARNATE!!!") //THROW SHIT AT PEOPLE. RANDOM BULLSHIT GO!!!! MOON KNIGHT. 
				H.set_blindness(0)
				bullshit_equip(H)

/datum/outfit/job/roguetown/wretch/vigilante/proc/watchman_equip(mob/living/carbon/human/H)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 5, TRUE) //If a MAA is allowed to have master wrestling, this guy can too. Blow me. 
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 5, TRUE) //I can do this all day. 
	backl = /obj/item/storage/backpack/rogue/backpack/bagpack
	beltr = /obj/item/rogueweapon/stoneaxe/hurlbat
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood
	cloak = /obj/item/clothing/cloak/thief_cloak
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_WIL, 3)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC) //No crit resist - you can still get folded pretty easily if overwhelmed
	if(H.mind)
		var/weapons = list("THE FISTS OF JUSTICE ARE UNISEX!","JUSTICE DISPENSED THROUGH KNUCKLE AND BLADE!")
		var/weapon_choice = input(H, "Choose your WEAPON.", "THY FISTS ARE THY IMPLEMENT, WATCHMAN!") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("THE FISTS OF JUSTICE ARE UNISEX!")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE) //It's sovl. 
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
			if("JUSTICE DISPENSED THROUGH KNUCKLE AND BLADE!")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE) //No Civbarb. 
				l_hand = /obj/item/rogueweapon/katar
				r_hand = /obj/item/rogueweapon/knuckles
	wretch_select_bounty(H)

/datum/outfit/job/roguetown/wretch/vigilante/proc/owl_equip(mob/living/carbon/human/H)
	backl = /obj/item/rogueweapon/woodstaff/quarterstaff/steel //nonlethal takedowns
	beltr = /obj/item/quiver/sling/iron
	l_hand = /obj/item/grapplinghook
	r_hand = /obj/item/bomb/smoke
	beltl = /obj/item/bomb/smoke
	cloak = /obj/item/clothing/cloak/cape/puritan
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	mask = /obj/item/clothing/mask/rogue/duelmask
	backpack_contents = list(
		/obj/item/lockpickring/mundane = 1,
		/obj/item/gun/ballistic/revolver/grenadelauncher/sling = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		)
	H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, 4, TRUE) //Investigations
	H.adjust_skillrank_up_to(/datum/skill/combat/slings, 4, TRUE) // Funny as shit to use. 
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE) //Last resort CQC. Enough def on a quarterstaff to fight defensively, not enough to be truly offensive.
	H.adjust_skillrank_up_to(/datum/skill/combat/staves, 4, TRUE) //Realized NOBODY was running this class because it was abysmal at combat with jman. Woe.
	H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, 4, TRUE) //I lurk in the shadows...
	H.adjust_skillrank_up_to(/datum/skill/craft/crafting, 4, TRUE) //Crafty
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, 5, TRUE) // Escape routes
	H.adjust_skillrank_up_to(/datum/skill/craft/engineering, 3, TRUE) //Make your own tinkering tools and smokebombs
	H.adjust_skillrank_up_to(/datum/skill/craft/smelting, 3, TRUE) //Just so your smelted ingots aren't ruined
	H.change_stat(STATKEY_INT, 3) 
	H.change_stat(STATKEY_WIL, 3)
	H.change_stat(STATKEY_PER, 3)
	wretch_select_bounty(H)

/datum/outfit/job/roguetown/wretch/vigilante/proc/bullshit_equip(mob/living/carbon/human/H)
	beltr = /obj/item/rogueweapon/stoneaxe/hurlbat
	r_hand = /obj/item/rogueweapon/stoneaxe/hurlbat
	l_hand = /obj/item/rogueweapon/stoneaxe/hurlbat
	beltl = /obj/item/quiver/javelin/steel
	backl = /obj/item/quiver/javelin/steel
	cloak = /obj/item/clothing/cloak/cape
	mask = /obj/item/clothing/mask/rogue/facemask
	H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 1, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 2, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/cooking, 1, TRUE)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/magicians_brick) //Trust the plan. 
	ADD_TRAIT(H, TRAIT_MAGEARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC) // You LITERALLY get no weapon skills. You're throwing shit at enemies. 
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_WIL, 1)
	H.change_stat(STATKEY_INT, 4) //Hilarious
	wretch_select_bounty(H)
