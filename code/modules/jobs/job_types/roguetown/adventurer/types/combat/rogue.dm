/datum/advclass/rogue
	name = "Treasure Hunter"
	tutorial = "You are a treasure hunter trained in hunting for valuables. Discern what is treasure or not, your fortune could be hidden anywhere."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/adventurer/rogue
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_SEEPRICES, TRAIT_GRAVEROBBER)
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
	class_select_category = CLASS_CAT_ROGUE
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/rogue/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a treasure hunter trained in hunting for valuables. Discern what is treasure or not, your fortune could be hidden anywhere."))
	pants = /obj/item/clothing/under/roguetown/trou/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	backr = /obj/item/rogueweapon/shovel
	head = /obj/item/clothing/head/roguetown/fedora
	beltl = /obj/item/flashlight/flare/torch/lantern
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backpack_contents = list(
		/obj/item/lockpick = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.mind)
		var/weapons = list("Sabre","Whip")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Sabre")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/sword/sabre
				r_hand = /obj/item/rogueweapon/scabbard/sword
			if("Whip")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/whip

/datum/advclass/rogue/thief
	name = "Thief"
	tutorial = "You are a scoundrel and a thief. A master in getting into places you shouldn't be and taking things that aren't rightfully yours."
	outfit = /datum/outfit/job/roguetown/adventurer/thief
	subclass_languages = list(/datum/language/thievescant)
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/adventurer/thief/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a scoundrel and a thief. A master in getting into places you shouldn't be and taking things that aren't rightfully yours."))
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	beltl = /obj/item/quiver/Warrows
	beltr = /obj/item/rogueweapon/mace/cudgel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

/datum/advclass/rogue/bard
	name = "Bard"
	tutorial = "You make your fortune in brothels, flop houses, and taverns – gaining fame for your songs and legends. If there is any truth to them, that is."
	outfit = /datum/outfit/job/roguetown/adventurer/bard
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_GOODLOVER, TRAIT_EMPATH)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/bard/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You make your fortune in brothels, flop houses, and taverns – gaining fame for your songs and legends. If there is any truth to them, that is."))
	head = /obj/item/clothing/head/roguetown/bardhat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	backl = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/half/red
	backpack_contents = list(
		/obj/item/lockpick = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T2)
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/vicious_mockery)
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

/datum/advclass/rogue/swashbuckler
	name = "Swashbuckler"
	tutorial = "You are a daring rogue of the seas! Swashbucklers wield agile swordplay and acrobatic prowess - fighting dirty to outmaneuver foes with flair."
	outfit = /datum/outfit/job/roguetown/adventurer/swashbuckler
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_NUTCRACKER, TRAIT_LEAPER)
	subclass_virtues = list(
		/datum/virtue/combat/guarded
		)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/swashbuckler/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a daring rogue of the seas! Swashbucklers wield agile swordplay and acrobatic prowess - fighting dirty to outmaneuver foes with flair."))
	head = /obj/item/clothing/head/roguetown/helmet/tricorn
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogue/instrument/hurdygurdy
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/sword/cutlass
	backpack_contents = list(
		/obj/item/bomb = 1,
		/obj/item/lockpick = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

/datum/advclass/rogue/antiquarian
	name = "Antiquarian"
	tutorial = "Your scholarship and connections allow you to find wealth where others do not care to look. You're unpracticed in direct combat, but knowledge and prepation leaves a few tricks up your sleeve."
	outfit = /datum/outfit/job/roguetown/adventurer/antiquarian
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(TRAIT_SEEPRICES, TRAIT_GRAVEROBBER, TRAIT_INTELLECTUAL, TRAIT_ALCHEMY_EXPERT)
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/antiquarian/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Your scholarship and connections allow you to find wealth where others do not care to look. You're unpracticed in direct combat, but knowledge and prepation leave a few tricks up your sleeve"))
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backl = /obj/item/storage/backpack/rogue/backpack
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	cloak = /obj/item/clothing/cloak/thief_cloak
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	shoes = /obj/item/clothing/shoes/roguetown/boots
	head = /obj/item/clothing/head/roguetown/roguehood
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	neck = /obj/item/clothing/neck/roguetown/leather
	backpack_contents = list(
		/obj/item/lockpick = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/skillbook/unfinished = 1
		)

	if(H.mind)
		var/weapons = list("Parrying Dagger","Whip", "Short Spear")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		H.mind.AddSpell(new /datum/action/cooldown/spell/matthios/barter_secular)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fortifyingvapors)
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/flashpowder)
		switch(weapon_choice)
			if("Parrying Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_APPRENTICE, TRUE)
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/virtue
				backr = /obj/item/rogueweapon/scabbard/sheath
			if("Whip")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_APPRENTICE, TRUE)
				r_hand = /obj/item/rogueweapon/whip
			if("Short Spear")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_APPRENTICE, TRUE)
				r_hand = /obj/item/rogueweapon/spear/short
				backr = /obj/item/rogueweapon/scabbard/gwstrap

		var/utility = list("Enchanted Ring","Sling","Arcyne Affinity")
		var/utility_choice = input(H, "Choose your utility.", "A RARE GIFT") as anything in utility
		H.set_blindness(0)
		switch(utility_choice)
			if("Enchanted Ring")
				var/rings = list("Swiftness","Vitality","Wisdom") //no courage because it gives unbound strength
				var/ring_choice = input(H, "What enchantment?", "A RARE GIFT") as anything in rings
				H.set_blindness(0)
				switch(ring_choice)
					if("Swiftness")
						id = /obj/item/clothing/ring/statgemerald/antiquarian
					if("Vitality")
						switch(H.patron?.type)
							if(/datum/patron/inhumen/baotha)
								var/baotharing = list("Ring of Vitality","Rosa Ring")
								var/baotharing_choice = input(H, "A discrete ring, or one of your faith?", "A RARE GIFT") as anything in baotharing
								H.set_blindness(0)
								switch(baotharing_choice)
									if("Ring of Vitality")
										id = /obj/item/clothing/ring/statonyx/antiquarian
									if("Rosa Ring")
										id = /obj/item/clothing/ring/griefflower
							else
								id = /obj/item/clothing/ring/statonyx/antiquarian
					if("Wisdom")
						id = /obj/item/clothing/ring/statamythortz/antiquarian //same effect but nearly worthless instead of 222 mammons
			if("Sling")
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
				beltl = /obj/item/quiver/sling/iron
			if("Arcyne Affinity")
				ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_NOVICE, TRUE)
				H.mind.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)
				if(!LAZYLEN(H.mind.mage_aspect_config)) //ripped from arcyne potential virtue, not sure what it does
					H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4))
				H.mind.check_learnspell()
