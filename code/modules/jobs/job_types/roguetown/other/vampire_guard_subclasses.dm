//VAMPIRE GUARD CLASSES//
// They are composed of a mix of iron, steel and ancient alloy, in order to stand out in numbers. The idea is sort of making them a retinue of the vampire lord.
// They are intended to be pretty scary and combat-capable, because vlord might end up fighting wretches, as they might end up fighting the town.

//They should not exceed the capacity of wretches though, they're intended to be scarier in numbers but weaker than a solo wretch on average.
//Also account for the fact they are neonites, they have 9RP to work with.


//Jack of all trades fighter, gains expert in their chosen weapon pick
/datum/advclass/vampguardsman
	name = "Vampiric Footsoldier"
	tutorial = "You are a seasoned weapon specialist, clad in maille, with years of experience in warfare and battle under your belt, more than any mortal could ever claim."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/other/vampguardsman
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	category_tags = list(CTAG_VAMPGUARD)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 2,
		// 8, point statline, akin to MAA deserter nearly albeit tipped towards the antag-side of scaling.
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN, //Despite town MAAs getting this at expert, I want duelist to be better in this
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //Keeping captives, alive. We're not a lich's army, we have standards.
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN, //Vampire soldiers are good trackers but not as good as skirmishers.
	)
//Unlike MAAs, they have lower skill outside of their weapon choice, akin to mercs but the journeyman jack-of-all trades of lich skeles/bandits


/datum/outfit/job/roguetown/other/vampguardsman/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a professional soldier, clad in maille, with years of experience in warfare and battle under your belt, far more than most mortals could claim. Your lord's will be done."))
	if(H.mind)
		var/weapons = list("Warhammer & Shield","Sabre & Shield","Axe & Shield","Billhook","Greataxe","Halberd")
		var/weapon_choice = input(H, "Choose your weapon.", "ARMS TO HERALD THE NITE") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Warhammer & Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/mace/warhammer
				backl = /obj/item/rogueweapon/shield/iron
			if("Sabre & Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/wood
			if("Axe & Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/iron
			if("Billhook")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/spear/billhook
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Halberd")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Greataxe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe
				backl = /obj/item/rogueweapon/scabbard/gwstrap

	add_verb(H, /mob/proc/haltyell_exhausting) //Soldier gets to halt people

	cloak = /obj/item/clothing/cloak/tabard/stabard/vamp
	mask = /obj/item/clothing/mask/rogue/facemask/steel //so they don't get sundered in the face
	head = /obj/item/clothing/head/roguetown/helmet/sallet
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy

	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/flashlight/flare/torch/lantern //we don't need it, but might as well play into the masquerade of a strange foreign retinue
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

// Ranger, minifort class. Also doubles as a knockoff assassin, a good tracker for people that run from your conversion horde.
/datum/advclass/vampskirmisher
	name = "Vampiric Skirmisher"
	tutorial = "You are a professional soldier, light in footwork, yet with years of experience in warfare and archery, far more than most mortals could claim. Your lord's will be done."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/other/vampskirmisher
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_OUTDOORSMAN)
	category_tags = list(CTAG_VAMPGUARD)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_PER = 4,
		// 8 point statline, mostly put into perception; no int bonus though, fient them sire.
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,		//On par with MAA skirmisher
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		//No slings, vampires are too "stylish" to use those, sire.
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT, //MAA skirmisher gets knives in expert, but you, you sire get the axe.
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE, //Enough to make a fort/tower quickly, be a servant if you want to go all-in.
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE, //Enough to make a wall, go grind if you want more.
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //Keeping captives, alive. We're not a lich's army, we have standards.
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER, //Vampire skirmishers are exceptionally good trackers.
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/other/vampskirmisher/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a professional soldier, light in footwork, yet with years of experience in warfare and archery, far more than most mortals could claim. Your lord's will be done."))

	cloak = /obj/item/clothing/cloak/tabard/stabard/vamp
	head = /obj/item/clothing/head/roguetown/roguehood/studded/vamp //Minimal face protection, maximal auramaxxing.
	mask = /obj/item/clothing/mask/rogue/ragmask/black //less face protection, go guardsman if you want that. Also ominious for aura.
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson //Less protection, due to archery's potental
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy

	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut //demolishing fortifications or setting them up.
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1
		)

	add_verb(H, /mob/proc/haltyell_exhausting) //Soldier gets to halt people

	if(H.mind)
		var/weapons = list("Recurve Bow","Yew Longbow","Crossbow")
		var/weapon_choice = input(H, "Choose your weapon.", "ARMS TO HERALD THE NITE") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Recurve Bow")
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltl = /obj/item/quiver/arrows
			if("Yew Longbow")
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				beltl = /obj/item/quiver/arrows
			if("Crossbow")
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/quiver/bolt/standard

