/datum/advclass/mage
	name = "Sorcerer"
	tutorial = "You are a learned mage and a scholar, having spent your life studying the arcane and its ways."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/adventurer/mage
	class_select_category = CLASS_CAT_MAGE
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
	traits_applied = list(TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
	)
	age_mod = /datum/class_age_mod/adv_mage
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 6, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/mage/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a learned mage and a scholar, having spent your life studying the arcane and its ways."))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/huntingknife
	backl = /obj/item/storage/backpack/rogue/satchel
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard]
	if(H.mind)
		backr = choose_implement(H, "lesser")
		backpack_contents = list(
			/obj/item/rogueweapon/spellbook = 1,
			/obj/item/chalk = 1
			)
	backpack_contents |= list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)
	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander4.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/mage/spellblade
	name = "Azurcaephan"
	tutorial = "You are an Azurcaephan — in common parlance, a Spellblade of the Azurean tradition. A hybrid melee warrior who channels arcyne momentum through combat. Build power with your weapon, then unleash it. Choose between three traditions: Blade (mobile swordsman with dashes and AoE), Phalangite (spear and shield — hold the line with thrusts and pushback), or Macebearer (blunt weapons — ground slams, charges, and shockwaves)."
	outfit = /datum/outfit/job/roguetown/adventurer/spellblade
	traits_applied = list(TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/spellblade
	var/subclass_selected

/datum/outfit/job/roguetown/adventurer/spellblade/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/adventurer/spellblade/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/bucklehat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/chalk = 1, /obj/item/rogueweapon/spellbook = 1)

	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "conventional")
	H << browse(selection_html, "window=spellblade_chant;size=1100x900")
	onclose(H, "spellblade_chant", src)

	var/open_time = world.time
	while(!subclass_selected && world.time - open_time < 5 MINUTES)
		stoplag(1)
	H << browse(null, "window=spellblade_chant")

	if(!subclass_selected)
		subclass_selected = "blade"

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = subclass_selected

	if(H.mind)
		switch(subclass_selected)
			if("blade")
				H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
				H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
				H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/blade_storm)
			if("phalangite")
				H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
				H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
				H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
			if("macebearer")
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter)
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
				H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)

		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	backr = /obj/item/rogueweapon/shield/wood

	switch(subclass_selected)
		if("blade")
			var/weapons = list("Longsword", "Rapier", "Sabre", "Iron Arming Sword", "Shortsword", "Hwando", "Steel Dagger")
			var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
			beltr = /obj/item/rogueweapon/scabbard/sword
			switch(weapon_choice)
				if("Longsword")
					r_hand = /obj/item/rogueweapon/sword/long
				if("Rapier")
					r_hand = /obj/item/rogueweapon/sword/rapier
				if("Sabre")
					r_hand = /obj/item/rogueweapon/sword/sabre
				if("Iron Arming Sword")
					r_hand = /obj/item/rogueweapon/sword/iron
				if("Shortsword")
					r_hand = /obj/item/rogueweapon/sword/short
				if("Hwando")
					r_hand = /obj/item/rogueweapon/sword/sabre/mulyeog
					armor = /obj/item/clothing/suit/roguetown/armor/basiceast
					gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
					pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
					head = /obj/item/clothing/head/roguetown/mentorhat
					backr = null
					beltr = /obj/item/rogueweapon/scabbard/sword/kazengun
				if("Steel Dagger")
					beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
			if(weapon_choice == "Steel Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("phalangite")
			var/spear_weapons = list("Spear", "Dory", "Naginata")
			var/spear_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in spear_weapons
			switch(spear_choice)
				if("Spear")
					r_hand = /obj/item/rogueweapon/spear
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Dory")
					r_hand = /obj/item/rogueweapon/spear/spellblade
				if("Naginata")
					r_hand = /obj/item/rogueweapon/spear/naginata
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					armor = /obj/item/clothing/suit/roguetown/armor/basiceast
					gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
					pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
					head = /obj/item/clothing/head/roguetown/mentorhat
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("macebearer")
			var/mace_weapons = list("Mace", "Warhammer", "Goedendag", "Iron Axe", "Greataxe")
			var/mace_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in mace_weapons
			var/picked_axe = FALSE
			switch(mace_choice)
				if("Mace")
					r_hand = /obj/item/rogueweapon/mace
				if("Warhammer")
					r_hand = /obj/item/rogueweapon/mace/warhammer
				if("Goedendag")
					r_hand = /obj/item/rogueweapon/mace/goden
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Iron Axe")
					r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
					picked_axe = TRUE
				if("Greataxe")
					r_hand = /obj/item/rogueweapon/greataxe
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					picked_axe = TRUE
			if(picked_axe)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)

	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/mage/spellsinger
	name = "Spellsinger"
	tutorial = "You belong to a school of bards renowned for their study of both the arcane and the arts."
	outfit = /datum/outfit/job/roguetown/adventurer/spellsinger
	traits_applied = list(TRAIT_ARCYNE, TRAIT_EMPATH, TRAIT_GOODLOVER)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
	)
	// TODO // FULL ON REWORK Bard.
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)
/datum/outfit/job/roguetown/adventurer/spellsinger/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You belong to a school of bards renowned for their study of both the arcane and the arts."))
	head = /obj/item/clothing/head/roguetown/spellcasterhat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/dark
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/sabre
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/chalk = 1, /obj/item/rogueweapon/spellbook = 1)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T1)
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/vicious_mockery)
		H.mind.AddSpell(new /datum/action/cooldown/spell/arcyne_forge)
		H.mind.AddSpell(new /datum/action/cooldown/spell/conjure_instrument)
		grant_poke_spell(H)

	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/mage/spellfist
	name = "Spellfist"
	tutorial = "You are a Spellfist, an unarmed warrior who combines martial prowess with arcyne magyck. Your art descends from the Pontifexes of Naledi, warrior-monks who first learned to channel arcyne power through their fists, though the technique has since spread across the world — especially to Lingyuese Psydonites in the east. You eschew most weapons in favor of using magyck to accelerate and strengthen your own body, striking enemies with blows from afar and storms of fists up close."
	outfit = /datum/outfit/job/roguetown/adventurer/spellfist
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_CON = 2
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4, ward = TRUE)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN, // Bare-handed abilities no weapon and read AA. Match unarmed.
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/spellfist
	var/sidearm_selected

