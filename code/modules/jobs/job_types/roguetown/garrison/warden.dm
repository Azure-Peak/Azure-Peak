/datum/job/roguetown/warden
	title = "Warden"
	flag = WARDEN
	department_flag = GARRISON
	faction = "Station"
	total_positions = 4
	spawn_positions = 4

	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "You are a volunteer with the Wardens; a fraternity of rangers who keep a vigil over Azuria's untamed wilderness. \
				While you may not be a professional soldier, you nevertheless serve the Duchy as the first line of defense against outside threats. \
				Obey your Sergeant-at-Arms, the Marshal, and the Crown. Serve their will, and you will receive that which a Warden covets most - the comfort of the wilds, and freedom from the confines of the city's walls."

	display_order = JDO_WARDEN
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/warden
	advclass_cat_rolls = list(CTAG_WARDEN = 20)

	give_bank_account = TRUE
	min_pq = 0
	max_pq = null
	round_contrib_points = 2

	cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
	job_traits = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_WOODSMAN, TRAIT_SURVIVAL_EXPERT, TRAIT_EXPERT_HUNTER)
	job_subclasses = list(/datum/advclass/warden/warden)
	has_subprefs = FALSE // only one subclass

/datum/outfit/job/roguetown/warden
	neck = /obj/item/clothing/neck/roguetown/coif/padded
	cloak = /obj/item/clothing/cloak/wardencloak
	backl = /obj/item/storage/backpack/rogue/satchel
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	id = /obj/item/scomstone/bad/garrison
	job_bitflag = BITFLAG_GARRISON //Counts towards overall combat roles

/datum/advclass/warden/warden
	name = "Warden"
	tutorial = "You are a Warden; a guerilla beneath the Crown's command, a ranger of Azuria's sparsely populated woods, and the first line of defense against whatever foulness befalls this fief."
	extra_context = "Wardens receive a boost to Perception, Willpower, and Speed when traveling within the 'Azurian Grove' biome. When outside this biome, their statblock - compared to the Man-at-Arms - is slightly reduced."
	outfit = /datum/outfit/job/roguetown/warden/warden
	category_tags = list(CTAG_WARDEN)
	subclass_stats = list(
		STATKEY_PER = 2, //(4 with buff)
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 2, //(3 with buff)
		STATKEY_SPD = 1 //(2 with buff)
	)//8 points weighted, look at their buff to understand as to why.
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/warden/warden/pre_equip(mob/living/carbon/human/H)
	..()
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/warden_machete = 1,
		/obj/item/storage/keyring/warden = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/signal_horn = 1,
		/obj/item/hunting_map/boars = 1,
	)
	add_verb(H, /mob/proc/haltyell)
	H.set_blindness(0)

	if(!H.mind)
		return

	var/list/styles = list("Sentinel (Default)", "Guerilla (Stealth)", "Wyldcraft (Support)",)
	var/style = warden_prompt(H, styles, "Choose your STYLE.", "EVERY WARDEN HUNTS IN THEIR OWN WAY.")

	switch(style)
		if("Sentinel (Default)")
			apply_sentinel_style(H)
			to_chat(H, span_greenannounce("The watchful, the steadfast. You are the guardian of the wilds, the one who keeps the forest safe and its paths clear."))
		if("Wyldcraft (Support)")
			apply_wyldcraft_style(H)
			to_chat(H, span_greenannounce("The wise, the nurturing. You know the forest's secrets, its remedies, and how to keep your companions alive beneath its canopy."))
		if("Guerilla (Stealth)")
			apply_guerilla_style(H)
			to_chat(H, span_greenannounce("The silent, the cunning. You are one with the undergrowth, a hunter of hunters who strikes from where the forest itself hides you."))

	SStreasury.grant_savings(ECONOMIC_LOWER_MIDDLE_CLASS, H)

// Asks the player to pick from a list. If they close the window, the first option is used.
/datum/outfit/job/roguetown/warden/warden/proc/warden_prompt(mob/living/carbon/human/H, list/options, message, title)
	var/choice = input(H, message, title) as null|anything in options
	if(isnull(choice))
		return options[1]
	return choice

// SENTINEL - the classic Warden kit. No changes at all. This is intended to be the old reliable and baseline, it must ALWAYS be stronger than the sidegrades.
/datum/outfit/job/roguetown/warden/warden/proc/apply_sentinel_style(mob/living/carbon/human/H)
	var/list/armor_options = list("Light - Dodge Expert, Padded Gambeson", "Medium - Maille Training, Iron Hauberk")
	var/armor_choice = warden_prompt(H, armor_options, "Choose your ARMOR.", "PREPARE FOR THE HUNT-TO-COME.") //Like Skirmisher, you are not getting both. Choose wisely.
	switch(armor_choice)
		if("Light - Dodge Expert, Padded Gambeson")
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, JOB_TRAIT)
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
		if("Medium - Maille Training, Iron Hauberk")
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, JOB_TRAIT)
			wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron

	var/list/weapon_options = list("Bowhunter - Blackhorn Bow + 20 Broadheads", "Spearhunter - Spear + Sling, +I STR / -I SPD")
	var/weapon_choice = warden_prompt(H, weapon_options, "Choose your SPECIALITY.", "JACK OF MANY TRADES, MASTER OF NONE.")
	switch(weapon_choice)
		if("Bowhunter - Blackhorn Bow + 20 Broadheads")
			beltr = /obj/item/quiver/arrows
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/warden
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)
		if("Spearhunter - Spear + Sling, +I STR / -I SPD")
			beltr = /obj/item/quiver/sling/iron
			r_hand = /obj/item/rogueweapon/spear
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE)
			H.change_stat(STATKEY_SPD, -1)
			H.change_stat(STATKEY_STR, 1)

	choose_warden_headgear(H)

