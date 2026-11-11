#define DOPPEL_CLONE_RANGE 15
#define DOPPEL_AUDIENCE_RANGE 7
#define DOPPEL_TAKE_FORM_RANGE 14
#define DOPPEL_UNSEEN_TIME (10 HOURS)
#define DOPPEL_CHATTER_CHANCE 8 // Should makes masked Doppel more obviouss
#define DOPPEL_LAUGH_CHANCE 50
#define DOPPEL_MIRACLE_TIER_CAP CLERIC_T3
#define DOPPEL_NAME_PREFIX "Wyrd"

/mob/living/carbon/human/species/human/northern/doppelganger
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_FAE)
	ambushable = FALSE
	dodgetime = 30
	d_intent = INTENT_PARRY
	var/cloned_target = FALSE
	var/clone_ready = FALSE
	var/copied_name

/mob/living/carbon/human/species/human/northern/doppelganger/ambush
	threat_point = THREAT_DEADLY // Ochre had it at 20, let's go for 40
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/doppelganger/Initialize(mapload)
	. = ..()
	set_species(/datum/species/human/northern)
	don_shroud()
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/doppelganger/proc/don_shroud()
	if(cloned_target || length(get_equipped_items(TRUE)))
		return
	equipOutfit(new /datum/outfit/doppelganger_shroud)
	for(var/obj/item/shroud_item in get_equipped_items(TRUE))
		shroud_item.AddComponent(/datum/component/item_on_drop/dust)

/mob/living/carbon/human/species/human/northern/doppelganger/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC)
	var/static/list/ranged_skills = list(
		/datum/skill/combat/bows,
		/datum/skill/combat/crossbows,
		/datum/skill/combat/slings,
	)
	for(var/skill in GLOB.npc_melee_skills + GLOB.npc_brawl_skills + GLOB.npc_athletics_skills + ranged_skills)
		adjust_skillrank_up_to(skill, SKILL_LEVEL_EXPERT, TRUE)
	for(var/skill in GLOB.npc_survival_skills)
		adjust_skillrank_up_to(skill, SKILL_LEVEL_JOURNEYMAN, TRUE)
	clone_ready = TRUE

/mob/living/carbon/human/species/human/northern/doppelganger/Life()
	. = ..()
	if(stat == DEAD || client)
		return
	if(!cloned_target)
		if(clone_ready)
			find_clone_target()
		return
	if(!prob(DOPPEL_CHATTER_CHANCE))
		return
	if(prob(DOPPEL_LAUGH_CHANCE))
		emote("laugh")
	else
		say(doppel_voiceline(FALSE), forced = TRUE, npc_speech = TRUE)

/mob/living/carbon/human/species/human/northern/doppelganger/proc/find_clone_target()
	var/mob/living/carbon/human/closest
	var/closest_dist = DOPPEL_CLONE_RANGE + 1
	for(var/mob/living/carbon/human/candidate in GLOB.player_list)
		if(candidate.stat == DEAD || candidate.z != z)
			continue
		if(istype(candidate, /mob/living/carbon/human/species/human/northern/doppelganger))
			continue
		var/dist = get_dist(src, candidate)
		if(dist < closest_dist)
			closest = candidate
			closest_dist = dist
	if(closest)
		become(closest)

/mob/living/carbon/human/species/human/northern/doppelganger/proc/become(mob/living/carbon/human/target)
	if(!target.dna?.species)
		return FALSE
	cloned_target = TRUE
	return_to_sight()
	for(var/obj/item/shroud_item in get_equipped_items(TRUE) + held_items)
		qdel(shroud_item)
	mirror_body(target)
	mirror_gear(target)
	var/controller_type = mirror_magic(target)
	for(var/obj/item/equipped_item in get_equipped_items(TRUE) + held_items)
		equipped_item.AddComponent(/datum/component/item_on_drop/dust)
	if(!client)
		for(var/obj/item/held_item in held_items)
			ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)
		if(controller_type)
			upgrade_ai_controller(controller_type)
	regenerate_icons()
	return TRUE

/mob/living/carbon/human/species/human/northern/doppelganger/Login()
	. = ..()
	if(!client)
		return
	if(istype(ai_controller))
		QDEL_NULL(ai_controller)
	for(var/obj/item/held_item in held_items)
		REMOVE_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)
	if(cloned_target)
		to_chat(src, span_notice("You are a doppelganger wearing the form of [copied_name]."))
		return
	if(!(locate(/datum/action/cooldown/doppel_take_form) in actions))
		var/datum/action/cooldown/doppel_take_form/take_form = new(src)
		take_form.Grant(src)
	don_shroud()
	fade_from_sight()
	to_chat(src, span_notice("You are a doppelganger. You are unseen until you attack, are struck or take a form. Use Take Form to pick someone within [DOPPEL_TAKE_FORM_RANGE] paces and copy them. You get one form."))

