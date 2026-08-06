/datum/job/roguetown/absolver
	title = "Absolver"
	flag = ABSOLVER
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 1 // THE ONE.
	spawn_positions = 1
	forbidden_races = list(RACES_OOZE)
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
	vice_restrictions = list(/datum/charflaw/silverweakness)

	job_traits = list(
		TRAIT_NOPAINSTUN,
		TRAIT_PACIFISM,
		TRAIT_EMPATH,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_SILVER_BLESSED,
		TRAIT_STEELHEARTED,
		TRAIT_INQUISITION,
		TRAIT_MANORKEEPER,
	)

	advclass_cat_rolls = list(CTAG_ABSOLVER = 2)
	job_subclasses = list(
		/datum/advclass/absolver
	)
	has_subprefs = FALSE // only one subclass

/datum/advclass/absolver
	name = "Absolver"
	tutorial = "Once, you were alone in this monastery; a chapel of stone, protecting a shard of Psydon's divinity. Now, you've a whole sect to shepherd - and their propensity for violence oft-clashes with your own vows of pacifism. Temper the floch with your wisdom, siphon away their wounds with your blessings, and guide the wayard towards absolution."
	outfit = /datum/outfit/job/roguetown/absolver/basic
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_ABSOLVER)
	subclass_stats = list(
		STATKEY_CON = 5,
		STATKEY_WIL = 5,
		STATKEY_INT = 2,
		STATKEY_SPD = -2 //A fairly unorthodox statspread, but one that's compensated by the Absolver's shtick of (mostly) forced pacifism and healing-through-damage-transferance.
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT, // Healing skills. Lesser than the Priest, but still commendable.
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN, // Physical skills. More physicailly conditioned than their counterparts, and for a good reason.
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN, // Support skills. They're the handler of the Inquisition's manor, and are familiar with most standard affairs.
		/datum/skill/labor/fishing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,

	)
	subclass_stashed_items = list(
		"The Book" = /obj/item/book/rogue/bibble/psy
	)

// REMEMBER FLAGELLANT? REMEMBER LASZLO? THIS IS HIM NOW. FEEL OLD YET?

/datum/job/roguetown/absolver/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.mind)
			H.mind.AddSpell(new /datum/action/cooldown/spell/psydon/persist)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydonlux_tamper)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydonabsolve)
			H.mind.RemoveSpell(/datum/action/cooldown/spell/psydon/respite)
			H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/qsabsolution)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)

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
	id = /obj/item/clothing/ring/signet/psy
	backpack_contents = list(
		/obj/item/book/rogue/bibble/psy = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 2,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 2,
		/obj/item/paper/inqslip/arrival/abso = 1,
		/obj/item/needle = 1,
		/obj/item/natural/worms/leech/cheele = 1,
		/obj/item/storage/keyring/inquisitor = 1,
		)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_ABSOLVER, start_maxed = TRUE) // PSYDONIAN MIRACLE-WORKER. LUX-MERGING FREEK.
	change_origin(H, /datum/virtue/origin/otava, "Holy order")
