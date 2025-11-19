//////////////////////////////////////////
/////////////////////////////////// LAYMAN
/*
	dude w/a mace & heavy armor
	given a single buff spell of their choice + Mending
*/
/datum/advclass/warband/wizard/grunt/layman
	title = "LAYMAN"
	name = "Layman"
	tutorial = "The LAYMAN is denied the Sorcerer-King's greatest secrets. He only serves with brute force."
	outfit = /datum/outfit/job/roguetown/warband/wizard/grunt/layman
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_FORMATIONFIGHTER)
	subclass_stats = list(
		STATKEY_SPD = -1,
		STATKEY_CON = 2,
		STATKEY_WIL = 4,
		STATKEY_INT = -1,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/carpentry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,	
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/warband/wizard/grunt/layman/pre_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/rogueweapon/mace/goden/steel
	cloak = /obj/item/clothing/cloak/thrall
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/mask/rogue/facemask/goldmask/layman/alt
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/thrall
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/layman
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron/layman
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest/thrall
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt
	neck = /obj/item/clothing/neck/roguetown/bevor/iron/layman
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron/layman
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron/layman
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 1,
		/obj/item/reagent_containers/glass/bottle/waterskin = 1
		)

	if(H.mind)
		H.mind.AddSpell(new	/obj/effect/proc_holder/spell/invoked/mending)
		var/coverclass = list("Guidance","Hawk's Eyes","Giant's Strength","Stoneskin","Fortitude","Haste")
		var/coverclass_choice = input("I was taught a single spell to aid our efforts!", "I REMEMBER") as anything in coverclass
		switch(coverclass_choice)
			if("Guidance")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/guidance)
			if("Hawk's Eyes")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/hawks_eyes)
			if("Giant's Strength")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/giants_strength)
			if("Stoneskin")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stoneskin)
			if("Fortitude")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fortitude)
			if("Haste")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/haste)

///////////////////////////////////////////
/////////////////////////////////// STALKER
/*
	assassin w/dual hookblades & two charges of Invisibility
*/
/datum/advclass/warband/wizard/grunt/stalker
	title = "STALKER"
	name = "Stalker"
	tutorial = "Wheresoever the weakest of the Warband's foes lurk, so too shall the STALKER - hidden beneath Noc's cloak with hooked blades at the ready."
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_FORMATIONFIGHTER, TRAIT_LIGHT_STEP, TRAIT_DUALWIELDER)
	subclass_stats = list(
		STATKEY_STR = -2,
		STATKEY_SPD = 5,
		STATKEY_CON = -1,
		STATKEY_WIL = 3,
		STATKEY_INT = 3,
		STATKEY_PER = 4,
	)
	subclass_skills = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
	
	)
	outfit = /datum/outfit/job/roguetown/warband/wizard/grunt/stalker

/datum/outfit/job/roguetown/warband/wizard/grunt/stalker/pre_equip(mob/living/carbon/human/H)
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/thrall
	head = /obj/item/clothing/mask/rogue/facemask/goldmask/layman
	cloak = /obj/item/clothing/cloak/thrall
	armor = /obj/item/clothing/suit/roguetown/armor/leather/cuirass/stalker
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/iron
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest/thrall
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	r_hand = /obj/item/rogueweapon/sword/sabre/hook
	l_hand = /obj/item/rogueweapon/sword/sabre/hook
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/invisibility)
		H.mind.AddSpell(new	/obj/effect/proc_holder/spell/invoked/invisibility)
		H.mind.AddSpell(new	/obj/effect/proc_holder/spell/invoked/blink)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch)		
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/counterspell)
		H.mind.AddSpell(new	/obj/effect/proc_holder/spell/targeted/touch/nondetection)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mirror_transform)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)


