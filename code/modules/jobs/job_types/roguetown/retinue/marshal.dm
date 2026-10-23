/datum/job/roguetown/marshal // A somewhat ham-fisted merge between bailiff and the old town sheriff role. The latter was built like a modern day officer, but we medieval in this bitch!
	title = "Marshal"
	flag = MARSHAL
	department_flag = RETINUE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	display_order = JDO_MARSHAL
	selection_color = JCOLOR_RETINUE
	tutorial = "You are an agent of the crown in matters of law and military, making sure that laws are pushed, verified and carried out by the retinue upon the citizenry of the realm. \
				While you preside over the knights and men-at-arms, much of your work happens behind a desk, deferring to the Sergeant-at-Arms to make sure your will is carried out in the field."
	whitelist_req = FALSE

	spells = list(/obj/effect/proc_holder/spell/self/convertrole/guard) // /obj/effect/proc_holder/spell/self/convertrole/bog
	outfit = /datum/outfit/job/roguetown/marshal

	give_bank_account = TRUE
	noble_income = 20
	min_pq = 8
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_knight.ogg'
	advclass_cat_rolls = list (CTAG_MARSHAL = 20)

	job_traits = list(TRAIT_NOBLE, TRAIT_STEELHEARTED, TRAIT_GUARDSMAN, TRAIT_EXPERT_HUNTER)
	vice_restrictions = list(/datum/charflaw/mute, /datum/charflaw/unintelligible) //Needs to use the throat - sometimes
	job_subclasses = list(
		/datum/advclass/marshal/classic,
		/datum/advclass/marshal/kcommander
	)

/datum/outfit/job/roguetown/marshal
	job_bitflag = BITFLAG_ROYALTY | BITFLAG_GARRISON	//Same as Captain, you get decent combat stats so might as well be garrison.

/datum/outfit/job/roguetown/marshal/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backl = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/garrison
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/book/rogue/law = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	add_verb(H, /mob/proc/haltyell)
	add_verb(H, list(/mob/living/carbon/human/proc/request_outlaw, /mob/living/carbon/human/proc/request_law, /mob/living/carbon/human/proc/request_law_removal, /mob/living/carbon/human/proc/request_purge))
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_RICH, H)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/movemovemove)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/takeaim)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/hold)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/onfeet)

/datum/advclass/marshal/classic
	name = "Constable"
	tutorial = "You spent your daes as a lawmaker, a sleuth and as a part of the garrison in the city. You've studied the law tomes from back to front and understand that they're merely guidelines that should be followed, but not directly to the letter. Thus, you've made it so that your words espouse true justice with a silver tongue and an iron hand. You've collected facts and reviewed evidence so that the warmongers in court don't get their uncivilized, outdated way for an execution a dae, and most of the realm respects your authority in matters of crimes and punishment."
	outfit = /datum/outfit/job/roguetown/marshal/classic

	category_tags = list(CTAG_MARSHAL) //11 statweight, the better sergeant
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 3,
		STATKEY_CON = 3,
		STATKEY_WIL = 1,
		STATKEY_SPD = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)
	subclass_virtues = list(
		/datum/virtue/utility/tracker
	)

/datum/outfit/job/roguetown/marshal/classic/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/retinue
	cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/bailiff
	pants = /obj/item/clothing/under/roguetown/chainlegs
	wrists = /obj/item/clothing/wrists/roguetown/bracers/armharness
	backr = /obj/item/rogueweapon/mace/cudgel/flanged/justice
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltr = /obj/item/rogueweapon/shield/buckler
	beltl = /obj/item/storage/keyring/marshal
	head = /obj/item/clothing/head/roguetown/chaperon/noble/bailiff
	neck = /obj/item/clothing/neck/roguetown/bevor
	r_hand = /obj/item/clothing/head/roguetown/helmet/sallet/visored


/datum/advclass/marshal/kcommander
	name = "Knight Commander"
	tutorial = "You spent your daes as a dutiful knight, maybe even the best, in the service of the crown. Earning your accolades through military tactics and victories, you're renowned for your leadership in battle. Now retired from your time at war, you enforce the same iron laws once practiced in bloodied fields, now behind stone walls. You run the garrison, retinue, and town's laws with a militarized strictness; no doubt, any constable would see you as an overbearing warmonger... but the times necessitate such."
	outfit = /datum/outfit/job/roguetown/marshal/kcommander

	category_tags = list(CTAG_MARSHAL)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list( //11 statweight, mounted knight stats
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/marshal/kcommander/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/marshal
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	backr = /obj/item/rogueweapon/sword/long/oathkeeper
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/scabbard/sword/noble
	beltl = /obj/item/storage/keyring/marshal
	head = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor
	neck = /obj/item/clothing/neck/roguetown/gorget/steel

/mob/living/carbon/human/proc/request_law()
	set name = "Request Law"
	set category = "RoleUnique.Voice of Command"
	if(stat)
		return
	var/inputty = input(src, "Write a new law", "SHERIFF") as text|null
	if(inputty)
		if(hasomen(OMEN_NOLORD))
			make_law(inputty)
		else
			var/lord = find_lord()
			if(lord)
				INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(lord_law_requested), src, lord, inputty)
			else
				make_law(inputty)

