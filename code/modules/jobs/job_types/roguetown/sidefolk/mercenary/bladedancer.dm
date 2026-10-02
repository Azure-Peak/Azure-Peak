/datum/advclass/mercenary/bladedancer
	name = "Goliard of Steel"
	tutorial = "You're a blade dancer, trained in the art of arcyne and miracles to perfect your performance with your weapon in the name of your patron Xylix. With blade, song and wit you dance across the battlefied granting a fantastical spectacle for friend and foe alike."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/mercenary/bladedancer
	class_select_category = CLASS_CAT_GRENZELHOFT
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_WARMAGE)
	cmode_music = 'sound/music/combat_jester.ogg'
	subclass_languages = list(/datum/language/grenzelhoftian)
	allowed_patrons = list(/datum/patron/divine/xylix)
	traits_applied = list(TRAIT_ARCYNE, TRAIT_UNCONVERTIBLE) //Limited to light armor only, unconvertible because the thought of them being converted to another patron terrifies me
	subclass_stats = list(
		STATKEY_SPD = 1, // Weighted 7. SPD focus to demonstraight their acrobatic nature
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 6)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/mercenary/bladedancer
	var/subclass_selected

/datum/outfit/job/roguetown/mercenary/bladedancer/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/mercenary/bladedancer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	head = /obj/item/clothing/head/roguetown/grenzelhofthat
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	mask = /obj/item/clothing/mask/rogue/xylixmask
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/huntingknife,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/flashlight/flare/torch,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/spellbook/greater
		)

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
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
				H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
				H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/blade_storm)
			if("phalangite")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
				H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
				H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
			if("macebearer")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter)
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
				H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)

		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
		H.mind.AddSpell(new /datum/action/cooldown/spell/conjure_instrument) //Gives them the ability to summon an instrument as a freebie, they are as much musical performers as they are blade dancers.

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1) //Tier 3 spells because patron locked to Xylix and most of Xylix's spells are mostly whimsical. Change this if Xylix's spells are ever changed, be sure to change this too. Same devotion gain as a templar spellblade, and same devotion cap.

	switch(subclass_selected)
		if("blade")
			var/blade_weapons = list("Rapier", "Estoc", "Stecher", "Longsword", "Sabre")
			var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in blade_weapons
			switch(weapon_choice)
				if("Rapier")
					r_hand = /obj/item/rogueweapon/sword/rapier
					beltl = /obj/item/rogueweapon/scabbard/sword
				if("Estoc")
					r_hand = /obj/item/rogueweapon/estoc
					backl = /obj/item/rogueweapon/scabbard/gwstrap
				if("Stecher")
					r_hand = /obj/item/rogueweapon/sword/long/ap
					beltl = /obj/item/rogueweapon/scabbard/sword
				if("Longsword")
					r_hand = /obj/item/rogueweapon/sword/long
					beltl = /obj/item/rogueweapon/scabbard/sword
				if("Sabre")
					r_hand = /obj/item/rogueweapon/sword/sabre
					beltl = /obj/item/rogueweapon/scabbard/sword
		if("phalangite")
			var/polearm_weapons = list("Spear", "Dory & Shield")
			var/polearm_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in polearm_weapons
			switch(polearm_choice)
				if("Spear")
					r_hand = /obj/item/rogueweapon/spear
					backl = /obj/item/rogueweapon/scabbard/gwstrap
				if("Dory & Shield")
					r_hand = /obj/item/rogueweapon/spear/spellblade
					backl = /obj/item/rogueweapon/shield/heater
		if("macebearer")
			var/mace_weapons = list("Steel Mace", "Steel Warhammer & Shield", "Grand Mace", "Battle Axe", "Steel Greataxe")
			var/mace_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in mace_weapons
			var/picked_axe = FALSE
			switch(mace_choice)
				if("Steel Mace")
					r_hand = /obj/item/rogueweapon/mace/steel
				if("Steel Warhammer & Shield")
					r_hand = /obj/item/rogueweapon/mace/warhammer/steel
					backl = /obj/item/rogueweapon/shield/tower/raneshen
				if("Grand Mace")
					r_hand = /obj/item/rogueweapon/mace/goden/steel
					backl = /obj/item/rogueweapon/scabbard/gwstrap
				if("Battle Axe")
					r_hand = /obj/item/rogueweapon/stoneaxe/battle
					picked_axe = TRUE
				if("Steel Greataxe")
					r_hand = /obj/item/rogueweapon/greataxe/steel
					backl = /obj/item/rogueweapon/scabbard/gwstrap
					picked_axe = TRUE
			if(picked_axe)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
	H.merctype = 7
