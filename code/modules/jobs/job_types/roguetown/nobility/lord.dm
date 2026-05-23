GLOBAL_VAR(lordsurname)
GLOBAL_LIST_EMPTY(lord_titles)

/datum/job/roguetown/lord
	title = "Grand Duke"
	f_title = "Grand Duchess"
	flag = LORD
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_NOBLE
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	allowed_sexes = list(MALE, FEMALE)
	advclass_cat_rolls = list(CTAG_LORD = 20)

	outfit = /datum/outfit/job/roguetown/lord
	visuals_only_outfit = /datum/outfit/job/roguetown/lord/visuals

	display_order = JDO_LORD
	tutorial = "Elevated upon your throne through a web of intrigue and political upheaval, you are the absolute authority of these lands and at the center of every plot within it. Every man, woman and child is envious of your position and would replace you in less than a heartbeat: Show them the error of their ways."
	whitelist_req = FALSE
	min_pq = 50 //staff request
	max_pq = null
	round_contrib_points = 4
	give_bank_account = 250
	cmode_music = 'sound/music/combat_noble.ogg'

	// Can't use the Throat when you can't talk properly or.. at all for that matter.
	vice_restrictions = list(/datum/charflaw/mute, /datum/charflaw/unintelligible)

	job_subclasses = list(
		/datum/advclass/lord/warrior,
		/datum/advclass/lord/merchant,
		/datum/advclass/lord/mage,
		/datum/advclass/lord/inbred
	)
	

/datum/outfit/job/roguetown/lord
	job_bitflag = BITFLAG_ROYALTY
	has_loadout = TRUE

/datum/job/roguetown/lord/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(L)

		L.verbs |= /mob/living/carbon/human/proc/grant_title_verb
		L.verbs |= /mob/living/carbon/human/proc/grant_nobility_verb
		L.verbs |= /mob/living/carbon/human/proc/recruit_guard_verb
		L.verbs |= /mob/living/carbon/human/proc/recruit_servant_verb
		L.verbs |= /mob/living/carbon/human/proc/recruit_warden_verb

		var/list/chopped_name = splittext(L.real_name, " ")
		if(length(chopped_name) > 1)
			chopped_name -= chopped_name[1]
			GLOB.lordsurname = jointext(chopped_name, " ")
		else
			GLOB.lordsurname = "of [L.real_name]"
		SSticker.set_ruler_mob(L)
		var/realm = SSticker.realm_name || "Azure Peak"
		to_chat(world, "<b><span class='notice'><span class='big'>[L.real_name] is [SSticker.rulertype] of [realm].</span></span></b>")
		if(istype(SSticker.regentmob, /mob/living/carbon/human))
			var/mob/living/carbon/human/regentbuddy = SSticker.regentmob
			to_chat(L, span_notice("Word reached me on the approach that [regentbuddy.real_name], the [regentbuddy.job], served as regent in my absence."))
		SSticker.regentmob = null //Time for regent to give up the position.

		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, lord_marriage_choice)), 50) //sensible to have this first
		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, lord_suitor_choice)), 50)
		if(STATION_TIME_PASSED() <= 30 MINUTES) //Late to the party? Stuck with default colors, sorry!
			addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, lord_color_choice)), 50)

/datum/outfit/job/roguetown/lord
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	cloak = /obj/item/clothing/cloak/lordcloak
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltl = /obj/item/storage/keyring/lord
	beltr = /obj/item/rogueweapon/scabbard/sword/royal
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/blueprint/mace_mushroom = 1, /obj/item/hunting_map/white_stag = 1)
	id = /obj/item/scomstone/garrison

/datum/outfit/job/roguetown/lord/pre_equip(mob/living/carbon/human/H)
	..()
	if(SSroguemachine.crown == null || (QDELETED(SSroguemachine.crown)))
		SSroguemachine.crown = null
		head = /obj/item/clothing/head/roguetown/crown/serpcrown
	else
		to_chat(H, span_warning("My crown must be yet in the realm. I shall search it out."))
	if(should_wear_femme_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/black
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/royal
		cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
		wrists = /obj/item/clothing/wrists/roguetown/royalsleeves
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/black
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
		shoes = /obj/item/clothing/shoes/roguetown/boots
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/gold
	if(H.wear_mask)
		if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch))
			qdel(H.wear_mask)
			mask = /obj/item/clothing/mask/rogue/lordmask
		if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch/left))
			qdel(H.wear_mask)
			mask = /obj/item/clothing/mask/rogue/lordmask/l
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)

