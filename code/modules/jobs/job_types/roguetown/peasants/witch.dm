/datum/job/roguetown/witch
	title = "Witch"
	flag = WITCH
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 3 // you can have a coven, but there shouldn't be many of these
	spawn_positions = 3
	display_order = JDO_WITCH
	allowed_sexes = list(MALE, FEMALE) // no forbidden races since these are outcasts
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'

	tutorial = "You are a witch, seen as wisefolk to some and a demon to many. Ostracized and sequestered for wrongthinks or outright heresy, your potions are what the commonfolk turn to when all else fails, and for this they tolerate you — at an arm's length. Take care not to end 'pon a pyre, for the church condemns your left handed arts."

	give_bank_account = FALSE // weird for them to be taxed by default + lets them live invisibly for real outcast larp
	min_pq = -10
	max_pq = null
	round_contrib_points = 2

	job_traits = list(TRAIT_DEATHSIGHT, TRAIT_WITCH, TRAIT_ALCHEMY_EXPERT, TRAIT_RESIDENT) // so they can claim the witch huts

	job_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1
	)

	advclass_cat_rolls = list(CTAG_WITCH = 3)
	job_subclasses = list(
		/datum/advclass/oldmagick,
		/datum/advclass/mystagogue,
		/datum/advclass/godsblood
	)

/datum/advclass/oldmagick
	name = "Old Magick"
	tutorial = "Unlike the mages in their ivory tower, you practice your magick without the sanction of the Crown. The townsfolk may fear you, the Church may condemn you, but you alone know truths the Academy has forgotten."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/adventurer/witch/oldmagick
	category_tags = list(CTAG_WITCH)
	townie_contract_gate_exempt = TRUE
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1
	)
	age_mod = /datum/class_age_mod/witch
	traits_applied = list(TRAIT_ARCYNE)

	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 5, "ward" = TRUE)

/datum/advclass/godsblood
	name = "Godsblood"
	tutorial = "The Church would say that the only way to wield the power of the gods is a lyfe dedicated fully to worship. You beg to differ. Through a taboo ritual, you now wield your patron's miracles - though not without cost. Condemned by the Chuch and feared by the townsfolk, you live on as a pariah, the last resort of those with no-one else to turn to."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/adventurer/witch/godsblood
	category_tags = list(CTAG_WITCH)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1
	)
	age_mod = /datum/class_age_mod/witch

	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)

/datum/advclass/mystagogue
	name = "Mystagogue"
	tutorial = "You may not be as knowledgeable as a magos, or as powerful as an acolyte, but your command of both the arcyne and divine arts lends you a unique strength. Such a mixture is oft considered heretical, and you've had to dodge the suspicions of the Church your whole lyfe."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/adventurer/witch/mystagogue
	category_tags = list(CTAG_WITCH)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1
	)
	age_mod = /datum/class_age_mod/witch

	subclass_skills = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 3)

/datum/outfit/job/roguetown/adventurer/witch/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/witchhat
	mask = /obj/item/clothing/head/roguetown/roguehood/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/storage/magebag/starter
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/shortboots

	var/list/prefs = H.client?.prefs?.job_subprefs
	var/list/witchprefs
	if(prefs)
		witchprefs = prefs["Witch"]
	var/shapeshiftchoice
	if(witchprefs && witchprefs["witch_form"])
		shapeshiftchoice = witchprefs["witch_form"]
	if(!shapeshiftchoice)
		var/shapeshifts = list("Zad", "Cat", "Cat (Black)", "Bat", "Lesser Volf", "Cabbit", "Small Rous", "Lesser Venard")
		shapeshiftchoice = input(H, "What form does your second skin take?", "THE OLD WAYS") as anything in shapeshifts
	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/armor/corset
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		pants = /obj/item/clothing/under/roguetown/skirt/red

	if(H.mind)
		switch (shapeshiftchoice)
			if("Zad")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/crow)
			if("Cat")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat)
			if("Cat (Black)")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat/black)
			if("Bat")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/bat)
			if("Lesser Volf")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_wolf)
			if("Lesser Venard")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_vernard)
			if("Small Rous")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/rous)
			if("Cabbit")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cabbit)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)

/datum/outfit/job/roguetown/adventurer/witch/oldmagick/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = choose_implement(H, "lesser")
	backpack_contents = list(
						/obj/item/rogueweapon/spellbook = 1,
						/obj/item/reagent_containers/glass/mortar = 1,
						/obj/item/pestle = 1,
						/obj/item/candle/yellow = 2,
						/obj/item/chalk = 1
						)
	if (H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE)

/datum/outfit/job/roguetown/adventurer/witch/godsblood/pre_equip(mob/living/carbon/human/H)
	. = ..()
	var/datum/devotion/D = new /datum/devotion/(H, H.patron)
	D.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_2)
	D.max_devotion *= 0.5
	neck = /obj/item/clothing/neck/roguetown/psicross/wood
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
						/obj/item/reagent_containers/glass/mortar = 1,
						/obj/item/pestle = 1,
						/obj/item/candle/yellow = 2,
						)
	if (H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)

