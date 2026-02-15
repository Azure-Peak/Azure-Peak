/datum/advclass/iconoclast //Support Cleric, Heavy armor, unarmed, miracles.
	name = "Iconoclast"
	tutorial = "Trained by an Ecclesial sect, you uphold the Ideological purity of the Matthian Creed. Take from the wealthy, give to the worthless, empower. They will look up to you, in search of the God of Robbery's guidance. Be their light in the dark."
	extra_context = "Chosen of Matthios gives you weapon skills and as well access to HEAVY ARMOR training. Golden Serpent is limited to his fists (cannot even use shields nor punch weapons) and is forced to have BRONZE ARM / MISSING EYE."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/bandit/iconoclast
	category_tags = list(CTAG_BANDIT)
	maximum_possible_slots = 1 // We only want one of these.
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN, TRAIT_RITUALIST)
	subclass_stats = list(
		STATKEY_STR = 3,// LETS WRASSLE
		STATKEY_WIL = 3,// This is our Go Big stat, we want lots of stamina for miracles and WRASSLIN.
		STATKEY_LCK = 2,//We have a total of +12 in stats. 
		STATKEY_CON = 1
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,  // Unarmed if we want to kick ass for the lord(you do, this is what you SHOULD DO!!)
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, // We can substitute for a sawbones, but aren't as good and dont have access to surgical tools
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER, //We are the True Mathlete
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
	)
	cmode_music = 'sound/music/Iconoclast.ogg'

/datum/outfit/job/roguetown/bandit/iconoclast/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/inhumen/matthios)))	//This is the only class that forces Matthios. Needed for miracles + limited slot.
		to_chat(H, span_warning("Matthios embraces me.. I must uphold his creed. I am his light in the darkness."))
		H.set_patron(/datum/patron/inhumen/matthios)
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/ritechalk = 1,
					)
	id = /obj/item/mattcoin
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
	var/subtype = list("Chosen of Matthios", "Golden Serpent")
	if(H.mind)
		var/subtype_choice = input(H, "Choose your path.", "TAKE UP ARMS") as anything in subtype
		H.set_blindness(0)
		switch(subtype_choice)
			if("Chosen of Matthios") //Classic
				r_hand = /obj/item/rogueweapon/woodstaff
				head = /obj/item/clothing/head/roguetown/roguehood
				armor = /obj/item/clothing/suit/roguetown/armor/plate
				beltr = /obj/item/rogueweapon/katar
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
				cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
				ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
			if("Golden Serpent") //Pugilist
				head = /obj/item/clothing/head/roguetown/headband/monk
				mask = /obj/item/clothing/mask/rogue/eyepatch
				wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
				armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/iconoclast
				shirt = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
				ADD_TRAIT(H, TRAIT_GNARLYDIGITS, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_CYCLOPS_RIGHT, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_LEGENDARY, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_LEGENDARY, TRUE)
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_LCK, -2)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending/lesser)//So he can fix his arm
				var/static/list/safe_bodyzones = list(
					BODY_ZONE_HEAD,
					BODY_ZONE_CHEST,
					BODY_ZONE_R_ARM,
					BODY_ZONE_L_LEG,
					BODY_ZONE_R_LEG
				)
				for(var/obj/item/bodypart/limb in H.bodyparts)
					if(limb.body_zone in safe_bodyzones)
						continue
					limb.drop_limb()
					qdel(limb)
				var/obj/item/bodypart/l_arm/prosthetic/bronzeleft/L = new()
				L.attach_limb(H)