// WYLDCRAFT - Support kit sidegrade, terrible at direct combat, but makes the fort a little livelier. For the people who want to homeguard instead of going after trouble.
/datum/outfit/job/roguetown/warden/warden/proc/apply_wyldcraft_style(mob/living/carbon/human/H)
	//NO Armor Training at all! NO Dodge Expert! >>> They're Arcyne WITHOUT ward/spells! <<< That makes them NOT a mage! Think of them as some advanced Arcyne Potential.
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	//Very important! If danger BREATHES their way, they should fold!
	H.change_stat(STATKEY_CON, -2)
	H.change_stat(STATKEY_SPD, 1)
	//ALL their EXPERT skills are neutered to JMAN (except slings cos they get Levy's kiddy sling, cause that's funny)
	l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling/wood/bog
	beltr = /obj/item/quiver/sling/iron
	H.adjust_skillrank(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, SKILL_LEVEL_JOURNEYMAN, TRUE)
	//HOWEVER, they get a poke spell n fortifying vapors! And some other nerd shit that helps them maintain the fort.
	grant_poke_spell(H) // It will be this for now, but I'm planning to give them an unique, wood-based poke spell.
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fortifyingvapors)
	H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_EXPERT, TRUE)
	ADD_TRAIT(H, TRAIT_ARCYNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_SELF_RELIANCE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_JACKOFALLTRADES, JOB_TRAIT)
	//You don't get a fancy headgear, you're not worthy...
	head = /obj/item/clothing/head/roguetown/headband/monk
	mask = /obj/item/clothing/head/roguetown/roguehood/warden

// GUERILLA - Stealth kit sidegrade, worse at combat but good at information gathering or laying traps. For the people who just want to larp as actual spies and focus more on relaying info than being a frag machine.
/datum/outfit/job/roguetown/warden/warden/proc/apply_guerilla_style(mob/living/carbon/human/H)
	//NO Armor Training at all, too. This is the catch. Your only defense is how quiet you can be, or working that charisma to intimidate or enamorate your opponents! Roleplay, ser!
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	//Their main weapon is their speshul snowflake seax now. Tough luck on your kill potential, but you can at least defend yourself with it.
	H.adjust_skillrank(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, SKILL_LEVEL_JOURNEYMAN, TRUE)
	//You also get a smoke bomb because let's be real, you're screwed if you're caught.
	l_hand = /obj/item/bomb/smoke
	//Similar to your sibling above, if danger breathes your way, start praying.
	H.change_stat(STATKEY_CON, -2)
	H.change_stat(STATKEY_SPD, 1)
	//Your kit is really about outmaneuvering and escaping danger, really. You're just an info-gathering bean.
	H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_LEGENDARY, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_LEGENDARY, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_MASTER, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/engineering, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/traps, SKILL_LEVEL_EXPERT, TRUE)
	ADD_TRAIT(H, TRAIT_KEENEARS, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_PERFECT_TRACKER, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_BOMBER_EXPERT, JOB_TRAIT)
	//You barely made it through the final exams, so you get a cool headgear. You're like, the aura farmer who when danger goes your way you fold. But if you can keep that intimidation for looking like the other Wardens and don't make it come to blows, you should be fine, yeh.
	choose_warden_headgear(H)

// Helmet and shroud choice, shared by every style. Only TRUE wardens get this, if you are a wyldcraft chud, you failed the test for one reason or another, yet you're still useful for the creed.
/datum/outfit/job/roguetown/warden/warden/proc/choose_warden_headgear(mob/living/carbon/human/H)
	var/list/helmets = list(
		"Path of the Antelope" = /obj/item/clothing/head/roguetown/helmet/bascinet/antler,
		"Path of the Volf" = /obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf,
		"Path of the Ram" = /obj/item/clothing/head/roguetown/helmet/sallet/warden/goat,
		"Path of the Bear" = /obj/item/clothing/head/roguetown/helmet/sallet/warden/bear,
		"Path of the Rous" = /obj/item/clothing/head/roguetown/helmet/sallet/warden/rat,
		"None" = null,
	)
	var/helm_choice = warden_prompt(H, helmets, "Choose your HELMET.", "FOLLOW THE PATH OF YOUR ANCESTORS.")
	if(helmets[helm_choice])
		head = helmets[helm_choice]

	var/list/hoods = list(
		"Common Shroud" = /obj/item/clothing/head/roguetown/roguehood/warden,
		"Antlered Shroud" = /obj/item/clothing/head/roguetown/roguehood/warden/antler,
		"None" = null,
		)
	var/hood_choice = warden_prompt(H, hoods, "Choose your SHROUD.", "LEST THEY SEE THE WHITES OF YOUR EYES.")
	if(hoods[hood_choice])
		mask = hoods[hood_choice]

	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_LOWER_MIDDLE_CLASS, H)
