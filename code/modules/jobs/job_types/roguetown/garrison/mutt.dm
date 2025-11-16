/datum/job/roguetown/mutt
	title = "Mutt"
	flag = MUTT
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_SOLDIER
	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	advclass_cat_rolls = list(CTAG_MUTT = 2)

	tutorial = "You are the Garrison's beloved guard dog, trained to protect and assist the soldiers of the Garrison. Your name is: Mutt."
	display_order = JDO_MUTT
	give_bank_account = FALSE
	min_pq = 20
	max_pq = null
	round_contrib_points = 5

	cmode_music = 'sound/music/combat_squire.ogg'
	job_subclasses = list(
		/datum/advclass/mutt
	)

/datum/outfit/job/roguetown/mutt
	job_bitflag = BITFLAG_GARRISON

/datum/advclass/mutt
	name = "Mutt"
	tutorial = "You are the Garrison's beloved guard dog, trained to protect and assist the soldiers of the Garrison. Your name is: Mutt."

	allowed_races = list(/datum/species/shapewolf/mutt)
	category_tags = list(CTAG_MUTT)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_EXP_APPRENTICE,

	)
	adv_stat_ceiling = list(STAT_INTELLIGENCE = 3)

/datum/job/roguetown/mutt/equip(mob/living/carbon/human/H, visualsOnly, announce, latejoin, datum/outfit/outfit_override, client/preference_source)
	if(visualsOnly)
		return ..()
	var/mob/new_mutt = new /mob/living/carbon/human/species/wildshape/volf/mutt(H.loc)
	new_mutt.job = "Mutt"
	H.mind.transfer_to(new_mutt)
	new_mutt.AddSpell(new /obj/effect/proc_holder/spell/self/wolfclaws)
	var/obj/item/clothing/cloak/stabard/guard/mutt/mutt_cloak = new /obj/item/clothing/cloak/stabard/guard/mutt(H)
	new_mutt.equip_to_slot_or_del(mutt_cloak, SLOT_CLOAK, TRUE)
	qdel(H)
	return new_mutt

/datum/job/roguetown/mutt/after_spawn(mob/living/carbon/human/H, mob/M, latejoin)
	H.real_name = "Mutt"
	H.name = "Mutt"
	return ..()
