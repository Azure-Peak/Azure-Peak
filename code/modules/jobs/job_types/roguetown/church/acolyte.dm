/datum/job/roguetown/monk
	title = "Acolyte"
	flag = ACOLYTE
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 6
	spawn_positions = 6

	forbidden_races = list(RACES_DESPISED)
	allowed_patrons = ALL_DIVINE_PATRONS
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/monk
	tutorial = "Chores, some more chores- Even more chores.. Oh how the life of a humble acolyte is exhausting… You have faith, but even you know you gave up a life of adventure for that of the security in the Church. Assist the Bishop in their daily tasks, maybe today will be the day something interesting happens."

	display_order = JDO_ACOLYTE
	give_bank_account = TRUE
	min_pq = 1 //A step above sexton, should funnel new players to the sexton role to learn miracles at a more sedate pace
	max_pq = null
	round_contrib_points = 5

	//No nobility for you, being a member of the clergy means you gave UP your nobility. It says this in many of the church tutorial texts.
	virtue_restrictions = list(/datum/virtue/utility/noble)
	job_traits = list(TRAIT_RITUALIST, TRAIT_GRAVEROBBER, TRAIT_HOMESTEAD_EXPERT, TRAIT_CLERGY)
	advclass_cat_rolls = list(CTAG_ACOLYTE = 2)
	job_subclasses = list(
		/datum/advclass/acolyte
	)

/datum/advclass/acolyte
	name = "Acolyte"
	tutorial = "Chores, some more chores- Even more chores.. Oh how the life of a humble acolyte is exhausting… You have faith, but even you know you gave up a life of adventure for that of the security in the Church. Assist the Bishop in their daily tasks, maybe today will be the day something interesting happens."
	outfit = /datum/outfit/job/roguetown/monk/basic
	subclass_languages = list(/datum/language/grenzelhoftian)
	category_tags = list(CTAG_ACOLYTE)
	traits_applied = list(TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1
	)
	age_mod = /datum/class_age_mod/acolyte
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
	)

/datum/outfit/job/roguetown/monk
	name = "Acolyte"
	jobtype = /datum/job/roguetown/monk
	has_loadout = TRUE
	job_bitflag = BITFLAG_HOLY_WARRIOR
	allowed_patrons = list(/datum/patron/divine/undivided, /datum/patron/divine/pestra, /datum/patron/divine/astrata, /datum/patron/divine/eora, /datum/patron/divine/noc, /datum/patron/divine/necra, /datum/patron/divine/abyssor, /datum/patron/divine/malum, /datum/patron/divine/ravox, /datum/patron/divine/xylix) // The whole Ten. Probably could delete this now, actually.

