/datum/advclass/barbersurgeon
	name = "Barber Surgeon"
	tutorial = "Wielding crude tools and accumulated knowledge, you are something of a 'freelance physician' even if the local apothecary declined your application, and over the yils have probably cut into more people than the average knight."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED)
	
	outfit = /datum/outfit/job/roguetown/adventurer/doctor
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	traits_applied = list(TRAIT_EMPATH, TRAIT_NOSTINK, TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	cmode_music = 'sound/music/combat_physician.ogg'
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_LCK = 1,
		STATKEY_PER = 1
	)
	maximum_possible_slots = 20 // Should not fill, just a hack to make it shows what types of towners are in round

	age_mod = /datum/class_age_mod/barber_surgeon

	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_MASTER,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/doctor/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/head/roguetown/roguehood
	head = /obj/item/clothing/head/roguetown/armingcap{
		name = "barber's cap"
		color = COLOR_WHITE;
		desc = "A modest cloth cap that keeps the hair and sweat away"
	}
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid /// they are a fine dressed doctor. no one else gonna pay em. psycross removed since it was a hold over for secular
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest{
		color = CLOTHING_BROWN
	}
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/huntingknife/chefknife/cleaver
	beltr = /obj/item/storage/belt/rogue/surgery_bag/full
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/clothing/cloak/apron/cook{
							name = "barber's apron";
							desc = "An apron meant to keep the hands clean of blood, as well as tools"
							} = 1,							
						/obj/item/folding_alchcauldron_stored = 1,	
						/obj/item/rogueweapon/huntingknife/scissors/steel = 1,						
						/obj/item/flashlight/flare/torch/lantern = 1,
						/obj/item/natural/worms/leech/cheele = 1,
						/obj/item/recipe_book/alchemy = 1,
						/obj/item/heart_blood_canister/filled = 2,
						/obj/item/bait/leech = 2,
						/obj/item/hair_dye_cream = 2,
						/obj/item/clothing/suit/roguetown/shirt/robe/physician = 1,
						)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_UPPER_MIDDLE_CLASS, H)