/datum/outfit/job/roguetown/lord/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/client/player = H?.client
	if(player.prefs)
		if(!istype(player.prefs.virtue_origin, /datum/virtue/origin/azuria) && !istype(player.prefs.virtue_origin, /datum/virtue/origin/grenzelhoft) && !istype(player.prefs.virtue_origin, /datum/virtue/origin/otava) && !istype(player.prefs.virtue_origin, /datum/virtue/origin/etrusca))
			var/list/new_origins = list("Azuria" = /datum/virtue/origin/azuria, 
			"Grenzelhoft" = /datum/virtue/origin/grenzelhoft,
			"Otava" = /datum/virtue/origin/otava,
			"Etrusca" = /datum/virtue/origin/etrusca)
			var/new_origin
			var/choice = input(player, "Your origins are not compatible with the [SSticker.realm_type_short]. Where do you hail from?", "ANCESTRY") as anything in new_origins
			if(choice)
				new_origin = new_origins[choice]
			else
				to_chat(player, span_notice("No choice detected. Picking a random compatible origin."))
				new_origin = pick(/datum/virtue/origin/grenzelhoft, /datum/virtue/origin/otava, /datum/virtue/origin/etrusca)
			change_origin(H, new_origin, "Royal line")

//	SSticker.rulermob = H
/**
	Warrior Lord subclass. An evolution from the Daring Twit. This is the original Lord Class.
*/
/datum/advclass/lord/warrior
	name = "Valiant Warrior"
	tutorial = "You're a noble warrior. You rose to your rank through your own strength and skill, whether by leading your men or by fighting alongside them. Or perhaps you are none of that, but simply a well-trained heir elevated to the position of Lord. You're trained in the usage of heavy armor, and knows swordsmanship well."
	outfit = /datum/outfit/job/roguetown/lord/warrior
	category_tags = list(CTAG_LORD)
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_DNR)
	subclass_stats = list(
		STATKEY_LCK = 5,
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
		STATKEY_STR = 1,
	)
	age_mod = /datum/class_age_mod/grand_duke
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)
	
	subclass_stashed_items = list(
		"Ducal Caparison (Saiga)" = /obj/item/caparison/azure,
		"Fogbeast Caparison" = /obj/item/caparison/fogbeast)

/datum/outfit/job/roguetown/lord/warrior/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/lordscepter

/**
	Merchant Lord subclass. Consider this an evolution from Sheltered Aristocrat.
	Gets the same weighted 12 statspread + 5 fortune, but no strength. +2 Int, trade 2 End for 2 Perception. Keep speed. Deals gotta be quick.
	Get nice traits for seeing price, secular appraise and keen ears for spying.
	Weapon skills are worse across the board compared to the warrior lord, apprentice only.
	Has a high noble income plus a starting pouch with insane amount of money.
*/
/datum/advclass/lord/merchant
	name = "Merchant Lord"
	tutorial = "You were always talented with coins and trade. And your talents have brought you to the position of the Lord of Azure Peak. You could be a merchant who bought his way into nobility and power, or an exceptionally talented noble who were inclined to be good with coins. Fighting directly is not your forte\
	But you have plenty of wealth, keen ears, and know a good deal from a bad one."
	outfit = /datum/outfit/job/roguetown/lord/merchant
	category_tags = list(CTAG_LORD)
	noble_income = 275 // Decently high but shouldn't remove any need for economic management
	traits_applied = list(TRAIT_NOBLE, TRAIT_SEEPRICES, TRAIT_CICERONE, TRAIT_KEENEARS, TRAIT_MEDIUMARMOR, TRAIT_DNR)
	subclass_stats = list(
		STATKEY_LCK = 5,
		STATKEY_INT = 5,
		STATKEY_PER = 4,
		STATKEY_SPD = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT, // Weapons suitable for defending yourself as a merchant.
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_stashed_items = list(
		"Ducal Caparison (Saiga)" = /obj/item/caparison/azure,
		"Fogbeast Caparison" = /obj/item/caparison/fogbeast)

/datum/outfit/job/roguetown/lord/merchant/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/lordscepter
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)