/datum/outfit/job/roguetown/adventurer/spellfist/Topic(href, href_list)
	. = ..()
	if(href_list["sidearm"])
		sidearm_selected = href_list["sidearm"]

/datum/outfit/job/roguetown/adventurer/spellfist/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/headband/monk
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt =	/obj/item/clothing/suit/roguetown/armor/gambeson
	armor =	/obj/item/clothing/suit/roguetown/armor/leather/heavy
	gloves = /obj/item/clothing/gloves/roguetown/angle
	neck = /obj/item/clothing/neck/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/rogueweapon/huntingknife
	var/naledi_book = pick(/obj/item/book/rogue/naledi1, /obj/item/book/rogue/naledi2, /obj/item/book/rogue/naledi3, /obj/item/book/rogue/naledi4)
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		(naledi_book) = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
	)

	var/origin = input(H, "Did you study under the Naledi Yogis?", "ORIGIN") as anything in list("Yes", "No")
	if(origin == "Yes")
		head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian

	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/fist_of_psydon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/grasp_of_psydon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/blink/shadowstep)
		H.mind.AddSpell(new /datum/action/cooldown/spell/storm_of_psydon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.set_chant("unarmed")

	sidearm_selected = null
	var/chant_html = get_spellfist_chant_html(src, H)
	H << browse(chant_html, "window=spellfist_tutorial;size=650x700")
	onclose(H, "spellfist_tutorial", src)

	var/open_time = world.time
	while(!sidearm_selected && world.time - open_time < 5 MINUTES)
		stoplag(1)
	H << browse(null, "window=spellfist_tutorial")

	if(!sidearm_selected)
		sidearm_selected = "katar"

	switch(sidearm_selected)
		if("katar")
			H.put_in_hands(new /obj/item/rogueweapon/katar/bronze(H))
		if("knuckledusters")
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/knuckles/bronze(H))

	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'

