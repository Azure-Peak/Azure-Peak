/obj/effect/proc_holder/spell/invoked/arcynestrike
	name = "Arcyne Strike"
	desc = "Imbue your held weapon with latent arcyne energy before striking your target"
	cost = 2 // basic spellblade melee spell
	overlay_state = "hellish_rebuke"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0.6 SECONDS
	charging_slowdown = 2
	recharge_time = 5 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocation_type = "none"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	gesture_required = TRUE
	human_req = TRUE // Combat spell
	range = 1

/obj/effect/proc_holder/spell/invoked/arcynestrike/cast(list/targets, mob/user = user)
	var/mob/living/carbon/human/H = user
	var/datum/intent/a_intent = H.a_intent // Use the attack intent
	var/mapped_wound_class = BCLASS_CUT
	switch(a_intent.blade_class)
		if(BCLASS_BLUNT)
			mapped_wound_class = BCLASS_BLUNT
		if(BCLASS_SMASH)
			mapped_wound_class = BCLASS_BLUNT
		if(BCLASS_PICK)
			mapped_wound_class = BCLASS_STAB
		if(BCLASS_STAB)
			mapped_wound_class = BCLASS_STAB
				switch(mapped_wound_class)
		if(BCLASS_BLUNT)
			cast(/obj/effect/proc_holder/spell/invoked/smite/blunt/cast(list/targets, mob/living/user))
		if(BCLASS_STAB)
			cast(/obj/effect/proc_holder/spell/invoked/smite/stab/cast(list/targets, mob/living/user))
		else
			cast(/obj/effect/proc_holder/spell/invoked/smite/cast(list/targets, mob/living/user))

	. = ..()


/obj/effect/proc_holder/spell/invoked/smite/cast(list/targets, mob/living/user)
	if(!isliving(targets[1]))
		return FALSE

	var/mob/living/carbon/target = targets[1]
	damage = 50
	woundclass = BCLASS_CUT
	nodamage = FALSE
	npc_simple_damage_mult = 1.5 // Makes it more effective against NPCs.
	hitsound = 'sound/combat/hits/bladed/smallslash (1).ogg'
	target.visible_message(span_warning("[user] strikes at [target] with rending arcyne energy!"), \
	span_userdanger("[user] striles you with rending arcyne energy"))

/obj/effect/proc_holder/spell/invoked/smite/blunt/cast(list/targets, mob/living/user)
	if(!isliving(targets[1]))
		return FALSE

	var/mob/living/carbon/target = targets[1]
	woundclass = BCLASS_BLUNT
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg'
	target.visible_message(span_warning("[user] strikes at [target] with crushing arcyne energy!"), \
	span_userdanger("[user] striles you with crushing arcyne energy"))

/obj/effect/proc_holder/spell/invoked/smite/stab/cast(list/targets, mob/living/user)
	if(!isliving(targets[1]))
		return FALSE

	var/mob/living/carbon/target = targets[1]
	woundclass = BCLASS_STAB
	hitsound = 'sound/combat/hits/bladed/genstab (3).ogg'
	target.visible_message(span_warning("[user] strikes at [target] with piercing arcyne energy!"), \
	span_userdanger("[user] striles you with piercing arcyne energy"))

/obj/effect/proc_holder/spell/invoked/smite/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/carbon/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
