#define HAG_TRANSFORM_LOCKOUT (2 MINUTES)

/datum/advclass/hag
	name = "Hag"
	tutorial = "You are ancient, malevolent evil. None of the known gods claim to have brought you into this world. All you know is hatred, how to sift through the grains of this land with your calloused hands, picking those who prove themselves useful."
	outfit = /datum/outfit/job/roguetown/hag
	traits_applied = list(TRAIT_RITUALIST, TRAIT_ALCHEMY_EXPERT,
	 					  TRAIT_ANCIENT_HAG, TRAIT_MIRROR_MAGIC,
						  TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT,
						  TRAIT_LEECHIMMUNE, TRAIT_ZOMBIE_IMMUNE)
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
	if(H.mind)
		H.ambushable = FALSE
		H.faction |= list("hag", "spiders")
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/hag_true_form)
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

		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/spiritual_siphon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/transmutation_rite)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/grant_boon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/resurrect/hag)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mindlink/hag)
		H.dna.species.soundpack_m = new /datum/voicepack/hag()
		H.dna.species.soundpack_f = new /datum/voicepack/hag()
		if(H.mind.has_antag_datum(/datum/antagonist/hag))
			var/datum/antagonist/new_antag = new /datum/antagonist/hag()
			H.mind.add_antag_datum(new_antag)

/obj/effect/proc_holder/spell/targeted/shapeshift/hag_true_form
	die_with_shapeshifted_form = FALSE
	gesture_required = TRUE
	chargetime = 5 SECONDS
	recharge_time = 50
	cooldown_min = 50
	convert_damage = FALSE
	do_gib = FALSE
	knockout_on_death = 10 SECONDS

/obj/effect/proc_holder/spell/targeted/shapeshift/hag_true_form/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!COOLDOWN_FINISHED(H, hag_transform_lockout))
		var/time_left = COOLDOWN_TIMELEFT(H, hag_transform_lockout)
		to_chat(user, span_warning("My essence is scattered by the clean air of the world. I must wait [DisplayTimeText(time_left)] to reform."))
		return FALSE

	var/area/A = get_area(user)

	if(!istype(A, /area/rogue/outdoors/bog) && !istype(A, /area/rogue/indoors/shelter/bog) && !istype(A, /area/rogue/indoors/shelter/bog_hag))
		to_chat(user, span_warning("The air here is too pure, the soil too firm. I feel the nasty gaze of the ten. I can only reveal my true self within the Terrorbog or my Hut!"))
		revert_cast(user)
		return FALSE
	user.visible_message(span_warning("[user] begins to twist and contort!"), span_notice("I begin to transform..."))
	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/hag_true_form/Shapeshift(mob/living/caster)
	// Do-after before transforming
	if(!do_after(caster, 3 SECONDS, target = caster))
		to_chat(caster, span_warning("Transformation interrupted!"))
		revert_cast(caster)  // Refund the cooldown
		return

	// Call parent to actually transform
	..()

	var/obj/shapeshift_holder/H = locate() in usr 
	if(H && H.shape)
		H.shape.apply_status_effect(/datum/status_effect/debuff/hag_bog_tether)
		to_chat(H.shape, span_notice("The rot of the bog sustains this form... I must not wander too far."))
	else
		// Fallback
		var/obj/shapeshift_holder/H_fallback = caster.loc
		if(istype(H_fallback) && H_fallback.shape)
			H_fallback.shape.apply_status_effect(/datum/status_effect/debuff/hag_bog_tether)

	return TRUE

/obj/effect/proc_holder/spell/targeted/shapeshift/hag_true_form/Restore(mob/living/shape)
	// Check if restrained before allowing revert
	if(shape.restrained(ignore_grab = FALSE))
		to_chat(shape, span_warn("I am restrained, I can't transform back!"))
		revert_cast(shape)  // Refund the cooldown
		return

	// Add do-after for witches when reverting
	shape.visible_message(span_warning("[shape] begins to shift back!"), span_notice("I begin to transform..."))
	if(!do_after(shape, 15 SECONDS, target = shape))
		to_chat(shape, span_warning("Transformation revert interrupted!"))
		revert_cast(shape)  // Refund the cooldown
		return

	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/hag_true_form
	name = "True form"
	desc = "I'm tired of these mortals invading MY bog, out with them!! I shall show them -true- terror!"
	overlay_state = "cat_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/hag_shapeshift

/datum/antagonist/hag
	name = "Hag"
	roundend_category = "Hags"
	antagpanel_category = "Hags"
	job_rank = ROLE_HAG

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
