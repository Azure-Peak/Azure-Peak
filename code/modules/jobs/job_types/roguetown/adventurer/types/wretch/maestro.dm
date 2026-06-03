/datum/advclass/wretch/maestro
	name = "Maestro"
	tutorial = "You were renowned all over Psydonia for your song and merriment until you seduced the wrong dragon or made too many jokes at a noble's expense. Whatever happened, you now play melancholic or manic songs for the dregs of society. Lyve your best lyfe and lyve to tell the tale."
	allowed_sexes = list(MALE, FEMALE)

	outfit              = /datum/outfit/job/roguetown/wretch/maestro
	age_mod             = /datum/class_age_mod/wretch/maestro
	cmode_music         = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	class_select_category = CLASS_CAT_ROGUE
	category_tags       = list(CTAG_WRETCH)
	traits_applied      = list(TRAIT_DODGEEXPERT, TRAIT_GOODLOVER, TRAIT_INSPIRING_MUSICIAN)
	extra_context       = "All paths gain Allegro: every 5th landed rhythm restores energy.<br>\
						  Busker gains Empath, Deceiving Meekness, and Light Step, with Expert Sneaking, Stealing, Lockpicking, Climbing, and Knives (Parrying Knife).<br>\
						  Cacophonist gains a bonus rhythm pick (3 total) and song slot (5 total), with Expert Swords and Whips & Flails (Alloy-tipped whip & Arming Sword).<br>\
						  Boomwhacker gains Expert Pugilist and +1 Strength, with Expert Unarmed and Wrestling (Knuckle dusters & Katar).<br>\
						  Chanter gains T1 miracles (slow Devotion regen), with Journeyman Holy skill.<br>\
						  Cipher gains one Minor Arcane aspect, five Utility points, and one offensive cantrip of choice."
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/music       = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking    = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing    = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics   = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing    = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading     = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives    = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming    = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps      = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"Sewing Kit" = /obj/item/repair_kit,
	)

/datum/outfit/job/roguetown/wretch/maestro/pre_equip(mob/living/carbon/human/H)
	..()

	head   = /obj/item/clothing/head/roguetown/bardhat
	armor  = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	cloak  = /obj/item/clothing/cloak/thief_cloak/yoruku
	shirt  = /obj/item/clothing/suit/roguetown/armor/gambeson
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	pants  = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes  = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt   = /obj/item/storage/belt/rogue/leather/knifebelt/black/iron
	beltr  = /obj/item/rogueweapon/huntingknife/idagger/steel
	backl  = /obj/item/storage/backpack/rogue/satchel
	mask   = /obj/item/clothing/mask/rogue/duelmask
	neck   = /obj/item/clothing/neck/roguetown/coif/heavypadding
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit					= 1,
		/obj/item/rogueweapon/scabbard/sheath							= 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot	= 1,
		/obj/item/reagent_containers/glass/bottle/rogue/manapot			= 1,
	)

	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T2)
	I.allegro_enabled = TRUE // Allegro — every 5th landed rhythm restores energy

	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/vicious_mockery)

		var/instruments = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman","Psyaltery","Flute","Drums")
		var/instrument_choice = input(H, "Choose your instrument.", "Choose your instrument.") as anything in instruments
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
			if("Drums")
				backr = /obj/item/rogue/instrument/drum

		var/paths = list("Busker", "Cacophonist", "Boomwhacker", "Chanter", "Cipher")
		var/path_choice = input(H, "Choose your genre.", "Choose your genre") as anything in paths
		switch(path_choice)
			if("Busker")
				ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_DECEIVING_MEEKNESS, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking,    SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/stealing,    SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/climbing,    SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives,    SKILL_LEVEL_EXPERT, TRUE)
				beltr  = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
			if("Cacophonist")
				H.inspiration.bonus_rhythm_picks = 1 // 3 rhythm picks instead of T2 default 2
				H.inspiration.maxsongs++             // 5 song slots instead of T2 default 4
				H.adjust_skillrank_up_to(/datum/skill/combat/swords,      SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/whip/triumph
				l_hand = /obj/item/rogueweapon/sword
				beltl  = /obj/item/rogueweapon/scabbard/sword
			if("Boomwhacker")
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed,   SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling,  SKILL_LEVEL_EXPERT, TRUE)
				H.change_stat(STATKEY_STR, 1)
				gloves = /obj/item/clothing/gloves/roguetown/knuckles
				beltl  = /obj/item/rogueweapon/katar
			if("Chanter")
				H.adjust_skillrank_up_to(/datum/skill/magic/holy, SKILL_LEVEL_JOURNEYMAN, TRUE)
				var/datum/devotion/D = new /datum/devotion(H, H.patron)
				D.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
			if("Cipher")
				ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 5))
				r_hand = /obj/item/book/spellbook
				var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Greater Arcyne Bolt", "Stygian Efflorescence", "Arcyne Lance", "Lesser Gravel Blast", "Lesser Soulshot")
				var/poke_choice = input(H, "Choose your cantrip.", "Choose your cantrip") as anything in poke_options
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
					if("Lesser Soulshot")
						H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/soulshot/lesser)

		wretch_select_bounty(H)
