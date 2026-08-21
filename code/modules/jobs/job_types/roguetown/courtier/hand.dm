/datum/job/roguetown/hand
	title = "Hand"
	flag = HAND
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)	//No noble constructs.
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
	job_traits = list(TRAIT_NOBLE, TRAIT_EXPERT_HUNTER)
	vice_restrictions = list(/datum/charflaw/mute, /datum/charflaw/unintelligible, /datum/charflaw/wanted) //Needs to use the throat - sometimes
	job_subclasses = list(
		/datum/advclass/hand/blademaster,
		/datum/advclass/hand/spymaster,
		/datum/advclass/hand/advisor
	)

/datum/outfit/job/roguetown/hand
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/besilked
	wrists = /obj/item/clothing/wrists/roguetown/bracers/hand
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/scomstone/garrison/hand
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/hand/pre_equip(mob/living/carbon/human/H)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/agent)
	add_verb(H, /datum/job/roguetown/hand/proc/remember_agents)

/datum/job/roguetown/hand/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(L)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			GLOB.court_spymaster[H.real_name] = H
			addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, know_agents)), 5 SECONDS)

///////////
//CLASSES//
///////////

//Blademaster Hand start
/datum/advclass/hand/blademaster
	name = "Blademaster"
	tutorial = "You have played blademaster and strategist to the Noble-Family for so long that you are a master tactician, something you exploit with potent conviction. Let no man ever forget whose ear you whisper into. You've killed more men with swords than any spymaster could ever claim to."
	outfit = /datum/outfit/job/roguetown/hand/blademaster
	category_tags = list(CTAG_HAND)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 3,
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_LCK = 1, //less lucky than the rest... go figure
	)
	age_mod = /datum/class_age_mod/hand_blademaster
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/hand/blademaster/pre_equip(mob/living/carbon/human/H)
	backr = /obj/item/storage/backpack/rogue/satchel/short
	belt = /obj/item/storage/belt/rogue/leather/steel
	r_hand = /obj/item/rogueweapon/sword/long/hand
	beltr = /obj/item/rogueweapon/scabbard/sword/royal
	head = /obj/item/clothing/head/roguetown/chaperon/noble/hand
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hand
	pants = /obj/item/clothing/under/roguetown/tights/black
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/dtace = 1,
		/obj/item/rogueweapon/scabbard/sheath/royal = 1,
		/obj/item/storage/keyring/lord = 1,
		/obj/item/roguekey/skeleton = 1,
		/obj/item/hunting_map/white_stag = 1,
	)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_RICH, H)


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
		STATKEY_LCK = 2,
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
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER, // not like they're gonna break into the vault.
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)

//Spymaster start. More similar to the rogue adventurer - loses heavy armor and sword skills for more sneaky stuff.
/datum/outfit/job/roguetown/hand/spymaster/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hand/spymaster
	backr = /obj/item/storage/backpack/rogue/satchel/short/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/rogueweapon/scabbard/sheath/noble
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/dtace = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying/hand = 1,
		/obj/item/storage/keyring/lord = 1,
		/obj/item/roguekey/skeleton = 1,
		/obj/item/lockpickring/mundane = 1,
	)
	if(H.dna.species.type in NON_DWARVEN_RACE_TYPES)
		cloak = /obj/item/clothing/cloak/half/shadowcloak/spymaster
		gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/spymaster
		mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask/spymaster
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/spymaster
	else
		cloak = /obj/item/clothing/cloak/raincloak/mortus //cool spymaster cloak
		pants = /obj/item/clothing/under/roguetown/tights/black
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_RICH, H)

//Advisor Start
/datum/advclass/hand/advisor
	name = "Advisor"
	tutorial = " You have played researcher and confidant to the Noble-Family for so long that you are a vault of knowledge, something you exploit with potent conviction. Let no man ever forget the knowledge you wield. You've read more books than any blademaster or spymaster could ever claim to."
	outfit = /datum/outfit/job/roguetown/hand/advisor
	category_tags = list(CTAG_HAND)
	traits_applied = list(TRAIT_ALCHEMY_EXPERT, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 3,
		STATKEY_SPD = 1,
		STATKEY_WIL = 1,
		STATKEY_LCK = 2,
	)
	age_mod = /datum/class_age_mod/hand_advisor
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 2, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN, //they get the whole cane sword, they should use the whole cane sword
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN,
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
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/hand/advisor
	backr = /obj/item/storage/backpack/rogue/satchel/short
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hand/advisor
	r_hand = /obj/item/rogueweapon/sword/rapier/hand
	beltr = /obj/item/rogueweapon/scabbard/sheath/courtphysician/hand
	beltl = /obj/item/rogueweapon/huntingknife/idagger/dtace
	head = /obj/item/clothing/head/roguetown/chaperon/noble/hand
	pants = /obj/item/clothing/under/roguetown/tights/black

//Advisor start. Trades combat skills for more knowledge and skills - for older hands, hands that don't do combat - people who wanna play wizened old advisors.
/datum/outfit/job/roguetown/hand/advisor/pre_equip(mob/living/carbon/human/H)
	backpack_contents = list(
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/keyring/lord = 1,
		/obj/item/roguekey/skeleton = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,//starts with a vial of poison, like all wizened evil advisors do!
		/obj/item/rogueweapon/spellbook = 1,
	)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_RICH, H)

////////////////////
///SPELLS & VERBS///
////////////////////


