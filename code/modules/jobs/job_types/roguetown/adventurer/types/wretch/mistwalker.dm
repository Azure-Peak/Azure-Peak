/datum/advclass/wretch/mistwalker
	name = "Mistwalker"
	tutorial = "Hailing from Kazengun you were once a sacred guardian, dedicating your lyfe to protecting your chosen shrine of the twelve against brigands and fiends from beyond alike... now? Your sacred home has fallen, claimed by ruinous forces and you are banished to wander the realm. What will you find in your search for purpose?"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_OOZE) //I did in fact regret letting them be revs
	allowed_patrons = ALL_KAZENGUN_PATRONS //guardian of the twelve... and saidon but no undivided
	outfit = /datum/outfit/job/roguetown/wretch/mistwalker
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	virtue_limits = list(/datum/virtue/combat/second_chance)
	traits_applied = list(TRAIT_NOPAINSTUN, TRAIT_BLOOD_RESISTANCE, TRAIT_JOURNEYS_END) //no armour, literally made to bleed
	maximum_possible_slots = 2 //you probably don't want many of these - edit: let them bring a friend/rival

	cmode_music = 'sound/music/combat_Kazengun_Firestorm.ogg'
	subclass_stats = list(
		STATKEY_STR = 2, //10 weighted with weapon buff, two below disgraced knight
		STATKEY_CON = 1,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN, //wish there was an oni axe or something
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE, //my dynasty is highly learned and we wear all shadow and leave no souls to recount our legend
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, //you'll get real familiar with bleeding
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE, //social outcast but can still read protective charms
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN, //flavour and useful for making armour
	)
	subclass_stashed_items = list(
		"Sewing Kit" =	/obj/item/repair_kit, //I am sure you'll find a way to repair your bracers
		"Stashed Funds" = /obj/item/roguecoin/silver/pile/wretchpile,
	)
	extra_context = "This subclass gains addition stat points from weapon selection, and is race-limited from: Constructs. It may only be picked by characters originating from: Kazengun, Lingyue. This class is incompatible with the following Virtue: Second Chance."
	adv_stat_ceiling = list(STAT_STRENGTH = 14, STAT_CONSTITUTION = 14, STAT_SPEED = 14) //WIL does basically nothing, so we cap SPD instead

/datum/advclass/wretch/mistwalker/check_requirements(mob/living/carbon/human/H)
	var/client/player = H?.client
	if(!istype(player.prefs.virtue_origin, /datum/virtue/origin/kazengun) && !istype(player.prefs.virtue_origin, /datum/virtue/origin/lingyue))
		return FALSE
	return ..()

/datum/outfit/job/roguetown/wretch/mistwalker/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Failed in your duty, outcast from whence you came you wander. Only the steel in your hand can be trusted."))

	head = /obj/item/clothing/head/roguetown/mentorhat
	mask = /obj/item/clothing/mask/rogue/facemask/steel/kazengun //let them have this
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath/kazengun = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)

	if(H.mind)
		var/armor_options = list("Ceremonial Robes", "Enchanted Inks")
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armor_options
		var/weapons = list("Ssangsudo +2 CON, +2 INT", "Kanabo +1 STR, +2 CON", "Naginata +2 PER, +2 INT", "Hwando +2 INT, +1 SPD", "Longbow +2 PER, +1 SPD", "Kodachi +2 SPD")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/bloodlet)
		switch(armor_choice)
			if("Ceremonial Robes")
				neck = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
				wrists = /obj/item/clothing/wrists/roguetown/bracers/black
				if(H.dna.species.type in NON_DWARVEN_RACE_TYPES)
					armor = /obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit
					pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun/black
					gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
					shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
				else
					armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/black
					pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
					gloves = /obj/item/clothing/gloves/roguetown/angle
					shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced //dwarves like to blow up my patience
			if("Enchanted Inks")
				neck = /obj/item/clothing/neck/roguetown/leather
				armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/easttats/mistwalker //a full-body leather armor with 150% integ.
				shirt = /obj/item/clothing/suit/roguetown/armor/manual/meditation/chest/easttats/mistwalker //another chest-only leather armor.
				l_hand = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				ADD_TRAIT(H, TRAIT_HONORBOUND, TRAIT_GENERIC)
				if(H.dna.species.type in NON_DWARVEN_RACE_TYPES)
					pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun/black
					gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
					shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
				else
					pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
					gloves = /obj/item/clothing/gloves/roguetown/angle
					shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		switch(weapon_choice)
			if("Ssangsudo +2 CON, +2 INT")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/noparry
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_INT, 2)
			if("Kanabo +1 STR, +2 CON")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/mace/goden/steel/kanabo
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_CON, 2)
			if("Naginata +2 PER, +2 INT")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/spear/naginata
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_INT, 2)
			if("Hwando +2 INT, +1 SPD") // I know what you are.
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/mulyeog
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun
				H.change_stat(STATKEY_INT, 2)
				H.change_stat(STATKEY_SPD, 1)
			if("Longbow +2 PER, +1 SPD") //they still have the expert knives for melee
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				beltr = /obj/item/quiver/arrows
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_SPD, 1)
			if("Kodachi +2 SPD")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/short/kazengun
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
				H.change_stat(STATKEY_SPD, 2)

		wretch_select_bounty(H)


/obj/effect/proc_holder/spell/self/bloodlet
	source_aspect = /datum/magic_aspect/pseudo/mistwalker
	name = "Red Tides"
	desc = "Take a brief moment to open yourself up to the flow of battle, both in body and mynd. Allow the raging tides of blood to wash through you and embrace the current driven by its dissipation. Teetering on the edge of sanity and heresy, Gaiyuke will find no joy in your suffering, only the resolve to see it through."
	antimagic_allowed = TRUE
	clothes_req = FALSE
	chargetime = 3 SECONDS
	recharge_time = 5 MINUTES
	invocations = list("surrenders their lyfeblood to the tide of battle!")
	invocation_type = "emote"

/obj/effect/proc_holder/spell/self/bloodlet/cast(mob/living/carbon/human/user)
	. = ..()
	var/bloodbuff_duration = 15 SECONDS
	if(!ishuman(user))
		revert_cast()
		return FALSE
	if(user.blood_volume <= BLOOD_VOLUME_OKAY) //336
		to_chat(user, span_warning("I can't let go of more willingly!"))
		revert_cast()
		return FALSE
	if(!do_after(user, 3 SECONDS, TRUE, null, TRUE, null, FALSE, FALSE, TRUE))
		to_chat(user, span_warning("Action interrupted!"))
		revert_cast()
		return FALSE
	user.blood_volume = max(user.blood_volume - 150, BLOOD_VOLUME_BAD) //226
	user.apply_status_effect(/datum/status_effect/buff/empowered_strike, bloodbuff_duration)
	to_chat(user, span_notice("Calm as the mountain lake. Inevitable as the raging tides."))
	playsound(user, 'sound/combat/hits/bladed/genthrust (1).ogg', 100, TRUE)
	return TRUE

/obj/item/clothing/wrists/roguetown/bracers/black
	color = CLOTHING_BLACK
/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
	color = CLOTHING_BLACK
/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/black
	color = CLOTHING_BLACK
/obj/item/clothing/neck/roguetown/coif/heavypadding/black
	color = CLOTHING_BLACK
/obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun/black
	color = CLOTHING_BLACK
