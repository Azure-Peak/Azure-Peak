/datum/job/roguetown/lady
	title = "Consort"
	flag = LADY
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	tutorial = "Picked out of your political value rather than likely any form of love, you have become the rulers most trusted confidant--and likely friend--throughout your time at their side. Your loyalty, patience and trust will be tested this day... for the daggers that threaten the neck of the one who wears the crown are as equally pointed at your own." //no more refence to marriage or love, can be platonic

	spells = list(/obj/effect/proc_holder/spell/self/convertrole/servant,
	/obj/effect/proc_holder/spell/self/grant_nobility, /obj/effect/proc_holder/spell/self/grant_title) //why not
	outfit = /datum/outfit/job/roguetown/lady

	display_order = JDO_LADY
	give_bank_account = TRUE
	noble_income = 22
	min_pq = 10 //should probably be higher with duchess at 50
	max_pq = null
	round_contrib_points = 3
	vice_restrictions = list(/datum/charflaw/mute, /datum/charflaw/unintelligible) //Needs to use the throat - sometimes

/datum/job/roguetown/exlady
	title = "Consort Dowager"
	flag = LADY
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	display_order = JDO_LADY
	give_bank_account = TRUE

/datum/outfit/job/roguetown/lady
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	pants = /obj/item/clothing/under/roguetown/tights
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	backr = /obj/item/storage/backpack/rogue/satchel/short
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	id = /obj/item/scomstone/garrison
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/lady/pre_equip(mob/living/carbon/human/H)
	. = ..()
	ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KEENEARS, TRAIT_GENERIC)
//		SSticker.rulermob = H
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
	else if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/gold
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/decorated,
		/obj/item/rogueweapon/scabbard/sheath/royal = 1,
		/obj/item/storage/keyring/lord = 1,
		/obj/item/roguekey/skeleton = 1
	)
	H.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE) //not that easy to grab after all
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE) //of course
	H.change_stat(STATKEY_INT, 3)
	H.change_stat(STATKEY_WIL, 3)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_LCK, 5)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Savings.")
		record_round_statistic(STATS_MARRIAGES_MADE)//Terrible way to do this but like, it wouldn't work off the "I'm married proc" so here we are.

/obj/effect/proc_holder/spell/self/convertrole/servant
	name = "Recruit Servant"
	new_role = "Servant"
	overlay_state = "recruit_servant"
	recruitment_faction = "Servants"
	recruitment_message = "Serve the crown, %RECRUIT!"
	accept_message = "FOR THE CROWN!"
	refuse_message = "I refuse."
	recharge_time = 100
