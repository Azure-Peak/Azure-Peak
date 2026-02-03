//shotgun spell. big dmg if all 3 hit. very good vs light or no armor; not so much vs plate...
//low accuracy bc 3 of them, literally codersprited

/obj/effect/proc_holder/spell/invoked/projectile/shrapnelbloom
	name = "Stygian Efflorescence"
	desc = "Burst forth a triad of sharpened onyxian shards, cut from Mount Golgotha herself. Strips away a fully-stacked Arcane Mark to deal extra damage."
	range = 7 //no reason to not
	projectile_type = /obj/projectile/energy/shrapnelbloom
	projectiles_per_fire = 3
	overlay_state = "stygian"
	sound = list('sound/magic/scrapeblade.ogg') //todo: this is Bad
	active = FALSE
	releasedrain = 30
	chargedrain = 1
	chargetime = 0
	recharge_time = 15 SECONDS //this shit very strong actually
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	invocations = list("Golgotha shraptae!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	cost = 3

/obj/projectile/energy/shrapnelbloom
	name = "stygian harpe"
	range = 3
	accuracy = 50
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "stygian"
	damage = 30
	woundclass = BCLASS_STAB
	armor_penetration = 20
	npc_simple_damage_mult = 1.5
	speed = 2
	ricochets_max = 4
	ricochet_chance = 50
	ricochet_auto_aim_angle = 40
	ricochet_auto_aim_range = 5
	ricochet_incidence_leeway = 50
	hitsound = 'sound/foley/glass_step.ogg'

/obj/projectile/energy/shrapnelbloom/on_hit(target) //no antimagic;
	var/mob/living/carbon/M
	if(istype(target, /mob/living/carbon))
		M = target
		var/datum/status_effect/debuff/arcanemark/mark = M.has_status_effect(/datum/status_effect/debuff/arcanemark)
		if(mark && mark.stacks >= mark.max_stacks)
			consume_arcane_mark_stacks(M)
			damage = 75
			to_chat(M, "<span class='userdanger'>STYGIAN WORLD-ECHO; TRYPTICH-MARKE DETONATION!</span>")

	. = ..()

/obj/effect/proc_holder/spell/invoked/projectile/shrapnelbloom/ready_projectile(obj/projectile/P, atom/target, mob/user, iteration) //dude this is all copy-paste guessed from other servers and ai slop. if this shit works id be so surprised
	var/base_angle = P.Angle
	if(isnull(base_angle))
		base_angle = Get_Angle(user, target)
	var/spread_step = 20
	var/center_index = (projectiles_per_fire + 1) / 2
	P.Angle = base_angle + ((iteration - center_index) * spread_step)