/datum/outfit/job/roguetown/adventurer/witch/mystagogue/pre_equip(mob/living/carbon/human/H)
	. = ..()
	// hybrid arcane/holy witch with t1 arcane and t1 miracles
	var/datum/devotion/D = new /datum/devotion/(H, H.patron)
	H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
	D.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
	D.max_devotion *= 0.5
	ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
	neck = /obj/item/clothing/neck/roguetown/psicross/wood
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
						/obj/item/rogueweapon/spellbook = 1,
						/obj/item/reagent_containers/glass/mortar = 1,
						/obj/item/pestle = 1,
						/obj/item/candle/yellow = 2,
						/obj/item/chalk = 1
						)
	if (H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
	grant_poke_spell(H)

/obj/effect/proc_holder/spell/targeted/shapeshift/witch
	die_with_shapeshifted_form = FALSE
	gesture_required = TRUE
	chargetime = 5 SECONDS
	recharge_time = 50
	cooldown_min = 50
	convert_damage = FALSE
	do_gib = FALSE
	knockout_on_death = 10 SECONDS

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cast(list/targets, mob/user = usr)
	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/Shapeshift(mob/living/caster)
	caster.visible_message(span_warning("[caster] begins to twist and contort!"), span_notice("I begin to transform into another form..."))
	// Do-after before transforming
	if(!do_after(caster, 3 SECONDS, target = caster))
		to_chat(caster, span_warning("Transformation interrupted!"))
		revert_cast(caster)  // Refund the cooldown
		return

	// Call parent to actually transform
	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/Restore(mob/living/shape)
	// Check if restrained before allowing revert
	if(shape.restrained(ignore_grab = FALSE))
		to_chat(shape, span_warn("I am restrained, I can't transform back!"))
		revert_cast(shape)  // Refund the cooldown
		return

	// Add do-after for witches when reverting
	shape.visible_message(span_warning("[shape] compresses and takes another form!"), span_notice("I begin to twist back into my normal form..."))
	if(!do_after(shape, 3 SECONDS, target = shape))
		to_chat(shape, span_warning("Transformation revert interrupted!"))
		revert_cast(shape)  // Refund the cooldown
		return

	return ..()


/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat
	name = "Cat Form"
	desc = ""
	overlay_state = "cat_transform"
	shapeshift_type = /mob/living/simple_animal/pet/cat/witch_shifted

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat/black
	shapeshift_type = /mob/living/simple_animal/pet/cat/rogue/black/witch_shifted

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_wolf
	name = "Lesser Volf Form"
	desc = ""
	overlay_state = "volf_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/wolf/witch_shifted

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/bat
	name = "Bat Form"
	desc = ""
	overlay_state = "bat_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/bat
	knockout_on_death = 30 SECONDS

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/crow
	name = "Zad Form"
	overlay_state = "zad"
	desc = ""
	knockout_on_death = 15 SECONDS
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/bat/crow
	sound = 'sound/vo/mobs/bird/birdfly.ogg'

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_vernard
	name = "Lesser Vernard Form"
	desc = ""
	overlay_state = "vernard_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/fox/witch_shifted

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/rous
	name = "Small Rous Form"
	desc = ""
	overlay_state = "rous_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/smallrat/witch_shifted

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cabbit
	name = "Cabbit Form"
	desc = ""
	overlay_state = "cabbit_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/witch_shifted

/datum/intent/simple/claw/witch_cat
	name = "scratch"
	attack_verb = list("scratches", "claws")

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/witch_shifted
	name = "lesser volf"
	desc = "A smaller, runtier variant of the classic volf that hounds the woods nearby. Rarely seen around these parts, and doesn't look nearly as dangerous as its larger counterparts. This one has a peculiar intelligence in its yellow eyes..."
	STASPD = 15
	STASTR = 3
	STACON = 5
	melee_damage_lower = 9
	melee_damage_upper = 14
	del_on_deaggro = null
	defprob = 70

/mob/living/simple_animal/pet/cat/witch_shifted
	name = "aloof cat"
	desc = "A bored-seeming feline. This one has a peculiar intelligence in its green eyes..."
	defprob = 90
	STASPD = 18
	STASTR = 1
	STACON = 3
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 2
	melee_damage_upper = 5

/mob/living/simple_animal/pet/cat/rogue/black/witch_shifted
	name = "voidblack cat"
	desc = "Supposedly sacred to Necra, and just as interested in rats as their lesser counterparts. This one has a strange intelligence behind its dark, wide eyes..."
	defprob = 90
	STASPD = 18
	STASTR = 1
	STACON = 3
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 2
	melee_damage_upper = 5

/mob/living/simple_animal/hostile/retaliate/rogue/fox/witch_shifted
	name = "lesser venard"
	desc = "A smaller, runtier variant of the sneaky venards that skulk the woods nearby. Rarely seen around these parts, and doesn't look nearly as dangerous as its larger counterparts. This one has a peculiar intelligence in its yellow eyes..."
	defprob = 90
	STASPD = 18
	STASTR = 2
	STACON = 4
	melee_damage_lower = 8
	melee_damage_upper = 12
	del_on_deaggro = null
	defprob = 70

/mob/living/simple_animal/hostile/retaliate/smallrat/witch_shifted
	name = "small rous"
	desc = "Supposedly sacred to Pestra, these small and occasionally pestilent creachurs are commonly found in pantries and ships. This one seems to be a bit more smarter than the others..."
	defprob = 90
	STASPD = 18
	STASTR = 1
	STACON = 1
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 1
	melee_damage_upper = 2

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/witch_shifted
	name = "lesser cabbit"
	desc = "Seeing one of these quick beasts is said to bring Xylix's fortune, along with their feet. It looks weak and innocent, and incredibly adorable."
	defprob = 90
	STASPD = 20
	STASTR = 1
	STACON = 2
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 1
	melee_damage_upper = 2
