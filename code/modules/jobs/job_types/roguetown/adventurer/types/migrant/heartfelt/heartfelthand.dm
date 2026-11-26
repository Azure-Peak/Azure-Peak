/datum/job/roguetown/heartfelt/hand
	title = "Hand of Heartfelt"
	tutorial = "You are the Hand of Heartfelt, the trusted right-hand of the Count of Heartfelt. \
	Certain circumstances have compelled your Lord to visit the capital. Whether to request more aid for the borderlands against Aavnic raids, reconstruction, canal funding, or perhaps intrigue or a plot to finally seize the throne of Azuria, you have arrived here as part of their entourage."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED RACES_HEARTFELT)
	outfit = /datum/outfit/job/roguetown/heartfelt/hand
	total_positions = 1
	spawn_positions = 0
	job_traits = list(TRAIT_NOBLE, TRAIT_HEARTFELT)
	noble_income = 22
	advclass_cat_rolls = list(CTAG_HFT_HAND)

	job_subclasses = list(
		/datum/advclass/heartfelt/hand/marshal,
		/datum/advclass/heartfelt/hand/steward,
		/datum/advclass/heartfelt/hand/advisor,
		)

/datum/outfit/job/roguetown/heartfelt/hand/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	pants = /obj/item/clothing/under/roguetown/tights/black
	gloves =/obj/item/clothing/gloves/roguetown/angle
	beltr = /obj/item/flashlight/flare/torch/lantern
	id = /obj/item/scomstone
	backl = /obj/item/storage/backpack/rogue/satchel

/***************************************************************/
// MARSHAL //
/***************************************************************/


/datum/advclass/heartfelt/hand/marshal
	name = "Marshal of Heartfelt"
	tutorial = "You are the Marshal of Heartfelt. You spent your daes as a dutiful knight, maybe even the best, in the service of the Count. \
	Earning your accolades through military tactics and victories, you're renowned for your leadership in battle."
	outfit = /datum/outfit/job/roguetown/heartfelt/hand/marshal
	category_tags = list(CTAG_HFT_HAND)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_NOBLE, TRAIT_HEARTFELT, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
	)

	subclass_stashed_items = list("Heartfelt Caparison" = /obj/item/caparison/heartfelt)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_skills = list(
	/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
	/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
	/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/heartfelt/hand/marshal/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/hand
	r_hand = /obj/item/rogueweapon/sword/long/dec
	l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltl = /obj/item/rogueweapon/scabbard/sword/noble
	backr = /obj/item/quiver/bolt/standard
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)
		add_verb(H, list(/mob/living/carbon/human/mind/proc/setordersheartfelt))

	var/helmet = list("Etruscan Bascinet","Volf Plate Helmet","Beak Helmet","Visored Sallet","Snouted Visored Sallet",)
	var/helmet_choice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmet
	switch(helmet_choice)
		if("Etruscan Bascinet")
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
		if("Volf Plate Helmet")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate
		if("Beak Helmet") // GUUUUTS NO GUTS NOOOOO
			head = /obj/item/clothing/head/roguetown/helmet/heavy/beakhelm
		if("Visored Sallet")
			head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
		if("Snouted Visored Sallet")
			head = /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted
		else
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan

/***************************************************************/
// STEWARD //
/***************************************************************/

/datum/advclass/heartfelt/hand/steward
	name = "Steward of Heartfelt"
	tutorial = "Coin, Coin, Coin! Oh beautiful coin: You're addicted to it, and you hold the position as the Count of Heartfelt's personal treasurer of both coin and information. \
	You know the power silver and gold has on a man's mortal soul, and you know just what lengths they'll go to in order to get even more."
	outfit = /datum/outfit/job/roguetown/heartfelt/hand/steward
	category_tags = list(CTAG_HFT_HAND)
	traits_applied = list(TRAIT_SEEPRICES, TRAIT_HEARTFELT)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
	)

	subclass_stashed_items = list("Heartfelt Caparison" = /obj/item/caparison/heartfelt)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_skills = list(
	/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
	/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
	/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
	/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/heartfelt/hand/steward/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	r_hand = /obj/item/rogueweapon/sword/sabre/dec
	beltl = /obj/item/rogueweapon/scabbard/sword/noble
	beltr = /obj/item/flashlight/flare/torch/lantern
	neck = /obj/item/storage/belt/rogue/pouch/coins/veryrich
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 2,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		)
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	id = /obj/item/scomstone
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)

/***************************************************************/
// ADVISOR - MAGE CLASS //
/***************************************************************/

/datum/advclass/heartfelt/hand/advisor
	name = "Advisor of Heartfelt"
	tutorial = "You are the Advisor of Heartfelt. You have played researcher and confidant to the Count for so long that you are a vault of knowledge, something you exploit with potent conviction. \
	Let no man ever forget the knowledge you wield. You've read more books than any marshal or steward could ever claim to."
	outfit = /datum/outfit/job/roguetown/heartfelt/hand/advisor
	category_tags = list(CTAG_HFT_HAND)
	traits_applied = list(TRAIT_ARCYNE, TRAIT_INTELLECTUAL, TRAIT_SEEPRICES_SHITTY, TRAIT_HEARTFELT, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_SPD = 1
	)

	subclass_stashed_items = list("Heartfelt Caparison" = /obj/item/caparison/heartfelt)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 4, "ward" = TRUE)

	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)
	var/list/spells = list()

//Advisor start. Trades combat skills for more knowledge and skills - for older hands, hands that don't do combat - people who wanna play wizened old advisors.
/datum/outfit/job/roguetown/heartfelt/hand/advisor/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		/obj/item/rogueweapon/spellbook = 1,
	) //starts with a vial of poison, like all wizened evil advisors do!
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	pants = /obj/item/clothing/under/roguetown/tights/black
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)

	if(H.age == AGE_OLD)
		H.change_stat("speed", -1)
		H.change_stat("strength", -1)
		H.change_stat("intelligence", 1)
		H.change_stat("perception", 1)
		if(H.mind)
			H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 5))
