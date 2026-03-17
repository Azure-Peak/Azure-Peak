/datum/advclass/hag
	name = "Hag"
	tutorial = "You are ancient, malevolent evil. None of the known gods claim to have brought you into this world. All you know is hatred, how to sift through the grains of this land with your calloused hands, picking those who prove themselves useful."
	outfit = /datum/outfit/job/roguetown/hag
	traits_applied = list(TRAIT_RITUALIST, TRAIT_ALCHEMY_EXPERT, TRAIT_ANCIENT_HAG, TRAIT_MIRROR_MAGIC)
	reset_stats = TRUE
	subclass_stats = list(
		STATKEY_STR = -7,
		STATKEY_WIL = 8,
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
		/datum/skill/craft/alchemy = SKILL_LEVEL_LEGENDARY
	)
	category_tags = list(CTAG_HAG)
	cmode_music = 'sound/music/combat_graggar.ogg'

/datum/outfit/job/roguetown/hag

/datum/outfit/job/roguetown/hag/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/hag_true_form)
		H.set_patron(/datum/patron/godless)
		H.AddComponent(/datum/component/hag_curio_tracker)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/varnish)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/synth_shiny)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/hag/synth_base)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/spiritual_siphon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/transmutation_rite)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/grant_boon)

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
	user.visible_message(span_warning("[user] begins to twist and contort!"), span_notice("I begin to transform..."))
	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/hag_true_form/Shapeshift(mob/living/caster)
	// Do-after before transforming
	if(!do_after(caster, 3 SECONDS, target = caster))
		to_chat(caster, span_warning("Transformation interrupted!"))
		revert_cast(caster)  // Refund the cooldown
		return

	// Call parent to actually transform
	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/hag_true_form/Restore(mob/living/shape)
	// Check if restrained before allowing revert
	if(shape.restrained(ignore_grab = FALSE))
		to_chat(shape, span_warn("I am restrained, I can't transform back!"))
		revert_cast(shape)  // Refund the cooldown
		return

	// Add do-after for witches when reverting
	shape.visible_message(span_warning("[shape] begins to shift back!"), span_notice("I begin to transform..."))
	if(!do_after(shape, 3 SECONDS, target = shape))
		to_chat(shape, span_warning("Transformation revert interrupted!"))
		revert_cast(shape)  // Refund the cooldown
		return

	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/hag_true_form
	name = "True form"
	desc = "I'm tired of these mortals invading MY bog, out with them!! I shall show them -true- terror!"
	overlay_state = "cat_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/hag_shapeshift
