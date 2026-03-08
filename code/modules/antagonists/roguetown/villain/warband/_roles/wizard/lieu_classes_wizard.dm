//////////////////////////////////////////////
/////////////////////////////////// PYROMANCER
/*
	preset fire spells
	red for an amazing reason,
*/
/datum/advclass/warband/wizard/lieutenant/pyromancer
	title = "PYROMANCER"
	name = "Pyromancer"
	tutorial = ""
	outfit = /datum/outfit/job/roguetown/warband/wizard/lieutenant/pyromancer
	traits_applied = list(TRAIT_ARCYNE_T3, TRAIT_MAGEARMOR, TRAIT_FORMATIONFIGHTER, TRAIT_LAWEXPERT)
	subclass_stats = list(
		STATKEY_STR = -2,
		STATKEY_CON = -2,
		STATKEY_WIL = 3,
		STATKEY_INT = 5,
		STATKEY_PER = 4,
	)
	subclass_skills = list(
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_MASTER,
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
	)


/datum/outfit/job/roguetown/warband/wizard/lieutenant/pyromancer/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/wizhat/red
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/down
	cloak = /obj/item/clothing/cloak/thrall
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/magered
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/black
	beltl = /obj/item/storage/magebag
	r_hand = /obj/item/rogueweapon/woodstaff/ruby
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew,
		/obj/item/recipe_book/alchemy,
		/obj/item/reagent_containers/glass/bottle/waterskin,
		/obj/item/book/spellbook,
		/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne
	)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/meteor_storm)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball/artillery)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball/artillery)
		H.mind.AddSpell(new	/obj/effect/proc_holder/spell/invoked/projectile/fireball/greater)
		H.mind.AddSpell(new	/obj/effect/proc_holder/spell/invoked/projectile/fireball/greater)
		H.mind.AddSpell(new	/obj/effect/proc_holder/spell/self/conjure_armor/dragonhide)	
		H.mind.AddSpell(new	/obj/effect/proc_holder/spell/invoked/projectile/spitfire)
		H.mind.AddSpell(new	/obj/effect/proc_holder/spell/invoked/rebuke)
		H.mind.AddSpell(new	/obj/effect/proc_holder/spell/self/light)


///////////////////////////////////////////////
/////////////////////////////////// STORMCALLER
/*
	storm & storm-adjacent preset spells
	dual wields Two Lances w/No Great Weapon Straps
	blue for an amazing reason,
*/
/datum/advclass/warband/wizard/lieutenant/stormcaller
	title = "STORMCALLER"
	name = "Stormcaller"
	tutorial = ""
	outfit = /datum/outfit/job/roguetown/warband/wizard/lieutenant/stormcaller
	traits_applied = list(TRAIT_FORMATIONFIGHTER, TRAIT_LAWEXPERT, TRAIT_ARCYNE_T3, TRAIT_MAGEARMOR, TRAIT_DUALWIELDER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = -2,
		STATKEY_INT = 6,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,		
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,			
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)


/datum/outfit/job/roguetown/warband/wizard/lieutenant/stormcaller/pre_equip(mob/living/carbon/human/H)
	..()

	r_hand = /obj/item/rogueweapon/spear/lance
	l_hand = /obj/item/rogueweapon/spear/lance
	head = /obj/item/clothing/head/roguetown/wizhat
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/down/blue
	cloak = /obj/item/clothing/cloak/thrall
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/mageblue
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/black
	beltl = /obj/item/storage/magebag
	if(H.mind)
		if(H.patron.type == /datum/patron/inhumen/zizo)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/bloodlightning)
		else
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/sundering_lightning)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/sundering_lightning)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/thunderstrike)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/thunderstrike)
		H.mind.AddSpell(new	/obj/effect/proc_holder/spell/invoked/blink)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/leap)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravity)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/haste)



////////////////////////////////////////////
/////////////////////////////////// CONJURER
/*

*/
/datum/advclass/warband/wizard/lieutenant/conjurer
	title = "CONJURER"
	name = "Conjurer"
	tutorial = ""
	outfit = /datum/outfit/job/roguetown/warband/wizard/lieutenant/conjurer
	traits_applied = list(TRAIT_ARCYNE_T4, TRAIT_MAGEARMOR, TRAIT_FORMATIONFIGHTER, TRAIT_LAWEXPERT)
	subclass_stats = list(
		STATKEY_STR = -2,
		STATKEY_CON = 6,
		STATKEY_WIL = 6,
		STATKEY_INT = -1,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/alchemy = SKILL_LEVEL_LEGENDARY,
		/datum/skill/magic/arcane = SKILL_LEVEL_MASTER,
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
	)


/datum/outfit/job/roguetown/warband/wizard/lieutenant/conjurer/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/wizhat/yellow
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/down/yellow
	cloak = /obj/item/clothing/cloak/thrall
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/mageyellow
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/black
	beltl = /obj/item/storage/magebag
	r_hand = /obj/item/rogueweapon/woodstaff/toper
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew,
		/obj/item/alch/airdust,
		/obj/item/alch/waterdust,
		/obj/item/alch/firedust,
		/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne
	)
	if(H.mind) // who gives a fuck anymore bro
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/forcewall/greater)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/forcewall/greater)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/forcewall/greater)
