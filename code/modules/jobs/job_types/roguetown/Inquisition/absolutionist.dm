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
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_psydon)

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

/obj/effect/proc_holder/spell/invoked/convert_psydon
	name = "Return to Orthodoxy"
	desc = "Convert a heretic back to the worship of PSYDON. Requires the heretic to be willing, and takes a long time to cast."
	invocations = list("Allfather, accept your wayward child once more.")
	invocation_type = "whisper"
	sound = 'sound/magic/bless.ogg'
	devotion_cost = 100
	recharge_time = 20 MINUTES
	chargetime = 10 SECONDS
	associated_skill = /datum/skill/magic/holy
	overlay_state = "convert_heretic"

/obj/effect/proc_holder/spell/invoked/convert_psydon/cast(list/targets, mob/living/carbon/human/user)
	var/mob/living/carbon/human/target = targets[1]

	if(!ishuman(target))
		revert_cast()
		return FALSE
	
	if(target.cmode)
		revert_cast()
		return FALSE

	if(istype(target.patron, /datum/patron/old_god))
		to_chat(user, span_warning("[target] is already a faithful of Psydon!"))
		revert_cast()
		return FALSE

	if(alert(target, "[user.real_name] is trying to convert you to the worship of PSYDON. Do you accept?", "Conversion Request", "Yes", "No") != "Yes")
		to_chat(user, span_warning("[target] refused your offer of conversion."))
		revert_cast()
		return FALSE


	if(target.devotion) //Remove all granted miracles and does NOT replace them, since Psydonic "miracles" don't work the same way and your old skills don't help with it
		
		for(var/obj/effect/proc_holder/spell/S in target.devotion.granted_spells)
			target.mind.RemoveSpell(S)

		target.devotion.Destroy()
		target.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/projectile/divineblast)
		target.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/projectile/divineblast/unholyblast)

	// Convert to PSYDON
	target.patron = new user.patron.type()

	message_admins("PSYDONIC CONVERSION: [user.real_name] ([user.ckey]) has converted [target.real_name] ([target.ckey]) to [user.patron.name]")
	log_game("PSYDONIC CONVERSION: [user.real_name] ([user.ckey]) converted [target.real_name] ([target.ckey]) to [user.patron.name]")
	to_chat(user, span_danger("You've converted [target.name] to follow [user.patron.name]!"))
	to_chat(target, span_danger("You feel the weight of heresy lift from your soul as you embrace [user.patron.name]!"))

	return TRUE