// Dodger melee class, excels in damage but also lacks the jack-of-all trades that is, guardsman and weaker tracking
/datum/advclass/vampduelist
	name = "Vampiric Duelist"
	tutorial = "You are an professional swordsman and warrior who foregoes armor in exchange for a more nimble fighting style than most mortals could claim. Your lord's will be done."
	outfit = /datum/outfit/job/roguetown/other/vampduelist
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT, TRAIT_DECEIVING_MEEKNESS)
	category_tags = list(CTAG_VAMPGUARD)
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_STR = 1,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		// 7 point statline, mostly put into speed; no con buff though
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT, //They can have a little, as a treat
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE, //Vampire duelists are okay trackers, less so to account for speed loss.
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //Keeping captives, alive. We're not a lich's army, we have standards.
	)

/datum/outfit/job/roguetown/other/vampduelist/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are an esteemed swordsman who foregoes armor in exchange for a more nimble fighting style than most mortals could claim. Your lord's will be done."))
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Messer & Parrying Dagger","Messer & Buckler","Heavy Dagger & Parrying Dagger","Dual Wield Messers") //Rapiers are a newer design, therefore ancient vampires use something else...
		var/weapon_choice = input(H, "Choose your weapon.", "ARMS TO HERALD THE NITE") as anything in weapons
		switch(weapon_choice)
			if("Messer & Parrying Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)//So it actually parries with said dagger.
				l_hand = /obj/item/rogueweapon/sword/short/messer/duelist
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
				backr = /obj/item/rogueweapon/scabbard/sword
			if("Messer & Buckler")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/short/messer/duelist
				r_hand = /obj/item/rogueweapon/shield/buckler
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Heavy Dagger & Parrying Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/huntingknife/combat
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
				beltr = /obj/item/rogueweapon/scabbard/sheath
			if("Dual Wield Messers")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/short/messer/duelist
				r_hand = /obj/item/rogueweapon/sword/short/messer/duelist
				beltr = /obj/item/rogueweapon/scabbard/sword
				beltl = /obj/item/rogueweapon/scabbard/sword

	add_verb(H, /mob/proc/haltyell_exhausting) //Soldier gets to halt people

	head = /obj/item/clothing/head/roguetown/duelhat/vamp //lowest of all guards in head armor in that only their coif really gives them any.
	mask = /obj/item/clothing/mask/rogue/duelmask //I AM THE NIGHT
	cloak = /obj/item/clothing/cloak/half/vamp //They get to auramax, as a treat
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/black
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

///////////////////////////////////////////////
//POTENTALLY PROBLEMATIC CLASSES,  BELOW HERE//
//////////////////////////////////////////////
		////////////////////////////////
		//////					//////
		////					////
		//						//
		//						//

// Puglist arson experiment class, replacement for adventurer bombardier. Still despite going all-in they actually perform worst as a puglist class when fighting themselves over just using bombs, this is intended.
/datum/advclass/vampbomber
	name = "Vampiric Arsonist"
	tutorial = "There has been nothing more enchanting in unlyfe than the dance of flames upon an inferno of your alchemical mixes and the taste of blood. Now your master arises once more and your talents shall see use again. Your lord's will be done."
	outfit = /datum/outfit/job/roguetown/other/vampbomber
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_ALCHEMY_EXPERT, TRAIT_EXPLOSIVE_SUPPLY, TRAIT_MEDIUMARMOR, TRAIT_CIVILIZEDBARBARIAN,  TRAIT_BOMBER_EXPERT)
	category_tags = list(CTAG_VAMPGUARD)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_CON = 3, //Trust me, you're going to need it.

		// 8 point statline, with a unique backup unarmed choice of just punching people with your bare hands into joining your fold.
		// albeit unlike other unarmed classes, you get no special techniques, no skin armor, miracles, nor a lot of strength for it
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT, //Maile punchman, tradeoff is that you have no special techniques vs proper unarmed classes, you lack the miracles + fullplate of icono and the stam regen of monks.
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, //RUN AND BLOW IT TO HELL, You kinda need this as you get no luxuries in raw combat outside of puglist fighting without bombs like everyone else, including just default strength.
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //Keeping captives, alive. We're not a lich's army, we have standards.
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/engineering = SKILL_LEVEL_EXPERT, //bombs, bombs and more bombs!
	)

