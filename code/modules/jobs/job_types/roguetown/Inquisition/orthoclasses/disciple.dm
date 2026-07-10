/datum/advclass/disciple
	name = "Disciple"
	tutorial = "Psydonite monks, practiced in both martiality and scripture. Spilling blood on sacred grounds is considered 'sinful' to the clergymen, though no qualms are spared towards knocking someone's lights out."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/disciple
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_ORTHODOXIST)
	traits_applied = list(
		TRAIT_CIVILIZEDBARBARIAN,
		TRAIT_BLOOD_RESISTANCE,
		TRAIT_STEELHEARTED,
		TRAIT_INQUISITION
	)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_INT = -1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"The Book" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass can choose from multiple Disciplines. Your unarmed skills are inversely scaled; the better that a chosen Discipline is at fistfighting, the worse that they'll be at wrestling."

/datum/outfit/job/roguetown/disciple
	job_bitflag = BITFLAG_HOLY_WARRIOR

/obj/item/storage/belt/rogue/leather/rope/upgraded/dark
	color = "#505050"

/datum/outfit/job/roguetown/disciple/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	if(H.mind)
		var/weapons = list("Abboteer - Master Pugilist, Weaponless Oath & No Malus", "Pugilist - Master Athletics, Pain Resistance", "Quarterstaff - Expert Staves, +I PER / +I INT", "Katar", "Knuckledusters")
		var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
		switch(weapon_choice)
			if("Abboteer - Master Pugilist, Weaponless Oath & No Malus")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/magic/holy, SKILL_LEVEL_JOURNEYMAN, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
				ADD_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_WEAPONLESS, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_STRONGBITE, TRAIT_GENERIC)
				H.change_stat(STATKEY_INT, 1)
				H.change_stat(STATKEY_SPD, 1)
			if("Pugilist - Master Athletics, Pain Resistance")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
				ADD_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
			if("Quarterstaff - Expert Staves, +I PER / +I INT")
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/psy
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
				H.change_stat(STATKEY_PER, 1)
			if("Katar")
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/katar/psydon
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
			if("Knuckledusters")
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/knuckledusters/psy
		var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff") // cool wrestling moves for non-magic guys.
		var/technique_choice = input(H,"Choose your TECHNIQUE.", "DECIMATE AND DOMINATE WITH FLAIR.") as anything in techniques
		switch(technique_choice)
			if("Dropkick - Pushback + Extra Damage")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
			if("Chokeslam - Stamina Damage")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
			if("Stunner - Dazed Debuff")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
			if("Headbutt - Vulnerable Debuff")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)

	head = /obj/item/clothing/head/roguetown/roguehood/psydon
	mask = /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	wrists = /obj/item/clothing/wrists/roguetown/bracers/psythorns
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	id = /obj/item/clothing/ring/signet/psy

	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple

	backpack_contents = list(/obj/item/roguekey/inquisitionmanor = 1,
	/obj/item/paper/inqslip/arrival/ortho = 1)
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	cloak = /obj/item/clothing/cloak/tabard/psydontabard/alt

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles.
