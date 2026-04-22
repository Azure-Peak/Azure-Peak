#define HAG_TRANSFORM_LOCKOUT (2 MINUTES)

/datum/advclass/hag
	name = "Hag"
	tutorial = "You are ancient, malevolent evil. None of the known gods claim to have brought you into this world. All you know is hatred, how to sift through the grains of this land with your calloused hands, picking those who prove themselves useful."
	outfit = /datum/outfit/job/roguetown/hag
	traits_applied = list(TRAIT_RITUALIST, TRAIT_ALCHEMY_EXPERT,
	 					  TRAIT_ANCIENT_HAG, TRAIT_EDIT_DESCRIPTORS,
						  TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT,
						  TRAIT_LEECHIMMUNE, TRAIT_ZOMBIE_IMMUNE,
						  TRAIT_NOMOOD, TRAIT_UNLYCKERABLE,
						  TRAIT_KNEESTINGER_IMMUNITY, TRAIT_DARKVISION,
						  TRAIT_NOHUNGER)
	reset_stats = TRUE
	subclass_stats = list(
		STATKEY_STR = -7,
		STATKEY_WIL = 8,
		// She should have a hard time kiting to make using crossbows harder.
		STATKEY_SPD = -2,
		STATKEY_CON = 1,
		STATKEY_INT = 9
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/medicine = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/crafting = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/alchemy = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/sewing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/cooking = SKILL_LEVEL_MASTER,
	)
	category_tags = list(CTAG_HAG)
	cmode_music = 'sound/music/combat_graggar.ogg'

/datum/outfit/job/roguetown/hag

/datum/outfit/job/roguetown/hag/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/hag
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	beltl = /obj/item/storage/belt/rogue/pouch/coins/aalloy
	beltr = /obj/item/roguekey/hag
	if(H.mind)
		H.verbs |= /mob/living/carbon/human/proc/commune_with_roots
		H.ambushable = FALSE
		H.faction |= list("hag", "spiders")
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/wildshape/hag_true_form)
		H.set_patron(/datum/patron/mossmother)
		H.AddComponent(/datum/component/hag_curio_tracker)
		// --- Taught Recipes ---
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/varnish)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/synth_shiny)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/synth_base)

		// Low Rarity
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/faded_moss)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/crawling_moss)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/stormy_moss)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/corrosive_moss)

		// Mid Rarity
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/lustrous_moss)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/caring_moss)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/rooted_moss)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/creeping_moss)

		// High Rarity
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/prismatic_moss)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/gilded_moss)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/drowned_moss)

		// Items
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_axe)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_cross)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_sword)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_spear)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/lux_moss)

		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/repulse)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/spiritual_siphon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/transmutation_rite)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/grant_boon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/resurrect/hag)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mindlink/hag)
		H.dna.species.soundpack_m = new /datum/voicepack/hag()
		H.dna.species.soundpack_f = new /datum/voicepack/hag()
		if(!H.mind.has_antag_datum(/datum/antagonist/hag))
			var/datum/antagonist/new_antag = new /datum/antagonist/hag()
			H.mind.add_antag_datum(new_antag)

/datum/antagonist/hag
	name = "Hag"
	roundend_category = "Hags"
	antagpanel_category = "Hags"
	job_rank = ROLE_HAG

/datum/antagonist/hag/roundend_report()
	var/grand_rite_victory = FALSE
	var/individual_spite_score = 0
	var/is_living = (owner?.current && owner.current.stat != DEAD)

	for(var/obj/structure/roguemachine/hag_heart/H in GLOB.hag_hearts)
		if(H.rite_completed)
			grand_rite_victory = TRUE
			break

	if(owner?.current)
		var/datum/component/hag_curio_tracker/HCT = owner.current.GetComponent(/datum/component/hag_curio_tracker)
		if(HCT)
			for(var/t_name in HCT.boon_registry)
				var/datum/hag_boon/curse_scar/S = HCT.find_boon_by_type(t_name, /datum/hag_boon/curse_scar)
				if(S)
					individual_spite_score += S.points

	printplayer(owner)

	if(grand_rite_victory)
		to_chat(world, span_boldnotice("THE MOSS MOTHER HAS ASCENDED!"))
		to_chat(owner, span_greentext("Your sisters have completed the Grand Rite. You have TRIUMPHED!"))
		if(owner.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 50, FALSE)
	else if(is_living && individual_spite_score > 0)
		to_chat(owner, span_notice("The Grand Rite was not completed, but your harvest of souls was bountiful."))
		to_chat(owner, span_info("Your Personal Spite Score: [individual_spite_score] points."))
		to_chat(world, span_notice("The Hag [owner.current.real_name] has left a mark of misery of [individual_spite_score] points."))
	else
		// If dead or scoreless and no Grand Rite happened
		var/fail_reason = !is_living ? "Your physical form was broken and the roots withered." : "You failed to sow enough discord among the mortals."
		to_chat(owner, span_redtext("FAILURE: [fail_reason]"))
		to_chat(world, span_redtext("The Hag [owner.current ? owner.current.real_name : "unknown"] has FAILED!"))
		if(owner.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 50, FALSE)

/datum/status_effect/debuff/hag_bog_tether
	id = "hag_bog_tether"
	duration = -1
	tick_interval = 5 SECONDS
	alert_type = null

/datum/status_effect/debuff/hag_bog_tether/tick()
	var/mob/living/L = owner
	if(!L)
		return

	var/area/A = get_area(L)

	if(!istype(A, /area/rogue/outdoors/bog) && !istype(A, /area/rogue/indoors/shelter/bog) && !istype(A, /area/rogue/indoors/shelter/bog_hag))
		to_chat(L, span_userdanger("The air is too pure! My monstrous form cannot sustain itself away from the Mother's roots!"))
		
		// Find the shapeshift holder and force a restore
		var/obj/shapeshift_holder/H = locate() in L
		if(H)
			var/mob/living/carbon/human/hum = H.stored
			COOLDOWN_START(hum, hag_transform_lockout, HAG_TRANSFORM_LOCKOUT)
			H.restore()
		return

#undef HAG_TRANSFORM_LOCKOUT
