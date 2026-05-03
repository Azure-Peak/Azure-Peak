/datum/advclass/mage
	name = "Sorcerer"
	tutorial = "You are a learned mage and a scholar, having spent your life studying the arcane and its ways."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
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
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
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
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	if(H.mind)
		backr = choose_implement(H, "lesser")
		backpack_contents = list(
			/obj/item/book/spellbook = 1,
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
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/chalk = 1, /obj/item/book/spellbook = 1)

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
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/blade_storm)
			if("phalangite")
				H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
				H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
				H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
			if("macebearer")
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/kastvyl)
				H.mind.AddSpell(new /datum/action/cooldown/spell/tremor)
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
				if("Dory")
					r_hand = /obj/item/rogueweapon/spear/spellblade
				if("Naginata")
					r_hand = /obj/item/rogueweapon/spear/naginata
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					armor = /obj/item/clothing/suit/roguetown/armor/basiceast
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
				if("Iron Axe")
					r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
					picked_axe = TRUE
				if("Greataxe")
					r_hand = /obj/item/rogueweapon/greataxe
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
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/chalk = 1, /obj/item/book/spellbook = 1)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T1)
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/vicious_mockery)
		H.mind.AddSpell(new /datum/action/cooldown/spell/arcyne_forge)
		var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Greater Arcyne Bolt", "Stygian Efflorescence", "Arcyne Lance", "Lesser Gravel Blast")
		var/poke_choice = input(H, "Choose your offensive cantrip.", "Arcyne Training") as anything in poke_options
		switch(poke_choice)
			if("Spitfire")
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
			if("Frost Bolt")
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
			if("Arc Bolt")
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
			if("Greater Arcyne Bolt")
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/greater_arcyne_bolt)
			if("Stygian Efflorescence")
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
			if("Arcyne Lance")
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)
			if("Lesser Gravel Blast")
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast/lesser)
	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
	if(H.mind)
		var/weapons = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman", "Psyaltery", "Flute")
		var/weapon_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", weapons)
		H.set_blindness(0)
		switch(weapon_choice)
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

/datum/advclass/mage/spellfist
	name = "Spellfist"
	tutorial = "You are a Spellfist, an unarmed warrior who combines martial prowess with arcyne magyck. Your art descends from the Pontifexes of Naledi, warrior-monks who first learned to channel arcyne power through their fists, though the technique has since spread across the world — especially to Lingyuese Psydonites in the east. You eschew most weapons in favor of using magyck to accelerate and strengthen your own body, striking enemies with blows from afar and storms of fists up close."
	outfit = /datum/outfit/job/roguetown/adventurer/spellfist
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_CON = 1
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
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
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/angle
	neck = /obj/item/clothing/neck/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	belt = /obj/item/storage/belt/rogue/leather/rope
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/rogueweapon/huntingknife
	var/naledi_book = pick(/obj/item/book/rogue/naledi1, /obj/item/book/rogue/naledi2, /obj/item/book/rogue/naledi3, /obj/item/book/rogue/naledi4)
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		(naledi_book) = 1,
		/obj/item/book/spellbook = 1,
		/obj/item/chalk = 1,
	)

	var/origin = input(H, "Did you study under the Naledi Yogis?", "ORIGIN") as anything in list("Yes", "No")
	if(origin == "Yes")
		head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian

	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/fist_of_psydon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/grasp_of_psydon())
		H.mind.AddSpell(new /datum/action/cooldown/spell/blink)
		H.mind.AddSpell(new /datum/action/cooldown/spell/storm_of_psydon())
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