/mob/living/carbon/human/species/human/northern/doppelganger/proc/fade_from_sight()
	mob_timers[MT_INVISIBILITY] = world.time + DOPPEL_UNSEEN_TIME
	rogue_sneaking = TRUE
	alpha = 0

/mob/living/carbon/human/species/human/northern/doppelganger/proc/return_to_sight()
	if(mob_timers[MT_INVISIBILITY] <= world.time)
		return
	mob_timers[MT_INVISIBILITY] = world.time
	update_sneak_invis(TRUE)

/datum/outfit/doppelganger_shroud
	head = /obj/item/clothing/head/roguetown/roguehood/black
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/black
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather

/datum/action/cooldown/doppel_take_form
	name = "Take Form"
	desc = "Copy the body, gear and magic of someone nearby. Works once."
	var/choosing = FALSE

/datum/action/cooldown/doppel_take_form/proc/can_copy(mob/living/carbon/human/species/human/northern/doppelganger/doppel, mob/living/carbon/human/victim)
	if(QDELETED(victim) || victim == doppel || victim.stat == DEAD)
		return FALSE
	if(istype(victim, /mob/living/carbon/human/species/human/northern/doppelganger))
		return FALSE
	return victim.z == doppel.z && get_dist(doppel, victim) <= DOPPEL_TAKE_FORM_RANGE

/datum/action/cooldown/doppel_take_form/Activate(atom/target)
	var/mob/living/carbon/human/species/human/northern/doppelganger/doppel = owner
	if(!istype(doppel) || doppel.cloned_target || choosing)
		return FALSE
	var/list/choices = list()
	for(var/mob/living/carbon/human/candidate in range(DOPPEL_TAKE_FORM_RANGE, doppel))
		if(!can_copy(doppel, candidate))
			continue
		var/label = candidate.real_name
		var/copies = 1
		while(choices[label])
			copies++
			label = "[candidate.real_name] ([copies])"
		choices[label] = candidate
	if(!length(choices))
		to_chat(doppel, span_warning("There is no one near enough to copy."))
		return FALSE
	choosing = TRUE
	var/picked = tgui_input_list(doppel, "Whose form will you take?", "Take Form", choices)
	choosing = FALSE
	if(QDELETED(src) || QDELETED(doppel) || !picked || doppel.cloned_target)
		return FALSE
	var/mob/living/carbon/human/victim = choices[picked]
	if(!can_copy(doppel, victim))
		to_chat(doppel, span_warning("[picked] is no longer near enough."))
		return FALSE
	if(!doppel.become(victim))
		to_chat(doppel, span_warning("I cannot copy that."))
		return FALSE
	log_game("[key_name(doppel)] took the form of [key_name(victim)] as a doppelganger.")
	message_admins("[key_name_admin(doppel)] took the form of [key_name_admin(victim)] as a doppelganger.")
	to_chat(doppel, span_notice("I take the form of [victim.real_name]."))
	QDEL_IN(src, 1)
	return TRUE

/mob/living/carbon/human/species/human/northern/doppelganger/proc/mirror_body(mob/living/carbon/human/target)
	gender = target.gender
	skin_tone = target.skin_tone
	dna.features = target.dna.features.Copy()
	dna.body_markings = deepCopyList(target.dna.body_markings)
	set_species(target.dna.species.type)
	dna.features = target.dna.features.Copy()
	dna.body_markings = deepCopyList(target.dna.body_markings)
	apply_markings_to_body_parts(dna.body_markings, src)
	eye_color = target.eye_color
	copied_name = target.real_name
	name = "[DOPPEL_NAME_PREFIX] [target.name]"
	real_name = "[DOPPEL_NAME_PREFIX] [target.real_name]"
	dna.real_name = real_name
	job = target.job
	advjob = target.advjob
	patron = target.patron
	pronouns = target.pronouns
	voice_type = target.voice_type
	mob_descriptors = target.mob_descriptors?.Copy()
	def_intent_change(target.d_intent)

	for(var/obj/item/bodypart/taur/their_taur in target.bodyparts)
		Taurize(their_taur.type, their_taur.taur_color || "#ffffff")

	remove_all_bodypart_features()
	for(var/obj/item/bodypart/their_part as anything in target.bodyparts)
		var/obj/item/bodypart/our_part = get_bodypart(their_part.body_zone)
		if(!our_part)
			continue
		for(var/datum/bodypart_feature/feature as anything in their_part.bodypart_features)
			our_part.clone_bodypart_feature(feature)

	for(var/obj/item/organ/ours as anything in internal_organs.Copy())
		if(!ours.visible_organ || target.getorganslot(ours.slot))
			continue
		ours.Remove(src, TRUE)
		qdel(ours)
	for(var/obj/item/organ/theirs as anything in target.internal_organs)
		if(!theirs.visible_organ)
			continue
		var/datum/organ_dna/blueprint = theirs.create_organ_dna()
		var/obj/item/organ/copy = blueprint.create_organ()
		copy.Insert(src, TRUE, FALSE)

	STASTR = target.STASTR
	STASPD = target.STASPD
	STACON = target.STACON
	STAWIL = target.STAWIL
	STAPER = target.STAPER
	STAINT = target.STAINT
	STALUC = target.STALUC
	recalculate_pain_threshold()

