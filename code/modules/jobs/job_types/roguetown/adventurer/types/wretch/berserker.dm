/datum/advclass/wretch/berserker
	name = "Berserker"
	tutorial = "You are a warrior feared for your brutality, dedicated to using your might for your own gain. Might equals right, and you are the reminder of such a saying."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/berserker
	cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_STRONGBITE, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_NOPAINSTUN, TRAIT_BLOOD_RESISTANCE, TRAIT_RAGE)
	extra_context = "This subclass gains access to the RAGE ability."
	// total of 5 because int gets nuked by 2 similar to barbarian, still better then adv barb for +1
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_INT = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
        "Sewing Kit" =  /obj/item/repair_kit,
    )

/datum/outfit/job/roguetown/wretch/berserker
	var/subclass_selected

/datum/outfit/job/roguetown/wretch/berserker/pre_equip(mob/living/carbon/human/H)
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/rope // more wild look + aura
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding //Used to be a reinforced leather coif, but crit resist kinda leaves your head open to shit
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/combat = 1, //Steel variant of the hunting knife. Pseudoantagonist-tier, plus an avenue to hack limbs with.
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	if(H.mind)
		H.set_blindness(0)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rage)
		var/list/main_choices = list("Unarmed Master", "Martial Expert") // Unarmed focuses on master punching and wrestling moves, Martial gives you two expert weapon skills to be flexible
		var/category_choice = input(H, "Choose your MEANS OF VIOLENCE.", "SMASH OR SLASH!!") as anything in main_choices
		switch(category_choice)
			if("Unarmed Master") //still incredibly strong btw, apply punch to skull
				var/list/unarmed_options = list("Discipline - Unarmed", "Katar", "Knuckledusters", "Punch Dagger", )
				var/weapon_choice = input(H, "Choose how you PUNCH!", "BREAK THEIR BONES.") as anything in unarmed_options
				switch(weapon_choice)
					if("Discipline - Unarmed")
						H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
						ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
						gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted // apperantly normal barb gets em so for consistency sake
						armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/berserker
					if("Katar")
						H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
						beltr = /obj/item/rogueweapon/katar
					if("Knuckledusters")
						H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
						gloves = /obj/item/clothing/gloves/roguetown/knuckles
					if("Punch Dagger")
						H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
						beltr = /obj/item/rogueweapon/katar/punchdagger
				var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff") // cool wrestling moves
				var/technique_choice = input(H,"Choose your TECHNIQUE.", "TOSS THEM.") as anything in techniques
				switch(technique_choice)
					if("Dropkick - Pushback + Extra Damage")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
					if("Chokeslam - Stamina Damage")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
					if("Stunner - Dazed Debuff")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
					if("Headbutt - Vulnerable Debuff")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)
			if("Martial Expert") // designed to compete with unarmed by giving you alternatives to approaching fights- only expert 
				var/list/martial_options = list("Discipline - Bodybuilder", "Battle Axe", "Grand Mace", "Longsword")
				var/weapon_choice = input(H, "Choose your WEAPONS of WAR!", "SPILL THEIR ENTRAILS.") as anything in martial_options
				switch(weapon_choice)
					if("Discipline - Bodybuilder") //Actually not a meme anymore
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
						H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE) //they need this to actually do pushups, it's the only way they can fix their armor
						r_hand = /obj/item/rogueweapon/greatsword/paalloy
						armor = /obj/item/clothing/suit/roguetown/armor/manual/pushups/leather/good
						backl = /obj/item/rogueweapon/scabbard/gwstrap
					if("Battle Axe")
						H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
						beltr = /obj/item/rogueweapon/stoneaxe/battle
					if("Grand Mace")
						H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
						beltr = /obj/item/rogueweapon/mace/goden/steel
					if("Longsword") //Swapped out the falx for this, it's a primary weapon afterall
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
						beltr = /obj/item/rogueweapon/scabbard/sword
						r_hand = /obj/item/rogueweapon/sword/falx
				var/list/sidearm_options = list("Iron Arming Sword", "Iron Axe", "Mace")
				var/sidearm_choice = input(H, "Choose your secondary WEAPON!", "SPILL THEIR ENTRAILS.") as anything in sidearm_options
				switch(sidearm_choice)
					if("Iron Arming Sword")
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
						beltl = /obj/item/rogueweapon/sword/iron
					if("Iron Axe")
						H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
						beltl = /obj/item/rogueweapon/stoneaxe/woodcut
					if("Mace")
						H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
						beltl = /obj/item/rogueweapon/mace

		var/helmets = list("Berserker's Volfskulle Bascinet","Steel Kettle + Wildguard")
		var/helmet_choice = input(H, "Choose your HELMET.", "STEEL YOURSELF.") as anything in helmets
		switch(helmet_choice)
			if("Berserker's Volfskulle Bascinet")
				head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker //Pseudoantagonistic-exclusive. Light AC with an on-wear trait for HELMBITING.
			if("Steel Kettle + Wildguard")
				head = /obj/item/clothing/head/roguetown/helmet/kettle
				mask = /obj/item/clothing/mask/rogue/wildguard
		wretch_select_bounty(H)
