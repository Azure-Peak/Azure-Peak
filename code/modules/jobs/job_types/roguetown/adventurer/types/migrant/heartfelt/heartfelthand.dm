/datum/job/roguetown/heartfelt/hand
	title = "Hand of Heartfelt"
	tutorial = "You are the Hand of Heartfelt, burdened by the perception of failure in protecting your Lord's domain. \
	Despite doubts from others, your loyalty remains steadfast as you journey to the Reach, determined to fulfill your duties."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/heartfelt/hand
	total_positions = 1
	spawn_positions = 0
	job_traits = list(TRAIT_NOBLE, TRAIT_HEARTFELT)
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
	backl = /obj/item/storage/backpack/rogue/satchel/heartfelt

/***************************************************************/
// MARSHAL //
/***************************************************************/


/datum/advclass/heartfelt/hand/marshal
	name = "Marshal of Heartfelt"
	tutorial = "Renowned for your command of war, you laid down your blade in peaceful years, but peace died with Heartfelt. \
	Pressed once more into service by tragedy, you climb towards the Reach."
	outfit = /datum/outfit/job/roguetown/heartfelt/hand/marshal
	category_tags = list(CTAG_HFT_HAND)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_NOBLE, TRAIT_HEARTFELT)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)

/datum/outfit/job/roguetown/heartfelt/hand/marshal/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/hand
	r_hand = /obj/item/rogueweapon/sword/long/dec
	//l_hand = banner-pike for when I add it
	beltl = /obj/item/rogueweapon/scabbard/sword
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt)
		// H.mind.AddSpell(new/obj/effect/proc_holder/spell/invoked/order/heartfelt/focustarget)
		H.verbs |= list(/mob/living/carbon/human/mind/proc/setordersheartfelt)
	var/helmet = list("Etruscan Bascinet","Beak Helmet","Visored Sallet",)
	var/helmet_choice = input("Choose your Helm.", "TAKE UP HELMS") as anything in helmet
	switch(helmet_choice)
		if("Etruscan Bascinet")
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
		if("Beak Helmet") // GUUUUTS NO GUTS NOOOOO
			head = /obj/item/clothing/head/roguetown/helmet/heavy/beakhelm
		if("Visored Sallet")	
			head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
		else
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan

/***************************************************************/
// STEWARD //
/***************************************************************/

/datum/advclass/heartfelt/hand/steward
	name = "Steward of Heartfelt"
	tutorial = "You are the Steward of Heartfelt, once the quiet architect behind the barony's \
	order—keeper of ledgers, harvests, and the lifeblood that sustained your people. \
	Pressed once more into service by tragedy, you climb towards the Reach."
	outfit = /datum/outfit/job/roguetown/heartfelt/hand/steward
	category_tags = list(CTAG_HFT_HAND)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_SEEPRICES, TRAIT_HEARTFELT)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
	)

/datum/outfit/job/roguetown/heartfelt/hand/steward/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	r_hand = /obj/item/rogueweapon/sword/sabre/dec
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/flashlight/flare/torch/lantern
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,)
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	id = /obj/item/scomstone
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)

/***************************************************************/
// ADVISOR - MAGE CLASS //
/***************************************************************/

/datum/advclass/heartfelt/hand/advisor
	name = "Advisor of Heartfelt"
	tutorial = "You are the Advisor of Heartfelt, trusted for your measured counsel and keen insight into matters of state. \
	Bound once more to serve in the wake of ruin, you climb towards the Reach."
	outfit = /datum/outfit/job/roguetown/heartfelt/hand/advisor
	category_tags = list(CTAG_HFT_HAND)
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T2, TRAIT_INTELLECTUAL, TRAIT_SEEPRICES_SHITTY, TRAIT_HEARTFELT)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 3,
		STATKEY_SPD = 1
	)

	subclass_spellpoints = 15

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
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
	var/list/spells = list(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation)

//Advisor start. Trades combat skills for more knowledge and skills - for older hands, hands that don't do combat - people who wanna play wizened old advisors.
/datum/outfit/job/roguetown/heartfelt/hand/advisor/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	r_hand = /obj/item/rogueweapon/sword/sabre/dec
	beltl = /obj/item/rogueweapon/scabbard/sword
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/lockpickring/mundane = 1, 
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1
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
		H?.mind.adjust_spellpoints(3)
