/proc/setup_mystic_healing(mob/living/carbon/human/H)
	if(!H.mind)
		return
	H.mind.RemoveSpell(/datum/action/cooldown/spell/miracle/heal)
	H.mind.RemoveSpell(/datum/action/cooldown/spell/miracle/heal/undivided)
	switch(H.patron?.type)
		if(/datum/patron/divine/undivided)
			var/list/heal = list("Greater Miracle (Divine)", "Fortifying Vapors (Secular)")
			switch(input(H, "Choose your healing training.", "Experientia Medica") as anything in heal)
				if("Greater Miracle (Divine)")
					H.mind.AddSpell(new /datum/action/cooldown/spell/miracle/heal/undivided)
				if("Fortifying Vapors (Secular)")
					H.mind.AddSpell(new /datum/action/cooldown/spell/fortifying_vapors)
		if(/datum/patron/old_god)
			H.mind.AddSpell(new /datum/action/cooldown/spell/fortifying_vapors)
		else
			var/list/heal = list("Miracle (Divine)", "Fortifying Vapors (Secular)")
			switch(input(H, "Choose your healing training.", "Experientia Medica") as anything in heal)
				if("Miracle (Divine)")
					H.mind.AddSpell(new /datum/action/cooldown/spell/miracle/heal)
				if("Fortifying Vapors (Secular)")
					H.mind.AddSpell(new /datum/action/cooldown/spell/fortifying_vapors)

/proc/setup_mystic_weapon(datum/outfit/job/roguetown/adventurer/O, mob/living/carbon/human/H)
	if(!H.mind)
		return
	var/list/weapons = list("Lesser Staff", "Lesser Tome", "Quarterstaff")
	switch(input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons)
		if("Lesser Staff")
			O.r_hand = /obj/item/rogueweapon/woodstaff/implement
		if("Lesser Tome")
			O.r_hand = /obj/item/rogueweapon/spellbook
		if("Quarterstaff")
			O.r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
			O.backr = /obj/item/rogueweapon/scabbard/gwstrap
	H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)

/proc/setup_martial_mystic_weapon(datum/outfit/job/roguetown/adventurer/O, mob/living/carbon/human/H)
	if(!H.mind)
		return
	var/list/weapons = list(
		"Arming Sword",
		"Greatsword",
		"Spear",
		"Axe",
		"Dagger",
		"Combat Knife",
		"Shortsword + Shield",
		"Mace + Shield",
		"Whip",
	)
	switch(input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons)
		if("Arming Sword")
			O.r_hand = /obj/item/rogueweapon/sword
			O.beltr = /obj/item/rogueweapon/scabbard/sword
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Greatsword")
			O.r_hand = /obj/item/rogueweapon/greatsword
			O.backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Spear")
			O.r_hand = /obj/item/rogueweapon/spear
			O.backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Axe")
			O.r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Dagger")
			O.r_hand = /obj/item/rogueweapon/huntingknife/idagger
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Combat Knife")
			O.r_hand = /obj/item/rogueweapon/huntingknife/combat
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Shortsword + Shield")
			O.r_hand = /obj/item/rogueweapon/sword/short
			O.beltr = /obj/item/rogueweapon/scabbard/sword
			O.backr = /obj/item/rogueweapon/shield/wood
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("Mace + Shield")
			O.r_hand = /obj/item/rogueweapon/mace
			O.backr = /obj/item/rogueweapon/shield/wood
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)

/proc/setup_mystic_patron(datum/outfit/job/roguetown/adventurer/O, mob/living/carbon/human/H)
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			O.neck = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/undivided)
			O.neck = /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/divine/astrata)
			O.neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			O.neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			O.neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			H.grant_language(/datum/language/abyssal)
		if(/datum/patron/divine/dendor)
			O.neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
		if(/datum/patron/divine/necra)
			O.neck = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			O.neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			O.neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			O.neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			O.neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			O.neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			O.neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			O.neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			O.neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			O.neck = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'

/proc/grant_azurca_poke_spell(mob/living/carbon/human/H)
	if(!H?.mind)
		return
	var/list/choices = list(
		"Caedo Sidecut" = /datum/action/cooldown/spell/caedo,
		"Azurean Phalanx" = /datum/action/cooldown/spell/azurean_phalanx,
		"Shattering Strike" = /datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter,
	)
	var/choice = input(H, "Choose your Azurca technique.", "Azurca Discipline") as null|anything in choices
	if(!choice)
		choice = "Caedo Sidecut"
	var/spell_type = choices[choice]
	H.mind.AddSpell(new spell_type)
	H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
	H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)