/datum/outfit/job/roguetown/other/vampbomber/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("There has been nothing more enchanting in unlyfe than the dance of flames upon an inferno of your alchemical mixes and the taste of blood. Now your master arises once more and your talents shall see use again. Your lord's will be done."))
	H.set_blindness(0)

	add_verb(H, /mob/proc/haltyell_exhausting) //Halting the charred corpse is too funny, we're keeping it. sovl.

	mask = /obj/item/clothing/mask/rogue/ragmask/black
	cloak = /obj/item/clothing/cloak/tabard/stabard/vamp
	head = /obj/item/clothing/head/roguetown/helmet/kettle/minershelm //I can see it getting ditched but sovlful
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	pants = /obj/item/clothing/under/roguetown/brigandinelegs
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy //Weaker to chest stabs, intentional, go upgrade your armor
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/twstrap/bombstrap/firebomb
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron //weaker, intended
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron //Ditto
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	belt = /obj/item/storage/belt/rogue/leather //A little bit of difference to other guards
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/flint = 1,
		/obj/item/bomb = 2 //CHAOS REIGNS
		)

//A bunch of motherfuckin' draculas and they're all playin' flute. Buff-class lite duelist, doesn't perform as well as duelist in tradeoff for being able to buff up their teammates with music and perform vicious mockery.
/datum/advclass/vampbard
	name = "Vampiric Bard"
	tutorial = "Betwixt an occasional visit to a brothel, tavern or flophouse for your thirst for blood, you once told legends and myths of yills untold. One that someone could only dream of lyving, except you; yet now you've a prophecy to fulfil. Your lord's will be done."
	outfit = /datum/outfit/job/roguetown/other/vampbard
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT, TRAIT_GOODLOVER, TRAIT_EMPATH) //Keeping good lover, its funny.
	category_tags = list(CTAG_VAMPGUARD)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		//6 point statline, unchanged from adv save for +1 wil so they last longer in combat with music. Due to how strong bardic buffs can be in the hands of vampyres now they get numbers (I.E stam regen, health regen, etc) although they do still feel blue bar (excluding vlord) they have to retain being somewhat weak-ish
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE, //Still not amazing, because you can buff up already pretty stacked classes.
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT, //OG bard, its sovl
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER, //Dead men tell no tales, fortunately undead ones tell many more.
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //Keeping captives, alive. We're not a lich's army, we have standards.
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE, //Worse than adv, intended.
		/datum/skill/misc/music = SKILL_LEVEL_LEGENDARY, //SOVL NUKE
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT, //Keeping it, unironically works perfectly here.
	)