/mob/living/carbon/human/species/human/northern/doppelganger/proc/mirror_gear(mob/living/carbon/human/target)
	var/static/list/worn_slots = list(
		SLOT_SHIRT,
		SLOT_PANTS,
		SLOT_ARMOR,
		SLOT_SHOES,
		SLOT_GLOVES,
		SLOT_WRISTS,
		SLOT_NECK,
		SLOT_WEAR_MASK,
		SLOT_HEAD,
		SLOT_MOUTH,
		SLOT_GLASSES,
		SLOT_RING,
		SLOT_CLOAK,
		SLOT_BELT,
		SLOT_BELT_L,
		SLOT_BELT_R,
		SLOT_BACK,
		SLOT_BACK_L,
		SLOT_BACK_R,
		SLOT_L_STORE,
		SLOT_R_STORE,
		SLOT_S_STORE,
	)
	for(var/slot in worn_slots)
		var/obj/item/copy = copy_item(target.get_item_by_slot(slot))
		if(copy)
			equip_to_slot_or_del(copy, slot)
	for(var/hand_index in 1 to length(target.held_items))
		var/obj/item/copy = copy_item(target.held_items[hand_index])
		if(copy && !put_in_hand(copy, hand_index))
			qdel(copy)

/mob/living/carbon/human/species/human/northern/doppelganger/proc/copy_item(obj/item/original)
	if(!istype(original) || (original.item_flags & ABSTRACT) || istype(original, /obj/item/grabbing))
		return null
	var/obj/item/copy = new original.type(src)
	if(QDELETED(copy))
		return null
	copy.color = original.color
	return copy

/mob/living/carbon/human/species/human/northern/doppelganger/proc/mirror_magic(mob/living/carbon/human/target)
	var/controller_type
	adjust_skillrank_up_to(/datum/skill/magic/arcane, min(target.get_skill_level(/datum/skill/magic/arcane), SKILL_LEVEL_EXPERT), TRUE)
	adjust_skillrank_up_to(/datum/skill/magic/holy, min(target.get_skill_level(/datum/skill/magic/holy), SKILL_LEVEL_EXPERT), TRUE)

	var/datum/status_effect/buff/arcyne_momentum/their_momentum = target.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(their_momentum?.chant)
		var/datum/spellblade_chant/chant = GLOB.npc_spellblade_chants[their_momentum.chant]
		if(chant)
			chant.apply_npc_chant(src)
			controller_type = /datum/ai_controller/human_npc/caster/melee

	var/datum/mind/their_mind = target.mind
	var/list/aspects = list()
	if(LAZYLEN(their_mind?.major_aspects))
		aspects += their_mind.major_aspects
	if(LAZYLEN(their_mind?.minor_aspects))
		aspects += their_mind.minor_aspects
	for(var/datum/magic_aspect/aspect as anything in aspects)
		var/choice_spell
		for(var/candidate in aspect.choice_spells - aspect.mastery_choice_spells)
			if(their_mind.has_spell(candidate, TRUE))
				choice_spell = candidate
				break
		aspect.grant_npc_spells(src, choice_spell)
		if(!controller_type)
			controller_type = /datum/ai_controller/human_npc/caster
	if(locate(/datum/action/cooldown/spell/form_blade) in actions)
		controller_type = /datum/ai_controller/human_npc/caster/melee

	var/datum/action/cooldown/spell/conjure_arcyne_ward/their_ward = locate() in target.actions
	if(their_ward && !(locate(/datum/action/cooldown/spell/conjure_arcyne_ward) in actions))
		var/datum/action/cooldown/spell/our_ward = new their_ward.type(src)
		our_ward.Grant(src)

	if(target.devotion && grant_npc_miracle_tier(min(target.devotion.level, DOPPEL_MIRACLE_TIER_CAP)))
		if(!controller_type)
			controller_type = /datum/ai_controller/human_npc/caster/melee

	for(var/datum/action/cooldown/spell/spell in actions)
		spell.npc_on_spawn(src)
	return controller_type