/datum/outfit/job/roguetown/monk/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	belt = /obj/item/storage/belt/rogue/leather/rope/cleric
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/storage/keyring/acolyte
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/ritechalk = 1, 
		/obj/item/mini_flagpole/church = 1,
		/obj/item/paper/clerical_info/holysee = 1,
		/obj/item/needle = 1, //Regular needle
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1, //Buy more off of the clinic or use water, stabilising people
		/obj/item/natural/bundle/cloth/bandage/full = 1, //Needed to keep people from bleeding out dead
		)
	H.cmode_music = 'sound/music/cmode/church/combat_acolyte.ogg' // has to be defined here for the selection below to work. sm1 please rewrite cmusic to apply pre-equip.
	switch(H.patron?.type)
		if(/datum/patron/divine/undivided)
			head = /obj/item/clothing/head/roguetown/roguehood/undivided
			neck = /obj/item/clothing/neck/roguetown/psicross/undivided
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/undivided
			cloak = /obj/item/clothing/cloak/undivided
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
		if(/datum/patron/divine/astrata)
			head = /obj/item/clothing/head/roguetown/roguehood/astrata
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
		if(/datum/patron/divine/noc)
			head = /obj/item/clothing/head/roguetown/roguehood/nochood
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
			wrists = /obj/item/clothing/wrists/roguetown/nocwrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/noc // this robe is broken unless its in the cloak slot
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
		if(/datum/patron/divine/abyssor) // the deep calls!
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			pants = /obj/item/clothing/under/roguetown/tights
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor
			head = /obj/item/clothing/head/roguetown/roguehood/abyssor
		if(/datum/patron/divine/dendor) //Dendorites all busted. Play Druid.
			head = /obj/item/clothing/head/roguetown/dendormask
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded // Kunai: I think I'll give them a weak ass skin srmor later, once that PR is merged, for the nudist theme
		if(/datum/patron/divine/necra)
			head = /obj/item/clothing/head/roguetown/necrahood
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			shoes = /obj/item/clothing/shoes/roguetown/boots
			pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/necra
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			cloak = /obj/item/clothing/cloak/raincloak/mortus
			var/list/necra_tools = list("Silver Shovel", "Silver Scythe")
			var/tool_choice = input(H, "A reaper, or a digger?", "HOW WILL YOU APPEASE THE UNDERMAIDEN?") as anything in necra_tools
			switch(tool_choice) // choose wisely... larp or effectiveness?
				if("Silver Shovel")
					backr = /obj/item/rogueweapon/shovel/silver
				if("Silver Scythe") // o lawd we farmin
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					l_hand = /obj/item/rogueweapon/scythe/silver
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
			head = /obj/item/clothing/head/roguetown/roguehood/phys
			shoes = /obj/item/clothing/shoes/roguetown/boots
			pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
			cloak = /obj/item/clothing/cloak/templar/pestran
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			l_hand = /obj/item/storage/belt/rogue/surgery_bag
		if(/datum/patron/divine/eora) //Eora content from Stonekeep
			head = /obj/item/clothing/head/roguetown/eoramask
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			cloak = /obj/item/clothing/cloak/templar/eoran
			r_hand = /obj/item/rogueweapon/huntingknife/scissors
			l_hand = /obj/item/needle/thorn
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			var/robes = list("Modest","Exposed")
			var/robe_choice = input(H, "Choose your ROBES.", "TAKE UP ROBES.") as anything in robes
			switch(robe_choice) // This feels wrong to do but I am unsure how else to do it
				if("Modest")
					armor = /obj/item/clothing/suit/roguetown/shirt/robe/eora
				if("Exposed")
					armor = /obj/item/clothing/suit/roguetown/shirt/robe/eora/alt
		if(/datum/patron/divine/malum)
			head = /obj/item/clothing/head/roguetown/roguehood
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
			shoes = /obj/item/clothing/shoes/roguetown/boots
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			pants = /obj/item/clothing/under/roguetown/trou
			cloak = /obj/item/clothing/cloak/templar/malumite
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
		if(/datum/patron/divine/ravox)
			head = /obj/item/clothing/head/roguetown/roguehood/ravox
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
			cloak = /obj/item/clothing/cloak/templar/ravox
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/boots
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/ravox
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			l_hand = /obj/item/rope/chain
		if(/datum/patron/divine/xylix)
			head = /obj/item/clothing/head/roguetown/roguehood/black
			cloak = /obj/item/clothing/cloak/templar/xylixian
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/black
			neck = /obj/item/clothing/neck/roguetown/psicross/xylix
			H.cmode_music = 'sound/music/combat_jester.ogg'
			var/datum/inspiration/I = new /datum/inspiration(H)
			I.grant_inspiration(H, bard_tier = BARD_T2)
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			if(H.mind)
				var/instruments = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman", "Psyaltery", "Flute", "Drum", "Shamisen")
				var/instrument_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", instruments)
				H.set_blindness(0)
				switch(instrument_choice)
					if("Harp")
						backr = /obj/item/rogue/instrument/harp
					if("Lute")
						backr = /obj/item/rogue/instrument/lute
					if("Accordion")
						backr = /obj/item/rogue/instrument/accord
					if("Guitar")
						backr = /obj/item/rogue/instrument/guitar
					if("Hurdy-Gurdy")
						backr = /obj/item/rogue/instrument/hurdygurdy
					if("Viola")
						backr = /obj/item/rogue/instrument/viola
					if("Vocal Talisman")
						backr = /obj/item/rogue/instrument/vocals
					if("Psyaltery")
						backr = /obj/item/rogue/instrument/psyaltery
					if("Flute")
						backr = /obj/item/rogue/instrument/flute
					if("Drum")
						backr = /obj/item/rogue/instrument/drum
					if("Shamisen")
						backr = /obj/item/rogue/instrument/shamisen
		else
			head = /obj/item/clothing/head/roguetown/roguehood/astrata
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast)
	// -- End of section for god specific bonuses --
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_LOWER_MIDDLE_CLASS, H)

