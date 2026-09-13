/datum/advclass/iconoclast //Support Cleric, Heavy armor, unarmed, miracles.
	name = "Iconoclast"
	tutorial = "Trained by an Ecclesial sect, you uphold the Ideological purity of the Matthiosian Creed. Take from the wealthy, give to the worthless, empower. They will look up to you, in search of the God of Robbery's guidance. Be their light in the dark."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED)
	outfit = /datum/outfit/job/roguetown/bandit/iconoclast
	category_tags = list(CTAG_BANDIT)
	maximum_possible_slots = 1 // We only want one of these.
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN, TRAIT_HEAVYARMOR, TRAIT_RITUALIST)
	subclass_stats = list(
		STATKEY_STR = 3,// LETS WRASSLE
		STATKEY_CON = 1,
		STATKEY_WIL = 3,// This is our Go Big stat, we want lots of stamina for miracles and WRASSLIN.
		STATKEY_LCK = 2,//We have a total of +12 in stats.
	)
	subclass_skills = list(
		/datum/skill/combat/whipsflails = SKILL_LEVEL_MASTER,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	)
	cmode_music = 'sound/music/Iconoclast.ogg'

/datum/outfit/job/roguetown/bandit/iconoclast/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/inhumen/matthios)))
		to_chat(H, span_warning("Matthios embraces me.. I must uphold his creed. I am his light in the darkness."))
		H.set_patron(/datum/patron/inhumen/matthios)
	r_hand = /obj/item/rogueweapon/woodstaff
	head = /obj/item/clothing/head/roguetown/roguehood
	neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	armor = /obj/item/clothing/suit/roguetown/armor/plate
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/katar
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/mattcoin
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/ritechalk = 1,
					)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
	H.mind.AddSpell(new /datum/action/cooldown/spell/matthios/raze)