///////////////////////////////////////////
/////////////////////////////////// WARLOCK
/*
	T4 Cleric & a Locked Spellcaster
	suffers the curse from their related patron
	cannot regenerate devotion
*/
/datum/advclass/warband/wizard/grunt/warlock
	title = "WARLOCK"
	name = "Warlock"
	tutorial = "Guilty of divine thievery, the WARLOCK finds themselves cursed. Their future is short, and should be suffered at one's own peril."
	outfit = /datum/outfit/job/roguetown/warband/wizard/grunt/warlock
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_FORMATIONFIGHTER, TRAIT_RITUALIST, TRAIT_ARCYNE_T2)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_CON = -2,
		STATKEY_WIL = 2,
		STATKEY_INT = 5,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/warband/wizard/grunt/warlock/proc/warlock_spellset(mob/living/carbon/human/H, patron_type)
	var/patron_effects = list(
		/datum/patron/divine/astrata = list(
			"spells" = list(
				/obj/effect/proc_holder/spell/invoked/projectile/fireball,
				/obj/effect/proc_holder/spell/invoked/projectile/fireball,
				/obj/effect/proc_holder/spell/invoked/projectile/fireball,
				/obj/effect/proc_holder/spell/invoked/projectile/spitfire
			),
			"curse" = /datum/curse/astrata
		),
		/datum/patron/divine/abyssor = list(
			"spells" = list(
				/obj/effect/proc_holder/spell/invoked/snap_freeze,
				/obj/effect/proc_holder/spell/invoked/projectile/frostbolt,
				/obj/effect/proc_holder/spell/invoked/projectile/frostbolt
			),
			"curse" = /datum/curse/abyssor
		),
		/datum/patron/divine/noc = list(
			"curse" = /datum/curse/noc,
			"traits" = list(TRAIT_ANTIMAGIC)
		),
		/datum/patron/divine/ravox = list(
			"spells" = list(
				/obj/effect/proc_holder/spell/invoked/giants_strength,
				/obj/effect/proc_holder/spell/invoked/blade_burst,
				/obj/effect/proc_holder/spell/invoked/blade_burst
			),
			"curse" = /datum/curse/ravox
		),
		/datum/patron/divine/necra = list(
			"spells" = list(
				/obj/effect/proc_holder/spell/invoked/wither,
				/obj/effect/proc_holder/spell/invoked/wither
			),
			"curse" = /datum/curse/necra
		),
		/datum/patron/divine/xylix = list(
			"spells" = list(
				/obj/effect/proc_holder/spell/invoked/haste,
				/obj/effect/proc_holder/spell/invoked/invisibility
			),
			"curse" = /datum/curse/xylix,
			"traits" = list(TRAIT_ZJUMP)
		),
		/datum/patron/divine/pestra = list(
			"spells" = list(
				/obj/effect/proc_holder/spell/invoked/aerosolize,
				/obj/effect/proc_holder/spell/invoked/projectile/acidsplash,
				/obj/effect/proc_holder/spell/invoked/projectile/acidsplash
			),
			"curse" = /datum/curse/pestra
		),
		/datum/patron/divine/malum = list(
			"spells" = list(
				/obj/effect/proc_holder/spell/invoked/fortitude,
				/obj/effect/proc_holder/spell/invoked/stoneskin,
				/obj/effect/proc_holder/spell/invoked/gravity,
				/obj/effect/proc_holder/spell/self/magicians_brick,
				/obj/effect/proc_holder/spell/self/magicians_brick,
				/obj/effect/proc_holder/spell/self/magicians_brick
			),
			"curse" = /datum/curse/malum
		),
		/datum/patron/divine/eora = list(
			"spells" = list(
				/obj/effect/proc_holder/spell/invoked/ensnare,
				/obj/effect/proc_holder/spell/invoked/ensnare,
				/obj/effect/proc_holder/spell/invoked/mindlink
			),
			"curse" = /datum/curse/eora
		),
		/datum/patron/inhumen/zizo = list(
			"curse" = /datum/curse/zizo,
			"traits" = list(TRAIT_ANTIMAGIC)
		)
	)
	if(!patron_effects[patron_type]) 
		return FALSE
	var/patron_data = patron_effects[patron_type]
	
	if(patron_data["spells"])
		for(var/spell_type in patron_data["spells"])
			H.mind.AddSpell(new spell_type)
	
	if(patron_data["curse"])
		H.add_curse(patron_data["curse"])
	
	if(patron_data["traits"])
		for(var/trait in patron_data["traits"])
			ADD_TRAIT(H, trait, TRAIT_GENERIC)


/datum/outfit/job/roguetown/warband/wizard/grunt/warlock/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/corset
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/silktunic/thrall
		pants = /obj/item/clothing/under/roguetown/skirt/black
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/black
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest/thrall
	head = /obj/item/clothing/head/roguetown/witchhat/thrall
	cloak = /obj/item/clothing/cloak/thrall
	gloves = /obj/item/clothing/gloves/roguetown/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/scabbard/sword	
	beltr = /obj/item/clothing/neck/roguetown/psicross/wood
	backl = /obj/item/storage/backpack/rogue/satchel/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	l_hand = /obj/item/rogueweapon/sword/long
	backpack_contents = list(
		/obj/item/ritechalk = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 1,
		/obj/item/reagent_containers/glass/bottle/waterskin = 1
		)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/arcynebolt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
		// baotha, matthios & graggar are excluded because they don't have spell sets atm
		// psydon & undivided are excluded because, Y'Know
		if(H.patron.type == /datum/patron/divine/undivided || H.patron.type == /datum/patron/old_god || H.patron.type == /datum/patron/inhumen/matthios || H.patron.type == /datum/patron/inhumen/graggar || H.patron.type == /datum/patron/inhumen/baotha)
			var/curseclass = list("Astrata","Abyssor","Ravox","Necra","Xylix","Pestra","Malum","Eora","Noc","Zizo")
			var/curseclass_choice = input("I was cursed by...", "WOE") as anything in curseclass
			var/patron_path = list(
				"Astrata" = /datum/patron/divine/astrata,
				"Abyssor" = /datum/patron/divine/abyssor,
				"Noc" = /datum/patron/divine/noc,
				"Ravox" = /datum/patron/divine/ravox,
				"Necra" = /datum/patron/divine/necra,
				"Xylix" = /datum/patron/divine/xylix,
				"Pestra" = /datum/patron/divine/pestra,
				"Malum" = /datum/patron/divine/malum,
				"Eora" = /datum/patron/divine/eora,
				"Zizo" = /datum/patron/inhumen/zizo
			)
			var/selected_patron_type = patron_path[curseclass_choice]
			if(selected_patron_type)
				H.set_patron(selected_patron_type)
				warlock_spellset(H, selected_patron_type) 
		else
			warlock_spellset(H, H.patron.type)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T4, devotion_limit = CLERIC_REQ_4, start_maxed = TRUE)
		H.verbs -= /mob/living/carbon/human/proc/clericpray	// shouldn't be capable of regeneration