/datum/outfit/job/roguetown/monk/basic/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	// -- Start of section for god specific bonuses --
	if(H.patron?.type == /datum/patron/divine/undivided)
		H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/astrata) // Light and Guidance - Like ravox, they probably can endure seeing some shit.
		H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
	if(H.patron?.type == /datum/patron/divine/noc) // Arcyne and Knowledge - Probably good at reading and the other arcyne adjacent stuff.
		H.adjust_skillrank(/datum/skill/misc/reading, SKILL_LEVEL_JOURNEYMAN, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
		H.adjust_skillrank(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE) // for their arcane spells, very little CDR and cast speed.
		if(H.mind)
			H.mind.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)
		ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC) // So that they can take arcyne potential and not break.
	if(H.patron?.type == /datum/patron/divine/abyssor) // The Sea and Weather - probably would be good at fishing
		H.adjust_skillrank(/datum/skill/labor/fishing, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
		ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
		H.grant_language(/datum/language/abyssal)
	if(H.patron?.type == /datum/patron/divine/necra) // Death and Moving on - grave diggers.
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_APPRENTICE, TRUE) // digging graves and carrying bodies builds muscles probably.
		H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
	if(H.patron?.type == /datum/patron/divine/pestra) // Medicine and Healing - better surgeons and alchemists
		H.adjust_skillrank(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/alchemy, SKILL_LEVEL_NOVICE, TRUE)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/eora) // Beauty and Love - beautiful and can read people pretty well.
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		// 90% of eorans i see are farming to tend to their tree and/or cooking. they also get sewing -- arts and crafts.
		H.adjust_skillrank(/datum/skill/craft/sewing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, SKILL_LEVEL_NOVICE, TRUE)
	if(H.patron?.type == /datum/patron/divine/malum) // Craft and Creativity - they can make stuff.
		ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
		H.adjust_skillrank(/datum/skill/craft/blacksmithing, SKILL_LEVEL_APPRENTICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
		H.adjust_skillrank(/datum/skill/labor/lumberjacking, SKILL_LEVEL_APPRENTICE, TRUE)
	if(H.patron?.type == /datum/patron/divine/ravox) // Justice and Honor - athletics and probably a bit better at handling the horrors of war
		H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank(/datum/skill/combat/staves, SKILL_LEVEL_NOVICE, TRUE) //On par with an Adventuring Monk. Seems quite fitting.
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/xylix)  // Trickery and Inspiration - muxic and rogueish skills
		H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/music, SKILL_LEVEL_EXPERT, TRUE)

//Since acolytes are the mainstray of clerics, we'll keep the itemfile here.
//Once this becomes more solid this'll be moved to its own file, likely with the quicksilver slip too in a small refactor.

/obj/item/paper/clerical_info //TODO, Psydonic varient. Won't do ascendant, assume they infiltrated the golden/silver orders or something.
	name = "Clerical Missive"
	desc = "A letter from some holy Order. It smells of alchemical herbs and jackberries."
	info = {"
		<font face=\"Segoe Script\" color=#00000>Greetings to ye, distant missionaries in Azuria<br><br>This missive serves to inform of a the basics of your role under 
		Pestra's service in the eyes of the Ten.<br><br>
		You firstly will want to make sure that you sew up all of the patient's injuries, should you have an inspection hammer or your patronage hath blessed thou with 
		Pestra's hallowed rite of inspection, you will want to check the patient's injuries. <br><br>
		Remember, if the injuries are few and far between to grab their wounds to apply pressure, this will stem the flow of lyfesblood from their veins and in some cases assist with its clotting. <br><br>
		Ensure that all of these are tended that all of their wounds are sewed tight, apply a vigorous dressing of sultures and miracles to ensure that all fractures and bleeding of the patient are dealt with. <br><br>
		In the case they only stirr for a moment they are lykely a follower of Psydon, in which case proceede with regular surgery intervention.<br><br>
		If you lack such a kit or medicine training, refer them to another more talented individual or should the case be outdoors 
		in the wilderness where such is not safe, apply a bottle of greater or lesser lyfesblood, also known as health potions, or "red" as commonly nicknamed throughout Psydonia. <br><br>
		Should you have a surgery kit and the training, proceed with a scapel, then apply a retractor and forecepts, you will then want to apply either another set of forecepts or a needle 
		and begin to attend the applicable injuries at hand, during this time ensure no miracles are cast upon the patient, if the patient has fractures however, you will want to apply a bone-setter as well to set the bones. <br><br>
		This may take a bit to properly set once the surgery is done, so make sure to try to set every limb, giving the patient tyme to recover once fully tended. <br><br> <br><br>
		Now should you be capable of it, or another you will want to cast anastasis upon the fallen.<br><br>
		Should you forget, remember to cast it upon yourself so the divine may remynd you of the ritual at cost, your patron under the eyes of the Divine will be most benovolent, proof that the Ten undivided are O' so
		hallowed and humbled by such a duty as of yours, if however you worship the Undermaiden and know the rituals, proceed with a ritual of Necra and a toll.<br><br>
		Ensure your patient is fully stable and alwaes adminster water before reviving, once your patient is revived and given a health dosage of water they should recover swiftly.<br><br>
		If all of these steps are done right and they aren't experiencing sudden poisoning from lack of a liver, then they are ready to set loose once more, ensure that they get some rest 
		the Inn or prayer upon the pews is oft a good place of resting to ensure that they do not blunder into an early demise once more. <br><br> <br><br>
		May the Gods watch over you and your flock.</font>
		"}

/obj/item/paper/clerical_info/holysee //Same detail, different flavor
	name = "See Clinical Missive"
	desc = "A letter from the Holy See of Grenzelhoft. It smells of copper and alchemical herbs."
