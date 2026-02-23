// Zizite Spellblade — wretch spellblade variant.
// Medium armor + T1 caster (healing/profane) instead of dodge expert.
/datum/advclass/wretch/zizite_spellblade
	name = "Zizite Spellblade"
	tutorial = "You are a devotee of Zizo, Mistress of Progress. While her followers descend into necromancy and obsession with undeath, you remember her true teachings. That magic is a tool of advancement. You combined her gifts with martial discipline, forging yourself into a Spellblade - an ancient art native to Azurea, now, with renewed lyfe. Unlike other spellblades, you know how to wield such terrifying power together with armor. Truly, the Mistress of Progress always favor her followers. The Church brands you a heretic, the Necromancers call you fools, the Oaks see only deviation. Let them. Her light will shine through, and one cut at a time, you shall save this world from stagnation. Her Will Be Done."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	allowed_patrons = list(/datum/patron/inhumen/zizo)
	outfit = /datum/outfit/job/roguetown/wretch/zizite_spellblade
	maximum_possible_slots = 2 // Team rocket!!!
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ARCYNE_T2, TRAIT_ARCYNE_T1)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 2, // Weighted 7. But a very nice statblock 
		STATKEY_CON = 1,
		STATKEY_WIL = 2, // With 2 Wil they should not be struggling
	)
	subclass_spell_point_pools = list("utility" = 6) // Mama Zizo said you get 2 more points on Utility!!!
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE, // Welcome to bad holy skills scaling
	)

/datum/outfit/job/roguetown/wretch/zizite_spellblade
	var/subclass_selected

/datum/outfit/job/roguetown/wretch/zizite_spellblade/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/wretch/zizite_spellblade/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/roguehood
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1)

	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "zizite")
	H << browse(selection_html, "window=spellblade_chant;size=900x900")
	onclose(H, "spellblade_chant", src)

	var/open_time = world.time
	while(!subclass_selected && world.time - open_time < 60 SECONDS)
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
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/caedo)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/air_strike)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/forcewall/greater)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/blade_storm)
			if("phalangite")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/azurean_phalanx)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/azurean_javelin)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/advance)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gate_of_reckoning)
			if("macebearer")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/shatter)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/tremor)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/charge)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/cataclysm)

		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/recall_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/bind_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)

	// Armor choice: Discretion (light, like adventurer) vs Progress (medium armor set with helmet)
	var/armor_style = list("Discretion (Spellblade Disguise)", "Progress (Medium Armor)")
	var/armor_choice = input(H, "Choose your armament philosophy.", "HER LIGHT SHINES THROUGH") as anything in armor_style
	switch(armor_choice)
		if("Discretion (Spellblade Disguise)")
			head = /obj/item/clothing/head/roguetown/roguehood
			armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
		if("Progress (Medium Armor)")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk

	backr = /obj/item/rogueweapon/shield/heater

	switch(subclass_selected)
		if("blade")
			var/weapons = list("Avantyne Longsword", "Kriegmesser", "Longsword", "Rapier", "Sabre")
			var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
			beltr = /obj/item/rogueweapon/scabbard/sword
			switch(weapon_choice)
				if("Avantyne Longsword")
					r_hand = /obj/item/rogueweapon/sword/long/zizo
				if("Kriegmesser")
					r_hand = /obj/item/rogueweapon/sword/long/kriegmesser
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Longsword")
					r_hand = /obj/item/rogueweapon/sword/long
				if("Rapier")
					r_hand = /obj/item/rogueweapon/sword/rapier
				if("Sabre")
					r_hand = /obj/item/rogueweapon/sword/sabre
		if("phalangite")
			var/polearm_weapons = list("Halberd", "Bardiche", "Boar Spear")
			var/polearm_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in polearm_weapons
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			switch(polearm_choice)
				if("Halberd")
					r_hand = /obj/item/rogueweapon/halberd
				if("Bardiche")
					r_hand = /obj/item/rogueweapon/halberd/bardiche
				if("Boar Spear")
					r_hand = /obj/item/rogueweapon/spear/boar
		if("macebearer")
			var/mace_weapons = list("Steel Mace", "Steel Warhammer")
			var/mace_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in mace_weapons
			switch(mace_choice)
				if("Steel Mace")
					r_hand = /obj/item/rogueweapon/mace/steel
				if("Steel Warhammer")
					r_hand = /obj/item/rogueweapon/mace/warhammer/steel

	H.cmode_music = 'sound/music/combat_heretic.ogg'
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1, start_maxed = TRUE)	
	//Minor regen, T1 only. Cannot progress beyond that (hah). Mostly for self healing.
	wretch_select_bounty(H)
