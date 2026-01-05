/datum/class_age_mod
	var/target_age = null
	var/list/stat_mods = list()
	var/list/skill_mods = list()
	var/sp_mod = 0

/datum/class_age_mod/proc/apply_age_mod(mob/living/carbon/human/H)
	if(H.age == target_age)
		if(length(stat_mods))
			for(var/stat in stat_mods)
				H.change_stat(stat_mods[stat])
		if(length(skill_mods))
			for(var/S in skill_mods)
				var/datum/skill/skill = S
				H.adjust_skillrank_up_to(skill, skill_mods[S], TRUE)
		if(sp_mod)
			H.mind?.adjust_spellpoints(sp_mod)

/datum/class_age_mod/proc/get_preview_string()
	if(!target_age)
		return null
	var/str = ""
	str += "<font color ='#7a4d0a'>If the Character is <font color ='#b3d6df'>[target_age]</font>, they will get these additional bonuses:</font>"
	if(length(stat_mods))
		for(var/stat in stat_mods)
			str += "<br>[capitalize(stat)]: <b>[stat_mods[stat] < 0 ? "<font color = '#cf2a2a'>" : "<font color = '#91cf68'>"]\Roman[stat_mods[stat]]</font></b>"
		str += "<font color ='#7a4d0a'><br>-----</font>"
	if(length(skill_mods))
		for(var/S in skill_mods)
			var/datum/skill/skill = S
			str += "<br><font color ='#ad9152'>[initial(skill.name)] — [SSskills.level_names[skill_mods[S]]]</font>"
		str += "<br><font color ='#7a4d0a'>-----</font>"
	if(sp_mod)
		str += "<br><font color = '#4b4f7c'>Additional Spellpoints: <b>[sp_mod]</b></font>"

	return str

/*
********* MODS BEGIN HERE **********
*/

//--- BANDITS ---

/datum/class_age_mod/bandit/rogue_mage
	target_age = AGE_OLD
	stat_mods = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1
	)
	skill_mods = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_MASTER
	)
	sp_mod = 6

/datum/class_age_mod/bandit/sawbones
	target_age = AGE_OLD
	stat_mods = list(
		STATKEY_SPD = -1,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
	)

//--- WRETCHES ---

/datum/class_age_mod/wretch/hedge_mage
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_MASTER
	)
	sp_mod = 6 

// --- VETERAN ---
/datum/class_age_mod/veteran
	target_age = AGE_OLD	//Saving ourselves the redundancy

/datum/class_age_mod/veteran/battlemaster
	skill_mods = list(
		/datum/skill/combat/swords = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/maces = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
	)
	stat_mods = list(
		STATKEY_WIL = 1
	)

/datum/class_age_mod/veteran/footman
	skill_mods = list(
		/datum/skill/combat/shields = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/polearms = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/maces = SKILL_LEVEL_MASTER,
		/datum/skill/combat/axes = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER
	)

/datum/class_age_mod/veteran/cavalryman
	// You get a lot of weapon skills, but none are legendary. Jack of all trades, master of none. 
	// This is probably worse than just having legendary in one, as people rarely swap weapons mid-combat.
	skill_mods = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/maces = SKILL_LEVEL_MASTER,
		/datum/skill/combat/axes = SKILL_LEVEL_MASTER,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_MASTER,
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,
	)

/datum/class_age_mod/veteran/mercenary
	skill_mods = list(
		/datum/skill/combat/axes = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN
	)

/datum/class_age_mod/veteran/scout
	skill_mods = list(
		/datum/skill/combat/bows = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/axes = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
	)

/datum/class_age_mod/veteran/spy
	// Having Master Knives is extremely negligible for a singular role that isn't even meant to be combative.
	skill_mods = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/knives = SKILL_LEVEL_MASTER,
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT
	)
	stat_mods = list(
		STATKEY_SPD = 1	// You get -2 speed from being old. You are still in the negative stat wise from picking old.
	)
//--- THE REST ---

