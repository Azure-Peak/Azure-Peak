/* ALMAH & SPELLBLADE ARCHETYPE EXCLUSIVE
 Do not make this learnable by wizards in general. It is part of spellblade's identity.
 Design is that this is an Arcyne Bolt sidegrade that don't works well as a DPS spell
 And is meant to be weaved in between attacks in melee to keep pressure
 It can access all damage types and can crit, like Arcyne Bolt.
*/

/obj/effect/proc_holder/spell/invoked/projectile/airblade
	name = "Air Blade"
	desc = "Slash the air with your weapon, forming an arcyne blade in the air that can strike enemies at range. Adds a stack of <b>Arcane Mark</b> to the target. \n\
	Damage type depends on your current intent. It defaults to cut, but change to blunt if it is Blunt / Smash, and stabbing if it is stab / pick\n\
	Damage is increased by 50% versus simple-minded creechurs."
	clothes_req = FALSE
	range = 6
	projectile_type = /obj/projectile/energy/airblade
	overlay_state = "air_blade"
	sound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg')
	active = FALSE
	releasedrain = 20 // Same stamina cost as Arcyne bolt
	chargedrain = 0
	chargetime = 0
	recharge_time = 8 SECONDS //2x longer recharge than Arcyne Bolt so not spammable
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	invocations = list("Aeris Gladios!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	cost = 3 // Just in case

/obj/effect/proc_holder/spell/invoked/projectile/airblade/cast(list/targets, mob/user = user)
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
			projectile_type = /obj/projectile/energy/airblade/blunt
		if(BCLASS_STAB)
			projectile_type = /obj/projectile/energy/airblade/stab
		else
			projectile_type = /obj/projectile/energy/airblade

	. = ..()


/obj/projectile/energy/airblade
	name = "Air Blade (Cut)"
	icon_state = "air_blade_cut"
	damage = 40
	woundclass = BCLASS_CUT
	nodamage = FALSE
	npc_simple_damage_mult = 1.5 // Makes it more effective against NPCs.
	hitsound = 'sound/combat/hits/bladed/smallslash (1).ogg'
	speed = 1

/obj/projectile/energy/airblade/blunt
	name = "Air Blade (Blunt)"
	icon_state = "air_blade_blunt"
	woundclass = BCLASS_BLUNT
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg' // Different sound for blunt

/obj/projectile/energy/airblade/stab
	name = "Air Blade (Stab)"
	icon_state = "air_blade_stab"
	woundclass = BCLASS_STAB
	hitsound = 'sound/combat/hits/bladed/genstab (3).ogg' // Different sound for stab

/obj/projectile/energy/airblade/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/carbon/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		playsound(get_turf(target), hitsound, 100) // Play the hit sound
		if(istype(M, /mob/living/carbon))
			apply_arcane_mark(M)
	else
		return
