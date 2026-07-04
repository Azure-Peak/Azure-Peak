/datum/job/roguetown/merchant
	title = "Merchant"
	flag = MERCHANT
	department_flag = ATC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_ATC
	forbidden_races = list(RACES_DESPISED)
	tutorial = "Some find craft fulfilling, others take to powerful magic, and yet others take to war and steel. But you found a different vocation. You understand numbers, you understand trade, and you know how to close a good deal. Through expertise - or perhaps a well-placed connection - you have risen to the second most powerful position in the century-old Azurian Trading Company, second only to the Grand Factor, who keeps the Company's seat at Rosporth, a leased enclave a few days' ride north of Azure Peak.\n\
You are the beating heart of the Azurian economy, inheritor of a thousand yils of her people's sailing traditions. Without you, Malumite craftsmen's wares would have nowhere to go, the grain blessed by Astrata and Dendor would rot in the fields, and the perfumes and spices promised to us by Eora would never reach our shores.\n\
The priests will whisper that you follow the Sun-Thief. Frown, shake your head, and remind them you are an honest and humble merchant keeping the wheels of commerce turning, a faithful worker of Malum's will. Do not let some mouth-breathing crownsman tell you otherwise."

	display_order = JDO_MERCHANT

	outfit = /datum/outfit/job/roguetown/merchant
	give_bank_account = TRUE
	noble_income = 100 // ATC chapter stipend - The sole Money Role outside of the keep, should help them keep pace a bit + pick up if they get completely knocked out of coin.
	min_pq = 1 //"Yeah...my guy says the best I can do is one PQ, final offer"
	max_pq = null
	required = TRUE
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_noble.ogg'
	is_quest_giver = TRUE

	job_traits = list(TRAIT_SEEPRICES, TRAIT_CICERONE)
	virtue_restrictions = list(/datum/virtue/utility/skilled, /datum/virtue/utility/apprentice) //Commerce role, not a craftsman.

	advclass_cat_rolls = list(CTAG_MERCH = 2)
	job_subclasses = list(
		/datum/advclass/merchant
	)

/datum/job/roguetown/merchant/after_spawn(mob/living/H, mob/M, latejoin)
	. = ..()
	if(ishuman(H) && SSmerchant_trade)
		SSmerchant_trade.try_claim_kinship_for(H, M?.client)

/datum/advclass/merchant
	name = "Merchant"
	tutorial = "Some find craft fulfilling, others take to powerful magic, and yet others take to war and steel. But you found a different vocation. You understand numbers, you understand trade, and you know how to close a good deal. Through expertise - or perhaps a well-placed connection - you have risen to the second most powerful position in the century-old Azurian Trading Company, second only to the Grand Factor, who keeps the Company's seat at Rosporth, a leased enclave a few days' ride north of Azure Peak.\n\
You are the beating heart of the Azurian economy, inheritor of a thousand yils of her people's sailing traditions. Without you, Malumite craftsmen's wares would have nowhere to go, the grain blessed by Astrata and Dendor would rot in the fields, and the perfumes and spices promised to us by Eora would never reach our shores.\n\
The priests will whisper that you follow the Sun-Thief. Frown, shake your head, and remind them you are an honest and humble merchant keeping the wheels of commerce turning, a faithful worker of Malum's will. Do not let some mouth-breathing crownsman tell you otherwise"
	outfit = /datum/outfit/job/roguetown/merchant/basic
	category_tags = list(CTAG_MERCH)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 2,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
	)
	tempo_capable = FALSE

/datum/outfit/job/roguetown/merchant/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
		/obj/item/blueprint/mace_mushroom = 1
		)
	neck = /obj/item/clothing/neck/roguetown/horus
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/merchant
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/keyring/merchant
	beltr = /obj/item/storage/belt/rogue/pouch/merchant/coins
	id = /obj/item/clothing/ring/gold
	backr = /obj/item/storage/backpack/rogue/satchel
	if(should_wear_masc_clothes(H))
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard]
	else if(should_wear_femme_clothes(H))
		shoes = /obj/item/clothing/shoes/roguetown/gladiator
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/takeapprentice)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_RICH, H)
	backpack_contents = list(
		/obj/item/mini_flagpole/merchant = 1,
		// For selling
		/obj/item/hunting_map/white_stag = 1,
	)
