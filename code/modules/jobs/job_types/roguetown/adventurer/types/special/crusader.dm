/datum/advclass/crusader
	name = "Crusader"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/crusader
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_MEDIUMARMOR)

	maximum_possible_slots = 1 // Disabled Role

	tutorial = "The crusaders... Knights who have pledged \
	their wealth and lands to the church, taking up the banner \
	of one of the rival Orders dedicated to retaking the holy land. \
	The 451st crusade is sure to be the last."

	category_tags = list(CTAG_DISABLED)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
		STATKEY_INT = 1
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/crusader
	name = "Crusader"

/datum/outfit/job/roguetown/adventurer/crusader/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.current.faction += "[H.name]_faction"
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	armor = /obj/item/clothing/cloak/tabard/stabard/crusader
	cloak = /obj/item/clothing/cloak/cape/crusader
	gloves = /obj/item/clothing/gloves/roguetown/chain
	backr = /obj/item/rogueweapon/shield/tower/metal
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/decorated
	beltl = /obj/item/clothing/head/roguetown/helmet/heavy/crusader
	neck = /obj/item/clothing/neck/roguetown/psicross/g
	backpack_contents = list(
						/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
						/obj/item/flashlight/flare/torch = 1,
						)

	for(var/I in SSrole_class_handler.sorted_class_categories[CTAG_ALLCLASS])
		var/datum/advclass/A = I
		if(A.name == name)
			if(A.total_slots_occupied > 1)
				armor = /obj/item/clothing/cloak/tabard/stabard/crusader/t
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				beltl = /obj/item/clothing/head/roguetown/helmet/heavy/crusader/t
				neck = /obj/item/clothing/neck/roguetown/psicross
				r_hand = /obj/item/rogueweapon/sword/sabre
				beltr = /obj/item/rogueweapon/scabbard/sword
				belt = /obj/item/storage/belt/rogue/leather/plaquesilver

	if(should_wear_femme_clothes(H))
		backr = /obj/item/storage/backpack/rogue/satchel
		gloves = null
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		backpack_contents = list(
							/obj/item/rogueweapon/huntingknife/idagger/silver = 1,
							/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
							/obj/item/flashlight/flare/torch = 1,
							/obj/item/rogueweapon/scabbard/sheath = 1
							)
		H.change_stat(STATKEY_STR, 1)


	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR)	//Minor regen, can level up to T4.

/obj/item/clothing/cloak/tabard/stabard/crusader
	name = "surcoat of the golden order"
	desc = "A regal surcoat, inlined with golden threading. The stitchwork tethers it to the Golden Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from heathens, cultists, and the ever-looming threat of another calamity. This variant bares the psicruciformic sigil of the Psydonic and Necran \
	orders."
	icon_state = "crusader_surcoat"
	icon = 'icons/roguetown/clothing/special/crusader.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/crusader.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/crusader.dmi'

/obj/item/clothing/cloak/tabard/stabard/crusader/t
	name = "surcoat of the silver order"
	desc = "A noble surcoat, inlined with silver threading. The stitchwork tethers it to the Silver Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from monsters, deadites, and the ever-looming threat of another calamity. This variant bares the psicruciformic sigil of the Psydonic and Necran \
	orders."
	icon_state = "crusader_surcoatt2"

/obj/item/clothing/cloak/tabard/stabard/crusader/astrata
	name = "surcoat of the golden order"
	desc = "A regal surcoat, inlined with golden threading. The stitchwork tethers it to the Golden Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from heathens, cultists, and the ever-looming threat of another calamity. This variant bares the duocruciformic sigil of the Astratan and Ravoxian \
	orders."
	icon_state = "acrusader_surcoat"

/obj/item/clothing/cloak/tabard/stabard/crusader/t/astrata
	name = "surcoat of the silver order"
	desc = "A noble surcoat, inlined with silver threading. The stitchwork tethers it to the Silver Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from monsters, deadites, and the ever-looming threat of another calamity. This variant bares the duocruciformic sigil of the Astratan and Ravoxian \
	orders."
	icon_state = "acrusader_surcoatt2"