/mob/living/carbon/human/species/human/northern/doppelganger/proc/pick_audience()
	for(var/mob/living/carbon/human/audience in range(DOPPEL_AUDIENCE_RANGE, src))
		if(audience == src || !audience.client)
			continue
		if(audience.nickname == "Please Change Me" || audience.real_name == copied_name)
			continue
		return audience
	return null

/mob/living/carbon/human/species/human/northern/doppelganger/proc/doppel_voiceline(dying)
	var/static/list/combat_lines = list(
		"Help me!",
		"I'm the real one!",
		"They're fake!",
		"What the fuck.",
		"Who-",
		"They're me!",
		"Get them!!!",
		"???",
	)
	var/static/list/dying_lines = list(
		"Augh, no...",
		"I only wanted a chance.",
		"I was the real one...",
	)
	var/static/list/patron_combat_lines = list(
		"Psydon" = "I will ENDURE!",
		"Undivided" = "By the Ten!",
		"Xylix" = "HAHAHA!",
		"Ravox" = "I will deliver you unto justice!",
		"Abyssor" = "I shall crash a tide upon you!",
		"Astrata" = "Light guide my hand!",
		"Dendor" = "For the call of the wilds!",
		"Eora" = "I have Eora's love about me.",
		"Malum" = "I am a divine instrument!",
		"Necra" = "Fear not, I shall bury you proper.",
		"Noc" = "For the moon.",
		"Pestra" = "I shall soothe what ails you.",
		"Baotha" = "Oh, what joy!",
		"Graggar" = "I WILL kill you!",
		"Matthios" = "This is justice!",
		"Zizo" = "What manner of creation are you?",
	)
	var/static/list/patron_dying_lines = list(
		"Psydon" = "Allfather, I could not endure any longer...",
		"Undivided" = "I fall into the arms of the ten...",
		"Xylix" = "Xylix, did I amuse you?",
		"Ravox" = "Ravox, was I unjust?",
		"Abyssor" = "Sink me into the abyss of dreams.",
		"Astrata" = "Sun, please shine your light on me one last time...",
		"Dendor" = "Argh- NOW I AM ONE WITH THE TREEFATHER!",
		"Eora" = "Into the bosom I fall...",
		"Malum" = "What was I if not a beautiful creation?",
		"Necra" = "My lady, I was always ready.",
		"Noc" = "I have never seen the night so dark...",
		"Pestra" = "Imbue my heart unto others, it is my gift to you.",
		"Baotha" = "What an interruption...",
		"Graggar" = "I fought to the end...",
		"Matthios" = "You stole my right to a lyfe.",
		"Zizo" = "What am I?",
	)
	var/list/lines = dying ? dying_lines.Copy() : combat_lines.Copy()
	if(patron)
		var/patron_line = dying ? patron_dying_lines[patron.name] : patron_combat_lines[patron.name]
		if(patron_line)
			lines += patron_line
	var/mob/living/carbon/human/audience = pick_audience()
	if(audience)
		if(dying)
			lines += "[audience.real_name], why?"
		else
			lines += "Help, [audience.nickname]!"
			lines += "Please, [audience.real_name]!"
			lines += "[audience.nickname]!"
			lines += "I'm the real [copied_name]!"
			lines += "It's me, [copied_name]!"
			lines += "[audience.real_name]..."
			lines += "[audience.nickname], get the fake [copied_name]!"
			lines += "[copied_name] is a fake!"
	return pick(lines)

/mob/living/carbon/human/species/human/northern/doppelganger/death(gibbed, nocutscene = FALSE)
	if(stat == DEAD)
		return ..()
	if(cloned_target && !client)
		say(doppel_voiceline(TRUE), forced = TRUE, npc_speech = TRUE)
	if(!gibbed)
		new /obj/item/doppel_heart(get_turf(src))
	. = ..()
	if(!gibbed)
		dust(FALSE, FALSE, TRUE)

/obj/item/doppel_heart
	name = "doppel heart"
	desc = "A chalky white heart. It is still beating."
	icon = 'icons/roguetown/items/doppel_heart.dmi'
	icon_state = "doppel"
	sellprice = 150
	dropshrink = 0.7

#undef DOPPEL_CLONE_RANGE
#undef DOPPEL_AUDIENCE_RANGE
#undef DOPPEL_TAKE_FORM_RANGE
#undef DOPPEL_UNSEEN_TIME
#undef DOPPEL_CHATTER_CHANCE
#undef DOPPEL_LAUGH_CHANCE
#undef DOPPEL_MIRACLE_TIER_CAP
#undef DOPPEL_NAME_PREFIX