/datum/advclass/mage/spellthief
	name = "Arcyne Trickster"
	tutorial = "You are an Arcyne Trickster, a thief and hooligan gifted in the arcyne arts."
	outfit = /datum/outfit/job/roguetown/adventurer/spellthief
	subclass_languages = list(/datum/language/thievescant)
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	traits_applied = list(TRAIT_ARCYNE)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/spellthief/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are an Arcyne Trickster, a thief and hooligan gifted in the arcyne arts."))
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/scabbard/sheath
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/chalk = 1, /obj/item/rogueweapon/spellbook = 1)

	// This just changes your starting cantrips and if you wear snazzy blue or edgy black.
	var/origin = input(H, "Arcyne Thief or a Magos Hooligan?", "ORIGIN") as anything in list("Arcyne Thief (Aetherknife)", "Magos Hooligan (Magician's Brick)")
	if(origin == "Arcyne Thief (Aetherknife)")
		head = /obj/item/clothing/head/roguetown/headband/monk/barbarian
		wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator
		cloak = /obj/item/clothing/cloak/raincloak/mortus
		if(H.mind)
			H.mind.AddSpell(new /datum/action/cooldown/spell/aetherknife)
			H.mind.AddSpell(new /datum/action/cooldown/spell/lesser_knock)
	else
		head = /obj/item/clothing/head/roguetown/witchhat/mageblue
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
		cloak = /obj/item/clothing/cloak/raincloak/mageblue
		if(H.mind)
			H.mind.AddSpell(new /datum/action/cooldown/spell/magicians_brick)
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/waterbolt)
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/blink)