/obj/item/clothing/cloak/tabard/stabard/crusader/undivided
	name = "surcoat of the golden order"
	desc = "A regal surcoat, inlined with golden threading. The stitchwork tethers it to the Golden Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from heathens, cultists, and the ever-looming threat of another calamity. This variant bares the unicruciform sigil of the Undivided and Erranteer \
	orders."
	icon_state = "acrusader_surcoat"

/obj/item/clothing/cloak/tabard/stabard/crusader/t/undivided
	name = "surcoat of the silver order"
	desc = "A noble surcoat, inlined with silver threading. The stitchwork tethers it to the Silver Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from monsters, deadites, and the ever-looming threat of another calamity. This variant bares the unicruciform sigil of the Undivided and Erranteer \
	orders."
	icon_state = "acrusader_surcoatt2"

/obj/item/clothing/cloak/tabard/stabard/crusader/bsteel
	name = "surcoat of the blacksteel order"
	desc = "A venerated surcoat, inlined with blacksteel threading. The stitchwork tethers it to the Blacksteel Order; an ancient faith-militance whose roots trace \
	all the way back to Psydonia's first crusaders. Uniquely welcoming to both Psydonic and Undivided patroneers, and irreversably valorant against the dreaded \
	Avantyne Legion. </br>'Happiness must be fought for, lest all hope perish from the face of this world.'"
	icon_state = "crusader_surcoatb3"

/obj/item/clothing/cloak/tabard/stabard/crusader/heavy
	name = "overvestments"
	desc = "A heavy surcoat that offers complete modesty and protection against the weather, but leaves the thinner-framed with sorer shoulders. Commonly seen upon \
	the bods of paladin-errants, priests, and pilgrims across Psydonia's more intemperate climates."
	icon_state = "priest_surcoat"

//

/obj/item/clothing/cloak/tabard/stabard/crusader/legacy
	name = "valorian surcoat of the golden order"
	desc = "A regal surcoat, inlined with golden threading. The stitchwork tethers it to the Golden Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from heathens, cultists, and the ever-looming threat of another calamity. This variant predates them all - stitched by Valorian seamstresses to adorn \
	the bods of Rockhill's final crusaders. </br>'Into the darkness, unto the light; steel to the heathen, so that their sins may be set right.'"
	icon_state = "legacy_crusader_surcoat"
	icon = 'icons/roguetown/clothing/special/crusader.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/crusader.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/crusader.dmi'

/obj/item/clothing/cloak/tabard/stabard/crusader/t/legacy
	name = "valorian surcoat of the silver order"
	desc = "A noble surcoat, inlined with silver threading. The stitchwork tethers it to the Silver Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from monsters, deadites, and the ever-looming threat of another calamity. This variant predates them all - stitched by Valorian seamstresses to adorn \
	the bods of Rockhill's final crusaders. </br>'Lest we forget, before we forgive; silver to the monster, for the Hell they'll relive.'"
	icon_state = "legacy_crusader_surcoatt2"

//

/obj/item/clothing/cloak/cape/crusader
	name = "desert cape"
	desc = "Were we to've met in another lyfetime, do you suppose we would've been fonder friends?"
	icon_state = "crusader_cloak"
	icon = 'icons/roguetown/clothing/special/crusader.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/crusader.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/crusader.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/crusader //Legacy, but kept in to avoid potential errors. Refer to the 'sugarloaf' helmet variants for a more modern take.
	name = "bucket helm"
	icon_state = "crusader_helm"
	icon = 'icons/roguetown/clothing/special/crusader.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/crusader.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/crusader/t
	icon_state = "crusader_helmt2"

/obj/item/clothing/cloak/cape/crusader/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/roguetown/cloak)

/obj/item/clothing/cloak/cape/crusader/attack_right(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		CP.rmb_show(user)
		return TRUE
	..()

/obj/item/clothing/cloak/cape/crusader/dropped(mob/living/carbon/human/user)
	..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))