/datum/advclass/mystic
	name = "Mystic"
	tutorial = "I devoted my life to the arcane, but the mysteries of the divine proved just as alluring. Though I learned the rites and miracles of the faithful, true devotion forever eluded me. I can wield only the smallest blessings, for faith cannot be studied into existence."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/mystic
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
			STATKEY_INT = 2,
			STATKEY_SPD = 1,
			STATKEY_LCK = -1,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 0, "utilities" = 2, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/mystic/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("My pursuit of arcane mastery led me to study the divine. I learned the prayers, the rites, and the smallest miracles, but my heart never truly belonged to the gods. There are depths of faith I can never reach."))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/backpack
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard]
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/censer = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/folding_alchcauldron_stored = 1,
		/obj/item/reagent_containers/glass/bottle = 3,
		/obj/item/reagent_containers/glass/bottle/alchemical = 3,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
		/obj/item/herbmill/bootleg = 1,
		)
	var/datum/devotion/C = new(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
	setup_mystic_healing(H)
	setup_mystic_weapon(src, H)
	setup_mystic_patron(src, H)

/datum/advclass/mystic/sage
	name = "Sage"
	tutorial = "I devoted myself to the gods and their miracles, but faith alone could not answer every question. I turned to the Arcyne to better preserve life and shield those in my care. Yet the revelations of the Arcyne have given me more questions than answers, and with each discovery my faith grows ever more uncertain."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/resilient
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_ARCYNE, TRAIT_MEDICINE_EXPERT)
	subclass_stats = list(
			STATKEY_INT = 2,
			STATKEY_CON = 1,
			STATKEY_SPD = 1,
			STATKEY_LCK = -1,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 5, "locked_aspects" = list(/datum/magic_aspect/lesser_augmentation))
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/sage/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("My faith never faltered, yet I found the Arcyne to be another tool with which to preserve life. Though I still wield the gods' blessings, every revelation of the Arcyne leaves me questioning truths I once held sacred."))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard]
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/censer = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
		/obj/item/herbmill/bootleg = 1,
	)
	grant_poke_spell(H)
	var/datum/devotion/C = new(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1,)
	setup_mystic_healing(H)
	if(H.mind)
		var/list/weapons = list("Lesser Staff", "Lesser Tome")
		switch(input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons)
			if("Lesser Staff")
				r_hand = /obj/item/rogueweapon/woodstaff/implement
			if("Lesser Tome")
				r_hand = /obj/item/rogueweapon/spellbook
		H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)
	setup_mystic_patron(src, H)

/datum/advclass/mystic/luminary
	name = "Luminary"
	tutorial = "I ever dreamed of becoming a Templar, but my heart was never steadfast enough to walk their path. Ashamed of my shortcomings, I sought the Arcyne as a crutch, believing strength could be learned where faith had failed me. Only after a long pilgrimage did I come to understand that I had been chasing the wrong answer. The light I sought was never beyond the horizon. It was within my own hands all along."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/luminary
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = 2,
		STATKEY_CON = -1,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/luminary/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("I sought to become a Templar, but my conviction faltered where theirs did not. I embraced the Arcyne to strengthen what faith alone could not, only to learn during my pilgrimage that true resolve cannot be borrowed. The light I searched for was never beyond my reach. It was always within my own hands."))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/censer = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
		/obj/item/herbmill/bootleg = 1,
	)
	grant_azurca_poke_spell(H)
	var/datum/devotion/C = new(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/selfbuff)
	setup_mystic_healing(H)
	setup_martial_mystic_weapon(src, H)
	setup_mystic_patron(src, H)

/datum/advclass/mystic/zealot
	name = "Zealot"
	tutorial = "I have never doubted the will of the gods. Doubt is the weakness of those who cannot hear their calling. When prayers alone could not reach the hearts of men, I sought other means. The Arcyne is not a rejection of faith, but another testament to the wonders placed before us. If the divine has granted us the means to command flame, spirit, and the unseen forces of creation, then it would be blasphemy to leave such gifts unused. I shall carry the word of the gods wherever it is needed, by sermon, miracle, or sorcery."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/zealot
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = -1,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/zealot/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("The gods gave mortals both faith and understanding. I shall wield both. Through prayer I shall bring salvation, and through the Arcyne I shall tear away the ignorance that blinds those who refuse to listen."))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/censer = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
	)
	grant_azurca_poke_spell(H)
	var/datum/devotion/C = new(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/selfbuff)
	setup_mystic_healing(H)
	setup_martial_mystic_weapon(src, H)
	setup_mystic_patron(src, H)