/datum/class_age_mod/grand_duke
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER
	)

/datum/class_age_mod/hand_blademaster
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER
	)
	stat_mods = list(
		STATKEY_LCK = 2
	)

/datum/class_age_mod/hand_advisor
	target_age = AGE_OLD
	stat_mods = list(
		STATKEY_PER = 1,
		STATKEY_INT = 1,
		STATKEY_STR = -1,
		STATKEY_SPD = -1,
	)
	sp_mod = 3

/datum/class_age_mod/hand_spymaster
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/stealing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_LEGENDARY
	)

/datum/class_age_mod/war_scholar
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_MASTER
	)
	stat_mods = list(
		STATKEY_PER = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = -1
	)
	sp_mod = 6

/datum/class_age_mod/apprentice_associate
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT
	)
	stat_mods = list(
		STATKEY_INT = 1,
		STATKEY_SPD = -1
	)
	sp_mod = 6

/datum/class_age_mod/apprentice_apprentice
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN
	)
	stat_mods = list(
		STATKEY_INT = 1,
		STATKEY_SPD = -1
	)
	sp_mod = 3

/datum/class_age_mod/apprentice_alchemist
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/craft/alchemy = SKILL_LEVEL_MASTER
	)
	stat_mods = list(
		STATKEY_INT = 1,
		STATKEY_PER = -1
	)

/datum/class_age_mod/grenzel_mage
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_MASTER
	)
	stat_mods = list(
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_SPD = -1,
		STATKEY_STR = -1,
		STATKEY_CON = -2
	)
	sp_mod = 3

/datum/class_age_mod/adv_mage
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT
	)
	sp_mod = 6

/datum/class_age_mod/exorcist
	target_age = AGE_OLD
	stat_mods = list(
		STATKEY_INT = 1,
		STATKEY_CON = -2,
	)
	skill_mods = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT
	)

/datum/class_age_mod/barber_surgeon
	target_age = AGE_OLD
	stat_mods = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = -1
	)

/datum/class_age_mod/fisher
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/labor/fishing = SKILL_LEVEL_MASTER
	)

/datum/class_age_mod/witch
	target_age = AGE_OLD
	stat_mods = list(
		STATKEY_LCK = 1,
		STATKEY_INT= 1,
		STATKEY_SPD = -1
	)

/datum/class_age_mod/druid
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
		/datum/skill/magic/druidic = SKILL_LEVEL_MASTER
	)

/datum/class_age_mod/acolyte
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
	)

/datum/class_age_mod/priest
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/magic/holy = SKILL_LEVEL_LEGENDARY,
	)

/datum/class_age_mod/seneschal
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/craft/cooking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/class_age_mod/servant
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/craft/cooking = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/class_age_mod/cook
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/craft/cooking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/class_age_mod/tapster
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/craft/cooking = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
	)

/datum/class_age_mod/soilson
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/labor/farming = SKILL_LEVEL_LEGENDARY,
		/datum/skill/labor/butchering = SKILL_LEVEL_LEGENDARY
	)

/datum/class_age_mod/cuisiner
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/craft/cooking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
	)

/datum/class_age_mod/archivist
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN
	)
	stat_mods = list(
		STATKEY_INT = 1,
		STATKEY_SPD = -1
	)
	sp_mod = 3

/datum/class_age_mod/innkeeper
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/craft/cooking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT
	)

/datum/class_age_mod/guildmaster
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/smelting = SKILL_LEVEL_MASTER,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN, // Worse than the real tailor, so can't steal their job right away
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN
	)

/datum/class_age_mod/court_magician
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_LEGENDARY
	)
	stat_mods = list(
		STATKEY_PER = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = -1
	)
	sp_mod = 6

/datum/class_age_mod/court_physician
	target_age = AGE_OLD
	skill_mods = list(
		/datum/skill/craft/alchemy = SKILL_LEVEL_LEGENDARY
	)
	stat_mods = list(
		STATKEY_PER = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = -1
	)
