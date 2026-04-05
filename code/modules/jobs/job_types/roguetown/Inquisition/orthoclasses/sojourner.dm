// Pontifex but inquisition. Same statblock - only differences being access to T1 miracles.
/datum/advclass/sojourner
	name = "Sojourner"
	tutorial = "Psydonite monks, trained in the Naledian discipline of Automagic - enhancement of one's own body through Arcyne Magick. \
	Your fists and your will are the one thing that cannot be deprived from you, handy tools when Azuria is rife with monsters and heretics alike. \
	Where your fists fall short, your wits prevail. Where your magyck falters, your fists answer. \
	His will be done."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/sojourner
	subclass_languages = list(/datum/language/otavan, /datum/language/celestial)
	category_tags = list(CTAG_ORTHODOXIST)
	traits_applied = list(
		TRAIT_CIVILIZEDBARBARIAN,
		TRAIT_ARCYNE,
		TRAIT_NALEDI
	)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_CON = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4, "ward" = TRUE)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/sojourner
	job_bitflag = BITFLAG_HOLY_WARRIOR
	var/sidearm_selected

/datum/outfit/job/roguetown/sojourner/Topic(href, href_list)
	. = ..()
	if(href_list["sidearm"])
		sidearm_selected = href_list["sidearm"]

/datum/outfit/job/roguetown/sojourner/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/fist_of_psydon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/grasp_of_psydon())
		H.mind.AddSpell(new /datum/action/cooldown/spell/blink/shadowstep)
		H.mind.AddSpell(new /datum/action/cooldown/spell/storm_of_psydon())
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/blade_of_psydon())

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.set_chant("unarmed")

	sidearm_selected = null
	var/chant_html = get_spellfist_chant_html(src, H)
	H << browse(chant_html, "window=spellfist_tutorial;size=650x700")
	onclose(H, "spellfist_tutorial", src)

	var/open_time = world.time
	while(!sidearm_selected && world.time - open_time < 5 MINUTES)
		stoplag(1)
	H << browse(null, "window=spellfist_tutorial")

	if(!sidearm_selected)
		sidearm_selected = "katar"

	switch(sidearm_selected)
		if("katar")
			H.put_in_hands(new /obj/item/rogueweapon/katar(H))
		if("knuckledusters")
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/knuckles(H))

	head = /obj/item/clothing/head/roguetown/headband/naledi
	mask = /obj/item/clothing/mask/rogue/lordmask/naledi/sojourner
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/naledi
	gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
	armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	neck = /obj/item/clothing/neck/roguetown/psicross/g
	id = /obj/item/clothing/ring/signet
	belt = /obj/item/storage/belt/rogue/leather/rope/dark
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	backl = /obj/item/storage/backpack/rogue/satchel/black
	cloak = /obj/item/clothing/cloak/tabard/psydontabard/alt
	var/naledi_book = pick(/obj/item/book/rogue/naledi1, /obj/item/book/rogue/naledi2, /obj/item/book/rogue/naledi3, /obj/item/book/rogue/naledi4)
	backpack_contents = list(
		/obj/item/roguekey/inquisitionmanor = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1,
		/obj/item/roguegem/amethyst/naledi = 1,
		(naledi_book) = 1,
		/obj/item/book/spellbook = 1,
		)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)

	change_origin(H, /datum/virtue/origin/naledi, "Holy order")//These are Naledi we make them actually Naledi
	H.grant_language(/datum/language/celestial)
