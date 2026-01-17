/datum/job/roguetown/hand
	title = "Hand"
	flag = HAND
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = RACES_NO_CONSTRUCT	//No noble constructs.
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/hand
	advclass_cat_rolls = list(CTAG_HAND = 20)
	display_order = JDO_HAND
	selection_color = JCOLOR_COURTIER
	tutorial = "You owe everything to your liege. Once, you were just a humble friend--now you are one of the most important people within the duchy itself. You have played spymaster and confidant to the Noble-Family for so long that you are a veritable vault of intrigue, something you exploit with potent conviction at every opportunity. Let no man ever forget into whose ear you whisper. You've killed more men with those lips than any blademaster could ever claim to."
	whitelist_req = TRUE
	give_bank_account = TRUE
	noble_income = 22
	min_pq = 9 //The second most powerful person in the realm...
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/cmode/nobility/combat_spymaster.ogg'
	job_traits = list(TRAIT_NOBLE)
	job_subclasses = list(
		/datum/advclass/hand/blademaster,
		/datum/advclass/hand/spymaster,
		/datum/advclass/hand/advisor
	)

/datum/outfit/job/roguetown/hand
	backr = /obj/item/storage/backpack/rogue/satchel/short
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	belt = /obj/item/storage/belt/rogue/leather/steel
	id = /obj/item/scomstone/garrison
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/hand/pre_equip(mob/living/carbon/human/H)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/agent)
	H.verbs |= /datum/job/roguetown/hand/proc/remember_agents

/datum/job/roguetown/hand/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(know_agents), L), 5 SECONDS)

///////////
//CLASSES//
///////////

//Blademaster Hand start
/datum/advclass/hand/blademaster
	name = "Blademaster"
	tutorial = "You have played blademaster and strategist to the Noble-Family for so long that you are a master tactician, something you exploit with potent conviction. Let no man ever forget whose ear you whisper into. You've killed more men with swords than any spymaster could ever claim to."
	outfit = /datum/outfit/job/roguetown/hand/blademaster

	category_tags = list(CTAG_HAND)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 3,
		STATKEY_STR = 2,
		STATKEY_LCK = 1,
	)
	age_mod = /datum/class_age_mod/hand_blademaster
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/hand/blademaster/pre_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/rogueweapon/sword/long/dec //Gets STR so longsword instead of a rapier
	beltr = /obj/item/rogueweapon/scabbard/sword
	head = /obj/item/clothing/head/roguetown/chaperon/noble/hand
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/hand
	pants = /obj/item/clothing/under/roguetown/tights/black
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_f
	else if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_m
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/dtace = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/hand = 1,
	)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Savings.")


//Spymaster start
/datum/advclass/hand/spymaster
	name = "Spymaster"
	tutorial = " You have played spymaster and confidant to the Noble-Family for so long that you are a vault of intrigue, something you exploit with potent conviction. Let no man ever forget whose ear you whisper into. You've killed more men with those lips than any blademaster could ever claim to."
	extra_context = "This subclass recieves 'Perfect Tracker' and 'Keen Ears' for free."
	outfit = /datum/outfit/job/roguetown/hand/spymaster

	category_tags = list(CTAG_HAND)
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_KEENEARS, TRAIT_DODGEEXPERT, TRAIT_PERFECT_TRACKER)//Spy not a royal champion
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_STR = -1,
	)
	age_mod = /datum/class_age_mod/hand_spymaster
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER, // not like they're gonna break into the vault.
	)

//Spymaster start. More similar to the rogue adventurer - loses heavy armor and sword skills for more sneaky stuff.
/datum/outfit/job/roguetown/hand/spymaster/pre_equip(mob/living/carbon/human/H)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/dtace = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/hand = 1,
		/obj/item/lockpickring/mundane = 1,
	)
	if(H.dna.species.type in NON_DWARVEN_RACE_TYPES)
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/shadowrobe
		cloak = /obj/item/clothing/cloak/half/shadowcloak
		gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves
		mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask
		pants = /obj/item/clothing/under/roguetown/trou/shadowpants
	else
		cloak = /obj/item/clothing/cloak/raincloak/mortus //cool spymaster cloak
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		backr = /obj/item/storage/backpack/rogue/satchel/black
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/hand
		pants = /obj/item/clothing/under/roguetown/tights/black
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Savings.")

//Advisor Start
/datum/advclass/hand/advisor
	name = "Advisor"
	tutorial = " You have played researcher and confidant to the Noble-Family for so long that you are a vault of knowledge, something you exploit with potent conviction. Let no man ever forget the knowledge you wield. You've read more books than any blademaster or spymaster could ever claim to."
	outfit = /datum/outfit/job/roguetown/hand/advisor

	category_tags = list(CTAG_HAND)
	traits_applied = list(TRAIT_ALCHEMY_EXPERT, TRAIT_MAGEARMOR, TRAIT_ARCYNE_T2)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 3,
		STATKEY_WIL = 2,
		STATKEY_LCK = 2,
	)
	age_mod = /datum/class_age_mod/hand_advisor
	subclass_spellpoints = 15
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)

//Advisor start. Trades combat skills for more knowledge and skills - for older hands, hands that don't do combat - people who wanna play wizened old advisors.
/datum/outfit/job/roguetown/hand/advisor/pre_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/rogueweapon/sword/rapier/dec
	beltr = /obj/item/rogueweapon/scabbard/sword
	head = /obj/item/clothing/head/roguetown/chaperon/noble/hand
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/hand
	pants = /obj/item/clothing/under/roguetown/tights/black
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_f
	else if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_m
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/dtace = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/keyring/hand = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,//starts with a vial of poison, like all wizened evil advisors do!
	)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Savings.")

////////////////////
///SPELLS & VERBS///
////////////////////

/datum/job/roguetown/hand/proc/know_agents(var/mob/living/carbon/human/H)
	if(!GLOB.court_agents.len)
		to_chat(H, span_boldnotice("You begun the week with no agents."))
	else
		to_chat(H, span_boldnotice("We begun the week with these agents:"))
		for(var/name in GLOB.court_agents)
			to_chat(H, span_greentext(name))

/datum/job/roguetown/hand/proc/remember_agents()
	set name = "Remember Agents"
	set category = "Voice of Command"

	to_chat(usr, span_boldnotice("I have these agents present:"))
	for(var/name in GLOB.court_agents)
		to_chat(usr, span_greentext(name))
	return

/obj/effect/proc_holder/spell/self/convertrole/agent
	name = "Recruit Agent"
	new_role = "Court Agent"//They get shown as adventurers either way.
	overlay_state = "recruit_servant"
	recruitment_faction = "Agents"
	recruitment_message = "Serve the crown, %RECRUIT!"
	accept_message = "FOR THE CROWN!"
	refuse_message = "I refuse."
	recharge_time = 100

/obj/effect/proc_holder/spell/self/convertrole/agent/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(!.)
		return
	GLOB.court_agents += recruit.real_name
