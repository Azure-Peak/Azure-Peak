/datum/advclass/assassin_poisoner
	name = "Assassin - Poisoner"
	tutorial = "You've known you way around poisons, natural or man-made, for most of your life. From brewing antidotes, to creating lethal mixes. You blend in well in even noble courts as a medicine man, hiding your true inentions.."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/assassin/poisoner
	category_tags = list(CTAG_ASSASSIN)
	traits_applied = list(TRAIT_NOSTINK, TRAIT_ALCHEMY_EXPERT, TRAIT_UNCONVERTIBLE, TRAIT_BADTRAINER)	// Stinky Man - You get tossed a bone around rotting corpses. Plays into the poison and stuff.
	// Weighted 14
	// im not really sure what stats these guys *need*, honestly. throwing a bone w/ PER and all. poisons aren't very good anymore, unfortunately.
	// hopefully the higher int will let them do... some stuff. some interesting stuff. again; IDRFK.
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2, // 4
		STATKEY_INT = 3, // smart fella
		STATKEY_CON = 3, // pestran fortitude, innit?
	)
	subclass_skills = list(
		// MAIN COMBAT SKILLS
		/datum/skill/combat/knives = SKILL_LEVEL_MASTER,		// Zoo-wee mama; annoying stabber. Still shit at parrying I guess though.
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,		// May be silly but - hey, they can pose as a doctor-type.
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,		// poison arrows
		// CLASS-SPECIFIC
		/datum/skill/craft/alchemy = SKILL_LEVEL_MASTER, // craft poisons
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT, // medicine-man, innit?
		// CHICHANERY
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		// ASSASSIN ESSENTIALS
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
	)
	extra_context = "All assassins are DODGE EXPERTS, able to access the ZURCH, have NOSTINK, have ANTI-SCRYING, and are steel-hearted. \
	Each class also can summon the 'PROFANE DAGGER', which they are all experts in using."

/datum/outfit/job/roguetown/assassin/poisoner/pre_equip(mob/living/carbon/human/H)
	..()
	cloak = /obj/item/clothing/cloak/cotehardie
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/flashlight/flare/torch/lantern/prelit = 1,
					/obj/item/lockpickring/mundane = 1,
					/obj/item/rogueweapon/huntingknife/idagger/steel/corroded = 1,	// ideally, we'd actually add the poisoning thing to their *assasin dagger* but im not sure how to do that in an efficient way.
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 1,
					/obj/item/reagent_containers/glass/bottle/rogue/stampoison = 1,
					/obj/item/recipe_book/alchemy = 1,
					/obj/item/folding_alchstation_stored = 1,
					)
	mask = /obj/item/clothing/mask/rogue/physician/phys
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	head = /obj/item/clothing/head/roguetown/physician
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	beltl = /obj/item/rogueweapon/scabbard/sheath
	// medico morbo adhebe *stabs U
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)