/mob/living/carbon/human/proc/request_law_removal()
	set name = "Request Law Removal"
	set category = "RoleUnique.Voice of Command"
	if(stat)
		return
	var/inputty = input(src, "Remove a law", "SHERIFF") as text|null
	var/law_index = text2num(inputty) || 0
	if(law_index && GLOB.laws_of_the_land[law_index])
		if(hasomen(OMEN_NOLORD))
			remove_law(law_index)
		else
			var/lord = find_lord()
			if(lord)
				INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(lord_law_removal_requested), src, lord, law_index)
			else
				remove_law(law_index)

/mob/living/carbon/human/proc/request_purge()
	set name = "Request Purge"
	set category = "RoleUnique.Voice of Command"
	if(stat)
		return
	if(hasomen(OMEN_NOLORD))
		purge_laws()
	else
		var/lord = find_lord()
		if(lord)
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(lord_purge_requested), src, lord)
		else
			purge_laws()

/mob/living/carbon/human/proc/request_outlaw()
	set name = "Request Outlaw"
	set category = "RoleUnique.Voice of Command"
	if(stat)
		return
	var/inputty = input(src, "Outlaw a person", "SHERIFF") as text|null
	if(inputty)
		if(hasomen(OMEN_NOLORD))
			make_outlaw(inputty)
		else
			var/lord = find_lord()
			if(lord)
				INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(lord_outlaw_requested), src, lord, inputty)
			else
				make_outlaw(inputty)

/proc/find_lord(required_stat = CONSCIOUS)
	var/mob/living/lord
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.mind || H.job != "Grand Duke" || (H.stat > required_stat))
			continue
		lord = H
		break
	return lord

/proc/lord_law_requested(mob/living/bailiff, mob/living/carbon/human/lord, requested_law)
	var/choice = alert(lord, "The sheriff requests a new law!\n[requested_law]", "SHERIFF LAW REQUEST", "Yes", "No")
	if(choice != "Yes" || QDELETED(lord) || lord.stat > CONSCIOUS)
		if(bailiff)
			to_chat(bailiff, span_warning("The lord has denied the request for a new law!"))
		return
	make_law(requested_law)

/proc/lord_law_removal_requested(mob/living/bailiff, mob/living/carbon/human/lord, requested_law)
	if(!requested_law || !GLOB.laws_of_the_land[requested_law])
		return
	var/choice = alert(lord, "The sheriff requests the removal of a law!\n[GLOB.laws_of_the_land[requested_law]]", "SHERIFF LAW REQUEST", "Yes", "No")
	if(choice != "Yes" || QDELETED(lord) || lord.stat > CONSCIOUS)
		if(bailiff)
			to_chat(bailiff, span_warning("The lord has denied the request for a law removal!"))
		return
	remove_law(requested_law)

/proc/lord_purge_requested(mob/living/bailiff, mob/living/carbon/human/lord)
	var/choice = alert(lord, "The sheriff requests a purge of all laws!", "SHERIFF PURGE REQUEST", "Yes", "No")
	if(choice != "Yes" || QDELETED(lord) || lord.stat > CONSCIOUS)
		if(bailiff)
			to_chat(bailiff, span_warning("The lord has denied the request for a purge of all laws!"))
		return
	purge_laws()

/proc/lord_outlaw_requested(mob/living/bailiff, mob/living/carbon/human/lord, requested_outlaw)
	var/choice = alert(lord, "The sheriff requests to outlaw someone!\n[requested_outlaw]", "SHERIFF OUTLAW REQUEST", "Yes", "No")
	if(choice != "Yes" || QDELETED(lord) || lord.stat > CONSCIOUS)
		if(bailiff)
			to_chat(bailiff, span_warning("The lord has denied the request for declaring an outlaw!"))
		return
	make_outlaw(requested_outlaw)

/mob/proc/haltyell()
	set name = "HALT!"
	set category = "Emotes.Noises"
	emote("haltyell")

/mob/proc/haltyell_exhausting()
	set name = "HALT!"
	set category = "Emotes.Noises"

	emote("haltyell")
	stamina_add(rand(5,15))