/**
	Mage Lord subclass. Prince mage is a thing.
	Light on skills, has some combat skills mage normally doesn't have. 18 pts so people don't complain they are better.
	Stats is better than mage associate and magic heir. +12 total.
	Mage armor and no armor training.


	King's addition: Porting this to Azure after a long time. May adjust later to compromise with other vision for the role. Also gave them a fucking satchel.
*/
/datum/advclass/lord/mage
	name = "Mage Lord"
	tutorial = "Despite spending your younger years focused on reading and the wonders of the arcyne, it came the time for you to take the throne. Now you rule not only by crown and steel, but by spell and wit, show those who doubted your time buried in books was well spent how wrong they were."
	outfit = /datum/outfit/job/roguetown/lord/mage
	category_tags = list(CTAG_LORD)
	traits_applied = list(TRAIT_NOBLE, TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT, TRAIT_DNR)
	subclass_stats = list(
		STATKEY_LCK = 5,
		STATKEY_INT = 4,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 4, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_stashed_items = list(
		"Ducal Caparison (Saiga)" = /obj/item/caparison/azure,
		"Fogbeast Caparison" = /obj/item/caparison/fogbeast)

/datum/outfit/job/roguetown/lord/mage/pre_equip(mob/living/carbon/human/H)
	..()
	backr = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/book/spellbook = 1, /obj/item/blueprint/mace_mushroom = 1, /obj/item/chalk = 1, /obj/item/hunting_map/white_stag = 1,)

