/datum/advclass/noble
	name = "Aristocrat"
	tutorial = "You are a traveling noble visiting the lands of Azure Peak's dutchy. With wealth, come the poor, ready to pilfer you of your hard earned (inherited) coin, so tread lightly unless you want to meet a grizzly end."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	outfit = /datum/outfit/job/roguetown/adventurer/noble
	traits_applied = list(TRAIT_NOBLE, TRAIT_NUTCRACKER)
	noble_income = 15
	class_select_category = CLASS_CAT_NOBLE
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)

	subclass_stats = list(
		STATKEY_PER = 1,
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_NOVICE,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	) //Less spawn siega clutter, also makes sense you'd have a named mount.
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE

	extra_context = "This subclass has different regional loadouts with some locked behind species (drow), your skills + traits + stats further differ based on proficiency picked."

/datum/outfit/job/roguetown/adventurer/noble/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/evil] //Aurafarming
	H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/haughty]
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/gold
	if(H.mind)
		var/clothing = list("Classic - Nowhere Significant", "Azuria", "Grenzelhoft", "Otava", "Aavnr", "Ranesheni", "Gronn", "Etrusca", "Naledi", "Kazengun")
		if(is_species(H, /datum/species/elf/dark) || is_species(H, /datum/species/dullahan)) //Species Exclusive Options -> Drow Underdark House
			clothing += "Underdark" //dullahan are only included for oversights/downstreams where they might be able to roll for this.
		//if(is_species(H, /datum/species/kobold) || is_species(H, /datum/species/dracon)) //Species Exclusive Options -> Lirvan
			//clothing += "Lirvan" EXCLUDED for now cause of content lacking. If you ever want to add this, de-comment this.
		var/clothing_choice = input(H, "Choose your clothing style.", "FROM WHERE DOTH YOUR HOUSE HAIL FROM?") as anything in clothing
		switch(clothing_choice)
			if("Classic - Nowhere Significant") //Sovl, arguably the /worst/ gear-wise but it STAYS because its the OG loadout.
				if(should_wear_masc_clothes(H))
					cloak = /obj/item/clothing/cloak/half/red
					shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
					pants = /obj/item/clothing/under/roguetown/tights/black
					shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
					head = /obj/item/clothing/head/roguetown/fancyhat
				if(should_wear_femme_clothes(H))
					shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/purple
					cloak = /obj/item/clothing/cloak/raincloak/purple
					shoes = /obj/item/clothing/shoes/roguetown/boots
					head = /obj/item/clothing/head/roguetown/hatblu
				backl = /obj/item/storage/backpack/rogue/satchel
				belt = /obj/item/storage/belt/rogue/leather/black
				beltr = /obj/item/flashlight/flare/torch/lantern
				id = /obj/item/clothing/ring/silver
				H.cmode_music = 'sound/music/combat_noble.ogg'
			if("Azuria")
				if(should_wear_masc_clothes(H))
					shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
					armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor/nightman
					pants = /obj/item/clothing/under/roguetown/trou/beltpants
					shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
				if(should_wear_femme_clothes(H))
					shirt = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/triumph/azure
					shoes = /obj/item/clothing/shoes/roguetown/boots
				cloak = /obj/item/clothing/cloak/half/azure
				head = /obj/item/clothing/head/roguetown/chaperon/noble
				gloves = /obj/item/clothing/gloves/roguetown/leather/black
				backl = /obj/item/storage/backpack/rogue/satchel/black
				belt = /obj/item/storage/belt/rogue/leather/plaquesilver //On-part with courtier noblilty
				beltr = /obj/item/flashlight/flare/torch/lantern
				id = /obj/item/clothing/ring/silver
				H.cmode_music = 'sound/music/combat_squire.ogg'
				//No unique language cause true Azurian-Origin Azurians know the tongue. Keeps the idea of foreign marrages, same courts
			if("Underdark") //Matron vs halfcloak fits
				if(should_wear_masc_clothes(H))
					cloak = /obj/item/clothing/cloak/half
					shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
				if(should_wear_femme_clothes(H))
					cloak = /obj/item/clothing/cloak/matron //SOVL NUKE
					shoes = /obj/item/clothing/shoes/roguetown/boots
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/shadowrobe //Worse varient found in dungeons
				pants = /obj/item/clothing/under/roguetown/trou/shadowpants //Unarmored varient
				mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask/delf
				gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves //Unarmored varient
				backl = /obj/item/storage/backpack/rogue/satchel/black
				belt = /obj/item/storage/belt/rogue/leather/plaquegold/steward
				beltr = /obj/item/flashlight/flare/torch/lantern
				id = /obj/item/clothing/ring/gold
				H.cmode_music = 'sound/music/combat_delf.ogg'
				change_origin(H, /datum/virtue/origin/racial/underdark) //Yeah obviously
			if("Grenzelhoft") //Half-cloak and gilded shirt, or Dress and Cloak
				if(should_wear_masc_clothes(H))
					cloak = /obj/item/clothing/cloak/half/red
					shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
				if(should_wear_femme_clothes(H))
					shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
					cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
				shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
				head = /obj/item/clothing/head/roguetown/grenzelhofthat/triumph
				gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
				belt = /obj/item/storage/belt/rogue/leather/plaquegold/steward
				beltr = /obj/item/flashlight/flare/torch/lantern
				id = /obj/item/clothing/ring/blacksteel //Most Grenzelhoftian ass ring you can get
				neck = /obj/item/clothing/neck/roguetown/psicross/undivided //The Ten Undivided!
				H.cmode_music = 'sound/music/combat_grenzelhoft.ogg'
				H.grant_language(/datum/language/grenzelhoftian) //Duh
				backl = /obj/item/storage/backpack/rogue/satchel/black
			if("Otava") //Shoulder-Cloak or Silk Coat
				if(should_wear_masc_clothes(H))
					cloak = /obj/item/clothing/cloak/thief_cloak/yoruku
					shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
				if(should_wear_femme_clothes(H))
					armor = /obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown/aristocratotava
				shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				head = /obj/item/clothing/head/roguetown/chaperon/noble/aristocratotava
				gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
				belt = /obj/item/storage/belt/rogue/leather/plaquesilver
				beltr = /obj/item/flashlight/flare/torch/lantern
				id = /obj/item/clothing/ring/signet
				wrists = /obj/item/clothing/neck/roguetown/psicross //Purity afloat!
				H.cmode_music = 'sound/music/combat_inqcommander.ogg' //ENDVRE
				H.grant_language(/datum/language/otavan) //Duh
				backl = /obj/item/storage/backpack/rogue/satchel/otavan
			if("Aavnr") //Gender Neutral Fit Mostly
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				head = /obj/item/clothing/head/roguetown/papakha
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/aristocratavar
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
				gloves = /obj/item/clothing/gloves/roguetown/angle
				belt = /obj/item/storage/belt/rogue/leather/steel
				beltr = /obj/item/flashlight/flare/torch/lantern
				id = /obj/item/clothing/ring/silver
				neck = /obj/item/clothing/neck/roguetown/psicross/reform //God is dead but I still follow his word!
				H.cmode_music = 'sound/music/frei_lancer.ogg'
				H.grant_language(/datum/language/aavnic) //Duh
				backl = /obj/item/storage/backpack/rogue/satchel/black
			if("Ranesheni") //Gender Neutral Fit Mostly (To avoid excessive mechanical differences)
				if(should_wear_masc_clothes(H))
					armor = /obj/item/clothing/cloak/tabard/stabard/dungeon
				if(should_wear_femme_clothes(H))
					armor = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/triumph/raneshen
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/raneshen //Shittier version with regular gambeson protection levels
				pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen
				gloves = /obj/item/clothing/gloves/roguetown/angle
				head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab
				belt = /obj/item/storage/belt/rogue/leather/shalal
				cloak = /obj/item/clothing/cloak/half/rider/red
				beltr = /obj/item/flashlight/flare/torch/lantern
				//No ring cause its the best fit for armor - unintended but w/e
				H.cmode_music = 'sound/music/combat_desertrider.ogg'
				H.grant_language(/datum/language/raneshi) //Duh
				backl = /obj/item/storage/backpack/rogue/satchel/black
			if("Gronn") //Noble dress or rugged cloak and hat, nordic-esc nobility
				if(should_wear_masc_clothes(H))
					shirt = /obj/item/clothing/suit/roguetown/shirt/tunic
					gloves = /obj/item/clothing/gloves/roguetown/angle/gronn
					cloak = /obj/item/clothing/cloak/darkcloak/minotaur
					belt = /obj/item/storage/belt/rogue/leather/battleskirt/barbarian
				if(should_wear_femme_clothes(H))
					armor = /obj/item/clothing/suit/roguetown/shirt/dress/velvetdress
					gloves = /obj/item/clothing/gloves/roguetown/angle
					cloak = /obj/item/clothing/cloak/raincloak/furcloak
					belt = /obj/item/storage/belt/rogue/leather/cloth/upgraded/lady
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
				pants = /obj/item/clothing/under/roguetown/trou/leather/gronn
				beltr = /obj/item/flashlight/flare/torch/lantern
				H.cmode_music = 'sound/music/combat_vagarian.ogg'
				H.grant_language(/datum/language/gronnic) //Duh
				H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior] //Barbaric nobles
				H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]
				backl = /obj/item/storage/backpack/rogue/satchel
				switch(H.patron?.type) //If you are in the gronnic pantheon, you get a lucky charm.
					if(/datum/patron/inhumen/zizo)
						neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
					if(/datum/patron/inhumen/graggar)
						neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
					if(/datum/patron/inhumen/matthios)
						neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
					if(/datum/patron/inhumen/baotha)
						neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/baothagronn
					if(/datum/patron/divine/abyssor)
						neck = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
					if(/datum/patron/divine/dendor)
						neck = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn
					else
						neck = null //fallback is nothing, heretic
			if("Etrusca") //Somewhat placeholdery
				if(should_wear_masc_clothes(H))
					cloak = /obj/item/clothing/cloak/half/rider/orange
					shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
				if(should_wear_femme_clothes(H))
					cloak = /obj/item/clothing/cloak/half/orange
					shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
				pants = /obj/item/clothing/under/roguetown/trou/shadowpants
				mask = /obj/item/alch/rosa //SOVL
				shoes = /obj/item/clothing/shoes/roguetown/boots
				head = /obj/item/clothing/head/roguetown/duelhat/aristocrat
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				belt = /obj/item/storage/belt/rogue/leather/plaquesilver
				beltr = /obj/item/flashlight/flare/torch/lantern
				id = /obj/item/clothing/ring/gold
				H.cmode_music = 'sound/music/frei_lancer.ogg'
				H.grant_language(/datum/language/etruscan) //Duh
				backl = /obj/item/storage/backpack/rogue/satchel/black
			if("Naledi") //100% Gender neutral fit, just like the warscholars and refugees
				var/list/hmm = list("I left for a reason... (Default)", "The Djinn could be anywhere! (Naledi Complex)")
				var/complex = input(H, "How tightly bound to traditions you are?", "I HATE DJINNS!") as anything in hmm
				armor = /obj/item/clothing/cloak/tabard/stabard/dungeon
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian
				pants = /obj/item/clothing/under/roguetown/skirt/black
				shoes = /obj/item/clothing/shoes/roguetown/sandals
				head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black
				belt = /obj/item/storage/belt/rogue/leather/plaquegold/steward
				beltr = /obj/item/flashlight/flare/torch/lantern
				wrists = /obj/item/clothing/neck/roguetown/psicross/naledi
				neck = /obj/item/clothing/neck/roguetown/psicross/g //Not warded or anything, just raw psydonic status vs ring
				H.cmode_music = 'sound/music/warscholar.ogg'
				H.grant_language(/datum/language/celestial) //Yes
				backl = /obj/item/storage/backpack/rogue/satchel/black
				switch(complex)
					if("The Djinn could be anywhere! (Naledi Complex)")
						ADD_TRAIT(H, TRAIT_NALEDI, TRAIT_GENERIC) //Inconvenience for no benefit than flavor
						mask = /obj/item/clothing/mask/rogue/lordmask/naledi
					else
						mask = /obj/item/clothing/mask/rogue/lordmask/tarnished
			if("Kazengun") //Placeholdery until we have proper noble clothing for Kazengun - Gender Neutral
				cloak = /obj/item/clothing/cloak/cotehardie/aristocrat
				head = /obj/item/clothing/head/roguetown/smokingcap
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
				pants = /obj/item/clothing/under/roguetown/trou/leather/eastern
				shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan/shitty
				gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
				belt = /obj/item/storage/belt/rogue/leather/plaquesilver
				beltr = /obj/item/flashlight/flare/torch/lantern
				id = /obj/item/clothing/ring/gold
				H.cmode_music = 'sound/music/combat_Kazengun_Runaway_Chariot.ogg'
				H.grant_language(/datum/language/kazengunese) //Duh
				backl = /obj/item/storage/backpack/rogue/satchel/black

		var/proficiencies = list("Decorated Sabre + Maille Training + 1 WIL", "Decorated Rapier + Maille Training + 1 WIL", "Decorated Arming Sword + Maille Training + 1 WIL", "Decorated Dagger + Maille Training + 1 WIL", "Recurve Bow + Hunting Skill/Masterful Hunter Trait + Boar Maps + 1 PER", "Extra Coin + Expert Appraiser + Intellectual", "Inbred Noble - +5 LCK + Stat 8 baseline + Crit Weakness + No Run + Maille Training", "Survival Skills + Expert Hunter + Outdoorsman + Less Starting Coin + 1 PER", "Thieves Jargon + Expert Climbing + Journeyman Sneaking + Keen Ears + Cicerone + Deceiving Meakness + 1 PER")
		var/proficiency_choice = input(H, "Choose your proficiency.", "WHAT IS THY TALENT?") as anything in proficiencies
		switch(proficiency_choice)
			if("Decorated Sabre + Maille Training + 1 WIL") //Rich Battlemaster Lite (Without the Armor or Proper Training)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE) //Not a complete pushover
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				r_hand = /obj/item/rogueweapon/sword/sabre/dec
				backpack_contents = list(/obj/item/recipe_book/survival = 1, /obj/item/storage/belt/rogue/pouch/coins/rich = 1)
				H.change_stat(STATKEY_WIL, 1)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				to_chat(H, span_warning("You are a traveling noble visiting foreign lands. With wealth, come the poor, ready to pilfer you of your hard earned (inherited) coin, so tread lightly unless you want to meet a grisly end."))
			if("Decorated Rapier + Maille Training + 1 WIL") //Rich Battlemaster Lite (Without the Armor or Proper Training)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE) //Not a complete pushover
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				r_hand = /obj/item/rogueweapon/sword/rapier/dec
				backpack_contents = list(/obj/item/recipe_book/survival = 1, /obj/item/storage/belt/rogue/pouch/coins/rich = 1)
				H.change_stat(STATKEY_WIL, 1)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				to_chat(H, span_warning("You are a traveling noble visiting foreign lands. With wealth, come the poor, ready to pilfer you of your hard earned (inherited) coin, so tread lightly unless you want to meet a grisly end."))
			if("Decorated Arming Sword + Maille Training + 1 WIL") //Rich Battlemaster Lite (Without the Armor or Proper Training)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE) //Not a complete pushover
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				r_hand = /obj/item/rogueweapon/sword/decorated
				backpack_contents = list(/obj/item/recipe_book/survival = 1, /obj/item/storage/belt/rogue/pouch/coins/rich = 1)
				H.change_stat(STATKEY_WIL, 1)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				to_chat(H, span_warning("You are a traveling noble visiting foreign lands. With wealth, come the poor, ready to pilfer you of your hard earned (inherited) coin, so tread lightly unless you want to meet a grisly end."))
			if("Decorated Dagger + Maille Training + 1 WIL") //Rich Battlemaster Lite (Without the Armor or Proper Training)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE) //Not a complete pushover
				beltl = /obj/item/rogueweapon/scabbard/sheath/noble
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/decorated
				backpack_contents = list(/obj/item/recipe_book/survival = 1, /obj/item/storage/belt/rogue/pouch/coins/rich = 1)
				H.change_stat(STATKEY_WIL, 1)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				to_chat(H, span_warning("You are a traveling noble visiting foreign lands. With wealth, come the poor, ready to pilfer you of your hard earned (inherited) coin, so tread lightly unless you want to meet a grisly end."))
			if("Recurve Bow + Hunting Skill/Masterful Hunter Trait + Boar Maps + 1 PER") //Huntmaster lite, a poacher or perhaps an offical hunter?
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE) //To make it worth it w/trait too
				H.adjust_skillrank_up_to(/datum/skill/misc/hunting, SKILL_LEVEL_EXPERT, TRUE)
				H.change_stat(STATKEY_PER, 1)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltl = /obj/item/quiver/arrows
				backpack_contents = list(/obj/item/recipe_book/survival = 1, /obj/item/hunting_map/boars = 1, /obj/item/storage/belt/rogue/pouch/coins/mid = 1)
				ADD_TRAIT(H, TRAIT_MASTERFUL_HUNTER, TRAIT_GENERIC) //Unique starting prompt, you sort of did actually earn that
				ADD_TRAIT(H, TRAIT_EXPERT_HUNTER, TRAIT_GENERIC)
				to_chat(H, span_warning("You are a traveling noble visiting foreign lands for a great hunter. With wealth, come the poor, ready to pilfer you of your hard earned coin, so tread lightly unless you want to meet a grisly end."))
			if("Extra Coin + Expert Appraiser + Intellectual") //RP route, sacrifices practical skills for massive utility + wealth
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
				backpack_contents = list(/obj/item/recipe_book/survival = 1, /obj/item/storage/belt/rogue/pouch/coins/veryrich = 1, /obj/item/storage/belt/rogue/pouch/coins/rich = 1)
				ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_INTELLECTUAL, TRAIT_GENERIC)
				var/crowns = list(
					"Consort's Crown" 	= /obj/item/clothing/head/roguetown/nyle/consortcrown,
					"Circlet" 	= /obj/item/clothing/head/roguetown/circlet,
					"Jade Circlet" 	= /obj/item/clothing/head/roguetown/circlet/carvedgem/jade,
					"Amber Circlet" 	= /obj/item/clothing/head/roguetown/circlet/carvedgem/amber,
					"Shell Circlet" 	= /obj/item/clothing/head/roguetown/circlet/carvedgem/shell,
					"Rosestone Circlet" 	= /obj/item/clothing/head/roguetown/circlet/carvedgem/rose,
					"Cerulite Circlet" 	= /obj/item/clothing/head/roguetown/circlet/carvedgem/turq,
					"Onyxa Circlet" 	= /obj/item/clothing/head/roguetown/circlet/carvedgem/onyxa,
					"Heartstone Circlet" 	= /obj/item/clothing/head/roguetown/circlet/carvedgem/coral,
					"Opal Circlet" 	= /obj/item/clothing/head/roguetown/circlet/carvedgem/opal,
					"Hennin" 	= /obj/item/clothing/head/roguetown/hennin,
					"None"
					)
				var/crownchoice = input(H, "Choose your Crown/Hat.", "TAKE UP OPULANCE") as anything in crowns
				if(crownchoice != "None")
					head = crowns[crownchoice]
				to_chat(H, span_warning("You are a traveling noble visiting foreign lands. With great wealth, come the poor and the greedy, ready to pilfer you of your hard earned (inherited) coin, so tread lightly, trust few unless you want to meet a grisly end."))
			if("Inbred Noble - +5 LCK + Stat 8 baseline + Crit Weakness + No Run + Maille Training") //The Shitpost Option
				//Honestly, the fact you can even wear maile is fucking hilarious
				backpack_contents = list(/obj/item/recipe_book/survival = 1, /obj/item/storage/belt/rogue/pouch/coins/veryrich = 1) //Hilarious
				ADD_TRAIT(H, TRAIT_NORUN, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC) //HILARIOUS
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.change_stat(STATKEY_WIL, -2) //Effectively neutralise our job stats and set everything to 8 baseline
				H.change_stat(STATKEY_CON, -2)
				H.change_stat(STATKEY_SPD, -1)
				H.change_stat(STATKEY_STR, -3)
				H.change_stat(STATKEY_PER, -4)
				H.change_stat(STATKEY_INT, -4)
				H.change_stat(STATKEY_LCK, 5) //Congratulations, you survived this long! Somehow. Here's our exclusion.
				to_chat(H, span_warning("You are a traveling noble visiting foreign lands. Despite all of the attempts of your family to off you, you've managed to make it this far somehow. Yet tread lightly, unless you want to meet a grisly end separated from your hard earned (inherited) riches"))
			if("Survival Skills + Expert Hunter + Outdoorsman + Less Starting Coin + 1 PER") //Survival Skill Pack w/ outdoorsman on top
				backpack_contents = list(/obj/item/recipe_book/survival = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1)
				ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_EXPERT_HUNTER, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_SURVIVAL_EXPERT, JOB_TRAIT) //Yea sure.
				H.change_stat(STATKEY_PER, 1)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/hunting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
				//Impoverished noble sort of, you get a much less (I am a very rich guy) prompt and more of a despite it all, you're still here one.
				to_chat(H, span_warning("You are a traveling noble visiting foreign lands. Despite tymes costing most of your coin, you've kept the clothes on your back and picked up a few skills along the way, yet you still know to tread lightly unless you want to meet a grisly end."))
			if("Thieves Jargon + Expert Climbing + Journeyman Sneaking + Keen Ears + Cicerone + Deceiving Meakness + 1 PER") //A noble spy perhaps? Or a high-ranking smuggler
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
				H.change_stat(STATKEY_PER, 1)
				//No lockpicking, go thief for that. You're geared to cause problems, be it for or against the court.
				backpack_contents = list(/obj/item/recipe_book/survival = 1, /obj/item/storage/belt/rogue/pouch/coins/rich = 1)
				ADD_TRAIT(H, TRAIT_KEENEARS, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)

				ADD_TRAIT(H, TRAIT_DECEIVING_MEEKNESS, TRAIT_VIRTUE)
				add_verb(H, /mob/living/carbon/human/proc/toggle_descriptors)
				add_verb(H, /mob/living/carbon/human/proc/emote_ffsalute)
				add_verb(H, /mob/living/carbon/human/proc/toggle_guarded)

				//No darkvision, you're not /amazing/ at this vs a proper specialist
				H.grant_language(/datum/language/thievescant)
				to_chat(H, span_warning("You are a traveling noble visiting foreign lands. Perhaps sent as a spy, a liason, a part of a smuggling network or perhaps simply a hand to some small-time court, tread lightly however as your skills in espionage never covered escape, lest you meet a grisly end."))