/datum/outfit/job/roguetown/other/vampbard/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Betwixt an occasional visit to a brothel, tavern or flophouse for your thirst for blood, you once told legends and myths of yills untold. One that someone could only dream of lyving, except you; yet now you've a prophecy to fulfil. Your lord's will be done."))
	head = /obj/item/clothing/head/roguetown/bardhat //Thou hath nae hat then thou art nae bard O' myne.
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy //Covers head, also semi-noticable
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	mask = /obj/item/clothing/mask/rogue/ragmask/black //Obligary face coverage
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson //Less protection, due to support class.
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	beltl = /obj/item/rogueweapon/scabbard/sword
	backr = /obj/item/rogueweapon/sword //OG sword
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	backl = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/half/vamp //stays, obligary.
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/lockpick = 1, //Go buy more, if you need em.
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	add_verb(H, /mob/proc/haltyell_exhausting) //This is stupid, keeping it. Halting someone to listen to your music is too funny.

	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T2)
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/vicious_mockery)
		var/weapons = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman", "Psyaltery", "Flute")
		var/weapon_choice = input(H, "Choose your instrument.", "STRINGS TO PLAY LYKE MORTALS.") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Harp")
				l_hand = /obj/item/rogue/instrument/harp
			if("Lute")
				l_hand = /obj/item/rogue/instrument/lute
			if("Accordion")
				l_hand = /obj/item/rogue/instrument/accord
			if("Guitar")
				l_hand = /obj/item/rogue/instrument/guitar
			if("Hurdy-Gurdy")
				l_hand = /obj/item/rogue/instrument/hurdygurdy
			if("Viola")
				l_hand = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				l_hand = /obj/item/rogue/instrument/vocals
			if("Psyaltery")
				l_hand = /obj/item/rogue/instrument/psyaltery
			if("Flute")
				l_hand = /obj/item/rogue/instrument/flute //You know what must be done.

// Armored mage, basically vampire magos for the lord. Specialises in faster casting, as a sort of step-in replacement for the grenzelhoftian seige mage. They may be buffed, nerfed or replaced depending how they perform.
/datum/advclass/vampseigemage
	name = "Vampiric Battlemage"
	tutorial = "You were a magos of old, ever since the embrace you've never had more time to practice your persuit of arcayne magicks, let alone revel in your taste for blood; now your master arises once more and your arcayne research shall see fruitation. Your lord's will be done."
	outfit = /datum/outfit/job/roguetown/other/vampseigemage
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_INTELLECTUAL, TRAIT_ALCHEMY_EXPERT, TRAIT_ARCYNE)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 6, "ward" = TRUE)
	category_tags = list(CTAG_VAMPGUARD)
	subclass_stats = list(
		STATKEY_INT = 3, //You've had long to study, a lot to study as well
		STATKEY_STR = -1,
		STATKEY_WIL = 2,
		STATKEY_PER = 3,
		// 7 point statline, mostly put into perception + int, they lack on their baseline speed being slightly higher unlike most mages on top of weaker martal talent
	)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_MASTER, //You've had a long, time to practice
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE, //Weaker vs grapples, compared to everyone else
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //Keeping captives, alive. We're not a lich's army, we have standards.
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/other/vampseigemage/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You were a magos of old, ever since the embrace you've never had more time to practice your persuit of arcayne magicks, let alone revel in your taste for blood; now your master arises once more and your arcayne research shall see fruitation. Your lord's will be done."))
	H.set_blindness(0)
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard] //Every wizzard gotta have the evyl laugh, I don't make the rules, sire.
	add_verb(H, /mob/proc/haltyell_exhausting) //Halting the charred corpse is too funny, we're keeping it. sovl.

	cloak = /obj/item/clothing/cloak/tabard/stabard/vamp
	head = /obj/item/clothing/head/roguetown/witchhat //EVERY PALLY IN THE KINGDOM ON MA TAIL
	mask = /obj/item/clothing/mask/rogue/facemask/
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson //Less protection, due to casting ability
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy //Makes up for no gloves
	neck = /obj/item/clothing/neck/roguetown/gorget/paalloy //No head armor but good anti-decap armor, intended.
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/battleskirt
	beltl = /obj/item/book/spellbook
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff/implement/greater

	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1
		)

/obj/item/clothing/cloak/tabard/stabard/vamp
	desc = "A checkered pattern of white fabrics and red silks, inlined seamlessly with silks befit for one under a lord with true opulance, not any mere dull-blooded or otherwise, branded with a crest of a forgotten empire."
	color = CLOTHING_WHITE
	detail_tag = "_quad"
	detail_color = CLOTHING_RED

/obj/item/clothing/head/roguetown/duelhat/vamp
	color = CLOTHING_WHITE
	detail_color = CLOTHING_RED

/obj/item/clothing/cloak/half/vamp
	desc = "An opulant half-cloak of silk for one under service to a lord with true fashion, not for any mere dull-blooded or otherwise, branded with a crest of a forgotten empire."
	color = CLOTHING_RED

/obj/item/clothing/head/roguetown/roguehood/studded/vamp
	color = CLOTHING_RED
