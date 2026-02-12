/obj/effect/proc_holder/spell/invoked/projectile/arcynestrike
	name = "Arcyne Strike"
	desc = "Imbue your held weapon with latent arcyne energy before striking your target"
	cost = 2 // basic spellblade melee spell
	overlay_state = "conjure_weapon"
	range = 1
	projectile_type = /obj/projectile/energy/arcynestrike
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
	spell_tier = 2 // offensive magic
	invocation_type = "none"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	gesture_required = TRUE
	human_req = TRUE // Combat spell
	

/obj/effect/proc_holder/spell/invoked/projectile/arcynestrike/cast(list/targets, mob/user = user)
	var/mob/living/carbon/human/H = user
	var/datum/intent/attack_intent = H.a_intent // Use the attack intent
	var/mapped_wound_class = BCLASS_CUT
	switch(attack_intent.blade_class)
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
			projectile_type = /obj/projectile/energy/arcynestrike/blunt
		if(BCLASS_STAB)
			projectile_type = /obj/projectile/energy/arcynestrike/stab
		else
			projectile_type = /obj/projectile/energy/arcynestrike

	. = ..()


/obj/projectile/energy/arcynestrike
	name = "Arcyne Smite (Cut)"
	icon_state = "air_blade_cut"
	damage = 50
	range = 1
	woundclass = BCLASS_CUT
	nodamage = FALSE
	npc_simple_damage_mult = 1.5 // Makes it more effective against NPCs.
	hitsound = 'sound/combat/hits/bladed/smallslash (1).ogg'
	speed = 10 // to make sure it hit the target
	var/apply_mark = TRUE

/obj/projectile/energy/arcynestrike/blunt
	name = "Arcyne Smite (Blunt)"
	icon_state = "air_blade_blunt"
	woundclass = BCLASS_BLUNT
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg' // Different sound for blunt

/obj/projectile/energy/arcynestrike/stab
	name = "Arcyne Smite (Stab)"
	icon_state = "air_blade_stab"
	woundclass = BCLASS_STAB
	hitsound = 'sound/combat/hits/bladed/genstab (3).ogg' // Different sound for stab

/obj/projectile/energy/arcynestrike/on_hit(target)

	var/mob/living/carbon/M = target
	if(ismob(target))
		var/datum/status_effect/debuff/arcanemark/mark = M.has_status_effect(/datum/status_effect/debuff/arcanemark)
		if(mark && mark.stacks == mark.max_stacks)
			armor_penetration = 40 //pierces most armors
			apply_mark = FALSE
			consume_arcane_mark_stacks(M)

	. = ..()

	if(ismob(target))
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