/datum/advclass/noble/knighte
	name = "Knight Errant"
	tutorial = "You are a knight from a distant land, a scion of a noble house visiting Azuria for one reason or another."
	outfit = /datum/outfit/job/roguetown/adventurer/knighte
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	noble_income = 15
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/adventurer/knighte/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		to_chat(H, span_warning("You are a knight from a distant land, a scion of a noble house visiting Azuria for one reason or another."))
		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Sugarloaf Helmet"  = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader,
			"Knight's Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Knight's Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old,
			"Knight's Greatplumed Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume,
			"Visored Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"Visored Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor,
			"Great Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great,
			"Volfskulle Bascinet"		= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
			"None"
			)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/armors = list(
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
			"Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/heavy,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]

	gloves = /obj/item/clothing/gloves/roguetown/chain
	pants = /obj/item/clothing/under/roguetown/chainlegs
	cloak = /obj/item/clothing/cloak/tabard/stabard
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/recipe_book/survival = 1,
		)
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/knight]
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Longsword","Arming Sword + Shield","Mace + Shield","Flail + Shield","Lance + Shield","Billhook","Battle Axe","Greataxe","Greatflail")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Longsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/sword/long
				r_hand = /obj/item/rogueweapon/scabbard/sword/noble
			if("Arming Sword + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/sword
				r_hand = /obj/item/rogueweapon/scabbard/sword/noble
				backr = /obj/item/rogueweapon/shield/tower/metal
			if("Mace + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/mace
				backr = /obj/item/rogueweapon/shield/tower/metal
			if("Flail + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/flail
				backr = /obj/item/rogueweapon/shield/tower/metal
			if("Lance + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/lance
				backr = /obj/item/rogueweapon/shield/tower/metal
			if("Greatflail")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/peasantwarflail/iron
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Billhook")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/billhook
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Battle Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/battle
			if("Greataxe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe
				backr = /obj/item/rogueweapon/scabbard/gwstrap

/datum/advclass/noble/squire
	name = "Squire Errant"
	tutorial = "You are a squire who has traveled far in search of a master to train you and a lord to knight you."
	outfit = /datum/outfit/job/roguetown/adventurer/squire
	traits_applied = list(TRAIT_SQUIRE_REPAIR)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
	)
	extra_context = "Chooses between Light Armor (Dodge Expert) and Medium Armor."

/datum/outfit/job/roguetown/adventurer/squire/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a squire who has traveled far in search of a master to train you and a lord to knight you."))
	head = /obj/item/clothing/head/roguetown/roguehood
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	cloak = /obj/item/clothing/cloak/tabard/stabard
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/repair_kit/metal = 1,
		/obj/item/repair_kit = 1,
		/obj/item/armor_brush = 1,
		/obj/item/polishing_cream = 1,
		/obj/item/recipe_book/survival = 1,
	)
	if(H.mind)
		var/armors = list("Light Armor","Medium Armor")
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMS") as anything in armors
		switch(armor_choice)
			if("Light Armor")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				pants = /obj/item/clothing/under/roguetown/trou/leather
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				beltr = /obj/item/rogueweapon/huntingknife/idagger
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			if("Medium Armor")
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				pants = /obj/item/clothing/under/roguetown/chainlegs/iron
				gloves = /obj/item/clothing/gloves/roguetown/chain/iron
				beltr = /obj/item/rogueweapon/sword/iron
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.set_blindness(0)