/mob/living/carbon/human/proc/know_agents()
	if(!GLOB.court_agents.len)
		to_chat(src, span_boldnotice("I currently have no agents."))
	else
		to_chat(src, span_boldnotice("I currently have these agents:"))
		for(var/name in GLOB.court_agents)
			to_chat(src, span_greentext(name))
			var/mob/living/carbon/human/agent = GLOB.court_agents[name]
			if(agent && istype(agent) && agent.mind)
				agent.mind.i_know_person(src)
				src.mind.i_know_person(agent)

/datum/job/roguetown/hand/proc/remember_agents()
	set name = "Remember Agents"
	set category = "RoleUnique.Voice of Command"

	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	H.know_agents()
	return

/obj/effect/proc_holder/spell/self/convertrole/agent
	name = "Recruit Agent"
	new_role = "Court Agent"//They get shown as adventurers either way.
	overlay_state = "recruit_servant"
	recruitment_faction = "Agents"
	recruitment_message = "Serve the crown, %RECRUIT."
	accept_message = "For the crown."//We no longer shout because we aren't stupid
	refuse_message = "I refuse."
	recharge_time = 100

/obj/effect/proc_holder/spell/self/convertrole/agent/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(!.)
		return
	GLOB.court_agents[recruit.real_name] = recruit
	add_verb(recruit, /datum/job/roguetown/adventurer/courtagent/proc/remember_employer)

///////////////
//AGENT FILES//
///////////////

/obj/item/hand_files
	name = "\improper sheaf of parchment" // innocuous to the casual observer
	dropshrink = 0.8
	desc = "A bound stack of papers. Each one contains details on an Agent of the Court. Useful to a spymaster, invaluable to an enemy of the Crown."
	var/current_agent
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "manuscript"
	dir = WEST

/obj/item/hand_files/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use the files in your hand to read them. They will update automatically if more agents join the round.")
	. += span_info("Be very careful with these: if you lose them, you can't get more!")

/obj/item/hand_files/attack_self(mob/user)
	. = ..()
	if(!length(GLOB.court_agents))
		to_chat(user, span_warning("Your files lie fallow; none of your agents are active in the region at the mote."))
		return
	refresh_window(user)

/obj/item/hand_files/proc/refresh_window(mob/user)
	user << browse_rsc('html/book.png')
	if(!current_agent) // display a table-of-contents menu
		var/HTML = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html><head><style type=\"text/css\">
			body { background-image:url('book.png');background-repeat: repeat; }</style></head><body scroll=yes><div style='
			font-family: Georgia, Times New Roman, serif;
			padding: 16px;
			max-width: 800px;
			margin: auto;
			color: black;'><h2 style='margin: 4px; padding:0px;'>Hand's Files: Agents of the Court</h2><hr/><b>Current agents:</b>"}
		for(var/realname in GLOB.court_agents)
			HTML += "<br><a href='?src=[REF(src)];agent=[realname]'>[realname]</a>"
		HTML += "<a href='?src=[REF(src)];close=1' style='position:absolute;right:15px;bottom:15px'>Close</a></div></body></html>"
		user << browse(HTML, "window=hand_files;size=550x450;can_resize=1")
	else
		var/mob/living/carbon/human/agent = GLOB.court_agents[current_agent]
		if(!agent || !istype(agent) || !agent.mind)
			to_chat(user, span_warning("Invalid agent. This is a bug."))
			return
		var/list/agent_prefs = agent.mind.job_subprefs["Court Agent"]
		if(!length(agent_prefs))
			to_chat(user, span_warning("Invalid agent prefs. This is a bug."))
			return
		var/codename = agent_prefs["codename"]
		var/hand_notes_html = agent_prefs["hand_file_notes"]

		var/list/d_list = agent.get_mob_descriptors()
		var/trait_desc = "[capitalize(build_coalesce_description_nofluff(d_list, agent, list(MOB_DESCRIPTOR_SLOT_TRAIT), "%DESC1%"))]"
		var/stature_desc = "[capitalize(build_coalesce_description_nofluff(d_list, agent, list(MOB_DESCRIPTOR_SLOT_STATURE), "%DESC1%"))]"
		var/descriptor_name = "[trait_desc] [stature_desc]"
		var/HTML = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type=\"text/css\">
					body { background-image:url('book.png');background-repeat: repeat; color: #14103f}</style></head><body scroll=yes>
					<div style='
			font-family: Georgia, Times New Roman, serif;
			padding: 16px;
			max-width: 800px;
			margin: auto;
			color: black;'>
					<h2 style='margin: 4px; padding:0px;'>Agent File: [current_agent]</h2><hr>
			<b>Agent Name:</b> [current_agent]<br/>[codename ? "<b>Codename:</b> [codename]<br/>":""][(descriptor_name!= " ") ? "<b>Appearance:</b> [descriptor_name]<br/>" : ""]<b>Profession:</b> [agent.get_role_title()]
			<hr/>
			[hand_notes_html]
			<hr/>
			<a href='?src=[REF(src)];back=1' style='position:absolute;left:15px;bottom:15px'>Back</a><a href='?src=[REF(src)];close=1' style='position:absolute;right:15px;bottom:15px'>Close</a></div></body></html>"}

		user << browse(HTML, "window=hand_files;size=550x450;can_resize=1")

/obj/item/hand_files/Topic(href, href_list)
	. = ..()
	if(href_list["close"])
		usr << browse(null, "window=hand_files")
	if(href_list["back"])
		current_agent = null
		refresh_window(usr)
	if(href_list["agent"])
		current_agent = href_list["agent"]
		refresh_window(usr)
