#define CRIER_ANNOUNCEMENT_COOLDOWN (10 MINUTES)//He has access to free SCOM he should be using this

/datum/job/roguetown/crier
	title = "Town Crier"
	tutorial = "Keeper of the Horn, Master of the Jabberline, and self-appointed Voice of Reason. From your desk in the SCOM atelier, you decide which words will thunder across the realm and which will die in the throats of petitioners who didn't pay enough ratfeed. In your upstairs studio, you host debates, recite gossip, and spin tales that will ripple through every corner of town. All ears are turned toward you - so speak wisely."
	flag = CRIER
	department_flag = BURGHERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	spells = list(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	allowed_races = ALL_RACES_TYPES
	allowed_ages = ALL_AGES_LIST

	outfit = /datum/outfit/job/roguetown/loudmouth
	display_order = JDO_CRIER
	give_bank_account = TRUE
	min_pq = 3 // Has actual responsibility and is a key figure in town.
	max_pq = null
	round_contrib_points = 3

	job_traits = list(TRAIT_INTELLECTUAL, TRAIT_ARCYNE_T1, TRAIT_MAGEARMOR, TRAIT_SEEPRICES_SHITTY, TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_TOWNCRIER = 2)
	job_subclasses = list(
		/datum/advclass/towncrier
	)

/datum/advclass/towncrier
	name = "Town Crier"
	tutorial = "Keeper of the Horn, Master of the Jabberline, and self-appointed Voice of Reason. \
	From your desk in the SCOM atelier, you decide which words will thunder across the realm and which will die in the throats of petitioners who didn't pay enough ratfeed. \
	In your upstairs studio, you host debates, recite gossip, and spin tales that will ripple through every corner of town. All ears are turned toward you - so speak wisely."
	outfit = /datum/outfit/job/roguetown/loudmouth/basic
	subclass_languages = list(
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/celestial,
		/datum/language/hellspeak,
		/datum/language/orcish,
		/datum/language/grenzelhoftian,
		/datum/language/otavan,
		/datum/language/etruscan,
		/datum/language/gronnic,
		/datum/language/kazengunese,
		/datum/language/draconic,
		/datum/language/aavnic, // All but beast, which is associated with werewolves.
	)
	category_tags = list(CTAG_TOWNCRIER)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_INT = 3,
		STATKEY_SPD = 1
	)
	age_mod = /datum/class_age_mod/archivist
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/loudmouth/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	if(should_wear_femme_clothes(H))
		pants = /obj/item/legwears/black
	else
		pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	armor = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/loudmouth
	head = /obj/item/clothing/head/roguetown/veiled/loudmouth
	backr = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/roguekey/crier
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/scomstone
	backpack_contents = list(
		/obj/item/recipe_book/alchemy
	)
	if (H && H.mind)
		H.mind.adjust_spellpoints(6)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_CLASS, H, "Savings.")

/mob/living/carbon/human/proc/crier_announcement()
	set name = "Announcement"
	set category = "CRIER"
	if(stat)
		return
	var/announcementinput = input("Bellow to the Peaks", "Make an Announcement") as text|null
	if(announcementinput)
		if(!src.can_speak_vocal())
			to_chat(src,span_warning("I can't speak!"))
			return FALSE
		if(!istype(get_area(src), /area/rogue/outdoors/town))//Go touch grass
			to_chat(src, span_warning("I can only speak from within premises of the Town."))
			return FALSE
		if(!COOLDOWN_FINISHED(src, crier_announcement))
			to_chat(src, span_warning("You must wait before speaking again."))
			return FALSE
		visible_message(span_warning("[src] takes a deep breath, preparing to make an announcement.."))
		if(do_after(src, 15 SECONDS, target = src)) // Reduced to 15 seconds from 30 on the original Herald PR. 15 is well enough time for sm1 to shove you.
			say(announcementinput)
			priority_announce("[announcementinput]", "The Crier Pontificates", 'sound/misc/bell.ogg', sender = src)
			COOLDOWN_START(src, crier_announcement, CRIER_ANNOUNCEMENT_COOLDOWN)
		else
			to_chat(src, span_warning("Your announcement was interrupted!"))
			return FALSE

#undef CRIER_ANNOUNCEMENT_COOLDOWN
