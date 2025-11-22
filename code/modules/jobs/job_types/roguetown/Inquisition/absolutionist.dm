/datum/job/roguetown/absolver
	title = "Absolver"
	flag = ABSOLVER
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 1 // THE ONE.
	spawn_positions = 1
	allowed_races = RACES_ALL_KINDS
	allowed_patrons = list(/datum/patron/old_god) //Requires the character to be a practicing Psydonite.
	tutorial = "Once, you were alone in this monastery; a chapel of stone, protecting a shard of Psydon's divinity. Now, you've a whole sect to shepherd - and their propensity for violence oft-clashes with your own vows of pacifism. Temper the floch with your wisdom, siphon away their wounds with your blessings, and guide the wayard towards absolution."
	selection_color = JCOLOR_INQUISITION
	outfit = /datum/outfit/job/roguetown/absolver
	display_order = JDO_ABSOLVER
	min_pq = 3 
	max_pq = null
	round_contrib_points = 2
	wanderer_examine = FALSE
	advjob_examine = FALSE
	give_bank_account = 15

	job_traits = list(
		TRAIT_NOPAINSTUN,
		TRAIT_PACIFISM,
		TRAIT_EMPATH,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_SILVER_BLESSED,
		TRAIT_STEELHEARTED,
		TRAIT_INQUISITION,
	)

	advclass_cat_rolls = list(CTAG_ABSOLVER = 2)
	job_subclasses = list(
		/datum/advclass/absolver
	)

/datum/advclass/absolver
	name = "Absolver"
	tutorial = "Once, you were alone in this monastery; a chapel of stone, protecting a shard of Psydon's divinity. Now, you've a whole sect to shepherd - and their propensity for violence oft-clashes with your own vows of pacifism. Temper the floch with your wisdom, siphon away their wounds with your blessings, and guide the wayard towards absolution."
	outfit = /datum/outfit/job/roguetown/absolver/basic
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_ABSOLVER)
	subclass_stats = list(
		STATKEY_CON = 7,
		STATKEY_WIL = 3,
		STATKEY_SPD = -2 //Originally swapped to -3, but this probably isn't as important due to the pacifism trait.
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN, // Enduring.
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN, // A hobbyist.
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE, // Parry things.
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT, // Psydon's Holiest Guy
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)

// REMEMBER FLAGELLANT? REMEMBER LASZLO? THIS IS HIM NOW. FEEL OLD YET?

/datum/job/roguetown/absolver/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonpersist)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydonlux_tamper)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydonabsolve)
			// H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydondefy) -- not ready yet.
			H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/psydonrespite)
			H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/qsabsolution)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)

/datum/job/roguetown/absolver/after_spawn(mob/living/H, mob/M, latejoin = TRUE)
	..()
	if(ishuman(H))
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/inq = "Brother"
		if(should_wear_femme_clothes(H))
			inq = "Sister"
		H.real_name = "[inq] [prev_real_name]"
		H.name = "[inq] [prev_name]"

		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)

/datum/outfit/job/roguetown/absolver/basic/pre_equip(mob/living/carbon/human/H)
	..()
	job_bitflag = BITFLAG_HOLY_WARRIOR
	H.adjust_blindness(-3)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/psythorns
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	beltr = /obj/item/flashlight/flare/torch/lantern/psycenser
	beltl = /obj/item/storage/belt/rogue/pouch/coins/rich
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	cloak = /obj/item/clothing/cloak/absolutionistrobe
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/psydon
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	mask = /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns
	head = /obj/item/clothing/head/roguetown/helmet/heavy/absolver
	id = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(
		/obj/item/book/rogue/bibble/psy = 1,
		/obj/item/natural/bundle/cloth/roll = 2,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 2,
		/obj/item/paper/inqslip/arrival/abso = 1,
		/obj/item/needle = 1,
		/obj/item/natural/worms/leech/cheele = 1,
		/obj/item/storage/keyring/puritan = 1,
		)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_ABSOLVER, start_maxed = TRUE) // PSYDONIAN MIRACLE-WORKER. LUX-MERGING FREEK.