/datum/advclass/witch
	name = "Witch"
	tutorial = "You are a witch, seen as wisefolk to some and a demon to many. Ostracized and sequestered for wrongthinks or outright heresy, your potions are what the commonfolk turn to when all else fails, and for this they tolerate you — at an arm's length. Take care not to end 'pon a pyre, for the church condemns your left handed arts."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/adventurer/witch
	class_select_category = CLASS_CAT_MAGE
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
	traits_applied = list(TRAIT_DEATHSIGHT, TRAIT_WITCH, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1
	)
	age_mod = /datum/class_age_mod/witch

	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/witch/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/witchhat
	mask = /obj/item/clothing/head/roguetown/roguehood/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/storage/magebag/starter
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/shortboots

	var/list/prefs = H.client?.prefs?.job_subprefs
	var/list/witchprefs
	if(prefs)
		witchprefs = prefs["Adventurer"]
	var/classchoice
	var/shapeshiftchoice
	if(witchprefs && witchprefs["witch_type"])
		classchoice = witchprefs["witch_type"]
	if(witchprefs && witchprefs["witch_form"])
		shapeshiftchoice = witchprefs["witch_form"]
	if(!classchoice)
		var/classes = list("Old Magick", "Godsblood", "Mystagogue")
		classchoice = input(H, "How do your powers manifest?", "THE OLD WAYS") as anything in classes
	if(!shapeshiftchoice)
		var/shapeshifts = list("Zad", "Cat", "Cat (Black)", "Bat", "Lesser Volf", "Cabbit", "Small Rous", "Lesser Venard")
		shapeshiftchoice = input(H, "What form does your second skin take?", "THE OLD WAYS") as anything in shapeshifts

	switch (classchoice)
		if("Old Magick")
			ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if(H.mind)
				H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 5, "ward" = TRUE))
			backl = /obj/item/storage/backpack/rogue/satchel
			backr = choose_implement(H, "lesser")
			backpack_contents = list(
								/obj/item/rogueweapon/spellbook = 1,
								/obj/item/reagent_containers/glass/mortar = 1,
								/obj/item/pestle = 1,
								/obj/item/candle/yellow = 2,
								/obj/item/chalk = 1
								)
			if (H.age == AGE_OLD)
				H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE)
		if("Godsblood")
			//miracle witch: capped at t2 miracles. cannot pray to regain devo, but has high innate regen because of it (2 instead of 1 from major)
			var/datum/devotion/D = new /datum/devotion/(H, H.patron)
			H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_APPRENTICE, TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_2)
			D.max_devotion *= 0.5
			neck = /obj/item/clothing/neck/roguetown/psicross/wood
			backl = /obj/item/storage/backpack/rogue/satchel
			backpack_contents = list(
								/obj/item/reagent_containers/glass/mortar = 1,
								/obj/item/pestle = 1,
								/obj/item/candle/yellow = 2,
								)
			if (H.age == AGE_OLD)
				H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
		if("Mystagogue")
			// hybrid arcane/holy witch with t1 arcane and t1 miracles
			var/datum/devotion/D = new /datum/devotion/(H, H.patron)
			H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
			D.max_devotion *= 0.5
			ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_NOVICE, TRUE)
			if(H.mind)
				H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 3))
			neck = /obj/item/clothing/neck/roguetown/psicross/wood
			backl = /obj/item/storage/backpack/rogue/satchel
			backpack_contents = list(
								/obj/item/rogueweapon/spellbook = 1,
								/obj/item/reagent_containers/glass/mortar = 1,
								/obj/item/pestle = 1,
								/obj/item/candle/yellow = 2,
								/obj/item/chalk = 1
								)
			if (H.age == AGE_OLD)
				H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_NOVICE, TRUE)
				H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
	if(H.mind)
		switch (shapeshiftchoice)
			if("Zad")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/crow)
			if("Cat")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat)
			if("Cat (Black)")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat/black)
			if("Bat")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/bat)
			if("Lesser Volf")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_wolf)
			if("Lesser Venard")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_vernard)
			if("Small Rous")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/rous)
			if("Cabbit")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cabbit)
		switch (classchoice)
			if("Mystagogue")
				grant_poke_spell(H)
	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/armor/corset
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		pants = /obj/item/clothing/under/roguetown/skirt/red

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_LOWER_MIDDLE_CLASS, H)

/obj/effect/proc_holder/spell/targeted/shapeshift/witch
	die_with_shapeshifted_form = FALSE
	gesture_required = TRUE
	chargetime = 5 SECONDS
	recharge_time = 50
	cooldown_min = 50
	convert_damage = FALSE
	do_gib = FALSE
	knockout_on_death = 10 SECONDS

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cast(list/targets, mob/user = usr)
	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/Shapeshift(mob/living/caster)
	caster.visible_message(span_warning("[caster] begins to twist and contort!"), span_notice("I begin to transform into another form..."))
	// Do-after before transforming
	if(!do_after(caster, 3 SECONDS, target = caster))
		to_chat(caster, span_warning("Transformation interrupted!"))
		revert_cast(caster)  // Refund the cooldown
		return

	// Call parent to actually transform
	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/Restore(mob/living/shape)
	// Check if restrained before allowing revert
	if(shape.restrained(ignore_grab = FALSE))
		to_chat(shape, span_warn("I am restrained, I can't transform back!"))
		revert_cast(shape)  // Refund the cooldown
		return

	// Add do-after for witches when reverting
	shape.visible_message(span_warning("[shape] compresses and takes another form!"), span_notice("I begin to twist back into my normal form..."))
	if(!do_after(shape, 3 SECONDS, target = shape))
		to_chat(shape, span_warning("Transformation revert interrupted!"))
		revert_cast(shape)  // Refund the cooldown
		return

	return ..()


