/datum/advclass/templar/noc_spellblade
	name = "Noccite Azurcaephan"
	tutorial = "You are a Noccite Azurcaephan - A devotee of the Azurean Church\
	Other templars clad themselves in heavy armor and relies on their miracles and their cone\
	But you know Noc's true teaching - he granted knowledge so we, humen, may seize upon it and uses magyck\
	to seize our own destiny. With steel in one hand, sorcery in the other, and Noc's blessing in your heart\
	None can stand against you. Protect the Church, its myriad acolytes, and further the pursuit of enlightenment, knowledge and mastery"
	outfit = /datum/outfit/job/roguetown/templar/noc_spellblade
	category_tags = list(CTAG_TEMPLAR)
	allowed_patrons = list(/datum/patron/divine/noc)
	maximum_possible_slots = 1 // The Special Snowflake
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ARCYNE_T2)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 1, // Weighted 7 but a nice statblock
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
	)
	subclass_spell_point_pools = list("utility" = 6)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/templar/noc_spellblade
	var/subclass_selected

/datum/outfit/job/roguetown/templar/noc_spellblade/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/templar/noc_spellblade/pre_equip(mob/living/carbon/human/H)
	..()

	// Equipment — medium armor templar with Noc theming
	wrists = /obj/item/clothing/neck/roguetown/psicross/noc
	head = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
	cloak = /obj/item/clothing/cloak/tabard/devotee/noc
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/black
	backr = /obj/item/rogueweapon/shield/heater
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/clothing/ring/silver
	backpack_contents = list(
		/obj/item/ritechalk = 1,
		/obj/item/storage/keyring/acolyte = 1,
	)

	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'

	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "noccite", "Moonlight Khopesh")
	H << browse(selection_html, "window=spellblade_chant;size=1300x1000")
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
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/caedo)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/air_strike)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/leyline_anchor)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/blade_storm)
			if("phalangite")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/azurean_phalanx)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/azurean_javelin)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/advance)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gate_of_reckoning)
			if("macebearer")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/shatter)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/tremor)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/charge)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/cataclysm)

		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/recall_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/empower_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/bind_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1, start_maxed = TRUE)

	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Church Funding.")

/datum/outfit/job/roguetown/templar/noc_spellblade/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	switch(subclass_selected)
		if("blade")
			var/list/weapons = list("Moonlight Khopesh", "Longsword", "Rapier", "Sabre", "Steel Greatsword", "Steel Dagger")
			var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
			switch(weapon_choice)
				if("Moonlight Khopesh")
					H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/nockhopesh(H))
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword(H), SLOT_BELT_R, TRUE)
				if("Longsword")
					H.put_in_hands(new /obj/item/rogueweapon/sword/long(H))
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword(H), SLOT_BELT_R, TRUE)
				if("Rapier")
					H.put_in_hands(new /obj/item/rogueweapon/sword/rapier(H))
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword(H), SLOT_BELT_R, TRUE)
				if("Sabre")
					H.put_in_hands(new /obj/item/rogueweapon/sword/sabre(H))
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword(H), SLOT_BELT_R, TRUE)
				if("Steel Greatsword")
					H.put_in_hands(new /obj/item/rogueweapon/greatsword(H))
					H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
				if("Steel Dagger")
					H.equip_to_slot_or_del(new /obj/item/rogueweapon/huntingknife/idagger/steel(H), SLOT_BELT_R, TRUE)
			if(weapon_choice == "Steel Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("phalangite")
			var/polearm_weapons = list("Halberd", "Bardiche", "Boar Spear", "Dory", "Naginata")
			var/polearm_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in polearm_weapons
			switch(polearm_choice)
				if("Halberd")
					H.put_in_hands(new /obj/item/rogueweapon/halberd(H))
					H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
				if("Bardiche")
					H.put_in_hands(new /obj/item/rogueweapon/halberd/bardiche(H))
					H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
				if("Boar Spear")
					H.put_in_hands(new /obj/item/rogueweapon/spear/boar(H))
					H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
				if("Dory")
					H.put_in_hands(new /obj/item/rogueweapon/spear/spellblade(H))
				if("Naginata")
					H.put_in_hands(new /obj/item/rogueweapon/spear/naginata(H))
					H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("macebearer")
			var/mace_weapons = list("Steel Mace", "Steel Warhammer", "Grand Mace")
			var/mace_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in mace_weapons
			switch(mace_choice)
				if("Steel Mace")
					H.put_in_hands(new /obj/item/rogueweapon/mace/steel(H))
				if("Steel Warhammer")
					H.put_in_hands(new /obj/item/rogueweapon/mace/warhammer/steel(H))
				if("Grand Mace")
					H.put_in_hands(new /obj/item/rogueweapon/mace/maul/grand(H))
					H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
