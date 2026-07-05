/datum/advclass/wretch/necromancer
	name = "Necromancer"
	tutorial = "You have been ostracized and hunted by society for your dark magics and perversion of lyfe; your speciality is gaining power through what you raise."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/wretch/necromancer
	cmode_music = 'sound/music/combat_heretic.ogg'
	class_select_category = CLASS_CAT_MAGE
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_ZOMBIE_IMMUNE, TRAIT_NOSTINK, TRAIT_GRAVEROBBER, TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT, TRAIT_MEDICINE_EXPERT)
	maximum_possible_slots = 2 // Skeles no longer count vs antag cap, however these are pretty strong mage roles with some inzane potental that can make them a fucking menace to deal with if they work for it. A la-wretch heretics.
	//Slightly worse spread than rogue mage, trades off with a lot of summoning potental + pretty fucking decent armor choice that's more obvious long-term + player skeles with numbers + traits + medicine skill.
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 2,
		STATKEY_WIL = 1
	)
	age_mod = /datum/class_age_mod/wretch/rogue_mage
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 4, "post_aspect_spells" = list(/datum/action/cooldown/spell/message, /datum/action/cooldown/spell/mindlink), "ward" = TRUE)
	//VS rogue mage, weaker combat skills + less alchemy (works with the living less often) to make up for their minions doing the work for them.
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT, //For lux extractions/revivals (Higher than rogue mage by 2 levels).
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
        "Sewing Kit" =  /obj/item/repair_kit,
    )

/datum/outfit/job/roguetown/wretch/necromancer/pre_equip(mob/living/carbon/human/H)
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	backl = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/rogueweapon/spellbook/greater = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/necro_relics/necro_crystal = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/chalk = 1,
		)
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard]
	if(H.mind)
		backr = choose_implement(H, "greater")
		H.set_patron(/datum/patron/inhumen/zizo)
		H.mind.AddSpell(new /datum/action/cooldown/spell/eyebite)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonechill)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)
		H.mind.AddSpell(new /datum/action/cooldown/spell/minion_order)
		H.mind.AddSpell(new /datum/action/cooldown/spell/gravemark)
		H.mind.AddSpell(new /datum/action/cooldown/spell/raise_undead_formation/necromancer)
		H.mind.AddSpell(new /datum/action/cooldown/spell/raise_undead_guard/necromancer)
		H.mind.AddSpell(new /datum/action/cooldown/spell/convert_heretic/arcyne)
		H.mind.AddSpell(new /datum/action/cooldown/spell/lacrima)
		H.mind.AddSpell(new /datum/action/cooldown/spell/tame_undead)
		H.mind.AddSpell(new /datum/action/cooldown/spell/raise_deadite)
		wretch_select_bounty(H)
	H.grant_language(/datum/language/undead)

	// Armor choice: Discretion (lighter robes, subtle similar to rogue mage) vs Progress (open armored necromancer robes) with better protection potental and unique drip
	var/armor_style = list("Discretion (Mage Disguise)", "Progress (Open Necromancer Robes)")
	var/armor_choice = input(H, "Choose your scholarship route.", "NO COST TOO GREAT") as anything in armor_style
	switch(armor_choice)
		if("Discretion (Mage Disguise)")
			head = /obj/item/clothing/head/roguetown/roguehood/black
			neck = /obj/item/clothing/neck/roguetown/gorget
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/black
			belt = /obj/item/storage/belt/rogue/leather
			beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot //Hacky solution so you don't lose em.
			beltl = /obj/item/rogueweapon/huntingknife
		if("Progress (Open Necromancer Robes)") //Good light armored potental, at a price of being super obvious with unique robes.
			head = /obj/item/clothing/head/roguetown/roguehood/unholy/enchanted
			neck = /obj/item/clothing/neck/roguetown/leather //Lesser gorget for more armor elsewhere, have to aquire one in the round.
			belt = /obj/item/storage/belt/rogue/leather/black
			beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot //Hacky solution so you don't lose em.
			beltl = /obj/item/rogueweapon/huntingknife
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson //Can upgrade this via sewing/theft, balances out with the robes also having armor + head armor with this choice.
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/unholy/enchanted
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/bronze //It ain't gold, it ain't decrepit, but its certainly fitting for YOU.