/**
	Inbred Lord subclass. A joke class, evolution of the Inbred Wastrel.
	Literally the same stat line and skills line, but with one exception - 10 Fortune.
	Why? Because it is funny, that's why. They also have heavy armor training.
	The fact that the inbred wastrel with 20 fortune and critical weakness
	can get into heavy armor and try to fight is hilarious.
*/
/datum/advclass/lord/inbred
	name = "Inbred Lord"
	tutorial = "Psydon and Astrata smiles upon you. For despite your inbred and weak body, and your family's conspiracies to remove you from succession, you have somehow become the Lord of Azure Peak. May your reign lasts a hundred years."
	outfit = /datum/outfit/job/roguetown/lord/inbred
	category_tags = list(CTAG_LORD)
	traits_applied = list(TRAIT_NOBLE, TRAIT_CRITICAL_WEAKNESS, TRAIT_NORUN, TRAIT_HEAVYARMOR, TRAIT_GOODLOVER, TRAIT_DNR)
	subclass_stats = list(
		STATKEY_LCK = 10,
		STATKEY_INT = -2,
		STATKEY_PER = -2,
		STATKEY_CON = -2,
		STATKEY_WIL = -2,
		STATKEY_STR = -2,
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_stashed_items = list(
		"Ducal Caparison (Saiga)" = /obj/item/caparison/azure,
		"Fogbeast Caparison" = /obj/item/caparison/fogbeast)

/datum/outfit/job/roguetown/lord/inbred/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/lordscepter
	H.adjust_skillrank(/datum/skill/combat/crossbows, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, pick(0,0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, pick(0,1), TRUE)

/datum/outfit/job/roguetown/lord/visuals/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/crown/fakecrown //Prevents the crown of woe from happening again.

/proc/give_lord_surname(mob/living/carbon/human/family_guy, preserve_original = FALSE)
	if(!GLOB.lordsurname)
		return
	if(preserve_original)
		family_guy.fully_replace_character_name(family_guy.real_name, family_guy.real_name + " " + GLOB.lordsurname)
		return family_guy.real_name
	var/list/chopped_name = splittext(family_guy.real_name, " ")
	if(length(chopped_name) > 1)
		family_guy.fully_replace_character_name(family_guy.real_name, chopped_name[1] + " " + GLOB.lordsurname)
	else
		family_guy.fully_replace_character_name(family_guy.real_name, family_guy.real_name + " " + GLOB.lordsurname)
	return family_guy.real_name

/mob/living/carbon/human/proc/grant_title_verb()
	set name = "Grant Title"
	set category = "Noble"

	noble_grant_title(src)



/mob/living/carbon/human/proc/grant_nobility_verb()
	set name = "Grant Nobility"
	set category = "Noble"

	noble_grant_nobility(src)



/mob/living/carbon/human/proc/recruit_guard_verb()
	set name = "Recruit Guardsman"
	set category = "Noble"

	noble_convert_role(
		src,
		"Watchman",
		"Watchman",
		"Will you serve as a town guard, %RECRUIT?",
		"FOR THE CROWN!",
		"I refuse.",
		3,
		PROC_REF(noble_guard_post)
	)



/proc/noble_guard_post(mob/living/carbon/human/recruit,mob/living/carbon/human/user)
	recruit.verbs |= /mob/proc/haltyell



/mob/living/carbon/human/proc/recruit_servant_verb()
	set name = "Recruit Servant"
	set category = "Noble"

	noble_convert_role(
		src,
		"Servant",
		"Servants",
		"Will you serve the crown, %RECRUIT?",
		"FOR THE KICHEN!",
		"I refuse."
	)



/mob/living/carbon/human/proc/recruit_warden_verb()
	set name = "Recruit Warden"
	set category = "Noble"

	noble_convert_role(
		src,
		"Warden",
		"Bog Guard",
		"Will you serve the Wardens, %RECRUIT?",
		"FOR THE GROVE!",
		"I refuse."
	)



/proc/noble_get_candidates(mob/living/carbon/human/user, range = 3, mode = "convert")
	var/list/candidates = list()

	for(var/mob/living/carbon/human/H in (get_hearers_in_view(range, user) - user))
		if(QDELETED(H))
			continue

		if(!H.mind)
			continue

		if(!H.get_face_name(null))
			continue

		switch(mode)
			if("convert")
				if(!(H.job in GLOB.peasant_positions) && \
					!(H.job in GLOB.burgher_positions) && \
					!(H.job in GLOB.wanderer_positions))
					continue

			if("nobility")
				if(HAS_TRAIT(H, TRAIT_DEFILED_NOBLE))
					continue

		candidates[H.name] = H

	return candidates



/proc/noble_convert_role(mob/living/carbon/human/user, new_role, faction_name, prompt_text, accept_text, refuse_text, range = 3, post_success = null)
	var/list/candidates = noble_get_candidates(user, range, "convert")

	if(!length(candidates))
		to_chat(user, span_warning("There are no potential recruits in range."))
		return FALSE

	var/inputty = input(user, "Select a recruit.", faction_name) as null|anything in candidates

	if(!inputty)
		return FALSE

	var/mob/living/carbon/human/recruit = candidates[inputty]

	if(QDELETED(recruit))
		return FALSE

	if(!(recruit in get_hearers_in_view(range, user)))
		return FALSE

	user.say(replacetext(prompt_text,"%RECRUIT","[recruit]"))

	var/choice = alert(
		recruit,
		"Do you wish to become a [new_role]?",
		"[faction_name] Recruitment",
		"Yes",
		"No"
	)

	if(QDELETED(user) || QDELETED(recruit))
		return FALSE

	if(!(user in get_hearers_in_view(range,recruit)))
		return FALSE

	if(choice != "Yes")
		if(refuse_text)
			recruit.say(refuse_text)
		return FALSE

	if(accept_text)
		recruit.say(accept_text)

	recruit.job = new_role

	if(post_success)
		call(post_success)(recruit,user)

	SEND_SIGNAL(SSdcs, COMSIG_GLOB_ROLE_CONVERTED, user, recruit, new_role)

	return TRUE



/proc/noble_grant_title(
	mob/living/carbon/human/user,
	range = 3,
	title_length = 42
)
	var/granted_title = input(user,"What title?","Grant Title") as null|text

	granted_title = reject_bad_text(granted_title,title_length)

	if(!granted_title)
		return FALSE

	var/list/candidates = noble_get_candidates(user, range)

	if(!length(candidates))
		return FALSE

	var/inputty = input(user,"Select honorary.") as anything in candidates

	if(!inputty)
		return FALSE

	var/mob/living/carbon/human/recruit = candidates[inputty]

	if(GLOB.lord_titles[recruit.real_name])
		user.say("I HEREBY STRIP YOU, [uppertext(recruit.name)], OF THE TITLE OF [uppertext(GLOB.lord_titles[recruit.real_name])]!")
		GLOB.lord_titles -= recruit.real_name
		return TRUE

	user.say("I HEREBY GRANT YOU, [uppertext(recruit.name)], THE TITLE OF [uppertext(granted_title)]!")

	GLOB.lord_titles[recruit.real_name] = granted_title
	return TRUE



/proc/noble_grant_nobility(
	mob/living/carbon/human/user,
	range = 3
)
	var/list/candidates = noble_get_candidates(user, range, "nobility")

	if(!length(candidates))
		return FALSE

	var/inputty = input(user,"Select target.") as anything in candidates

	if(!inputty)
		return FALSE

	var/mob/living/carbon/human/recruit = candidates[inputty]

	if(HAS_TRAIT(recruit,TRAIT_NOBLE))

		if(!(recruit.job in GLOB.foreign_positions))
			user.say("I HEREBY STRIP YOU, [uppertext(recruit.name)], OF NOBILITY!")

			REMOVE_TRAIT(recruit,TRAIT_NOBLE,TRAIT_GENERIC)
			REMOVE_TRAIT(recruit,TRAIT_NOBLE,TRAIT_VIRTUE)

			return TRUE

		to_chat(user,span_warning("Their nobility is not mine to strip!"))
		return FALSE

	user.say("I HEREBY GRANT YOU, [uppertext(recruit.name)], NOBILITY!")

	ADD_TRAIT(recruit,TRAIT_NOBLE,TRAIT_GENERIC)

	return TRUE