/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat
	name = "Cat Form"
	desc = ""
	overlay_state = "cat_transform"
	shapeshift_type = /mob/living/simple_animal/pet/cat/witch_shifted

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat/black
	shapeshift_type = /mob/living/simple_animal/pet/cat/rogue/black/witch_shifted

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_wolf
	name = "Lesser Volf Form"
	desc = ""
	overlay_state = "volf_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/wolf/witch_shifted

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/bat
	name = "Bat Form"
	desc = ""
	overlay_state = "bat_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/bat
	knockout_on_death = 30 SECONDS

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/crow
	name = "Zad Form"
	overlay_state = "zad"
	desc = ""
	knockout_on_death = 15 SECONDS
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/bat/crow
	sound = 'sound/vo/mobs/bird/birdfly.ogg'

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_vernard
	name = "Lesser Vernard Form"
	desc = ""
	overlay_state = "vernard_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/fox/witch_shifted

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/rous
	name = "Small Rous Form"
	desc = ""
	overlay_state = "rous_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/smallrat/witch_shifted

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cabbit
	name = "Cabbit Form"
	desc = ""
	overlay_state = "cabbit_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/witch_shifted

/datum/intent/simple/claw/witch_cat
	name = "scratch"
	attack_verb = list("scratches", "claws")

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/witch_shifted
	name = "lesser volf"
	desc = "A smaller, runtier variant of the classic volf that hounds the woods nearby. Rarely seen around these parts, and doesn't look nearly as dangerous as its larger counterparts. This one has a peculiar intelligence in its yellow eyes..."
	STASPD = 15
	STASTR = 3
	STACON = 5
	melee_damage_lower = 9
	melee_damage_upper = 14
	del_on_deaggro = null
	defprob = 70

/mob/living/simple_animal/pet/cat/witch_shifted
	name = "aloof cat"
	desc = "A bored-seeming feline. This one has a peculiar intelligence in its green eyes..."
	defprob = 90
	STASPD = 18
	STASTR = 1
	STACON = 3
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 2
	melee_damage_upper = 5

/mob/living/simple_animal/pet/cat/rogue/black/witch_shifted
	name = "voidblack cat"
	desc = "Supposedly sacred to Necra, and just as interested in rats as their lesser counterparts. This one has a strange intelligence behind its dark, wide eyes..."
	defprob = 90
	STASPD = 18
	STASTR = 1
	STACON = 3
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 2
	melee_damage_upper = 5

/mob/living/simple_animal/hostile/retaliate/rogue/fox/witch_shifted
	name = "lesser vernard"
	desc = "A smaller, runtier variant of the sneaky vernards that skulk the woods nearby. Rarely seen around these parts, and doesn't look nearly as dangerous as its larger counterparts. This one has a peculiar intelligence in its yellow eyes..."
	defprob = 90
	STASPD = 18
	STASTR = 2
	STACON = 4
	melee_damage_lower = 8
	melee_damage_upper = 12
	del_on_deaggro = null
	defprob = 70

/mob/living/simple_animal/hostile/retaliate/smallrat/witch_shifted
	name = "small rous"
	desc = "Supposedly sacred to Pestra, these small and occasionally pestilent creachurs are commonly found in pantries and ships. This one seems to be a bit more smarter than the others..."
	defprob = 90
	STASPD = 18
	STASTR = 1
	STACON = 1
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 1
	melee_damage_upper = 2

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/witch_shifted
	name = "lesser cabbit"
	desc = "Seeing one of these quick beasts is said to bring Xylix's fortune, along with their feet. It looks weak and innocent, and incredibly adorable."
	defprob = 90
	STASPD = 20
	STASTR = 1
	STACON = 2
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 1
	melee_damage_upper = 2

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/witch_shifted/can_be_held(mob/by)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/witch_shifted/set_item_sprite(obj/item/mob_item/orb)
	..()
	orb.mob_overlay_icon = 'icons/roguetown/mob/cabbit_item.dmi'
	orb.worn_offsets = list("x" = 0, "y" = 25)
	orb.alternate_worn_layer = BODY_UNDER_LAYER
