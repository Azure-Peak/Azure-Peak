/datum/job/roguetown/greater_skeleton
	title = "Greater Skeleton"
	flag = SKELETON
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null //no pq
	max_pq = null
	announce_latejoin = FALSE

	advclass_cat_rolls = list(CTAG_NSKELETON = 20)

	tutorial = "You are bygone. A wandering has-been. But maybe your luck has not run out, yet.."

	outfit = /datum/outfit/job/roguetown/greater_skeleton/necro
	show_in_credits = TRUE 
	give_bank_account = FALSE
	hidden_job = TRUE
	vice_restrictions = list(/datum/charflaw/hunted)

/datum/outfit/job/roguetown/greater_skeleton/pre_equip(mob/living/carbon/human/H)
	..()

	ADD_TRAIT(H, TRAIT_OUTLAW, TRAIT_GENERIC) //No miesters for skeletons, you're an undead, bloodless skeletal abomination.
	ADD_TRAIT(H, TRAIT_SHATTER_KILL, TRAIT_GENERIC) //Softer version of crit weakness that only kills with paralysis/rib fractures and nothing else.

	H.set_patron(/datum/patron/inhumen/zizo)

	H.possible_rmb_intents = list(/datum/rmb_intent/feint,\
	/datum/rmb_intent/aimed,\
	/datum/rmb_intent/riposte,\
	/datum/rmb_intent/strong,\
	/datum/rmb_intent/weak)
	H.swap_rmb_intent(num=1)

	var/datum/antagonist/new_antag = new /datum/antagonist/skeleton()
	H.mind.add_antag_datum(new_antag)

	H.grant_language(/datum/language/undead)

	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/undead

/datum/job/roguetown/greater_skeleton/after_spawn(mob/living/L, mob/M, latejoin = FALSE)
	..()

	var/mob/living/carbon/human/H = L
	H.mob_biotypes |= MOB_UNDEAD

	H.advsetup = TRUE
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")
	for (var/obj/item/bodypart/B in H.bodyparts)
		B.skeletonize(FALSE)

/*
NECRO SKELETONS
*/


/datum/outfit/job/roguetown/greater_skeleton/necro
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron

/datum/outfit/job/roguetown/greater_skeleton/necro/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = prob(50) ? /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant : /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

// Melee fighter with a shield. Holds the line.
/datum/advclass/greater_skeleton/necro/legionnaire
	name = "Decrepit Legionnaire"
	tutorial = "Legions rise and you answer. Stand proud with your line; for you serve the architect. You know death. Memento mori. You just can't understand it."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/necro/legionnaire

	category_tags = list(CTAG_NSKELETON)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,

	)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_SILVER_WEAK)

/datum/outfit/job/roguetown/greater_skeleton/necro/legionnaire/pre_equip(mob/living/carbon/human/H)
	..()

	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.STASTR = prob(2) ? 18 : rand(11,12)
	H.STAPER = rand(9,11)
	H.STASPD = rand(7,8)
	H.STACON = rand(7,9)
	H.STAWIL = rand(10,11)
	H.STAINT = rand(1,3)

	pants = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backr = /obj/item/rogueweapon/shield/wood

	H.adjust_blindness(-3)
	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/necro
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/necro
		if("Black Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich
	var/weapon_choice = input(H, "Choose your weapon.", "WHAT WILL YOU CARRY?") as anything in list("Sword", "Axe")
	H.set_blindness(0)
	switch(weapon_choice)
		if("Sword")
			beltr = /obj/item/rogueweapon/sword
		if("Axe")
			beltr = /obj/item/rogueweapon/stoneaxe/woodcut

	H.energy = H.max_energy

// Ranged skeleton with either a bow or a sling.
/datum/advclass/greater_skeleton/necro/ballistiare
	name = "Hollow Ballistiare"
	tutorial = "You're broken, cracked and risen anew. How do they expect a lesser rattler like you to shoot out the eyes of our enemies? The Dame of Progress smiles at you tonight. Make Her proud."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/necro/ballistiare

	category_tags = list(CTAG_NSKELETON)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
	)
	traits_applied = list(TRAIT_SILVER_WEAK)

/datum/outfit/job/roguetown/greater_skeleton/necro/ballistiare/pre_equip(mob/living/carbon/human/H)
	..()

	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.STASTR = 8
	H.STASPD = 9
	H.STACON = 8
	H.STAWIL = 12
	H.STAINT = 6
	H.STAPER = 14

	head = /obj/item/clothing/head/roguetown/helmet/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots
	beltr = /obj/item/rogueweapon/huntingknife/idagger

	H.adjust_blindness(-3)
	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/necro
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/necro
		if("Black Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich
	var/weapon_choice = input(H, "Choose your weapon.", "WHAT WILL YOU CARRY?") as anything in list("Bow", "Sling")
	H.set_blindness(0)
	switch(weapon_choice)
		if("Bow")
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
			beltl = /obj/item/quiver/arrows
		if("Sling")
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			beltl = /obj/item/quiver/sling/iron

	H.energy = H.max_energy

// Crafting and labor skeleton. Tools double as weapons.
/datum/advclass/greater_skeleton/necro/sapper
	name = "Lesser Bone Sapper"
	tutorial = "Toil toil toil. You rise to work. You rise to rebell; but your rebellion is localized in the smithy, in the sawmills, in the plants. Create under the foreman and the architect."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/necro/sapper

	category_tags = list(CTAG_NSKELETON)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
	)
	traits_applied = list(TRAIT_SILVER_WEAK)

/datum/outfit/job/roguetown/greater_skeleton/necro/sapper/pre_equip(mob/living/carbon/human/H)
	..()

	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	H.STASTR = rand(8,10)
	H.STASPD = rand(4,6)
	H.STACON = rand(6,8)
	H.STAWIL = rand(8,10)
	H.STAINT = prob(2) ? 18 : rand(4,6)
	H.STAPER = rand(6,8)

	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer/lich
	pants = /obj/item/clothing/under/roguetown/trou/artipants/lich
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut
	beltl = /obj/item/rogueweapon/pick

	H.adjust_blindness(-3)
	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/necro
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/necro
		if("Black Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

/obj/item/clothing/cloak/tabard/stabard/surcoat/necro
	name = "decrepit jupon"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who are condemned to march forevermore."
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/tabard/necro
	name = "decrepit tabard"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who once knew of chivalry's allure."
	color = CLOTHING_BLACK
